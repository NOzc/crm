package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkMapper {

    /**
     * 根据线索id查询该线索下的所有备注
     */
   List<ClueRemark> selectClueRemarkForDetailByClueId(String clueId);

    /**
     * 根据线索id查询该线索下所有备注，涉及表中数据的转移，不是给用户看的，不需要关联表查询
     */
   List<ClueRemark> selectClueRemarkByClueId(String clueId);

    /**
     * 根据线索的id删除该线索下的所有备注
     */
   int deleteClueRemarkByClueId(String clueId);
}