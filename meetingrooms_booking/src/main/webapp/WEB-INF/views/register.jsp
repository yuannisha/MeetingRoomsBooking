<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>注册 - 会议室预订系统</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.6.8/dist/css/layui.css">
    <style>
        body {
            background-color: #f2f2f2;
        }
        .register-container {
            width: 400px;
            margin: 100px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 4px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .register-title {
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
        .login-link {
            text-align: center;
            margin-top: 15px;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <h2 class="register-title">注册新用户</h2>
        <form class="layui-form">
            <div class="layui-form-item">
                <input type="text" name="username" required lay-verify="required" placeholder="请输入用户名" autocomplete="off" class="layui-input">
            </div>
            <div class="layui-form-item">
                <input type="text" name="phone" required lay-verify="required|phone" placeholder="请输入手机号" autocomplete="off" class="layui-input">
            </div>
            <div class="layui-form-item">
                <input type="password" name="password" required lay-verify="required|pass" placeholder="请输入密码" autocomplete="off" class="layui-input">
            </div>
            <div class="layui-form-item">
                <input type="password" name="repassword" required lay-verify="required|repass" placeholder="请确认密码" autocomplete="off" class="layui-input">
            </div>
            <div class="layui-form-item">
                <button class="layui-btn layui-btn-fluid layui-btn-normal" lay-submit lay-filter="register">注册</button>
            </div>
        </form>
        <div class="login-link">
            <a href="${pageContext.request.contextPath}/users/login" class="layui-link">已有账号？立即登录</a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/layui@2.6.8/dist/layui.js"></script>
    <script>
        layui.use(['form', 'layer'], function(){
            var form = layui.form;
            var layer = layui.layer;
            var $ = layui.$;
            
            form.verify({
                phone: [/^1\d{10}$/, '请输入正确的手机号'],
                pass: [/^[\S]{6,12}$/, '密码必须6到12位，且不能出现空格'],
                repass: function(value){
                    var password = $('input[name=password]').val();
                    if(value !== password){
                        return '两次密码输入不一致';
                    }
                }
            });
            
            form.on('submit(register)', function(data){
                var field = data.field;
                delete field.repassword;  // 删除确认密码字段
                
                $.ajax({
                    url: '${pageContext.request.contextPath}/users/register',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify(field),
                    success: function(res){
                        layer.msg('注册成功，即将跳转到登录页面');
                        setTimeout(function(){
                            window.location.href = '${pageContext.request.contextPath}/users/login';
                        }, 1500);
                    },
                    error: function(xhr){
                        layer.msg(xhr.responseText || '注册失败');
                    }
                });
                return false;
            });
        });
    </script>
</body>
</html> 