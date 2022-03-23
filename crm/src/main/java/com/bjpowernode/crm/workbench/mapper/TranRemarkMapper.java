package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.TranRemark;

import java.util.List;

public interface TranRemarkMapper {

    /**
     * 批量保存创建的交易备注信息(从线索备注表中转换过来)
     */
    int insertTranRemarkByList(List<TranRemark> list);

    /**
     * 根据交易id查询交易的备注信息
     */
    List<TranRemark> selectTranRemarkForDetailByTranId(String tranId);
}