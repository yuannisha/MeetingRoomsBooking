package com.meeting.booking.service;

import com.meeting.booking.model.Role;
import com.meeting.booking.model.UserRole;
import java.util.List;

/**
 * 用户角色服务接口
 * @author meeting
 */
public interface UserRoleService {
    /**
     * 查询用户角色
     * @param userId 用户ID
     * @return 用户角色列表
     */

    UserRole getRoleByUserId(Long userId);
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
    boolean update(UserRole userRole);
    /**
     * 删除用户角色关联
     * @param userId 用户ID
     * @return 影响行数
     */
    boolean deleteByUserId(Long userId);
    /**
     * 查询所有用户角色关联
     * @return 用户角色关联列表
     */

    List<UserRole> getAllUserRoles();           
}
    