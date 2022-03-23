package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.ContactsRemark;

import java.util.List;

public interface ContactsRemarkMapper {

    /**
     * 批量保存联系人备注(从线索备注表中转换过来)
     */
    int insertContactsRemarkByList(List<ContactsRemark> list);
}