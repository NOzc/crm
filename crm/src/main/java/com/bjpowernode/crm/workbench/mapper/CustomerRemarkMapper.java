package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkMapper {

    /**
     * 批量保存创建的客户备注(从线索备注表中转换进来)
     */
    int insertCustomerRemarkByList(List<CustomerRemark> list);
}