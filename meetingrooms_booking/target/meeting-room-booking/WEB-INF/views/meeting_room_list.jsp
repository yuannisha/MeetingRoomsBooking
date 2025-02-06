<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>会议室列表 - 会议室预订系统</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/layui@2.6.8/dist/css/layui.css">
    <style>
        body {
            background-color: #f5f7fa;
        }
        .list-container {
            width: 90%;
            margin: 30px auto;
            padding: 20px;
        }
        .list-title {
            text-align: center;
            margin-bottom: 30px;
            color: #333;
            font-size: 24px;
            font-weight: bold;
        }
        .room-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            padding: 20px;
        }
        .room-card {
            background: #fff;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        .room-card:hover {
            transform: translateY(-5px);
        }
        .room-status {
            position: absolute;
            top: 0;
            right: 0;
            padding: 5px 15px;
            color: #fff;
            border-bottom-left-radius: 10px;
        }
        .status-active {
            background-color: #009688;
        }
        .status-inactive {
            background-color: #FF5722;
        }
        .room-free {
            position: absolute;
            top: 30px;
            right: 0;
            padding: 5px 15px;
            color: #fff;
            border-bottom-left-radius: 10px;
        }
        .free-yes {
            background-color: #5FB878;
        }
        .free-no {
            background-color: #FFB800;
        }
        .room-icon {
            width: 60px;
            height: 60px;
            margin-bottom: 15px;
        }
        .room-info {
            margin-top: 20px;
        }
        .room-name {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 10px;
            color: #333;
        }
        .room-detail {
            color: #666;
            margin-bottom: 5px;
            font-size: 14px;
        }
        .search-box {
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        .layui-input {
            border-radius: 4px;
        }
        .layui-btn {
            border-radius: 4px;
        }
        .room-actions {
            margin-top: 15px;
            text-align: right;
        }
        .pagination-container {
            margin-top: 20px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="list-container">
        <h2 class="list-title">会议室预订</h2>
        
        <div class="search-box">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <input type="text" id="searchName" placeholder="请输入会议室名称" class="layui-input">
                </div>
                <div class="layui-inline">
                    <button class="layui-btn layui-btn-normal" id="searchBtn">

                        <i class="layui-icon layui-icon-search"></i> 搜索
                    </button>
                </div>
            </div>
        </div>

        <div class="room-grid" id="roomContainer"></div>
        
        <div class="pagination-container" id="pagination"></div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/layui@2.6.8/dist/layui.js"></script>
    <script>
        layui.use(['layer', 'laypage'], function(){
            var layer = layui.layer;
            var laypage = layui.laypage;
            var $ = layui.$;
            
            // 会议室图标SVG
            var roomSvg = `
                <svg t="1738848490625" class="room-icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="4229" width="200" height="200"><path d="M523.73504 319.29344h-204.8c-16.896 0-30.72-13.824-30.72-30.72s13.824-30.72 30.72-30.72h204.8c16.896 0 30.72 13.824 30.72 30.72s-13.824 30.72-30.72 30.72zM605.65504 452.41344h-286.72c-16.896 0-30.72-13.824-30.72-30.72s13.824-30.72 30.72-30.72h286.72c16.896 0 30.72 13.824 30.72 30.72s-13.824 30.72-30.72 30.72z" fill="#1296db" p-id="4230"></path><path d="M569.98912 669.2864c-2.41664 0-19.34336-16.92672-7.24992-48.35328 26.59328-26.60352 48.36352-70.12352 48.36352-113.64352 0-65.28-45.93664-99.13344-94.30016-99.13344-50.78016 0-94.30016 33.85344-94.30016 99.13344 0 43.52 19.34336 87.05024 45.93664 113.64352 9.66656 26.59328-7.24992 45.93664-12.09344 48.35328-53.1968 19.34336-113.64352 53.1968-113.64352 89.46688v12.09344c0 45.93664 89.46688 58.03008 174.09024 58.03008 82.20672 0 171.6736-9.66656 171.6736-58.03008v-12.09344c-2.41664-36.28032-65.28-72.54016-118.4768-89.46688z m0 0" fill="#1296db" p-id="4231"></path><path d="M729.56928 582.23616c-2.41664 0-16.92672-4.83328-7.24992-33.85344 24.17664-24.17664 41.10336-65.28 41.10336-106.38336 0-60.44672-38.68672-94.30016-87.05024-94.30016-33.8432 0-65.28 16.92672-77.37344 50.78016 29.00992 24.17664 48.36352 60.44672 48.36352 108.8 0 50.78016-24.17664 99.13344-50.78016 130.57024 41.10336 14.51008 103.97696 45.93664 120.89344 94.30016 62.86336-2.41664 120.89344-16.92672 120.89344-53.1968v-12.09344c2.42688-36.25984-55.6032-67.69664-108.8-84.62336z m-435.22048 0c2.41664 0 16.92672-4.83328 7.24992-33.85344-24.17664-24.17664-41.10336-65.28-41.10336-106.38336 2.41664-60.44672 41.10336-94.30016 87.04-94.30016 33.85344 0 65.29024 16.92672 77.37344 50.78016-29.02016 24.17664-48.35328 60.44672-48.35328 108.8 0 50.78016 24.17664 99.13344 50.78016 130.57024-41.10336 14.51008-103.96672 45.93664-120.89344 94.30016-62.86336-2.41664-120.89344-16.92672-120.89344-53.1968v-12.09344c0-36.25984 58.03008-67.69664 108.8-84.62336z m0 0" fill="#1296db" p-id="4232"></path><path d="M855.04 256.57344h-686.08c-16.896 0-30.72-13.824-30.72-30.72s13.824-30.72 30.72-30.72h686.08c16.896 0 30.72 13.824 30.72 30.72s-13.824 30.72-30.72 30.72z" fill="#1296db" p-id="4233"></path><path d="M138.24 471.61344v-245.76c0-16.896 13.824-30.72 30.72-30.72s30.72 13.824 30.72 30.72v245.76c0 16.896-13.824 30.72-30.72 30.72s-30.72-13.824-30.72-30.72zM824.32 471.61344v-245.76c0-16.896 13.824-30.72 30.72-30.72s30.72 13.824 30.72 30.72v245.76c0 16.896-13.824 30.72-30.72 30.72s-30.72-13.824-30.72-30.72z" fill="#1296db" p-id="4234"></path></svg>
            `;

            function loadRooms(page = 1) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/meetingRooms/roomsList',
                    method: 'GET',
                    data: {
                        page: page,
                        limit: 8,
                        name: $('#searchName').val()
                    },
                    success: function(res) {
                        var roomsHtml = '';
                        console.log("这是res",res);
                        res.meetingRooms.forEach(function(room) {
                            console.log("这是room",room);
                            let buttonHtml = '';
                            let buttonhtml2 = '';
                            let buttonhtml3 = '';
                            if (room.status == 1 && room.isFree == 1) {
                                buttonHtml = `
                                    <button class="layui-btn layui-btn-normal" onclick="bookRoom(` + room.id +`)">
                                        <i class="layui-icon layui-icon-date"></i> 预订
                                    </button>
                                `;
                            } else {
                                buttonHtml = `
                                    <button class="layui-btn layui-btn-disabled">
                                        <i class="layui-icon layui-icon-close"></i> 不可预订
                                    </button>
                                `;
                            }
                            console.log("这是buttonHtml",buttonHtml);
                            if(room.status == 1){
                                buttonhtml2 = `
                                    <div class="room-status status-active">
                                        启用
                                    </div>
                                `;
                            }else{
                                buttonhtml2 = `
                                    <div class="room-status status-inactive">
                                        禁用
                                    </div>
                                `;
                            }

                            if(room.isFree == 1){   
                                buttonhtml3 = `
                                    <div class="room-free free-yes">
                                        空闲
                                    </div>
                                `;
                            }else{
                                buttonhtml3 = `
                                    <div class="room-free free-no">
                                        使用中
                                    </div>
                                `;
                            }                            

                            roomsHtml += `
                                <div class="room-card">
                                     ` + buttonhtml2 + buttonhtml3 + roomSvg +`
                                    <div class="room-info">
                                        <div class="room-name"> `+ room.name + `</div>
                                        <div class="room-detail">
                                            <i class="layui-icon layui-icon-user"></i> 容纳人数： `+ room.capacity +`人
                                        </div>
                                        <div class="room-detail">
                                            <i class="layui-icon layui-icon-location"></i> 位置： `+ room.location + `
                                        </div>
                                    </div>
                                    <div class="room-actions">
                                        <button class="layui-btn layui-btn-normal" onclick="viewSchedule(` + room.id + `)">
                                            <i class="layui-icon layui-icon-log"></i> 查看预订情况
                                        </button>
                                        `+ buttonHtml +`
                                    </div>
                                </div>
                            `;
                        });
                        
                        $('#roomContainer').html(roomsHtml);
                        
                        // 设置分页
                        laypage.render({
                            elem: 'pagination',
                            count: res.total,
                            limit: 8,
                            curr: page,
                            theme: '#1E9FFF',
                            layout: ['prev', 'page', 'next', 'count'],
                            jump: function(obj, first) {
                                if(!first) {
                                    loadRooms(obj.curr);
                                }
                            }
                        });
                    }
                });
            }

            // 初始加载
            loadRooms();

            // 搜索功能
            $('#searchBtn').on('click', function() {
                loadRooms(1);
            });

            // 预订会议室
            window.bookRoom = function(roomId) {
                console.log("这是roomId",roomId);
                layer.open({
                    type: 1,
                    title: '预订会议室',
                    area: ['500px', '600px'],
                    content: `
                        <div class="layui-form" lay-filter="bookingForm" style="padding: 20px;">
                            <div class="layui-form-item">
                                <label class="layui-form-label">会议主题</label>
                                <div class="layui-input-block">
                                    <input type="text" name="title" id="bookTitle" required lay-verify="required" placeholder="请输入会议主题" autocomplete="off" class="layui-input">
                                </div>
                            </div>
                            <div class="layui-form-item">
                                <label class="layui-form-label">预订日期</label>
                                <div class="layui-input-block">
                                    <input type="text" name="date" id="bookDate" required lay-verify="required" placeholder="请选择日期" autocomplete="off" class="layui-input" readonly>
                                </div>
                            </div>
                            <div class="layui-form-item">
                                <label class="layui-form-label">开始时间</label>
                                <div class="layui-input-block">
                                    <select name="startTime" id="bookStartTime" required lay-verify="required" lay-filter="startTime">
                                        <option value="">请选择开始时间</option>
                                    </select>
                                </div>
                            </div>
                            <div class="layui-form-item">
                                <label class="layui-form-label">结束时间</label>
                                <div class="layui-input-block">
                                    <select name="endTime" id="bookEndTime" required lay-verify="required" lay-filter="endTime">
                                        <option value="">请选择结束时间</option>
                                    </select>
                                </div>
                            </div>
                            <div class="layui-form-item layui-form-text">
                                <label class="layui-form-label">参会人员</label>
                                <div class="layui-input-block">
                                    <textarea name="attendees" id="bookAttendees" required lay-verify="required" placeholder="请输入参会人员" class="layui-textarea"></textarea>
                                </div>
                            </div>
                            <div class="layui-form-item layui-form-text">
                                <label class="layui-form-label">会议描述</label>
                                <div class="layui-input-block">
                                    <textarea name="description" id="bookDescription" placeholder="请输入会议描述" class="layui-textarea"></textarea>
                                </div>
                            </div>
                            <div class="layui-form-item">
                                <div class="layui-input-block">
                                    <button type="button" class="layui-btn" id="submitBtn">确认预订</button>
                                    <button type="button" class="layui-btn layui-btn-primary" id="resetBtn">重置</button>
                                </div>
                            </div>
                        </div>
                    `,
                    success: function(layero, index) {
                        layui.use(['form', 'laydate'], function(){
                            var form = layui.form;
                            var laydate = layui.laydate;
                            
                            // 初始化日期选择器
                            laydate.render({
                                elem: '#bookDate',
                                min: 0,
                                max: 2,
                                value: new Date()
                            });

                            // 重置按钮点击事件
                            $('#resetBtn').on('click', function() {
                                // 重置所有输入框
                                $('#bookTitle').val('');
                                $('#bookDate').val('');
                                $('#bookStartTime').val('');
                                $('#bookEndTime').val('');
                                $('#bookAttendees').val('');
                                $('#bookDescription').val('');
                                // 重新渲染表单
                                form.render();
                            });

                            // 初始化时间选项
                            function initTimeOptions() {
                                var startSelect = $('#bookStartTime');
                                var endSelect = $('#bookEndTime');
                                
                                startSelect.empty().append('<option value="">请选择开始时间</option>');
                                endSelect.empty().append('<option value="">请选择结束时间</option>');
                                
                                for(var i = 6; i <= 23; i++) {
                                    startSelect.append('<option value="' + i + '">' + i + ':00</option>');
                                }
                                
                                form.render('select');
                            }

                            // 监听开始时间变化
                            form.on('select(startTime)', function(data){
                                var startTime = parseInt(data.value);
                                var endSelect = $('#bookEndTime');
                                
                                endSelect.empty().append('<option value="">请选择结束时间</option>');
                                
                                for(var i = startTime + 1; i <= 23; i++) {
                                    endSelect.append('<option value="' + i + '">' + i + ':00</option>');
                                }
                                
                                form.render('select');
                            });

                            // 初始化默认时间选项
                            initTimeOptions();

                            // 绑定提交按钮点击事件
                            $('#submitBtn').off('click').on('click', function() {
                                var data = {
                                    title: $('#bookTitle').val(),
                                    date: $('#bookDate').val(),
                                    startTime: $('#bookStartTime').val(),
                                    endTime: $('#bookEndTime').val(),
                                    attendees: $('#bookAttendees').val(),
                                    description: $('#bookDescription').val()
                                };

                                if (!data.title || !data.date || !data.startTime || !data.endTime || !data.attendees) {
                                    layer.msg('请填写完整信息');
                                    return false;
                                }

                                // 检查时间段是否可用
                                $.ajax({
                                    url: '${pageContext.request.contextPath}/bookings/checkTimeSlot',
                                    type: 'GET',
                                    data: {
                                        roomId: roomId,
                                        date: data.date,
                                        startTime: data.startTime,
                                        endTime: data.endTime
                                    },
                                    success: function(res) {
                                        if (res.available) {
                                            // 提交预订
                                            $.ajax({
                                                url: '${pageContext.request.contextPath}/bookings/add',
                                                type: 'POST',
                                                contentType: 'application/json',
                                                data: JSON.stringify({
                                                    roomId: roomId,
                                                    title: data.title,
                                                    date: data.date,
                                                    startTime: parseInt(data.startTime),
                                                    endTime: parseInt(data.endTime),
                                                    attendees: data.attendees,
                                                    description: data.description
                                                }),
                                                success: function(res) {
                                                    layer.msg('预订成功');
                                                    layer.closeAll('page');
                                                    loadRooms();
                                                },
                                                error: function(xhr) {
                                                    layer.msg(xhr.responseText || '预订失败');
                                                }
                                            });
                                        } else {
                                            layer.msg('该时间段已被预订，请选择其他时间');
                                        }
                                    },
                                    error: function(xhr) {
                                        layer.msg(xhr.responseText || '检查时间段失败');
                                    }
                                });
                            });
                        });
                    }
                });
            };

            // 添加查看预订情况的函数
            window.viewSchedule = function(roomId) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/bookings/room/' + roomId + '/schedule',
                    type: 'GET',
                    success: function(res) {
                        if (res.status === 0) {
                            let scheduleHtml = '<div class="layui-tab layui-tab-brief" lay-filter="scheduleTab">';
                            scheduleHtml += '<ul class="layui-tab-title">';
                            
                            // 添加标签页标题
                            res.schedule.forEach(function(day, index) {
                                let date = new Date(day.date);
                                let title = index === 0 ? '今天' : (index === 1 ? '明天' : '后天');
                                title += ' (' + day.date + ')';
                                scheduleHtml += '<li' + (index === 0 ? ' class="layui-this"' : '') + '>' + title + '</li>';
                            });
                            
                            scheduleHtml += '</ul><div class="layui-tab-content">';
                            
                            // 添加每天的预订情况
                            res.schedule.forEach(function(day, index) {
                                scheduleHtml += '<div class="layui-tab-item' + (index === 0 ? ' layui-show' : '') + '">';
                                
                                if (day.bookings && day.bookings.length > 0) {
                                    scheduleHtml += '<table class="layui-table">';
                                    scheduleHtml += '<thead><tr><th>时间段</th><th>会议主题</th><th>参会人员</th></tr></thead>';
                                    scheduleHtml += '<tbody>';
                                    
                                    day.bookings.forEach(function(booking) {
                                        scheduleHtml += '<tr>';
                                        scheduleHtml += '<td>' + booking.startTime + ':00 - ' + booking.endTime + ':00</td>';
                                        scheduleHtml += '<td>' + booking.title + '</td>';
                                        scheduleHtml += '<td>' + booking.attendees + '</td>';
                                        scheduleHtml += '</tr>';
                                    });
                                    
                                    scheduleHtml += '</tbody></table>';
                                } else {
                                    scheduleHtml += '<div class="layui-text" style="padding: 20px; text-align: center;">当天暂无预订</div>';
                                }
                                
                                scheduleHtml += '</div>';
                            });
                            
                            scheduleHtml += '</div></div>';
                            
                            layer.open({
                                type: 1,
                                title: '会议室预订情况',
                                area: ['800px', '600px'],
                                content: scheduleHtml,
                                success: function() {
                                    layui.element.render('tab', 'scheduleTab');
                                }
                            });
                        } else {
                            layer.msg(res.message || '获取预订情况失败');
                        }
                    },
                    error: function(xhr) {
                        layer.msg(xhr.responseText || '获取预订情况失败');
                    }
                });
            };
        });
    </script>
</body>
</html> 