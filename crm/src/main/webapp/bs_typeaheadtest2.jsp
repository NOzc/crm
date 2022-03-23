<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core_1_1" %>
<%
    String basePath = request.getScheme()
            +"://"+request.getServerName()+":"
            +request.getServerPort()
            +request.getContextPath()+"/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <title>演示自动补全插件</title>
    <%--引入jQuery插件--%>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <%--引入bootstrap插件--%>
    <link rel="stylesheet" type="text/css" href="jquery/bootstrap_3.3.0/css/bootstrap.min.css">
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <%--引入typehead--%>
    <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

    <script type="text/javascript">
        $(function () {
            $("#customerName").typeahead({
                source: function (jquery,process) {
                    // jquery是用户在容器中输入的关键字
                    // let name = $("#customerName").val();
                    $.ajax({
                        url: 'workbench/transaction/queryCustomerNameByName.do',
                        data: {
                          customerName:jquery
                        },
                        type: 'post',
                        dataType: 'json',
                        success: function (resp) {
                            process(resp);
                        }
                    });
                }
            })
        })
    </script>
</head>
<body>
<input type="text" id="customerName">
</body>
</html>
