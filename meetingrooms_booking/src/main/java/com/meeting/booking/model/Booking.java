package com.meeting.booking.model;

import com.meeting.booking.model.Enums.BookingEnum;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.Date;
import java.util.Map;

/**
 * 预订记录实体类
 */
@Data
public class Booking {
    /**
     * 预订记录ID
     */
    private Long id;
    
    /**
     * 会议室ID
     */
    private Long roomId;

    /**
     * 会议室名称
     */
    private String roomName;    
    
    /**
     * 预订用户ID
     */
    private Long userId;
    
    /**
     * 预订日期
     */
    private LocalDate date;

    /**
     * 预订日期String格式
     */
    private String stringDate;
    
    /**
     * 开始时间
     */
    private Integer startTime;
    

    /**
     * 结束时间
     */
    private Integer endTime;
    

    /**
     * 会议主题
     */

    private String title;
    
    /**
     * 参会人员
     */
    private String attendees;
    
    /**
     * 会议描述
     */
    private String description;
    
    /**
     * 预订状态
     */
    private BookingEnum status;
    

    /**
     * 创建时间
     */
    private String createdAt;
    

    /**
     * 更新时间
     */
    private String updatedAt;

    /**
     * 操作权限标志
     */
    private Map<String, Object> operations;
} 