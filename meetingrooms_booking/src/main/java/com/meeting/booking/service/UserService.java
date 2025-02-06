package com.meeting.booking.service;

import com.meeting.booking.model.User;
import java.util.List;
import java.util.Map;

/**
 * 用户服务接口
 * @author meeting
 */
public interface UserService {
    /**
     * 用户注册
     * @param user 用户信息
     * @return 注册成功返回用户信息，失败返回null
     */
    User register(User user);
    
    /**
     * 用户登录
     * @param phone 手机号
     * @param password 密码
     * @return 登录成功返回包含用户信息和角色的Map，失败返回null
     */
    Map<String, Object> login(String phone, String password);
    
    /**
     * 获取用户信息
     * @param id 用户ID
     * @return 用户信息
     */
    User getUserById(Long id);
    
    /**
     * 更新用户信息
     * @param user 用户信息
     * @return 更新成功返回true，失败返回false
     */
    boolean updateUser(User user);
    
    /**
     * 删除用户
     * @param id 用户ID
     * @return 删除成功返回true，失败返回false
     */
    boolean deleteUser(Long id);
    
    /**
     * 分页获取用户列表
     * @param page 页码
     * @param size 每页大小
     * @return 用户列表
     */
    List<User> getUserList(int page, int size ,String phone, String username);
    
    /**
     * 获取用户总数
     * @return 用户总数
     */
    int getUserCount();
} 