<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="com.nns.common.util.RSACrypt" %>
<%@ page pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<%
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader("Expires",0);
	if (request.getProtocol().equals("HTTP/1.1")) {
		response.setHeader("Cache-Control", "no-cache");
	}
%>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
	<title>NexPector Watcher</title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<!-- Project CSS -->
	<link type="text/css" href="<c:url value="/css/common.css" />" rel="stylesheet">
	<!-- jQuery CSS -->
	<link type="text/css" href="<c:url value="/js/jquery-ui-1.11.4.custom/jquery-ui.css" />" rel="stylesheet">
	<!-- Kendo UI CSS -->
	<link type="text/css" href="<c:url value="/common/kendo-ui/styles/kendo.common.min.css" />" rel="stylesheet"/>
	<link type="text/css" href="<c:url value="/common/kendo-ui/styles/kendo.default.min.css" />" rel="stylesheet"/>
	<link type="text/css" href="<c:url value="/common/kendo-ui/styles/kendo.bootstrap.min.css" />" rel="stylesheet"/>
	<link type="text/css" href="<c:url value="/common/kendo-ui/styles/kendo.dataviz.bootstrap.min.css" />" rel="stylesheet"/>
	<!-- 비밀번호 변경 레이어 팝업 CSS -->
	<link rel="stylesheet" href="<c:url value="/css/sign.css" />" />
	<!-- dtree CSS -->
	<link rel="stylesheet" href="<c:url value="/css/dtree.css" />" />

	<style type="text/css">
		#main_menu_wrap li {cursor: pointer;}
		.gnvBox span {cursor: pointer;}
		:root *>.k-icon, :root *>.k-sprite, :root *>.k-button-group .k-tool-icon{vertical-align:middle; margin-top: 4px} /*kendo icon 이 현 퍼블리싱에서 vertical-align:middle; 속성이 적용이 안되서 margin-top 추가*/
		.k-grid, .k-scheduler, .k-menu, .k-editor {border-radius: 0px;}
	</style>

	<!-- jQuery Javascript -->
	<script type="text/javascript" src="<c:url value="/common/js/jquery-3.2.1.min.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/common/js/jquery-migrate-3.0.0.min.js" />"></script>
	<script type="text/javascript" src="<c:url value="/js/jquery.blockUI.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/js/jquery-ui-1.11.4.custom/jquery-ui.min.js"/>"></script>

	<!-- Kendo UI Javascript -->
	<script type="text/javascript" src="<c:url value="/common/kendo-ui/js/kendo.all.min.js" />"></script>
	<script type="text/javascript" src="<c:url value="/common/kendo-ui/js/kendo.culture.ko-KR.min.js" />"></script>
	
	<!-- Project Javascript -->
	<script type="text/javascript" src="<c:url value="/js/common.js" />"></script>
	<script type="text/javascript" src="<c:url value="/js/dtree.js" />"></script>
	<script type="text/javascript" src="<c:url value="/js/function.js" />"></script>
	<script type="text/javascript" src="<c:url value="/js/global-variables.js" />"></script>

	<!-- 비밀번호 변경 레이어 팝업 Javascript -->
	<script src="<c:url value="/common/js/rsa/jsbn.js"/>" type="text/JavaScript"></script>
	<script src="<c:url value="/common/js/rsa/rsa.js"/>" type="text/JavaScript"></script>
	<script src="<c:url value="/common/js/rsa/prng4.js"/>" type="text/JavaScript"></script>
	<script src="<c:url value="/common/js/rsa/rng.js"/>" type="text/JavaScript"></script>
	<script src="<c:url value="/js/jquery.leanModal.min.js"/>" type="text/JavaScript"></script>
	<script src="<c:url value="/js/auth.js"/>" type="text/JavaScript"></script>

	<script type="text/javascript" src="<c:url value="/js/initialize.js" />"></script>
	<script type="text/javascript" src="<c:url value="/js/jquery-extend.js" />"></script>

	<script type="text/javascript">
    	kendo.culture("ko-KR");	
	
/* 		$(document).on("contextmenu",function(e){        
		   e.preventDefault();
		});
	
		$(document).keydown(function(event) {
		    if(event.keyCode==123){
		    return false;
		}});
 */	
		//<![CDATA[
		jQuery.migrateMute = true; // jQuery migrate logging off
		var console = window.console || {log:function(){}}; // IE8 이하 버전 console.log 에러 처리 - 개발버전
		//		var console = {log:function(){}}; // 상용버전

		var g_login_dt = '${sessionScope.LOGIN_DT}'; 
		var g_last_error_alarm_dt = '';
		var g_last_event_alarm_dt = '';
		var isPopupOpen = false;
		// 20160713 huni1067 추가
		// session LOGIN_CNT 체크
		var loginCnt = '${sessionScope.LOGIN_CNT}';

		setRsaModulusKey("<%=RSACrypt.getModulusKey()%>");
		setRsaPublicKey("<%=RSACrypt.getPublicKey()%>");

		// Document Ready
		$(document).ready(function() {
			//20160712
			// 사용자 등록후 첫 페이지 비밀번호 설정 레이어 표출
			$('a[rel*=leanModal]').leanModal({ top : 200, closeButton: ".modal_close", open: function() {$('#user_password').focus();} });
			if(loginCnt == 0) $("#go").click();

			// 비밀번호 변경 Modal Layer Popup
//			$('a[rel*=leanModal]').leanModal({ top : 200, closeButton: ".modal_close", open: function() {$('#user_password').focus();} });

			var c = createConstants('${ctx}');
			c.countPerPage(15); // Paging 한페이지 표시 개수
			c.pageSize(10); // Paging 하단 부분 몇개 나눌지 여부

			fn_chk_alarm_popup_status(); // 알람 팝업 체크

			var obj;
			if ('${param.menu}' === '' || '${param.menu}' === 'mnavi01_01') {
				obj = document.getElementById('mnavi01_01');
			} else if ('${param.menu}' === '' || '${param.menu}' === 'mnavi01_02') {
				obj = document.getElementById('mnavi01_02');
			} else {
				obj = document.getElementById('mnavi01_03');
			}
			$(obj).prop('selected', true); // 해당 메뉴가 선택된 메뉴이면 mouseout 이벤트에도 on 상태를 유지하기 위한 선언

			// Event 등록
			$('.gnvBox span').on('click', function() {
				if ( !confirm('메인 페이지로 이동 하시겠습니까?') ) {
					return;
				}
				location.href = cst.contextPath() + '/watcher/main.htm';
			});

			$('#main_menu_wrap').find('img')
					.on('click', function(event) {
						event.preventDefault();
						goMenu(this);
					})
					.hover(
						function() {
							this.src = this.src.replace('_off', '_on');
						},
						function() {
							if (!$(this).prop('selected')) {
								this.src = this.src.replace('_on', '_off');
							}
						});

			// 브라우저 사이즈 변경시 차트 리사이즈
			$(window).on("resize", function() {
				kendo.resize($(".chart-wrapper"));
			});
			//-- Event 등록

			// 사용기간에 따른 비밀번호 변경여부
			checkPasswordChange();
			
		});

		function checkPasswordChange() {
			var loginResult = '${LOGIN_RESULT}';
			var PERIOD_PREVIOUS = 104;
			if (loginResult != '' && parseInt(loginResult) === PERIOD_PREVIOUS ) {
				if (confirm('곧 비밀번호 사용 기간이 만료 됩니다.\n비밀번호를 변경하시겠습니까?')) {
					$('#go').click();
					$('#user_password').focus();
				}
				else {
					$('.modal_close').click();
				}
			}
			$('#user_id').val('${S_USER_ID}');
			$('#user_name').val('${S_USER_NAME}');
		}

		// Watcher 상위 메뉴 - 실시간 통계, 감시장비별 상세조회, 이력/통계 조회
		function goMenu(obj, parameter, menulink) {
			var url, param = {}, imgSrc;

			if (parameter) {
				$.extend(param, parameter);
			}

			if (obj.id === 'mnavi01_01') {
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

			location.href = url + '&' + $.param(param);
		}

		var	g_cb_funcTimer = null;
		function fn_chk_alarm_popup_status() {
			if (g_login_dt == null || g_login_dt == "") {
				g_login_dt = cfn_getTimeStamp();
			}
			var url		= cst.contextPath() + '/watcher/main/alarm_popup_history.htm',
				param	= {
					'LOGIN_DT' : g_login_dt,	
					'LAST_ERROR_ALARM_DT' : g_last_error_alarm_dt,
					'LAST_EVENT_ALARM_DT' : g_last_event_alarm_dt
				};

			$.post(url, param, function (str) {
				var data = JSON.parse(str);
				
				var newErrorAlarmFlag = false;
				var newEventAlarmFlag = false;

				if (data.isCheck == 'Y') { // 데이터 없을 시 로그인 시간 기준으로  조회
					// g_last_alarm_dt = g_login_dt;
					// g_last_error_alarm_dt = g_login_dt;
					// g_last_event_alarm_dt = g_login_dt;
				}
				
				if (data.isError == 'Y') {
					g_last_error_alarm_dt = data.errorData[0].D_UPDATE_TIME == null ? "" : data.errorData[0].D_UPDATE_TIME;
					
					if (data.errorData[0].NEW_ALARM == '1') { // 새로운 알람이 있으면 무조건 팝업창 open.
						newErrorAlarmFlag = true;
						
						setErrorAlarmData(data.errorData);
						fn_alarm_sound();
						fn_alarm_popup_open();
					}
				} 
				else {
					g_last_error_alarm_dt = g_login_dt;
				}
				
				if (data.isEvent == 'Y') {
					g_last_event_alarm_dt = data.eventData[0].D_IN_DATE == null ? "" : data.eventData[0].D_IN_DATE;
					
					if (data.eventData[0].NEW_ALARM == '1') {
						newEventAlarmFlag = true;
						
						// setEventAlarmData(data.eventData);
						
						if (!newErrorAlarmFlag) { // 동시에 발생 시 장애 팝업 우선
							// fn_alarm_popup_open();
						}
					}
				} 
				else {
					g_last_event_alarm_dt = g_login_dt;
				}
				
				
				if (newErrorAlarmFlag == false && newEventAlarmFlag == false) { // 새로운 알람은 없고 로그인 후 발생한 알람이 있을 시 (페이지 이동 시에도 팝업창에 데이터가 존재)
					   fn_alarm_popup_close();
					
					if (data.eventData && data.errorData) { // 둘다 데이터 있을 시 날짜 비교 후 최신 정보 세팅
						
						var errorTime = fn_stringToDate(data.errorData[0].D_UPDATE_TIME);
						var eventTime = fn_stringToDate(data.eventData[0].D_IN_DATE);
						
						if (errorTime.getTime() < eventTime.getTime()) { // 최신 정보 세팅
							if (!isPopupOpen) { // 팝업창 띄운 상황에서 데이터 바뀌지 않도록 함
								setEventAlarmData(data.eventData);
							}
						} 
						else {
							if (!isPopupOpen) {
								setErrorAlarmData(data.errorData);	
							}
						}
						
					} else if (data.errorData) {
						if (!isPopupOpen) {
							setErrorAlarmData(data.errorData);	
						}
					} else if (data.eventData) {
						if (!isPopupOpen) {
							setEventAlarmData(data.eventData);
						}
					}
				} 
				
				// call Garbage Collector using JScript like IE.
				if (typeof(CollectGarbage) == "function") {
				    CollectGarbage();
				};
				if (g_cb_funcTimer != null) {
					g_cb_funcTimer();
				}
				
				timeout.push(setTimeout(fn_chk_alarm_popup_status, 10000));
			}); 
		}
		
		function fn_stringToDate(str) {
			
			var year = str.substr(0, 4);
			var month = str.substr(4, 2);
			var day = str.substr(6, 2);
			var hour = str.substr(8, 2);
			var minute = str.substr(10, 2);
			var second = str.substr(12, 2);
			
			var date = new Date(year, month, day, hour, minute, second);
			
			return date;
		}
		
		function goErrorCheckServerDetail(obj) {
			var monId = $(obj).data('N_MON_ID');
			var groupCode = $(obj).data('N_GROUP_CODE');
			$.getJSON('<c:url value="/watcher/map_SvrLstByMonIdPageNum.htm"/>', {'MON_ID' : monId, 'N_GROUP_CODE' : groupCode}, function(data) {
				var pageNum = "";
				if(parseInt(data.NUM % 15) > 0)
					pageNum=parseInt(data.NUM / 15) + 1;
				else
					pageNum=parseInt(data.NUM / 15);

				var param = {'N_GROUP_CODE' : groupCode, 'N_MON_ID' : monId, pageNum : pageNum};
				goMenu(document.getElementById('mnavi01_02'), param);
			});
		}
		
		function setErrorAlarmData(obj) {
			if (obj) {
				$('.go_event_history').attr('href', '<c:url value="/watcher/go_history_stats.error_history.error_history.htm?menu=mnavi01_03&subMenu=3100"/>');
				$('#ntop_notice').removeClass('notice1');
				$('#ntop_notice').addClass('notice2');
				
				$('#popup_txt').empty();
				$('#popup_txt').append('<li>시간 : <span>'+ obj[0].D_UPDATE_TIME_FORMAT + '</span></li>');
				$('#popup_txt').append('<li>장비명 : <span>'+ obj[0].S_MON_NAME + '</span></li>');
				$('#popup_txt').append('<li>등급 : <span>'+ obj[0].S_ALM_RATING_NAME + '</span></li>');
				$('#popup_txt').append('<li>상태 : <span>'+ obj[0].S_ALM_STATUS_NAME + '</span></li>');
				$('#popup_txt').append('<li>내용 : <span style="width:1000px;overflow:hidden;white-space:nowrap;text-overflow:ellipsis;float:right;">'+ obj[0].S_ALM_MSG + '</span></li>');
				
				// $('#alarm_total_count').text(obj.length - 1); // 출력된 값을 제외한 나머지 카운트이기 때문에 -1
			}
			else {
				// $('#popup_txt').empty();
				// $('#alarm_total_count').text(0);
			}
		}
		
		function setEventAlarmData(obj) {
			if (obj) {
				$('.go_event_history').attr('href', '<c:url value="/admin/go_prgm.user.change_history.retrieve.htm"/>');
				$('#ntop_notice').removeClass('notice2');
				$('#ntop_notice').addClass('notice1');
				
				$('#popup_txt').empty();
				$('#popup_txt').append('<li>시간 : <span>'+ obj[0].D_IN_DATE_FORMAT + '</span></li>');
				$('#popup_txt').append('<li>종류 : <span>'+ obj[0].S_VALUE + '</span></li>');
				$('#popup_txt').append('<li>ID : <span>'+ obj[0].S_USER_ID + '</span></li>');
				$('#popup_txt').append('<li>내용 : <span style="width:1000px;overflow:hidden;white-space:nowrap;text-overflow:ellipsis;float:right;">'+ obj[0].S_EVENT_NAME +' ['+ obj[0].S_DATA + ']' + '</span></li>');
				//$('#alarm_total_count').text(obj.length - 1); // 출력된 값을 제외한 나머지 카운트이기 때문에 -1
			}
			else {
				// $('#popup_txt').empty();
				//$('#alarm_total_count').text(0);
			}
		}

		function fn_alarm_sound() {
			$('#div_alarm_sound').html('<embed src="' + cst.contextPath() + '/common/wav/error.wav' + '" hidden="true" style="display: none;">');
		}


		function fn_alarm_popup_open() {
			$('[id^=ntopPop0]').css("visibility", "visible");
			$('[id^=ntopPop0]').delay(200).slideDown(function() {
				isPopupOpen = true;
			});
		}
		
		function fn_alarm_popup_close() {
			$('[id^=ntopPop0]').delay(200).slideUp(function() {
				isPopupOpen = false;
			});
		}

		function createGrid(dataSource) {
			$("#error_state_grid").kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource: dataSource,
				columns: [
					{
						field: 'D_UPDATE_TIME',
						title: '시간',
						width: '25%',
						attributes: {style: 'text-align:center'},
						headerAttributes: {style: 'text-align:center'}
//						template: kendo.template($("#error_state_dialog_template").html())
					},
					{
						field: 'S_MON_NAME',
						title: '장비명',
						width: '10%',
						attributes: {style: 'text-align:left'},
						headerAttributes: {style: 'text-align:center'}
					},
					{
						field: 'S_ALM_RATING_NAME',
						title: '등급',
						width: '10%',
						attributes: {style: 'text-align:center'},
						headerAttributes: {style: 'text-align:center'}
					},
					{
						field: 'S_ALM_STATUS_NAME',
						title: '상태',
						width: '10%',
						attributes: {style: 'text-align:center'},
						headerAttributes: {style: 'text-align:center'}
					},
					{
						field: 'S_ALM_MSG',
						title: '내용',
						width: '45%',
						attributes: {style: 'text-align:left'},
						headerAttributes: {style: 'text-align:center'}
					}
				]
			}));
		}

		function logout() {
			typeof d !== 'undefined' && d.clearCookie();
			location.href = cst.contextPath() + '/watcher/logout.htm';
		}
		
		// 그리드 Row Select 시에 해당 장애상세페이지로 이동
		function goServerDetailPage(nMonId, nGroupCode, tabStript) {

			if(nMonId === "nMonId" && nGroupCode === "nGroupCode") {
				nMonId = realTimeErrorGrid.dataItem(realTimeErrorGrid.select()).N_MON_ID;
				nGroupCode = realTimeErrorGrid.dataItem(realTimeErrorGrid.select()).N_GROUP_CODE;
			}

			var monId = nMonId;
			var groupCode = nGroupCode ? nGroupCode : '';
			var leftNaviCountPerPage = parseInt(15);
			$.getJSON('<c:url value="/watcher/map_SvrLstByMonIdPageNum.htm"/>', {'MON_ID' : monId, 'N_GROUP_CODE' : groupCode}, function(data) {
				var pageNum = "";
				if(parseInt(data.NUM % leftNaviCountPerPage) > 0) {
					pageNum=parseInt(data.NUM / leftNaviCountPerPage) + 1;
				} else {
					pageNum=parseInt(data.NUM / leftNaviCountPerPage);
				}

				var param = {'N_GROUP_CODE' : groupCode, 'N_MON_ID' : monId, pageNum : pageNum, tabStrip : (tabStript ? tabStript : '')};
				goMenu(document.getElementById('mnavi01_02'), param, 'E'); // watcher_template.jsp 에 선언되어있음.
			});
		}
		
		function templateServerLink(nMonId, sMonName, nGroupCode) {
			return '<a href="#" style="text-decoration: underline;" onclick="goServerDetailPage(' + nMonId + ', ' + nGroupCode + '); return false;">' + sMonName + '</a>';
		}
		
		function fn_alarm_history_popup(v_realTimeErrorGroup, v_mon_id, v_alm_key, event) {
			if (event) {
				event.preventDefault ? event.preventDefault() : event.returnValue = false;
			}

			var param = "S_REAL_TIME_ERROR_GROUP=" + v_realTimeErrorGroup;
			param += "&N_MON_ID=" + v_mon_id;
			param += "&S_ALM_KEY=" + v_alm_key;
			// param += "&S_MON_NAME=" + (monName ? monName : '');
			// param += "&S_ALM_MSG=" + (almMsg ? almMsg : '');

			var dialogWidth = 900;

			$.post(cst.contextPath() + '/watcher/go_main.error_alarm_history.htm', param)
					.done(function(html) {
						$('#dialog_popup')
								.html(html)
								.dialog({
									title			: '장애확인/수동복구',
									resizable		: false,
									width			: dialogWidth,
									modal			: true,
									position		: [($(window).width() / 2) - (dialogWidth / 2), 150],
									autoReposition	: true,
									open			: function() {
										$(this).parent().css({top:50, left:($(window).width() / 2) - (dialogWidth / 2)});
									},
									buttons			: {
										"취소": function() {
											$( this ).dialog( "close" );
										},
										"확인": function() {
											$('#all_check').prop('checked', false);
											fn_save(); // error_alarm_history.jsp 선언
										}
									}
								});
					});
		}
		//]]>
	</script>

	<script type="text/x-kendo-template" id="error_state_dialog_template">
		<img src="<c:url value="/common/images/watcher/warning_view.gif"/>" onclick="# fn_alarm_history_popup(N_MON_ID, S_ALM_KEY); #" /> &nbsp; #: D_UPDATE_TIME #
	</script>
</head>

<body>

<!-- s:장애 알람 영역 -->
<a class="go_event_history" href='<c:url value="/watcher/go_history_stats.error_history.error_history.htm?menu=mnavi01_03&subMenu=3100" />'>
	<div id="ntopPop01" class="vsual_off" style="overflow:hidden; display: none; visibility: hidden">
		<div class="notice2" id="ntop_notice">
			<div class="txtbox">
				<div id="txt" class="txt">
					<ul id="popup_txt">
						<li>시간 : <span id="error_alarm_update_date">-</span></li>
						<li>장비명 : <span id="error_alarm_mon_name">-</span></li>
						<li>등급 : <span id="error_alarm_rating_name">-</span></li>
						<li>상태 : <span id="error_alarm_status_name">-</span></li>
						<li>내용 : <span id="error_alarm_message">-</span> <%--&nbsp;&nbsp; 외 <span id="alarm_total_count">0</span>건 &nbsp;&nbsp;--%></li>
					</ul>
					<%--<button id="btn_all_error" onclick="fn_error_state_popup(event);" style="position: fixed; top: 86px; background: #464D5D; color: white;">전체장애 보기</button>--%>
				</div>
			</div>
			<div class="day">
				<!--<label for="checkbox_5"><input type="checkbox" id="checkbox_5" />하루동안 보지않음</label> -->
				<a href="#" class="description"><img src="<c:url value="/images/common/btn_ntop_close01.png" />" alt="닫기" class="day_btn01" /></a>
			</div>
		</div>
	</div>
</a>
<!-- e:장애 알람 영역 //-->

<!-- s:전체영역 -->
<div id="Wrapper">

	<!-- s:상단영역 -->
	<div id="topArea">
		<div class="boxT">
			<div class="slogoB">
				<h1 class="slogo">
					<img src="<c:url value="/images/watcher/logo_s01.png" />" height="14px" alt="NEXPector"/>
				</h1>
				<span class="logoutA">
					<a id="go" rel="leanModal" name="signup" href="#signup" style="color:#f2641a;font-weight: bold;">${S_USER_NAME}</a> 님 로그인 하셨습니다 <a href="#" onclick="logout(); return false;"><img src="<c:url value="/images/botton/logout.png"/>" alt="Logout" /></a>
					<a href="#" class="ico_view" onclick="fn_alarm_popup_open(); return false;">알람 현황</a>
					<a href="<c:url value="/admin/main/switch.htm"/>" class="ico_adm">관리자 페이지</a>
				</span>
			</div>

			<!-- 상단메뉴 네비게이션-->
			<%--<div class="gnvBox">
				<span><img src="<c:url value="/images/watcher/logo01.png" />" alt="NEXPector" /><img src="<c:url value="/images/watcher/logo_title_watcher01.png" />" alt="NEXPector" /></span>
				<ul id="main_menu_wrap">
					&lt;%&ndash;<li><img id="img_warning" src="<c:url value="/common/images/watcher/icon_warning1.png"/>" onclick="fn_error_popup_open()" style="cursor:pointer;"></li>&ndash;%&gt;
					<li><img src="<c:choose><c:when test="${param.menu eq null or param.menu eq 'mnavi01_01'}"><c:url value="/images/nv/wnv01_on.png" /></c:when><c:otherwise><c:url value="/images/nv/wnv01_off.png" /></c:otherwise></c:choose>" alt="실시간 통계" name="mnavi01_01" width="181" height="64" border="0" id="mnavi01_01" /></li>
					<li><img src="<c:choose><c:when test="${param.menu eq 'mnavi01_02'}"><c:url value="/images/nv/wnv02_on.png" /></c:when><c:otherwise><c:url value="/images/nv/wnv02_off.png" /></c:otherwise></c:choose>" alt="감시장비별 상세조회" name="mnavi01_02" width="183" height="64" border="0" id="mnavi01_02" /></li>
					<li><img src="<c:choose><c:when test="${param.menu eq 'mnavi01_03'}"><c:url value="/images/nv/wnv03_on.png" /></c:when><c:otherwise><c:url value="/images/nv/wnv03_off.png" /></c:otherwise></c:choose>" alt="이력/통계 조회" name="mnavi01_03" width="182" height="64" border="0" id="mnavi01_03" /></li>
				</ul>
			</div>--%>
			<!--// 상단메뉴네비게이션-->


			<!--네비게이션-->
			<div class="gnvBox_v1">
				<div class="logo_left">
					<span>
						<a href="/watcher/realtime_stats/component/center_total.htm?menu=mnavi01_01">
							<img id="logo_img" src="<c:url value='/common/images/watcher/logo01.png'/>" alt="NEXPector" style="float:left; cursor: pointer;"/><span style="color:#ffffff;font-weight: bold;font-size:30px">HELP System Monitoring</span>
							
							<%-- <img src="<c:url value="/admin/images/manager/logo_title_watcher01.png"/>" alt="Nexpector Wathcer" /> --%>
						</a>
					</span>
					<%--<div class="total_box">

						<dl>
							<dt><img src="<c:url value="/images/watcher/cti_title.png"/>" alt="콜 통계" /></dt>
							<dd>
								<p><strong>누적 : 총 <span id="accTotalCall">0</span> / 수신 <span id="inCallCnt">0</span> / 발신 <span id="outCallCnt">0</span> / 내선 <span id="companyCallCnt">0</span></strong></p>
								<p><strong>현황 : 총 <span id="infoTotalCall">0</span> / 통화중 <span id="callingCnt">0</span>  / 연결시도 <span id="connectingCnt">0</span> / 대기 <span id="waitCnt">0</span></strong></p>
							</dd>
						</dl>
					</div>--%>
				</div>
				<ul id="main_menu_wrap">
					<%--<li><img id="img_warning" src="<c:url value="/common/images/watcher/icon_warning1.png"/>" onclick="fn_error_popup_open()" style="cursor:pointer;"></li>--%>
						<li><img src="<c:choose><c:when test="${param.menu eq null or param.menu eq 'mnavi01_01'}"><c:url value="/images/nv/wnv01_on.png" /></c:when><c:otherwise><c:url value="/images/nv/wnv01_off.png" /></c:otherwise></c:choose>" alt="실시간 통계" name="mnavi01_01" width="181" height="64" border="0" id="mnavi01_01" /></li>
						<li><img src="<c:choose><c:when test="${param.menu eq 'mnavi01_02'}"><c:url value="/images/nv/wnv02_on.png" /></c:when><c:otherwise><c:url value="/images/nv/wnv02_off.png" /></c:otherwise></c:choose>" alt="감시장비별 상세조회" name="mnavi01_02" width="183" height="64" border="0" id="mnavi01_02" /></li>
						<li><img src="<c:choose><c:when test="${param.menu eq 'mnavi01_03'}"><c:url value="/images/nv/wnv03_on.png" /></c:when><c:otherwise><c:url value="/images/nv/wnv03_off.png" /></c:otherwise></c:choose>" alt="이력/통계 조회" name="mnavi01_03" width="182" height="64" border="0" id="mnavi01_03" /></li>
				</ul>
			</div>
			<!--//네비게이션-->

		</div>
	</div>
	<!-- e:상단영역 // -->

	<!-- s:콘텐츠영역 -->
	<div id="contentsArea">
		<div class="boxC">
			<!-- left nv -->
			<div id="leftNv_Area" class="<c:choose><c:when test="${param.menu eq null or param.menu eq 'mnavi01_01'}">leftNv_Area</c:when><c:when test="${param.menu eq null or param.menu eq 'mnavi01_02'}">leftNv_Area2</c:when><c:otherwise>leftNv_Area3</c:otherwise></c:choose>">
				<tiles:insertAttribute name="left" />
			</div>
			<!-- left nv // -->

			<!-- contents box -->
			<div id="contentsbox_Area" class="contentsbox_Area">
				<div class="c_start" id="c_start">
					<tiles:insertAttribute name="body" />
				</div>
			</div>
			<!-- contents box // -->
		</div>
	</div>
	<!-- e:콘텐츠영역 // -->

	<!-- s:하단영역 -->
	<div id="footerArea">
		<div class="boxF">COPYRIGHT(c) POSCO all rights reserved.</div>
	</div>
	<!-- e:하단영역 // -->

</div>
<!-- e:전체영역 // -->

<div id="dialog_popup"></div>

<!-- s:에러 상태 레이어 팝업 -->
<div id="error_state_dialog_popup" style="display: none;">
	업데이트 시각 : <span id="update_time"></span><br/>
	<div id="error_state_grid"></div>
</div>
<!-- e:에러 상태 레이어 팝업 -->

<!-- s:비밀번호 변경 레이어 팝업 -->
<div id="signup" style="display:none;">
	<div id="signup-ct">
		<div id="signup-header">
			<h2>비밀번호 변경</h2>
			<a class="modal_close" href="#"></a>
		</div>

		<form id="frm_user_info_modify" name="frm_user_info_modify">

			<div class="txt-fld">
				<label for="user_id">사용자 ID</label>
				<input id="user_id" type="text" value="" disabled>
			</div>
			<%--<div class="txt-fld">
				<label for="user_name">사용자 명</label>
				<input id="user_name" type="text" value="" disabled>
			</div>--%>
			<div class="txt-fld">
				<label for="user_password">기존 비밀번호</label>
				<input id="user_password" name="S_USER_PWD" type="password" class="change_password_input_search">
			</div>
			<div class="txt-fld">
				<label for="new_user_password">신규 비밀번호</label>
				<input id="new_user_password" name="S_USER_PWD_NEW" type="password" class="change_password_input_search">
			</div>
			<div class="txt-fld">
				<label for="new_user_password_confirm">신규 비밀번호 확인</label>
				<input id="new_user_password_confirm" type="password" class="change_password_input_search">
			</div>
			<div class="btn-fld">
				<button id="btn_user_info_modify" type="button">변경</button>
			</div>
		</form>
	</div>
</div>
<!-- e:비밀번호 변경 레이어 팝업 -->

<!-- 장애알람 사운드 -->
<span id="div_alarm_sound" style="display:none;"/>

<script type="text/javascript">
	//<![CDATA[
	/* 상단팝업*/
	//$('[id^=ntopPop0]').hide();
	//	$('[id^=ntopPop0]').delay(200).slideDown();
	$('.description').bind('click',function(){
		$('[id^=ntopPop0]').delay(200).slideUp();
	});
	//]]>
</script>
</body>
</html>