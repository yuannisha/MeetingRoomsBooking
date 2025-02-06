package com.meeting.booking.service.impl;

import com.meeting.booking.dao.RoleMapper;
import com.meeting.booking.dao.UserMapper;
import com.meeting.booking.dao.UserRoleMapper;
import com.meeting.booking.model.Role;
import com.meeting.booking.model.User;
import com.meeting.booking.model.UserRole;
import com.meeting.booking.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.DigestUtils;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

/**
 * 用户服务实现类
 * @author meeting
 */
@Service
public class UserServiceImpl implements UserService {
    
    @Autowired
    private UserMapper userMapper;
    
    @Autowired
    private RoleMapper roleMapper;
    
    @Autowired
    private UserRoleMapper userRoleMapper;
    
    @Override
    @Transactional
    public User register(User user) {
        // 检查手机号是否已注册
        if (userMapper.selectByPhone(user.getPhone()) != null) {
            return null;
        }
        
        // 密码加密
        user.setPassword(DigestUtils.md5DigestAsHex(user.getPassword().getBytes()));
        // 设置状态为启用
        user.setStatus(1);
        
        // 插入用户
        if (userMapper.insert(user) > 0) {
            // 为新用户分配普通用户角色
            Role userRole = roleMapper.selectByName("ROLE_USER");
            if (userRole != null) {
                UserRole userRoleRelation = new UserRole();
                userRoleRelation.setUserId(user.getId());
                userRoleRelation.setRoleId(userRole.getId());
                userRoleMapper.insert(userRoleRelation);
            }
            return user;
        }
        return null;
    }
    
    @Override
    public Map<String, Object> login(String phone, String password) {
        User user = userMapper.selectByPhone(phone);
        if (user != null && user.getStatus() == 1) {
            // 验证密码
            String encryptedPassword = DigestUtils.md5DigestAsHex(password.getBytes());
            if (user.getPassword().equals(encryptedPassword)) {
                
                // 登录成功，清除密码
                user.setPassword(null);
                
                Map<String, Object> result = new HashMap<>();
                result.put("user", user);
                
                return result;
            }
        }
        return null;
    }
    
    @Override
    public User getUserById(Long id) {
        User user = userMapper.selectById(id);
        if (user != null) {
            // 清除密码
            user.setPassword(null);
        }
        return user;
    }
    
    @Override
    public boolean updateUser(User user) {
        User existingUser = userMapper.selectById(user.getId());
        if (existingUser == null) {
            return false;
        }
        
        // 如果要更新密码，需要加密
        if (user.getPassword() != null && !user.getPassword().isEmpty()) {
            user.setPassword(DigestUtils.md5DigestAsHex(user.getPassword().getBytes()));
        }
        
        return userMapper.update(user) > 0;
    }
    
    @Override
    public boolean deleteUser(Long id) {
        // 先删除用户角色关联
        userRoleMapper.deleteByUserId(id);
        // 再删除用户
        return userMapper.deleteById(id) > 0;
    }
    
    @Override
    public List<User> getUserList(int page, int size, String phone, String username) {
        int offset = (page - 1) * size;
        List<User> users = userMapper.selectAll(offset, size, phone, username);
        // 清除密码
        users.forEach(user -> user.setPassword(null));
        return users;
    }

    
    @Override
    public int getUserCount() {
        return userMapper.count();
    }
} 