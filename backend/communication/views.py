from rest_framework import views, status, generics
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from .models import Message, Report, SOSAlert
from .serializers import MessageSerializer, ReportSerializer, SOSAlertSerializer
from jobs.models import Job
from django.conf import settings

from .services import broadcast_message_to_room, build_agora_rtc_token, get_job_chat_channel_name

class SendMessageView(views.APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, job_id):
        user = request.user
        try:
            job = Job.objects.get(pk=job_id)
        except Job.DoesNotExist:
            return Response({'error': 'Job not found'}, status=status.HTTP_404_NOT_FOUND)

        # Verify user is either the customer or the provider for this job
        if not (job.customer.user == user or (job.provider and job.provider.user == user)):
            return Response({'error': 'Not authorized for this job chat'}, status=status.HTTP_403_FORBIDDEN)

        data = request.data.copy()
        data['job'] = job.id
        
        serializer = MessageSerializer(data=data, context={'request': request})
        if serializer.is_valid():
            message = serializer.save(sender=user)
            payload = MessageSerializer(message, context={'request': request}).data
            broadcast_message_to_room(job.id, payload)
            return Response(payload, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class GetChatHistoryView(generics.ListAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = MessageSerializer

    def get_queryset(self):
        job_id = self.kwargs['job_id']
        user = self.request.user
        try:
            job = Job.objects.get(pk=job_id)
            if not (job.customer.user == user or (job.provider and job.provider.user == user)):
                return Message.objects.none()
            return Message.objects.filter(job=job).order_by('timestamp')
        except Job.DoesNotExist:
            return Message.objects.none()

class GenerateAgoraTokenView(views.APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, job_id):
        user = request.user
        try:
            job = Job.objects.get(pk=job_id)
        except Job.DoesNotExist:
            return Response({'error': 'Job not found'}, status=status.HTTP_404_NOT_FOUND)

        if not (job.customer.user == user or (job.provider and job.provider.user == user)):
            return Response({'error': 'Not authorized for this job call'}, status=status.HTTP_403_FORBIDDEN)

        if not settings.AGORA_APP_ID or not settings.AGORA_APP_CERTIFICATE:
            return Response(
                {'error': 'Agora is not configured. Set AGORA_APP_ID and AGORA_APP_CERTIFICATE.'},
                status=status.HTTP_503_SERVICE_UNAVAILABLE,
            )

        channel_name = get_job_chat_channel_name(job_id)
        uid = request.user.id or 0

        try:
            token = build_agora_rtc_token(channel_name=channel_name, uid=uid)
        except RuntimeError as exc:
            return Response({'error': str(exc)}, status=status.HTTP_503_SERVICE_UNAVAILABLE)

        return Response({
            'channel_name': channel_name,
            'token': token,
            'app_id': settings.AGORA_APP_ID,
            'uid': uid,
            'expires_in': settings.AGORA_TOKEN_EXPIRY_SECONDS,
        }, status=status.HTTP_200_OK)

class ReportIssueView(views.APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, job_id):
        user = request.user
        try:
            job = Job.objects.get(pk=job_id)
        except Job.DoesNotExist:
            return Response({'error': 'Job not found'}, status=status.HTTP_404_NOT_FOUND)

        if not (job.customer.user == user or (job.provider and job.provider.user == user)):
            return Response({'error': 'Not authorized for this job report'}, status=status.HTTP_403_FORBIDDEN)

        if job.status not in ['COMPLETED', 'DISPUTED', 'CANCELLED']:
            return Response({'error': 'Reports can only be filed after the job is completed, disputed, or cancelled.'}, status=status.HTTP_400_BAD_REQUEST)

        existing_open_report = Report.objects.filter(
            job=job,
            reporter=user,
            status__in=['OPEN', 'REVIEWING'],
        ).first()
        if existing_open_report:
            return Response({'error': 'An open report already exists for this job.'}, status=status.HTTP_400_BAD_REQUEST)

        data = request.data.copy()
        data['job'] = job.id
        
        serializer = ReportSerializer(data=data)
        if serializer.is_valid():
            serializer.save(reporter=user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class SOSAlertView(views.APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        user = request.user
        latitude = request.data.get('latitude')
        longitude = request.data.get('longitude')
        
        if latitude in (None, '') or longitude in (None, ''):
            return Response({'error': 'Location is required for SOS'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            latitude = float(latitude)
            longitude = float(longitude)
        except (TypeError, ValueError):
            return Response({'error': 'Latitude and longitude must be numeric.'}, status=status.HTTP_400_BAD_REQUEST)

        alert = SOSAlert.objects.create(
            user=user,
            latitude=latitude,
            longitude=longitude,
            emergency_contact=user.emergency_contact,
            shared_with_police=bool(request.data.get('shared_with_police', True)),
            notes=request.data.get('notes', ''),
        )

        # In production this is where SMS / dispatch integrations would trigger.
        print(
            f"!!! SOS ALERT !!! User {user.phone_number} at ({latitude}, {longitude}) "
            f"shared_with_police={alert.shared_with_police} emergency_contact={alert.emergency_contact}"
        )

        payload = SOSAlertSerializer(alert).data
        return Response(
            {
                'message': 'SOS Alert triggered successfully. Live location shared with your emergency flow.',
                'alert': payload,
            },
            status=status.HTTP_201_CREATED,
        )
