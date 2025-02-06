package com.meeting.booking.model;

import lombok.Data;
import java.time.LocalDateTime;

/**
 * 角色权限关联实体类
 */
@Data
public class RolePermissions {
    /**
     * ID
     */
    private Long id;
    
    /**
     * 角色ID
     */
    private Long roleId;
    
    /**
     * 权限ID
     */
    private Long permissionId;
    
    /**
     * 创建时间
     */
    private String createdAt;
} 