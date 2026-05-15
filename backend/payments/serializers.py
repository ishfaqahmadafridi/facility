from rest_framework import serializers
from .models import Transaction, WithdrawalRequest

class TransactionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Transaction
        fields = '__all__'
        read_only_fields = ('provider', 'timestamp')

class WithdrawalRequestSerializer(serializers.ModelSerializer):
    class Meta:
        model = WithdrawalRequest
        fields = '__all__'
        read_only_fields = ('provider', 'status', 'created_at', 'processed_at')
