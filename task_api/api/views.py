from django.shortcuts import render, redirect
from rest_framework.response import Response 
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated

from task_base.models import Task, User

from .serializers import TaskSerializer, UserSerializer
# Create your views here.


@api_view(['GET'])
def endpoints(request):
    data = ['/tasks', 'tasks/:username']
    return Response(data)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def task_list(request):
    tasks = Task.objects.all()
    serializer = TaskSerializer(tasks, many = True)
    return Response(serializer.data)

@api_view(['GET', 'PUT', 'DELETE'])
def task_details(request, id):
    task = Task.objects.get(SK_TASK = id)
    if request.method == 'GET':
        serializer = TaskSerializer(task, many = False)
        return Response(serializer.data)
    if request.method == 'PUT':
        task.ST_TITLE = request.data['title']
        task.ST_DESCRIPTION = request.data['description']
        task.FC_DUE_DATE = request.data['due_date']
        task.save()
        serializer = TaskSerializer(task, many = False)
        return Response(serializer.data)
    if request.method == 'DELETE':
        task.delete()
        return Response('Task deleted')

@api_view(['POST'])
def add_task(request):
    task = Task.objects.create(
        ST_TITLE = request.data['title'],
        ST_DESCRIPTION = request.data['description'],
        FC_DUE_DATE = request.data['due_date']
    )
    serializer = TaskSerializer(task, many = False)
    return Response(serializer.data)


@api_view(['GET'])
def user_list(request):
    users = User.objects.all()
    serializer = UserSerializer(users, many = True)
    return Response(serializer.data) 
