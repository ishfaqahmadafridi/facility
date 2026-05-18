import time

from asgiref.sync import async_to_sync
from channels.layers import get_channel_layer
from django.conf import settings


def get_job_group_name(job_id):
    return f'job_chat_{job_id}'


def get_job_chat_channel_name(job_id):
    return f'job_{job_id}_channel'


def broadcast_message_to_room(job_id, payload):
    channel_layer = get_channel_layer()
    if not channel_layer:
        return

    async_to_sync(channel_layer.group_send)(
        get_job_group_name(job_id),
        {
            'type': 'chat.message',
            'message': payload,
        },
    )


def build_agora_rtc_token(*, channel_name, uid):
    try:
        from agora_token_builder import RtcTokenBuilder
    except ImportError as exc:
        raise RuntimeError('agora-token-builder is not installed on the backend.') from exc

    privilege_expired_ts = int(time.time()) + settings.AGORA_TOKEN_EXPIRY_SECONDS
    role = 1
    return RtcTokenBuilder.buildTokenWithUid(
        settings.AGORA_APP_ID,
        settings.AGORA_APP_CERTIFICATE,
        channel_name,
        int(uid),
        role,
        privilege_expired_ts,
    )
