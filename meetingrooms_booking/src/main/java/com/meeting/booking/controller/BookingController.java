package com.meeting.booking.controller;

import com.meeting.booking.model.Booking;
import com.meeting.booking.service.BookingService;
import com.meeting.booking.service.MeetingRoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.HashMap;
import java.util.Map;
import com.meeting.booking.model.User;
import com.meeting.booking.model.Enums.BookingEnum;
import java.time.LocalDate;
import java.util.ArrayList;

/**
 * 预订记录控制器
 */
@Controller
@RequestMapping("/bookings")
public class BookingController {

    @Autowired
    private BookingService bookingService;

    @Autowired  
    private MeetingRoomService meetingRoomService;

    /**
     * 检查时间段是否可用
     * @param roomId 会议室ID
     * @param date 预订日期
     * @param startTime 开始时间

     * @param endTime 结束时间
     * @return 时间段是否可用
     */
    @GetMapping("/checkTimeSlot")
    @ResponseBody
    public ResponseEntity<?> checkTimeSlot(
            @RequestParam Long roomId,
            @RequestParam String date,
            @RequestParam Integer startTime,
            @RequestParam Integer endTime) {
        boolean isAvailable = bookingService.isTimeSlotAvailable(roomId, date, startTime, endTime);
        Map<String, Object> response = new HashMap<>();
        response.put("available", isAvailable);
        return ResponseEntity.ok(response);
    }

    /**
     * 添加预订记录
     * @param booking 预订记录信息
     * @return 添加结果
     */
    @PostMapping("/add")
    @ResponseBody
    public ResponseEntity<?> addBooking(@RequestBody Booking booking, HttpSession session) {
        if (session.getAttribute("user") == null) {
            return ResponseEntity.status(401).body("请先登录");
        }

        // 获取当前用户ID
        User user = (User) session.getAttribute("user");
        booking.setUserId(user.getId());

        // 检查时间段是否可用
        if (!bookingService.isTimeSlotAvailable(booking.getRoomId(), booking.getDate().toString(), booking.getStartTime(), booking.getEndTime())) {
            return ResponseEntity.badRequest().body("该时间段已被预订");
        }

        // 设置预订状态为待审核
        booking.setStatus(BookingEnum.PENDING);

        if (bookingService.addBooking(booking)) {
            return ResponseEntity.ok("预订成功，等待管理员审核");
        }
        return ResponseEntity.badRequest().body("预订失败");
    }

    /**
     * 更新预订记录
     * @param booking 预订记录信息
     * @return 更新结果
     */
    @PutMapping("/update")
    @ResponseBody
    public ResponseEntity<?> updateBooking(@RequestBody Booking booking, HttpSession session) {
        // 管理员和普通用户都可以进行操作
        if (session.getAttribute("currentUserRole").equals("ROLE_USER") || session.getAttribute("currentUserRole").equals("ROLE_ADMIN")) {
            if (bookingService.updateBooking(booking)) {
                return ResponseEntity.ok("更新成功");

            }
            return ResponseEntity.badRequest().body("更新失败");
        }
        return ResponseEntity.status(403).body("无权限");
    }

    /**
     * 获取所有预订记录
     * @return 预订记录列表
     */
    @GetMapping("/list")
    @ResponseBody
    public ResponseEntity<?> listBookings(HttpSession session) {
        if (session.getAttribute("currentUserRole").equals("ROLE_USER") || session.getAttribute("currentUserRole").equals("ROLE_ADMIN")) {
            List<Booking> bookings = bookingService.getAllBookings();
            Map<String, Object> response = new HashMap<>();
            response.put("bookings", bookings);
            response.put("status", 0);
            response.put("message", "获取预订记录成功");
            return ResponseEntity.ok(response);
        }
        return ResponseEntity.status(403).body("无权限");
    }

    /**
     * 获取会议室未来三天的预订情况
     * @param roomId 会议室ID
     * @return 预订情况
     */
    @GetMapping("/room/{roomId}/schedule")
    @ResponseBody
    public ResponseEntity<?> getRoomSchedule(@PathVariable Long roomId) {
        try {
            // 获取今天、明天、后天的日期
            LocalDate today = LocalDate.now();
            List<Map<String, Object>> scheduleList = new ArrayList<>();
            
            // 获取三天的预订情况
            for (int i = 0; i < 3; i++) {
                LocalDate date = today.plusDays(i);
                List<Booking> bookings = bookingService.getBookingsByRoomAndDate(roomId, date.toString());
                
                Map<String, Object> daySchedule = new HashMap<>();
                daySchedule.put("date", date.toString());
                daySchedule.put("bookings", bookings);
                scheduleList.add(daySchedule);
            }
            
            Map<String, Object> response = new HashMap<>();
            response.put("schedule", scheduleList);
            response.put("status", 0);
            response.put("message", "获取预订情况成功");
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500).body("获取预订情况失败：" + e.getMessage());
        }
    }

    /**
     * 跳转到预订记录页面
     */
    @GetMapping("/record")
    public String toBookingRecord() {
        return "booking_record";
    }

    /**
     * 获取预订记录列表（分页）
     */
    @GetMapping("/record/list")
    @ResponseBody
    public ResponseEntity<?> getBookingRecords(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int limit,
            @RequestParam(required = false) BookingEnum status,
            HttpSession session) {
        
        User currentUser = (User) session.getAttribute("user");
        String userRole = (String) session.getAttribute("currentUserRole");
        
        if (currentUser == null) {
            return ResponseEntity.status(401).body("请先登录");
        }

        try {
            List<Booking> bookings;
            int total;
            if ("ROLE_ADMIN".equals(userRole)) {
                // 管理员可以查看所有记录
                bookings = bookingService.getBookingRecords(page, limit, status, null);
                //将bookings中的roomName信息添加到bookings中    
                for (Booking booking : bookings) {
                    booking.setRoomName(meetingRoomService.getMeetingRoomById(booking.getRoomId()).getName());
                    booking.setStringDate(booking.getDate().toString());
                    // 添加操作权限标志
                    Map<String, Object> bookingMap = new HashMap<>();
                    bookingMap.put("canReview", booking.getStatus() == BookingEnum.PENDING);
                    bookingMap.put("canCancel", false);
                    booking.setOperations(bookingMap);
                }
                total = bookingService.getBookingCount(status, null);
            } else {
                // 普通用户只能查看自己的记录
                bookings = bookingService.getBookingRecords(page, limit, status, currentUser.getId());  
                //将bookings中的roomName信息添加到bookings中    
                for (Booking booking : bookings) {
                    booking.setRoomName(meetingRoomService.getMeetingRoomById(booking.getRoomId()).getName());
                    booking.setStringDate(booking.getDate().toString());
                    // 添加操作权限标志
                    Map<String, Object> bookingMap = new HashMap<>();
                    bookingMap.put("canReview", false);
                    bookingMap.put("canCancel", bookingService.canCancelBooking(booking));
                    booking.setOperations(bookingMap);
                }
                total = bookingService.getBookingCount(status, currentUser.getId());
            }

            Map<String, Object> response = new HashMap<>();
            response.put("status", 200);
            response.put("msg", "获取预订记录成功");
            response.put("count", total);
            response.put("data", bookings);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            return ResponseEntity.status(500).body("获取预订记录失败：" + e.getMessage());
        }
    }

    /**
     * 取消预订
     */
    @PostMapping("/cancel/{id}")
    @ResponseBody
    public ResponseEntity<?> cancelBooking(@PathVariable Long id, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        String userRole = (String) session.getAttribute("currentUserRole");
        
        if (currentUser == null) {
            return ResponseEntity.status(401).body("请先登录");
        }

        try {
            Booking booking = bookingService.getBookingById(id);
            if (booking == null) {
                return ResponseEntity.badRequest().body("预订记录不存在");
            }

            // 检查权限
            if (!"ROLE_ADMIN".equals(userRole) && !booking.getUserId().equals(currentUser.getId())) {
                return ResponseEntity.status(403).body("无权限操作此预订记录");
            }

            // 检查是否可以取消（距离开始时间一小时以上）
            if (!bookingService.canCancelBooking(booking)) {
                return ResponseEntity.badRequest().body("距离会议开始时间不足一小时，无法取消");
            }

            booking.setStatus(BookingEnum.CANCELLED);
            if (bookingService.updateBooking(booking)) {
                return ResponseEntity.ok("取消预订成功");
            } else {
                return ResponseEntity.badRequest().body("取消预订失败");
            }
        } catch (Exception e) {
            return ResponseEntity.status(500).body("取消预订失败：" + e.getMessage());
        }
    }

    /**
     * 审核预订
     */
    @PostMapping("/review/{id}")
    @ResponseBody
    public ResponseEntity<?> reviewBooking(
            @PathVariable Long id,
            @RequestParam boolean approved,
            HttpSession session) {
        
        if (!"ROLE_ADMIN".equals(session.getAttribute("currentUserRole"))) {
            return ResponseEntity.status(403).body("无权限进行审核");
        }

        try {
            Booking booking = bookingService.getBookingById(id);
            if (booking == null) {
                return ResponseEntity.badRequest().body("预订记录不存在");
            }

            if (booking.getStatus() != BookingEnum.PENDING) {
                return ResponseEntity.badRequest().body("该预订记录不在待审核状态");
            }

            booking.setStatus(approved ? BookingEnum.APPROVED : BookingEnum.REJECTED);
            if (bookingService.updateBooking(booking)) {
                return ResponseEntity.ok(approved ? "审核通过" : "审核拒绝");
            } else {
                return ResponseEntity.badRequest().body("审核操作失败");
            }
        } catch (Exception e) {
            return ResponseEntity.status(500).body("审核失败：" + e.getMessage());
        }
    }
} 