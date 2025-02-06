package com.meeting.booking.model;

import lombok.Data;
import java.time.LocalDateTime;

/**
 * 用户角色关联实体类
 * @author meeting
 */
@Data
public class UserRole {
    /**
     * ID
     */
    private Long id;
    
    /**
     * 用户ID
     */
    private Long userId;
    
    /**
     * 角色ID
     */
    private Long roleId;
    
    /**
     * 创建时间
     */
    private String createdAt;
} 