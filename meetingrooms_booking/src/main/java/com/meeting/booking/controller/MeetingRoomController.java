package com.meeting.booking.controller;

import com.meeting.booking.model.MeetingRoom;
import com.meeting.booking.service.MeetingRoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

/**
 * 会议室控制器
 */
@Controller
@RequestMapping("/meetingRooms")
public class MeetingRoomController {

    @Autowired
    private MeetingRoomService meetingRoomService;

    /**
     * 普通用户跳转到会议室列表页面
     * @return 会议室列表页面
     */
    @GetMapping("/listpage")
    public String toRoomsList() {
        return "meeting_room_list";
    }

    /**
     * 跳转到会议室管理页面，只有管理员可以访问
     * @return 会议室管理页面
     */
    @GetMapping("/manage")
    public String toManagementPage(HttpSession session) {
        if (session.getAttribute("currentUserRole").equals("ROLE_ADMIN")) {
            return "meeting_room_manage";
        }
        return "redirect:/users/login";
    }

    /**
     * 获取会议室列表，普通用户可以访问
     * @return 会议室列表
     */
    @GetMapping("/roomsList")
    @ResponseBody
    public ResponseEntity<?> listMeetingRoomsForUser(@RequestParam(defaultValue = "1") int page,
                                                     @RequestParam(defaultValue = "10") int limit,
                                                     @RequestParam(defaultValue = "") String name) {
        List<MeetingRoom> meetingRooms = meetingRoomService.getAllMeetingRooms(page, limit, name);
        int total = meetingRooms.size();
        Map<String, Object> response = new HashMap<>();
        response.put("meetingRooms", meetingRooms);
        response.put("total", total);
        response.put("status", 0);
        response.put("message", "获取会议室列表成功");
        return ResponseEntity.ok(response);
    }

    /**
     * 获取会议室列表
     * @return 会议室列表
     */
    @GetMapping("/list")
    @ResponseBody
    public ResponseEntity<?> listMeetingRooms(@RequestParam(defaultValue = "1") int page,
                                               @RequestParam(defaultValue = "10") int limit,
                                               @RequestParam(defaultValue = "") String name,
                                               HttpSession session) {
        if (session.getAttribute("currentUserRole").equals("ROLE_ADMIN")) {
            List<MeetingRoom> meetingRooms = meetingRoomService.getAllMeetingRooms(page, limit, name);
            int total = meetingRooms.size();
            Map<String, Object> response = new HashMap<>();
            response.put("meetingRooms", meetingRooms);
            response.put("total", total);
            response.put("status", 0);


            response.put("message", "获取会议室列表成功");
            return ResponseEntity.ok(response);
        }
        return ResponseEntity.status(403).body("无权限");
    }


    /**
     * 添加会议室
     * @param meetingRoom 会议室信息
     * @return 添加结果
     */
    @PostMapping("/add")
    @ResponseBody
    public ResponseEntity<?> addMeetingRoom(@RequestBody MeetingRoom meetingRoom, HttpSession session) {
        if (session.getAttribute("currentUserRole").equals("ROLE_ADMIN")) {
            if (meetingRoomService.addMeetingRoom(meetingRoom)) {
                return ResponseEntity.ok("添加成功");
            }

            return ResponseEntity.badRequest().body("添加失败");
        }
        return ResponseEntity.status(403).body("无权限");
    }

    /**
     * 更新会议室
     * @param meetingRoom 会议室信息
     * @return 更新结果
     */
    @PutMapping("/update")
    @ResponseBody
    public ResponseEntity<?> updateMeetingRoom(@RequestBody MeetingRoom meetingRoom, HttpSession session) {
        if (session.getAttribute("currentUserRole").equals("ROLE_ADMIN")) {
            if (meetingRoomService.updateMeetingRoom(meetingRoom)) {
                return ResponseEntity.ok("更新成功");
            }

            return ResponseEntity.badRequest().body("更新失败");
        }
        return ResponseEntity.status(403).body("无权限");
    }

    /**
     * 删除会议室
     * @param id 会议室ID
     * @return 删除结果
     */
    @DeleteMapping("/delete/{id}")
    @ResponseBody
    public ResponseEntity<?> deleteMeetingRoom(@PathVariable Long id, HttpSession session) {
        if (session.getAttribute("currentUserRole").equals("ROLE_ADMIN")) {
            if (meetingRoomService.deleteMeetingRoom(id)) {
                return ResponseEntity.ok("删除成功");
            }

            return ResponseEntity.badRequest().body("删除失败");
        }
        return ResponseEntity.status(403).body("无权限");
    }
} 