package com.meeting.booking.service;

import com.meeting.booking.model.MeetingRoom;
import java.util.List;

/**
 * 会议室服务接口
 */
public interface MeetingRoomService {
    /**
     * 添加会议室
     * @param meetingRoom 会议室对象
     * @return 添加成功返回true，失败返回false
     */
    boolean addMeetingRoom(MeetingRoom meetingRoom);
    
    /**
     * 更新会议室
     * @param meetingRoom 会议室对象
     * @return 更新成功返回true，失败返回false
     */
    boolean updateMeetingRoom(MeetingRoom meetingRoom);
    
    /**
     * 删除会议室
     * @param id 会议室ID
     * @return 删除成功返回true，失败返回false
     */
    boolean deleteMeetingRoom(Long id);
    
    /**
     * 获取所有会议室
     * @return 会议室列表
     */
    List<MeetingRoom> getAllMeetingRooms(int page, int limit, String name);
    
    /**
     * 通过ID获取会议室
     * @param id 会议室ID
     * @return 会议室对象
     */
    MeetingRoom getMeetingRoomById(Long id);
} 