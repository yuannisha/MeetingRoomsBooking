# 会议室预订系统

## 项目概述
这是一个基于SSM(Spring + SpringMVC + MyBatis)框架开发的会议室预订系统，主要用于管理和预订会议室资源。系统支持用户管理、会议室管理、预订管理等功能，采用RBAC权限控制模型，分为管理员和普通用户两种角色。

本系统旨在解决传统会议室预订流程繁琐、信息不透明、资源利用率低下等问题，为企业或组织提供一个高效、便捷的会议室资源管理平台。

## 项目介绍
会议室预订系统是一个基于Web的应用程序，为企业或组织提供会议室资源的全方位管理。系统以用户友好的界面和高效的后台处理能力，使会议室的预订和管理变得简单高效。

### 用户可以进行的操作
1. **普通用户操作**
   - 查看可用会议室列表及详情
   - 按条件筛选会议室（容量、位置、设备等）
   - 申请预订会议室，指定日期、时间段和会议主题
   - 查看个人预订记录，包括待审核、已通过、已拒绝和已取消的预订
   - 取消尚未开始的会议预订（需在开始时间前一小时以上）
   - 修改个人信息和登录密码
   - 查看会议室当前预订状态和可用时段

2. **管理员用户操作**
   - 管理会议室：添加、编辑、删除会议室信息
   - 审批会议室预订申请：审核通过或拒绝
   - 管理用户：添加、编辑、禁用/启用用户账号
   - 查看所有预订记录：可查看所有用户的预订记录
   - 查询和统计会议室使用情况
   - 系统设置：修改系统参数、维护基础数据
   - 可以取消任何预订

### 业务流程
1. **会议室预订流程**
   - 用户登录系统
   - 浏览并选择合适的会议室
   - 选择预订日期和时间段
   - 填写会议主题、参会人员和会议描述
   - 提交预订申请
   - 管理员审核预订申请
   - 用户收到预订结果通知
   - 预订成功后，可在会议开始前取消预订

2. **会议室管理流程**
   - 管理员登录系统
   - 添加新会议室，包括名称、容量、位置等信息
   - 编辑已有会议室信息，如状态变更、设备更新等
   - 在必要时删除不再使用的会议室

3. **用户管理流程**
   - 新用户注册账号
   - 管理员审核并设置用户权限
   - 用户登录系统使用相应功能
   - 用户可以修改个人资料和密码
   - 管理员可以管理用户状态（启用/禁用）

## 环境要求
- JDK 21
- Maven 3.x
- MySQL 8.x
- Tomcat 10.x
- IDE（推荐使用 IntelliJ IDEA 或 Eclipse）

## 启动方式
1. 启动MySQL服务,可使用Docker启动或者phpstudy_pro启动，创建数据库`meeting_rooms_booking`，执行SQL脚本`datatables.sql`
2. 在项目根目录下运行`mvn clean package`，将项目打包成war包 
3. 将war包部署到Tomcat的webapps目录下
4. 启动Tomcat服务器：`bin/startup.bat`
5. 关闭Tomcat服务器：`bin/shutdown.bat`
6. 访问系统：http://localhost:8080/meeting-room-booking

## 技术栈
### 后端
- Spring 6.1.5
- SpringMVC 6.1.5
- MyBatis 3.5.15
- MySQL 8.x
- Maven
- Lombok
- Jackson 2.17.0
- Druid 1.2.20（数据库连接池）
- Logback 1.4.14（日志框架）

### 前端
- JSP
- Layui 2.6.8
- jQuery 3.6.0
- Ajax

## 项目启动
1. 数据库配置
   - 创建数据库：`meeting_rooms_booking`
   - 字符集：`utf8mb4`
   - 执行 SQL 脚本：项目根目录下的 `sql/init.sql`

2. 修改配置文件
   - 数据库连接配置：`src/main/resources/jdbc.properties`
   ```properties
   jdbc.driver=com.mysql.cj.jdbc.Driver
   jdbc.url=jdbc:mysql://localhost:3306/meeting_rooms_booking?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
   jdbc.username=你的数据库用户名
   jdbc.password=你的数据库密码
   ```

3. 项目打包
   ```bash
   mvn clean package
   ```

4. 部署运行
   - 将生成的 `target/meeting-room-booking.war` 部署到 Tomcat 的 webapps 目录下
   - 启动 Tomcat
   - 访问地址：`http://localhost:8080/meeting-room-booking`

## 功能模块
1. 用户管理
   - 用户注册：支持手机号+用户名+密码注册
   - 用户登录：手机号+密码登录
   - 个人信息管理：修改个人信息和密码
   - 用户管理（管理员）：用户列表、添加/编辑/删除用户、修改用户状态
   - 权限控制：基于RBAC模型，分为管理员和普通用户两种角色

2. 会议室管理
   - 会议室列表：分页显示、搜索功能
   - 会议室预订：选择时间段进行预订
   - 会议室管理（管理员）：添加/编辑/删除会议室、修改会议室状态

3. 预订管理
   - 预订记录：查看个人预订记录
   - 预订审批：管理员审批预订申请
   - 预订取消：可以取消未开始的预订
   - 状态管理：包括待审核、已通过、已拒绝、已取消等状态

## 项目结构
```
meetingrooms_booking/
├── src/                                 # 源代码目录
│   └── main/                           # 主要代码
│       ├── java/                       # Java源代码
│       │   └── com/meeting/booking/    # 项目主包
│       │       ├── controller/         # 控制器层
│       │       │   ├── UserController.java         # 用户相关控制器
│       │       │   ├── BookingController.java      # 预订相关控制器
│       │       │   └── MeetingRoomController.java  # 会议室相关控制器
│       │       ├── service/            # 服务层
│       │       │   ├── UserService.java            # 用户服务接口
│       │       │   ├── BookingService.java         # 预订服务接口
│       │       │   ├── MeetingRoomService.java     # 会议室服务接口
│       │       │   ├── RoleService.java            # 角色服务接口
│       │       │   ├── UserRoleService.java        # 用户角色服务接口
│       │       │   ├── RolePermissionsService.java # 角色权限服务接口
│       │       │   ├── PermissionsService.java     # 权限服务接口
│       │       │   └── impl/                       # 服务实现类
│       │       │       ├── UserServiceImpl.java         # 用户服务实现
│       │       │       ├── BookingServiceImpl.java      # 预订服务实现
│       │       │       ├── MeetingRoomServiceImpl.java  # 会议室服务实现
│       │       │       ├── RoleServiceImpl.java         # 角色服务实现
│       │       │       ├── userRoleServiceImpl.java     # 用户角色服务实现
│       │       │       ├── RolePermissionsServiceImpl.java # 角色权限服务实现
│       │       │       └── PermissionsServiceImpl.java  # 权限服务实现
│       │       ├── dao/                # 数据访问层
│       │       │   ├── UserMapper.java             # 用户数据访问接口
│       │       │   ├── BookingMapper.java          # 预订数据访问接口
│       │       │   ├── MeetingRoomMapper.java      # 会议室数据访问接口
│       │       │   ├── RoleMapper.java             # 角色数据访问接口
│       │       │   ├── UserRoleMapper.java         # 用户角色数据访问接口
│       │       │   ├── RolePermissionsMapper.java  # 角色权限数据访问接口
│       │       │   └── PermissionsMapper.java      # 权限数据访问接口
│       │       └── model/              # 实体类
│       │           ├── User.java                   # 用户实体类
│       │           ├── Booking.java                # 预订实体类
│       │           ├── MeetingRoom.java            # 会议室实体类
│       │           ├── Role.java                   # 角色实体类
│       │           ├── UserRole.java               # 用户角色关联实体类
│       │           ├── RolePermissions.java        # 角色权限关联实体类
│       │           ├── Permissions.java            # 权限实体类
│       │           └── Enums/                      # 枚举类
│       │               └── BookingEnum.java        # 预订状态枚举
│       ├── resources/                 # 资源文件目录
│       │   ├── mapper/                # MyBatis映射文件
│       │   │   ├── UserMapper.xml             # 用户SQL映射文件
│       │   │   ├── BookingMapper.xml          # 预订SQL映射文件
│       │   │   ├── MeetingRoomMapper.xml      # 会议室SQL映射文件
│       │   │   ├── RoleMapper.xml             # 角色SQL映射文件
│       │   │   ├── UserRoleMapper.xml         # 用户角色SQL映射文件
│       │   │   ├── RolePermissionsMapper.xml  # 角色权限SQL映射文件
│       │   │   └── PermissionsMapper.xml      # 权限SQL映射文件
│       │   ├── applicationContext.xml         # Spring配置文件
│       │   ├── spring-mvc.xml                # SpringMVC配置文件
│       │   └── jdbc.properties               # 数据库连接配置
│       └── webapp/                   # Web应用目录
│           ├── WEB-INF/                      # WEB-INF目录
│           │   ├── views/                    # JSP视图目录
│           │   │   ├── login.jsp                  # 登录页面
│           │   │   ├── register.jsp               # 注册页面
│           │   │   ├── profile.jsp                # 个人信息页面
│           │   │   ├── meeting_room_list.jsp      # 会议室列表页面
│           │   │   ├── meeting_room_manage.jsp    # 会议室管理页面
│           │   │   ├── booking_record.jsp         # 预订记录页面
│           │   │   ├── user_manage.jsp            # 用户管理页面
│           │   │   └── header.jsp                 # 公共头部
│           │   └── web.xml                        # Web应用配置文件
│           ├── static/                            # 静态资源目录
│           ├── index.jsp                          # 首页
│           ├── test.html                          # 测试页面
│           └── favicon.ico                        # 网站图标
├── target/                           # 构建输出目录
├── .idea/                            # IDEA配置目录
├── .vscode/                          # VSCode配置目录
├── pom.xml                           # Maven配置文件
├── 数据库设计及语句.txt                # 数据库设计文档
└── meeting_rooms_booking.sql         # 数据库脚本
```

## 页面功能说明
1. **用户界面**
   - `login.jsp`: 用户登录界面，提供手机号和密码登录功能
   - `register.jsp`: 用户注册界面，用于新用户注册
   - `profile.jsp`: 个人信息界面，用于查看和修改个人信息
   - `user_manage.jsp`: 管理员用户管理界面，提供用户列表和操作功能

2. **会议室界面**
   - `meeting_room_list.jsp`: 会议室列表界面，展示所有会议室及状态，用于普通用户浏览和预订会议室
   - `meeting_room_manage.jsp`: 会议室管理界面，用于管理员添加、编辑和删除会议室

3. **预订界面**
   - `booking_record.jsp`: 预订记录界面，查看预订历史和状态，管理员可查看所有记录并审批，普通用户只能查看自己的记录

4. **公共组件**
   - `header.jsp`: 页面公共头部，包含导航栏和用户信息

## 默认账号
- 管理员账号：13800138000
- 默认密码：admin123

## 注意事项
1. 确保MySQL服务已启动且能正常访问
2. 项目使用了Lombok，请在IDE中安装Lombok插件
3. 确保Tomcat版本兼容（推荐使用Tomcat 10.x）
4. 如遇到中文乱码问题，请检查数据库和项目的字符集设置

## 浏览器支持
- Chrome（推荐）
- Firefox
- Edge
- Safari

## 数据库设计
### 数据库名称
meeting_rooms_booking
### 主要表结构
1. 用户表(users)
   - id: bigint (主键)
   - username: varchar(50) (用户名)
   - password: varchar(100) (密码)
   - phone: varchar(20) (手机号)
   - status: int (状态)
   - created_at: datetime
   - updated_at: datetime

2. 会议室表(meeting_rooms)
   - id: bigint (主键)
   - name: varchar(50) (会议室名称)
   - capacity: int (容纳人数)
   - location: varchar(100) (位置)
   - status: int (状态)
   - created_at: datetime
   - updated_at: datetime

3. 预定记录表(bookings)
   - id: bigint (主键)
   - room_id: bigint (会议室ID)
   - user_id: bigint (预定用户ID)
   - start_time: int (开始时间)
   - date: date (预定日期)
   - end_time: int (结束时间)
   - title: varchar(100) (会议主题)
   - description: text (会议描述)
   - attendees: varchar(500) (参会人员)
   - status: enum (预定状态)
   - created_at: datetime
   - updated_at: datetime

4. 角色表(roles)
   - id: bigint (主键)
   - name: varchar(50) (角色名称)
   - description: varchar(200) (角色描述)
   - created_at: datetime
   - updated_at: datetime

5. 用户角色关联表(user_roles)
   - id: bigint (主键)
   - user_id: bigint (用户ID)
   - role_id: bigint (角色ID)
   - created_at: datetime

6. 权限表(permissions)
   - id: bigint (主键)
   - name: varchar(50) (权限名称)
   - description: varchar(200) (权限描述)
   - created_at: datetime

7. 角色权限关联表(role_permissions)
   - id: bigint (主键)
   - role_id: bigint (角色ID)
   - permission_id: bigint (权限ID)
   - created_at: datetime

##sql语句
-- 用户表
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    phone VARCHAR(20) NOT NULL UNIQUE COMMENT '手机号',
    password VARCHAR(100) NOT NULL COMMENT '密码',
    username VARCHAR(50) NOT NULL COMMENT '用户名',
    status INT NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 角色表
CREATE TABLE roles (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE COMMENT '角色名称',
    description VARCHAR(200) COMMENT '角色描述',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色表';

-- 用户角色关联表
CREATE TABLE user_roles (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL COMMENT '用户ID',
    role_id BIGINT NOT NULL COMMENT '角色ID',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (role_id) REFERENCES roles(id),
    UNIQUE KEY uk_user_role (user_id, role_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户角色关联表';

-- 权限表
CREATE TABLE permissions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE COMMENT '权限名称',
    description VARCHAR(200) COMMENT '权限描述',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='权限表';

-- 角色权限关联表
CREATE TABLE role_permissions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    role_id BIGINT NOT NULL COMMENT '角色ID',
    permission_id BIGINT NOT NULL COMMENT '权限ID',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (role_id) REFERENCES roles(id),
    FOREIGN KEY (permission_id) REFERENCES permissions(id),
    UNIQUE KEY uk_role_permission (role_id, permission_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色权限关联表';

-- 会议室表
CREATE TABLE rooms (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE COMMENT '会议室名称',
    capacity INT NOT NULL COMMENT '容纳人数',
    location VARCHAR(100) NOT NULL COMMENT '位置',
    status INT NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    isFree INT NOT NULL DEFAULT 1 COMMENT '是否空闲：1-空闲，0-不空闲',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_name (name),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='会议室表';

-- 预定记录表
CREATE TABLE bookings (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    room_id BIGINT NOT NULL COMMENT '会议室ID',
    user_id BIGINT NOT NULL COMMENT '预定用户ID',
    date DATE NOT NULL COMMENT '预定日期',
    start_time INT NOT NULL COMMENT '开始时间',
    end_time INT NOT NULL COMMENT '结束时间',
    title VARCHAR(100) NOT NULL COMMENT '会议主题',
    attendees TEXT NOT NULL COMMENT '参会人员',
    description TEXT NOT NULL COMMENT '会议描述',
    status enum ('PENDING','APPROVED','REJECTED','CANCELLED') NOT NULL DEFAULT 'PENDING' COMMENT '预定状态',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_room_date (room_id, date),
    INDEX idx_user_date (user_id, date),
    INDEX idx_status (status),
    INDEX idx_date (date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='预定记录表';

-- 插入初始角色
INSERT INTO roles (name, description) VALUES
('ROLE_ADMIN', '系统管理员'),
('ROLE_USER', '普通用户');

-- 插入初始权限
INSERT INTO permissions (name, description) VALUES
('USER_CREATE', '创建用户'),
('USER_READ', '查看用户'),
('USER_UPDATE', '更新用户'),
('USER_DELETE', '删除用户'),
('ROOM_CREATE', '创建会议室'),
('ROOM_READ', '查看会议室'),
('ROOM_UPDATE', '更新会议室'),
('ROOM_DELETE', '删除会议室'),
('BOOKING_CREATE', '创建预订'),
('BOOKING_READ', '查看预订'),
('BOOKING_UPDATE', '更新预订'),
('BOOKING_DELETE', '删除预订');

-- 为角色分配权限
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.name = 'ROLE_ADMIN';

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.name = 'ROLE_USER'
AND p.name IN ('ROOM_READ', 'BOOKING_CREATE', 'BOOKING_READ', 'BOOKING_UPDATE', 'BOOKING_DELETE');

-- 创建管理员用户（密码：admin123）
INSERT INTO users (phone, password,username, status)
VALUES ('13800138000', '0192023a7bbd73250516f069df18b500', '管理员', 1);

-- 为管理员分配角色
INSERT INTO user_roles (user_id, role_id)
SELECT u.id, r.id
FROM users u
CROSS JOIN roles r
WHERE u.phone = '13800138000'
AND r.name = 'ROLE_ADMIN';  