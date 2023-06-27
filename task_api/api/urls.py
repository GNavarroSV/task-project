from django.urls import path
from . import views

from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    #TokenRefreshView,
)



urlpatterns = [
    path('', views.endpoints, name = "endpoints"),
    path('task_list', views.task_list, name = "task_list"),
    path('task_details/<int:id>/', views.task_details, name = "task_details"),
    path('add_task', views.add_task, name= "add_task" ),
    path('user_list', views.user_list, name = "user_list"),

    #JWT VIEWS
    path('token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    #path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
]