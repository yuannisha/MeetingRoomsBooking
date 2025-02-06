package com.meeting.booking.service;

import com.meeting.booking.model.Role;
import java.util.List;      

/**
 * 角色服务接口
 * @author meeting
 */ 
public interface RoleService  {
    /**
     * 通过ID查询角色
     * @param id 角色ID
     * @return 角色对象
     */
    Role getRoleById(Long id);  

    /**
     * 插入角色
     * @param role 角色对象
     * @return 影响行数
     */
    boolean addRole(Role role);  


    /**
     * 更新角色
     * @param role 角色对象
     * @return 影响行数
     */
    boolean updateRole(Role role);  



    /**
     * 删除角色
     * @param id 角色ID
     * @return 影响行数
     */
    boolean deleteRole(Long id);    



    /**
     * 查询所有角色
     * @return 角色列表
     */
    List<Role> getAllRoles();   

}
