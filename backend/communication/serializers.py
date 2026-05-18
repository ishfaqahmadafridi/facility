from rest_framework import serializers
from .models import Message, Report, SOSAlert
from users.serializers import UserSerializer

class MessageSerializer(serializers.ModelSerializer):
    sender_details = UserSerializer(source='sender', read_only=True)
    voice_note_url = serializers.SerializerMethodField()

    class Meta:
        model = Message
        fields = '__all__'
        read_only_fields = ('timestamp', 'sender')

    def validate(self, attrs):
        message_type = attrs.get('message_type', getattr(self.instance, 'message_type', 'TEXT'))
        content = attrs.get('content')
        voice_note = attrs.get('voice_note')

        if message_type == 'TEXT' and not content:
            raise serializers.ValidationError({'content': 'Text messages require content.'})

        if message_type == 'VOICE' and not voice_note:
            raise serializers.ValidationError({'voice_note': 'Voice messages require an uploaded file.'})

        return attrs

    def get_voice_note_url(self, obj):
        if not obj.voice_note:
            return None

        request = self.context.get('request')
        url = obj.voice_note.url
        return request.build_absolute_uri(url) if request else url

class ReportSerializer(serializers.ModelSerializer):
    class Meta:
        model = Report
        fields = '__all__'
        read_only_fields = ('status', 'created_at', 'reporter')

class SOSAlertSerializer(serializers.ModelSerializer):
    user_details = UserSerializer(source='user', read_only=True)

    class Meta:
        model = SOSAlert
        fields = '__all__'
        read_only_fields = ('status', 'created_at', 'user')
