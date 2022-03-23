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
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<%--bs_pagination分页插件--%>
<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

<script type="text/javascript">

	$(function(){
		// 给创建按钮添加事件
		$("#createActivityBtn").click(function () {
		    // 清空上次填写的表单数据,重置表单
            $("#createActivityForm").get(0).reset();
            // 弹出模态窗口
            $("#createActivityModal").modal("show")
        })

		// 给“保存”按钮添加单击事件
        $("#saveCreateActivityBtn").click(function () {
            // 收集参数
            let owner = $("#create-marketActivityOwner").val();
            let name = $.trim($("#create-marketActivityName").val());
            let startDate = $("#create-startDate").val()
            let endDate = $("#create-endDate").val();
            let cost = $.trim($("#create-cost").val())
            let description = $.trim($("#create-describe").val())
            // 表单验证，保证数据合法
            if (owner == ""){
                alert("所有者不能为空")
                return
            }
            if (name==""){
                alert("名称不能为空")
                return
            }
            if (startDate!="" && endDate!=""){
                if (startDate>endDate){
                    alert("结束日期不能比开始日期小")
                    return
                }
            }
            //正则表达式：定义字符串的匹配模式，可以用来判断指定的具体字符串是否符合匹配模式
            let regExp = /^(([1-9]\d*)|0)$/
            if (!regExp.test(cost)){
                alert("成本只能是非负整数")
                return
            }
            // 发送请求
            $.ajax({
                url: 'workbench/activity/saveCreateActivity.do',
                // 请求参数名要和接收参数的实体类的属性名保持一致
                data: {
                    owner,
                    name,
                    startDate,
                    endDate,
                    cost,
                    description
                },
                type: 'post',
                dataType: 'json',
                success: (data) => {
                    if (data.code == '1'){
                        // 关闭模态窗口
                        $("#createActivityModal").modal('hide')
                        // 刷新市场活动列，显示第一页数据，保持每页显示条数不变
                        queryActivityByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'))
                    }else {
                        alert(data.message)
                    }
                }
            })
        })

        // 当容器加载完成之后对容器调用工具函数,日历插件
        $(".mydate").datetimepicker({
            language: 'zh-CN',
            format: 'yyyy-mm-dd',
            minView: 'month', //最小视图
            initialDate: new Date(), // 初始化显示日期
            autoclose: true, //选择完之后自动关闭

            todayBtn: true,//显示当天按钮
            clearBtn: true //显示清空按钮
        });

		// 当市场活动主页面加载完，查询所有数据的第一页以及所有数据的总条数
        queryActivityByConditionForPage(1,10);

        // 给查询按钮添加单击事件
        $("#queryActivityBtn").click(()=>{
            // 查询所有符合条件数据的第一页以及所有符合条件数据的总条数
            let pageSize = $("#demo_pag1").bs_pagination('getOption','rowsPerPage');
            queryActivityByConditionForPage(1,pageSize);
        })

        // 全选按钮添加单击事件
        $("#checkAll").click(function () {
            //如果“全选”按钮是选中状态，则列表中所有checkbox都选中
            $("#tBody input[type='checkbox']").prop("checked",this.checked)
        });
        // 给动态生成的元素添加事件：父选择器.on(’事件类型‘，子选择器，function(){})
        $("#tBody").on('click',$("input[type='checkbox']"),function () {
            //如果列表中所有checkbox都是选中状态，则全选按钮也选中
            if ($("#tBody input[type='checkbox']").size()==$("#tBody input[type='checkbox']:checked").size()){
                $("#checkAll").prop('checked',true)
            }else {
                $("#checkAll").prop('checked',false)
            }
        });

        //删除按钮绑定单击事件
        $("#deleteActivityBtn").click(function () {
            //收集参数
            //获取列表中所有选中的checkbox
            let checkedIds = $("#tBody input[type='checkbox']:checked")
            if (checkedIds.size()==0){
                alert("请选择要删除的市场活动")
                return
            }
            if (window.confirm("确定删除吗？")){
                let ids = "";
                $.each(checkedIds,function () {
                    ids+="id="+this.value+"&"
                })
                ids = ids.substr(0,ids.length-1);
                $.ajax({
                    url: 'workbench/activity/deleteActivityByIds.do',
                    type: 'post',
                    data: ids,
                    dataType: 'json',
                    success: function (data) {
                        if (data.code == "1"){
                            //刷新市场活动列表，显示第一页数据，保持每页数据不变
                            queryActivityByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'))
                        }else {
                            alert(data.message);
                        }
                    }
                })
            }
        })

        //修改按钮添加单击事件
        $("#editActivityBtn").click(function () {
            //收集参数，选中的checkbox的id
            let checkedIds = $("#tBody input[type='checkbox']:checked");
            if (checkedIds.size() == 0){
                alert("请选择要修改的市场活动");
                return;
            }
            if (checkedIds.size()>1){
                alert("每次只能修改一条市场活动");
                return;
            }
            let id = checkedIds.val();
            $.ajax({
                url: 'workbench/activity/queryActivityById.do',
                type: 'post',
                data:{
                    id
                },
                dataType: 'json',
                success: (res)=>{
                    //设置隐藏域方便点击更新时方便得到
                    $("#edit-id").val(res.id);
                    //把市场活动的信息显示在修改的模态窗口上
                    //将所有者的id复制给select，浏览器自动匹配默认选中的option
                    $("#edit-marketActivityOwner").val(res.owner);
                    $("#edit-marketActivityName").val(res.name);
                    $("#edit-startTime").val(res.startDate);
                    $("#edit-endTime").val(res.endDate);
                    $("#edit-cost").val(res.cost);
                    $("#edit-describe").val(res.description);
                    //弹出模态窗口
                    $("#editActivityModal").modal('show');
                }
            });
        })

        //"更新"按钮添加单击事件
        $("#saveEditActivityBtn").click(function () {
            //收集参数
            let id = $("#edit-id").val();
            let owner = $("#edit-marketActivityOwner").val();
            let name = $.trim($("#edit-marketActivityName").val());
            let startDate = $("#edit-startTime").val();
            let endDate = $("#edit-endTime").val();
            let cost = $.trim($("#edit-cost").val());
            let description = $.trim($("#edit-describe").val());
            //表单验证
            if (owner == ""){
                alert("所有者不能为空");
                return;
            }
            if (name==""){
                alert("名称不能为空");
                return;
            }
            if (startDate!="" && endDate!=""){
                if (startDate>endDate){
                    alert("结束日期不能比开始日期小");
                    return;
                }
            }
            //正则表达式：定义字符串的匹配模式，可以用来判断指定的具体字符串是否符合匹配模式
            let regExp = /^(([1-9]\d*)|0)$/;
            if (!regExp.test(cost)){
                alert("成本只能是非负整数");
                return;
            }
            //发送请求
            $.ajax({
                url: 'workbench/activity/saveEditActivity.do',
                type: 'post',
                data: {
                    id,owner,name,startDate,endDate,cost,description
                },
                dataType: 'json',
                success: (res)=>{
                    if (res.code=="1"){
                        $("#editActivityModal").modal('hide');
                        //刷新市场活动页面，保持页号和每页显示条数不变
                        queryActivityByConditionForPage($("#demo_pag1").bs_pagination('getOption','currentPage'),
                            $("#demo_pag1").bs_pagination('getOption','rowsPerPage'))
                    }else {
                        alert(res.message)
                    }
                }
            })
        })

        //"批量导出"
        $("#exportActivityAllBtn").click(function () {
            window.location.href = "workbench/activity/exportAllActivity.do";
        })

        //"导入"按钮添加单击事件
        $("#importActivityBtn").click(function () {
            //收集参数
            let activityFileName=$("#activityFile").val();//获取文件名
            //从文件名最后一个“.”截取到最后，并转为小写
            let suffix=activityFileName.substr(activityFileName.lastIndexOf(".")+1).toLowerCase();
            if (suffix!="xls"){
                alert("只支持xls文件");
                return;
            }
            //获取选中的文件，是一个数组
            let activityFile=$("#activityFile")[0].files[0];
            //获取文件大小
            if(activityFile.size>5*1024*1024){
                alert("文件大小不能超过5MB");
                return;
            }
            //FormData是Ajax提供的接口,可以模拟键值对向后台提交参数
            //FormData不但能提交文本数据，还能提交二进制数据
            let formData=new FormData();
            formData.append("activityFile",activityFile);
            formData.append("userName","赵超");
            $.ajax({
                url: 'workbench/activity/importActivity.do',
                data:formData,
                processData:false,//设置ajax向后台提交参数之前，是否把参数统一转换成字符串:true,false,默认是true
                contentType:false,//设置ajax向后台提交参数之前，是否把所有参数统一按urlencoded编码:true,false,默认是true
                type:'post',
                dataType:'json',
                success:function(data){
                    if(data.code=="1"){
                        //提示成功导入记录条数
                        alert("成功导入"+data.reData+"条记录");
                        //关闭模态窗口
                        $("#importActivityModal").modal('hide');
                        //刷新市场活动列表,显示第一页数据,保持每页显示条数不变
                        queryActivityByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'))
                    }else {
                        alert(data.message);
                    }
                }
            })
        })
	});

    function queryActivityByConditionForPage(pageNo,pageSize) {
        // 收集参数
        let name = $("#query-name").val()
        let owner = $("#query-owner").val()
        let startDate = $("#query-startDate").val()
        let endDate = $("#query-endDate").val()
        // let pageNo = 1;
        // let pageSize = 10;
        $.ajax({
            url: 'workbench/activity/queryActivityByConditionForPage',
            type: 'post',
            data: {
                name,owner,startDate,endDate,pageNo,pageSize
            },
            dataType: 'json',
            success: (data)=> {
                // 显示市场活动的列表
                // 遍历activityList,拼接所有行数据
                let htmlStr = '';
                $.each(data.activityList,(index,element)=>{
                    htmlStr+="<tr class=\"active\">"
                    htmlStr+="<td><input type=\"checkbox\" value='"+element.id+"' /></td>"
                    htmlStr+="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/activity/detailActivity.do?id="+element.id+"'\">"+element.name+"</a></td>"
                    htmlStr+="<td>"+element.owner+"</td>"
                    htmlStr+="<td>"+element.startDate+"</td>"
                    htmlStr+="<td>"+element.endDate+"</td>"
                    htmlStr+="</tr>"
                });
                $("#tBody").html(htmlStr);
                // 取消全选按钮的选中状态
                $("#checkAll").prop("checked",false);
                // 计算总页数
                let totalPages = 1;
                // totalPages = data.totalRows/pageSize
                if (data.totalRows%pageSize==0){
                    totalPages = data.totalRows/pageSize
                }else {
                    totalPages = parseInt(data.totalRows/pageSize)+1
                }
                // 调用 bs_pagination工具函数，显示分页信息
                $("#demo_pag1").bs_pagination({
                    currentPage: pageNo, // 当前页号，默认是1，相当于pageNo
                    rowsPerPage: pageSize, // 每页显示条数，默认是10,相当于pageSize
                    totalRows: data.totalRows,// 总条数
                    totalPages: totalPages, // 总页数，必填参数
                    visiblePageLinks: 5,//最多可以显示的卡片数
                    showGoToPage: true,//是否显示跳转到某页，默认true
                    showRowsPerPage: true,//是否显示“每页显示条数”部分，默认true
                    showRowsInfo: true,// 是否显示记录的信息，默认true
                    onChangePage: (event,pageObj)=> {
                        // 每次切换页号执行此方法，返回切换后的pageNo和pageSize
                        queryActivityByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);
                    }
                })
            }
        })
    }
</script>
</head>
<body>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form id="createActivityForm" class="form-horizontal" role="form" >
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">
								  <c:forEach items="${users}" var="u">
                                      <option value="${u.id}">${u.name}</option>
                                  </c:forEach>
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="create-startDate" readonly>
							</div>
							<label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="create-endDate" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveCreateActivityBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
					    <input type="hidden" id="edit-id">
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">
                                    <c:forEach items="${users}" var="u">
                                        <option value="${u.id}">${u.name}</option>
                                    </c:forEach>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="edit-startTime" readonly>
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="edit-endTime" readonly>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" value="5,000">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button"  class="btn btn-primary" id="saveEditActivityBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input id="query-name" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="query-owner" class="form-control" type="text">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="query-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="query-endDate">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="queryActivityBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createActivityBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editActivityBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteActivityBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                    <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
                </div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll" /></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="tBody">
					</tbody>
				</table>
                <div id="demo_pag1"></div>
			</div>
		</div>
		
	</div>
</body>
</html>