package com.meeting.booking.service.impl;

import com.meeting.booking.dao.MeetingRoomMapper;
import com.meeting.booking.model.MeetingRoom;
import com.meeting.booking.service.MeetingRoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

/**
 * 会议室服务实现类
 */
@Service
public class MeetingRoomServiceImpl implements MeetingRoomService {
    
    @Autowired
    private MeetingRoomMapper meetingRoomMapper;
    
    @Override
    public boolean addMeetingRoom(MeetingRoom meetingRoom) {
        return meetingRoomMapper.insert(meetingRoom) > 0;
    }
    
    @Override
    public boolean updateMeetingRoom(MeetingRoom meetingRoom) {
        return meetingRoomMapper.update(meetingRoom) > 0;
    }
    
    @Override
    public boolean deleteMeetingRoom(Long id) {
        return meetingRoomMapper.deleteById(id) > 0;
    }
    
    @Override
    public List<MeetingRoom> getAllMeetingRooms(int page, int limit, String name) {
        int offset = (page - 1) * limit;
        return meetingRoomMapper.selectAll(offset, limit, name);
    }
    


    @Override
    public MeetingRoom getMeetingRoomById(Long id) {
        return meetingRoomMapper.selectById(id);
    }
} 