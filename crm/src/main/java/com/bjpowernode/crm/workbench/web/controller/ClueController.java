package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.constants.Constants;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.DicValueService;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Clue;
import com.bjpowernode.crm.workbench.domain.ClueActivityRelation;
import com.bjpowernode.crm.workbench.domain.ClueRemark;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.bjpowernode.crm.workbench.service.ClueActivityRelationService;
import com.bjpowernode.crm.workbench.service.ClueRemarkService;
import com.bjpowernode.crm.workbench.service.ClueService;
import com.sun.xml.internal.bind.v2.runtime.reflect.opt.Const;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class ClueController {

    @Autowired
    private UserService userService;
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private ClueService clueService;
    @Autowired
    private ClueRemarkService clueRemarkService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ClueActivityRelationService clueActivityRelationService;

    @RequestMapping("/workbench/clue/index.do")
    public ModelAndView index(){
        ModelAndView mv = new ModelAndView();
        //所有用户
        List<User> userList = userService.queryAllUsers();
        //称呼
        List<DicValue> appellationList = dicValueService.queryDicValueByTypeCode("appellation");
        //线索来源
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        //线索状态
        List<DicValue> clueStateList = dicValueService.queryDicValueByTypeCode("clueState");

        mv.addObject("userList",userList);
        mv.addObject("appellationList",appellationList);
        mv.addObject("sourceList",sourceList);
        mv.addObject("clueStateList",clueStateList);
        mv.setViewName("workbench/clue/index");
        return mv;
    }

    @RequestMapping("/workbench/clue/saveCreateClue.do")
    @ResponseBody
    public Object saveCreateClue(Clue clue, HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        //封装参数
        clue.setId(UUIDUtils.getUUID());
        clue.setCreateTime(DateUtils.formateDateTime(new Date()));
        clue.setCreateBy(user.getId());
        ReturnObject res = new ReturnObject();
        try {
            //调用service层方法
            int count = clueService.saveCreateClue(clue);
            if (count>0){
                res.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                res.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                res.setMessage("系统忙，请稍后重试....");
            }
        }catch (Exception e){
            e.printStackTrace();
            res.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            res.setMessage("系统忙，请稍后重试....");
        }
        return res;
    }

    @RequestMapping("/workbench/clue/queryClueByConditionForPage.do")
    @ResponseBody
    public Object queryClueByConditionForPage(String fullname,String company,String phone,String source,String owner,
                                              String mphone,String state,Integer pageNo,Integer pageSize){
        //封装参数
        Map<String,Object> map=new HashMap<>();
        map.put("fullname",fullname);
        map.put("company",company);
        map.put("phone",phone);
        map.put("source",source);
        map.put("owner",owner);
        map.put("mphone",mphone);
        map.put("state",state);
        map.put("pageNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);
        //调用service层方法
        List<Clue> clueList = clueService.queryClueByConditionForPage(map);
        for (Clue clue: clueList){
            System.out.println(clue);
        }
        int totalRows = clueService.queryCountOfClueByCondition(map);
        Map<String,Object> res=new HashMap<>();
        res.put("clueList",clueList);
        res.put("totalRows",totalRows);
        return res;
    }

    @RequestMapping("/workbench/clue/deleteClueByIds.do")
    @ResponseBody
    public Object deleteClueByIds(String[] id){
        ReturnObject res = new ReturnObject();
        try{
            int count = clueService.deleteClueByIds(id);
            if (count>0){
                res.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                res.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                res.setMessage("系统忙，请稍后重试....");
            }
        }catch (Exception e){
            e.printStackTrace();
            res.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            res.setMessage("系统忙，请稍后重试....");
        }
        return res;
    }

    @RequestMapping("/workbench/clue/detailClue.do")
    public String detailClue(String id, HttpServletRequest request){
        //调用service层方法
        Clue clue = clueService.queryClueForDetailById(id);
        List<ClueRemark> remarkList = clueRemarkService.queryClueRemarkForDetailByClueId(id);
        List<Activity> activityList = activityService.queryActivityForDetailByClueId(id);
        request.setAttribute("clue",clue);
        request.setAttribute("remarkList",remarkList);
        request.setAttribute("activityList",activityList);
        return "workbench/clue/detail";
    }

    @RequestMapping("/workbench/clue/queryClueById.do")
    @ResponseBody
    //用于初始化修改模态窗口
    public Object queryClueById(String id){
        //调用service层方法
        Clue clue = clueService.queryClueById(id);
        return clue;
    }

    @RequestMapping("/workbench/clue/saveEditClueById.do")
    @ResponseBody
    public Object saveEditClueById(Clue clue,HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        clue.setEditBy(user.getId());
        clue.setEditTime(DateUtils.formateDateTime(new Date()));
        ReturnObject res = new ReturnObject();
        try {
            int count = clueService.saveEditClueById(clue);
            if (count>0){
                res.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                res.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                res.setMessage("系统忙，请稍后重试....");
            }
        }catch (Exception e){
            e.printStackTrace();
            res.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            res.setMessage("系统忙，请稍后重试....");
        }
        return res;
    }

    @RequestMapping("/workbench/clue/queryActivityForDetailByNameClueId.do")
    @ResponseBody
    public Object queryActivityForDetailByNameClueId(String activityName,String clueId){
        Map<String,Object> map = new HashMap<>();
        map.put("activityName",activityName);
        map.put("clueId",clueId);
        List<Activity> activityList = activityService.queryActivityForDetailByNameClueId(map);
        return activityList;
    }

    @RequestMapping("/workbench/clue/saveBund.do")
    @ResponseBody
    public Object saveBund(String[] activityId,String clueId){
        ClueActivityRelation relation=null;
        List<ClueActivityRelation> list = new ArrayList<>();
        for(String id:activityId){
            relation = new ClueActivityRelation();
            relation.setId(UUIDUtils.getUUID());
            relation.setActivityId(id);
            relation.setClueId(clueId);
            list.add(relation);
        }
        ReturnObject res = new ReturnObject();
        try {
            //调用service层方法，批量保存线索和市场活动的关联关系
            int count = clueActivityRelationService.saveCreateClueActivityRelationByList(list);
            if (count>0){
                res.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                List<Activity> activityList = activityService.queryActivityForDetailByIds(activityId);
                res.setReData(activityList);
            }else{
                res.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                res.setMessage("系统忙，请稍后重试....");
            }
        }catch(Exception e){
            e.printStackTrace();
            res.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            res.setMessage("系统忙，请稍后重试....");
        }
        return res;
    }

    @RequestMapping("/workbench/clue/saveUnbund.do")
    @ResponseBody
    public Object saveUnbund(ClueActivityRelation relation){
        ReturnObject res = new ReturnObject();
        try {
            int count = clueActivityRelationService.deleteClueActivityRelationByClueIdActivityId(relation);
            if (count>0){
                res.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                res.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                res.setMessage("系统忙，请稍后重试....");
            }
        }catch (Exception e){
            e.printStackTrace();
            res.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            res.setMessage("系统忙，请稍后重试....");
        }
        return res;
    }

    @RequestMapping("/workbench/clue/toConvert.do")
    public String toConvert(String id,HttpServletRequest request){
        Clue clue = clueService.queryClueForDetailById(id);
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        request.setAttribute("clue",clue);
        request.setAttribute("stageList",stageList);
        return "workbench/clue/convert";
    }

    @RequestMapping("/workbench/clue/queryActivityForConvertByNameClueId.do")
    @ResponseBody
    public Object queryActivityForConvertByNameClueId(String activityName,String clueId){
        //封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("activityName",activityName);
        map.put("clueId",clueId);
        //调用service层方法
        List<Activity> activityList = activityService.queryActivityForConvertByNameClueId(map);
        return activityList;
    }

    @RequestMapping("/workbench/clue/convertClue.do")
    @ResponseBody
    public Object convertClue(String clueId,String money,String name,String expectedDate,String stage,String activityId,String isCreateTran,HttpSession session){
        //封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("clueId",clueId);
        map.put("money",money);
        map.put("name",name);
        map.put("expectedDate",expectedDate);
        map.put("stage",stage);
        map.put("activityId",activityId);
        map.put("isCreateTran",isCreateTran);
        map.put(Constants.SESSION_USER,session.getAttribute(Constants.SESSION_USER));
        ReturnObject res = new ReturnObject();
        try {
            //调用service层方法
            clueService.saveConvertClue(map);
            res.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        }catch (Exception e){
            e.printStackTrace();
            res.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            res.setMessage("系统忙，请稍后重试");
        }
        return res;
    }
}
