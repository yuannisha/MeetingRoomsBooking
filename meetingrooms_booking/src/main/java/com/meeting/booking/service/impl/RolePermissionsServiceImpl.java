package com.meeting.booking.service.impl;

import com.meeting.booking.dao.RolePermissionsMapper;
import com.meeting.booking.model.RolePermissions;
import com.meeting.booking.service.RolePermissionsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

/**
 * 角色权限服务实现类
 */
@Service
public class RolePermissionsServiceImpl implements RolePermissionsService {
    
    @Autowired
    private RolePermissionsMapper rolePermissionsMapper;
    
    @Override
    public boolean addRolePermission(RolePermissions rolePermissions) {
        return rolePermissionsMapper.insert(rolePermissions) > 0;
    }
    
    @Override
    public boolean deleteRolePermission(Long id) {
        return rolePermissionsMapper.deleteById(id) > 0;
    }
    
    @Override
    public List<RolePermissions> getPermissionsByRoleId(Long roleId) {
        return rolePermissionsMapper.selectByRoleId(roleId);
    }
} 