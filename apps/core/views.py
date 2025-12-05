from django.shortcuts import render, redirect, get_object_or_404
from django.contrib import messages
from django.contrib.auth.hashers import make_password, check_password
from django.db import connection
from datetime import datetime, date
from .models import (
    Donor, Recipient, Organ, OrganType, Hospital, MedicalStaff,
    Surgery, RecipientWaitlist, OrganAllocation, RecipientMedication,
    User, FollowUpAppointment, HospitalCapabilities
)
from .decorators import login_required_custom, role_required


# ==================== AUTHENTICATION ====================
def user_login(request):
    """Login using MySQL User table"""
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        
        try:
            user = User.objects.get(username=username)
            if user.account_status != 'Active':
                messages.error(request, 'Account is not active')
                return render(request, 'core/login.html')
                
            if user.password_hash == password or check_password(password, user.password_hash):
                request.session['user_id'] = user.user_id
                request.session['username'] = user.username
                request.session['role'] = user.role
                
                user.last_login = datetime.now()
                user.save()
                
                messages.success(request, f'Welcome back, {user.username}!')
                return redirect('core:dashboard')
            else:
                messages.error(request, 'Invalid password')
        except User.DoesNotExist:
            messages.error(request, 'User not found')
    
    return render(request, 'core/login.html')


def user_logout(request):
    """Logout user"""
    request.session.flush()
    messages.success(request, 'Logged out successfully')
    return redirect('core:login')


def user_register(request):
    """Register new user"""
    if request.method == 'POST':
        username = request.POST.get('username')
        email = request.POST.get('email')
        password = request.POST.get('password')
        role = request.POST.get('role')
        
        if User.objects.filter(username=username).exists():
            messages.error(request, 'Username already exists')
        elif User.objects.filter(email=email).exists():
            messages.error(request, 'Email already registered')
        else:
            User.objects.create(
                username=username,
                email=email,
                password_hash=make_password(password),
                role=role,
                account_status='Active',
                created_date=date.today()
            )
            messages.success(request, 'Registration successful! Please login.')
            return redirect('core:login')
    
    return render(request, 'core/register.html')


# ==================== DASHBOARD ====================
@login_required_custom
def dashboard(request):
    """Homepage dashboard - role-specific views"""
    user_role = request.session.get('role')
    user_id = request.session.get('user_id')
    
    # RECIPIENT gets personalized dashboard with ONLY their data
    if user_role == 'Recipient':
        try:
            recipient = Recipient.objects.get(user_id=user_id)
            
            my_waitlist = RecipientWaitlist.objects.filter(
                recipient=recipient, 
                status='Waiting'
            ).select_related('type_name')
            
            my_allocations = OrganAllocation.objects.filter(
                recipient=recipient, 
                status='Pending'
            ).select_related('organ', 'organ__type_name', 'organ__donor')
            
            my_surgeries = Surgery.objects.filter(
                recipient=recipient
            ).select_related('organ', 'hospital', 'primary_surgeon')
            
            context = {
                'user_id': user_id,
                'username': request.session.get('username'),
                'role': user_role,
                'my_recipient': recipient,
                'my_waitlist': my_waitlist,
                'my_allocations': my_allocations,
                'my_surgeries': my_surgeries,
                'total_available_organs': Organ.objects.filter(status='Available').count(),
                'organ_types': OrganType.objects.all(),
            }
            return render(request, 'core/recipient_dashboard.html', context)
            
        except Recipient.DoesNotExist:
            context = {
                'user_id': user_id,
                'username': request.session.get('username'),
                'role': user_role,
                'error': 'No recipient profile found. Please contact administrator.',
            }
            return render(request, 'core/recipient_dashboard.html', context)
    
    # STAFF/COORDINATOR/ADMIN get full system dashboard
    else:
        context = {
            'total_donors': Donor.objects.count(),
            'total_recipients': Recipient.objects.count(),
            'total_organs': Organ.objects.count(),
            'total_hospitals': Hospital.objects.count(),
            'available_organs': Organ.objects.filter(status='Available').count(),
            'waiting_recipients': Recipient.objects.filter(status='Waiting').count(),
            'organ_types': OrganType.objects.all(),
            'user_id': user_id,
            'username': request.session.get('username'),
            'role': user_role,
        }
        
        if user_role in ['Administrator', 'Medical_Staff', 'Coordinator']:
            context['total_staff'] = MedicalStaff.objects.count()
            context['total_surgeries'] = Surgery.objects.count()
            context['pending_allocations'] = OrganAllocation.objects.filter(status='Pending').count()
            context['active_waitlist'] = RecipientWaitlist.objects.filter(status='Waiting').count()
        
        return render(request, 'core/dashboard.html', context)


# ==================== ORGANS ====================
@login_required_custom
def available_organs(request):
    """All users can VIEW available organs"""
    organs = Organ.objects.filter(
        status__in=['Available', 'Allocated']
    ).select_related('donor', 'type_name').order_by('-procurement_date', '-procurement_time')
    
    organs_with_viability = []
    for organ in organs:
        procurement_datetime = datetime.combine(organ.procurement_date, organ.procurement_time)
        now = datetime.now()
        elapsed = now - procurement_datetime
        elapsed_hours = elapsed.total_seconds() / 3600
        max_viability = organ.type_name.typical_viability_hours
        remaining_hours = max_viability - elapsed_hours
        
        if remaining_hours < 0:
            viability_status = 'Expired'
            viability_class = 'expired'
        elif remaining_hours < 2:
            viability_status = 'Critical'
            viability_class = 'critical'
        elif remaining_hours <= 6:
            viability_status = 'Urgent'
            viability_class = 'urgent'
        else:
            viability_status = 'Normal'
            viability_class = 'normal'
        
        viability_percentage = (remaining_hours / max_viability * 100) if remaining_hours > 0 else 0
        
        organs_with_viability.append({
            'organ': organ,
            'remaining_hours': round(remaining_hours, 1),
            'max_hours': max_viability,
            'viability_status': viability_status,
            'viability_class': viability_class,
            'viability_percentage': round(viability_percentage, 1),
            'elapsed_hours': round(elapsed_hours, 1),
        })
    
    context = {
        'organs_with_viability': organs_with_viability,
        'total_available': len([o for o in organs_with_viability if o['organ'].status == 'Available']),
        'total_allocated': len([o for o in organs_with_viability if o['organ'].status == 'Allocated']),
    }
    return render(request, 'core/available_organs.html', context)


@login_required_custom
def available_organs_mysql_view(request):
    """All users can VIEW - uses MySQL view"""
    with connection.cursor() as cursor:
        cursor.execute("SELECT * FROM available_organs")
        columns = [col[0] for col in cursor.description]
        results = cursor.fetchall()
        organs = [dict(zip(columns, row)) for row in results]
    
    context = {'organs': organs}
    return render(request, 'core/available_organs_view.html', context)


@login_required_custom
@role_required('Medical_Staff', 'Administrator')
def check_organ_viability(request, organ_id):
    """Medical staff and admin only - Call CheckOrganViability procedure"""
    organ = get_object_or_404(Organ, organ_id=organ_id)
    viability_data = None
    
    with connection.cursor() as cursor:
        try:
            cursor.callproc('CheckOrganViability', [organ_id])
            columns = [col[0] for col in cursor.description]
            result = cursor.fetchone()
            viability_data = dict(zip(columns, result)) if result else None
            
            while cursor.nextset():
                cursor.fetchall()
                
        except Exception as e:
            messages.error(request, f'Error: {str(e)}')
    
    context = {
        'organ': organ,
        'viability_data': viability_data,
    }
    return render(request, 'core/organ_viability.html', context)


@login_required_custom
@role_required('Medical_Staff', 'Administrator')
def match_organ(request, organ_id):
    """Medical staff and admin only - Call MatchOrganToRecipients procedure
    CONSTRAINT: Only for non-expired organs"""
    organ = get_object_or_404(Organ, organ_id=organ_id)
    
    if organ.status == 'Expired':
        messages.error(request, 'Cannot match expired organ')
        return redirect('core:available_organs')
    
    matches = []
    
    with connection.cursor() as cursor:
        try:
            cursor.callproc('MatchOrganToRecipients', [organ_id])
            columns = [col[0] for col in cursor.description]
            results = cursor.fetchall()
            
            if results and len(results) > 0:
                first_row = results[0]
                if columns[0] == 'Message' and isinstance(first_row[0], str) and 'Error' in first_row[0]:
                    messages.error(request, first_row[0])
                else:
                    matches = [dict(zip(columns, row)) for row in results]
            
            while cursor.nextset():
                cursor.fetchall()
                
        except Exception as e:
            messages.error(request, f'Error calling procedure: {str(e)}')
    
    context = {
        'organ': organ,
        'matches': matches,
        'match_count': len(matches),
    }
    return render(request, 'core/match_organ.html', context)


@login_required_custom
@role_required('Medical_Staff', 'Administrator')
def allocate_organ_page(request, organ_id):
    """Medical staff and admin only - Call AllocateOrgan procedure
    CONSTRAINT: Only for AVAILABLE organs"""
    organ = get_object_or_404(Organ, organ_id=organ_id)
    
    if organ.status != 'Available':
        messages.error(request, f'Cannot allocate organ. Current status: {organ.status}')
        return redirect('core:available_organs')
    
    procurement_datetime = datetime.combine(organ.procurement_date, organ.procurement_time)
    elapsed_hours = (datetime.now() - procurement_datetime).total_seconds() / 3600
    remaining_hours = organ.type_name.typical_viability_hours - elapsed_hours
    
    if remaining_hours <= 0:
        messages.error(request, 'Cannot allocate expired organ')
        return redirect('core:available_organs')
    
    if request.method == 'POST':
        recipient_id = request.POST.get('recipient_id')
        
        if not RecipientWaitlist.objects.filter(
            recipient_id=recipient_id,
            type_name=organ.type_name,
            status='Waiting'
        ).exists():
            messages.error(request, 'Recipient is not on waitlist for this organ type')
            return redirect('core:allocate_organ_page', organ_id=organ_id)
        
        allocation_result = None
        with connection.cursor() as cursor:
            try:
                cursor.callproc('AllocateOrgan', [organ_id, recipient_id])
                
                if cursor.description:
                    columns = [col[0] for col in cursor.description]
                    result = cursor.fetchone()
                    allocation_result = dict(zip(columns, result)) if result else None
                
                while True:
                    if not cursor.nextset():
                        break
                    if cursor.description:
                        cursor.fetchall()
                        
            except Exception as e:
                messages.error(request, f'Error during allocation: {str(e)}')
                allocation_result = None
        
        if allocation_result and 'Success' in str(allocation_result.get('Message', '')):
            messages.success(request, f"Organ allocated successfully! Allocation ID: {allocation_result.get('Allocation_ID')}")
            return redirect('core:allocation_list')
        else:
            error_msg = allocation_result.get('Message', 'Allocation failed') if allocation_result else 'Allocation failed'
            messages.error(request, error_msg)
    
    potential_recipients = []
    
    waitlist_entries = RecipientWaitlist.objects.filter(
        type_name=organ.type_name,
        status='Waiting',
        recipient__status='Waiting'
    ).select_related('recipient').order_by('-priority_score')[:10]
    
    for entry in waitlist_entries:
        donor_blood = organ.donor.blood_type
        recip_blood = entry.recipient.blood_type
        
        blood_score = 30 if donor_blood == recip_blood else 20
        wait_score = min((datetime.now().date() - entry.wait_list_date).days / 30, 20)
        urgency_score = entry.recipient.medical_urgency_level * 2
        total_score = blood_score + 15 + wait_score + 15 + urgency_score
        
        potential_recipients.append({
            'Recipient_ID': entry.recipient.recipient_id,
            'Recipient_Name': entry.recipient.name,
            'Recipient_Blood': entry.recipient.blood_type,
            'Medical_Urgency_Level': entry.recipient.medical_urgency_level,
            'Days_Waiting': (datetime.now().date() - entry.wait_list_date).days,
            'Total_Match_Score': round(total_score, 1),
        })
    
    potential_recipients.sort(key=lambda x: x['Total_Match_Score'], reverse=True)
    
    context = {
        'organ': organ,
        'potential_recipients': potential_recipients,
    }
    return render(request, 'core/allocate_organ.html', context)


@login_required_custom
@role_required('Medical_Staff', 'Administrator')
def create_organ(request):
    """Medical staff and admin only - Record organ procurement
    CONSTRAINTS: Donor must be Active/Deceased with medical clearance (enforced by trigger)"""
    if request.method == 'POST':
        donor_id = request.POST.get('donor_id')
        organ_type = request.POST.get('organ_type')
        procurement_date = request.POST.get('procurement_date')
        procurement_time = request.POST.get('procurement_time')
        hla_type = request.POST.get('hla_type')
        size_weight = request.POST.get('size_weight')
        
        proc_date = datetime.strptime(procurement_date, '%Y-%m-%d').date()
        if proc_date > date.today():
            messages.error(request, 'Procurement date cannot be in the future')
            return redirect('core:create_organ')
        
        try:
            Organ.objects.create(
                donor_id=donor_id,
                type_name_id=organ_type,
                procurement_date=procurement_date,
                procurement_time=procurement_time,
                hla_type=hla_type if hla_type else None,
                size_weight=size_weight if size_weight else None,
                status='Available'
            )
            messages.success(request, 'Organ recorded! Triggers fired: validation ✓, auto-matching ✓')
            return redirect('core:available_organs')
        except Exception as e:
            messages.error(request, f'Trigger validation failed: {str(e)}')
    
    context = {
        'donors': Donor.objects.filter(
            status__in=['Active', 'Deceased'],
            medical_clearance_date__isnull=False
        ).order_by('-registration_date'),
        'organ_types': OrganType.objects.all(),
    }
    return render(request, 'core/organ_form.html', context)


@login_required_custom
@role_required('Medical_Staff', 'Administrator')
def update_organ(request, organ_id):
    """Medical staff and admin only - Update organ status
    CONSTRAINT: Cannot change Transplanted to Available (enforced by trigger)"""
    organ = get_object_or_404(Organ, organ_id=organ_id)
    
    if request.method == 'POST':
        try:
            new_status = request.POST.get('status')
            
            if organ.status == 'Transplanted' and new_status != 'Transplanted':
                messages.error(request, 'Cannot change status of transplanted organ (protected by trigger)')
                return redirect('core:update_organ', organ_id=organ_id)
            
            organ.status = new_status
            organ.save()
            messages.success(request, 'Organ status updated!')
            return redirect('core:available_organs')
        except Exception as e:
            messages.error(request, f'Error: {str(e)}')
    
    context = {'organ': organ}
    return render(request, 'core/organ_update.html', context)


# ==================== DONORS ====================
@login_required_custom
@role_required('Medical_Staff', 'Coordinator', 'Administrator')
def donor_list(request):
    """Staff, coordinators, and admin can view donors
    Shows organ count for each donor"""
    donors = Donor.objects.prefetch_related('organ_set').all().order_by('-registration_date')
    context = {'donors': donors}
    return render(request, 'core/donor_list.html', context)


@login_required_custom
@role_required('Coordinator', 'Administrator')
def create_donor(request):
    """Coordinators and admin only - Register donor
    CONSTRAINTS: Deceased donors must have cause of death"""
    if request.method == 'POST':
        donor_type = request.POST.get('donor_type')
        cause_of_death = request.POST.get('cause_of_death')
        
        if donor_type == 'Deceased' and not cause_of_death:
            messages.error(request, 'Deceased donors must have a cause of death')
            return redirect('core:create_donor')
        
        if donor_type == 'Living' and cause_of_death:
            messages.warning(request, 'Living donor should not have cause of death - clearing field')
            cause_of_death = None
        
        Donor.objects.create(
            name=request.POST.get('name'),
            date_of_birth=request.POST.get('date_of_birth'),
            blood_type=request.POST.get('blood_type'),
            gender=request.POST.get('gender'),
            contact_info=request.POST.get('contact_info'),
            donor_type=donor_type,
            medical_history=request.POST.get('medical_history'),
            cause_of_death=cause_of_death,
            registration_date=request.POST.get('registration_date'),
            medical_clearance_date=request.POST.get('medical_clearance_date') if request.POST.get('medical_clearance_date') else None,
            status=request.POST.get('status')
        )
        messages.success(request, 'Donor registered successfully!')
        return redirect('core:donor_list')
    
    return render(request, 'core/donor_form.html')


@login_required_custom
@role_required('Coordinator', 'Administrator')
def update_donor(request, donor_id):
    """Coordinators and admin only - Update donor
    CONSTRAINT: Cannot delete if has active organs (enforced by trigger)"""
    donor = get_object_or_404(Donor, donor_id=donor_id)
    
    if request.method == 'POST':
        donor.status = request.POST.get('status')
        donor.contact_info = request.POST.get('contact_info')
        donor.medical_history = request.POST.get('medical_history')
        donor.save()
        messages.success(request, 'Donor updated successfully!')
        return redirect('core:donor_list')
    
    context = {'donor': donor}
    return render(request, 'core/donor_update.html', context)


# ==================== RECIPIENTS ====================
@login_required_custom
@role_required('Medical_Staff', 'Coordinator', 'Administrator')
def recipient_list(request):
    """Staff, coordinators, and admin can view all recipients"""
    recipients = Recipient.objects.all().order_by('-medical_urgency_level', '-registration_date')
    context = {'recipients': recipients}
    return render(request, 'core/recipient_list.html', context)


@login_required_custom
@role_required('Coordinator', 'Administrator')
def create_recipient(request):
    """Coordinators and admin only - Register recipient
    CONSTRAINTS: Urgency 1-5, valid blood type"""
    if request.method == 'POST':
        urgency = int(request.POST.get('medical_urgency_level'))
        
        if urgency < 1 or urgency > 5:
            messages.error(request, 'Medical urgency level must be between 1 and 5')
            return redirect('core:create_recipient')
        
        Recipient.objects.create(
            name=request.POST.get('name'),
            date_of_birth=request.POST.get('date_of_birth'),
            blood_type=request.POST.get('blood_type'),
            gender=request.POST.get('gender'),
            contact_info=request.POST.get('contact_info'),
            medical_history=request.POST.get('medical_history'),
            primary_diagnosis=request.POST.get('primary_diagnosis'),
            medical_urgency_level=urgency,
            registration_date=request.POST.get('registration_date'),
            status='Waiting',
            insurance_info=request.POST.get('insurance_info')
        )
        messages.success(request, 'Recipient registered successfully!')
        return redirect('core:recipient_list')
    
    return render(request, 'core/recipient_form.html')


@login_required_custom
@role_required('Medical_Staff', 'Coordinator', 'Administrator')
def update_recipient(request, recipient_id):
    """Staff, coordinators, and admin can update
    CONSTRAINT: Cannot manually set to Transplanted (only via surgery trigger)
    Triggers after_recipient_update if urgency changes"""
    recipient = get_object_or_404(Recipient, recipient_id=recipient_id)
    
    if request.method == 'POST':
        new_status = request.POST.get('status')
        new_urgency = int(request.POST.get('medical_urgency_level'))
        
        if new_urgency < 1 or new_urgency > 5:
            messages.error(request, 'Urgency level must be 1-5')
            return redirect('core:update_recipient', recipient_id=recipient_id)
        
        if new_status == 'Transplanted' and recipient.status != 'Transplanted':
            messages.error(request, 'Cannot manually set to Transplanted. Use surgery scheduling.')
            return redirect('core:update_recipient', recipient_id=recipient_id)
        
        old_urgency = recipient.medical_urgency_level
        recipient.medical_urgency_level = new_urgency
        recipient.status = new_status
        recipient.contact_info = request.POST.get('contact_info')
        recipient.insurance_info = request.POST.get('insurance_info')
        recipient.save()
        
        if old_urgency != new_urgency:
            messages.success(request, 'Recipient updated! Trigger auto-recalculated priority scores.')
        else:
            messages.success(request, 'Recipient updated successfully!')
        return redirect('core:recipient_list')
    
    context = {'recipient': recipient}
    return render(request, 'core/recipient_update.html', context)


@login_required_custom
def recipient_history(request, recipient_id):
    """Recipients can view their own, staff can view all"""
    user_role = request.session.get('role')
    user_id = request.session.get('user_id')
    
    recipient = get_object_or_404(Recipient, recipient_id=recipient_id)
    
    if user_role == 'Recipient':
        if not recipient.user or recipient.user.user_id != user_id:
            messages.error(request, 'You can only view your own history')
            return redirect('core:dashboard')
    
    surgeries = Surgery.objects.filter(recipient=recipient).select_related('organ', 'hospital', 'primary_surgeon')
    medications = RecipientMedication.objects.filter(recipient=recipient).select_related('medication', 'prescribing_staff')
    
    context = {
        'recipient': recipient,
        'surgeries': surgeries,
        'medications': medications,
    }
    return render(request, 'core/recipient_history.html', context)


@login_required_custom
@role_required('Medical_Staff', 'Coordinator', 'Administrator')
def critical_recipients(request):
    """Staff, coordinators, and admin only - Query critical_recipients MySQL VIEW"""
    with connection.cursor() as cursor:
        cursor.execute("SELECT * FROM critical_recipients")
        columns = [col[0] for col in cursor.description]
        results = cursor.fetchall()
        critical_patients = [dict(zip(columns, row)) for row in results]
    
    context = {'critical_patients': critical_patients}
    return render(request, 'core/critical_recipients.html', context)


# ==================== WAITLIST ====================
@login_required_custom
def waitlist(request):
    """All users can VIEW waitlist"""
    waitlist_entries = RecipientWaitlist.objects.filter(
        status='Waiting'
    ).select_related('recipient', 'type_name').order_by('-priority_score', 'wait_list_date')
    
    context = {'waitlist_entries': waitlist_entries}
    return render(request, 'core/waitlist.html', context)


@login_required_custom
def active_waitlist_mysql_view(request):
    """All users can VIEW - uses MySQL active_wait_list VIEW"""
    with connection.cursor() as cursor:
        cursor.execute("SELECT * FROM active_wait_list")
        columns = [col[0] for col in cursor.description]
        results = cursor.fetchall()
        waitlist = [dict(zip(columns, row)) for row in results]
    
    context = {'waitlist': waitlist}
    return render(request, 'core/active_waitlist_view.html', context)


@login_required_custom
@role_required('Coordinator', 'Administrator')
def add_to_waitlist(request):
    """Coordinators and admin only - Add to waitlist
    CONSTRAINTS: Recipient must be Waiting, no duplicates, no pending allocations"""
    if request.method == 'POST':
        recipient_id = request.POST.get('recipient_id')
        organ_type = request.POST.get('organ_type')
        wait_list_date = request.POST.get('wait_list_date')
        
        if RecipientWaitlist.objects.filter(
            recipient_id=recipient_id,
            type_name_id=organ_type
        ).exists():
            messages.error(request, 'Recipient is already on this waitlist')
            return redirect('core:add_to_waitlist')
        
        if OrganAllocation.objects.filter(
            recipient_id=recipient_id,
            organ__type_name_id=organ_type,
            status='Pending'
        ).exists():
            messages.error(request, 'Recipient has pending allocation for this organ type')
            return redirect('core:add_to_waitlist')
        
        RecipientWaitlist.objects.create(
            recipient_id=recipient_id,
            type_name_id=organ_type,
            wait_list_date=wait_list_date,
            status='Waiting',
            priority_score=0.00
        )
        messages.success(request, 'Recipient added to waitlist!')
        return redirect('core:waitlist')
    
    context = {
        'recipients': Recipient.objects.filter(status='Waiting'),
        'organ_types': OrganType.objects.all(),
    }
    return render(request, 'core/waitlist_form.html', context)


@login_required_custom
@role_required('Medical_Staff', 'Coordinator', 'Administrator')
def calculate_priority(request, recipient_id, organ_type):
    """Staff, coordinators, and admin - Call CalculatePriorityScore procedure"""
    priority_data = None
    
    with connection.cursor() as cursor:
        try:
            cursor.callproc('CalculatePriorityScore', [recipient_id, organ_type])
            columns = [col[0] for col in cursor.description]
            result = cursor.fetchone()
            priority_data = dict(zip(columns, result)) if result else None
            
            while cursor.nextset():
                cursor.fetchall()
                
        except Exception as e:
            messages.error(request, f'Error: {str(e)}')
    
    recipient = get_object_or_404(Recipient, recipient_id=recipient_id)
    
    context = {
        'recipient': recipient,
        'organ_type': organ_type,
        'priority_data': priority_data,
    }
    return render(request, 'core/priority_calculation.html', context)


@login_required_custom
@role_required('Coordinator', 'Administrator')
def remove_from_waitlist(request, recipient_id, organ_type):
    """Coordinators and admin only - Remove from waitlist
    CONSTRAINT: Cannot remove if has accepted allocation"""
    
    if OrganAllocation.objects.filter(
        recipient_id=recipient_id,
        organ__type_name_id=organ_type,
        status='Accepted'
    ).exists():
        messages.error(request, 'Cannot remove - recipient has accepted allocation for this organ type')
        return redirect('core:waitlist')
    
    waitlist_entry = get_object_or_404(
        RecipientWaitlist, 
        recipient_id=recipient_id, 
        type_name_id=organ_type
    )
    waitlist_entry.delete()
    messages.success(request, 'Recipient removed from waitlist!')
    return redirect('core:waitlist')


# ==================== ALLOCATIONS ====================
@login_required_custom
def allocation_list(request):
    """Recipients see their own, staff see all"""
    user_role = request.session.get('role')
    user_id = request.session.get('user_id')
    
    if user_role == 'Recipient':
        try:
            recipient = Recipient.objects.get(user_id=user_id)
            allocations = OrganAllocation.objects.filter(
                recipient=recipient
            ).select_related('organ', 'recipient', 'organ__donor').order_by('-allocation_date')
        except Recipient.DoesNotExist:
            allocations = OrganAllocation.objects.none()
    else:
        allocations = OrganAllocation.objects.select_related(
            'organ', 'recipient', 'organ__donor'
        ).order_by('-allocation_date')
    
    context = {'allocations': allocations}
    return render(request, 'core/allocation_list.html', context)


@login_required_custom
def respond_to_allocation(request, allocation_id):
    """Recipients respond to own, staff can respond to any
    CONSTRAINTS: Only Pending allocations, deadline not passed, recipient still Waiting"""
    user_role = request.session.get('role')
    user_id = request.session.get('user_id')
    
    allocation = get_object_or_404(OrganAllocation, allocation_id=allocation_id)
    
    if allocation.status != 'Pending':
        messages.error(request, f'Cannot respond - allocation is already {allocation.status}')
        return redirect('core:allocation_list')
    
    if allocation.response_deadline and datetime.now() > allocation.response_deadline.replace(tzinfo=None):
        messages.error(request, 'Response deadline has passed')
        allocation.status = 'Expired'
        allocation.save()
        return redirect('core:allocation_list')
    
    if allocation.recipient.status != 'Waiting':
        messages.error(request, f'Recipient status is {allocation.recipient.status}, cannot respond')
        return redirect('core:allocation_list')
    
    if user_role == 'Recipient':
        if not allocation.recipient.user or allocation.recipient.user.user_id != user_id:
            messages.error(request, 'You can only respond to your own allocations')
            return redirect('core:allocation_list')
    
    if request.method == 'POST':
        response = request.POST.get('response')
        allocation.status = response
        allocation.save()
        
        if response == 'Rejected':
            organ = allocation.organ
            organ.status = 'Available'
            organ.save()
            messages.success(request, 'Allocation rejected. Organ is available again.')
        else:
            messages.success(request, f'Allocation {response}!')
        
        return redirect('core:allocation_list')
    
    context = {'allocation': allocation}
    return render(request, 'core/allocation_respond.html', context)


# ==================== SURGERY ====================
@login_required_custom
@role_required('Medical_Staff', 'Administrator')
def surgery_list(request):
    """Medical staff and admin only"""
    surgeries = Surgery.objects.select_related(
        'recipient', 'organ', 'hospital', 'primary_surgeon'
    ).order_by('-surgery_date')
    
    context = {'surgeries': surgeries}
    return render(request, 'core/surgery_list.html', context)


@login_required_custom
@role_required('Medical_Staff', 'Administrator')
def create_surgery(request):
    """Medical staff and admin only - Schedule surgery
    CONSTRAINTS: Only allocated organs with accepted allocations"""
    if request.method == 'POST':
        organ_recipient = request.POST.get('organ_recipient')
        hospital_id = request.POST.get('hospital_id')
        surgeon_id = request.POST.get('surgeon_id')
        surgery_date = request.POST.get('surgery_date')
        surgery_time = request.POST.get('surgery_time')
        duration_hours = request.POST.get('duration_hours')
        notes = request.POST.get('notes')
        
        if not organ_recipient:
            messages.error(request, 'Please select an organ-recipient pair')
            return redirect('core:create_surgery')
        
        organ_id, recipient_id = organ_recipient.split('_')
        
        try:
            organ = Organ.objects.select_related('type_name').get(organ_id=organ_id)
        except Organ.DoesNotExist:
            messages.error(request, 'Organ not found')
            return redirect('core:create_surgery')
        
        if organ.status != 'Allocated':
            messages.error(request, f'Organ must be Allocated. Current status: {organ.status}')
            return redirect('core:create_surgery')
        
        if not HospitalCapabilities.objects.filter(
            hospital_id=hospital_id,
            type_name=organ.type_name
        ).exists():
            messages.error(request, 'Selected hospital cannot perform this organ type transplant')
            return redirect('core:create_surgery')
        
        try:
            surgeon = MedicalStaff.objects.get(staff_id=surgeon_id)
            if str(surgeon.hospital_id) != str(hospital_id):
                messages.error(request, 'Surgeon is not affiliated with selected hospital')
                return redirect('core:create_surgery')
        except MedicalStaff.DoesNotExist:
            messages.error(request, 'Surgeon not found')
            return redirect('core:create_surgery')
        
        if not OrganAllocation.objects.filter(
            organ_id=organ_id,
            recipient_id=recipient_id,
            status='Accepted'
        ).exists():
            messages.error(request, 'No accepted allocation found for this organ-recipient pair')
            return redirect('core:create_surgery')
        
        surg_date = datetime.strptime(surgery_date, '%Y-%m-%d').date()
        if surg_date < date.today():
            messages.error(request, 'Surgery date cannot be in the past')
            return redirect('core:create_surgery')
        
        try:
            Surgery.objects.create(
                hospital_id=hospital_id,
                organ_id=organ_id,
                recipient_id=recipient_id,
                primary_surgeon_id=surgeon_id,
                surgery_date=surgery_date,
                surgery_time=surgery_time,
                duration_hours=duration_hours,
                outcome='Success',
                notes=notes
            )
            messages.success(request, '🎉 Surgery scheduled! Trigger fired and completed 5 automatic actions!')
            return redirect('core:surgery_list')
        except Exception as e:
            messages.error(request, f'Error creating surgery: {str(e)}')
    
    organ_recipient_pairs = []
    
    accepted_allocations = OrganAllocation.objects.filter(
        status='Accepted',
        organ__status='Allocated'
    ).select_related('organ', 'organ__donor', 'organ__type_name', 'recipient')
    
    for alloc in accepted_allocations:
        organ_recipient_pairs.append({
            'organ': alloc.organ,
            'recipient': alloc.recipient,
        })
    
    context = {
        'hospitals': Hospital.objects.all(),
        'organ_recipient_pairs': organ_recipient_pairs,
        'surgeons': MedicalStaff.objects.filter(
            specialization='Transplant_Surgeon'
        ).select_related('hospital').order_by('hospital__name', 'name'),
        'today': date.today().strftime('%Y-%m-%d'),
    }
    return render(request, 'core/surgery_form.html', context)


@login_required_custom
@role_required('Medical_Staff', 'Coordinator', 'Administrator')
def upcoming_followups(request):
    """Staff, coordinators, and admin - Query upcoming_follow_ups MySQL VIEW"""
    with connection.cursor() as cursor:
        cursor.execute("SELECT * FROM upcoming_follow_ups")
        columns = [col[0] for col in cursor.description]
        results = cursor.fetchall()
        followups = [dict(zip(columns, row)) for row in results]
    
    context = {'followups': followups}
    return render(request, 'core/upcoming_followups.html', context)


# ==================== REPORTS ====================
@login_required_custom
@role_required('Medical_Staff', 'Coordinator', 'Administrator')
def hospital_performance(request):
    """Staff, coordinators, and admin - Query transplant_success_rate_by_hospital VIEW"""
    with connection.cursor() as cursor:
        cursor.execute("SELECT * FROM transplant_success_rate_by_hospital")
        columns = [col[0] for col in cursor.description]
        results = cursor.fetchall()
        hospitals = [dict(zip(columns, row)) for row in results]
    
    context = {'hospitals': hospitals}
    return render(request, 'core/hospital_performance.html', context)


@login_required_custom
@role_required('Medical_Staff', 'Coordinator', 'Administrator')
def waiting_time_analysis(request):
    """Staff, coordinators, and admin - Complex query with CalculateWaitTimeDays function"""
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT 
                ot.Type_Name as Organ_Type,
                r.Blood_Type,
                AVG(CalculateWaitTimeDays(r.Recipient_ID, ot.Type_Name)) as Avg_Wait_Days,
                COUNT(*) as Recipient_Count,
                MIN(CalculateWaitTimeDays(r.Recipient_ID, ot.Type_Name)) as Min_Wait_Days,
                MAX(CalculateWaitTimeDays(r.Recipient_ID, ot.Type_Name)) as Max_Wait_Days
            FROM Recipient r
            JOIN Recipient_Waitlist rw ON r.Recipient_ID = rw.Recipient_ID
            JOIN Organ_Type ot ON rw.Type_Name = ot.Type_Name
            WHERE r.Status = 'Waiting' AND rw.Status = 'Waiting'
            GROUP BY ot.Type_Name, r.Blood_Type
            ORDER BY Avg_Wait_Days DESC
        """)
        columns = [col[0] for col in cursor.description]
        results = cursor.fetchall()
        wait_times = [dict(zip(columns, row)) for row in results]
    
    context = {'wait_times': wait_times}
    return render(request, 'core/waiting_time_analysis.html', context)