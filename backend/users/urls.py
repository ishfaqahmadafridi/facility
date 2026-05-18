from django.urls import path
from .views import SendOTPView, VerifyOTPView, CompleteProfileView, SwitchModeView, ToggleOnlineView, ToggleRiderModeView, ProviderProfileView, CurrentProviderProfileView

urlpatterns = [
    path('auth/send-otp/', SendOTPView.as_view(), name='send_otp'),
    path('auth/verify-otp/', VerifyOTPView.as_view(), name='verify_otp'),
    path('profile/complete/', CompleteProfileView.as_view(), name='complete_profile'),
    path('switch-mode/', SwitchModeView.as_view(), name='switch_mode'),
    path('toggle-online/', ToggleOnlineView.as_view(), name='toggle_online'),
    path('toggle-rider-mode/', ToggleRiderModeView.as_view(), name='toggle_rider_mode'),
    path('provider/me/', CurrentProviderProfileView.as_view(), name='current_provider_profile'),
    path('provider/<int:pk>/', ProviderProfileView.as_view(), name='provider_profile'),
]
