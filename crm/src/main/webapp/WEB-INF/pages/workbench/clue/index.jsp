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

<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

<script type="text/javascript">

	$(function(){
	    queryClueByConditionForPage(1,10);
	    //引入日历插件
        $(".mydate").datetimepicker({
            language: 'zh-CN',
            format: 'yyyy-mm-dd',
            minView: 'month', //最小视图
            initialDate: new Date(), // 初始化显示日期
            autoclose: true, //选择完之后自动关闭

            todayBtn: true,//显示当天按钮
            clearBtn: true //显示清空按钮
        });
	    $("#createClueBtn").click(function () {
            $("#createClueForm")[0].reset()
	        $("#createClueModal").modal("show")
        })
		//创建线索
        $("#saveCreateClueBtn").click(function () {
           let fullname=$.trim($("#create-fullname").val());
           let appellation=$("#create-appellation").val();
           let owner=$("#create-owner").val();
           let company=$.trim($("#create-company").val());
           let job=$.trim($("#create-job").val());
           let email=$.trim($("#create-email").val());
           let phone=$.trim($("#create-phone").val());
           let website=$.trim($("#create-website").val());
           let mphone=$.trim($("#create-mphone").val());
           let state=$("#create-state").val();
           let source=$("#create-source").val();
           let description=$.trim($("#create-description").val());
           let contactSummary=$.trim($("#create-contactSummary").val());
           let nextContactTime=$.trim($("#create-nextContactTime").val());
           let address=$.trim($("#create-address").val());
           //表单验证
            if (company==""){
                alert("公司不能为空")
                return;
            }
            if(fullname==""){
                alert("输入的姓名不能为空")
                return;
            }
            if (email!=""){
                let emailRegExp=/^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/
                if (!emailRegExp.test(email)){
                    alert("输入的邮箱格式不符合规范")
                    return;
                }
            }
            if (mphone!=""){
                let mphoneRegExp=/^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/
                if (!mphoneRegExp.test(mphone)){
                    alert("输入的手机号格式不符合规范")
                    return;
                }
            }
            /*let webExp1=/[a-zA-z]+:\/\/[^\s]*!/
            let webExp2=/^http:\/\/([\w-]+\.)+[\w-]+(\/[\w-./?%&=]*)?$/
            if (!(webExp1.test(website)||webExp2.test(website))){
                alert("输入的公司网站格式不符合规范")
                return;
            }*/
           $.ajax({
               url: 'workbench/clue/saveCreateClue.do',
               data: {
                   fullname,appellation,owner,company,job,email,phone,website,mphone,state,source,description,contactSummary,nextContactTime,address
               },
               type: 'post',
               dataType: 'json',
               success: function (data) {
                   if (data.code=="1"){
                       $("#createClueModal").modal("hide")
                       //刷新线索列表,显示第一页数据,保持每页显示条数不变
                       queryClueByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'))
                   }else{
                       alert(data.message)
                   }
               }
           })
        })

		//按条件查询
        $("#queryClueByConditionBtn").click(function(){
            // 查询所有符合条件数据的第一页以及所有符合条件数据的总条数
            let pageSize = $("#demo_pag1").bs_pagination('getOption','rowsPerPage');
            queryClueByConditionForPage(1,pageSize);
        })
        //全选与取消全选
        $("#checkAll").click(function () {
            $("#mybody input[type='checkbox']").prop("checked",$("#checkAll").prop("checked"));
        })
        $("#mybody").on('click',$("input[type='checkbox']"),function () {
            $("#checkAll").prop('checked',$("#mybody input[type='checkbox']").size()==$("#mybody input[type='checkbox']:checked").size());
        })

        //删除线索
        $("#deleteClueBtn").click(function () {
            //收集参数
            //获取列表中所有选中的checkbox
            let checkedIds = $("#mybody input[type='checkbox']:checked")
            if (checkedIds.size()==0){
                alert("请选择要删除的线索")
                return
            }
            if (window.confirm("确定删除吗？")){
                let ids = "";
                $.each(checkedIds,function () {
                    ids+="id="+this.value+"&"
                })
                ids = ids.substr(0,ids.length-1);
                $.ajax({
                    url: 'workbench/clue/deleteClueByIds.do',
                    type: 'post',
                    data: ids,
                    dataType: 'json',
                    success: function (data) {
                        if (data.code == "1"){
                            //刷新市场活动列表，显示第一页数据，保持每页数据不变
                            queryClueByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'))
                        }else {
                            alert(data.message);
                        }
                    }
                })
            }
        })

        //打开修改模态窗口
        $("#editClueBtn").click(function(){
            $("#editClueForm")[0].reset()
            let checkedBoxs=$("#mybody input[type='checkbox']:checked")
            if (checkedBoxs.size()==0){
                alert("请选择一条记录")
                return;
            }
            if (checkedBoxs.size()>1){
                alert("至多选中一条记录")
                return;
            }
            let id=checkedBoxs.val()
            $.ajax({
                url: 'workbench/clue/queryClueById.do',
                data: {id},
                type: 'post',
                dataType: 'json',
                success: function(resp){
                    console.info(resp)
                    $("#edit-id").val(id)
                    $("#edit-owner").val(resp.owner)
                    $("#edit-company").val(resp.company)
                    $("#edit-appellation").val(resp.appellation)
                    $("#edit-fullname").val(resp.fullname)
                    $("#edit-job").val(resp.job)
                    $("#edit-email").val(resp.email)
                    $("#edit-phone").val(resp.phone)
                    $("#edit-website").val(resp.website)
                    $("#edit-mphone").val(resp.mphone)
                    $("#edit-state").val(resp.state)
                    $("#edit-source").val(resp.source)
                    $("#edit-description").val(resp.description)
                    $("#edit-contactSummary").val(resp.contactSummary)
                    $("#edit-nextContactTime").val(resp.nextContactTime)
                    $("#edit-address").val(resp.address)
                    $("#editClueModal").modal("show")
                }
            })
        })

        //点击更新修改线索信息
        $("#saveEditClueBtn").click(function(){
            let id=$("#edit-id").val()
            let owner=$("#edit-owner").val()
            let company=$.trim($("#edit-company").val())
            let appellation=$("#edit-appellation").val()
            let fullname=$.trim($("#edit-fullname").val())
            let job=$.trim($("#edit-job").val())
            let email=$.trim($("#edit-email").val())
            let phone=$.trim($("#edit-phone").val())
            let website=$.trim($("#edit-website").val())
            let mphone=$.trim($("#edit-mphone").val())
            let state=$("#edit-state").val()
            let source=$("#edit-source").val()
            let description=$.trim($("#edit-description").val())
            let contactSummary=$.trim($("#edit-contactSummary").val())
            let nextContactTime=$("#edit-nextContactTime").val()
            let address=$.trim($("#edit-address").val())
            //表单验证
            if (company==""){
                alert("公司不能为空")
                return;
            }
            if(fullname==""){
                alert("输入的姓名不能为空")
                return;
            }
            if (email!=""){
                let emailRegExp=/^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/
                if (!emailRegExp.test(email)){
                    alert("输入的邮箱格式不符合规范")
                    return;
                }
            }
            if (mphone!=""){
                let mphoneRegExp=/^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/
                if (!mphoneRegExp.test(mphone)){
                    alert("输入的手机号格式不符合规范")
                    return;
                }
            }
            $.ajax({
                url: 'workbench/clue/saveEditClueById.do',
                data:{
                    id,owner,company,appellation,fullname,job,email,phone,website,mphone,state,source,description,contactSummary,nextContactTime,address
                },
                type: 'post',
                dataType: 'json',
                success: function (resp) {
                    if (resp.code=="1"){
                        $("#editClueModal").modal('hide');
                        queryClueByConditionForPage($("#demo_pag1").bs_pagination('getOption','currentPage'),$("#demo_pag1").bs_pagination('getOption','rowsPerPage'))
                    }else{
                        alert(resp.message)
                    }
                }
            })
        })
	})

    function queryClueByConditionForPage(pageNo,pageSize){
        let fullname=$("#query-fullname").val()
        let company=$("#query-company").val()
        let phone=$("#query-phone").val()
        let source=$("#query-source").val()
        let owner=$("#query-owner").val()
        let mphone=$("#query-mphone").val()
        let state=$("#query-state").val()
        $.ajax({
            url: 'workbench/clue/queryClueByConditionForPage.do',
            data: {
                fullname,company,phone,source,owner,mphone,state,pageNo,pageSize
            },
            type: 'post',
            dataType: 'json',
            success: function (data) {
                let htmlStr='';
                $.each(data.clueList,(i,n)=>{
                    htmlStr+="<tr>"
                    htmlStr+="<td><input type=\"checkbox\" value='"+n.id+"'/></td>"
                    if (n.appellation!=null){
                        htmlStr+="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/clue/detailClue.do?id="+n.id+"';\">"+n.fullname+n.appellation+"</a></td>"
                    }else{
                        htmlStr+="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/clue/detailClue.do?id="+n.id+"';\">"+n.fullname+"</a></td>"
                    }
                    htmlStr+="<td>"+n.company+"</td>"
                    htmlStr+="<td>"+n.phone+"</td>"
                    htmlStr+="<td>"+n.mphone+"</td>"
                    if (n.source!=null){
                        htmlStr+="<td>"+n.source+"</td>"
                    }else {
                        htmlStr+="<td>"+""+"</td>"
                    }
                    htmlStr+="<td>"+n.owner+"</td>"
                    if (n.state!=null){
                        htmlStr+="<td>"+n.state+"</td>"
                    }
                    htmlStr+="<td>"+""+"</td>"
                    htmlStr+="</tr>"
                })
                $("#mybody").html(htmlStr);
                $("#checkAll").prop("checked",false);
                let totalPages = 1;
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
                        queryClueByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);
                    }
                })
            }
        })
    }
	
</script>
</head>
<body>

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form id="createClueForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
								  <c:forEach items="${userList}" var="user">
                                      <option value="${user.id}">${user.name}</option>
                                  </c:forEach>
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
                                  <option></option>
								  <c:forEach items="${appellationList}" var="appellation">
                                      <option value="${appellation.id}">${appellation.value}</option>
                                  </c:forEach>
								</select>
							</div>
							<label for="create-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">
								  <option></option>
								  <c:forEach items="${clueStateList}" var="state">
                                      <option value="${state.id}">${state.value}</option>
                                  </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
                                  <c:forEach items="${sourceList}" var="source">
                                      <option value="${source.id}">${source.value}</option>
                                  </c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control mydate" id="create-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveCreateClueBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="editClueForm">
					    <input type="hidden" id="edit-id">
						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
                                    <c:forEach items="${userList}" var="user">
                                        <option value="${user.id}">${user.name}</option>
                                    </c:forEach>
								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
								  <option></option>
                                    <c:forEach items="${appellationList}" var="appellation">
                                        <option value="${appellation.id}">${appellation.value}</option>
                                    </c:forEach>
								</select>
							</div>
							<label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname" value="李四">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
							<label for="edit-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-state">
								  <option></option>
                                    <c:forEach items="${clueStateList}" var="state">
                                        <option value="${state.id}">${state.value}</option>
                                    </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
                                    <c:forEach items="${sourceList}" var="source">
                                        <option value="${source.id}">${source.value}</option>
                                    </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">这是一条线索的描述信息</textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control mydate" id="edit-nextContactTime" value="2017-05-01">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveEditClueBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
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
				      <input id="query-fullname" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input id="query-company" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input id="query-phone" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select id="query-source" class="form-control">
					  	  <option value=""></option>
                          <c:forEach items="${sourceList}" var="source">
                              <option value="${source.id}">${source.value}</option>
                          </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="query-owner" class="form-control" type="text">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input id="query-mphone" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select id="query-state" class="form-control">
					  	<option value=""></option>
                          <c:forEach items="${clueStateList}" var="state">
                              <option value="${state.id}">${state.value}</option>
                          </c:forEach>
					  </select>
				    </div>
				  </div>

				  <button type="button" class="btn btn-default" id="queryClueByConditionBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createClueBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editClueBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteClueBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll" /></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="mybody">

					</tbody>
				</table>
                <div id="demo_pag1"></div>
			</div>

			<%--<div style="height: 50px; position: relative;top: 60px;">
				<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
				</div>
				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>
					<div class="btn-group">
						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							10
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a href="#">20</a></li>
							<li><a href="#">30</a></li>
						</ul>
					</div>
					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
				</div>
				&lt;%&ndash;<div style="position: relative;top: -88px; left: 285px;">
					&lt;%&ndash;<nav>
						<ul class="pagination">
							<li class="disabled"><a href="#">首页</a></li>
							<li class="disabled"><a href="#">上一页</a></li>
							<li class="active"><a href="#">1</a></li>
							<li><a href="#">2</a></li>
							<li><a href="#">3</a></li>
							<li><a href="#">4</a></li>
							<li><a href="#">5</a></li>
							<li><a href="#">下一页</a></li>
							<li class="disabled"><a href="#">末页</a></li>
						</ul>
					</nav>&ndash;%&gt;

				</div>&ndash;%&gt;
			</div>--%>
			
		</div>
		
	</div>
</body>
</html>