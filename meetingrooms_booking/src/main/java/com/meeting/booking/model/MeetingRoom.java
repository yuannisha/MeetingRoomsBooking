package com.meeting.booking.model;

import lombok.Data;
import java.time.LocalDateTime;

/**
 * 会议室实体类
 */
@Data
public class MeetingRoom {
    /**
     * 会议室ID
     */
    private Long id;
    
    /**
     * 会议室名称
     */
    private String name;
    
    /**
     * 容纳人数
     */
    private Integer capacity;
    
    /**
     * 位置
     */
    private String location;
    
    /**
     * 状态：0-禁用，1-启用
     */
    private Integer status;
    
    /**
     * 是否空闲：1-空闲，0-不空闲
     */
    private Integer isFree;


    /**
     * 创建时间

     */
    private String createdAt;
    
    /**
     * 更新时间
     */
    private String updatedAt;
} 