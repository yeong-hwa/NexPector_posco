<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>::: [유안타증권] IPT/IPCC 모니터링 시스템 :::</title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
</head>
<%@ include file="/WEB-INF/views/include/dashboard_include.jsp"%>
<style>
	a {
    	color: #FFF;
	}
	a.ablock {
    	color: #FFF;
    	text-decoration: none;
    	display: block;
	}
	a.disabled {
    	pointer-events: none;
    	cursor: default;
    	display: block;
	}
	.con_legend_box {
		margin-left: 20px;
		font-size: 13px;
	}
	.con_legend {
		font-size: 13px;
	}
	.under_line {
		text-decoration:underline;
		cursor: pointer;
	}
</style>
<body>
	<!--Wrapper-->
	<div id="wrapper">
		<!--Header-->
		<div id="header">
			<div class="logo fl">
				<a href='/watcher/realtime_stats/component/center_total.htm?menu=mnavi01_01'><img src="${img3}/logo.png" alt="유안타증권" /></a>
			</div>
			<div class="title fl">
				<p class="maintit">IPT/IPCC 시스템 현황</p>
				<p class="subtit">IPT/IPCC Monitoring System</p>
			</div>
			<div class="antena fl">
				<img src="${img3}/antena01.gif" alt="작동중" />
			</div>
			<!--탭-->
			<div class="tab fl">
				<a class="on" href="/dashboard/dashboard_system_info.htm">운영현황</a>
				<a href="/dashboard/dashboard_network_info.htm">네트워크 현황</a>
			</div>
	        <div class="date_wrap fr">
	          <span id="dday" class="date">2018.01.01(월)</span>
	          <span id="dtime" class="time">03:28</span>
	          <span id="ampm" class="time_ap">PM</span>
	          <span class="setting">
	        	<a id="intervalSet" href="#"><img src="${img3}/btn_setting.png" alt="설정" /></a>
	          </span>
	        </div>
		</div>
		<!--//Header-->

		<!--Content-->
		<div id="content_op_wrap">
			<!-- 왼쪽 -->
			<div class="leftWrap fl">
				<!-- 운영 현황 -->
				<div class="row_di">
					<div class="stitwrap mgb25">
						<h1 class="stitle fl">
							<!-- <span class="titline_b">시스템</span>현황 -->
							<a href="/watcher/realtime_stats/component/center_total.htm"><span class="">시스템</span>현황</a>
							<span id="total_lamp" class="total_squlamp_gn"></span>
							<span class="con_legend_box">
								<span class="">ㆍ전체: </span><span id="total_mon" class="">0</span>
								<span class="">ㆍ연결: </span><span id="total_con" class="">0</span>
								<span class="">ㆍ장애: </span><span id="total_alm" class="">0</span>
							</span>
						</h1>
						<ul class="legend fr">
							<li><span class="le_squlamp_gn"></span>정상</li>
							<li><span class="le_squlamp_rd"></span>장애</li>
							<li><span class="le_squlamp_og"></span>경고</li>
							<li><span class="le_squlamp_yw"></span>주의</li>
						</ul>
					</div>
					<div class="boxWrap">
						<div class="box1 fl mgr20">
							<a href="/watcher/realtime_stats/component/center_detail.htm?N_GROUP_CODE=10000"><p id="ipcc" class="box1_title normal_line">IPCC</p></a>
							<ul class="box_con">
								<li id="ipcc_cm" class="">
									<a class="type_link" ><span class="type_lamp"></span><div class="boxc_title">교환기</div></a>
								</li>
								<li id="ipcc_cti" class="">
									<a class="type_link"><span class="type_lamp"></span><div class="boxc_title">CTI</div></a>
								</li>
								<li id="ipcc_vm" class="">
									<a class="type_link"><span class="type_lamp"></span><div class="boxc_title">가상서버</div></a>
								</li>
							</ul>
						</div>
						<div class="box1 fl mgr20">
							<a href="/watcher/realtime_stats/component/center_detail.htm?N_GROUP_CODE=15000"><p id="ipt" class="box1_title normal_line">IPT</p></a>
							<ul class="box_con">
								<li id="ipt_cm" class="">
									<a class="type_link"><span class="type_lamp"></span><div class="boxc_title">교환기</div></a>
								</li>
								<li id="ipt_cti" class="">
									<a class="type_link"><span class="type_lamp"></span><div class="boxc_title">CTI</div></a>
								</li>
								<li id="ipt_vm" class="">
									<a class="type_link"><span class="type_lamp"></span><div class="boxc_title">가상서버</div></a>
								</li>
							</ul>
						</div>
						<div class="box1 fl mgr20">
							<a href="/watcher/realtime_stats/component/center_detail.htm?N_GROUP_CODE=15550"><p id="ivr" class="box1_title normal_line">IVR</p></a>
							<ul class="box_con">
								<li id="ivr_ivr" class="">
									<a class="type_link"><span class="type_lamp"></span><div class="boxc_title">IVR</div></a>
								</li>
								<li id="ivr_tts" class="">
									<a class="type_link"><span class="type_lamp"></span><div class="boxc_title">TTS</div></a>
								</li>
							</ul>
						</div>
						<div class="box2 fl mgr20">
							<a href="/watcher/realtime_stats/component/center_detail.htm?N_GROUP_CODE=16000"><p id="rec" class="box2_title normal_line">녹취</p></a>
							<ul class="box_con mgr10">
								<li id="rec_total" class="">
									<a class="type_link"><span class="type_lamp"></span><div class="boxc_title">통합</div></a>
								</li>
								<li id="rec_normal" class="">
									<a class="type_link"><span class="type_lamp"></span><div class="boxc_title">일반</div></a>
								</li>
								<li id="rec_hotline" class="">
									<a class="type_link"><span class="type_lamp"></span><div class="boxc_title">핫라인</div></a>
								</li>
							</ul>
							<ul class="box_con">
								<li id="rec_screen" class="">
									<a class="type_link"><span class="type_lamp"></span><div class="boxc_title">스크린</div></a>
								</li>
								<li id="rec_face" class="">
									<a class="type_link"><span class="type_lamp"></span><div class="boxc_title">대면</div></a>
								</li>
								<li id="rec_mr" class="">
									<a class="type_link"><span class="type_lamp"></span><div class="boxc_title">착신전환</div></a>
								</li>
							</ul>
						</div>
						<div class="box2 fl mgr20">
							<a href="/watcher/realtime_stats/component/center_detail.htm?N_GROUP_CODE=17000"><p id="sub_service" class="box2_title normal_line">부가서비스</p></a>
							<ul class="box_con mgr10">
								<li id="sub_service_chat" class="">
									<a class="type_link"><span class="type_lamp"></span><div class="boxc_title">채팅</div></a>
								</li>
								<li id="sub_service_stat" class="">
									<a class="type_link"><span class="type_lamp"></span><div class="boxc_title">통합통계</div></a>
								</li>
								<li id="sub_service_var" class="">
									<a class="type_link"><span class="type_lamp"></span><div class="boxc_title">보이는ARS</div></a>
								</li>
								<li id="sub_service_ip" class="">
									<a class="type_link"><span class="type_lamp"></span><div class="boxc_title">InfoPush</div></a>
								</li>
								<li id="sub_service_ap" class="">
									<a class="type_link"><span class="type_lamp"></span><div class="boxc_title">AgentPush</div></a>
								</li>
							</ul>
							<ul class="box_con">
								<li id="sub_service_fax" class="">
									<a class="type_link"><span class="type_lamp"></span><div class="boxc_title">FAX</div></a>
								</li>
								<li id="sub_service_bil" class="">
									<a class="type_link"><span class="type_lamp"></span><div class="boxc_title">과금</div></a>
								</li>
								<li id="sub_service_mon" class="">
									<a class="type_link"><span class="type_lamp"></span><div class="boxc_title">모니터링</div></a>
								</li>
								<li id="sub_service_vm" class="">
									<a class="type_link"><span class="type_lamp"></span><div class="boxc_title">가상서버</div></a>
								</li>
							</ul>
						</div>
						<div class="box1 fl">
							<a href="/watcher/realtime_stats/component/center_detail.htm?N_GROUP_CODE=18000"><p id="network" class="box1_title normal_line">네트워크</p></a>
							<ul class="box_con">
								<li id="network_switch" class="">
									<a class="type_link"><span class="type_lamp"></span><div class="boxc_title">L3 스위치</div></a>
								</li>
							</ul>
						</div>
					</div>
				</div>
				<!-- //운영 현황 -->

				<!-- 서비스 현황 -->
				<div class="row">
					<div class="col_lg_12_left">
						<div class="stitwrap mgb9">
							<h1 class="stitle fl">
								<a href="/watcher/realtime_stats/component/center_call.htm"><span class="">서비</span>스 현황<span class="stits">&nbsp;(현황/동시간대 한달 평균)</span></a>
							</h1>
							<span class="stits2" style="float:right;">(주기 2분)</span>
						</div>
						<div class="service_data">
							<ul>
								<li class="w130">
									<p class="data_sss">IPCC 교환기 통화</p>
									<p id="ipcc_call_current" class="data_s">
										0
									</p>
									<p id="ipcc_call_before" class="data_ss">
										<span class="dash">/&nbsp;</span>0
									</p>
								</li>
								<li class="w120">
									<p class="data_sss">IPT 교환기 통화</p>
									<p id="ipt_call_current" class="data_s">
										0
									</p>
									<p id="ipt_call_before" class="data_ss">
										<span class="dash">/&nbsp;</span>0
									</p>
								</li>
								<li class="w130_2">
									<p class="data_sss">IVR 시나리오</p>
									<p id="ivr_current" class="data_s">
										0
									</p>
									<p id="ivr_before" class="data_ss">
										<span class="dash">/&nbsp;</span>0
									</p>
								</li>
							</ul>
						</div>
					</div>
					<div class="col_lg_12_right">
						<div class="stitwrap mgb9">
							<h1 class="stitle fl">
								<a href="/watcher/realtime_stats/component/center_call.htm"><span class="">서</span>비스 일누적<span class="stits">&nbsp;(금일 누적/동시간대 한달 평균)</span></a></span></a>
							</h1>
							<span class="stits3"; style="float:right;">(주기 1분)</span> 
						</div>
						<div class="service_data">
							<ul>
								<li class="w120">
									<p class="data_sss">채팅 요청</p>
									<p id="chat_accum_current" class="data_s">
										0
									</p>
									<p id="chat_accum_before" class="data_ss">
										<span class="dash">/&nbsp;</span>0
									</p>
								</li>
								
								<li class="w120">
									<p class="data_sss">채팅 상담</p>
									<p id="chat_counsel_current" class="data_s">
										0
									</p>
									<p id="chat_counsel_before" class="data_ss">
										<span class="dash">/&nbsp;</span>0
									</p>
								</li>
								<li class="w120">
									<p class="data_sss">보이는 ARS</p>
									<p id="vars_current" class="data_s">
										0
									</p>
									<p id="vars_before" class="data_ss">
										<span class="dash">/&nbsp;</span>0
									</p>
								</li>
								<li class="w148">
									<p class="data_sss">infoPush 조회</p>
									<p id="info_accum_current" class="data_s">
										0
									</p>
									<p id="info_accum_before" class="data_ss">
										<span class="dash">/&nbsp;</span>0
									</p>
								</li> 
<!-- 								<li class="w148">
									<p class="data_sss">AgentPush 일 누적</p>
									<p id="agent_accum_current" class="data_s">
										0
									</p>
									<p id="agent_accum_before" class="data_ss">
										<span class="dash">/&nbsp;</span>0
									</p>
								</li> -->
								<li class="w168">
									<p class="data_sss">AgentPush 발송</p>
									<p id="agent_send_current" class="data_s">
										0
									</p>
									<p id="agent_send_before" class="data_ss">
										<span class="dash">/&nbsp;</span>0
									</p>
								</li>
								<li class="w168">
									<p class="data_sss">AgentPush 조회</p>
									<p id="agent_search_current" class="data_s">
										0
									</p>
									<p id="agent_search_before" class="data_ss">
										<span class="dash">/&nbsp;</span>0
									</p>
								</li>
							</ul>
						</div>
					</div>
				</div>
				<!-- //서비스 현황 -->

				<div class="row">
					<!-- 녹취 현황 -->
					<div class="col_lg_6 mgr30">
						<div class="stitwrap mgb9">
							<h1 class="stitle fl">
								<a href="/watcher/go_history_stats.rec_variation_history.rec_variation_history.htm?menu=mnavi01_03&subMenu=4800"><span class="">녹</span>취 일누적<span class="stits">&nbsp;(금일 누적/동시간대 한달 평균)</span></a></span></a>
							</h1>
							<span class="stits2" style="float:right;">(주기 1분)</span>
						</div>
						<div class="service_data">
							<ul>
								<li class="w100">
									<p class="data_sss gray">IPCC</p>
									<p id="rec_ipcc_current" class="data_s">
										0
									</p>
									<p id="rec_ipcc_before" class="data_ss">
										<span class="dash">/&nbsp;</span>0
									</p>
								</li>
								<li class="w100">
									<p class="data_sss gray">IPT</p>
									<p id="rec_ipt_current" class="data_s">
										-
									</p>
									<p id="rec_ipt_before" class="data_ss">
										<span class="dash">/&nbsp;</span>-
									</p>
								</li>
								<li class="w100">
									<p class="data_sss gray">대면</p>
									<p id="rec_face_current" class="data_s">
										-
									</p>
									<p id="rec_face_before" class="data_ss">
										<span class="dash">/&nbsp;</span>-
									</p>
								</li>
								<li class="w100">
									<p class="data_sss gray">부분</p>
									<p id="rec_part_current" class="data_s">
										-
									</p>
									<p id="rec_part_before" class="data_ss">
										<span class="dash">/&nbsp;</span>-
									</p>
								</li>
								<li class="w100">
									<p class="data_sss gray">착신전환</p>
									<p id="rec_transfer_current" class="data_s">
										-
									</p>
									<p id="rec_transfer_before" class="data_ss">
										<span class="dash">/&nbsp;</span>-
									</p>
								</li>
								<li class="w100">
									<p class="data_sss gray">핫라인</p>
									<p id="rec_hotline_current" class="data_s">
										-
									</p>
									<p id="rec_hotline_before" class="data_ss">
										<span class="dash">/&nbsp;</span>-
									</p>
								</li>
								<li class="w100">
									<p class="data_sss gray">스크린</p>
									<p id="rec_screen_current" class="data_s">
										-
									</p>
									<p id="rec_screen_before" class="data_ss">
										<span class="dash">/&nbsp;</span>-
									</p>
								</li>								
							</ul>
						</div>
					</div>
					<!-- //녹취 현황 -->
					<!-- 착신전환 채널 -->
					<div class="col_lg_2 mgr29">
						<div class="stitwrap mgb9">
							<h1 class="stitle fl">
								<span class="">착신</span>전환 채널<span class="stits">&nbsp;(현황/MAX)</span></a></span>
							</h1>
						</div>
						<div class="service_data">
							<ul>
								<li class="w65">
									<p class="data_sss1 gray">사용률</p>
									<p id="incomming_channel_rate" class="data_s1">
										0<span style="font-size: 16px">%</span>
									</p>
								</li>
								<li class="w65">
									<p class="data_sss gray">착신전환</p>
									<p id="incomming_channel_current" class="data_s">
										0
									</p>
									<p id="incomming_channel_before" class="data_ss">
										<span class="dash">/&nbsp;</span>0
									</p>
								</li>
							</ul>
						</div>
					</div>
					<!-- //착신전환 채널 -->
					<!-- IP전화기 현황 -->
					<div class="col_lg_4">
						<div class="stitwrap mgb9">
							<h1 class="stitle fl">
								<span class="">IP전</span>화기 현황<span class="stits2">&nbsp;(전체/연결끊김)</span></a></span>
							</h1>
							<span class="stits2" style="float:right;">(주기 5분)</span>
						</div>
						<div class="service_data">
							<ul>
								<li class="w136">
								
								<p class="data_sss gray under_line" id="ipcc_ipphone">IPCC</p>
									<p class="data_s">
										<span id="ipcc_total">0</span>
									</p>
									<p id="ipcc_disconnect" class="data_ss">
										<span class="dash">/&nbsp;</span>0
									</p>
								</li>
								<li class="w136">
									<p class="data_sss gray under_line" id="ipt_ipphone">IPT</p>
									<p class="data_s"> 
										<span id="ipt_total">0</span>
									</p>
									<p id="ipt_disconnect" class="data_ss">
										<span class="dash">/&nbsp;</span>0
									</p>
								</li>
								<li class="w136">
									<p class="data_sss gray under_line" id="ipt_officer">임원</p>
									<p class="data_s">
										<span id="officer_total">0</span>
									</p>
									<p id="officer_disconnect" class="data_ss">
										<span class="dash">/&nbsp;</span>0
									</p>
								</li>
							</ul>
						</div>
					</div>
					<!-- //IP전화기 현황 -->
				</div>

				<div class="row">
					<!-- 콜센터 현황 -->
					<div class="col_lg_6 mgr30">
						<div class="stitwrap mgb9">
							<h1 class="stitle fl">
								<a href="/watcher/realtime_stats/component/center_call.htm"><span class="">콜센</span>터 현황<span class="stits2">&nbsp;(현황/동시간대 한달 평균)</span></a></span></a>
							</h1>
							<span class="stits2" style="float:right;">(주기 1분)</span>
						</div>
						<div class="service_data">
							<ul>
								<li class="w113">
									<p class="data_sss gray">콜센터 대기호</p>
									<p id="call_wait_current" class="data_s">
										0
									</p>
									<p id="call_wait_before" class="data_ss">
										<span class="dash">/&nbsp;</span>0
									</p>
								</li>
								<li class="w113">
									<p class="data_sss gray">콜센터 포기호</p>
									<p id="call_quit_current" class="data_s">
										0
									</p>
									<p id="call_quit_before" class="data_ss">
										<span class="dash">/&nbsp;</span>0
									</p>
								</li>
								<li class="w113">
									<p class="data_sss gray">VOC 불만</p>
									<p id="voc_complaint_current" class="data_s">
										0
									</p>
									<p id="voc_complaint_before" class="data_ss">
										<span class="dash">/&nbsp;</span>0
									</p>
								</li>
								<li class="w113">
									<p class="data_sss gray">VOC 제안</p>
									<p id="voc_propose_current" class="data_s">
										0
									</p>
									<p id="voc_propose_before" class="data_ss">
										<span class="dash">/&nbsp;</span>0
									</p>
								</li>
								<li class="w113">
									<p class="data_sss gray">VOC Q＆A</p>
									<p id="voc_qna_current" class="data_s">
										0
									</p>
									<p id="voc_qna_before" class="data_ss">
										<span class="dash">/&nbsp;</span>0
									</p>
								</li>
							</ul>
						</div>
					</div>
					<!-- //콜센터 현황 -->
					<!-- 테이블 -->
					<div class="tblWrap fl">
						<table class="contbl" cellspacing="0" cellpadding="0" summary="">
							<caption style="display: none">장애유형</caption>
							<colgroup>
								<col width="116px" />
								<col width="136px" />
								<col width="130px" />
								<col width="267px" />
								<col width="" />
							</colgroup>
							<thead>
								<th scope="col">장애유형</th>
								<th scope="col">장애발생 일시</th>
								<th scope="col">장비별</th>
								<th scope="col">장애발생 내용</th>
								<th scope="col">상태</th>
							</thead>
							<tbody></tbody>
						</table>
						<div id="content-7" style="height: 108px;">
							<div class="tblWrap fl">
								<table class="contbl" cellspacing="0" cellpadding="0" summary="">
									<caption style="display: none">장애유형</caption>
									<colgroup>
										<col width="116px" />
										<col width="136px" />
										<col width="130px" />
										<col width="267px" />
										<col width="" />
									</colgroup>
									<thead></thead>
									<tbody id="error_list">
									</tbody>
								</table>
							</div>
						</div>

					</div>
					<!-- //테이블 -->
				</div>
			</div>
			<!-- //왼쪽 -->
			<!-- 오른쪽 -->
			<div class="rightWrap fl">
				<div class="col_lg_1 ">
					<div class="stitwrap mgb21">
						<h1 class="stitle fl">
							<span class="">자원</span> 사용 현황
						</h1>
					</div>
					<div class="graphbox">
						<div class="graph_tit">
							<span class="bullet"></span>CPU 사용률 Top 5
						</div>
						<div id="cpu_chart" >
						</div>
					</div>
					<div class="graphbox mgt30">
						<div class="graph_tit">
							<span class="bullet"></span>Memory 사용률 Top 5
						</div>
						<div id="memory_chart" >
						</div>
					</div>
					<div class="graphbox mgt30">
						<div class="graph_tit">
							<span class="bullet"></span>Disk 사용률 Top 5
						</div>
						<div id="disk_chart" >
						</div>
					</div>
				</div>

			</div>
			<!-- //오른쪽 -->
		</div>
		<!--//Content-->
	</div>
	<!--//Wrapper -->
	  
  <div id="dashboard_error_popup"></div>
  
  <input type="hidden" id="interval_url" name="interval_url" value="/dashboard/dashboard_system_info.htm">
  
  <script>
	var concerto_date;
	var search_date;
	var error_popup;
	
	var pageConfig = { 
			comparativeRate : 2 // 전월대비 비교율
			/* css value*/
			, bsqulamp_rd : "bsqulamp_rd", bsqulamp_og : "bsqulamp_og", bsqulamp_yw : "bsqulamp_yw", bsqulamp_gn : "bsqulamp_gn" // 운영현황 장비 램프
			, disabled : 'disabled'  // a tag disabled
			
	}
	
	var almRatings = new Array();

	$(document).ready( function() {
	    init();
        intervalInit();

	    // 스크롤 색상 변경
		$("#content-7").mCustomScrollbar({
			theme: "light-thick",
			scrollButtons: { enable: false }
		});
	});

	
	function init() {
		// 차트 생성
        createChart("#cpu_chart", null);
        createChart("#memory_chart", null);
        createChart("#disk_chart", null);
		
		// 조회
		fn_search();

		// 현재 날짜, 시간
		currentDateTimer();
	}

	// kendo chart 생성
	function createChart(id, data){
		$(id).kendoChart({
			dataSource: {
				data: data
			},
			// renderAs: "canvas",
			chartArea: {
			    background: "transparent"
			},  
			plotArea: {
		    	background: "transparent"
		   	},
		   	legend: {
				visible: false
			},
			seriesDefaults: {
				type: "bar",
				labels: {
                    visible: true,
                    color: 'white',
                    background: "transparent"
                }
			},
			series: [{
				field : "N_PER_USE",
                colorField: "N_PER_USE_COLOR"
			}],
			valueAxis: {
                max: 103,
                min: 0,
                line: {
					visible: true,
					color: "#5f605b"
				},
				majorGridLines: {
                    visible: true,
                    color: "#5f605b"
                },
                labels: {
                    visible: true,
                    color: 'white',
                    background: "transparent"
                }
			},
			categoryAxis: {
				field: "S_MON_NAME",
				color: "#FFF",
				line: {
					visible: true
					, color: "#FFF"
				},
				majorGridLines: {
                    visible: false
                },
				labels: {
					cursor: 'pointer'
				}
                /* , labels: {
                    font: "NotoS_R, 굴림, Dotum, tahoma, sans-serif"
                    , margin : 0 // { left: -5 }
                	, padding : 0
                } */
 			},
			tooltip: {
				visible: true,
				format: "{0}",
				template: "#= value #%",
				color: 'white'
			},
			seriesClick: function (e) {
				location.href = "/watcher/server_detail/monitoring.htm?menu=mnavi01_02&N_MON_ID=" + e.dataItem.N_MON_ID;
			},
			axisLabelClick: function (e) {
				if (e.dataItem) {
					location.href = "/watcher/server_detail/monitoring.htm?menu=mnavi01_02&N_MON_ID=" + e.dataItem.N_MON_ID;
				}
			}
		}); 
	}
	
	// 조회
	function fn_search(){
		// 이전 reload timeout 제거
		fn_clearReloadIntervalSetting();
		
		// 현재 시간 갱신
		currentDateTimer();
		
		$.ajax({
			url:'<c:url value="/dashboard/system_info.htm"/>',
	        type:"post",
	        data:{S_URL : $('#interval_url').val()},
	        dataType : "json",
	        success: function(RES) {
	        	// console.log(RES);
				setData(RES);

                setIntervalInfo(RES);
	          },
	          error: function(res,error) {
	          	//alert("에러가 발생했습니다."+error);
	          }
		});
	}

	function setData(RES) {
		// 시스템 현황
		setOperationStatus(RES);
		
		// 콜 현황판 
		setCallStatus(RES);
		
		// 에러 현황
		setErrorStatus(RES);
		
		// 자원 사용 현황 차트
		setUsingChartInfo(RES);
    }
	
	// 장애에 해당하는 그룹 박스 라인 색깔 표시
	function setGroupErrorBox(selector, rating) {
		if (rating == 1) {
			$(selector).addClass('error_line');
		} else if (rating == 2) {
			$(selector).addClass('warning_line');
		} else if (rating == 3) {
			$(selector).addClass('caution_line');
		}
	}
	
	// 타입별 장애 표시
	function setBsquLampErrorBox(selector, rating, param) {
		// 알람별 장애램프 표시
		if (rating == 1) {
			$(selector + ' span').first().addClass(pageConfig.bsqulamp_rd);
		} else if (rating == 2) {
			$(selector + ' span').first().addClass(pageConfig.bsqulamp_og);
		} else if (rating == 3) {
			$(selector + ' span').first().addClass(pageConfig.bsqulamp_yw);
		}
		else {
			$(selector + ' span').first().addClass(pageConfig.bsqulamp_gn);
		}
		// $(selector + ' a').removeClass(pageConfig.disabled);
		// $(selector + ' a').attr('href', "javascript:openErrorPopup(" + JSON.stringify(param) + ")" ); // 장애 팝업
	}
	
	// 장애, 경고, 주의 순으로 알람등급 우선 
	function errorBoxAlmRating(key, comparingRating) {
		if (!almRatings[key]) {
			almRatings[key] = 0;
		}
		if (comparingRating == 1) { // 장애
			almRatings[key] = 1;
		} else if (comparingRating == 2) { // 경고
			if (almRatings[key] >= 2) {
				almRatings[key] = 2;
			}
		} else if (comparingRating == 3) { // 주의
			if (almRatings[key] >= 3) {
				almRatings[key] = 3;
			}
		}
	}
	
	function getSystemType(groupCode, serviceCode) {
		var systemTypeInfo = {groupId : "", typeId : "", typeCode : ""}; 
		if (groupCode == 10000) { // IPCC
			systemTypeInfo.groupId = "ipcc";
			if (serviceCode == 'CM') { // CM
				systemTypeInfo.typeId = 'ipcc_cm';
				systemTypeInfo.typeCode = 1000; 
			} else if (serviceCode == 'CTI') { // CTI
				systemTypeInfo.typeId = 'ipcc_cti';
				systemTypeInfo.typeCode = 2000;
			} else if (serviceCode == 'VM') { // VM
				systemTypeInfo.typeId = 'ipcc_vm';
				systemTypeInfo.typeCode = 8500;
			}
		}
		if (groupCode == 15000) { // IPT
			systemTypeInfo.groupId = "ipt";
			if (serviceCode == 'CM') { // CM
				systemTypeInfo.typeId = 'ipt_cm';
				systemTypeInfo.typeCode = 1000; 
			} else if (serviceCode == 'CTI') { // CTI
				systemTypeInfo.typeId ='ipt_cti';
				systemTypeInfo.typeCode = 2000; 
			} else if (serviceCode == 'VM') { // VM
				systemTypeInfo.typeId = 'ipt_vm';
				systemTypeInfo.typeCode = 8500;
			}
		}
		if (groupCode == 15550) { // IVR
			systemTypeInfo.groupId = 'ivr';
			if (serviceCode == 'TTS') { // TTS
				systemTypeInfo.typeId = 'ivr_tts';
			} 
			else if (serviceCode == 'IVR'){ // IVR
				systemTypeInfo.typeId = 'ivr_ivr';
			}
			systemTypeInfo.typeCode = 3000;
		}
		if (groupCode == 16000) { // 녹취
			systemTypeInfo.groupId = 'rec';
			if (serviceCode == 'TR') { // 통합
				systemTypeInfo.typeId = 'rec_total'; 
			} else if (serviceCode == 'SR') { // 스크린
				systemTypeInfo.typeId = 'rec_screen';
			} else if (serviceCode == 'NR') { // 일반
				systemTypeInfo.typeId = 'rec_normal';
			} else if (serviceCode == 'FR') { // 대면
				systemTypeInfo.typeId = 'rec_face';
			} else if (serviceCode == 'HR') { // 핫라인
				systemTypeInfo.typeId = 'rec_hotline';
			} else if (serviceCode == 'MR') { // 착신전환
				systemTypeInfo.typeId = 'rec_mr';
			}
			systemTypeInfo.typeCode = 3500;
		}
		if (groupCode == 17000) { // 부가서비스
			systemTypeInfo.groupId = 'sub_service';
			if (serviceCode == 'CHA') { // 채팅
				systemTypeInfo.typeId = 'sub_service_chat';
				systemTypeInfo.typeCode = 4000;
			} else if (serviceCode == 'FAX') { // 팩스
				systemTypeInfo.typeId = 'sub_service_fax';
				systemTypeInfo.typeCode = 7500;
			} else if (serviceCode == 'STAT') { // 통합통계
				systemTypeInfo.typeId = 'sub_service_stat';
				systemTypeInfo.typeCode = 4500;
			} else if (serviceCode == 'BIL') { // 과금
				systemTypeInfo.typeId = 'sub_service_bil';
				systemTypeInfo.typeCode = 6500;
			} else if (serviceCode == 'VAR') { // 보이는 ARS
				systemTypeInfo.typeId = 'sub_service_var';
				systemTypeInfo.typeCode = 5600;
			} else if (serviceCode == 'MON') { // 모니터링
				systemTypeInfo.typeId = 'sub_service_mon';
				systemTypeInfo.typeCode = 8000;
			} else if (serviceCode == 'IP') { // Info Push
				systemTypeInfo.typeId = 'sub_service_ip';
				systemTypeInfo.typeCode = 5600;
			} else if (serviceCode == 'VM') { // 가상 서버
				systemTypeInfo.typeId = 'sub_service_vm';
				systemTypeInfo.typeCode = 8500;
			} else if (serviceCode == 'AP') { // Agent Push
				systemTypeInfo.typeId = 'sub_service_ap';
				systemTypeInfo.typeCode = 5600;
			}
		}
		if (groupCode == 18000) { // 네트워크 스위치 
			systemTypeInfo.groupId = 'network';
			systemTypeInfo.typeId = 'network_switch';
			systemTypeInfo.typeCode = 9000;
		}
		if (groupCode == 19000) {
			// 개발
		}
		
		return systemTypeInfo;
	} 
	
	// 시스템 현황
	function setOperationStatus(data) {
		
		// 전체 장비, 연결,  알람 개수 세팅
		var totalCntInfo = data.SYSTEM_TOTAL_CNT;
		$('#total_mon').html(totalCntInfo.TOTAL_CNT);
		$('#total_con').html(totalCntInfo.TOTAL_CON_CNT);
		$('#total_alm').html(totalCntInfo.TOTAL_ALM_CNT);
		//total_squlamp_rd total_squlamp_gn
		// 시스템현황 lamp 세팅
		
		$('#total_lamp').removeClass("total_squlamp_rd total_squlamp_gn");
		if (totalCntInfo.TOTAL_ALM_CNT > 0) {
			$('#total_lamp').addClass("total_squlamp_rd");
		}
		else {
			$('#total_lamp').addClass("total_squlamp_gn");
		}
		// 시스템현황 장비 개수 및 링크 추가
		data.SYSTEM_MON_CNT.push({N_GROUP_CODE: 17000, S_SERVICE_CODE: 'MON', ALL_MON_CNT : 1}); // 부가서비스 모니터링은 1개
		data.SYSTEM_MON_CNT.push({N_GROUP_CODE: 17000, S_SERVICE_CODE: 'VM', ALL_MON_CNT : 1}); // 부가서비스 가상서버는 1개
		for (var i = 0; i < data.SYSTEM_MON_CNT.length; i ++ ) {
			var typeMonCntInfo = data.SYSTEM_MON_CNT[i];
			var systemTypeInfo = getSystemType(typeMonCntInfo.N_GROUP_CODE, typeMonCntInfo.S_SERVICE_CODE);
			var typeId = systemTypeInfo.typeId;
			var typeCode = systemTypeInfo.typeCode;
			
			// 기존정보 초기화
			$('#' + typeId + '> a > div > span').eq(0).remove();
			// <li id="ipcc_cm" class="">
			// 	<a class="type_link" ><span class="type_lamp"></span><div class="boxc_title">교환기<span></span></a>	
			// </li>
			
			var html = "";
			html += "<span class='type_cnt_box'>";
			html += 		"(<span>" + typeMonCntInfo.ALL_MON_CNT + "</span>/";
			html += 		"<span id='" + typeId +  "_alm'>" + 0 + "</span>)";
			html += "</span>";
			
			$('#' + typeId + '> a > div').append(html); 
			
			$('#' + typeId + '> a').attr('href', "/watcher/realtime_stats/component/center_detail.htm?N_GROUP_CODE=" + typeMonCntInfo.N_GROUP_CODE + "&N_TYPE_CODE=" + typeCode ); // 서버 디테일 링크
			$('#' + typeId + '> a').addClass('ablock');
		}
		
		// 시스템현황 장비 알람개수 추가
		for (var i = 0; i < data.SYSTEM_ALM_CNT.length; i ++ ) {
			var typeAlmCntInfo = data.SYSTEM_ALM_CNT[i];
			var systemTypeInfo = getSystemType(typeAlmCntInfo.N_GROUP_CODE, typeAlmCntInfo.S_SERVICE_CODE);
			var typeId = systemTypeInfo.typeId;
			$('#' + typeId + "_alm").text(typeAlmCntInfo.CNT);
		}
		
		// 외부 박스 라인 초기화
		$('.normal_line').removeClass('normal_line').addClass('normal_line');
		$('.warning_line').removeClass('warning_line').addClass('normal_line');
		$('.error_line').removeClass('error_line').addClass('normal_line')
		
		// 외부 박스 알람 등급 초기화
		for (var key in almRatings) {
			almRatings[key] = 0;
		}
		
		// 내부박스 초기화
		$('.type_lamp').removeClass('bsqulamp_rd bsqulamp_og bsqulamp_yw bsqulamp_gn').addClass('bsqulamp_gn');
		// 알람창 팝업 disable
		// $('.type_link').addClass(pageConfig.disabled);
		
		// 에러 세팅
		for (var i = 0; i < data.SYSTEM_ERRORLST.length; i++) {
			var error = data.SYSTEM_ERRORLST[i];
			// var param = {GROUP_CODE : error.N_GROUP_CODE, SERVICE_CODE: error.S_SERVICE_CODE};
 			var systemTypeInfo = getSystemType(error.N_GROUP_CODE, error.S_SERVICE_CODE);
			
 			if (systemTypeInfo.groupId && systemTypeInfo.typeId) {  
 	 			var groupId = systemTypeInfo.groupId;
 				var typeId = systemTypeInfo.typeId;

 				errorBoxAlmRating(groupId, error.N_ALM_RATING);
 				errorBoxAlmRating(typeId, error.N_ALM_RATING);
 				// setBsquLampErrorBox('#' + typeId, almRatings[typeId], param);
 				setBsquLampErrorBox('#' + typeId, almRatings[typeId]);
 				setGroupErrorBox('#' + groupId, almRatings[groupId]);
 			} 
 			else { // 개발은 처리하지않음 
 			}

			/*			
			
			 */
			/* if (error.N_GROUP_CODE == 10000) { // IPCC
				
				errorBoxAlmRating('ipcc', error.N_ALM_RATING);
				
				if (error.S_SERVICE_CODE == 'CM') { // CM
					setBsquLampErrorBox('#ipcc_cm', almRatings['ipcc_cm'], param);
				} else if (error.S_SERVICE_CODE == 'CTI') { // CTI
					setBsquLampErrorBox('#ipcc_cti', error.N_ALM_RATING, param);
				} else if (error.S_SERVICE_CODE == 'VM') { // VM
					setBsquLampErrorBox('#ipcc_vm', error.N_ALM_RATING, param);
				}
				
				setGroupErrorBox('#ipcc', almRatings['ipcc']);
			}
			
			if (error.N_GROUP_CODE == 15000) { // IPT
				errorBoxAlmRating('ipt', error.N_ALM_RATING);
			
				if (error.S_SERVICE_CODE == 'CM') { // CM
					setBsquLampErrorBox('#ipt_cm', error.N_ALM_RATING, param);
				} else if (error.S_SERVICE_CODE == 'CTI') { // CTI
					setBsquLampErrorBox('#ipt_cti', error.N_ALM_RATING, param);
				} else if (error.S_SERVICE_CODE == 'VM') { // VM
					setBsquLampErrorBox('#ipt_vm', error.N_ALM_RATING, param);
				}
				setGroupErrorBox('#ipt', almRatings['ipt']);
			}
			
			if (error.N_GROUP_CODE == 15550) { // IVR
				errorBoxAlmRating('ivr', error.N_ALM_RATING);
				
				if (error.S_SERVICE_CODE == 'TTS') { // TTS
					setBsquLampErrorBox('#ivr_tts', error.N_ALM_RATING, param);
				} 
				else { // IVR
					setBsquLampErrorBox('#ivr_ivr', error.N_ALM_RATING, param);
				}
				setGroupErrorBox('#ivr', almRatings['ivr']);
			}
			
			if (error.N_GROUP_CODE == 16000) { // 녹취
				
				errorBoxAlmRating('rec', error.N_ALM_RATING);
				if (error.S_SERVICE_CODE == 'TR') { // 통합
					setBsquLampErrorBox('#rec_total', error.N_ALM_RATING, param);
				} else if (error.S_SERVICE_CODE == 'SR') { // 스크린
					setBsquLampErrorBox('#rec_screen', error.N_ALM_RATING, param);
				} else if (error.S_SERVICE_CODE == 'NR') { // 일반
					setBsquLampErrorBox('#rec_normal', error.N_ALM_RATING, param);
				} else if (error.S_SERVICE_CODE == 'FR') { // 대면
					setBsquLampErrorBox('#rec_face', error.N_ALM_RATING, param);
				} else if (error.S_SERVICE_CODE == 'HR') { // 핫라인
					setBsquLampErrorBox('#rec_hotline', error.N_ALM_RATING, param);
				} else if (error.S_SERVICE_CODE == 'MR') { // 착신전환
					setBsquLampErrorBox('#rec_mr', error.N_ALM_RATING, param);
				}
				setGroupErrorBox('#rec', almRatings['rec']);
				
			}
			if (error.N_GROUP_CODE == 17000) { // 부가서비스
				
				errorBoxAlmRating('subService', error.N_ALM_RATING);
				if (error.S_SERVICE_CODE == 'CHA') { // 채팅
					setBsquLampErrorBox('#sub_service_chat', error.N_ALM_RATING, param);
				} else if (error.S_SERVICE_CODE == 'FAX') { // 팩스
					setBsquLampErrorBox('#sub_service_fax', error.N_ALM_RATING, param);
				} else if (error.S_SERVICE_CODE == 'STAT') { // 통합통계
					setBsquLampErrorBox('#sub_service_stat', error.N_ALM_RATING, param);
				} else if (error.S_SERVICE_CODE == 'BIL') { // 과금
					setBsquLampErrorBox('#sub_service_bil', error.N_ALM_RATING, param);
				} else if (error.S_SERVICE_CODE == 'VAR') { // 보이는 ARS
					setBsquLampErrorBox('#sub_service_var', error.N_ALM_RATING, param);
				} else if (error.S_SERVICE_CODE == 'MON') { // 모니터링
					setBsquLampErrorBox('#sub_service_mon', error.N_ALM_RATING, param);
				} else if (error.S_SERVICE_CODE == 'IP') { // Info Push
					setBsquLampErrorBox('#sub_service_ip', error.N_ALM_RATING, param);
				} else if (error.S_SERVICE_CODE == 'VM') { // 가상 서버
					setBsquLampErrorBox('#sub_service_vm', error.N_ALM_RATING, param);
				} else if (error.S_SERVICE_CODE == 'AP') { // Agent Push
					setBsquLampErrorBox('#sub_service_ap', error.N_ALM_RATING, param);
				}
				setGroupErrorBox('#sub_service', almRatings['subService']);
			}
			
			if (error.N_GROUP_CODE == 18000) { // 네트워크 스위치 
				errorBoxAlmRating('network', error.N_ALM_RATING);
				
				setBsquLampErrorBox('#network_switch', error.N_ALM_RATING, param);
				
				setGroupErrorBox('#network', almRatings['network']);
			} */
		}
		
	}
	
	// 콜 현황 정보 입력
	function setCallStatus(data) {
		var pbxServiceCurrentUse = data.pbxServiceCurrentUse;
		var pbxServiceAvgUse = data.pbxServiceAvgUse;
		
		var dashServiceCurrentUse = data.dashServiceCurrentUse;
		var dashServiceAvgUse = data.dashServiceAvgUse;
		
		var callCurrentUse = data.callCurrentUse;
		var callAvgUse = data.callAvgUse;
		
		var recCurrentUse = data.recCurrentUse;
		var recAvgUse = data.recAvgUse;
		
		var centerConnectUse = data.centerConnect;
		
		// IPCC 교환기 현황
		makeCallStatus('#ipcc_call_current', pbxServiceCurrentUse.IPCC_TRUNK, pbxServiceAvgUse.IPCC_TRUNK, true);
		makeCallStatus('#ipcc_call_before', pbxServiceCurrentUse.IPCC_TRUNK, pbxServiceAvgUse.IPCC_TRUNK, false);
		
		// IVR 시나리오 현황
		makeCallStatus('#ivr_current', pbxServiceCurrentUse.IVR_SESSION, pbxServiceAvgUse.IVR_SESSION, true);
		makeCallStatus('#ivr_before', pbxServiceCurrentUse.IVR_SESSION, pbxServiceAvgUse.IVR_SESSION, false);
	
		// 채팅 누적
		makeCallStatus('#chat_accum_current', dashServiceCurrentUse.CHAT_TOTAL, dashServiceAvgUse.CHAT_TOTAL, true);
		makeCallStatus('#chat_accum_before', dashServiceCurrentUse.CHAT_TOTAL, dashServiceAvgUse.CHAT_TOTAL, false);

 		// 채팅 상담
		makeCallStatus('#chat_counsel_current', dashServiceCurrentUse.CHAT_CONSULT, dashServiceAvgUse.CHAT_CONSULT, true);
		makeCallStatus('#chat_counsel_before', dashServiceCurrentUse.CHAT_CONSULT, dashServiceAvgUse.CHAT_CONSULT, false); 
		
		// 보이는 ARS
		makeCallStatus('#vars_current', dashServiceCurrentUse.VARS_TOTAL, dashServiceAvgUse.VARS_TOTAL, true);
		makeCallStatus('#vars_before', dashServiceCurrentUse.VARS_TOTAL, dashServiceAvgUse.VARS_TOTAL, false);
		
		// Info Push 월 누적
		makeCallStatus('#info_accum_current', dashServiceCurrentUse.IP_INQUIRY_TOTAL, dashServiceAvgUse.IP_INQUIRY_TOTAL, true);
		makeCallStatus('#info_accum_before', dashServiceCurrentUse.IP_INQUIRY_TOTAL, dashServiceAvgUse.IP_INQUIRY_TOTAL, false);
		
		// Agent Push 월 누적
		makeCallStatus('#agent_accum_current', dashServiceCurrentUse.AP_INVOKE_TOTAL + dashServiceCurrentUse.AP_INQUIRY_TOTAL, dashServiceAvgUse.AP_INQUIRY_TOTAL + dashServiceAvgUse.AP_INQUIRY_TOTAL, true);
		makeCallStatus('#agent_accum_before', dashServiceCurrentUse.AP_INVOKE_TOTAL + dashServiceCurrentUse.AP_INQUIRY_TOTAL, dashServiceAvgUse.AP_INQUIRY_TOTAL + dashServiceAvgUse.AP_INQUIRY_TOTAL, false);
		
		// Agent Push 월 발송
		makeCallStatus('#agent_send_current', dashServiceCurrentUse.AP_INVOKE_TOTAL, dashServiceAvgUse.AP_INVOKE_TOTAL, true);
		makeCallStatus('#agent_send_before', dashServiceCurrentUse.AP_INVOKE_TOTAL, dashServiceAvgUse.AP_INVOKE_TOTAL, false);
		
		// Agent Push 월 조회
		makeCallStatus('#agent_search_current', dashServiceCurrentUse.AP_INQUIRY_TOTAL, dashServiceAvgUse.AP_INQUIRY_TOTAL, true);
		makeCallStatus('#agent_search_before', dashServiceCurrentUse.AP_INQUIRY_TOTAL, dashServiceAvgUse.AP_INQUIRY_TOTAL, false);
		
		/* 콜센터 */
		// 콜센터 대기호
		makeCallStatus('#call_wait_current', dashServiceCurrentUse.CALL_IDLE, dashServiceAvgUse.CALL_IDLE, true);
		makeCallStatus('#call_wait_before', dashServiceCurrentUse.CALL_IDLE, dashServiceAvgUse.CALL_IDLE, false);
		
		// 콜센터 포기호
		makeCallStatus('#call_quit_current', dashServiceCurrentUse.CALL_ABANDON, dashServiceAvgUse.CALL_ABANDON, true);
		makeCallStatus('#call_quit_before', dashServiceCurrentUse.CALL_ABANDON, dashServiceAvgUse.CALL_ABANDON, false);
		
		// VOC 불만
		makeCallStatus('#voc_complaint_current', callCurrentUse.COMPLAINT, callAvgUse.COMPLAINT, true);
		makeCallStatus('#voc_complaint_before', callCurrentUse.COMPLAINT, callAvgUse.COMPLAINT, false);
		
		// VOC 제안
		makeCallStatus('#voc_propose_current', callCurrentUse.CUST_OFFER, callAvgUse.CUST_OFFER, true);
		makeCallStatus('#voc_propose_before', callCurrentUse.CUST_OFFER, callAvgUse.CUST_OFFER, false);
		
		// VOC Q&A
		makeCallStatus('#voc_qna_current', callCurrentUse.QNA, callAvgUse.QNA, true);
		makeCallStatus('#voc_qna_before', callCurrentUse.QNA, callAvgUse.QNA, false);

		// IPCC 녹취
		makeCallStatus('#rec_ipcc_current', recCurrentUse.IPCC, recAvgUse.IPCC, true);
		makeCallStatus('#rec_ipcc_before', recCurrentUse.IPCC, recAvgUse.IPCC, false);



		//[[ 착신전환 채널
		var channelRate = recCurrentUse.TRANSFER_PEEK / recCurrentUse.TRANSFER_CHANNEL * 100; // 평균
		channelRate = channelRate.toFixed(1);
		
		$('#incomming_channel_rate').removeClass('red');
		if(recCurrentUse.TRANSFER_PEEK > 70) {
			$('#incomming_channel_rate').addClass('red');
		}
		$('#incomming_channel_rate').html(channelRate + '<span style="font-size: 16px">%</span>'); 
		

	
		makeCallStatus('#incomming_channel_current', recCurrentUse.TRANSFER_PEEK, recCurrentUse.TRANSFER_CHANNEL, true);
		makeCallStatus('#incomming_channel_before', recCurrentUse.TRANSFER_PEEK, recCurrentUse.TRANSFER_CHANNEL, false);
		//]] 착신전환 채널
		
		// TODO
		// IPCC 연결
		makeConnectStatus('#ipcc_total', centerConnectUse.IPCC_TOTAL, centerConnectUse.IPCC_DISCONNECT, true);
		makeConnectStatus('#ipcc_disconnect', centerConnectUse.IPCC_TOTAL, centerConnectUse.IPCC_DISCONNECT, false);

		$('#ipcc_ipphone').addClass('under_line');
		$('#ipcc_ipphone').on('click', function() {
			goDetailMenu({N_MON_ID : 1018}, 'inact_extension');
		});
		// IPT 연결
		makeConnectStatus('#ipt_total', centerConnectUse.IPT_TOTAL, centerConnectUse.IPT_DISCONNECT, true);
		makeConnectStatus('#ipt_disconnect', centerConnectUse.IPT_TOTAL, centerConnectUse.IPT_DISCONNECT, false);
		
		$('#ipt_ipphone').addClass('under_line');
		$('#ipt_ipphone').on('click', function() {
			goDetailMenu({N_MON_ID : 1001}, 'inact_extension');
		});
		// 임원 연결
 		makeConnectStatus('#officer_total', centerConnectUse.OFFICER_TOTAL, centerConnectUse.OFFICER_DISCONNECT, true);
		makeConnectStatus('#officer_disconnect', centerConnectUse.OFFICER_TOTAL, centerConnectUse.OFFICER_DISCONNECT, false);		

		$('#ipt_officer').addClass('under_line');
		$('#ipt_officer').on('click', function() {
			goDetailMenu({N_MON_ID : 1001}, 'inact_extension');
		});
		// IPT 교환기 현황
		makeCallStatus('#ipt_call_current', pbxServiceCurrentUse.IPT_TRUNK, pbxServiceAvgUse.IPT_TRUNK, true);
		makeCallStatus('#ipt_call_before', pbxServiceCurrentUse.IPT_TRUNK, pbxServiceAvgUse.IPT_TRUNK, false);		

		// IPT 녹취
		makeCallStatus('#rec_ipt_current', recCurrentUse.IPT, recAvgUse.IPT, true);
		makeCallStatus('#rec_ipt_before', recCurrentUse.IPT, recAvgUse.IPT, false);

		// 임원 연결
 		makeConnectStatus('#officer_total', centerConnectUse.OFFICER_TOTAL, centerConnectUse.OFFICER_DISCONNECT, true);
		makeConnectStatus('#officer_disconnect', centerConnectUse.OFFICER_TOTAL, centerConnectUse.OFFICER_DISCONNECT, false);		

		// 핫라인 녹취
		makeCallStatus('#rec_hotline_current', recCurrentUse.HOTLINE, recAvgUse.HOTLINE, true);
		makeCallStatus('#rec_hotline_before', recCurrentUse.HOTLINE, recAvgUse.HOTLINE, false);		
		
		// 대면 녹취
		makeCallStatus('#rec_face_current', recCurrentUse.FACE_TO_FACE, recAvgUse.FACE_TO_FACE, true);
		makeCallStatus('#rec_face_before', recCurrentUse.FACE_TO_FACE, recAvgUse.FACE_TO_FACE, false);
		
		// 부분 녹취
		makeCallStatus('#rec_part_current', recCurrentUse.PART, recAvgUse.PART, true);
		makeCallStatus('#rec_part_before', recCurrentUse.PART, recAvgUse.PART, false);
		
		// 착신전환 녹취 
		makeCallStatus('#rec_transfer_current', recCurrentUse.TRANSFER_CALL, recAvgUse.TRANSFER_CALL, true);
		makeCallStatus('#rec_transfer_before', recCurrentUse.TRANSFER_CALL, recAvgUse.TRANSFER_CALL, false);
		
		makeCallStatus('#rec_screen_current', recCurrentUse.SCREEN, recAvgUse.SCREEN, true);
		makeCallStatus('#rec_screen_before', recCurrentUse.SCREEN, recAvgUse.SCREEN, false);		

		/* 추후 해제
		$('#vars_current').html('-');
		$('#vars_before').html('-');
		
		$('#info_accum_current').html('-');
		$('#info_accum_before').html('-');
		
		$('#agent_accum_current').html('-');
		$('#agent_accum_before').html('-');
		
		$('#agent_send_current').html('-');
		$('#agent_send_before').html('-');
		
		$('#agent_search_current').html('-');
		$('#agent_search_before').html('-');
		
		$('#chat_accum_current').html('-');
		$('#chat_accum_before').html('-');
		
		$('#chat_counsel_current').html('-');
		$('#chat_counsel_before').html('-');
	
		$('#rec_ipt_current').html('-');
		
		$('#ipt_call_current').html('-');
		$('#ipt_call_before').html('-');		
		
		$('#officer_total').html('-');
		$('#officer_disconnect').html('-');
		
		$('#ipt_total').html('-');
		$('#ipt_disconnect').html('-');
		


		$('#rec_hotline_before').html('-');
		$('#rec_hotline_current').html('-');
		*/			
/* 		$('#chat_accum_current').html('-');
		$('#chat_accum_before').html('-');	 */	

	}
	
	// 콜 개별 정보 입력
	function makeCallStatus(id, current, before, isCurrent) {
	    // 현재 월이 현재보다 일정비율 이상 크면 빨간 글씨로 표시
	    if(isCurrent) {
			$(id).removeClass('red');
	    	
			if (current > before * pageConfig.comparativeRate && current > 100) {
				// $(id).addClass('red');
		    }
	    }
		
		var str = "";
		
		if(isCurrent) { // 현월
			str = comma(current);
		}
		else { // 전월
			str = dash() + comma(before);
		}
	    $(id).html(str);
	}
	
	// 전화기 연결 정보 입력
	function makeConnectStatus(id, current, before, isCurrent) {
		var str = "";
		
		if(isCurrent) { // 현월
			str = comma(current);
		}
		else { // 전월
			str = dash() + comma(before);
		}
	    $(id).html(str);
	}
	
	// 콤마 <span> 생성
	function comma(num) {
	    var len, point, str; 
	       
	    num = num + ""; 
	    point = num.length % 3 ;
	    len = num.length; 
	   
	    str = num.substring(0, point); 
	    while (point < len) { 
	        if (str != "") str += "<span class='com'>,</span>"; 
	        str += num.substring(point, point + 3); 
	        point += 3; 
	    } 
	     
	    return str;
	}
	
	function dash() {
		return "<span class='dash'>/&nbsp;</span>";
	}
	
	function setErrorStatus(data) {
		
		$('#error_list').empty();
		
		for (var i = 0; i < data.SYSTEM_ERRORLST.length; i++) {
			var errorInfo = data.SYSTEM_ERRORLST[i];
			
			var param = {ALM_KEY : errorInfo.S_ALM_KEY};
			
			
			// tr onclick 익스에서 동작 안함
			var html = "";
			html += "<tr>";
			html += 	"<td><a href='javascript:openErrorPopup(" + JSON.stringify(param) + ")' class='ablock'>" + errorInfo.S_GROUP_NAME + "</a></td>";
			html += 	"<td><a href='javascript:openErrorPopup(" + JSON.stringify(param) + ")' class='ablock'>" + errorInfo.D_UPDATE_TIME + "</a></td>";
			html += 	"<td><a href='javascript:openErrorPopup(" + JSON.stringify(param) + ")' class='ablock'>" + errorInfo.S_MON_NAME + "</a></td>";
			html += 	"<td class='align_left pdl10'><a href='javascript:openErrorPopup(" + JSON.stringify(param) + ")' class='tb_row'>" + errorInfo.S_ALM_MSG + "</a></td>";
			// html += 	"<td class='align_left pdl10'>" + errorInfo.S_ALM_MSG + "</td>";
			
			var almClass = "";
			if(errorInfo.N_ALM_RATING == 1) { // 장애
				almClass = "error_rd";
			} else if(errorInfo.N_ALM_STATUS == 2) { // 경고
				almClass = "error_yw";
			} else if (errorInfo.N_ALM_STATUS == 3) { // 주의
				almClass = "error_og";
			}
			html +=     "<td class='" + almClass + "'><a class='" + almClass + "' href='javascript:openErrorPopup(" + JSON.stringify(param) + ")' style='cursor:pointer;'>" + errorInfo.S_ALM_STATUS + "</a></td>";
			// html += 	"<td class='" + almClass + "'>" + errorInfo.S_ALM_STATUS + "</td>";
			html += "</tr>";
			$('#error_list').append(html);
		}
	}
	
	function setUsingChartInfo(data) {
		/* 사용률 Top (CPU) */
        // setDataChart("#using_cpu_chart", RES.DISK_USING_RATIO);
		$("#cpu_chart").data("kendoChart").setDataSource(data.CPU_USING_RATIO);

        /* 사용률 Top (MEMORY) */
        // setDataChart("#using_memory_chart", RES.MEMORY_USING_RATIO);
		$("#memory_chart").data("kendoChart").setDataSource(data.MEMORY_USING_RATIO);
        
        /* 사용률 Top (DISK) */
        // setDataChart("#using_disk_chart", RES.DISK_USING_RATIO);
		$("#disk_chart").data("kendoChart").setDataSource(data.DISK_USING_RATIO);
	}

	// 페이지 롤링 -->> 시스템 현황 이동
	function fn_pagemove(){
	//	fn_clearIntervalSetting(); // 모든 timeout 제거
	// 	location.replace('/dashboard/dashboard_network_info.htm');
	}

	function currentDateTimer() {
		var date = new Date();
		$("#dday").text(date.format("yyyy.MM.dd (e)"));
		$("#dtime").text(date.format("hh:mm"));
		$("#ampm").text(date.format("A/P"));
	}
	
	function goDetailMenu(parameter, tabStrip) {
		var param = {};
		
		if (parameter) {
			$.extend(param, parameter);
		}

		var url = '/watcher/server_detail/monitoring.htm?menu=mnavi01_02&tabStrip='+tabStrip;
		location.href = url + '&' + $.param(param);
	}
  </script>
</body>

</html>