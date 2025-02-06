<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户管理 - 会议室预订系统</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.6.8/dist/css/layui.css">
    <style>
        body {
            background-color: #f2f2f2;
        }
        .manage-container {
            width: 80%;
            margin: 50px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 4px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .manage-title {
            text-align: center;
            margin-bottom: 20px;
            color: #333;
            font-size: 24px;
        }
    </style>
</head>
<body>
    <div class="manage-container">
        <h2 class="manage-title">用户管理</h2>
        <div class="layui-form-item">
            <input type="text" id="searchPhone" placeholder="手机号" class="layui-input" style="width: 200px; display: inline-block;">
            <input type="text" id="searchUsername" placeholder="用户名" class="layui-input" style="width: 200px; display: inline-block;">
            <button class="layui-btn" id="searchBtn">搜索</button>
        </div>
        <table class="layui-hide" id="userTable" lay-filter="userTable"></table>
        <div id="pagination"></div>
        <button class="layui-btn" id="addUserBtn">添加用户</button>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/layui@2.6.8/dist/layui.js"></script>
    <script>
        layui.use(['layer', 'table', 'laypage'], function(){
            var layer = layui.layer;
            var table = layui.table;
            var $ = layui.$;
            table.render({
                elem: '#userTable',
                url: `${pageContext.request.contextPath}/users/manage/userList`,
                method: 'GET',
                parseData: function(res){ // res 即为原始返回的数据
                  return {
                    "code": res.status, // 解析接口状态
                    "msg": res.message, // 解析提示文本
                    "count": res.total, // 解析数据长度
                    "data": res.users // 解析数据列表
                  };
                },
                  where: { phone: '', username: '' },
                page: true,
                cols: [[
                    {field: 'id', title: 'ID', width: 100},
                    {field: 'username', title: '用户名', width: 150},
                    {field: 'phone', title: '手机号', width: 150},
                    {field: 'userRole', title: '角色', width: 150,templet: function(d){ return d.userRole.description; }},
                    {field: 'status', title: '状态', width: 100, templet: function(d){ return d.status === 1 ? '启用' : '禁用'; }},
                    {field: 'createdAt', title: '创建时间', width: 180},
                    {field: 'updatedAt', title: '更新时间', width: 180},
                    {fixed: 'right', title: '操作', toolbar: '#operationBar', width: 150}
                ]]
            });

            $('#searchBtn').on('click', function() {
                var phone = $('#searchPhone').val();
                var username = $('#searchUsername').val();
                table.reload('userTable', {
                    where: { phone, username },
                    page: { curr: 1 }
                });
            });

            table.on('tool(userTable)', function(obj){
                var data = obj.data;
                console.log('这是table data',data)
                if(obj.event === 'edit'){
                    layer.open({
                        type: 1,
                        title: '编辑用户',
                        content: '<div style="padding: 20px;">' +
                                    //显示id但是不能修改
                                '<input type="text" id="editId" value="' + data.id + '" required lay-verify="required" class="layui-input" style="margin-bottom: 10px; display: none;">' +
                                 '<input type="text" id="editUsername" value="' + data.username + '" required lay-verify="required" class="layui-input" style="margin-bottom: 10px;">' +
                                 '<input type="text" id="editPhone" value="' + data.phone + '" required lay-verify="required|phone" class="layui-input" style="margin-bottom: 10px;">' + 
                                 '<select id="editRole" class="layui-select" required lay-verify="required" style="margin-bottom: 10px;">' +
                                    '<option value="">请选择角色</option>' +
                                    '<option value="1">管理员</option>' +
                                    '<option value="2">用户</option>' +
                                    '</select>' +
                                        //更改status
                                '<select id="editStatus" class="layui-select" required lay-verify="required" style="margin-bottom: 10px;">' +
                                    '<option value="1">启用</option>' +
                                    '<option value="0">禁用</option>' +
                                    '</select>' +
                                 '<button class="layui-btn" id="editUserBtn"  >保存</button>' +
                                 '</div>',
                        area: ['400px', '300px'],
                        success:function(layero,index){
                            $('#editUserBtn').on('click', function() {
                //将id、name、phone、status封装成user对象，将id、userRole封装成userRole对象
                var user = {
                    //将id值转换为long
                    id: parseInt($('#editId').val()),
                    username: $('#editUsername').val(),
                    phone: $('#editPhone').val(),
                    status: $('#editStatus').val()
                };
                var userRole = {
                    //将id值转换为long
                    userId: parseInt($('#editId').val()),
                    roleId: $('#editRole').val()
                };
                //将user和userRole两个对象合成一个对象
                var updateUser = {
                    user: user,
                    userRole: userRole
                };
                $.ajax({
                    url: '${pageContext.request.contextPath}/users/manage/update',
                    type: 'put',
                    contentType: 'application/json',
                    data: JSON.stringify(updateUser),
                    success: function(res){
                        layer.msg('更新成功');
                        layer.closeAll();
                        table.reload('userTable');
                    },
                    error: function(xhr){
                                layer.msg(xhr.responseText || '更新失败');
                            }
                        });
                    });
                        }

                    });
                    layer.msg('编辑用户：' + data.username);
                    // 编辑逻辑
                } else if(obj.event === 'delete'){
                    layer.confirm('确定要删除用户吗', function(index){
                        console.log('这是userId2',data.id)
                        console.log('这是userName',data.username)
                        $.ajax({
                            url: '${pageContext.request.contextPath}/users/manage/delete/' + data.id,
                            type: 'DELETE',
                            contentType: 'application/json',
                            success: function(res){
                                layer.msg('删除成功');
                                obj.del();
                                layer.close(index);
                                table.reload('userTable');
                            },
                            error: function(xhr){
                                layer.msg(xhr.responseText || '删除失败');
                            }
                        });
                        // 删除逻辑
                    });
                }
            });

             

            $('#addUserBtn').on('click', function() {
                layer.open({
                    type: 1,
                    title: '添加用户',
                    content: '<div style="padding: 20px;">' +
                             '<input type="text" id="newUsername" required lay-verify="required" placeholder="用户名" autocomplete="off" class="layui-input" style="margin-bottom: 10px;">' +
                             '<input type="text" id="newPhone" required lay-verify="required|phone" placeholder="手机号" autocomplete="off" class="layui-input" style="margin-bottom: 10px;">' +
                             '<input type="password" id="newPassword" required lay-verify="required" placeholder="密码" autocomplete="off" class="layui-input" style="margin-bottom: 10px;">' +
                             '<button class="layui-btn" id="addUserBtnSave">保存</button>' +
                             '</div>',
                    area: ['400px', '300px']
                });

                $('#addUserBtnSave').on('click', function() {
                    var newUser = {
                        username: $('#newUsername').val(),
                        phone: $('#newPhone').val(),
                        password: $('#newPassword').val()
                    };
                    $.ajax({
                        url: '${pageContext.request.contextPath}/users/manage/add',
                        type: 'POST',
                        contentType: 'application/json',
                        data: JSON.stringify(newUser),
                        success: function(res){
                            layer.msg('添加成功');
                            layer.closeAll();
                            table.reload('userTable');
                        },
                        error: function(xhr){
                            layer.msg(xhr.responseText || '添加失败');
                        }
                    });
                });
            });
        });
    </script>

    <script type="text/html" id="operationBar">
        <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
        <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete">删除</a>
    </script>
</body>
</html> 