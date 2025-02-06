package com.meeting.booking.service;

import com.meeting.booking.model.Booking;
import com.meeting.booking.model.Enums.BookingEnum;

import java.util.List;

/**
 * 预订记录服务接口
 */
public interface BookingService {
    /**
     * 添加预订记录
     * @param booking 预订记录对象
     * @return 添加成功返回true，失败返回false
     */
    boolean addBooking(Booking booking);
    
    /**
     * 更新预订记录
     * @param booking 预订记录对象
     * @return 更新成功返回true，失败返回false
     */
    boolean updateBooking(Booking booking);
    
    /**
     * 删除预订记录
     * @param id 预订记录ID
     * @return 删除成功返回true，失败返回false
     */
    boolean deleteBooking(Long id);
    
    /**
     * 获取所有预订记录
     * @return 预订记录列表
     */
    List<Booking> getAllBookings();
    
    /**
     * 通过ID获取预订记录
     * @param id 预订记录ID
     * @return 预订记录对象
     */
    Booking getBookingById(Long id);
    
    /**
     * 检查时间段是否可用
     * @param roomId 会议室ID
     * @param date 预订日期
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 时间段是否可用
     */
    boolean isTimeSlotAvailable(Long roomId, String date, Integer startTime, Integer endTime);
    
    /**
     * 获取指定会议室和日期的所有预订记录
     * @param roomId 会议室ID
     * @param date 日期
     * @return 预订记录列表
     */
    List<Booking> getBookingsByRoomAndDate(Long roomId, String date);

    /**
     * 分页获取预订记录
     * @param page 页码
     * @param limit 每页数量
     * @param status 状态过滤
     * @param userId 用户ID（可选，为null时查询所有用户）
     * @return 预订记录列表
     */
    List<Booking> getBookingRecords(int page, int limit, BookingEnum status, Long userId);

    /**
     * 获取预订记录总数
     * @param status 状态过滤
     * @param userId 用户ID（可选，为null时查询所有用户）
     * @return 记录总数
     */
    int getBookingCount(BookingEnum status, Long userId);

    /**
     * 检查预订是否可以取消
     * @param booking 预订记录
     * @return 是否可以取消
     */
    boolean canCancelBooking(Booking booking);
} 