from django.urls import path
from .views import (SendMessageView, GetChatHistoryView, GenerateAgoraTokenView,
                    ReportIssueView, SOSAlertView)

urlpatterns = [
    path('<int:job_id>/send/', SendMessageView.as_view(), name='send_message'),
    path('<int:job_id>/messages/', GetChatHistoryView.as_view(), name='get_messages'),
    path('<int:job_id>/agora-token/', GenerateAgoraTokenView.as_view(), name='agora_token'),
    path('job/<int:job_id>/report/', ReportIssueView.as_view(), name='report_issue'),
    path('sos/', SOSAlertView.as_view(), name='sos_alert'),
]
