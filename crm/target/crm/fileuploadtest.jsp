<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme()
            +"://"+request.getServerName()+":"
            +request.getServerPort()
            +request.getContextPath()+"/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <title>演示文件上传导入</title>
</head>
<body>
<!--
    文件上传的表单
       1.表单组件标签只能用<input type='file'>
       2.请求方式只能用post
       3.表单的编码格式只能用multipart/form-data,
            浏览器默认的编码格式:urlencoded,只能对文本数据进行编码,将参数转为String
-->
    <form action="workbench/activity/fileUpload.do" method="post" enctype="multipart/form-data">
        <input type="file" name="myFile"><br>
        <input type="text" name="userName"><br>
        <input type="submit" value="上传">
    </form>
</body>
</html>
