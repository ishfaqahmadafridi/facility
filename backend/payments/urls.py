from django.urls import path
from .views import WalletSummaryView, RequestWithdrawalView

urlpatterns = [
    path('wallet/', WalletSummaryView.as_view(), name='wallet_summary'),
    path('withdraw/', RequestWithdrawalView.as_view(), name='request_withdrawal'),
]
