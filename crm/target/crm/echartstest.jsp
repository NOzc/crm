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
    <title>演示echarts报表插件</title>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/echars/echarts.min.js"></script>
    <script type="text/javascript">
        $(function () {
            // 基于准备好的dom，初始化echarts实例
            var myChart = echarts.init(document.getElementById('main'));
            // 指定图表的配置项和数据
            var option = {
                title: {
                    text: 'ECharts 入门示例',
                    subtext: '测试副标题',
                    textStyle:{
                        fontStyle: 'italic'
                    }
                },
                //提示框
                tooltip: {
                    textStyle: {
                        color:'blue'
                    }
                },
                legend: {//图例
                    data: ['销量']
                },
                xAxis: {//x轴数据项
                    data: ['衬衫', '羊毛衫', '雪纺衫', '裤子', '高跟鞋', '袜子']
                },
                yAxis: {},//y轴,数据量
                series: [//系列
                    {
                        name: '销量',//系列的名称
                        type: 'bar',//系列的类型 bat:柱状图,line:折线图
                        data: [5, 20, 36, 10, 10, 20]//系列的数据
                    }
                ]
            };
            // 使用刚指定的配置项和数据显示图表。
            myChart.setOption(option);
        })
    </script>
</head>
<body>
<!-- 为 ECharts 准备一个定义了宽高的 DOM -->
<div id="main" style="width: 600px;height:400px;"></div>
</body>
</html>
