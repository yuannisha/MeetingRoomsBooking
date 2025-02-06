<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.6.8/dist/css/layui.css">
<script src="https://cdn.jsdelivr.net/npm/layui@2.6.8/dist/layui.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
<style>
    .layui-header {
        background-color: #393D49;
        color: #fff;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 20px;
    }
    .layui-logo {
        font-size: 18px;
        font-weight: bold;
    }
    .layui-nav-item a {
        color: #201e1e !important;
    }
    .layui-nav-item a:hover {
        background-color: #1E9FFF;
    }
    .layui-btn {
        margin: 0 5px;
    }
</style>

<div class="layui-header">
    <div class="layui-logo">会议室预订系统</div>
    <ul class="layui-nav layui-layout-left">
        <!-- 所有用户都可以看到的按钮 -->
        <li class="layui-nav-item"><button class="layui-btn" onclick="toMeetingRoomList()">首页</button></li>
        <li class="layui-nav-item"><button class="layui-btn" onclick="toProfile()">个人信息</button></li>
        <li class="layui-nav-item"><button class="layui-btn" onclick="toBookingRecord()">预约记录</button></li>
        
        <!-- 只有管理员可以看到的按钮 -->
        <c:if test="${sessionScope.currentUserRole eq 'ROLE_ADMIN'}">
            <li class="layui-nav-item"><button class="layui-btn" onclick="toUserManage()">用户管理</button></li>
            <li class="layui-nav-item"><button class="layui-btn" onclick="toMeetingRoomManage()">会议室管理</button></li>
        </c:if>
    </ul>
    <ul class="layui-nav layui-layout-right">
        <li class="layui-nav-item">
            <a href="javascript:;">
                <img src="https://gravatar.com/avatar/27205e5c51cb03f862138b22bcb5dc20f94a342e744ff6df1b8dc8af3c865109?f=y" class="layui-nav-img">
                ${sessionScope.user.username}
            </a>
            <dl class="layui-nav-child">
                <dd><button class="layui-btn" onclick="logout()">退出</button></dd>
            </dl>
        </li>
    </ul>
</div>
<script>
    // 跳转到首页（会议室列表）方法
    function toMeetingRoomList() {
        window.location.href = '${pageContext.request.contextPath}/meetingRooms/listpage';
    }
    // 跳转到个人信息方法
    function toProfile() {
        window.location.href = '${pageContext.request.contextPath}/users/profile';
    }
    // 跳转到会议室管理方法
    function toMeetingRoomManage() {
        window.location.href = '${pageContext.request.contextPath}/meetingRooms/manage';
    }    
    // 跳转到预约记录方法
    function toBookingRecord() {
        window.location.href = '${pageContext.request.contextPath}/bookings/record';
    } 
    //跳转到用户管理方法
    function toUserManage() {
        $.ajax({    
            url: '${pageContext.request.contextPath}/users/manage',
            type: 'get',
            contentType: 'application/json',
            success: function(res){
                window.location.href = '${pageContext.request.contextPath}/users/manage';
            },
            error: function(xhr){
                layer.msg(xhr.responseText || '跳转失败');
            }   
        });
    }
    // 退出方法
    function logout() {
        $.ajax({
            url: '${pageContext.request.contextPath}/users/logout',
            type: 'get',
            contentType: 'application/json',
            success: function(res){
                layer.msg('退出成功');
                window.location.href = '${pageContext.request.contextPath}/users/login';
            },
            error: function(xhr){
                layer.msg(xhr.responseText || '退出失败');
            }
        });
    }

    // 初始化layui导航栏
    layui.use('element', function(){
        var element = layui.element;
    });
</script>
