-- =====================================================
-- FIXED: MySQL Views with Correct Naming
-- =====================================================

USE organ_donation_db;

-- Drop any existing views
DROP VIEW IF EXISTS active_wait_list;
DROP VIEW IF EXISTS available_organs;
DROP VIEW IF EXISTS transplant_success_rate_by_hospital;
DROP VIEW IF EXISTS critical_recipients;
DROP VIEW IF EXISTS upcoming_follow_ups;

-- Also drop uppercase versions if they exist
DROP VIEW IF EXISTS Active_Wait_List;
DROP VIEW IF EXISTS Available_Organs;
DROP VIEW IF EXISTS Transplant_Success_Rate_By_Hospital;
DROP VIEW IF EXISTS Critical_Recipients;
DROP VIEW IF EXISTS Upcoming_Follow_Ups;

-- =====================================================
-- VIEW 1: active_wait_list (lowercase)
-- =====================================================
CREATE VIEW active_wait_list AS
SELECT 
    r.Recipient_ID,
    r.Name as Recipient_Name,
    r.Blood_Type,
    r.Medical_Urgency_Level,
    wl.Type_Name as Organ_Type_Needed,
    wl.Priority_Score,
    wl.Wait_List_Date,
    CalculateWaitTimeDays(r.Recipient_ID, wl.Type_Name) as Days_Waiting,
    wl.MELD_Score,
    wl.CPRA_Score,
    r.Contact_Info,
    CASE 
        WHEN r.Medical_Urgency_Level = 5 THEN 'Critical'
        WHEN r.Medical_Urgency_Level = 4 THEN 'High'
        WHEN r.Medical_Urgency_Level = 3 THEN 'Medium'
        WHEN r.Medical_Urgency_Level = 2 THEN 'Low'
        ELSE 'Stable'
    END as Urgency_Category
FROM Recipient r
JOIN Recipient_Waitlist wl ON r.Recipient_ID = wl.Recipient_ID
WHERE r.Status = 'Waiting' 
  AND wl.Status = 'Waiting'
ORDER BY wl.Priority_Score DESC, wl.Wait_List_Date ASC;

-- =====================================================
-- VIEW 2: available_organs (lowercase)
-- =====================================================
CREATE VIEW available_organs AS
SELECT 
    o.Organ_ID,
    o.Type_Name as Organ_Type,
    o.Status,
    o.Procurement_Date,
    o.Procurement_Time,
    CONCAT(o.Procurement_Date, ' ', o.Procurement_Time) as Procurement_DateTime,
    GetRemainingViableHours(o.Organ_ID) as Hours_Remaining,
    CASE 
        WHEN GetRemainingViableHours(o.Organ_ID) < 0 THEN 'Expired'
        WHEN GetRemainingViableHours(o.Organ_ID) < 2 THEN 'Critical'
        WHEN GetRemainingViableHours(o.Organ_ID) <= 6 THEN 'Urgent'
        ELSE 'Normal'
    END as Viability_Status,
    o.HLA_Type,
    o.Size_Weight,
    d.Donor_ID,
    d.Name as Donor_Name,
    d.Blood_Type as Donor_Blood_Type,
    d.Donor_Type,
    ot.Typical_Viability_Hours as Max_Viability_Hours,
    ROUND((GetRemainingViableHours(o.Organ_ID) / ot.Typical_Viability_Hours) * 100, 2) as Viability_Percentage
FROM Organ o
JOIN Donor d ON o.Donor_ID = d.Donor_ID
JOIN Organ_Type ot ON o.Type_Name = ot.Type_Name
WHERE o.Status IN ('Available', 'Allocated')
ORDER BY GetRemainingViableHours(o.Organ_ID) ASC;

-- =====================================================
-- VIEW 3: transplant_success_rate_by_hospital (lowercase)
-- =====================================================
CREATE VIEW transplant_success_rate_by_hospital AS
SELECT 
    h.Hospital_ID,
    h.Name as Hospital_Name,
    h.City,
    h.State,
    COUNT(s.Surgery_ID) as Total_Surgeries,
    SUM(CASE WHEN s.Outcome = 'Success' THEN 1 ELSE 0 END) as Successful_Surgeries,
    SUM(CASE WHEN s.Outcome = 'Complications' THEN 1 ELSE 0 END) as Surgeries_With_Complications,
    SUM(CASE WHEN s.Outcome = 'Failed' THEN 1 ELSE 0 END) as Failed_Surgeries,
    ROUND((SUM(CASE WHEN s.Outcome = 'Success' THEN 1 ELSE 0 END) / COUNT(s.Surgery_ID)) * 100, 2) as Success_Rate_Percentage,
    ROUND((SUM(CASE WHEN s.Outcome = 'Complications' THEN 1 ELSE 0 END) / COUNT(s.Surgery_ID)) * 100, 2) as Complication_Rate_Percentage,
    ROUND((SUM(CASE WHEN s.Outcome = 'Failed' THEN 1 ELSE 0 END) / COUNT(s.Surgery_ID)) * 100, 2) as Failure_Rate_Percentage,
    ROUND(AVG(s.Duration_Hours), 2) as Avg_Surgery_Duration_Hours,
    MIN(s.Surgery_Date) as First_Surgery_Date,
    MAX(s.Surgery_Date) as Most_Recent_Surgery_Date
FROM Hospital h
LEFT JOIN Surgery s ON h.Hospital_ID = s.Hospital_ID
GROUP BY h.Hospital_ID, h.Name, h.City, h.State
HAVING Total_Surgeries > 0
ORDER BY Success_Rate_Percentage DESC, Total_Surgeries DESC;

-- =====================================================
-- VIEW 4: critical_recipients (lowercase)
-- =====================================================
CREATE VIEW critical_recipients AS
SELECT 
    r.Recipient_ID,
    r.Name as Recipient_Name,
    r.Blood_Type,
    r.Medical_Urgency_Level,
    r.Primary_Diagnosis,
    r.Contact_Info,
    r.Insurance_Info,
    wl.Type_Name as Organ_Needed,
    wl.Priority_Score,
    wl.Wait_List_Date,
    CalculateWaitTimeDays(r.Recipient_ID, wl.Type_Name) as Days_Waiting,
    wl.MELD_Score,
    wl.CPRA_Score,
    CASE 
        WHEN r.Medical_Urgency_Level = 5 THEN 'Emergency'
        WHEN r.Medical_Urgency_Level = 4 THEN 'Critical'
        ELSE 'High'
    END as Priority_Category,
    CASE 
        WHEN CalculateWaitTimeDays(r.Recipient_ID, wl.Type_Name) > 365 THEN 'Over 1 Year'
        WHEN CalculateWaitTimeDays(r.Recipient_ID, wl.Type_Name) > 180 THEN '6-12 Months'
        WHEN CalculateWaitTimeDays(r.Recipient_ID, wl.Type_Name) > 90 THEN '3-6 Months'
        ELSE 'Under 3 Months'
    END as Wait_Time_Category
FROM Recipient r
JOIN Recipient_Waitlist wl ON r.Recipient_ID = wl.Recipient_ID
WHERE r.Status = 'Waiting' 
  AND wl.Status = 'Waiting'
  AND r.Medical_Urgency_Level >= 4
ORDER BY r.Medical_Urgency_Level DESC, wl.Priority_Score DESC, wl.Wait_List_Date ASC;

-- =====================================================
-- VIEW 5: upcoming_follow_ups (lowercase)
-- =====================================================
CREATE VIEW upcoming_follow_ups AS
SELECT 
    fa.Appointment_ID,
    fa.Appointment_Date,
    fa.Appointment_Time,
    CONCAT(fa.Appointment_Date, ' ', fa.Appointment_Time) as Appointment_DateTime,
    DATEDIFF(fa.Appointment_Date, CURDATE()) as Days_Until_Appointment,
    r.Recipient_ID,
    r.Name as Recipient_Name,
    r.Blood_Type,
    r.Contact_Info as Recipient_Contact,
    s.Surgery_ID,
    s.Surgery_Date,
    DATEDIFF(CURDATE(), s.Surgery_Date) as Days_Since_Surgery,
    o.Type_Name as Transplanted_Organ,
    ms.Staff_ID as Assigned_Staff_ID,
    ms.Name as Staff_Name,
    ms.Specialization,
    ms.Phone as Staff_Contact,
    fa.Rejection_Indicators,
    fa.Lab_Results,
    fa.Medication_Adherence,
    fa.Notes as Previous_Notes,
    fa.Next_Appointment_Date,
    CASE 
        WHEN DATEDIFF(fa.Appointment_Date, CURDATE()) = 0 THEN 'Today'
        WHEN DATEDIFF(fa.Appointment_Date, CURDATE()) = 1 THEN 'Tomorrow'
        WHEN DATEDIFF(fa.Appointment_Date, CURDATE()) <= 7 THEN 'This Week'
        WHEN DATEDIFF(fa.Appointment_Date, CURDATE()) <= 14 THEN 'Next Week'
        ELSE 'Later This Month'
    END as Appointment_Urgency
FROM Follow_Up_Appointment fa
JOIN Recipient r ON fa.Recipient_ID = r.Recipient_ID
JOIN Surgery s ON fa.Surgery_ID = s.Surgery_ID
JOIN Organ o ON s.Organ_ID = o.Organ_ID
JOIN Medical_Staff ms ON fa.Staff_ID = ms.Staff_ID
WHERE fa.Appointment_Date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY)
ORDER BY fa.Appointment_Date ASC, fa.Appointment_Time ASC;