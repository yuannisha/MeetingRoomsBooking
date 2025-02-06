<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>预订记录 - 会议室预订系统</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.6.8/dist/css/layui.css">
    <style>
        .record-container {
            width: 95%;
            margin: 20px auto;
            padding: 20px;
            background-color: #fff;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-radius: 10px;
        }
        .record-title {
            text-align: center;
            margin-bottom: 20px;
            color: #333;
            font-size: 24px;
            font-weight: bold;
        }
        .record-card {
            background: #fff;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            position: relative;
        }
        .record-status {
            position: absolute;
            top: 10px;
            right: 10px;
            padding: 4px 12px;
            border-radius: 4px;
            color: #fff;
            font-size: 12px;
        }
        .status-pending { background-color: #FFB800; }
        .status-approved { background-color: #009688; }
        .status-rejected { background-color: #FF5722; }
        .status-cancelled { background-color: #999; }
        .status-completed { background-color: #5FB878; }
        .record-info {
            margin-top: 10px;
            color: #666;
            font-size: 14px;
            line-height: 1.8;
        }
        .record-actions {
            margin-top: 15px;
            text-align: right;
        }
        .layui-tab-title {
            border-bottom: 2px solid #1E9FFF;
        }
        .layui-tab-brief > .layui-tab-title .layui-this {
            color: #1E9FFF;
        }
        .layui-tab-brief > .layui-tab-more li.layui-this:after,
        .layui-tab-brief > .layui-tab-title .layui-this:after {
            border-bottom: 2px solid #1E9FFF;
        }
    </style>
</head>
<body>
    <div class="record-container">
        <h2 class="record-title">预订记录</h2>
        
        <div class="layui-tab layui-tab-brief" lay-filter="recordTab">
            <ul class="layui-tab-title">
                <li class="layui-this">全部记录</li>
                <li>待审核</li>
                <li>已通过</li>
                <li>已取消</li>
            </ul>
            <div class="layui-tab-content">
                <div class="layui-tab-item layui-show">
                    <table id="recordTable" lay-filter="recordTable"></table>
                </div>
                <div class="layui-tab-item">
                    <table id="pendingTable" lay-filter="recordTable"></table>
                </div>
                <div class="layui-tab-item">
                    <table id="approvedTable" lay-filter="recordTable"></table>
                </div>
                <div class="layui-tab-item">
                    <table id="cancelledTable" lay-filter="recordTable"></table>
                </div>
            </div>
        </div>
    </div>

    <!-- 表格操作按钮模板 -->
    <script type="text/html" id="actionBar">
        {{# if(d.operations.canCancel) { }}
        <button class="layui-btn layui-btn-danger layui-btn-xs" lay-event="cancel">
            <i class="layui-icon layui-icon-close"></i>取消预订
        </button>
        {{# } }}
        
        {{# if(d.operations.canReview) { }}
        <button class="layui-btn layui-btn-normal layui-btn-xs" lay-event="approve">
            <i class="layui-icon layui-icon-ok"></i>通过
        </button>
        <button class="layui-btn layui-btn-danger layui-btn-xs" lay-event="reject">
            <i class="layui-icon layui-icon-close"></i>拒绝
        </button>
        {{# } }}
    </script>

    <script src="https://cdn.jsdelivr.net/npm/layui@2.6.8/dist/layui.js"></script>
    <script>
        layui.use(['table', 'element', 'layer'], function(){
            var table = layui.table;
            var element = layui.element;
            var layer = layui.layer;
            var $ = layui.$;
            
            // 渲染表格的通用配置
            var tableConfig = {
                page: true,
                limit: 10,
                cols: [[
                    {field: 'id', title: 'ID', width: 80, sort: true},
                    {field: 'roomName', title: '会议室', width: 120},
                    {field: 'title', title: '会议主题', width: 200},
                    {field: 'stringDate', title: '日期', width: 120},
                    {field: 'startTime', title: '开始时间', width: 100, templet: function(d){
                        return d.startTime + ':00';
                    }},

                    {field: 'endTime', title: '结束时间', width: 100, templet: function(d){
                        return d.endTime + ':00';
                    }},
                    {field: 'attendees', title: '参会人员', width: 200},
                    {field: 'status', title: '状态', width: 100, templet: function(d){
                        var statusMap = {
                            'PENDING': '<span class="layui-badge layui-bg-orange">待审核</span>',
                            'APPROVED': '<span class="layui-badge layui-bg-green">已通过</span>',
                            'REJECTED': '<span class="layui-badge layui-bg-red">已拒绝</span>',
                            'CANCELLED': '<span class="layui-badge layui-bg-gray">已取消</span>'
                        };
                        return statusMap[d.status] || d.status;
                    }},

                    {title: '操作', width: 200, toolbar: '#actionBar', fixed: 'right'}
                ]],
                response: {
                    statusCode: 200
                },
                parseData: function(res){
                    return {
                        "code": res.status,
                        "msg": res.msg,
                        "count": res.count,
                        "data": res.data
                    };

                }
            };

            // 渲染不同状态的表格
            function renderTable(elem, status) {
                var config = Object.assign({}, tableConfig, {
                    elem: elem,
                    url: '${pageContext.request.contextPath}/bookings/record/list',
                    where: status ? {status: status} : {}
                });
                return table.render(config);
            }

            // 初始化所有表格
            var tables = {
                'all': renderTable('#recordTable'),
                'pending': renderTable('#pendingTable', 'PENDING'),
                'approved': renderTable('#approvedTable', 'APPROVED'),
                'cancelled': renderTable('#cancelledTable', 'CANCELLED')
            };


            // 监听表格工具条
            table.on('tool(recordTable)', function(obj){
                var data = obj.data;
                if(obj.event === 'cancel'){
                    layer.confirm('确定要取消这个预订吗？', function(index){
                        $.ajax({
                            url: '${pageContext.request.contextPath}/bookings/cancel/' + data.id,
                            type: 'POST',
                            success: function(res){
                                layer.msg('取消成功');
                                // 刷新所有表格
                                Object.values(tables).forEach(function(t) {
                                    t.reload();
                                });
                            },
                            error: function(xhr){
                                layer.msg(xhr.responseText || '取消失败');
                            }
                        });
                        layer.close(index);
                    });
                } else if(obj.event === 'approve' || obj.event === 'reject'){
                    var approved = obj.event === 'approve';
                    layer.confirm('确定要' + (approved ? '通过' : '拒绝') + '这个预订申请吗？', function(index){
                        $.ajax({
                            url: '${pageContext.request.contextPath}/bookings/review/' + data.id,
                            type: 'POST',
                            data: {
                                approved: approved
                            },
                            success: function(res){
                                layer.msg(approved ? '已通过' : '已拒绝');
                                // 刷新所有表格
                                Object.values(tables).forEach(function(t) {
                                    t.reload();
                                });
                            },
                            error: function(xhr){
                                layer.msg(xhr.responseText || '操作失败');
                            }
                        });
                        layer.close(index);
                    });
                }
            });

            // 监听标签页切换
            element.on('tab(recordTab)', function(){
                // 切换标签页时重新渲染表格
                Object.values(tables).forEach(function(t) {
                    t.resize();
                });
            });
        });
    </script>
</body>
</html> 