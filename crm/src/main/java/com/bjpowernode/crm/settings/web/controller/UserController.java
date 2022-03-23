package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.commons.constants.Constants;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
public class UserController {
    @Autowired
    private UserService userService;
    // uri要和controller方法处理完请求之后，响应信息返回的页面的资源目录保持一致
    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin(){
        return "settings/qx/user/login";
    }

    @RequestMapping("/settings/qx/user/login.do")
    @ResponseBody
    public Object login(String loginAct, String loginPwd, String isRemPwd, HttpServletRequest request, HttpServletResponse response,HttpSession session){
        Map<String,Object> map = new HashMap<>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        User user = userService.queryUserByLoginActAndPwd(map);
        ReturnObject res = new ReturnObject();
        if (user==null){
            // 用户名或密码错误
            res.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            res.setMessage("用户名或密码错误");
        }else {
//            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//            String nowTime = sdf.format(new Date());
            String nowTime = DateUtils.formateDateTime(new Date());
            if (nowTime.compareTo(user.getExpireTime()) > 0){
                // 账号过期
                res.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                res.setMessage("账号已过期");
            }else if ("0".equals(user.getLockState())){
                // 状态锁定
                res.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                res.setMessage("状态被锁定");
            }else if (!user.getAllowIps().contains(request.getRemoteAddr())){
                // ip受限
                res.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                res.setMessage("ip受限");
            }else {
                // 登录成功
                res.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                // 把user对象保存到 session中
                session.setAttribute(Constants.SESSION_USER,user);
                // 判断是否记住密码
                if ("true".equals(isRemPwd)){
                    Cookie c1 = new Cookie("loginAct", user.getLoginAct());
                    c1.setMaxAge(10*24*60*60);
                    response.addCookie(c1);
                    Cookie c2 = new Cookie("loginPwd", user.getLoginPwd());
                    c2.setMaxAge(10*24*60*60);
                    response.addCookie(c2);
                }else {
                    // 删除没有过期的cookie
                    Cookie c1 = new Cookie("loginAct", "1");
                    c1.setMaxAge(0);
                    response.addCookie(c1);
                    Cookie c2 = new Cookie("loginPwd", "1");
                    c2.setMaxAge(0);
                    response.addCookie(c2);
                }
            }
        }
        return res;
    }

    @RequestMapping("/settings/qx/user/logout.do")
    public String logout(HttpServletResponse response,HttpSession session) {
        // 清空 cookie
        Cookie c1 = new Cookie("loginAct", "1");
        c1.setMaxAge(0);
        response.addCookie(c1);
        Cookie c2 = new Cookie("loginPwd", "1");
        c2.setMaxAge(0);
        response.addCookie(c2);
        // 销毁 session
        session.invalidate();
        // 跳转首页
        return "redirect:/";
    }
}
