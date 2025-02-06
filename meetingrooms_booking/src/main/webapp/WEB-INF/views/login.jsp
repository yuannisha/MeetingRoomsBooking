<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>登录 - 会议室预订系统</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.6.8/dist/css/layui.css">
    <style>
        body {
            background-color: #f2f2f2;
        }
        .login-container {
            width: 400px;
            margin: 100px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 4px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .login-title {
            text-align: center;
            margin-bottom: 20px;
            color: #333;
            font-size: 24px;
        }
        .layui-form {
            padding: 20px;
        }
        .layui-form-item {
            margin-bottom: 20px;
        }
        .register-link {
            text-align: center;
            margin-top: 15px;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2 class="login-title">会议室预订系统</h2>
        <form class="layui-form">
            <div class="layui-form-item">
                <input type="text" name="phone" required lay-verify="required|phone" placeholder="请输入手机号" autocomplete="off" class="layui-input">
            </div>
            <div class="layui-form-item">
                <input type="password" name="password" required lay-verify="required" placeholder="请输入密码" autocomplete="off" class="layui-input">
            </div>
            <div class="layui-form-item">
                <button class="layui-btn layui-btn-fluid layui-btn-normal" lay-submit lay-filter="login">登录</button>
            </div>
        </form>
        <div class="register-link">
            <a href="${pageContext.request.contextPath}/users/register" class="layui-link">还没有账号？立即注册</a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/layui@2.6.8/dist/layui.js"></script>
    <script>
        layui.use(['form', 'layer'], function(){
            var form = layui.form;
            var layer = layui.layer;
            var $ = layui.$;
            
            form.verify({
                phone: [/^1\d{10}$/, '请输入正确的手机号']
            });
            
            form.on('submit(login)', function(data){
                $.ajax({
                    url: '${pageContext.request.contextPath}/users/login',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify(data.field),
                    success: function(res){
                        layer.msg('登录成功');
                        // 根据角色跳转到不同页面
                        var user = res.user;
                        var userRole = res.userRole;
                        console.log("这是用户的角色",userRole)
                        setTimeout(function() {
                            if (userRole == "ROLE_ADMIN" && user.status == 1) {
                                window.location.href = '${pageContext.request.contextPath}/users/manage';
                            } else if(userRole == "ROLE_USER" && user.status == 1) {
                                window.location.href = '${pageContext.request.contextPath}/meetingRooms/listpage';
                            } else {
                                layer.msg('用户已被禁用');
                            }

                        }, 1000);
                    },
                    error: function(xhr){
                        layer.msg(xhr.responseText || '登录失败');
                    }
                });
                return false;
            });
        });
    </script>
</body>
</html> 