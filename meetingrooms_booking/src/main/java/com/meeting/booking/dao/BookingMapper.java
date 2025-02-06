package com.meeting.booking.dao;

import com.meeting.booking.model.Booking;
import java.util.List;
import org.apache.ibatis.annotations.Param;

/**
 * 预订记录数据访问接口
 */
public interface BookingMapper {
    /**
     * 插入预订记录
     * @param booking 预订记录对象
     * @return 影响行数
     */
    int insert(Booking booking);
    
    /**
     * 更新预订记录
     * @param booking 预订记录对象
     * @return 影响行数
     */
    int update(Booking booking);
    
    /**
     * 删除预订记录
     * @param id 预订记录ID
     * @return 影响行数
     */
    int deleteById(Long id);
    
    /**
     * 查询所有预订记录
     * @return 预订记录列表
     */
    List<Booking> selectAll();
    
    /**
     * 通过ID查询预订记录
     * @param id 预订记录ID
     * @return 预订记录对象
     */
    Booking selectById(Long id);
    
    /**
     * 查询指定时间段内的预订记录
     * @param roomId 会议室ID
     * @param date 预订日期
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 重叠的预订记录列表
     */
    List<Booking> findOverlappingBookings(@Param("roomId") Long roomId, 
                                        @Param("date") String date, 
                                        @Param("startTime") Integer startTime, 
                                        @Param("endTime") Integer endTime);
    
    /**
     * 查询指定会议室和日期的所有预订记录
     * @param roomId 会议室ID
     * @param date 日期
     * @return 预订记录列表
     */
    List<Booking> selectByRoomAndDate(@Param("roomId") Long roomId, @Param("date") String date);

    /**
     * 分页查询预订记录
     * @param offset 偏移量
     * @param limit 每页数量
     * @param status 状态
     * @param userId 用户ID
     * @return 预订记录列表
     */
    List<Booking> selectBookingRecords(@Param("offset") int offset,
                                     @Param("limit") int limit,
                                     @Param("status") String status,
                                     @Param("userId") Long userId);

    /**
     * 获取预订记录总数
     * @param status 状态
     * @param userId 用户ID
     * @return 记录总数
     */
    int countBookingRecords(@Param("status") String status,
                           @Param("userId") Long userId);
} 