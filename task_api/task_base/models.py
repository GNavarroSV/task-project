from django.db import models
from django.contrib.auth.models import AbstractUser

# Create your models here.

class User(AbstractUser): 
    class Meta:
            db_table = "user"

class Task(models.Model):
    SK_TASK = models.AutoField(primary_key=True)
    ST_TITLE = models.CharField(max_length=50, null=False)
    ST_DESCRIPTION = models.CharField(max_length=200, null=False)
    FK_ASIGNED_USER =  models.ForeignKey(User,on_delete=models.SET_NULL,null=True,blank=True)
    FC_DUE_DATE = models.DateField(null=False,)
    BN_COMPLETED = models.BooleanField(null=False, default=0)
    class Meta:
            db_table = "task"
