from django.db import models
from users.models import ProviderProfile
from jobs.models import Job

class Transaction(models.Model):
    TRANSACTION_TYPES = (
        ('EARNING', 'Earning from Job'),
        ('WITHDRAWAL', 'Withdrawal'),
        ('REFUND', 'Refund'),
    )

    provider = models.ForeignKey(ProviderProfile, on_delete=models.CASCADE, related_name='transactions')
    job = models.ForeignKey(Job, on_delete=models.SET_NULL, null=True, blank=True)
    transaction_type = models.CharField(max_length=20, choices=TRANSACTION_TYPES)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    timestamp = models.DateTimeField(auto_now_add=True)
    description = models.CharField(max_length=255, blank=True, null=True)

    def __str__(self):
        return f"{self.transaction_type} of {self.amount} for {self.provider.user.phone_number}"

class WithdrawalRequest(models.Model):
    STATUS_CHOICES = (
        ('PENDING', 'Pending'),
        ('APPROVED', 'Approved'),
        ('REJECTED', 'Rejected'),
    )

    METHOD_CHOICES = (
        ('JAZZCASH', 'JazzCash'),
        ('EASYPAISA', 'Easypaisa'),
        ('BANK', 'Bank Transfer'),
    )

    provider = models.ForeignKey(ProviderProfile, on_delete=models.CASCADE, related_name='withdrawals')
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    method = models.CharField(max_length=20, choices=METHOD_CHOICES)
    account_number = models.CharField(max_length=50)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='PENDING')
    created_at = models.DateTimeField(auto_now_add=True)
    processed_at = models.DateTimeField(null=True, blank=True)

    def __str__(self):
        return f"Withdrawal of {self.amount} via {self.method} for {self.provider.user.phone_number}"
