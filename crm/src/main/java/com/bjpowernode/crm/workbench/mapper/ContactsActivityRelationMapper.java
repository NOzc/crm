package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.ContactsActivityRelation;

import java.util.List;

public interface ContactsActivityRelationMapper {

    /**
     * 批量保存联系人-市场活动关联关系(从线索-市场活动关联关系表中转换过来)
     */
    int insertContactsActivityRelationByList(List<ContactsActivityRelation> list);
}