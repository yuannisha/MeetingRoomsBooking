package com.meeting.booking.service;

import com.meeting.booking.model.RolePermissions;
import java.util.List;

/**
 * 角色权限服务接口
 */
public interface RolePermissionsService {
    /**
     * 添加角色权限关联
     * @param rolePermissions 角色权限关联对象
     * @return 添加成功返回true，失败返回false
     */
    boolean addRolePermission(RolePermissions rolePermissions);
    
    /**
     * 删除角色权限关联
     * @param id 角色权限关联ID
     * @return 删除成功返回true，失败返回false
     */
    boolean deleteRolePermission(Long id);
    
    /**
     * 获取角色的所有权限
     * @param roleId 角色ID
     * @return 角色权限关联列表
     */
    List<RolePermissions> getPermissionsByRoleId(Long roleId);
} 