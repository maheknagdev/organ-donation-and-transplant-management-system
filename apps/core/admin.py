from django.contrib import admin
from .models import (
    Donor, Recipient, Organ, OrganType, Hospital, MedicalStaff,
    Surgery, FollowUpAppointment, Medication, User,
    CompatibilityTest, OrganAllocation, RecipientWaitlist,
    DonorEmergencyContact, RecipientEmergencyContact,
    HospitalCapabilities, RecipientMedication, SurgeryPerformedBy
)


@admin.register(OrganType)
class OrganTypeAdmin(admin.ModelAdmin):
    list_display = ['type_name', 'typical_viability_hours', 'cold_ischemia_time_max', 'description']
    search_fields = ['type_name', 'description']


@admin.register(Donor)
class DonorAdmin(admin.ModelAdmin):
    list_display = ['donor_id', 'name', 'blood_type', 'donor_type', 'status', 'registration_date']
    list_filter = ['blood_type', 'donor_type', 'status', 'gender']
    search_fields = ['name', 'donor_id']
    date_hierarchy = 'registration_date'
    ordering = ['-registration_date']


@admin.register(Recipient)
class RecipientAdmin(admin.ModelAdmin):
    list_display = ['recipient_id', 'name', 'blood_type', 'medical_urgency_level', 'status', 'registration_date']
    list_filter = ['blood_type', 'status', 'medical_urgency_level', 'gender']
    search_fields = ['name', 'recipient_id']
    date_hierarchy = 'registration_date'
    ordering = ['-medical_urgency_level', '-registration_date']


@admin.register(Hospital)
class HospitalAdmin(admin.ModelAdmin):
    list_display = ['hospital_id', 'name', 'city', 'state', 'trauma_level', 'phone']
    list_filter = ['state', 'trauma_level', 'city']
    search_fields = ['name', 'city', 'state', 'phone']
    ordering = ['state', 'city', 'name']


@admin.register(MedicalStaff)
class MedicalStaffAdmin(admin.ModelAdmin):
    list_display = ['staff_id', 'name', 'specialization', 'hospital', 'license_number', 'email', 'phone']
    list_filter = ['specialization', 'hospital']
    search_fields = ['name', 'license_number', 'email']
    ordering = ['name']


@admin.register(Organ)
class OrganAdmin(admin.ModelAdmin):
    list_display = ['organ_id', 'type_name', 'donor', 'donor_blood_type', 'status', 'procurement_date', 'procurement_time']
    list_filter = ['type_name', 'status', 'procurement_date']
    search_fields = ['organ_id', 'donor__name']
    date_hierarchy = 'procurement_date'
    ordering = ['-procurement_date', '-procurement_time']
    
    def donor_blood_type(self, obj):
        return obj.donor.blood_type if obj.donor else '-'
    donor_blood_type.short_description = 'Blood Type'


@admin.register(Surgery)
class SurgeryAdmin(admin.ModelAdmin):
    list_display = ['surgery_id', 'recipient', 'organ', 'hospital', 'primary_surgeon', 'surgery_date', 'outcome', 'duration_hours']
    list_filter = ['outcome', 'surgery_date', 'hospital']
    search_fields = ['surgery_id', 'recipient__name', 'organ__organ_id']
    date_hierarchy = 'surgery_date'
    ordering = ['-surgery_date']


@admin.register(FollowUpAppointment)
class FollowUpAppointmentAdmin(admin.ModelAdmin):
    list_display = ['appointment_id', 'recipient', 'surgery', 'staff', 'appointment_date', 'appointment_time', 'medication_adherence']
    list_filter = ['appointment_date', 'medication_adherence']
    search_fields = ['recipient__name', 'appointment_id']
    date_hierarchy = 'appointment_date'
    ordering = ['-appointment_date', '-appointment_time']


@admin.register(Medication)
class MedicationAdmin(admin.ModelAdmin):
    list_display = ['medication_id', 'name', 'dosage_form', 'typical_dosage', 'purpose', 'manufacturer']
    list_filter = ['dosage_form', 'manufacturer']
    search_fields = ['name', 'manufacturer', 'purpose']
    ordering = ['name']


@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    list_display = ['user_id', 'username', 'email', 'role', 'account_status', 'created_date', 'last_login']
    list_filter = ['role', 'account_status', 'created_date']
    search_fields = ['username', 'email']
    date_hierarchy = 'created_date'
    ordering = ['-created_date']


@admin.register(RecipientWaitlist)
class RecipientWaitlistAdmin(admin.ModelAdmin):
    list_display = ['recipient', 'type_name', 'priority_score', 'wait_list_date', 'status', 'meld_score', 'cpra_score']
    list_filter = ['type_name', 'status', 'wait_list_date']
    search_fields = ['recipient__name']
    date_hierarchy = 'wait_list_date'
    ordering = ['-priority_score', 'wait_list_date']


@admin.register(OrganAllocation)
class OrganAllocationAdmin(admin.ModelAdmin):
    list_display = ['allocation_id', 'organ', 'recipient', 'allocation_date', 'match_score', 'status', 'response_deadline']
    list_filter = ['status', 'allocation_date']
    search_fields = ['allocation_id', 'recipient__name', 'organ__organ_id']
    date_hierarchy = 'allocation_date'
    ordering = ['-allocation_date']


@admin.register(CompatibilityTest)
class CompatibilityTestAdmin(admin.ModelAdmin):
    list_display = ['test_id', 'donor', 'recipient', 'test_type', 'test_date', 'test_result', 'compatibility_score']
    list_filter = ['test_result', 'test_type', 'test_date']
    search_fields = ['donor__name', 'recipient__name']
    date_hierarchy = 'test_date'
    ordering = ['-test_date']


@admin.register(DonorEmergencyContact)
class DonorEmergencyContactAdmin(admin.ModelAdmin):
    list_display = ['donor', 'contact_number', 'name', 'relationship', 'phone']
    list_filter = ['relationship']
    search_fields = ['donor__name', 'name', 'phone']


@admin.register(RecipientEmergencyContact)
class RecipientEmergencyContactAdmin(admin.ModelAdmin):
    list_display = ['recipient', 'contact_number', 'name', 'relationship', 'phone']
    list_filter = ['relationship']
    search_fields = ['recipient__name', 'name', 'phone']


@admin.register(HospitalCapabilities)
class HospitalCapabilitiesAdmin(admin.ModelAdmin):
    list_display = ['hospital', 'type_name']
    list_filter = ['type_name', 'hospital']
    search_fields = ['hospital__name']


@admin.register(RecipientMedication)
class RecipientMedicationAdmin(admin.ModelAdmin):
    list_display = ['recipient', 'medication', 'start_date', 'end_date', 'dosage', 'frequency', 'prescribing_staff']
    list_filter = ['start_date', 'end_date', 'medication']
    search_fields = ['recipient__name', 'medication__name']
    date_hierarchy = 'start_date'
    ordering = ['-start_date']


@admin.register(SurgeryPerformedBy)
class SurgeryPerformedByAdmin(admin.ModelAdmin):
    list_display = ['surgery', 'staff', 'role', 'primary_surgeon', 'start_time', 'end_time']
    list_filter = ['role', 'primary_surgeon']
    search_fields = ['surgery__surgery_id', 'staff__name']