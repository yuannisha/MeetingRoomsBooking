package com.meeting.booking.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.meeting.booking.model.Role;
import com.meeting.booking.model.User;
import com.meeting.booking.model.UserRole;
import com.meeting.booking.service.RoleService;
import com.meeting.booking.service.UserRoleService;
import com.meeting.booking.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.http.HttpSession;
import org.springframework.http.HttpStatus;

/**
 * 用户控制器
 * @author meeting
 */
@Controller
@RequestMapping("/users")
public class UserController {
    
    @Autowired
    public UserService userService;

    @Autowired
    public UserRoleService userRoleService;

    @Autowired
    public RoleService roleService;


    /**
     * 跳转到登录页面
     */
    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }
    
    /**
     * 登出
     */
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/users/login";
    }
    /**
     * 跳转到注册页面
     */
    @GetMapping("/register")
    public String registerPage() {
        return "register";
    }
    
    /**
     * 用户注册
     * @param user 用户信息
     * @return 注册结果
     */
    @PostMapping("/register")
    @ResponseBody
    public ResponseEntity<?> register(@RequestBody User user) {
        User registeredUser = userService.register(user);
        if (registeredUser != null) {
            Map<String, Object> response = new HashMap<>();
            response.put("message", "注册成功");
            response.put("user", registeredUser);
            return ResponseEntity.ok(response);
        }
        return ResponseEntity.badRequest().body("注册失败，手机号可能已被注册");
    }
    
    /**
     * 用户登录
     * @param loginMap 登录信息
     * @return 登录结果
     */
    @PostMapping("/login")
    @ResponseBody
    public ResponseEntity<?> login(@RequestBody Map<String, String> loginMap , HttpSession session) {
        String phone = loginMap.get("phone");
        String password = loginMap.get("password");
        
        Map<String, Object> result = userService.login(phone, password);
        if (result != null) {
            Map<String, Object> response = new HashMap<>();
            response.put("message", "登录成功");
            response.put("user", result.get("user"));

            //获取用户角色
            String userRole = getUserRole((User) result.get("user"));
            response.put("userRole", userRole);
            
            //登录成功后设置session
            session.setAttribute("currentUserRole", userRole);
            session.setAttribute("user", result.get("user"));
            return ResponseEntity.ok(response);
        }
        return ResponseEntity.badRequest().body("登录失败，手机号或密码错误");
    }
    
    /**
     * 获取用户信息
     * @param id 用户ID
     * @return 用户信息
     */
    @GetMapping("/{id}")
    @ResponseBody
    public ResponseEntity<?> getUserInfo(@PathVariable Long id) {
        User user = userService.getUserById(id);
        if (user != null) {
            return ResponseEntity.ok(user);
        }
        return ResponseEntity.notFound().build();
    }
    
    /**
     * 更新用户信息
     * @param id 用户ID
     * @param user 用户信息
     * @return 更新结果
     */
    @PutMapping("/{id}")
    @ResponseBody
    public ResponseEntity<?> updateUser(@PathVariable Long id, @RequestBody User user) {
        user.setId(id);
        if (userService.updateUser(user)) {
            return ResponseEntity.ok("更新成功");
        }
        return ResponseEntity.badRequest().body("更新失败");
    }
    
    /**
     * 删除用户
     * @param id 用户ID
     * @return 删除结果
     */
    @DeleteMapping("/{id}")
    @ResponseBody
    public ResponseEntity<?> deleteUser(@PathVariable Long id) {
        if (userService.deleteUser(id)) {
            return ResponseEntity.ok("删除成功");
        }
        return ResponseEntity.badRequest().body("删除失败");
    }
    
    /**
     * 获取用户列表
     * @param page 页码
     * @param  limit 数量
     * @return 用户列表
     */
    @GetMapping("/manage/userList")
    @ResponseBody
    public ResponseEntity<?> getUserList(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit,
            @RequestParam(defaultValue = "") String phone,
            @RequestParam(defaultValue = "") String username,
            HttpSession session) {
        if (session.getAttribute("currentUserRole").equals("ROLE_ADMIN")){
            List<User> users = userService.getUserList(page, limit, phone, username);
        
        //将用户列表中的用户角色信息添加到用户列表中
        for (User user : users) {
            UserRole userRole = userRoleService.getRoleByUserId(user.getId());
            Role role = roleService.getRoleById(userRole.getRoleId());
            user.setUserRole(role);
        }

        int total = userService.getUserCount();
        
        Map<String, Object> response = new HashMap<>();
        response.put("users", users);
        response.put("total", total);
        response.put("page", page);
        response.put("size", limit);
        //加入状态码
        response.put("status", 0);
        response.put("message", "获取用户列表成功");
        return ResponseEntity.ok(response);
    }
    return ResponseEntity.status(HttpStatus.FORBIDDEN).body("无权限");
    }

    /**
     * 查看个人信息
     * @return 个人信息页面
     */
    @GetMapping("/profile")
    public String viewProfile() {
        return "profile";
    }

    /**
     * 更新个人信息
     * @param user 用户信息
     * @return 更新结果
     */
    @PostMapping("/profile")
    @ResponseBody
    public ResponseEntity<?> updateProfile(@RequestBody User user) {
        if (userService.updateUser(user)) {
            return ResponseEntity.ok("更新成功");
        }
        return ResponseEntity.badRequest().body("更新失败");
    }

    /**
     * 获取用户的角色字段
     * @param user 当前用户
     * @return 用户的角色字段
     */
    private String getUserRole(User user) {
        UserRole userrole = userRoleService.getRoleByUserId(user.getId());
        Role role = roleService.getRoleById(userrole.getRoleId());
        return role.getName();
    }

    /**
     * 用户管理页面
     * @return 用户管理页面
     */
    @GetMapping("/manage")
    public String manageUsers(HttpSession session) {
        if (session.getAttribute("currentUserRole").equals("ROLE_ADMIN")) {
            return "user_manage";
        }
        return "redirect:/access-denied";
    }

    /**
     * 修改用户信息
     * @param updateUser & session 用户信息
     * @return 修改结果
     */
    @PutMapping("/manage/update")
    @ResponseBody
    //接收参数改为传过来的json数据
    public ResponseEntity<?> modifyUser(@RequestBody Map<String, Object> updateUser, HttpSession session) {
        ObjectMapper objectMapper = new ObjectMapper();
        User user = objectMapper.convertValue(updateUser.get("user"), User.class);
        UserRole userRole = objectMapper.convertValue(updateUser.get("userRole"), UserRole.class);
        if (session.getAttribute("currentUserRole").equals("ROLE_ADMIN")) {
            try {
                if (userService.updateUser(user) && userRoleService.update(userRole)) {
                    return ResponseEntity.ok("修改成功");
                } 
             return ResponseEntity.badRequest().body("修改失败");
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        }
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body("无权限");
    }

    /**
     * 删除用户
     * @param id 用户ID
     * @return 删除结果
     */
    @DeleteMapping("/manage/delete/{id}")
    @ResponseBody
    public ResponseEntity<?> deleteUser(@PathVariable Long id, HttpSession session) {
        if (session.getAttribute("currentUserRole").equals("ROLE_ADMIN")) {
            if (userService.deleteUser(id)) {
                return ResponseEntity.ok("删除成功");
            }
            return ResponseEntity.badRequest().body("删除失败");
        }
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body("无权限");
    }

    /**
     * 添加用户
     * @param user 用户信息
     * @return 添加结果
     */
    @PostMapping("/manage/add")
    @ResponseBody
    public ResponseEntity<?> addUser(@RequestBody User user, HttpSession session) {
        if (session.getAttribute("currentUserRole").equals("ROLE_ADMIN")) {
            User newUser = userService.register(user);
            if (newUser != null) {
                return ResponseEntity.ok("添加成功");
            }
            return ResponseEntity.badRequest().body("添加失败");
        }
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body("无权限");
    }

    /**
     * 修改密码
     * @param passwordMap 包含旧密码和新密码的Map
     * @return 修改结果
     */
    @PostMapping("/changePassword")
    @ResponseBody
    public ResponseEntity<?> changePassword(@RequestBody Map<String, Object> passwordMap, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("请先登录");
        }

        String oldPassword = (String) passwordMap.get("oldPassword");
        String newPassword = (String) passwordMap.get("newPassword");
        //将id转为Long类型
        Long userId = Long.parseLong(passwordMap.get("id").toString());

        // 验证用户ID是否匹配
        if (!currentUser.getId().equals(userId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("无权修改他人密码");
        }

        // 验证旧密码
        Map<String, Object> loginResult = userService.login(currentUser.getPhone(), oldPassword);
        if (loginResult == null) {
            return ResponseEntity.badRequest().body("原密码错误");
        }

        // 更新密码
        User user = new User();
        user.setId(userId);
        user.setPassword(newPassword);
        if (userService.updateUser(user)) {
            // 密码修改成功后，使当前会话失效
            session.invalidate();
            return ResponseEntity.ok("密码修改成功");
        }
        return ResponseEntity.badRequest().body("密码修改失败");
    }
} 