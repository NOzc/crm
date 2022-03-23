package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityMapper {

    /**
     * 保存创建的市场活动
     */
    int insertActivity(Activity activity);

    /**
     * 根据条件分页查询市场活动
     */
    List<Activity> selectActivityByConditionForPage(Map<String,Object> map);

    /**
     * 根据条件查询市场活动的总条数
     */
    int selectCountOfActivityByCondition(Map<String,Object> map);

    /**
     * 根据id组成的数组批量删除市场活动
     */
    int deleteActivityByIds(String[] ids);

    /**
     * 根据id查询市场活动的信息
     */
    Activity selectActivityById(String id);

    /**
     * 保存修改的市场活动
     */
    int updateActivity(Activity activity);

    /**
     * 查询所有的市场活动,用于导出
     */
    List<Activity> selectAllActivity();

    /**
     * 批量保存导入的市场活动
     */
    int insertActivityByList(List<Activity> activityList);

    /**
     * 根据id查询市场活动详细信息
     */
    Activity selectActivityForDetailById(String id);

    /**
     * 根据ClueId查询该线索相关联的市场活动的明细信息
     */
    List<Activity> selectActivityForDetailByClueId(String clueId);

    /**
     * 根据name模糊查询市场活动，并且把已经跟clueId关联过的市场活动排除
     */
    List<Activity> selectActivityForDetailByNameClueId(Map<String, Object> map);

    /**
     * 根据ids查询市场活动的明细信息
     */
    List<Activity> selectActivityForDetailByIds(String[] ids);

    /**
     * 根据name模糊查询市场活动，并且查询跟clueId关联过的市场活动
     */
    List<Activity> selectActivityForConvertByNameClueId(Map<String,Object> map);

    /**
     * 根据name模糊查询市场活动
     */
    List<Activity> selectActivityForSaveByName(String activityName);

}