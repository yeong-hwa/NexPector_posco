<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript">

	var pMonId 		= '${param.N_MON_ID}',
		pCpuKey 	= '${svr_info.S_CPU_KEY}',
		pMemoryKey 	= '${svr_info.S_MEM_KEY}',
		pDiskKey 	= '${svr_info.S_DISK_KEY}';

	$(function() {
		Initialize();
	});

	function Initialize() {
		fn_get_server_info();
	}

	function fn_get_server_info() {
		var param = {
			'N_MON_ID' : pMonId,
			'S_CPU_KEY' : pCpuKey,
			'S_MEM_KEY' : pMemoryKey,
			'S_DISK_KEY' : pDiskKey
		};
		$.post(cst.contextPath() + "/watcher/server_detail/p_s_info.htm", param)
			.done(function(data) {
				console.log(data);
				var obj = JSON.parse(data);
				console.log(obj);
				var p_s_info = obj.p_s_info;

				var cri_cnt = p_s_info.CRITICAL_ERR_CNT == null ? 0 : p_s_info.CRITICAL_ERR_CNT;
				var maj_cnt = p_s_info.MAJOR_ERR_CNT == null ? 0 : p_s_info.MAJOR_ERR_CNT;
				var min_cnt = p_s_info.MINOR_ERR_CNT == null ? 0 : p_s_info.MINOR_ERR_CNT;

				if (cri_cnt > maj_cnt) {
					if (cri_cnt > min_cnt) {
						maj_cnt = 30 * (maj_cnt / cri_cnt);
						min_cnt = 30 * (min_cnt / cri_cnt);
						cri_cnt = 30;
					}
					else if (cri_cnt < min_cnt) {
						maj_cnt = 30 * (maj_cnt / min_cnt);
						cri_cnt = 30 * (cri_cnt / min_cnt);
						min_cnt = 30;
					}
					else {
						maj_cnt = maj_cnt == 0 ? 0 : 30 * (maj_cnt / cri_cnt);
						cri_cnt = cri_cnt == 0 ? 0 : 30;
						min_cnt = min_cnt == 0 ? 0 : 30;
					}
				}
				else if (cri_cnt < maj_cnt) {
					if (maj_cnt > min_cnt) {
						cri_cnt = 30 * (cri_cnt / maj_cnt);
						min_cnt = 30 * (min_cnt / maj_cnt);
						maj_cnt = 30;
					}
					else if (maj_cnt < min_cnt) {
						maj_cnt = 30 * (maj_cnt / min_cnt);
						cri_cnt = 30 * (cri_cnt / min_cnt);
						min_cnt = 30;
					}
					else {
						cri_cnt = cri_cnt == 0 ? 0 : 30 * (cri_cnt / maj_cnt);
						maj_cnt = maj_cnt == 0 ? 0 : 30;
						min_cnt = min_cnt == 0 ? 0 : 30;
					}
				}
				else {
					min_cnt = min_cnt == 0 ? 0 : 30 * (min_cnt / cri_cnt);
					cri_cnt = cri_cnt == 0 ? 0 : 30;
					maj_cnt = maj_cnt == 0 ? 0 : 30;
				}

				$("#t_error_cnt_critical").text(p_s_info.CRITICAL_ERR_CNT);
				$("#t_error_cnt_major").text(p_s_info.MAJOR_ERR_CNT);
				$("#t_error_cnt_minor").text(p_s_info.MINOR_ERR_CNT);

				$("#t_error_cnt_critical_h").attr("height", cri_cnt);
				$("#t_error_cnt_major_h").attr("height", maj_cnt);
				$("#t_error_cnt_minor_h").attr("height", min_cnt);

				function fn_resource_bar(val) {
					return val < 50 ? (val * 2) : (val * 2 - (Math.floor((val - 50) / 10) * 3));
				}

				var cpu_info = obj.cpu_info;
				$("#t_cpu_per").attr("width", fn_resource_bar(cpu_info.N_PER_USE));
				$("#t_cpu_usage").text((cpu_info.N_NOW_USE == null ? "" : cpu_info.N_NOW_USE) + "%");

				var mem_info = obj.mem_info;
				$("#t_mem_per").attr("width", fn_resource_bar(mem_info.N_PER_USE));
				// $("#t_mem_usage").text((mem_info.N_NOW_USE==null?"":mem_info.N_NOW_USE) + "/" + (mem_info.N_FULL_SIZE==null?"":mem_info.N_FULL_SIZE) + "MB");
				$("#t_mem_usage").text(mem_info.N_PER_USE == null ? "" : mem_info.N_PER_USE + "%");

				var disk_info = obj.disk_info;
				$("#t_disk_per").attr("width", fn_resource_bar(disk_info.N_PER_USE));
				// $("#t_disk_usage").text((disk_info.N_NOW_USE==null?"":disk_info.N_NOW_USE) + "/" + (disk_info.N_FULL_SIZE==null?"":disk_info.N_FULL_SIZE) + "MB");
				$("#t_disk_usage").text(disk_info.N_PER_USE == null ? "" : disk_info.N_PER_USE + "%");

				window.setTimeout("fn_get_server_info()", 8000);
			});
	}
</script>

<form name="frm" method="post">
	<input type="hidden" name="N_MON_ID" value="${param.N_MON_ID}">
	<input type="hidden" name="S_CPU_KEY" value="${svr_info.S_CPU_KEY}">
	<input type="hidden" name="S_MEM_KEY" value="${svr_info.S_MEM_KEY}">
	<input type="hidden" name="S_DISK_KEY" value="${svr_info.S_DISK_KEY}">
</form>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>감시장비별 상세조회</h2><span>Home &gt; 감시장비별 상세조회 &gt; TestServer</span></div></div>
<!-- location // -->
<!-- 내용 -->
<!-- 감시장비별페이지 상단 -->
<div class="avaya_top_contentsBox">
	<div class="atcB_bottom">
		<ul class="atcBt_type1">
			<li class="left_bg">
				<dl>
					<dd><span>장비명</span>${svr_info.S_MON_NAME}&nbsp;&nbsp;-&nbsp;&nbsp;[${svr_info.N_MON_ID}]</dd>
					<dd><span>IP주소</span>${svr_info.S_MON_IP}</dd>
					<dd>
						<span>연결상태</span>
						<c:if test="${svr_info.B_CON_INFO eq '연결'}">
							<strong>${svr_info.B_CON_INFO}</strong>
						</c:if>
						<c:if test="${svr_info.B_CON_INFO eq '연결안됨'}">
							<strong class="dcnect">${svr_info.B_CON_INFO}</strong>
						</c:if>
					</dd>
				</dl>
			</li>
			<li class="right_bg"></li>
		</ul>
		<ul class="atcBt_type2">
			<li class="left_bg">
				<dl class="sbox3">
					<dt>장애</dt>
					<dd class="grap_bg2">
						<span id="t_error_cnt_critical" class="tc1">0</span>
						<span id="t_error_cnt_major" class="tc2">0</span>
						<span id="t_error_cnt_minor" class="tc3">0</span>
						<span class="tc1_grp"></span><span class="tc2_grp"></span><span class="tc3_grp"></span>
					</dd>
					<dd style="padding-top:5px;">
						<span class="tc21-1">Orl</span><span class="tc22-1">Maj</span><span class="tc23-1">Min</span>
					</dd>
				</dl>
			</li>
			<li class="right_bg"></li>
		</ul>
		<ul class="atcBt_type3">
			<li class="left_bg">
				<dl>
					<dd><span>CPU</span>1234</dd>
					<dd><span>DISK</span>1234</dd>
				</dl>
			</li>
			<li class="right_bg"></li>
		</ul>
	</div>

</div>
<!-- 감시장비별페이지 상단 // -->
<div id="tapBox1">
	<!-- tap -->
	<div class="tap_line">
		<ul>
			<li><a href="#" onclick="avaya_tab1()" style="cursor:pointer;" class="onted">장애현황</a></li>
		</ul>
	</div>
	<!-- tap // -->
	<!-- stitle -->
	<div class="avaya_stitle1">
		<div class="st_under"><h4>장애 현황</h4><span>건수 : 1</span></div>
	</div>
	<!-- stitle // -->
	<!-- table_typ2-3 -->
	<div class="table_typ2-3">
		<table summary="" cellpadding="0" cellspacing="0" style="width:100%;">
			<caption></caption>
			<colgroup>
				<col width="17%" />
				<col width="17%" />
				<col width="17%" />
				<col width="17%" />
				<col width="16%" />
				<col width="16%" />
			</colgroup>
			<tr>
				<td class="filed_A">발생시각</td>
				<td class="filed_A">감시종류</td>
				<td class="filed_A">등급</td>
				<td class="filed_A">상태</td>
				<td class="filed_A">내용</td>
				<td class="filed_A">복구</td>
			</tr>
			<tr>
				<td class="filed_B">2015-02-11 21:22:09 </td>
				<td class="filed_B">AM8701</td>
				<td class="filed_B">크리티컬</td>
				<td class="filed_B">복구</td>
				<td class="filed_B">프로세스 종료[nxrouting]</td>
				<td class="filed_B"><a href="http://106.248.228.114:3089/watcher/go_main.error_alarm_history.htm?N_MON_ID=5200&S_ALM_KEY=T150217111634918@a@100.100.100.123@a@824@a@100.100.100.255@a@824@a@UDP&REFRESH=fn_stats_retrieve" target="new"><img src="./images/botton/btn_warnview.gif" alt="상세정보" /></a></td>
			</tr>
			<tr>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
			</tr>
			<tr>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
			</tr>
			<tr>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
			</tr>
			<tr>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
			</tr>
			<tr>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
			</tr>
			<tr>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
			</tr>
			<tr>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
			</tr>
			<tr>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
			</tr>
			<tr>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
			</tr>
		</table>
	</div>
	<!-- table_typ2-3 // -->
	<!--paginate-->
	<div class="tap_pageing3"> <a class="direction prev" href="#"> <span> </span> <span> </span></a> <a class="direction prev" href="#"> <span> </span></a> <span style="line-height:21px;">Page 1 of 2</span> <a class="direction next" href="#"><span> </span> </a> <a class="direction next" href="#"><span> </span> <span> </span> </a> </div>
	<!--//paginate-->
	<!-- stitle -->
	<div class="avaya_stitle1">
		<div class="st_under"><h4>장애 히스토리</h4><span>건수 : 10</span></div>
	</div>
	<!-- stitle // -->
	<!-- table_typ2-3 -->
	<div class="table_typ2-3">
		<table summary="" cellpadding="0" cellspacing="0" style="width:100%;">
			<caption></caption>
			<colgroup>
				<col width="15%" />
				<col width="15%" />
				<col width="15%" />
				<col width="15%" />
				<col width="40%" />
			</colgroup>
			<tr>
				<td class="filed_A">발생시각</td>
				<td class="filed_A">등급</td>
				<td class="filed_A">상태</td>
				<td class="filed_A">처리자</td>
				<td class="filed_A">내용</td>
			</tr>
			<tr>
				<td class="filed_B">2015-02-11 21:21:32</td>
				<td class="filed_B">크리티컬</td>
				<td class="filed_B">발생</td>
				<td class="filed_B">null</td>
				<td class="filed_B">프로세스 종료 [nxrouting]</td>
			</tr>
			<tr>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
			</tr>
			<tr>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
			</tr>
			<tr>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
			</tr>
			<tr>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
			</tr>
			<tr>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
			</tr>
			<tr>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
			</tr>
			<tr>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
			</tr>
			<tr>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
			</tr>
			<tr>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
				<td class="filed_B"></td>
			</tr>
		</table>
	</div>
	<!-- table_typ2-3 // -->
	<!--paginate-->
	<div class="tap_pageing3"> <a class="direction prev" href="#"> <span> </span> <span> </span></a> <a class="direction prev" href="#"> <span> </span></a> <span style="line-height:21px;">Page 1 of 2</span> <a class="direction next" href="#"><span> </span> </a> <a class="direction next" href="#"><span> </span> <span> </span> </a> </div>
	<!--//paginate-->
</div>
</div>
<!-- 내용 // -->