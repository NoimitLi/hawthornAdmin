from rest_framework import routers
from .views import AuthView

routers = routers.DefaultRouter()

routers.register('', AuthView, basename='oauth')

urlpatterns = routers.urls
