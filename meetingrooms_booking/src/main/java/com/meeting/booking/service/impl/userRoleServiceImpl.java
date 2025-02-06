package com.meeting.booking.service.impl;

import com.meeting.booking.dao.UserRoleMapper;
import com.meeting.booking.model.Role;
import com.meeting.booking.model.UserRole;
import com.meeting.booking.service.UserRoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

/**
 * 用户角色服务实现类
 */
@Service
public class userRoleServiceImpl implements UserRoleService {

    @Autowired
    private UserRoleMapper userRoleMapper;

    /**
     * 查询用户角色
     * @param userId 用户ID
     * @return 用户角色列表
     */
    @Override
    public UserRole getRoleByUserId(Long userId) {
        return userRoleMapper.selectByUserId(userId);
    }

    @Override
    public int insert(UserRole userRole) {
        return 0;
    }

    @Override
    public boolean update(UserRole userRole) {
        return userRoleMapper.update(userRole) > 0;
    }


    @Override
    public boolean deleteByUserId(Long userId) {
        return userRoleMapper.deleteByUserId(userId) > 0;
    }


    @Override
    public List<UserRole> getAllUserRoles() {
        return List.of();
    }

}

