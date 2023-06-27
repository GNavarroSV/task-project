# Generated by Django 4.1.3 on 2023-06-25 18:52

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('task_base', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='task',
            name='FK_ASIGNED_USER',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, to=settings.AUTH_USER_MODEL),
        ),
    ]
