package com.meeting.booking.dao;

import com.meeting.booking.model.Role;
import com.meeting.booking.model.UserRole;

import java.util.List;

/**
 * 用户角色关联数据访问接口
 * @author meeting
 */
public interface UserRoleMapper {
    /**
     * 插入用户角色关联
     * @param userRole 用户角色关联对象
     * @return 影响行数
     */
    int insert(UserRole userRole);

    /**
     * 更新用户角色关联
     * @param userRole 用户角色关联对象
     * @return 影响行数
     */
    int update(UserRole userRole);
    
    /**
     * 删除用户的所有角色

     * @param userId 用户ID
     * @return 影响行数
     */
    int deleteByUserId(Long userId);
    
    /**
     * 查询用户的所有角色
     * @param userId 用户ID
     * @return 用户角色列表
     */
    UserRole selectByUserId(Long userId);
} 