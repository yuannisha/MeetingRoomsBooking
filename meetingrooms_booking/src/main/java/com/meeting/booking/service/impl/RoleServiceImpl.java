package com.meeting.booking.service.impl;

import com.meeting.booking.service.RoleService;
import com.meeting.booking.dao.RoleMapper;
import com.meeting.booking.model.Role;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 角色服务实现类
 * @author meeting      
 */
@Service
public class RoleServiceImpl implements RoleService {
    @Autowired
    private RoleMapper roleMapper;

    @Override
    public Role getRoleById(Long id) {
        return roleMapper.selectById(id);
    }

    @Override
    public boolean addRole(Role role) {
        return false;
    }

    @Override
    public boolean updateRole(Role role) {
        return false;
    }

    @Override
    public boolean deleteRole(Long id) {
        return false;
    }

    @Override
    public List<Role> getAllRoles() {
        return roleMapper.selectAllRoles();
    }   


}
