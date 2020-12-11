<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<c:set var="img3"><c:url value='/common/dashboard/images'/></c:set>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
  
  <div id="dialog_popup" style="display:none;">
    <div id="alarm_history_grid" class="p_cont1"></div>
	  <form id="frm" name="frm">
		<input type="hidden" id="ERROR_S_ALM_KEY" name="ERROR_S_ALM_KEY" value="">
		<input type="hidden" id="ERROR_N_MON_ID" name="ERROR_N_MON_ID" value="">
		<input type="hidden" id="ERROR_S_IP_ADDRESS" name="ERROR_S_IP_ADDRESS" value="">
		<input type="hidden" id="REAL_TIME_ERROR_GROUP" name="REAL_TIME_ERROR_GROUP" value="">
		<!--//장애이력상세정보-->
		<div class="p_title2"><strong>장애이력 상세정보</strong></div>
		<div class="info_box">
			<table summary="" cellpadding="0" cellspacing="0" class="info_tb1">
				<caption></caption>
				<colgroup>
					<col width="90" />
					<col width="120" />
					<col width="90" />
					<col width="" />
				</colgroup>
				<tr>
					<td><strong>장애 상태</strong></td>
					<td><select name="N_ALM_STATUS" class="select_box_ty1" ><option value="1">수동복구</option><option value="3">확인</option></select></td>
					<td><strong style="width:100%; text-align:right;">처리자</strong></td>
					<td>
						<input type="hidden" name="S_USER_ID" value="${sessionScope.S_USER_ID}" />
						<input type="text" name="S_USER_NAME" id="textfield2" class="input_box_ty1" value="${sessionScope.S_USER_NAME}" />
					</td>
				</tr>
				<tr>
					<td valign="top"><strong>이력 내용</strong></td>
					<td colspan="3"><textarea name="S_MSG" class="txt_in_box"></textarea></td>
				</tr>
			</table>
		</div>
	  <!--장애이력상세정보//-->
	  </form>
    </div>
  </div>

<script type="text/javascript">
var targetErrInfo;

function setAlmPhoneInfo(ip_address) {
	targetErrInfo = {
		N_MON_ID: '', 
		S_ALM_KEY: '', 
		S_IP_ADDRESS: ip_address, 
		MODE: 'PHONE'
	};
}
function setAlmMonInfo(mon_id, alm_key) {
	targetErrInfo = {
		N_MON_ID: mon_id, 
		S_ALM_KEY: alm_key, 
		S_IP_ADDRESS: '', 
		MODE: 'MON'
	};
}
function recoverError() {
	//$("#N_ALM_STATUS").val('1');
	$("#S_MSG").val('');

	fn_alarm_history_popup(targetErrInfo);
}

function fn_alarm_history_popup(tei) {
	var dialogWidth = 900; // screen.availWidth / 2; // 900

	$('#dialog_popup').dialog({
		title			: '장애확인/수동복구',
		resizable		: false,
		width			: dialogWidth,
		modal			: true,
		position		: [($(window).width() / 2) - (dialogWidth / 2), 150],
		autoReposition	: true,
		open			: function() {
			$(this).parent().css({top:50, left:($(window).width() / 2) - (dialogWidth / 2)});
			if (tei.MODE == 'PHONE')
				createGrid_AlmPhoneHistory(tei.S_IP_ADDRESS);
			else
				createGrid_AlmMonHistory(tei.N_MON_ID, tei.S_ALM_KEY);
		},
		close			: function() {
			$(this).dialog("destroy");
		},
		buttons			: {
			"확인": function() {
				if (tei.MODE == 'PHONE')
					fn_save_alram_phone(tei);
				else
					fn_save_alram_mon(tei);
			},
			"취소": function() {
				$(this).dialog("destroy");
			}
		}
	});
}

function createGrid_AlmMonHistory(v_mon_id, v_alm_key) {
	$("#alarm_history_grid").kendoGrid($.extend({}, kendoGridDefaultOpt, {
		dataSource	: {
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: "/watcher/kendoPagination_checkAlmHistoryQry.htm",
					data 		: function(data) {
						return { 'N_MON_ID' : v_mon_id, 'S_ALM_KEY' : v_alm_key };
					}
				},
				parameterMap: function (data, opperation) {
					return JSON.stringify(data);
				}
			},
			schema			: {
				data	: function(data) {
					return data;
				},
				total 	: function(response) {
					return response.length > 0 ? response[0].TOTAL_COUNT : 0;
				}
			},
			pageSize		: 10,
			serverPaging	: true
		},
		columns		: [
			{field:'D_UPDATE_TIME', title:'시간', width:'25%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}, template:'#= createHtml(N_ALM_STATUS, D_UPDATE_TIME) #'},
			{field:'S_ALM_STATUS_NAME', title:'상태', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
			{field:'S_USER_NAME', title:'처리자', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
			{field:'S_ALM_MSG', title:'변경이력', width:'55%', attributes:{style:'text-align:left'}, headerAttributes:{style:'text-align:center'}}
		]
	}));
}
function createGrid_AlmPhoneHistory(v_ip_addr) {
	$("#alarm_history_grid").kendoGrid($.extend({}, kendoGridDefaultOpt, {
		dataSource	: {
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: "/watcher/kendoPagination_checkAlmPhoneHistoryQry.htm",
					data 		: function(data) {
						return { 'S_IP_ADDRESS' : v_ip_addr };
					}
				},
				parameterMap: function (data, opperation) {
					return JSON.stringify(data);
				}
			},
			schema			: {
				data	: function(data) {
					return data;
				},
				total 	: function(response) {
					return response.length > 0 ? response[0].TOTAL_COUNT : 0;
				}
			},
			pageSize		: 10,
			serverPaging	: true
		},
		columns		: [
			{field:'D_UPDATE_TIME', title:'시간', width:'25%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}, template:'#= createHtml(N_ALM_STATUS, D_UPDATE_TIME) #'},
			{field:'S_ALM_STATUS_NAME', title:'상태', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
			{field:'S_USER_NAME', title:'처리자', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
			{field:'S_ALM_MSG', title:'변경이력', width:'55%', attributes:{style:'text-align:left'}, headerAttributes:{style:'text-align:center'}}
		]
	}));
}

function createHtml(status, time) {
	if (parseInt(status) === 0 || parseInt(status) === 1) {
		return '<img src="' + cst.contextPath() + '/common/images/watcher/icon_waring_re.png' + '"/>' + time;
	}
	else {
		return '<img src="' + cst.contextPath() + '/common/images/watcher/icon_waring_ing.png' + '"/>' + time;
	}
}

function fn_save_alram_mon(tei) {
	$('#ERROR_S_ALM_KEY').val(tei.S_ALM_KEY);
	$('#ERROR_N_MON_ID').val(tei.N_MON_ID);
	$('#ERROR_S_IP_ADDRESS').val('');

	var param = $('#frm').serialize(); // error_alarm_history.jsp 페이지 데이터 저장
	$.post('/watcher/main/alarm_status_modify.htm', param)
		.done(function(data) {
			var jsonData = JSON.parse(data);
			if (jsonData.reg_ok && jsonData.reg_ok === 'ok') {
				alert("저장 완료.");
				$('#dialog_popup').dialog("destroy");
				$('#dashboard_error_popup').dialog("destroy");
				
				pageReload();
			}
			else {
				alert("저장에 실패하였습니다.");
				$('#dialog_popup').dialog("destroy");
				$('#dashboard_error_popup').dialog("destroy");
			}
		});
}
function fn_save_alram_phone(tei) {
	$('#ERROR_S_IP_ADDRESS').val(tei.S_IP_ADDRESS);

	var param = $('#frm').serialize(); // error_alarm_history.jsp 페이지 데이터 저장
	$.post('/watcher/main/alarm_status_modify.htm', param)
		.done(function(data) {
			var jsonData = JSON.parse(data);
			if (jsonData.reg_ok && jsonData.reg_ok === 'ok') {
				alert("저장 완료.");
				$('#dialog_popup').dialog("destroy");
				$('#dashboard_error_popup').dialog("destroy");
				
				pageReload();
			}
			else {
				alert("저장에 실패하였습니다.");
				$('#dialog_popup').dialog("destroy");
				$('#dashboard_error_popup').dialog("destroy");
			}
		});
}
</script>
