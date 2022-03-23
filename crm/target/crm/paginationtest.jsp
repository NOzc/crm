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
    <title>演示分页插件bs_pagination的使用</title>
    <%--引入jQuery插件--%>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <%--引入bootstrap插件--%>
    <link rel="stylesheet" type="text/css" href="jquery/bootstrap_3.3.0/css/bootstrap.min.css">
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <%--引入bs_pagination插件--%>
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

    <script type="text/javascript">
        $(function () {
            $("#demo_pag1").bs_pagination({
                currentPage: 1, // 当前页号，默认是1，相当于pageNo
                rowsPerPage: 10, // 每页显示条数，默认是10,相当于pageSize
                totalRows: 1000,// 总条数
                totalPages: 100, // 总页数，必填参数
                visiblePageLinks: 5,//最多可以显示的卡片数
                showGoToPage: false,//是否显示跳转到某页，默认true
                showRowsPerPage: false,//是否显示“每页显示条数”部分，默认true
                showRowsInfo: false,// 是否显示记录的信息，默认true
                onChangePage: (event,pageObj)=> {
                    // 每次切换页号执行此方法，返回切换后的pageNo和pageSize

                }
            })
        })
    </script>
</head>
<body>
    <div id="demo_pag1">

    </div>
</body>
</html>
