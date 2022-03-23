package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.Contacts;

import java.util.List;

public interface ContactsMapper {

    /**
     *保存创建的联系人
     */
    int insertContacts(Contacts contacts);

    /**
     * 根据名称模糊查询联系人
     */
    List<Contacts> selectContactsForSaveByName(String fullname);
}