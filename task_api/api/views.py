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
#@permission_classes([IsAuthenticated])
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
        if request.data['FK_ASIGNED_USER']:
            user = User.objects.get(id = request.data['FK_ASIGNED_USER'])
        task.ST_TITLE = request.data['ST_TITLE']
        task.ST_DESCRIPTION = request.data['ST_DESCRIPTION']
        task.FC_DUE_DATE = request.data['FC_DUE_DATE']
        task.FK_ASIGNED_USER = user if user else None
        task.save()
        serializer = TaskSerializer(task, many = False)
        return Response(serializer.data)
    if request.method == 'DELETE':
        task.delete()
        return Response('Task deleted')

@api_view(['POST'])
def add_task(request):
    user = User.objects.get(id = request.data['FK_ASIGNED_USER'])
    task = Task.objects.create(
        ST_TITLE = request.data['ST_TITLE'],
        ST_DESCRIPTION = request.data['ST_DESCRIPTION'],
        FC_DUE_DATE = request.data['FC_DUE_DATE'],
        FK_ASIGNED_USER = user,
    )
    serializer = TaskSerializer(task, many = False)
    return Response(serializer.data)


@api_view(['PUT'])
def complete_task(request, id):
    task = Task.objects.get(SK_TASK= id)
    if request.method == 'PUT':
        task.BN_COMPLETED = True
        task.save()
        return Response('Task completed')


@api_view(['GET'])
def user_list(request):
    users = User.objects.all()
    serializer = UserSerializer(users, many = True)
    return Response(serializer.data) 


@api_view(['GET'])
def user_details(request, id):
    user = User.objects.get(id = id)
    serializer = UserSerializer(user, many = False)
    return Response(serializer.data) 
