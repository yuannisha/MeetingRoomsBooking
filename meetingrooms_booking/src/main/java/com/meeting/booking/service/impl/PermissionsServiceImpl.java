package com.meeting.booking.service.impl;

import com.meeting.booking.dao.PermissionsMapper;
import com.meeting.booking.model.Permissions;
import com.meeting.booking.service.PermissionsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

/**
 * 权限服务实现类
 */
@Service
public class PermissionsServiceImpl implements PermissionsService {
    
    @Autowired
    private PermissionsMapper permissionsMapper;
    
    @Override
    public boolean addPermission(Permissions permissions) {
        return permissionsMapper.insert(permissions) > 0;
    }
    
    @Override
    public boolean updatePermission(Permissions permissions) {
        return permissionsMapper.update(permissions) > 0;
    }
    
    @Override
    public boolean deletePermission(Long id) {
        return permissionsMapper.deleteById(id) > 0;
    }
    
    @Override
    public List<Permissions> getAllPermissions() {
        return permissionsMapper.selectAll();
    }
    
    @Override
    public Permissions getPermissionById(Long id) {
        return permissionsMapper.selectById(id);
    }
} 