package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueMapper {

    /**
     * 保存创建的线索
     */
    int insertClue(Clue clue);

    /**
     *根据条件查询线索并分页
     */
    List<Clue> selectAllClueByConditionForPage(Map<String,Object> map);

    /**
     * 查询符合条件的线索的记录条数
     */
    int selectCountOfClueByCondition(Map<String,Object> map);

    /**
     * 根据ids删除线索（可删除多个）
     */
    int deleteClueByIds(String[] ids);

    /**
     * 根据id查询线索的明细信息，跳转到详情页面
     */
    Clue selectClueForDetailById(String id);

    /**
     * 根据id查询线索，转到修改窗口，不需要连接表查询
     */
    Clue selectClueById(String id);

    /**
     * 更新线索信息
     */
    int updateClueById(Clue clue);

    /**
     * 根据id删除线索
     */
    int deleteClueById(String id);
}