package com.meeting.booking.model;

import lombok.Data;
import java.time.LocalDateTime;

/**
 * 用户实体类
 * @author meeting
 */
@Data
public class User {
    /**
     * 用户ID
     */
    private Long id;
    
    /**
     * 手机号
     */
    private String phone;
    
    /**
     * 密码
     */
    private String password;
    
    /**
     * 用户名
     */
    private String username;
    
    /**
     * 状态：0-禁用，1-启用
     */
    private Integer status;

    /**
     * 用户角色
     */
    private Role userRole;
    
    /**
     * 创建时间
     */

    private String createdAt;
    
    /**
     * 更新时间
     */
    private String updatedAt;
} 