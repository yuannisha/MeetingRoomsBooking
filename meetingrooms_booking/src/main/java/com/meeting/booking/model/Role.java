package com.meeting.booking.model;

import lombok.Data;
import java.time.LocalDateTime;

/**
 * 角色实体类
 * @author meeting
 */
@Data
public class Role {
    /**
     * 角色ID
     */
    private Long id;
    
    /**
     * 角色名称
     */
    private String name;
    
    /**
     * 角色描述
     */
    private String description;
    
    /**
     * 创建时间
     */
    private String createdAt;
    
    /**
     * 更新时间
     */
    private String updatedAt;
} 