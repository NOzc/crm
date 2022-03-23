package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.constants.Constants;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.commons.utils.HSSFUtils;
import com.bjpowernode.crm.commons.utils.UUIDUtils;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.service.ActivityRemarkService;
import com.bjpowernode.crm.workbench.service.ActivityService;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.util.*;

@Controller
public class ActivityController {

    @Autowired
    private UserService userService;

    @Autowired
    private ActivityService activityService;

    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/workbench/activity/index.do")
    public ModelAndView index(){
        ModelAndView md = new ModelAndView();
        List<User> users = userService.queryAllUsers();
        md.addObject("users",users);
        md.setViewName("workbench/activity/index");
        return md;
    }

    @RequestMapping("/workbench/activity/saveCreateActivity.do")
    @ResponseBody
    public Object saveCreateActivity(Activity activity, HttpSession session) {
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        // 封装缺少的参数
        activity.setId(UUIDUtils.getUUID());
        activity.setCreateTime(DateUtils.formateDateTime(new Date()));
        activity.setCreateBy(user.getId());
        // 报异常失败，不报异常进一步判断影响记录条数
        ReturnObject res = new ReturnObject();
        try {
            // 调用service层的方法插入数据
            int count = activityService.saveCreateActivity(activity);
            if (count > 0) {
                res.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                res.setMessage("创建成功");
            }else {
                res.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                res.setMessage("系统忙，请稍后重试....");
            }
        }catch (Exception e){
            e.printStackTrace();
            res.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            res.setMessage("系统忙，请稍后重试");
        }
        return res;
    }

    @RequestMapping("/workbench/activity/queryActivityByConditionForPage")
    @ResponseBody
    public Object queryActivityByConditionForPage(String name,String owner,String startDate,String endDate,
                                                  Integer pageNo,Integer pageSize){
        // 封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);
        // 调用service得到结果
        List<Activity> activityList = activityService.queryActivityByConditionForPage(map);
        int totalRows = activityService.queryCountOfActivityByCondition(map);
        // 生成响应信息
        HashMap<String, Object> res = new HashMap<>();
        res.put("activityList",activityList);
        res.put("totalRows",totalRows);
        return res;
    }

    @RequestMapping("/workbench/activity/deleteActivityByIds.do")
    @ResponseBody
    public Object deleteActivityByIds(String[] id){
        ReturnObject res = new ReturnObject();
        try {
            //调用service层方法删除市场活动
            int count = activityService.deleteActivityByIds(id);
            if (count > 0){
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

    @RequestMapping("/workbench/activity/queryActivityById.do")
    @ResponseBody
    public Object queryActivityById(String id){
        //调用service查询市场活动
        Activity activity = activityService.queryActivityById(id);
        return activity;
    }

    @RequestMapping("/workbench/activity/saveEditActivity.do")
    @ResponseBody
    public Object saveEditActivity(Activity activity,HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        //封装参数
        activity.setEditTime(DateUtils.formateDateTime(new Date()));
        activity.setEditBy(user.getId());
        ReturnObject res = new ReturnObject();
        try {
            //调用service层方法更新数据
            int count = activityService.saveEditActivity(activity);
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

    //演示文件下载
    @RequestMapping("/workbench/activity/fileDownload.do")
    public void fileDownload(HttpServletResponse response) throws IOException {
        //读服务器磁盘上的Excel文件
        //1.设置响应类型,二进制文件
        response.setContentType("application/octet-stream;charset=UTF-8");
        //2.获取输出流(字节流)
        OutputStream out = response.getOutputStream();

        //浏览器接收到响应信息之后，默认情况下，直接在显示窗口中打开响应信息
        //设置响应头信息，使浏览器接收到响应信息之后，直接激活文件下载窗口
        response.addHeader("Content-Disposition","attachment;filename=mystudentList.xls");
        //3.读取Excel文件(InputStream),输出到浏览器(OutputStream)
        InputStream is = new FileInputStream("C:\\Users\\Administrator\\Desktop\\workspace\\serverDir\\studentList.xls");
        byte[] buff = new byte[256];//缓冲区
        int len = 0;
        while ((len=is.read(buff))!= -1){//每次读取一个缓冲区直到返回值为-1
            out.write(buff,0,len);//每次写缓冲区，从每个缓冲区0开始，到缓冲区结束
        }
        //关闭资源
        is.close();
        out.flush();//由tomcat关闭
    }

    //批量导出
    @RequestMapping("/workbench/activity/exportAllActivity.do")
    public void exportAllActivity(HttpServletResponse response) throws IOException {
        //调用service层方法查询所有的市场活动
        List<Activity> activityList = activityService.queryAllActivity();
        //创建excel文件并把数据写入
        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFSheet sheet = wb.createSheet("市场活动列表");
        HSSFRow row = sheet.createRow(0);
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("ID");
        cell = row.createCell(1);
        cell.setCellValue("所有者");
        cell = row.createCell(2);
        cell.setCellValue("名称");
        cell = row.createCell(3);
        cell.setCellValue("开始日期");
        cell = row.createCell(4);
        cell.setCellValue("结束日期");
        cell = row.createCell(5);
        cell.setCellValue("成本");
        cell = row.createCell(6);
        cell.setCellValue("描述");
        cell = row.createCell(7);
        cell.setCellValue("创建时间");
        cell = row.createCell(8);
        cell.setCellValue("创建者");
        cell = row.createCell(9);
        cell.setCellValue("修改时间");
        cell = row.createCell(10);
        cell.setCellValue("修改者");
        if (activityList!=null && activityList.size()>0){
            Activity activity = null;
            for(int i=0;i<activityList.size();i++){
                activity = activityList.get(i);
                row = sheet.createRow(i+1);
                cell = row.createCell(0);
                cell.setCellValue(activity.getId());
                cell = row.createCell(1);
                cell.setCellValue(activity.getOwner());
                cell = row.createCell(2);
                cell.setCellValue(activity.getName());
                cell = row.createCell(3);
                cell.setCellValue(activity.getStartDate());
                cell = row.createCell(4);
                cell.setCellValue(activity.getEndDate());
                cell = row.createCell(5);
                cell.setCellValue(activity.getCost());
                cell = row.createCell(6);
                cell.setCellValue(activity.getDescription());
                cell = row.createCell(7);
                cell.setCellValue(activity.getCreateTime());
                cell = row.createCell(8);
                cell.setCellValue(activity.getCreateBy());
                cell = row.createCell(9);
                cell.setCellValue(activity.getEditTime());
                cell = row.createCell(10);
                cell.setCellValue(activity.getEditBy());
            }
        }
        //生成excel文件,从内存到硬盘
       /* OutputStream os = new FileOutputStream("C:\\Users\\Administrator\\Desktop\\workspace\\serverDir\\activityList.xls");
        wb.write(os);*/
        //关闭资源
        /*os.close();
        wb.close();*/
        //将文件输出到浏览器
        response.setContentType("application/octet-stream;charset=UTF-8");
        //设置响应头信息，使浏览器接收到响应信息之后，直接激活文件下载窗口
        response.addHeader("Content-Disposition","attachment;filename=activityList.xls");
        //读取Excel文件(InputStream),输出到浏览器(OutputStream)
        OutputStream out = response.getOutputStream();//从硬盘到内存
        /*InputStream is = new FileInputStream("C:\\Users\\Administrator\\Desktop\\workspace\\serverDir\\activityList.xls");
        byte[] buff = new byte[256];
        int len = 0;
        while ((len=is.read(buff))!=-1){
            out.write(buff,0,len);//从内存到硬盘
        }
        //关闭资源
        is.close();*/

        wb.write(out);
        wb.close();
        out.flush();
    }

    //演示文件上传
    //MultipartFile使mvc内部的类用来接收浏览器文件类型的数据,需要在mvc配置文件中配置文件上传解析器
    @RequestMapping("/workbench/activity/fileUpload.do")
    @ResponseBody
    public Object fileUpload(String userName, MultipartFile myFile) throws IOException {
        System.out.println("username="+userName);
        //把文件在服务器指定的目录中生成一个同样的文件
        String filename = myFile.getOriginalFilename();
        File file = new File("C:\\Users\\Administrator\\Desktop\\workspace\\serverDir\\"+filename);//路径必须手动创建好
        myFile.transferTo(file);
        //返回响应信息
        ReturnObject res = new ReturnObject();
        res.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        res.setMessage("上传成功");
        return res;
    }

    //批量导入
    @RequestMapping("/workbench/activity/importActivity.do")
    @ResponseBody
    public Object importActivity(MultipartFile activityFile,HttpSession session){
        User user=(User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject res = new ReturnObject();
        try {
            //把Excel文件写到磁盘目录中
            //String filename = activityFile.getOriginalFilename();
            //File file = new File("C:\\Users\\Administrator\\Desktop\\workspace\\serverDir\\", filename);//路径必须手动创建好
            //activityFile.transferTo(file);
            //根据Excel文件生成HSSFWorkbook对象，封装了Excel文件的所有信息
            //InputStream is = new FileInputStream("C:\\Users\\Administrator\\Desktop\\workspace\\serverDir\\"+filename);

            InputStream is=activityFile.getInputStream();
            HSSFWorkbook wb = new HSSFWorkbook(is);
            //通过wb对象获取HSSFSheet对象，封装了一页的所有信息
            HSSFSheet sheet = wb.getSheetAt(0);//页的下标，从0开始
            //通过sheet获取HSSFRow对象，封装了一行的所有信息
            HSSFRow row=null;
            HSSFCell cell=null;
            Activity activity=null;
            List<Activity> activityList=new ArrayList<>();
            for (int i=1;i<=sheet.getLastRowNum();i++){//getLastRowNum最后一行的下标
                row=sheet.getRow(i);//行的下标，从0开始
                activity=new Activity();
                activity.setId(UUIDUtils.getUUID());
                activity.setOwner(user.getId());
                activity.setCreateTime(DateUtils.formateDateTime(new Date()));
                activity.setCreateBy(user.getId());
                for (int j=0;j<row.getLastCellNum();j++){//getLastCellNum最后一列的下标+1，总列数
                    //根据row获取HSSFCell对象，封装了一列的所有信息
                    cell=row.getCell(j);//列的下标，从0开始
                    //获取列中的数据
                    String cellValue = HSSFUtils.getCellValueForStr(cell);
                    if (j==0){
                        activity.setName(cellValue);
                    }else if (j==1){
                        activity.setStartDate(cellValue);
                    }else if (j==2){
                        activity.setEndDate(cellValue);
                    }else if (j==3){
                        activity.setCost(cellValue);
                    }else if (j==4){
                        activity.setDescription(cellValue);
                    }
                }
                //每一行中所有列封装完成之后，把activity保存到List中
                activityList.add(activity);
            }
            //调用service层方法，保存数据
            int count = activityService.saveCreateActivityByList(activityList);
            res.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            res.setReData(count);
        }catch (Exception e){
            e.printStackTrace();
            res.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            res.setMessage("系统忙，请稍后重试....");
        }
        return res;
    }

    @RequestMapping("/workbench/activity/detailActivity.do")
    public ModelAndView detailActivity(String id){
        ModelAndView mdv=new ModelAndView();
        //调用service层方法，获取数据
        Activity activity=activityService.queryActivityForDetailById(id);
        List<ActivityRemark> remarkList = activityRemarkService.queryActivityRemarkForDetailByActivityId(id);
        mdv.addObject("activity",activity);
        mdv.addObject("remarkList",remarkList);
        mdv.setViewName("workbench/activity/detail");
        return mdv;
    }
}
