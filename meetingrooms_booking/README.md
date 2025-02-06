# 会议室预订系统

## 项目概述
这是一个基于SSM(Spring + SpringMVC + MyBatis)框架开发的会议室预订系统，主要用于管理和预订会议室资源。系统支持用户管理、会议室管理、预订管理等功能，采用RBAC权限控制模型，分为管理员和普通用户两种角色。

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
meeting-rooms-booking/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/meeting/booking/
│   │   │       ├── controller/    # 控制器层
│   │   │       ├── dao/          # 数据访问层
│   │   │       ├── model/        # 实体类
│   │   │       └── service/      # 服务层
│   │   ├── resources/
│   │   │   ├── mapper/          # MyBatis映射文件
│   │   │   ├── applicationContext.xml
│   │   │   ├── jdbc.properties
│   │   │   └── spring-mvc.xml
│   │   └── webapp/
│   │       └── WEB-INF/
│   │           ├── views/        # JSP页面
│   │           └── web.xml
└── pom.xml
```

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