package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryMapper {
    /**
     * 保存创建的交易历史
     */
    int insertTranHistory(TranHistory tranHistory);

    /**
     * 根据交易id查询该交易下的交易历史
     */
    List<TranHistory> selectTranHistoryForDetailByTranId(String tranId);
}