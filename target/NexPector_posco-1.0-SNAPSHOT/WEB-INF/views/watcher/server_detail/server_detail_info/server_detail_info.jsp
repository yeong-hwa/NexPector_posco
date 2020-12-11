<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style type="text/css">
	.k-tabstrip-wrapper {padding-right: 20px}
	.table_typ2-3 {padding-right: 0px}
	.table_typ2-1 {padding-right: 0px}
	.table_typ2-2 {padding-right: 0px}

	.k-link {color: #666; font-family: 'NGB';}
</style>

<script type="text/javascript">

	var pMonId 		= '${N_MON_ID}',
		pCpuKey 	= '${svr_info.S_CPU_KEY}',
		pMemoryKey 	= '${svr_info.S_MEM_KEY}',
		pDiskKey 	= '${svr_info.S_DISK_KEY}',
		pVgName		= '${vg_name}',
		pStyleCode 	= '${style_code}',
		pSnmpManCode = '${snmp_man_code}',
		pTypeCode 	= '${type_code}';

	$(function() {
		Initialize();
	});

	function Initialize() {
		fn_get_server_info(); // 페이지 초기화 할때 한번 실행시키고 밑에 setTimeout 을 8초단위로 실행
		interval.push(window.setInterval(fn_get_server_info, 8000));

		// Tabstrip Setting
		var contentUrls = [];

		$('#tabstrip ul li').each(function() {
			var url = cst.contextPath() + $(this).children('input').val(),
				monIdQryStr = 'N_MON_ID=' + $('#monId').val();

			if (url.indexOf('htm?') > -1) {
				contentUrls.push(url + '&' + monIdQryStr);
			} else {
				contentUrls.push(url + '?' + monIdQryStr);
			}
		});

		var tabStrip = $("#tabstrip").kendoTabStrip({
			activate	: function(e) {
				$(e.contentElement).css({ display : 'inline-block', width : '97.7%' });
			},
			select : function(e) {
				global.clearTimeout(); // setTimeout, setInterval clear
				// Select 시에 Content 를 다시 불러오기 위하여 Content 를 비워준다.
				$(e.contentElement).html("");

				// 탭 변경시 각 페이지에 적용해놓은 Style 이 중복으로 겹치면서 디자인이 깨지는
				// 문제가 발생하여 특정 스타일 삭제처리(특히 kendo listView 관련 스타일)
				$('.removeStyle').remove();
			},
			contentUrls : contentUrls
		}).data('kendoTabStrip');

		// main page 에서 link 타고 왔을시 장애현황 탭으로 가도록 처리
		// 장애현황 탭은 무조건 마지막에 나오기때문에 마지막 탭 클릭하도록 처리
		var index;
		if ('error' === '${param.tabStrip}') {
			index = tabStrip.tabGroup.children("li").length - 1;
			tabStrip.select(index);
		} else if ('act_extension' === '${param.tabStrip}') {
			index = Number($('#tab_' + 9).val());
			tabStrip.select(index);
		} else if ('inact_extension' === '${param.tabStrip}') {
			index = Number($('#tab_'+ 215).val());
			tabStrip.select(index);
		}
	}

	function fn_get_server_info() {
		var param = {
			'N_MON_ID' : pMonId,
			'S_CPU_KEY' : pCpuKey,
			'S_MEM_KEY' : pMemoryKey,
			'S_DISK_KEY' : pDiskKey
		};

		$.post(cst.contextPath() + '/watcher/map_ServerDetailInfoQry.htm', param)
			.done(function(data) {
				var jsonData = JSON.parse(data);
				$('#link_state').removeClass('dcnect');
				if (jsonData.B_CON_INFO === '연결안됨') {
					$('#link_state').addClass('dcnect');
				}
				$('#link_state').text(jsonData.B_CON_INFO);
			});

		$.post(cst.contextPath() + "/watcher/server_detail/p_s_info.htm", param)
			.done(function(data) {
				var obj = data ? data : {};

				var server = '${server}';
				var p_s_info = obj.p_s_info ? obj.p_s_info : {};

				if (server === 'N') {
					var cri_cnt = p_s_info.CRITICAL_ERR_CNT ? p_s_info.CRITICAL_ERR_CNT : 0;
					var maj_cnt = p_s_info.MAJOR_ERR_CNT ? p_s_info.MAJOR_ERR_CNT : 0;
					var min_cnt = p_s_info.MINOR_ERR_CNT ? p_s_info.MINOR_ERR_CNT : 0;

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

					$("#t_error_cnt_critical_h").css("height", cri_cnt + '%');
					$("#t_error_cnt_major_h").css("height", maj_cnt + '%');
					$("#t_error_cnt_minor_h").css("height", min_cnt + '%');
				}
				else {
					var p_cnt = p_s_info.PROCESS_CNT ? p_s_info.PROCESS_CNT : 0;
					var p_err_cnt = p_s_info.PROCESS_ERR_CNT ? p_s_info.PROCESS_ERR_CNT : 0;

					if (p_cnt > p_err_cnt) {
						p_err_cnt = 30 * (p_err_cnt / (p_cnt == 0 ? 1 : p_cnt));
						p_cnt = 30;
					}
					else if (p_cnt < p_err_cnt) {
						p_cnt = 30 * (p_cnt / (p_err_cnt == 0 ? 1 : p_err_cnt));
						p_err_cnt = 30;
					}
					else {
						p_cnt = p_cnt == 0 ? 0 : 30;
						p_err_cnt = p_err_cnt == 0 ? 0 : 30;
					}

					$("#t_process_cnt").text(p_s_info.PROCESS_CNT ? p_s_info.PROCESS_CNT : 0);
					$("#t_process_error_cnt").text(p_s_info.PROCESS_ERR_CNT ? p_s_info.PROCESS_ERR_CNT : 0);

					$("#t_process_cnt_h").css("height", p_cnt + '%');
					$("#t_process_error_cnt_h").css("height", p_err_cnt + '%');

					var s_cnt = p_s_info.SERVICE_CNT ? p_s_info.SERVICE_CNT : 0;
					var s_err_cnt = p_s_info.SERVICE_ERR_CNT ? p_s_info.SERVICE_ERR_CNT : 0;

					if (s_cnt > s_err_cnt) {
						s_err_cnt = 30 * (s_err_cnt / (s_cnt == 0 ? 1 : s_cnt));
						s_cnt = 30;
					}
					else if (s_cnt < s_err_cnt) {
						s_cnt = 30 * (s_cnt / (s_err_cnt == 0 ? 1 : s_err_cnt));
						s_err_cnt = 30;
					}
					else {
						s_cnt = s_cnt == 0 ? 0 : 30;
						s_err_cnt = s_err_cnt == 0 ? 0 : 30;
					}

					$("#t_service_cnt").text(p_s_info.SERVICE_CNT ? p_s_info.SERVICE_CNT : 0);
					$("#t_service_error_cnt").text(p_s_info.SERVICE_ERR_CNT ? p_s_info.SERVICE_ERR_CNT : 0);

					$("#t_service_cnt_h").css("height", s_cnt + '%');
					$("#t_service_error_cnt_h").css("height", s_err_cnt + '%');

					var cri_cnt = p_s_info.CRITICAL_ERR_CNT ? p_s_info.CRITICAL_ERR_CNT : 0;
					var maj_cnt = p_s_info.MAJOR_ERR_CNT ? p_s_info.MAJOR_ERR_CNT : 0;
					var min_cnt = p_s_info.MINOR_ERR_CNT ? p_s_info.MINOR_ERR_CNT : 0;

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

					$("#t_error_cnt_critcal").text(p_s_info.CRITICAL_ERR_CNT ? p_s_info.CRITICAL_ERR_CNT : 0);
					$("#t_error_cnt_major").text(p_s_info.MAJOR_ERR_CNT ? p_s_info.MAJOR_ERR_CNT : 0);
					$("#t_error_cnt_minor").text(p_s_info.MINOR_ERR_CNT ? p_s_info.MINOR_ERR_CNT : 0);

					$("#t_error_cnt_critcal_h").css("height", cri_cnt + '%');
					$("#t_error_cnt_major_h").css("height", maj_cnt + '%');
					$("#t_error_cnt_minor_h").css("height", min_cnt + '%');
				}

				var cpuInfo = obj.cpu_info,
					memoryInfo = obj.mem_info,
					disk_info = obj.disk_info,
					cpuNowUse = cpuInfo ? (cpuInfo.N_NOW_USE ? Math.floor(cpuInfo.N_NOW_USE) + '%' : '0%') : '0%',
					memoryPerUse = memoryInfo ? (memoryInfo.N_PER_USE ? Math.floor(memoryInfo.N_PER_USE) + '%' : '0%') : '0%',
					diskPerUse = disk_info ? (disk_info.N_PER_USE ? Math.floor(disk_info.N_PER_USE) + '%' : '0%') : '0%';

				var cpuTextColor = cpuNowUse === '0%' ? '#585858' : '#222',
					memoryTextColor = memoryPerUse === '0%' ? '#585858' : '#222',
					diskTextColor = diskPerUse === '0%' ? '#585858' : '#222';
				
				$('#cpu_progressBar').css({width: cpuNowUse, color: cpuTextColor}).text(cpuNowUse);
				$('#memory_progressBar').css({width: memoryPerUse, color: memoryTextColor}).text(memoryPerUse);
				$('#disk_progressBar').css({width: diskPerUse, color: diskTextColor}).text(diskPerUse);
			});
	}
</script>

<form name="frm" method="post">
	<input type="hidden" id="monId" name="N_MON_ID" value="${N_MON_ID}">
	<input type="hidden" id="cpuKey" name="S_CPU_KEY" value="${svr_info.S_CPU_KEY}">
	<input type="hidden" id="memoryKey" name="S_MEM_KEY" value="${svr_info.S_MEM_KEY}">
	<input type="hidden" id="diskKey" name="S_DISK_KEY" value="${svr_info.S_DISK_KEY}">
</form>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>감시장비별 상세조회</h2><span>Home &gt; 감시장비별 상세조회 &gt; ${svr_info.S_MON_NAME}</span></div></div>
<!-- location // -->
<!-- 내용 -->

<c:choose>
	<c:when test="${server eq 'N'}">
		<!-- 감시장비별페이지 상단 -->
		<div class="avaya_top_contentsBox">
			<div class="atcB_bottom">
				<ul class="atcBt_type1">
					<li class="left_bg">
						<dl>
							<dd><span>장비명</span>${svr_info.S_MON_NAME}[${svr_info.N_MON_ID}] - ${svr_info.GROUP_NAME}, ${svr_info.TYPE_NAME}</dd>
							<dd>
								<span>IP주소</span>${svr_info.S_MON_IP} - 
								<c:if test="${svr_info.B_CON_INFO eq '연결'}">
									<strong id="link_state">${svr_info.B_CON_INFO}</strong>
								</c:if>
								<c:if test="${svr_info.B_CON_INFO eq '연결안됨'}">
									<strong id="link_state" class="dcnect">${svr_info.B_CON_INFO}</strong>
								</c:if>
							</dd>
							<dd>
								<span>기타정보</span>${svr_info.S_DESC}
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
								<span id="t_error_cnt_critical_h" class="tc1_grp"></span>
								<span id="t_error_cnt_major_h" class="tc2_grp"></span>
								<span id="t_error_cnt_minor_h" class="tc3_grp"></span>
							</dd>
							<dd style="padding-top:5px;">
								<span class="tc21-1">Cri</span><span class="tc22-1">Maj</span><span class="tc23-1">Min</span>
							</dd>
						</dl>
					</li>
					<li class="right_bg"></li>
				</ul>
				<ul class="atcBt_type3_v2">
					<li class="left_bg2">
						<dl class="grp_t1_n1">
							<dt>CPU</dt>
							<dd><strong id="cpu_progressBar"></strong></dd>
						</dl>
						<dl class="grp_t1_n2">
							<dt>MEM</dt>
							<dd><strong id="memory_progressBar"></strong></dd>
						</dl>
					</li>
					<li class="right_bg2"></li>
				</ul>
			</div>

		</div>
		<!-- 감시장비별페이지 상단 // -->
	</c:when>
	<c:otherwise>
		<!-- 감시장비별페이지 상단 -->
		<div class="avaya_top_contentsBox">
			<div class="atcB_top">
				<ul class="atcBt_type1">
					<li class="left_bg">
						<dl>
							<dd><span>장비명</span>${svr_info.S_MON_NAME}[${svr_info.N_MON_ID}] - ${svr_info.GROUP_NAME}, ${svr_info.TYPE_NAME}</dd>
							<dd>
								<span>IP주소</span>${svr_info.S_MON_IP} - 
								<c:if test="${svr_info.B_CON_INFO eq '연결'}">
									<strong id="link_state">${svr_info.B_CON_INFO}</strong>
								</c:if>
								<c:if test="${svr_info.B_CON_INFO eq '연결안됨'}">
									<strong id="link_state" class="dcnect">${svr_info.B_CON_INFO}</strong>
								</c:if>
							</dd>
							<dd>
								<span>기타정보</span>${svr_info.S_DESC}
							</dd>
						</dl>
					</li>
					<li class="right_bg"></li>
				</ul>
				<ul class="atcBt_type2">
					<li class="left_bg">
						<dl class="sbox1">
							<dt>프로세스</dt>
							<dd class="grap_bg1">
								<span class="tc1" id="t_process_cnt">1</span><span class="tc2" id="t_process_error_cnt">0</span>
								<span class="tc1_grp" id="t_process_cnt_h"></span><span class="tc2_grp" id="t_process_error_cnt_h"></span>
							</dd>
							<dd style="padding-top:5px;">
								<span class="tc1-1">등록</span><span class="tc2-1">장애</span>
							</dd>
						</dl>
						<dl class="sbox2">
							<dt>서비스</dt>
							<dd class="grap_bg1">
								<span class="tc1" id="t_service_cnt">0</span><span class="tc2" id="t_service_error_cnt">0</span>
								<span class="tc1_grp" id="t_service_cnt_h"></span><span class="tc2_grp" id="t_service_error_cnt_h"></span>
							</dd>
							<dd style="padding-top:5px;">
								<span class="tc1-1">등록</span><span class="tc2-1">장애</span>
							</dd>
						</dl>
						<dl class="sbox3">
							<dt>장애</dt>
							<dd class="grap_bg2">
								<span class="tc1" id="t_error_cnt_critcal">0</span>
								<span class="tc2" id="t_error_cnt_major">0</span>
								<span class="tc3" id="t_error_cnt_minor">0</span>
								<span class="tc1_grp" id="t_error_cnt_critcal_h"></span><span class="tc2_grp" id="t_error_cnt_major_h"></span><span class="tc3_grp" id="t_error_cnt_minor_h"></span>
							</dd>
							<dd style="padding-top:5px;">
								<span class="tc21-1">Crl</span><span class="tc22-1">Maj</span><span class="tc23-1">Min</span>
							</dd>
						</dl>
					</li>
					<li class="right_bg"></li>
				</ul>
				<ul class="atcBt_type3_v2">
					<li class="left_bg2">
						<dl class="grp_t1_n1">
							<dt>CPU</dt>
							<dd><strong id="cpu_progressBar" style="color:#222;">0%</strong></dd>
						</dl>
						<dl class="grp_t1_n2">
							<dt>MEM</dt>
							<dd><strong id="memory_progressBar" style="color:#222;">0%</strong></dd>
						</dl>
						<dl class="grp_t1_n3">
							<dt>DISK</dt>
							<dd><strong id="disk_progressBar" style="color:#222;">0%</strong></dd>
						</dl>
					</li>
					<li class="right_bg2"></li>
				</ul>
			</div>

		</div>
		<!-- 감시장비별페이지 상단 // -->
	</c:otherwise>
</c:choose>

<div id="tapBox1">
	<!-- tap -->
	<div id="tabstrip">
		<ul>
			<c:forEach var="tab" items="${tabs}" varStatus="status">
				<li <c:if test="${status.index == 0}">class="k-state-active"</c:if>>
					${tab.tabName}
					<input type="hidden" value="${tab.tabUrl}"/>
					<input type="hidden" id="tab_${tab.seqSvrTabMenu}" value="${status.index}"/>
				</li>
			</c:forEach>
		</ul>
	</div>
	<!-- tap // -->
</div>
<!-- 내용 // -->