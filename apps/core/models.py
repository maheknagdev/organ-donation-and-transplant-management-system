from django.db import models


class CompatibilityTest(models.Model):
    test_id = models.AutoField(db_column='Test_ID', primary_key=True)
    donor = models.ForeignKey('Donor', models.DO_NOTHING, db_column='Donor_ID')
    recipient = models.ForeignKey('Recipient', models.DO_NOTHING, db_column='Recipient_ID')
    test_type = models.CharField(db_column='Test_Type', max_length=50)
    test_date = models.DateField(db_column='Test_Date')
    test_result = models.CharField(db_column='Test_Result', max_length=20)
    compatibility_score = models.DecimalField(db_column='Compatibility_Score', max_digits=5, decimal_places=2, blank=True, null=True)
    performed_by_staff = models.ForeignKey('MedicalStaff', models.DO_NOTHING, db_column='Performed_By_Staff_ID', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'compatibility_test'


class Donor(models.Model):
    donor_id = models.AutoField(db_column='Donor_ID', primary_key=True)
    name = models.CharField(db_column='Name', max_length=100)
    date_of_birth = models.DateField(db_column='Date_of_Birth')
    blood_type = models.CharField(db_column='Blood_Type', max_length=3)
    gender = models.CharField(db_column='Gender', max_length=5, blank=True, null=True)
    contact_info = models.CharField(db_column='Contact_Info', max_length=255, blank=True, null=True)
    donor_type = models.CharField(db_column='Donor_Type', max_length=8)
    medical_history = models.CharField(db_column='Medical_History', max_length=256, blank=True, null=True)
    cause_of_death = models.CharField(db_column='Cause_of_Death', max_length=255, blank=True, null=True)
    registration_date = models.DateField(db_column='Registration_Date')
    medical_clearance_date = models.DateField(db_column='Medical_Clearance_Date', blank=True, null=True)
    status = models.CharField(db_column='Status', max_length=8, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'donor'


class DonorEmergencyContact(models.Model):
    donor = models.ForeignKey(Donor, models.DO_NOTHING, db_column='Donor_ID', primary_key=True)
    contact_number = models.IntegerField(db_column='Contact_Number')
    name = models.CharField(db_column='Name', max_length=100)
    relationship = models.CharField(db_column='Relationship', max_length=50, blank=True, null=True)
    phone = models.CharField(db_column='Phone', max_length=20)
    alternate_phone = models.CharField(db_column='Alternate_Phone', max_length=20, blank=True, null=True)
    address = models.CharField(db_column='Address', max_length=255, blank=True, null=True)
    street_number = models.CharField(db_column='Street_number', max_length=20, blank=True, null=True)
    street_name = models.CharField(db_column='Street_name', max_length=100, blank=True, null=True)
    city = models.CharField(db_column='City', max_length=100, blank=True, null=True)
    state = models.CharField(db_column='State', max_length=50, blank=True, null=True)
    zipcode = models.CharField(db_column='Zipcode', max_length=10, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'donor_emergency_contact'
        unique_together = (('donor', 'contact_number'),)


class FollowUpAppointment(models.Model):
    appointment_id = models.AutoField(db_column='Appointment_ID', primary_key=True)
    surgery = models.ForeignKey('Surgery', models.DO_NOTHING, db_column='Surgery_ID')
    recipient = models.ForeignKey('Recipient', models.DO_NOTHING, db_column='Recipient_ID')
    staff = models.ForeignKey('MedicalStaff', models.DO_NOTHING, db_column='Staff_ID')
    appointment_date = models.DateField(db_column='Appointment_Date')
    appointment_time = models.TimeField(db_column='Appointment_Time', blank=True, null=True)
    rejection_indicators = models.CharField(db_column='Rejection_Indicators', max_length=255, blank=True, null=True)
    lab_results = models.CharField(db_column='Lab_Results', max_length=256, blank=True, null=True)
    medication_adherence = models.CharField(db_column='Medication_Adherence', max_length=50, blank=True, null=True)
    notes = models.CharField(db_column='Notes', max_length=256, blank=True, null=True)
    next_appointment_date = models.DateField(db_column='Next_Appointment_Date', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'follow_up_appointment'


class Hospital(models.Model):
    hospital_id = models.AutoField(db_column='Hospital_ID', primary_key=True)
    name = models.CharField(db_column='Name', max_length=150)
    address = models.CharField(db_column='Address', max_length=255, blank=True, null=True)
    street_number = models.CharField(db_column='Street_number', max_length=20, blank=True, null=True)
    street_name = models.CharField(db_column='Street_name', max_length=100, blank=True, null=True)
    city = models.CharField(db_column='City', max_length=100, blank=True, null=True)
    state = models.CharField(db_column='State', max_length=50, blank=True, null=True)
    zipcode = models.CharField(db_column='Zipcode', max_length=10, blank=True, null=True)
    phone = models.CharField(db_column='Phone', max_length=20, blank=True, null=True)
    trauma_level = models.IntegerField(db_column='Trauma_Level', blank=True, null=True)
    opo_affiliation = models.CharField(db_column='OPO_Affiliation', max_length=100, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'hospital'


class HospitalCapabilities(models.Model):
    hospital = models.ForeignKey(Hospital, models.DO_NOTHING, db_column='Hospital_ID', primary_key=True)
    type_name = models.ForeignKey('OrganType', models.DO_NOTHING, db_column='Type_Name')

    class Meta:
        managed = False
        db_table = 'hospital_capabilities'
        unique_together = (('hospital', 'type_name'),)


class MedicalStaff(models.Model):
    staff_id = models.AutoField(db_column='Staff_ID', primary_key=True)
    hospital = models.ForeignKey(Hospital, models.DO_NOTHING, db_column='Hospital_ID', blank=True, null=True)
    name = models.CharField(db_column='Name', max_length=100)
    specialization = models.CharField(db_column='Specialization', max_length=18)
    license_number = models.CharField(db_column='License_Number', unique=True, max_length=50, blank=True, null=True)
    certification_date = models.DateField(db_column='Certification_Date', blank=True, null=True)
    certification_level = models.CharField(db_column='Certification_Level', max_length=50, blank=True, null=True)
    phone = models.CharField(db_column='Phone', max_length=20, blank=True, null=True)
    email = models.CharField(db_column='Email', max_length=100, blank=True, null=True)
    user = models.OneToOneField('User', models.DO_NOTHING, db_column='User_ID', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'medical_staff'


class Medication(models.Model):
    medication_id = models.AutoField(db_column='Medication_ID', primary_key=True)
    name = models.CharField(db_column='Name', max_length=100)
    dosage_form = models.CharField(db_column='Dosage_Form', max_length=50, blank=True, null=True)
    typical_dosage = models.CharField(db_column='Typical_Dosage', max_length=50, blank=True, null=True)
    purpose = models.CharField(db_column='Purpose', max_length=100, blank=True, null=True)
    side_effects = models.CharField(db_column='Side_Effects', max_length=256, blank=True, null=True)
    manufacturer = models.CharField(db_column='Manufacturer', max_length=100, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'medication'


class Organ(models.Model):
    organ_id = models.AutoField(db_column='Organ_ID', primary_key=True)
    type_name = models.ForeignKey('OrganType', models.DO_NOTHING, db_column='Type_Name')
    donor = models.ForeignKey(Donor, models.DO_NOTHING, db_column='Donor_ID')
    hla_type = models.CharField(db_column='HLA_Type', max_length=50, blank=True, null=True)
    procurement_date = models.DateField(db_column='Procurement_Date')
    procurement_time = models.TimeField(db_column='Procurement_Time')
    size_weight = models.DecimalField(db_column='Size_Weight', max_digits=10, decimal_places=2, blank=True, null=True)
    status = models.CharField(db_column='Status', max_length=12, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'organ'


class OrganAllocation(models.Model):
    allocation_id = models.AutoField(db_column='Allocation_ID', primary_key=True)
    organ = models.ForeignKey(Organ, models.DO_NOTHING, db_column='Organ_ID')
    recipient = models.ForeignKey('Recipient', models.DO_NOTHING, db_column='Recipient_ID')
    allocation_date = models.DateTimeField(db_column='Allocation_Date')
    match_score = models.DecimalField(db_column='Match_Score', max_digits=5, decimal_places=2, blank=True, null=True)
    status = models.CharField(db_column='Status', max_length=20, blank=True, null=True)
    response_deadline = models.DateTimeField(db_column='Response_Deadline', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'organ_allocation'


class OrganType(models.Model):
    type_name = models.CharField(db_column='Type_Name', primary_key=True, max_length=30)
    typical_viability_hours = models.IntegerField(db_column='Typical_Viability_Hours')
    cold_ischemia_time_max = models.IntegerField(db_column='Cold_Ischemia_Time_Max')
    description = models.CharField(db_column='Description', max_length=256, blank=True, null=True)
    special_requirements = models.CharField(db_column='Special_Requirements', max_length=256, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'organ_type'


class Recipient(models.Model):
    recipient_id = models.AutoField(db_column='Recipient_ID', primary_key=True)
    name = models.CharField(db_column='Name', max_length=100)
    date_of_birth = models.DateField(db_column='Date_of_Birth')
    blood_type = models.CharField(db_column='Blood_Type', max_length=3)
    gender = models.CharField(db_column='Gender', max_length=5, blank=True, null=True)
    contact_info = models.CharField(db_column='Contact_Info', max_length=255, blank=True, null=True)
    medical_history = models.CharField(db_column='Medical_History', max_length=256, blank=True, null=True)
    primary_diagnosis = models.CharField(db_column='Primary_Diagnosis', max_length=255, blank=True, null=True)
    medical_urgency_level = models.IntegerField(db_column='Medical_Urgency_Level', blank=True, null=True)
    registration_date = models.DateField(db_column='Registration_Date')
    status = models.CharField(db_column='Status', max_length=12, blank=True, null=True)
    insurance_info = models.CharField(db_column='Insurance_Info', max_length=255, blank=True, null=True)
    user = models.OneToOneField('User', models.DO_NOTHING, db_column='User_ID', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'recipient'


class RecipientEmergencyContact(models.Model):
    recipient = models.ForeignKey(Recipient, models.DO_NOTHING, db_column='Recipient_ID', primary_key=True)
    contact_number = models.IntegerField(db_column='Contact_Number')
    name = models.CharField(db_column='Name', max_length=100)
    relationship = models.CharField(db_column='Relationship', max_length=50, blank=True, null=True)
    phone = models.CharField(db_column='Phone', max_length=20)
    alternate_phone = models.CharField(db_column='Alternate_Phone', max_length=20, blank=True, null=True)
    address = models.CharField(db_column='Address', max_length=255, blank=True, null=True)
    street_number = models.CharField(db_column='Street_number', max_length=20, blank=True, null=True)
    street_name = models.CharField(db_column='Street_name', max_length=100, blank=True, null=True)
    city = models.CharField(db_column='City', max_length=100, blank=True, null=True)
    state = models.CharField(db_column='State', max_length=50, blank=True, null=True)
    zipcode = models.CharField(db_column='Zipcode', max_length=10, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'recipient_emergency_contact'
        unique_together = (('recipient', 'contact_number'),)


class RecipientMedication(models.Model):
    recipient = models.ForeignKey(Recipient, models.DO_NOTHING, db_column='Recipient_ID', primary_key=True)
    medication = models.ForeignKey(Medication, models.DO_NOTHING, db_column='Medication_ID')
    start_date = models.DateField(db_column='Start_Date')
    end_date = models.DateField(db_column='End_Date', blank=True, null=True)
    dosage = models.CharField(db_column='Dosage', max_length=50)
    frequency = models.CharField(db_column='Frequency', max_length=50)
    prescribing_staff = models.ForeignKey(MedicalStaff, models.DO_NOTHING, db_column='Prescribing_Staff_ID', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'recipient_medication'
        unique_together = (('recipient', 'medication', 'start_date'),)


class RecipientWaitlist(models.Model):
    recipient = models.ForeignKey(Recipient, models.DO_NOTHING, db_column='Recipient_ID', primary_key=True)
    type_name = models.ForeignKey(OrganType, models.DO_NOTHING, db_column='Type_Name')
    priority_score = models.DecimalField(db_column='Priority_Score', max_digits=5, decimal_places=2, blank=True, null=True)
    wait_list_date = models.DateField(db_column='Wait_List_Date')
    status = models.CharField(db_column='Status', max_length=20, blank=True, null=True)
    meld_score = models.DecimalField(db_column='MELD_Score', max_digits=5, decimal_places=2, blank=True, null=True)
    cpra_score = models.DecimalField(db_column='CPRA_Score', max_digits=5, decimal_places=2, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'recipient_waitlist'
        unique_together = (('recipient', 'type_name'),)


class Surgery(models.Model):
    surgery_id = models.AutoField(db_column='Surgery_ID', primary_key=True)
    hospital = models.ForeignKey(Hospital, models.DO_NOTHING, db_column='Hospital_ID')
    organ = models.OneToOneField(Organ, models.DO_NOTHING, db_column='Organ_ID')
    recipient = models.ForeignKey(Recipient, models.DO_NOTHING, db_column='Recipient_ID')
    primary_surgeon = models.ForeignKey(MedicalStaff, models.DO_NOTHING, db_column='Primary_Surgeon_ID')
    surgery_date = models.DateField(db_column='Surgery_Date')
    surgery_time = models.TimeField(db_column='Surgery_Time', blank=True, null=True)
    duration_hours = models.DecimalField(db_column='Duration_Hours', max_digits=4, decimal_places=2, blank=True, null=True)
    outcome = models.CharField(db_column='Outcome', max_length=13, blank=True, null=True)
    notes = models.CharField(db_column='Notes', max_length=256, blank=True, null=True)
    complications_description = models.CharField(db_column='Complications_Description', max_length=256, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'surgery'


class SurgeryPerformedBy(models.Model):
    surgery = models.ForeignKey(Surgery, models.DO_NOTHING, db_column='Surgery_ID', primary_key=True)
    staff = models.ForeignKey(MedicalStaff, models.DO_NOTHING, db_column='Staff_ID')
    role = models.CharField(db_column='Role', max_length=50)
    start_time = models.DateTimeField(db_column='Start_Time', blank=True, null=True)
    end_time = models.DateTimeField(db_column='End_Time', blank=True, null=True)
    primary_surgeon = models.IntegerField(db_column='Primary_Surgeon', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'surgery_performed_by'
        unique_together = (('surgery', 'staff'),)


class User(models.Model):
    user_id = models.AutoField(db_column='User_ID', primary_key=True)
    username = models.CharField(db_column='Username', unique=True, max_length=50)
    password_hash = models.CharField(db_column='Password_Hash', max_length=255)
    email = models.CharField(db_column='Email', unique=True, max_length=100)
    role = models.CharField(db_column='Role', max_length=13)
    account_status = models.CharField(db_column='Account_Status', max_length=9, blank=True, null=True)
    created_date = models.DateField(db_column='Created_Date')
    last_login = models.DateTimeField(db_column='Last_Login', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'user'