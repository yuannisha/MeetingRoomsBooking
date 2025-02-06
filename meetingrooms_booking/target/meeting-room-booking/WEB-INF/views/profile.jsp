<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>个人信息 - 会议室预订系统</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.6.8/dist/css/layui.css">
    <style>
        body {
            background-color: #f5f7fa;
        }
        .profile-container {
            width: 500px;
            margin: 50px auto;
            padding: 30px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .profile-title {
            text-align: center;
            margin-bottom: 30px;
            color: #333;
            font-size: 24px;
            font-weight: bold;
        }
        .layui-form {
            padding: 20px;
        }
        .layui-form-item {
            margin-bottom: 25px;
        }
        .btn-group {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
        }
        .btn-group .layui-btn {
            width: 48%;
        }
        .layui-form-label {
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="profile-container">
        <h2 class="profile-title">个人信息</h2>
        <form class="layui-form" id="profileForm">
            <div class="layui-form-item">
                <label class="layui-form-label">用户名</label>
                <div class="layui-input-block">
                    <input type="text" name="username" required lay-verify="required" placeholder="请输入用户名" autocomplete="off" class="layui-input" value="${sessionScope.user.username}">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">手机号</label>
                <div class="layui-input-block">
                    <input type="text" name="phone" required lay-verify="required|phone" placeholder="请输入手机号" autocomplete="off" class="layui-input" value="${sessionScope.user.phone}">
                </div>
            </div>
            <div class="layui-form-item">
                <div class="btn-group">
                    <button type="button" class="layui-btn layui-btn-normal" lay-submit lay-filter="updateProfile">更新信息</button>
                    <button type="button" class="layui-btn layui-btn-primary" id="changePasswordBtn">修改密码</button>
                </div>
            </div>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/layui@2.6.8/dist/layui.js"></script>
    <script>
        layui.use(['form', 'layer'], function(){
            var form = layui.form;
            var layer = layui.layer;
            var $ = layui.$;

            // 手机号验证规则
            form.verify({
                phone: [/^1\d{10}$/, '请输入正确的手机号']
            });

            // 更新个人信息
            form.on('submit(updateProfile)', function(data){
                var userId = '${sessionScope.user.id}';
                var formData = {
                    id: parseInt(userId),
                    username: data.field.username,
                    phone: data.field.phone
                };

                //将现有信息与修改后的信息进行对比，如果修改后的信息与现有信息相同，则不进行更新
                if(formData.username === '${sessionScope.user.username}' && formData.phone === '${sessionScope.user.phone}'){
                    layer.msg('您的个人信息没有修改，请修改后再提交');
                    return;
                }

                $.ajax({
                    url: '${pageContext.request.contextPath}/users/profile',

                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify(formData),
                    success: function(res){
                        layer.msg('更新成功，请重新登录！');
                    setTimeout(function(){
                        window.location.href = '${pageContext.request.contextPath}/users/login';
                    }, 1500);
                    },
                    error: function(xhr){
                        layer.msg(xhr.responseText || '更新失败');
                    }
                });
                return false;
            });

            // 修改密码按钮点击事件
            $('#changePasswordBtn').on('click', function(){
                layer.open({
                    type: 1,
                    title: '修改密码',
                    area: ['400px', '350px'],
                    content: `
                        <div class="layui-form" style="padding: 20px;">
                            <div class="layui-form-item">
                                <label class="layui-form-label">原密码</label>
                                <div class="layui-input-block">
                                    <input type="password" id="oldPassword" required lay-verify="required" placeholder="请输入原密码" class="layui-input">
                                </div>
                            </div>
                            <div class="layui-form-item">
                                <label class="layui-form-label">新密码</label>
                                <div class="layui-input-block">
                                    <input type="password" id="newPassword" required lay-verify="required" placeholder="请输入新密码" class="layui-input">
                                </div>
                            </div>
                            <div class="layui-form-item">
                                <label class="layui-form-label">确认密码</label>
                                <div class="layui-input-block">
                                    <input type="password" id="confirmPassword" required lay-verify="required" placeholder="请确认新密码" class="layui-input">
                                </div>
                            </div>
                            <div class="layui-form-item" style="margin-top: 30px;">
                                <div class="layui-input-block">
                                    <button class="layui-btn layui-btn-normal" id="submitPassword">确认修改</button>
                                    <button type="reset" class="layui-btn layui-btn-primary" id="resetPassword">重置</button>
                                </div>
                            </div>
                        </div>
                    `,
                    success: function(layero, index){
                        // 重置按钮事件
                        $('#resetPassword').on('click', function(){
                            $('#oldPassword').val('');
                            $('#newPassword').val('');
                            $('#confirmPassword').val('');
                        });

                        // 提交修改密码
                        $('#submitPassword').on('click', function(){
                            var oldPassword = $('#oldPassword').val();
                            var newPassword = $('#newPassword').val();
                            var confirmPassword = $('#confirmPassword').val();
                            var userId = '${sessionScope.user.id}';

                            if(!oldPassword || !newPassword || !confirmPassword){
                                layer.msg('请填写完整信息');
                                return;
                            }

                            if(newPassword !== confirmPassword){
                                layer.msg('两次输入的新密码不一致');
                                return;
                            }

                            var passwordData = {
                                id: parseInt(userId),
                                oldPassword: oldPassword,
                                newPassword: newPassword
                            };

                            $.ajax({
                                url: '${pageContext.request.contextPath}/users/changePassword',
                                type: 'POST',
                                contentType: 'application/json',
                                data: JSON.stringify(passwordData),
                                success: function(res){
                                    layer.msg('密码修改成功，请重新登录');
                                    setTimeout(function(){
                                        window.location.href = '${pageContext.request.contextPath}/users/login';
                                    }, 1500);
                                },
                                error: function(xhr){
                                    layer.msg(xhr.responseText || '密码修改失败');
                                }
                            });
                        });
                    }
                });
            });
        });
    </script>
</body>
</html> 