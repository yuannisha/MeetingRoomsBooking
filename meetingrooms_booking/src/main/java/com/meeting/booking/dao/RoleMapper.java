package com.meeting.booking.dao;

import com.meeting.booking.model.Role;
import java.util.List;

/**
 * 角色数据访问接口
 * @author meeting
 */
public interface RoleMapper {

    /**
     * 插入角色
     * @param role 角色对象
     * @return 影响行数
     */
    int insert(Role role);

    /**
     * 删除角色
     * @param id 角色ID
     * @return 影响行数
     */
    int deleteById(Long id);

    /**
     * 更新角色
     * @param role 角色对象
     * @return 影响行数
     */
    int update(Role role);
    /**
     * 通过ID查询角色
     * @param id 角色ID
     * @return 角色对象
     */
    Role selectById(Long id);
    
    /**
     * 通过名称查询角色
     * @param name 角色名称
     * @return 角色对象
     */
    Role selectByName(String name);
    
    /**
     * 查询用户的所有角色
     * @return 角色列表
     */
    List<Role> selectAllRoles();
} 