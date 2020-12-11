<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<script type="text/javascript">
	var contextPath = '${ctx}';
	var pMonId = '${param.N_MON_ID}';
	var pAlmKey = '${param.S_ALM_KEY}';
	
	$(document).ready(function() {
		createGrid();
	});

	function createGrid() {
		$("#alarm_history_grid").kendoGrid($.extend({}, kendoGridDefaultOpt, {
			dataSource	: {
				transport		: {
					read		: {
						type		: 'post',
						dataType	: 'json',
						contentType	: 'application/json;charset=UTF-8',
						url 		: contextPath + "/watcher/kendoPagination_checkAlmHistoryQry.htm",
						data 		: function(data) {
							return { 'N_MON_ID' : pMonId, 'S_ALM_KEY' : pAlmKey };
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

	function fn_save() {
		var param = $('#frm').serialize(); // error_alarm_history.jsp 페이지 데이터 저장
		$.post(cst.contextPath() + '/watcher/main/alarm_status_modify.htm', param)
			.done(function(data) {
				var jsonData = JSON.parse(data);
				if (jsonData.reg_ok && jsonData.reg_ok === 'ok') {
					if (jsonData.error_detail && jsonData.error_detail === 'Y') {	//감시장비별 상세조회 메뉴 -> 장애현황 탭정보 일경우
						$("#errorStatsGrid").data('kendoGrid').dataSource.read();
						$("#errorHistoryGrid").data('kendoGrid').dataSource.read();	
					} else {	//실시간통계 메뉴의 실시간 장애현황 그리드
						$("#real_time_error").data('kendoGrid').dataSource.read();
					}
					
					alert("저장 완료.");
					$( '#dialog_popup' ).dialog( "close" );
				}
				else {
					alert("저장에 실패하였습니다.");
				}
			});
	}
</script>

<c:if test="${fn:indexOf(param.S_ALM_KEY, ',') < 0}">
	<!--//내용-->
	<%-- <div class="p_title1"><strong>장비명</strong>:<span>${param.S_MON_NAME}</span><strong>장애명</strong>:<span>${param.S_ALM_MSG}</span></div> --%>
	<div id="alarm_history_grid" class="p_cont1"></div>
	<!--내용//-->
</c:if>


<form id="frm" name="frm">
	<input type="hidden" name="ERROR_S_ALM_KEY" value="${param.S_ALM_KEY}">
	<input type="hidden" name="ERROR_N_MON_ID" value="${param.N_MON_ID}">
	<input type="hidden" name="REAL_TIME_ERROR_GROUP" value="${param.S_REAL_TIME_ERROR_GROUP}">
	<!--//장애이력상세정보-->
	<div class="p_title2"><strong>장애이력 상세정보</strong></div>
	<div class="info_box">
		<table summary="" cellpadding="0" cellspacing="0" class="info_tb1">
			<caption></caption>
			<colgroup>
				<col width="90" />
				<col width="90" />
				<col width="90" />
				<col width="" />
			</colgroup>
			<tr>
				<td><strong>장애 상태</strong></td>
				<td><select name="N_ALM_STATUS" class="select_box_ty1" ><option value="1">수동복구</option><option value="3">확인</option></select></td>
				<td><strong>처리자</strong></td>
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