from rest_framework import viewsets
from rest_framework.response import Response
from rest_framework.decorators import action


class AuthView(viewsets.ViewSet):
    """鉴权"""

    @action(methods=['post'], detail=False)
    def register(self, request):
        """注册"""
        pass

    @action(methods=['get'], detail=False)
    def login(self, request):
        """登录"""
        return Response({'message': '登录成功'})

    @action(methods=['post'], detail=False)
    def logout(self, request):
        """登出"""
        pass
