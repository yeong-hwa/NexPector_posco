<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>

<%@ include file="/WEB-INF/views/include/include.jsp" %>

<%-- <script src="${contextPath}/include/js/global_data.js" type="text/JavaScript"></script> --%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>::: NexPecter Manager :::</title>
<script>

	function fn_select_menu(url)
	{
		// 사용자 정보 관리
		if(url == "agent_mgr.init.neonex") url = "<c:url value="/admin/go_prgm.user.user_info.retrieve.htm"/>";

		// 사용자 메뉴 관리
		if(url == "user_menu_mgr.init.neonex") url = "<c:url value="/admin/go_prgm.user.user_menu.user_menu.htm"/>";

		// 사용자 그룹 관리
		if(url == "agentgroup_mgr.init.neonex") url = "<c:url value="/admin/go_prgm.user.user_group.retrieve.htm"/>";

		// *** 사용자등급코드 관리
		if(url == "rating_mgr.init.neonex") url = "<c:url value="/admin/go_prgm.user.rating.retrieve.htm"/>";

		// 알람 정보 관리
		if(url == "alarm_mgr.init.neonex") url = "<c:url value="/admin/go_prgm.user.user_alarm.retrieve.htm"/>";

		// 사용자 감시대상장비 관리
		if(url == "user_mon_mgr.init.neonex") url = "<c:url value="/admin/go_prgm.user.user_mon.retrieve.htm"/>";



        // 감시장비 관리
		if(url == "serverinfo_mgr.init.neonex") url = "<c:url value="/admin/go_prgm.mon.mon_info.retrieve.htm"/>";

		// 임계치 정보 관리
		if(url == "equipment_critical_value_mgr.init.neonex") url = "<c:url value="/admin/go_prgm.mon.critical_value.retrieve.htm"/>";

		// ICMP 정보 관리
		if(url == "icmp_mgr.init.neonex") url = "<c:url value="/admin/go_prgm.mon.icmp_info.retrieve.htm"/>";

		// SNMP MAP 코드 관리
		if(url == "snmp_map_mgr.init.neonex") url = "<c:url value="/admin/go_prgm.mon.snmp_map.retrieve.htm"/>";

		// *** SNMP 장비코드 관리
		if(url == "snmp_man_code_mgr.init.neonex") url = "<c:url value="/admin/go_prgm.mon.snmp_man_code.retrieve.htm"/>";

		// *** SNMP 감시 상세코드 관리
		if(url == "snmp_mon_code_mgr.init.neonex") url = "<c:url value="/admin/go_prgm.mon.snmp_mon_code.retrieve.htm"/>";

		// *** 연계장비 관리 equipment_link_mgr.init.neonex

		// SNMP 임계치 관리
		if(url == "snmp_alarm_mgr.init.neonex") url = "<c:url value="/admin/go_prgm.mon.snmp_alarm.retrieve.htm"/>";

		// SNMP Value 코드 관리
		if(url == "snmp_trap_mgr.init.neonex") url = "<c:url value="/admin/go_prgm.mon.snmp_value_code.retrieve_main.htm"/>";

		// *** VoiceGateway 담당자 관리  vgmanager_mgr.init.neonex
		// VoiceGateway 담당자 관리
		if(url == "vgmanager_mgr.init.neonex") url = "<c:url value="/admin/go_prgm.mon.vg_mng.retrieve.htm"/>";

		// 대시보드 시스템 관리
		if(url == "dashboard_system_mgr.init.neonex") url = "<c:url value="/admin/go_prgm.mon.dashboard_system.retrieve.htm"/>";

		// 대시보드 네트워크 관리
		if(url == "dashboard_netword_mgr.init.neonex") url = "<c:url value="/admin/go_prgm.mon.dashboard_network.retrieve.htm"/>";

		// 감시대상 IP전화기 관리
		if(url == "ipphone_mgr.init.neonex") url = "<c:url value="/admin/go_prgm.mon.ipphone.retrieve.htm"/>";



		// 메뉴 정보 관리
		if(url == "menu_mgr.init.neonex") url = "<c:url value="/admin/go_prgm.system.menu_info.retrieve.htm"/>";

		// 서버그룹코드 관리
		if(url == "servergroup_mgr.init.neonex") url = "<c:url value="/admin/go_prgm.system.svr_group.retrieve.htm"/>";

		// 서버타입코드 관리
		if(url == "servertype_mgr.init.neonex") url = "<c:url value="/admin/go_prgm.system.svr_type.retrieve.htm"/>";

		// 서버 스타일 관리
		if(url == "serverstyle_mgr.init.neonex") url = "<c:url value="/admin/go_prgm.system.svr_style.retrieve.htm"/>";

		// 서버그룹맵이미지 관리
		if(url == "servergroup_img_mgr.init.neonex") url = "<c:url value="/admin/go_prgm.system.svr_group_img.retrieve.htm"/>";

		// ***SNMP 정보 관리 snmp_info_mgr.init.neonex
		// SNMP 정보 관리
		if(url == "snmp_info_mgr.init.neonex") url = "<c:url value="/admin/go_prgm.system.snmp_info.retrieve.htm"/>";

		if(url == "job_management_mgr.init.neonex") url = "<c:url value="/admin/go_prgm.mon.jobmanagement.retrieve.htm"/>";

		document.frm.action = url;
		document.frm.target="ifm_screen";
		document.frm.submit();
	}

	function fn_history_back(url)
	{
		//if(url != "")
		//	ifm_submenu.fn_history_back(url);
	}

	function init()
	{
		//gfn_get_combo_data();
	}

	function goWatcherPage() {
		location.href = '<c:url value="/watcher/main/switch.htm"/>';
	}

</script>
</head>

<body onload="init()">
	<form name="frm" method="post">
		<input type="hidden" name="url" value="">

	<table border="0" width="1250" height="900">
		<tr height="120">
			<td colspan="2"><iframe name="ifm_top" src="<c:url value="/admin/top.htm"/>" width="100%" height="100%" frameborder="0" scrolling="no"></iframe></td>
		</tr>
		<tr height="780">
			<td width="220" valign="top">
				<iframe name="ifm_submenu" src="<c:url value="/admin/left.htm"/>" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>
		    </td>
			<td><iframe name="ifm_screen" src="" width="100%" height="780" frameborder="0" scrolling="no"></iframe></td>
		</tr>
	</table>
	</form>

	<!-- s:비밀번호 변경 레이어 팝업 -->
	<a id="go" rel="leanModal" name="signup" href="#signup"></a>
	<div id="signup" style="display:none;">
		<div id="signup-ct">
			<div id="signup-header">
				<h2>비밀번호 기간(3개월)이 만료되었습니다. </br>비밀번호를 변경해주세요.</h2>
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
					<input id="user_password" name="S_USER_PWD" type="password">
				</div>
				<div class="txt-fld">
					<label for="new_user_password">신규 비밀번호</label>
					<input id="new_user_password" name="S_USER_PWD_NEW" type="password">
				</div>
				<div class="txt-fld">
					<label for="new_user_password_confirm">신규 비밀번호 확인</label>
					<input id="new_user_password_confirm" type="password">
				</div>
				<div class="btn-fld">
					<button id="btn_user_info_modify" type="button">변경</button>
				</div>
			</form>
		</div>
	</div>
	<!-- e:비밀번호 변경 레이어 팝업 -->
</body>
</html>