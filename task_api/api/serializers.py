from rest_framework.serializers import ModelSerializer, SerializerMethodField

from task_base.models import Task, User

class UserSerializer(ModelSerializer):
    task_count = SerializerMethodField(read_only = True)
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'task_count']

    def get_task_count(self, obj):
        count = obj.task_set.count()
        return count


class TaskSerializer(ModelSerializer):
    FK_ASIGNED_USER = UserSerializer()
    class Meta:
        model = Task
        fields = '__all__'
        