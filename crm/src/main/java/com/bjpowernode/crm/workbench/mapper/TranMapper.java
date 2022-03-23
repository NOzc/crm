package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.FunnelVO;
import com.bjpowernode.crm.workbench.domain.Tran;

import java.util.List;

public interface TranMapper {

    /**
     * 保存创建的交易
     */
    int insertTran(Tran tran);

    /**
     * 根据id查询交易的明细信息
     */
    Tran selectTranForDetailById(String id);

    /**
     * 查询交易表中各个阶段的数据量
     */
    List<FunnelVO> selectCountOfTranGroupByStage();
}