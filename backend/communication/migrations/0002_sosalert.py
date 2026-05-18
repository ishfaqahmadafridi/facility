from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('communication', '0001_initial'),
        ('users', '0003_providerprofile_is_rider_mode'),
    ]

    operations = [
        migrations.CreateModel(
            name='SOSAlert',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('latitude', models.FloatField()),
                ('longitude', models.FloatField()),
                ('emergency_contact', models.CharField(blank=True, max_length=20, null=True)),
                ('shared_with_police', models.BooleanField(default=True)),
                ('notes', models.TextField(blank=True, null=True)),
                ('status', models.CharField(choices=[('OPEN', 'Open'), ('ACKNOWLEDGED', 'Acknowledged'), ('RESOLVED', 'Resolved')], default='OPEN', max_length=20)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='sos_alerts', to='users.user')),
            ],
        ),
    ]
