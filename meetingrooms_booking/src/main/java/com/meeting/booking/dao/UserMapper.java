package com.meeting.booking.dao;

import com.meeting.booking.model.User;
import org.apache.ibatis.annotations.Param;
import java.util.List;

/**
 * 用户数据访问接口
 * @author meeting
 */
public interface UserMapper {
    /**
     * 通过ID查询用户
     * @param id 用户ID
     * @return 用户对象
     */
    User selectById(Long id);
    
    /**
     * 通过手机号查询用户
     * @param phone 手机号
     * @return 用户对象
     */
    User selectByPhone(String phone);
    
    /**
     * 查询所有用户（分页）
     * @param offset 偏移量
     * @param limit 限制数
     * @return 用户列表
     */
    List<User> selectAll(@Param("offset") int offset, @Param("limit") int limit, @Param("phone") String phone, @Param("username") String username);
    
    /**
     * 插入新用户
     * @param user 用户对象
     * @return 影响行数
     */
    int insert(User user);
    
    /**
     * 更新用户信息
     * @param user 用户对象
     * @return 影响行数
     */
    int update(User user);
    
    /**
     * 删除用户
     * @param id 用户ID
     * @return 影响行数
     */
    int deleteById(Long id);
    
    /**
     * 获取总用户数
     * @return 用户总数
     */
    int count();
} 