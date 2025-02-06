package com.meeting.booking.service;

import com.meeting.booking.model.Permissions;
import java.util.List;

/**
 * 权限服务接口
 */
public interface PermissionsService {
    /**
     * 添加权限
     * @param permissions 权限对象
     * @return 添加成功返回true，失败返回false
     */
    boolean addPermission(Permissions permissions);
    
    /**
     * 更新权限
     * @param permissions 权限对象
     * @return 更新成功返回true，失败返回false
     */
    boolean updatePermission(Permissions permissions);
    
    /**
     * 删除权限
     * @param id 权限ID
     * @return 删除成功返回true，失败返回false
     */
    boolean deletePermission(Long id);
    
    /**
     * 获取所有权限
     * @return 权限列表
     */
    List<Permissions> getAllPermissions();
    
    /**
     * 通过ID获取权限
     * @param id 权限ID
     * @return 权限对象
     */
    Permissions getPermissionById(Long id);
    
} 