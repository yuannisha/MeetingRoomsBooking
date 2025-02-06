package com.meeting.booking.dao;

import com.meeting.booking.model.Permissions;
import java.util.List;

/**
 * 权限数据访问接口
 */
public interface PermissionsMapper {
    /**
     * 插入权限
     * @param permissions 权限对象
     * @return 影响行数
     */
    int insert(Permissions permissions);
    
    /**
     * 更新权限
     * @param permissions 权限对象
     * @return 影响行数
     */
    int update(Permissions permissions);
    
    /**
     * 删除权限
     * @param id 权限ID
     * @return 影响行数
     */
    int deleteById(Long id);
    
    /**
     * 查询所有权限
     * @return 权限列表
     */
    List<Permissions> selectAll();
    
    /**
     * 通过ID查询权限
     * @param id 权限ID
     * @return 权限对象
     */
    Permissions selectById(Long id);
} 