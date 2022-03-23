package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationMapper {
    /**
     * 批量保存创建的线索和市场活动的关联关系
     */
    int insertClueActivityRelationByList(List<ClueActivityRelation> list);

    /**
     * 根据clueId和activityId解除线索和市场活动的关联关系
     */
    int deleteClueActivityRelationByClueIdActivityId(ClueActivityRelation relation);

    /**
     * 根据clueId查询该线索和市场活动的关联关系，用于将关联关系转移到联系人和市场活动关联关系表中
     */
    List<ClueActivityRelation> selectClueActivityRelationByClueId(String clueId);

    /**
     * 根据线索的id删除该线索和市场活动的关联关系
     */
    int deleteClueActivityRelationByClueId(String clueId);
}