from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('jobs', '0003_portfolioitem_review'),
    ]

    operations = [
        migrations.AddField(
            model_name='ride',
            name='agreed_fare',
            field=models.DecimalField(blank=True, decimal_places=2, max_digits=10, null=True),
        ),
        migrations.AddField(
            model_name='ride',
            name='is_counter_offer',
            field=models.BooleanField(default=False),
        ),
    ]
