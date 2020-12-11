<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="com.nns.common.util.RSACrypt" %>
<%@ page pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8;" />
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

	<!-- jQuery Javascript -->
	<script type="text/javascript" src="<c:url value="/js/jquery-1.11.2.min.js" />"></script>
	<script type="text/javascript" src="<c:url value="/js/jquery.blockUI.js"/>"></script>
	<script type="text/javascript" src="<c:url value="/js/jquery-ui-1.11.4.custom/jquery-ui.min.js"/>"></script>
	<!-- Kendo UI Javascript -->
	<script type="text/javascript" src="<c:url value="/common/kendo-ui/js/kendo.all.min.js" />"></script>
	<!-- Project Javascript -->
	<script type="text/javascript" src="<c:url value="/js/common.js" />"></script>
	<script type="text/javascript" src="<c:url value="/js/dtree.js" />"></script>
	<script type="text/javascript" src="<c:url value="/js/function.js" />"></script>
	<script type="text/javascript" src="<c:url value="/js/global-variables.js" />"></script>
	<script type="text/javascript" src="<c:url value="/js/jquery-migrate-1.1.1.min.js" />"></script>

	<!-- 비밀번호 변경 레이어 팝업 Javascript -->
	<script src="<c:url value="/common/js/rsa/jsbn.js"/>" type="text/JavaScript"></script>
	<script src="<c:url value="/common/js/rsa/rsa.js"/>" type="text/JavaScript"></script>
	<script src="<c:url value="/common/js/rsa/prng4.js"/>" type="text/JavaScript"></script>
	<script src="<c:url value="/common/js/rsa/rng.js"/>" type="text/JavaScript"></script>
	<script src="<c:url value="/js/jquery.leanModal.min.js"/>" type="text/JavaScript"></script>
	<script src="<c:url value="/js/auth.js"/>" type="text/JavaScript"></script>

	<style type="text/css">
		#main_menu_wrap li {cursor: pointer;}
		.gnvBox span {cursor: pointer;}
		:root *>.k-icon, :root *>.k-sprite, :root *>.k-button-group .k-tool-icon{vertical-align:middle; margin-top: 4px} /* kendo icon 이 현 퍼블리싱에서 vertical-align:middle; 속성이 적용이 안되서 margin-top 추가 */
	</style>

	<script type="text/javascript">
		//<![CDATA[
		jQuery.migrateMute = true; // jQuery migrate logging off
		var console = window.console || {log:function(){}}; // IE8 이하 버전 console.log 에러 처리 - 개발버전
//		var console = {log:function(){}}; // 상용버전

		var g_login_dt = '${sessionScope.LOGIN_DT}', g_last_alarm_dt = '';

		setRsaModulusKey("<%=RSACrypt.getModulusKey()%>");
		setRsaPublicKey("<%=RSACrypt.getPublicKey()%>");

		// Document Ready
		$(document).ready(function() {

			// 비밀번호 변경 Modal Layer Popup
			$('a[rel*=leanModal]').leanModal({ top : 200, closeButton: ".modal_close", open: function() {$('#user_password').focus();} });

			var c = createConstants('${ctx}');
			c.countPerPage(15); // Paging 한페이지 표시 개수
			c.pageSize(10); // Paging 하단 부분 몇개 나눌지 여부

			initialize();

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

			$('#btn_all_error').kendoButton();

			// 사용기간에 따른 비밀번호 변경여부
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

			/*$.widget("ui.dialog", $.extend({}, $.ui.dialog.prototype, {
				_title: function(title) {
					if (!this.options.title ) {
						title.html("&#160;");
					}
					title.html(this.options.title);
				}
			}));*/
		});

		// 초기화
		function initialize() {
			goMenu(document.getElementById('mnavi01_01'));

			fn_chk_alarm_status(); // 장애 알람 체크
		}

		// Watcher 상위 메뉴 - 실시간 통계, 감시장비별 상세조회, 이력/통계 조회
		function goMenu(obj, parameter) {
			var url, param = {}, imgSrc;

			if (parameter) {
				$.extend(param, parameter);
			}

			if (obj.id === 'mnavi01_01') {
				url 	= cst.contextPath() + '/watcher/realtime_stats/realtime_main.htm';
				imgSrc 	= cst.contextPath() + '/images/nv/wnv01_on.png';
			}
			else if (obj.id === 'mnavi01_02') {
				url 	= cst.contextPath() + '/watcher/server_detail/server_detail_main.htm';
				imgSrc 	= cst.contextPath() + '/images/nv/wnv02_on.png';
			}
			else if (obj.id === 'mnavi01_03') {
				url 	= cst.contextPath() + '/watcher/history_stats/history_stats_main.htm';
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

			$.get(url, param, function(html) {
				$('#contentsArea .boxC').html(html);
			});
		}

		// Setting Popup
		function fn_setting() {
			var url 	= cst.contextPath() + '/watcher/go_main.setting.htm',
				param 	= $.param({
					'req_data'  : 'user_compo_lst;UserCompoLstQry|compo_lst;CompoLstQry',
					'S_USER_ID' : '${sessionScope.S_USER_ID}'
				});
			window.open(url + '?' + param,"setting","width=400, height=420, location=no", true);
		}

		function fn_chk_alarm_status() {
			if (g_login_dt == null || g_login_dt == "") {
				g_login_dt = cfn_getTimeStamp();
			}

			var url		= cst.contextPath() + '/watcher/main/error_alarm_history.htm',
				param 	= {
					'LOGIN_DT' : g_login_dt,
					'LAST_ALARM_DT' : g_last_alarm_dt
				};

			$.post(url, param, function (str) {
				var data = JSON.parse(str);
				if (data[0].S_ALM_KEY == null) {
					g_last_alarm_dt = g_login_dt;
					setAlarmData();
				}
				else {
					g_last_alarm_dt = data[0].D_UPDATE_TIME == null ? "" : data[0].D_UPDATE_TIME;
					setAlarmData(data);

					$('#check_alarm_wrap').data(data[0]);
				}

				if (data[0].NEW_ALARM == "1") {
					fn_alarm_sound();
					fn_error_popup_open();
				}
				else {
					if (!data[0].S_ALM_KEY) {
						$('[id^=ntopPop0]').delay(200).slideUp();
					}
				}

//				createGrid(data);

				setTimeout(fn_chk_alarm_status, 3000);
			});
		}

		function goErrorCheckServerDetail(obj) {
			console.log($(obj).data());
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

		function setAlarmData(obj) {
			if (obj) {
				$('#alarm_update_date').text(obj[0].D_UPDATE_TIME);
				$('#alarm_mon_name').text(obj[0].S_MON_NAME);
				$('#alarm_rating_name').text(obj[0].S_ALM_RATING_NAME);
				$('#alarm_status_name').text(obj[0].S_ALM_STATUS_NAME);
				$('#alarm_message').text(obj[0].S_ALM_MSG);

				$('#alarm_total_count').text(obj.length - 1); // 출력된 값을 제외한 나머지 카운트이기 때문에 -1
			}
			else {
				$('#alarm_update_date').text('-');
				$('#alarm_mon_name').text('-');
				$('#alarm_rating_name').text('-');
				$('#alarm_status_name').text('-');
				$('#alarm_message').text('-');

				$('#alarm_total_count').text(0);
			}
		}

		function fn_alarm_sound() {
			$('#div_alarm_sound').html('<embed src="' + cst.contextPath() + '/common/wav/error.wav' + '" hidden="true" style="display: none;">');
		}

		function fn_error_popup_open() {
			$('[id^=ntopPop0]').delay(200).slideDown();
		}

		function fn_error_state_popup(event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;

			var param = "LOGIN_DT=" + g_login_dt;
			param += "&LAST_ALARM_DT=" + g_last_alarm_dt;

			var dialogWidth = 900;

			$('#error_state_dialog_popup')
				.show()
				.dialog({
					title			: '새로운 장애 발생',
					resizable		: false,
					width			: dialogWidth,
					modal			: true,
					position		: [($(window).width() / 2) - (dialogWidth / 2), 150],
					autoReposition	: true,
					open			: function() {
						$(this).parent().css({top:50, left:($(window).width() / 2) - (dialogWidth / 2)});

					}
				});

			/*$.get(cst.contextPath() + '/watcher/main/error_alarm_history.htm', param)
				.done(function(json) {
					console.log(json);
					var data = JSON.parse(json);

					$('#update_time').text(data[0].CHECK_DT);


					$('#error_state_dialog_popup')
//						.html(innerHtml)
						.dialog({
							title			: '새로운 장애 발생',
							resizable		: false,
							width			: dialogWidth,
							modal			: true,
							position		: [($(window).width() / 2) - (dialogWidth / 2), 150],
							autoReposition	: true,
							open			: function() {
								$(this).parent().css({top:50, left:($(window).width() / 2) - (dialogWidth / 2)});

							}
						});
				});*/
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

		function fn_alarm_history_popup(v_mon_id, v_alm_key, event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;

			var param = "N_MON_ID=" + v_mon_id;
			param += "&S_ALM_KEY=" + v_alm_key;

			var dialogWidth = 900;

			$.get(cst.contextPath() + '/watcher/go_main.error_alarm_history.htm', param)
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
								"확인": function() {
									fn_save(); // error_alarm_history.jsp 선언
								},
								"취소": function() {
									$( this ).dialog( "close" );
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
<div id="ntopPop01" class="vsual_off" style="overflow:hidden; display: block;">
	<div class="notice">
		<div class="txtbox">
			<div class="txt">
				<ul>
					<li>시간 : <span id="alarm_update_date">-</span></li>
					<li>장비명 : <span id="alarm_mon_name">-</span></li>
					<li>등급 : <span id="alarm_rating_name">-</span></li>
					<li>상태 : <span id="alarm_status_name">-</span></li>
					<li>내용 : <span id="alarm_message">-</span> <%--&nbsp;&nbsp; 외 <span id="alarm_total_count">0</span>건 &nbsp;&nbsp;--%></li>
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
<!-- e:장애 알람 영역 //-->

<!-- s:전체영역 -->
<div id="Wrapper">

	<!-- s:상단영역 -->
	<div id="topArea">
		<div class="boxT">
			<div class="slogoB">
				<h1 class="slogo">
					<img src="<c:url value="/images/watcher/logo_s01.png" />" height="14px" alt="NEONEXsoft"/>
				</h1>
				<span class="logoutA">
					<a id="go" rel="leanModal" name="signup" href="#signup" style="color:#f2641a;font-weight: bold;">${S_USER_NAME}</a>님 로그인 하셨습니다
					<a href="<c:url value="/watcher/logout.htm"/>"><img src="<c:url value="/images/botton/logout.png"/>" alt="Logout" /></a>&nbsp;&nbsp;
					<a href="#" onclick="fn_error_popup_open(); return false;" class="ico_view">장애현황 보기</a>&nbsp;&nbsp;
					<a href="<c:url value="/admin/main/switch.htm"/>" class="ico_adm">관리자 페이지</a>
				</span>
			</div>

			<!-- 상단메뉴 네비게이션-->
			<div class="gnvBox">
				<span><img src="<c:url value="/images/watcher/logo01_miraeasset.png" />" alt="NEXPector" /><img src="<c:url value="/images/watcher/logo_title_watcher01.png" />" alt="NEXPector" /></span>
				<ul id="main_menu_wrap">
					<%--<li><img id="img_warning" src="<c:url value="/common/images/watcher/icon_warning1.png"/>" onclick="fn_error_popup_open()" style="cursor:pointer;"></li>--%>
					<li><img src="<c:url value="/images/nv/wnv01_on.png" />" alt="실시간 통계" name="mnavi01_01" width="181" height="65" border="0" id="mnavi01_01" /></li>
					<li><img src="<c:url value="/images/nv/wnv02_off.png" />" alt="감시장비별 상세조회" name="mnavi01_02" width="183" height="65" border="0" id="mnavi01_02" /></li>
					<li><img src="<c:url value="/images/nv/wnv03_off.png" />" alt="이력/통계 조회" name="mnavi01_03" width="182" height="65" border="0" id="mnavi01_03" /></li>
				</ul>
			</div>
			<!--// 상단메뉴네비게이션-->
		</div>
	</div>
	<!-- e:상단영역 // -->

	<!-- s:콘텐츠영역 -->
	<div id="contentsArea">
		<div class="boxC">

		</div>
	</div>
	<!-- e:콘텐츠영역 // -->

	<!-- s:하단영역 -->
	<div id="footerArea">
		<div class="boxF">COPYRIGHT 2004 NEONEXSoft Inc. all rights reserved.</div>
	</div>
	<!-- e:하단영역 // -->

</div>
<!-- e:전체영역 // -->

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
	$('[id^=ntopPop0]').hide();
	//	$('[id^=ntopPop0]').delay(200).slideDown();
	$('.description').bind('click',function(){
		$('[id^=ntopPop0]').delay(200).slideUp();
	});
	//]]>
</script>
</body>
</html>