package com.meeting.booking.service.impl;

import com.meeting.booking.dao.BookingMapper;
import com.meeting.booking.model.Booking;
import com.meeting.booking.model.Enums.BookingEnum;
import com.meeting.booking.service.BookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;

/**
 * 预订记录服务实现类
 */
@Service
public class BookingServiceImpl implements BookingService {
    
    @Autowired
    private BookingMapper bookingMapper;
    
    @Override
    public boolean isTimeSlotAvailable(Long roomId, String date, Integer startTime, Integer endTime) {
        // 检查是否有时间重叠的预订
        List<Booking> existingBookings = bookingMapper.findOverlappingBookings(roomId, date, startTime, endTime);
        return existingBookings.isEmpty();
    }
    
    @Override
    public boolean addBooking(Booking booking) {
        // 检查时间段是否可用
        if (!isTimeSlotAvailable(booking.getRoomId(), booking.getDate().toString(), booking.getStartTime(), booking.getEndTime())) {
            return false;
        }
        return bookingMapper.insert(booking) > 0;
    }
    
    @Override
    public boolean updateBooking(Booking booking) {
        return bookingMapper.update(booking) > 0;
    }
    
    @Override
    public boolean deleteBooking(Long id) {
        return bookingMapper.deleteById(id) > 0;
    }
    
    @Override
    public List<Booking> getAllBookings() {
        return bookingMapper.selectAll();
    }
    
    @Override
    public Booking getBookingById(Long id) {
        return bookingMapper.selectById(id);
    }
    
    @Override
    public List<Booking> getBookingsByRoomAndDate(Long roomId, String date) {
        return bookingMapper.selectByRoomAndDate(roomId, date);
    }

    @Override
    public List<Booking> getBookingRecords(int page, int limit, BookingEnum status, Long userId) {
        int offset = (page - 1) * limit;
        return bookingMapper.selectBookingRecords(offset, limit, 
            status != null ? status.name() : null, userId);
    }

    @Override
    public int getBookingCount(BookingEnum status, Long userId) {
        return bookingMapper.countBookingRecords(
            status != null ? status.name() : null, userId);
    }

    @Override
    public boolean canCancelBooking(Booking booking) {
        if (booking == null) {
            return false;
        }

        // 只有待审核和已通过的预订可以取消
        if (booking.getStatus() != BookingEnum.PENDING && 
            booking.getStatus() != BookingEnum.APPROVED) {
            return false;
        }

        // 检查是否距离开始时间超过一小时
        LocalDate bookingDate = booking.getDate();
        LocalTime startTime = LocalTime.of(booking.getStartTime(), 0);
        LocalDateTime bookingDateTime = LocalDateTime.of(bookingDate, startTime);
        LocalDateTime now = LocalDateTime.now();

        return bookingDateTime.minusHours(1).isAfter(now);
    }
} 