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
    <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

    <script type="text/javascript">
        $(function () {

            $("#searchActivityBtn").click(function () {
                $("#tBody1").html("")
                $("#findMarketActivity").modal("show")
            });

            $("#searchActivityText").keyup(function () {
                let activityName=$("#searchActivityText").val();
                $.ajax({
                    url: 'workbench/transaction/queryActivityByName.do',
                    data: {
                        activityName
                    },
                    type: 'get',
                    dataType: 'json',
                    success: function (resp) {
                        let htmlStr="";
                        $.each(resp,function (i,n) {
                            htmlStr+="<tr>";
                            htmlStr+="<td><input type=\"radio\" activityName='"+n.name+"' name=\"activity\" value='"+n.id+"'/></td>";
                            htmlStr+="<td>"+n.name+"</td>";
                            htmlStr+="<td>"+n.startDate+"</td>";
                            htmlStr+="<td>"+n.endDate+"</td>";
                            htmlStr+="<td>"+n.owner+"</td>";
                            htmlStr+="</tr>"
                        });
                        $("#tBody1").html(htmlStr);
                    }
                })
            });

            $("#tBody1").on("click","input[type='radio']",function () {
                $("#create-activityId").val(this.value);
                $("#create-activityName").val($(this).attr("activityName"));
                $("#findMarketActivity").modal("hide")
            })

            $("#searchContactsBtn").click(function () {
                $("#tBody2").html("");
                $("#findContacts").modal("show")
            })

            $("#searchContactsText").keyup(function () {
                let fullname=$("#searchContactsText").val();
                $.ajax({
                    url: 'workbench/transaction/queryContactsByName.do',
                    data: {fullname},
                    type: 'get',
                    dataType: 'json',
                    success: function (resp) {
                        console.log(resp);
                        let htmlStr="";
                        $.each(resp,function (i,n) {
                            htmlStr+="<tr>";
                            htmlStr+="<td><input fullname='"+n.fullname+"' type=\"radio\" name=\"activity\" value='"+n.id+"'/></td>";
                            htmlStr+="<td>"+n.fullname+"</td>";
                            htmlStr+="<td>"+n.email+"</td>";
                            htmlStr+="<td>"+n.mphone+"</td>";
                            htmlStr+="</tr>";
                        });
                        $("#tBody2").html(htmlStr);
                    }
                })
            });

            $("#tBody2").on("click","input[type='radio']",function () {
                $("#create-contactsId").val(this.value);
                $("#create-contactsName").val($(this).attr("fullname"));
                $("#findContacts").modal("hide");
            });

            //每次选择阶段去后台获取可能性
            $("#create-transactionStage").change(function () {
                let stageValue=$("#create-transactionStage>option:selected").html();
                if (stageValue==""){
                    $("#create-possibility").val("");
                    return;
                }
                $.ajax({
                   url: 'workbench/transaction/getPossibilityByStage.do',
                   data: {stageValue},
                   type: 'post',
                   dataType: 'json',
                    success: function (resp) {
                        $("#create-possibility").val(resp);
                    }
                });
            })

            $("#create-accountName").typeahead({
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
            });

            $("#saveCreateTranBtn").click(function () {
                let owner=$("#create-transactionOwner").val();
                let money=$.trim($("#create-amountOfMoney").val());
                let name=$.trim($("#create-transactionName").val());
                let expectedDate=$("#create-expectedClosingDate").val();
                let customerName=$.trim($("#create-accountName").val());
                let stage=$("#create-transactionStage").val();
                let type=$("#create-transactionType").val();
                let source=$("#create-clueSource").val();
                let activityId=$("#create-activityId").val();
                let contactsId=$("#create-contactsId").val();
                let description=$.trim($("#create-describe").val());
                let contactSummary=$.trim($("#create-contactSummary").val());
                let nextContactTime=$("#create-nextContactTime").val();
                //表单验证
                let moneyRegExp=/^(([1-9]\d*)|0)$/;
                if (money!==""){
                    if (!moneyRegExp.test(money)){
                        alert("金额只能是非负整数");
                        return;
                    }
                }
                if (name===""){
                    alert("名称不能为空");
                    return;
                }
                if (expectedDate===""){
                    alert("预计成交日期不能为空");
                    return;
                }
                if (customerName===""){
                    alert("客户名称不能为空");
                    return;
                }
                if (stage===""){
                    alert("阶段不能为空");
                    return;
                }
                //发送请求
                $.ajax({
                    url: 'workbench/transaction/saveCreateTran.do',
                    data: {
                        owner,money,name,expectedDate,customerName,stage,type,source,activityId,contactsId,description,contactSummary,nextContactTime
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (resp) {
                        if (resp.code=="1"){
                            window.location.href="workbench/transaction/index.do"
                        }else{
                            alert(resp.message)
                        }
                    }
                });
            })
        })
    </script>
</head>
<body>

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="searchActivityText" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="tBody1">
							<%--<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" id="searchContactsText" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="tBody2">

						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="saveCreateTranBtn">保存</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionOwner">
				  <c:forEach items="${userList}" var="user">
                      <option value="${user.id}">${user.name}</option>
                  </c:forEach>
				</select>
			</div>
			<label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-amountOfMoney">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-transactionName">
			</div>
			<label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-expectedClosingDate">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-accountName" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-transactionStage">
			  	<option></option>
			  	<c:forEach items="${stageList}" var="stage">
                    <option value="${stage.id}">${stage.value}</option>
                </c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionType">
				  <option></option>
				  <c:forEach items="${tranTypeList}" var="type">
                      <option value="${type.id}">${type.value}</option>
                  </c:forEach>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-possibility" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-clueSource">
				  <option></option>
				  <c:forEach items="${sourceList}" var="source">
                      <option value="${source.id}">${source.value}</option>
                  </c:forEach>
				</select>
			</div>
			<label for="create-activityName" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="searchActivityBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
                <input type="hidden" id="create-activityId">
				<input type="text" class="form-control" id="create-activityName">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="searchContactsBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
                <input type="hidden" id="create-contactsId">
				<input type="text" class="form-control" id="create-contactsName">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-describe"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-nextContactTime">
			</div>
		</div>
		
	</form>
</body>
</html>