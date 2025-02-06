package com.meeting.booking.dao;

import com.meeting.booking.model.RolePermissions;
import java.util.List;

/**
 * 角色权限关联数据访问接口
 */
public interface RolePermissionsMapper {
    /**
     * 插入角色权限关联
     * @param rolePermissions 角色权限关联对象
     * @return 影响行数
     */
    int insert(RolePermissions rolePermissions);
    
    /**
     * 删除角色权限关联
     * @param id 角色权限关联ID
     * @return 影响行数
     */
    int deleteById(Long id);
    
    /**
     * 查询角色的所有权限
     * @param roleId 角色ID
     * @return 角色权限关联列表
     */
    List<RolePermissions> selectByRoleId(Long roleId);
} 