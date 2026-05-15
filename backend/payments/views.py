from django.db.models import Sum
from rest_framework import views, status, generics
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from .models import Transaction, WithdrawalRequest
from .serializers import WithdrawalRequestSerializer, TransactionSerializer
from jobs.models import Job

class WalletSummaryView(views.APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user
        
        if not hasattr(user, 'provider_profile'):
            return Response({'error': 'Not a provider'}, status=status.HTTP_400_BAD_REQUEST)
            
        provider = user.provider_profile
        
        # Calculate Earnings (from transactions)
        total_earnings = Transaction.objects.filter(
            provider=provider, transaction_type='EARNING'
        ).aggregate(Sum('amount'))['amount__sum'] or 0.0

        total_withdrawals = Transaction.objects.filter(
            provider=provider, transaction_type='WITHDRAWAL'
        ).aggregate(Sum('amount'))['amount__sum'] or 0.0
        
        current_balance = float(total_earnings) - float(total_withdrawals)

        # Calculate Escrow (jobs accepted/in_progress with escrow_held=True)
        escrow_balance = Job.objects.filter(
            provider=provider, 
            status__in=['ACCEPTED', 'IN_PROGRESS'],
            escrow_held=True,
            escrow_released=False
        ).aggregate(Sum('price'))['price__sum'] or 0.0
        
        # Latest transactions
        recent_txs = Transaction.objects.filter(provider=provider).order_by('-timestamp')[:5]
        
        return Response({
            'total_earnings': float(total_earnings),
            'current_balance': float(current_balance),
            'escrow_balance': float(escrow_balance),
            'recent_transactions': TransactionSerializer(recent_txs, many=True).data
        }, status=status.HTTP_200_OK)

class RequestWithdrawalView(views.APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        user = request.user
        
        if not hasattr(user, 'provider_profile'):
            return Response({'error': 'Not a provider'}, status=status.HTTP_400_BAD_REQUEST)
            
        provider = user.provider_profile
        serializer = WithdrawalRequestSerializer(data=request.data)
        
        if serializer.is_valid():
            amount = serializer.validated_data['amount']
            
            # Simple balance check
            total_earnings = Transaction.objects.filter(
                provider=provider, transaction_type='EARNING'
            ).aggregate(Sum('amount'))['amount__sum'] or 0.0
            
            total_withdrawals = Transaction.objects.filter(
                provider=provider, transaction_type='WITHDRAWAL'
            ).aggregate(Sum('amount'))['amount__sum'] or 0.0
            
            current_balance = float(total_earnings) - float(total_withdrawals)
            
            if amount > current_balance:
                return Response({'error': 'Insufficient funds.'}, status=status.HTTP_400_BAD_REQUEST)
                
            serializer.save(provider=provider)
            
            # Log transaction (or do this only when approved by admin)
            Transaction.objects.create(
                provider=provider,
                transaction_type='WITHDRAWAL',
                amount=amount,
                description=f"Withdrawal request via {serializer.validated_data['method']}"
            )
            
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
