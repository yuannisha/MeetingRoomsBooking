<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>会议室管理 - 会议室预订系统</title>
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
        <h2 class="manage-title">会议室管理</h2>
        <div class="layui-form-item">
            <input type="text" id="searchName" placeholder="会议室名称" class="layui-input" style="width: 200px; display: inline-block;">
            <button class="layui-btn" id="searchBtn">搜索</button>
        </div>
        <table class="layui-hide" id="meetingRoomTable" lay-filter="meetingRoomTable"></table>
        <div id="pagination"></div>
        <button class="layui-btn" id="addMeetingRoomBtn">添加会议室</button>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/layui@2.6.8/dist/layui.js"></script>
    <script>
        layui.use(['layer', 'table', 'laypage'], function(){
            var layer = layui.layer;
            var table = layui.table;
            var $ = layui.$;
            table.render({
                elem: '#meetingRoomTable',
                url: `${pageContext.request.contextPath}/meetingRooms/list`,
                method: 'GET',
                parseData: function(res){
                  return {
                    "code": res.status,
                    "msg": res.message,
                    "count": res.total,
                    "data": res.meetingRooms
                  };
                },
                where: { name: '' },
                page: true,
                cols: [[
                    {field: 'id', title: 'ID', width: 100},
                    {field: 'name', title: '会议室名称', width: 150},
                    {field: 'capacity', title: '容纳人数', width: 150},
                    {field: 'location', title: '位置', width: 150},
                    {field: 'status', title: '状态', width: 100, templet: function(d){ return d.status === 1 ? '启用' : '禁用'; }},
                    {field: 'isFree', title: '是否空闲', width: 100, templet: function(d){ return d.isFree === 1 ? '空闲' : '不空闲'; }},
                    {field: 'createdAt', title: '创建时间', width: 180},
                    {field: 'updatedAt', title: '更新时间', width: 180},
                    {fixed: 'right', title: '操作', toolbar: '#operationBar', width: 150}
                ]]
            });

            $('#searchBtn').on('click', function() {
                var name = $('#searchName').val();
                table.reload('meetingRoomTable', {
                    where: { name },
                    page: { curr: 1 }
                });
            });

            table.on('tool(meetingRoomTable)', function(obj){
                var data = obj.data;
                if(obj.event === 'edit'){
                    layer.open({
                        type: 1,
                        title: '编辑会议室',
                        content: '<div style="padding: 20px;">' +
                                 '<input type="text" id="editId" value="' + data.id + '" required lay-verify="required" class="layui-input" style="margin-bottom: 10px; display: none;">' +
                                 '<input type="text" id="editName" value="' + data.name + '" required lay-verify="required" class="layui-input" style="margin-bottom: 10px;">' +
                                 '<input type="text" id="editCapacity" value="' + data.capacity + '" required lay-verify="required|number" class="layui-input" style="margin-bottom: 10px;">' +
                                 '<input type="text" id="editLocation" value="' + data.location + '" required lay-verify="required" class="layui-input" style="margin-bottom: 10px;">' +
                                 '<select id="editStatus" class="layui-select" required lay-verify="required" style="margin-bottom: 10px;">' +
                                    '<option value="1">启用</option>' +
                                    '<option value="0">禁用</option>' +
                                    '</select>' +
                                    '<select id="editIsFree" class="layui-select" required lay-verify="required" style="margin-bottom: 10px;">' +
                                        '<option value="1">空闲</option>' +
                                        '<option value="0">不空闲</option>' +
                                    '</select>' +
                                 '<button class="layui-btn" id="editMeetingRoomBtn">保存</button>' +
                                 '</div>',
                        area: ['400px', '400px'],

                        success:function(layero,index){
                            $('#editMeetingRoomBtn').on('click', function() {
                                var meetingRoom = {
                                    id: parseInt($('#editId').val()),
                                    name: $('#editName').val(),
                                    capacity: $('#editCapacity').val(),
                                    location: $('#editLocation').val(),
                                    status: $('#editStatus').val(),
                                    isFree: $('#editIsFree').val()

                                };
                                $.ajax({
                                    url: '${pageContext.request.contextPath}/meetingRooms/update',
                                    type: 'put',
                                    contentType: 'application/json',
                                    data: JSON.stringify(meetingRoom),
                                    success: function(res){
                                        layer.msg('更新成功');
                                        layer.closeAll();
                                        table.reload('meetingRoomTable');
                                    },
                                    error: function(xhr){
                                        layer.msg(xhr.responseText || '更新失败');
                                    }
                                });
                            });
                        }
                    });
                } else if(obj.event === 'delete'){
                    layer.confirm('确定要删除会议室吗', function(index){
                        $.ajax({
                            url: '${pageContext.request.contextPath}/meetingRooms/delete/' + data.id,
                            type: 'DELETE',
                            contentType: 'application/json',
                            success: function(res){
                                layer.msg('删除成功');
                                obj.del();
                                layer.close(index);
                                table.reload('meetingRoomTable');
                            },
                            error: function(xhr){
                                layer.msg(xhr.responseText || '删除失败');
                            }
                        });
                    });
                }
            });

            $('#addMeetingRoomBtn').on('click', function() {
                layer.open({
                    type: 1,
                    title: '添加会议室',
                    content: '<div style="padding: 20px;">' +
                             '<input type="text" id="newName" required lay-verify="required" placeholder="会议室名称" autocomplete="off" class="layui-input" style="margin-bottom: 10px;">' +
                             '<input type="text" id="newCapacity" required lay-verify="required|number" placeholder="容纳人数" autocomplete="off" class="layui-input" style="margin-bottom: 10px;">' +
                             '<input type="text" id="newLocation" required lay-verify="required" placeholder="位置" autocomplete="off" class="layui-input" style="margin-bottom: 10px;">' +
                             '<select id="newStatus" class="layui-select" required lay-verify="required" style="margin-bottom: 10px;">' +
                                '<option value="1">启用</option>' +
                                '<option value="0">禁用</option>' +
                                '</select>' +
                                '<select id="newIsFree" class="layui-select" required lay-verify="required" style="margin-bottom: 10px;">' +
                                    '<option value="1">空闲</option>' +
                                    '<option value="0">不空闲</option>' +
                                '</select>' +
                             '<button class="layui-btn" id="addMeetingRoomBtnSave">保存</button>' +
                             '</div>',
                    area: ['400px', '400px']

                });

                $('#addMeetingRoomBtnSave').on('click', function() {
                    var newMeetingRoom = {
                        name: $('#newName').val(),
                        capacity: $('#newCapacity').val(),
                        location: $('#newLocation').val(),
                        status: $('#newStatus').val(),
                        isFree: $('#newIsFree').val()
                    };

                    $.ajax({
                        url: '${pageContext.request.contextPath}/meetingRooms/add',
                        type: 'POST',
                        contentType: 'application/json',
                        data: JSON.stringify(newMeetingRoom),
                        success: function(res){
                            layer.msg('添加成功');
                            layer.closeAll();
                            table.reload('meetingRoomTable');
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