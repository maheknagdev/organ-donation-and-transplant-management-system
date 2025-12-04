from django.urls import path
from . import views

app_name = 'core'

urlpatterns = [
    # Authentication
    path('login/', views.user_login, name='login'),
    path('logout/', views.user_logout, name='logout'),
    path('register/', views.user_register, name='register'),
    
    # Dashboard
    path('', views.dashboard, name='dashboard'),
    
    # Organs
    path('organs/available/', views.available_organs, name='available_organs'),
    path('organs/available-view/', views.available_organs_mysql_view, name='available_organs_mysql_view'),
    path('organs/match/<int:organ_id>/', views.match_organ, name='match_organ'),
    path('organs/create/', views.create_organ, name='create_organ'),
    path('organs/<int:organ_id>/update/', views.update_organ, name='update_organ'),
    path('organs/<int:organ_id>/viability/', views.check_organ_viability, name='check_organ_viability'),
    path('organs/<int:organ_id>/allocate/', views.allocate_organ_page, name='allocate_organ_page'),
    
    # Donors
    path('donors/', views.donor_list, name='donor_list'),
    path('donors/create/', views.create_donor, name='create_donor'),
    path('donors/<int:donor_id>/update/', views.update_donor, name='update_donor'),
    
    # Recipients
    path('recipients/', views.recipient_list, name='recipient_list'),
    path('recipients/create/', views.create_recipient, name='create_recipient'),
    path('recipients/<int:recipient_id>/update/', views.update_recipient, name='update_recipient'),
    path('recipients/<int:recipient_id>/history/', views.recipient_history, name='recipient_history'),
    path('recipients/critical/', views.critical_recipients, name='critical_recipients'),
    
    # Waitlist
    path('waitlist/', views.waitlist, name='waitlist'),
    path('waitlist/active-view/', views.active_waitlist_mysql_view, name='active_waitlist_mysql_view'),
    path('waitlist/add/', views.add_to_waitlist, name='add_to_waitlist'),
    path('waitlist/<int:recipient_id>/<str:organ_type>/remove/', views.remove_from_waitlist, name='remove_from_waitlist'),
    path('waitlist/calculate-priority/<int:recipient_id>/<str:organ_type>/', views.calculate_priority, name='calculate_priority'),
    
    # Allocations
    path('allocations/', views.allocation_list, name='allocation_list'),
    path('allocations/<int:allocation_id>/respond/', views.respond_to_allocation, name='respond_to_allocation'),
    
    # Surgery & Follow-ups
    path('surgeries/', views.surgery_list, name='surgery_list'),
    path('surgeries/create/', views.create_surgery, name='create_surgery'),
    path('follow-ups/upcoming/', views.upcoming_followups, name='upcoming_followups'),
    
    # Reports
    path('reports/hospital-performance/', views.hospital_performance, name='hospital_performance'),
    path('reports/waiting-time/', views.waiting_time_analysis, name='waiting_time_analysis'),
]