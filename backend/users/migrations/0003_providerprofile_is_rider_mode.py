from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0002_nurseprofile_health_declaration_and_more'),
    ]

    operations = [
        migrations.AddField(
            model_name='providerprofile',
            name='is_rider_mode',
            field=models.BooleanField(default=False),
        ),
    ]
