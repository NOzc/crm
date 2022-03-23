package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueService {

    int saveCreateClue(Clue clue);

    List<Clue> queryClueByConditionForPage(Map<String,Object> map);

    int queryCountOfClueByCondition(Map<String,Object> map);

    int deleteClueByIds(String[] ids);

    Clue queryClueForDetailById(String id);

    Clue queryClueById(String id);

    int saveEditClueById(Clue clue);

    void saveConvertClue(Map<String,Object> map);
}
