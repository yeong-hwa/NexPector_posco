<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<c:set var="img3"><c:url value='/common/dashboard/images'/></c:set>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<head>
    <meta charset="utf-8">
  	<!-- Project CSS -->
	<link type="text/css" href="<c:url value="/css/popup.css" />" rel="stylesheet">
	<!-- jQuery CSS -->
	<%-- <link type="text/css" href="<c:url value="/js/jquery-ui-1.11.4.custom/jquery-ui.css" />" rel="stylesheet"> --%>
	<!-- Kendo UI CSS -->
	<link type="text/css" href="<c:url value="/common/kendo-ui/styles/kendo.common.min.css" />" rel="stylesheet"/>
	<link type="text/css" href="<c:url value="/common/kendo-ui/styles/kendo.default.min.css" />" rel="stylesheet"/>
	<link type="text/css" href="<c:url value="/common/kendo-ui/styles/kendo.bootstrap.min.css" />" rel="stylesheet"/>
	<link type="text/css" href="<c:url value="/common/kendo-ui/styles/kendo.dataviz.bootstrap.min.css" />" rel="stylesheet"/>
	
	<style>
		/* .ui-widget{border:1px solid #707070; height:22px; font-size:15px;} */
	</style>
</head>

  <!-- 모달팝업 mid-->
  <div id="myModal_mid" class="popup_wrap_mid mid">
    <!-- Top -->
    <div class="top">
      <a class="close" href="javascript:closePopup();"><img src="${img3}/btn_close.png" alt="닫기"></a>
    </div>
    <!-- //Top -->
    <!-- Content -->
    <div class="content">
      <a id="prev_btn" class="prev" href="#" onclick="prevSlides()"><img src="${img3}/btn_left.png" alt="이전페이지"></a>
      <a id="next_btn" class="next" href="#" onclick="nextSlides()"><img src="${img3}/btn_right.png" alt="다음페이지"></a>
      <!-- table#1 -->
      <div id="table_wrap" class="pop_tbl_wrap">
 <%--         <table class="errorDetail" cellspacing="0" cellpadding="0" summary="">
          <caption style="display: none">장애상세</caption>
          <colgroup>
            <col width="156px" />
            <col width="" />
          </colgroup>
          <thead>
            <tr>
              <th colspan="2">장애상세 <span class="page"><span style="color:#232378">1</span>/3</span>
              </th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <th scope="row">시간</th>
              <td>2017-12-06 18:00:35</td>
            </tr>
            <tr>
              <th scope="row">모니터링코드</th>
              <td>C_PBX_CM1</td>
            </tr>
            <tr>
              <th scope="row">영역</th>
              <td>IPCC</td>
            </tr>
            <tr>
              <th scope="row">타입</th>
              <td>IVR</td>
            </tr>
            <tr>
              <th scope="row">MAPKEY</th>
              <td>0000000</td>
            </tr>
            <tr>
              <th scope="row">등급</th>
              <td class="red">장애</td>
            </tr>
            <tr>
              <th scope="row">상태</th>
              <td class="red">발생</td>
            </tr>
            <tr>
              <th scope="row">발생내용</th>
              <td>CPU 사용률 초과 (85%)</td>
            </tr>
          </tbody>
        </table> --%>
      </div>
      <!-- //table#1 -->
    </div>
    <!-- //Content -->

    <!-- bottom  -->
    <div class="btn_wrap">
      <a class="btn_default mgr8" href="javascript:goCenterTotal();">실시간현황</a>
      <a class="btn_default mgr8" href="javascript:goServerDetail();">장비상세</a>
      <a class="btn_default" href="javascript:recoverError();">수동복구/확인</a>
    </div>
    <!-- //bottom  -->
  </div>
  <!-- //모달팝업 mid-->
  
  <div id="dialog_popup" style="display:none;">
    <div id="alarm_history_grid" class="p_cont1"></div>
	  <form id="frm" name="frm">
		<input type="hidden" id="ERROR_S_ALM_KEY" name="ERROR_S_ALM_KEY" value="${param.S_ALM_KEY}">
		<input type="hidden" id="ERROR_N_MON_ID" name="ERROR_N_MON_ID" value="${param.N_MON_ID}">
		<input type="hidden" id="REAL_TIME_ERROR_GROUP" name="REAL_TIME_ERROR_GROUP" value="${param.S_REAL_TIME_ERROR_GROUP}">
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
  <div>
  
  
  </div>
  
  <script>
	var mapId = '${param.MAP_ID}';
	var parent = '${param.F_PARENT}';
	
	var groupCode = '${param.GROUP_CODE}';
	var serviceCode = '${param.SERVICE_CODE}';
	
	var almKey = '${param.ALM_KEY}';
	
	var errorList;
	var targetError;
	
	var slideIndex = 0;
	var slideTotal = 0;

	var param = {MAP_ID : mapId, ALM_KEY : almKey, F_PARENT: parent, GROUP_CODE : groupCode, SERVICE_CODE : serviceCode};
	console.log('param: ', param);
	$(document).ready( function() {
		$.get('${ctx}' + '/watcher/lst_dashboard_system.SystemErrorQry.htm', param)
		.done(function(str) {
			errorList = JSON.parse(str);
			console.log('errorList: ', errorList);
			slideTotal = errorList.length;

			var html = "";
			for(var i = 0; i < errorList.length; i++) {
				var errorDetail = errorList[i];
				html += "<table id='table_" + i + "' class='errorDetail' cellspacing='0' cellpadding='0' style='display:none;'>";
				html += 	"<caption style='display: none'>장애상세</caption>";
				html += 	"<colgroup>";
				html += 		"<col width='156px' />"; 
				html += 		"<col width='' />"; 
				html += 	"</colgroup>";
				html += 	"<thead>";
				html += 		"<tr>";
				html +=				"<th colspan='2'>장애상세 ";
				html += 				"<span id='page_info' class='page'>";
				html +=						"<span style='color:#232378'>" + (i + 1) + "</span>/"+ slideTotal + "</span>"; 
				html += 				"</span>";
				html +=				"</th>";
				html += 		"</tr>";
				html += 	"</thead>";
				html += 	"<tbody>";
				html +=			"<tr>";
				html +=				"<th scope ='row'>시간</th>";
				html +=				"<td id='update_date'>" + errorDetail.D_UPDATE_TIME + "</td>";
				html +=			"</tr>";
				html +=			"<tr>";
				html +=				"<th scope ='row'>영역</th>";
				html +=				"<td id='group_code'>" + errorDetail.S_GROUP_NAME + "</td>";
				html +=			"</tr>";
				html +=			"<tr>";
				html +=				"<th scope ='row'>모니터링코드</th>";
				html +=				"<td id='alm_code'>" + errorDetail.S_MON_NAME + "</td>";
				html +=			"</tr>";
				html +=			"<tr>";
				html +=				"<th scope ='row'>타입</th>";
				html +=				"<td id='type_code'>" + errorDetail.S_TYPE_NAME + "</td>";
				html +=			"</tr>";
				if (errorDetail.S_MAP_KEY) {
					html +=			"<tr>";
					html +=				"<th scope ='row'>MAPKEY</th>";
					html +=				"<td id='map_key'>" + errorDetail.S_MAP_KEY + "</td>";
					html +=			"</tr>";
				}
				html +=			"<tr>";
				html +=				"<th scope ='row'>등급</th>";
				html +=				"<td id='alm_rate'>" + errorDetail.S_ALM_RATING + "</td>";
				html +=			"</tr>";
				html +=			"<tr>";
				html +=				"<th scope ='row'>상태</th>";
				html +=				"<td id='alm_status'>" + errorDetail.S_ALM_STATUS + "</td>";
				html +=			"</tr>";
				html +=			"<tr>";
				html +=				"<th scope ='row'>발생내용</th>";
				html +=				"<td id='alm_msg'>" + errorDetail.S_ALM_MSG + "</td>";
				html +=			"</tr>";
				html += 	"</tbody>";
				html += "</table>";
			}
			
			$('#table_wrap').html(html);
			
			showSlides();
		});
	});
	function prevSlides() { showSlides(-1); }
	function nextSlides() { showSlides(1); }
	function showSlides(to) {
		if(!to) { to = 0; }
		slides = $("#table_wrap table");
		slides.each(function() {
			$(this).hide();
		});
		
		slideIndex += to;
		slides.eq(slideIndex).show();
		targetError = errorList[slideIndex];
		
		// 이전 페이지 없을 시 prev 버튼 hide
		if ((slideIndex + 1) >= slideTotal) { $('#next_btn').hide(); }
		else { $('#next_btn').show(); }
		//  다음 페이지 없을 시 next 버튼 hide
		if (slideIndex == 0) { $('#prev_btn').hide(); }
		else { $('#prev_btn').show(); }
	}
	
	// 센터 현황으로 이동
	function goCenterTotal() {
		location.href ="/watcher/realtime_stats/component/center_total.htm";
	}
	
	// 감시장비상세 페이지로 이동
	function goServerDetail() {
		var monId = targetError.N_MON_ID;
		var groupCode = targetError.N_GROUP_CODE;
		var leftNaviCountPerPage = parseInt('<spring:eval expression="@serviceProps['watcher.detail.navi.countperpage']"/>');
		$.getJSON('<c:url value="/watcher/map_SvrLstByMonIdPageNum.htm"/>', {'MON_ID' : monId, 'N_GROUP_CODE' : groupCode}, function(data) {
			var pageNum = "";
			if(parseInt(data.NUM % leftNaviCountPerPage) > 0) {
				pageNum=parseInt(data.NUM / leftNaviCountPerPage) + 1;
			} else {
				pageNum=parseInt(data.NUM / leftNaviCountPerPage);
			}

			var param = {'N_GROUP_CODE' : groupCode, 'N_MON_ID' : monId, pageNum : pageNum, tabStrip : "error"};
			goMenu(document.getElementById('mnavi01_02'), param, 'E'); // watcher_template.jsp 에 선언되어있음.
		});
	}
	
	// Watcher 상위 메뉴 - 실시간 통계, 감시장비별 상세조회, 이력/통계 조회
	function goMenu(obj, parameter, menulink) {
		var url, param = {}, imgSrc;

		if (parameter) {
			$.extend(param, parameter);
		}

/* 		if (obj.id === 'mnavi01_01') {
			url 	= cst.contextPath() + '/watcher/realtime_stats/component/center_total.htm?menu=mnavi01_01';
			imgSrc 	= cst.contextPath() + '/images/nv/wnv01_on.png';
		}
		else if (obj.id === 'mnavi01_02') {
			url 	= cst.contextPath() + '/watcher/server_detail/monitoring.htm?menu=mnavi01_02&menulink=' + (menulink ? menulink : 'M');
			imgSrc 	= cst.contextPath() + '/images/nv/wnv02_on.png';
		}
		else if (obj.id === 'mnavi01_03') {
			url 	= cst.contextPath() + '/watcher/go_history_stats.resource_history.resource_history.htm?menu=mnavi01_03';
			imgSrc 	= cst.contextPath() + '/images/nv/wnv03_on.png';
		}
		else {
			return;
		}

		$('#main_menu_wrap img').each(function() {
			this.src = this.src.replace('_on', '_off');
			$(this).prop('selected', false);
		});

		obj.src = imgSrc;
		$(obj).prop('selected', true); // 해당 메뉴가 선택된 메뉴이면 mouseout 이벤트에도 on 상태를 유지하기 위한 선언
 */
 		url = '/watcher/server_detail/monitoring.htm?menu=mnavi01_02&menulink=' + (menulink ? menulink : 'M');
		location.href = url + '&' + $.param(param);
	}
	
	function recoverError() {
		var param = {ERROR_S_ALM_KEY : targetError.S_ALM_KEY, ERROR_N_MON_ID: targetError.N_MON_ID};
		
		fn_alarm_history_popup(targetError.N_MON_ID, targetError.N_MON_ID, targetError.S_ALM_KEY);
	}
	
	function fn_alarm_history_popup(v_realTimeErrorGroup, v_mon_id, v_alm_key) {
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
				createGrid(v_realTimeErrorGroup, v_mon_id, v_alm_key);
			},
			close			: function() {
				$(this).dialog("destroy");
			},
			buttons			: {
				"확인": function() {
					fn_save(); // error_alarm_history.jsp 선언
				},
				"취소": function() {
					$(this).dialog("destroy");
				}
			}
		});
		// createGrid(v_realTimeErrorGroup, v_mon_id, v_alm_key);
	}
	
	function createGrid(v_realTimeErrorGroup, v_mon_id, v_alm_key) {
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
	
	function createHtml(status, time) {
		if (parseInt(status) === 0 || parseInt(status) === 1) {
			return '<img src="' + cst.contextPath() + '/common/images/watcher/icon_waring_re.png' + '"/>' + time;
		}
		else {
			return '<img src="' + cst.contextPath() + '/common/images/watcher/icon_waring_ing.png' + '"/>' + time;
		}
	}
	
	function fn_save() {
		$('#ERROR_S_ALM_KEY').val(targetError.S_ALM_KEY);
		$('#ERROR_N_MON_ID').val(targetError.N_MON_ID);
		
		var param = $('#frm').serialize(); // error_alarm_history.jsp 페이지 데이터 저장
		$.post('/watcher/main/alarm_status_modify.htm', param)
			.done(function(data) {
				var jsonData = JSON.parse(data);
				if (jsonData.reg_ok && jsonData.reg_ok === 'ok') {
					alert("저장 완료.");
					$('#dialog_popup').dialog("destroy");
					$('#dashboard_error_popup').dialog("destroy");
				}
				else {
					alert("저장에 실패하였습니다.");
					$('#dialog_popup').dialog("destroy");
					$('#dashboard_error_popup').dialog("destroy");
				}
			});
	}
  </script>
