package com.meeting.booking.dao;

import com.meeting.booking.model.MeetingRoom;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 会议室数据访问接口
 */
public interface MeetingRoomMapper {
    /**
     * 插入会议室
     * @param meetingRoom 会议室对象
     * @return 影响行数
     */
    int insert(MeetingRoom meetingRoom);
    
    /**
     * 更新会议室
     * @param meetingRoom 会议室对象
     * @return 影响行数
     */
    int update(MeetingRoom meetingRoom);
    
    /**
     * 删除会议室
     * @param id 会议室ID
     * @return 影响行数
     */
    int deleteById(Long id);
    
    /**
     * 查询所有会议室
     * @return 会议室列表
     */
    List<MeetingRoom> selectAll(@Param("offset") int offset, @Param("limit") int limit, @Param("name") String name);
    
    /**
     * 通过ID查询会议室
     * @param id 会议室ID
     * @return 会议室对象
     */
    MeetingRoom selectById(Long id);
} 