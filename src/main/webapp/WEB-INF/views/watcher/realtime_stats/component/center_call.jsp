<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<style>
	.table_typv2 td.font_red{text-align:center; padding:7px 5px 2px 5px; border-bottom:1px solid #cacaca; border-right:1px solid #cacaca; color:red; line-height:14px; background:#fcfdfd;}
	.table_typv2 td.font_blue{text-align:center; padding:7px 5px 2px 5px; border-bottom:1px solid #cacaca; border-right:1px solid #cacaca; color:blue; line-height:14px; background:#fcfdfd;}
</style>

<div class="locationBox"><div class="st_under"><h2>사용자 현황</h2><span>Home &gt; 사용자 현황</span></div></div>

<!-- 내용 -->
<div class="table_div">
	<!-- 장비현준황 Map -->
	<div id="apDiv_map" name="compo">
		<div style="height:560px; width:1000px;">
			<div style="float:left; width:530px;">
<!-- 				<div class="stitleBox" style="height: 25px;">
					<div class="st_under">
						<h3 id="map_title">서비스 현황 </h3>
					</div>
				</div> -->
				<div class="stitleBox" style="height:25px; width: 530px;">
					<div class="st_under">
						<h3 id="map_title">서비스 현황(일 누적)</h3>
						<a id="goServiceHistoryBtn" href='/watcher/go_history_stats.service_variation_history.service_variation_history.htm?menu=mnavi01_03&subMenu=4700' 
							class="k-primary"
							style="width : 100px; float:right;">서비스현황 이력</a>
					</div>
					
				</div>
				<div id="use_div" class="table_typv2" style="margin-top: 10px; width:530px;">
					<table>
						<tr>
							<th width="8%">구분</th>
							<th width="17%">서비스명</th>
							<th width="6%">주기(분)</th>
							<th width="10%">사용량(누적)</th>
							<th width="10%">전월 평균</th>
							<th width="10%">증감 추이</th>
						</tr>
						<tr>
							<td rowspan="7">IPCC</td>
							<td>대표번호 인입</td>
							<td>1</td>
							<td id="call_total"></td>
							<td id="call_total_avg"></td>
							<td id="call_total_diff"></td>
						</tr>
						<tr>
							<td>상담 요청</td>
							<td>1</td>
							<td id="in_total"></td>
							<td id="in_total_avg"></td>
							<td id="in_total_diff"></td>
						</tr>
						<tr>
							<td>상담 처리</td>
							<td>1</td>
							<td id="est_total"></td>
							<td id="est_total_avg"></td>
							<td id="est_total_diff"></td>
						</tr>
						<tr>
							<td>상담 포기</td>
							<td>1</td>
							<td id="call_abandon"></td>
							<td id="call_abandon_avg"></td>
							<td id="call_abandon_diff"></td>
						</tr>		
						<tr>
							<td>상담 최대호 대기수</td>
							<td>15</td>
							<td id="max_inqueue"></td>
							<td id="max_inqueue_avg"></td>
							<td id="max_inqueue_diff"></td>
						</tr>	
						<tr>
							<td>상담 응대율</td>
							<td>1</td>
							<td id="ans_rate"></td>
							<td id="ans_rate_avg"></td>
							<td id="ans_rate_diff"></td>
						</tr>
						<tr>
							<td>상담 그룹 호 전환</td>
							<td>15</td>
							<td id="center_trans"></td>
							<td id="center_trans_avg"></td>
							<td id="center_trans_diff"></td>
						</tr>					
						<tr>
							<td rowspan="2">IPT</td>
							<td>지점 대표번호 인입</td>
							<td>15</td>
							<td id="branch_tot_total"></td>
							<td id="branch_tot_avg"></td>
							<td id="branch_tot_diff"></td>
						</tr>
						<tr>
							<td>지점 대표번호 지점연결</td>
							<td>15</td>
							<td id="jijum_trans"></td>
							<td id="jijum_trans_avg"></td>
							<td id="jijum_trans_diff"></td>
						</tr>									
						<tr>
							<td rowspan="6">부가서비스</td>
							<td>채팅 요청</td>
							<td>1</td>
							<td id="chat_total"></td>
							<td id="chat_total_avg"></td>
							<td id="chat_total_diff"></td>
						</tr>
						<tr>
							<td>채팅 상담</td>
							<td>1</td>
							<td id="chat_consult"></td>
							<td id="chat_consult_avg"></td>
							<td id="chat_consult_diff"></td>
						</tr>
						<tr>
							<td>보이는 ARS</td>
							<td>1</td>
							<td id="vars_total"></td>
							<td id="vars_total_avg"></td>
							<td id="vars_total_diff"></td>
						</tr>	
						<tr>
							<td>Info Push 조회</td>
							<td>1</td>
							<td id="ip_inquiry_total"></td>
							<td id="ip_inquiry_total_avg"></td>
							<td id="ip_inquiry_total_diff"></td>
						</tr>
						<tr>
							<td>Agent Push 발송</td>
							<td>1</td>
							<td id="ap_invoke_total"></td>
							<td id="ap_invoke_total_avg"></td>
							<td id="ap_invoke_total_diff"></td>
						</tr>
						<tr>
							<td>Agent Push 조회</td>
							<td>1</td>
							<td id="ap_inquiry_total"></td>
							<td id="ap_inquiry_total_avg"></td>
							<td id="ap_inquiry_total_diff"></td>
						</tr>
					
					</table>
				</div>
			</div>
			<div style="width:450px; height:250px; float:left; margin-left: 15px;">
				<div style="height:200px;">
					<div class="stitleBox" style="height:25px;">
						<div class="st_under">
							<h3 id="map_title">서비스 현황(실시간)</h3>
						</div>
					</div>
			
					<div id="use_div" class="table_typv2" style="margin-top: 10px;">
						<table>
							<tr>
								<th width="5%">구분</th>
								<th width="15%">서비스명</th>
								<th width="5%">주기(분)</th>
								<th width="14%">사용량<br/>(실시간/일피크)</th>
								<th width="8%">전월 평균</th>
								<th width="8%">증감 추이</th>
							</tr>
							<tr>
								<td rowspan="6">IPCC</td>
								<td>고객 대기</td>
								<td>1</td>
								<td id="call_idle"></td>
								<td id="call_idle_avg"></td>
								<td id="call_idle_diff"></td>
							</tr>
							<tr>
								<td>ARS 실시간 처리</td>
								<td>2</td>
								<td id="ivr_session"></td>
								<td id="ivr_session_avg"></td>
								<td id="ivr_session_diff"></td>
							</tr>
							<tr>
								<td>국선 사용량</td>
								<td>2</td>
								<td id="ipcc_trunk"></td>
								<td id="ipcc_trunk_avg"></td>
								<td id="ipcc_trunk_diff"></td>
							</tr>													
							<tr>
								<td>VOC 불만</td>
								<td>1</td>
								<td id="complaint"></td>
								<td id="complaint_avg"></td>
								<td id="complaint_diff"></td>
							</tr>
							<tr>
								<td>VOC 제안</td>
								<td>1</td>
								<td id="cust_offer"></td>
								<td id="cust_offer_avg"></td>
								<td id="cust_offer_diff"></td>
							</tr>
							<tr>
								<td>VOC Q&A</td>
								<td>1</td>
								<td id="qna"></td>
								<td id="qna_avg"></td>
								<td id="qna_diff"></td>
							</tr>
							<tr>
								<td>IPT</td>
								<td>국선 사용량</td>
								<td>2</td>
								<td id="ipt_trunk"></td>
								<td id="ipt_trunk_avg"></td>
								<td id="ipt_trunk_diff"></td>
							</tr>
						</table>
					</div>
				</div>
				<div style="height:200px;">
					<div class="stitleBox" style="height:25px;">
						<div class="st_under">
							<h3 id="map_title">녹취 현황 </h3>
							<a id="goRecHistoryBtn" href='/watcher/go_history_stats.rec_variation_history.rec_variation_history.htm?menu=mnavi01_03&subMenu=4800' 
							class="k-primary"
							style="width : 100px; float:right;">녹취현황 이력</a>
						</div>
					</div>
			
					<div id="use_div" class="table_typv2" style="margin-top: 10px;">
						<table>
							<tr>
								<th width="10%">구분</th>
								<th width="10%">주기(분)</th>
								<th width="10%">사용량</th>
								<th width="10%">전월평균</th>
								<th width="10%">증감추이</th>
							</tr>
							<tr>
								<td>IPCC</td>
								<td>1</td>
								<td id="ipcc_rec_current"></td>
								<td id="ipcc_rec_avg"></td>
								<td id="ipcc_rec_diff"></td>
							</tr>
							<tr>
								<td>IPT</td>
								<td>1</td>
								<td id="ipt_rec_current"></td>
								<td id="ipt_rec_avg"></td>
								<td id="ipt_rec_diff"></td>
							</tr>
							<tr>
								<td>대면</td>
								<td>1</td>
								<td id="face_rec_current"></td>
								<td id="face_rec_avg"></td>
								<td id="face_rec_diff"></td>
							</tr>
							<tr>
								<td>부분</td>
								<td>1</td>
								<td id="part_rec_current"></td>
								<td id="part_rec_avg"></td>
								<td id="part_rec_diff"></td>
							</tr>
							<tr>
								<td>착신전환</td>
								<td>1</td>
								<td id="transfer_rec_current"></td>
								<td id="transfer_rec_avg"></td>
								<td id="transfer_rec_diff"></td>
							</tr>
							<tr>
								<td>핫라인</td>
								<td>1</td>
								<td id="hot_rec_current"></td>
								<td id="hot_rec_avg"></td>
								<td id="hot_rec_diff"></td>
							</tr>
							<tr>
								<td>스크린</td>
								<td>1</td>
								<td id="screen_rec_current"></td>
								<td id="screen_rec_avg"></td>
								<td id="screen_rec_diff"></td>
							</tr>							
						</table>
					</div>
				</div>
			</div>
		</div>
		<!-- 실시간 장애 현황 -->
		<div id="apDiv8" name="compo">
			<div class="stitleBox" style="float: none;">
				<div class="st_under" style="height: 30px;">
					<h3>시스템 장애 현황</h3>
					<span style="right: 300px;">센터 :<cmb:combo qryname="cmb_svr_group" firstdata="전체" seltagname="ERR_STATS_N_GROUP_CODE" etc="style=\"width:80;\"" selvalue="${param.N_GROUP_CODE}"/></span>
					<span style="right: 110px;">장비타입 :<cmb:combo qryname="cmb_svr_type" firstdata="전체" seltagname="ERR_STATS_N_TYPE_CODE" etc="style=\"width:80;\"" selvalue="${param.N_TYPE_CODE}"/></span>
					<button type="button" id="btnMulti" style="margin-right: 15px;">다중복구</button>
				</div>
			</div>
			<div id="real_time_error" class="table_typv1"></div>
		</div>
	</div>
</div>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript">

	var nGroupCode 		= '${N_GROUP_CODE}';
	var realTimeErrorGrid;
	var test;

	$(document).ready(function () {
		initialize();

		$('#all_check').on('click', function() {
			if (this.checked) {
				$('input[name=S_ALM_KEY]').prop('checked', true);
			} else {
				$('input[name=S_ALM_KEY]').prop('checked', false);
			}
		});

		$('#btnMulti').kendoButton();

		$('#btnMulti').on('click', function(event) {
			event.preventDefault();

			var monId;
			var almKeys = [];

			if ( $('input[name=S_ALM_KEY]:checked').length === 0 ) {
				alert("복구대상 장애항목을 선택해주세요.");
				return;
			}

			$('input[name=S_ALM_KEY]:checked').each(function() {
				almKeys.push(this.value);
			});

			realTimeErrorDataItem = realTimeErrorGrid.dataSource.data();
			var tmp_realTimeError = "";
			$("input[name=S_ALM_KEY]").each(function(index) {
				if ($("input[name=S_ALM_KEY]")[index].checked == true) {
					monId = realTimeErrorDataItem[index].N_MON_ID;
					if (tmp_realTimeError != "") {
						tmp_realTimeError += ",";
					}
					tmp_realTimeError += realTimeErrorDataItem[index].N_MON_ID + ";" +
							realTimeErrorDataItem[index].S_ALM_KEY
				}
			});

			fn_alarm_history_popup(tmp_realTimeError, monId, almKeys.join(','));
		});

		$('#real_time_error div .k-grid-content table td').on('click', function() {
			var col = $(this).parent().children().index($(this));
		});
	});

	function initialize() {
		$('#goServiceHistoryBtn').kendoButton();
		$('#goRecHistoryBtn').kendoButton();
		// 실시간 장애현황 장비타입 Select Box Change Event
		$("select[name='ERR_STATS_N_TYPE_CODE'], select[name='ERR_STATS_N_GROUP_CODE']").on('change', function() {
			// 그룹 전체 일 경우 에만 Combo box 로 센터 선택가능하고 센터별로 들어갈 경우는 해당 센터 만 조회
			var groupCode = Number(nGroupCode);
			groupCode = $("select[name='ERR_STATS_N_GROUP_CODE'] option:selected").val() === '' ?
						-1 :
						$("select[name='ERR_STATS_N_GROUP_CODE'] option:selected").val();

			reloadRealTimeDataSource(groupCode, $("select[name='ERR_STATS_N_TYPE_CODE'] option:selected").val());
		});

		printRealTimeErrorGrid();
		
		// TODO 일단 주석처리 차후 주석 제거할것!!!! 2016-07-21
		getUseInfo();
 		interval.push(window.setInterval(getUseInfo, 10000));
		interval.push(window.setInterval(reloadRealTimeDataSource, 10000));
	}

	function setDiffData(id, current, avg) {
		$(id).text(current - avg);
		$(id).removeClass('font_red font_blue');
		if (current > avg) {
			// $(id).addClass('font_red');
		} else if (avg > current) {
			// $(id).addClass('font_blue');
		}
		else {
			
		}
	}
	
	function getUseInfo() {
        $.get(cst.contextPath() + '/watcher/service_stats.htm', {})
        .done(function(sData) {
            var data = JSON.parse(sData);
            
			var pbxServiceCurrentUse = data.pbxServiceCurrentUse;
			var pbxServiceAvgUse = data.pbxServiceAvgMaxUse;
			var pbxServiceCurrentMaxUse = data.pbxServiceCurrentMaxUse;
			var dashServiceCurrentUse = data.dashServiceCurrentUse;
			var dashServiceAvgUse = data.dashServiceAvgUse;
			var callCurrentUse = data.callCurrentUse;
			var callAvgUse = data.callAvgUse;
			var recCurrentUse = data.recCurrentUse;
			var recAvgUse = data.recAvgUse;
			var cmsCurrentUse = data.cmsCurrentUse;
			var cmsAvgUse = data.cmsAvgUse;
			/* 서비스 현황 (일누적) */
			/* <ipcc> */
			// 대표번호 인입
			$('#call_total').text(dashServiceCurrentUse.CALL_TOTAL);
			$('#call_total_avg').text(dashServiceAvgUse.CALL_TOTAL);
			setDiffData('#call_total_diff', dashServiceCurrentUse.CALL_TOTAL, dashServiceAvgUse.CALL_TOTAL);
			
			// 상담요청
			$('#in_total').text(dashServiceCurrentUse.IN_TOTAL);
			$('#in_total_avg').text(dashServiceAvgUse.IN_TOTAL);
			setDiffData('#in_total_diff', dashServiceCurrentUse.IN_TOTAL, dashServiceAvgUse.IN_TOTAL);
			
			// 상담처리
			$('#est_total').text(dashServiceCurrentUse.EST_TOTAL);
			$('#est_total_avg').text(dashServiceAvgUse.EST_TOTAL);
			setDiffData('#est_total_diff', dashServiceCurrentUse.EST_TOTAL, dashServiceAvgUse.EST_TOTAL);
			
			// 상담포기
			$('#call_abandon').text(dashServiceCurrentUse.CALL_ABANDON);
			$('#call_abandon_avg').text(dashServiceAvgUse.CALL_ABANDON);
			setDiffData('#call_abandon_diff', dashServiceCurrentUse.CALL_ABANDON, dashServiceAvgUse.CALL_ABANDON);
			
			// 상담 최대호 대기수
			$('#max_inqueue').text(cmsCurrentUse.MAX_INQUEUE);
			$('#max_inqueue_avg').text(cmsAvgUse.MAX_INQUEUE);
			setDiffData('#max_inqueue_diff', cmsCurrentUse.MAX_INQUEUE, cmsAvgUse.MAX_INQUEUE);
			
			// 상담 응대율
			$('#ans_rate').text(dashServiceCurrentUse.ANS_RATE);
			$('#ans_rate_avg').text(dashServiceAvgUse.ANS_RATE);
			setDiffData('#ans_rate_diff', dashServiceCurrentUse.ANS_RATE, dashServiceAvgUse.ANS_RATE);
			
			// 상담 그룹 호 전환
			$('#center_trans').text(cmsCurrentUse.CENTER_TRANS);
			$('#center_trans_avg').text(cmsAvgUse.CENTER_TRANS);
			setDiffData('#center_trans_diff', cmsCurrentUse.CENTER_TRANS, cmsAvgUse.CENTER_TRANS);
			
			/* </ipcc> */

			/* <ipt> */
			// 지점 총 인입
			$('#branch_tot_total').text(cmsCurrentUse.JIJUM_CALLS);
			$('#branch_tot_avg').text(cmsAvgUse.JIJUM_CALLS);
			setDiffData('#branch_tot_diff', cmsCurrentUse.JIJUM_CALLS, cmsAvgUse.JIJUM_CALLS);
			
			// 지점 총 연결
			$('#jijum_trans').text(cmsCurrentUse.JIJUM_TRANS);
			$('#jijum_trans_avg').text(cmsAvgUse.JIJUM_TRANS);
			setDiffData('#jijum_trans_diff', cmsCurrentUse.JIJUM_TRANS, cmsAvgUse.JIJUM_TRANS);
			
			/* </ipt> */
			
			/* <부가서비스> */
			// 채팅 총 인입
			$('#chat_total').text(dashServiceCurrentUse.CHAT_TOTAL);
			$('#chat_total_avg').text(dashServiceAvgUse.CHAT_TOTAL);
			setDiffData('#chat_total_diff', dashServiceCurrentUse.CHAT_TOTAL, dashServiceAvgUse.CHAT_TOTAL);
			
			// 채팅 상담
			$('#chat_consult').text(dashServiceCurrentUse.CHAT_CONSULT);
			$('#chat_consult_avg').text(dashServiceAvgUse.CHAT_CONSULT);
			setDiffData('#chat_consult_diff', dashServiceCurrentUse.CHAT_CONSULT, dashServiceAvgUse.CHAT_CONSULT);
			
			// 보이는 ARS
			$('#vars_total').text(dashServiceCurrentUse.VARS_TOTAL);
			$('#vars_total_avg').text(dashServiceAvgUse.VARS_TOTAL);
			setDiffData('#vars_total_diff', dashServiceCurrentUse.VARS_TOTAL, dashServiceAvgUse.VARS_TOTAL);
			
			// Info Push
			$('#ip_inquiry_total').text(dashServiceCurrentUse.IP_INQUIRY_TOTAL);
			$('#ip_inquiry_total_avg').text(dashServiceAvgUse.IP_INQUIRY_TOTAL);
			setDiffData('#ip_inquiry_total_diff', dashServiceCurrentUse.IP_INQUIRY_TOTAL, dashServiceAvgUse.IP_INQUIRY_TOTAL);
			
			// Agent Push 발송
			$('#ap_invoke_total').text(dashServiceCurrentUse.AP_INVOKE_TOTAL);
			$('#ap_invoke_total_avg').text(dashServiceAvgUse.AP_INVOKE_TOTAL);
			setDiffData('#ap_invoke_total_diff', dashServiceCurrentUse.AP_INVOKE_TOTAL, dashServiceAvgUse.AP_INVOKE_TOTAL);
			
			// Agent Push 조회
			$('#ap_inquiry_total').text(dashServiceCurrentUse.AP_INQUIRY_TOTAL);
			$('#ap_inquiry_total_avg').text(dashServiceAvgUse.AP_INQUIRY_TOTAL);
			setDiffData('#ap_inquiry_total_diff', dashServiceCurrentUse.AP_INQUIRY_TOTAL, dashServiceAvgUse.AP_INQUIRY_TOTAL);
			/* </부가서비스> */
			/* -- 서비스현황 일누적 */
			
			/* 서비스현황 실시간  */
			// 고객 대기
			$('#call_idle').text(dashServiceCurrentUse.CALL_IDLE);
			$('#call_idle_avg').text(dashServiceAvgUse.CALL_IDLE);
			setDiffData('#call_idle_diff', dashServiceCurrentUse.CALL_IDLE, dashServiceAvgUse.CALL_IDLE);
			
			// ARS 실시간 처리
			$('#ivr_session').text(pbxServiceCurrentUse.IVR_SESSION + "/" + pbxServiceCurrentMaxUse.IVR_SESSION);
			$('#ivr_session_avg').text(pbxServiceAvgUse.IVR_SESSION);
			setDiffData('#ivr_session_diff', pbxServiceCurrentUse.IVR_SESSION, pbxServiceAvgUse.IVR_SESSION);
			
			// 국선 사용량
			$('#ipcc_trunk').text(pbxServiceCurrentUse.IPCC_TRUNK+ "/" + pbxServiceCurrentMaxUse.IPCC_TRUNK);
			$('#ipcc_trunk_avg').text(pbxServiceAvgUse.IPCC_TRUNK);
			setDiffData('#ipcc_trunk_diff', pbxServiceCurrentUse.IPCC_TRUNK, pbxServiceAvgUse.IPCC_TRUNK);

			// VOC 불만
			$('#complaint').text(callCurrentUse.COMPLAINT);
			$('#complaint_avg').text(callAvgUse.COMPLAINT);
			setDiffData('#complaint_diff', callCurrentUse.COMPLAINT, callAvgUse.COMPLAINT);
			
			// VOC 제안
			$('#cust_offer').text(callCurrentUse.CUST_OFFER);
			$('#cust_offer_avg').text(callAvgUse.CUST_OFFER);
			setDiffData('#cust_offer_diff', callCurrentUse.CUST_OFFER, callAvgUse.CUST_OFFER);
			
			// VOC Q&A
			$('#qna').text(callCurrentUse.QNA);
			$('#qna_avg').text(callAvgUse.QNA);
			setDiffData('#qna_diff', callCurrentUse.QNA, callAvgUse.QNA);
			
			// 국선 사용량
			$('#ipt_trunk').text(pbxServiceCurrentUse.IPT_TRUNK+ "/" + pbxServiceCurrentMaxUse.IPT_TRUNK);
			$('#ipt_trunk_avg').text(pbxServiceAvgUse.IPT_TRUNK);
			setDiffData('#ipt_trunk_diff', pbxServiceCurrentUse.IPT_TRUNK, pbxServiceAvgUse.IPT_TRUNK);

			
			/* -- 서비스 현황 실시간 */
			
			/* 녹취현황 */
			// IPCC 녹취
			$('#ipcc_rec_current').text(recCurrentUse.IPCC);
			$('#ipcc_rec_avg').text(recAvgUse.IPCC);
			setDiffData('#ipcc_rec_diff', recCurrentUse.IPCC, recAvgUse.IPCC);
			/* -- 녹취현황 */

			// IPCC 녹취
			$('#ipt_rec_current').text(recCurrentUse.IPT);
			$('#ipt_rec_avg').text(recAvgUse.IPT);
			setDiffData('#ipt_rec_diff', recCurrentUse.IPT, recAvgUse.IPT);
			
			
			$('#hot_rec_current').text(recCurrentUse.HOTLINE);
			$('#hot_rec_avg').text(recAvgUse.HOTLINE);
			setDiffData('#hot_rec_diff', recCurrentUse.HOTLINE, recAvgUse.HOTLINE);		
			
			$('#face_rec_current').text(recCurrentUse.FACE_TO_FACE);
			$('#face_rec_avg').text(recAvgUse.FACE_TO_FACE);
			setDiffData('#face_rec_diff', recCurrentUse.FACE_TO_FACE, recAvgUse.FACE_TO_FACE);		
			
			$('#part_rec_current').text(recCurrentUse.PART);
			$('#part_rec_avg').text(recAvgUse.PART);
			setDiffData('#part_rec_diff', recCurrentUse.PART, recAvgUse.PART);		
			
			$('#transfer_rec_current').text(recCurrentUse.TRANSFER_CALL);
			$('#transfer_rec_avg').text(recAvgUse.TRANSFER_CALL);
			setDiffData('#transfer_rec_diff', recCurrentUse.TRANSFER_CALL, recAvgUse.TRANSFER_CALL);	
			
			$('#screen_rec_current').text(recCurrentUse.SCREEN);
			$('#screen_rec_avg').text(recAvgUse.SCREEN);
			setDiffData('#screen_rec_diff', recCurrentUse.SCREEN, recAvgUse.SCREEN);				
			/// 주석
			// 채팅 총 인입
/* 			$('#chat_total').text('-');
			$('#chat_total_avg').text('-');
			$('#chat_total_diff').text('-'); */
			
			//최대 동접 회선수(IPT 교환기)
/* 			$('#ipt_trunk').text('-');
			$('#ipt_trunk_avg').text('-');
			$('#ipt_trunk_diff').text('-');

			// IPT 녹취
			$('#ipt_rec_avg').text('-');
			$('#ipt_rec_current').text('-'); 		
		
			// 핫라인 녹취
			$('#hot_rec_avg').text('-');
			$('#hot_rec_current').text('-');

			// 대면 녹취
			$('#face_rec_avg').text('-');
			$('#face_rec_current').text('-');
			
			// 부분 녹취
			$('#part_rec_avg').text('-');
			$('#part_rec_current').text('-');
			
			// 착신전환 녹취
			$('#transfer_rec_avg').text('-');
			$('#transfer_rec_current').text('-');		
			
			// 스크린 녹취
			$('#screen_rec_avg').text('-');
			$('#screen_rec_current').text('-');				
			*/			
			//////
			// dh kim 20180122
/* 			$('#ars_avg').text("-");
			$('#ars_current').text("-");
			
			$('#info_avg').text("-");
			$('#info_current').text("-");
			
			$('#agent_accum_avg').text("-");
			$('#agent_accum_current').text("-");
			
			// Agent 월 발송
			$('#agent_send_avg').text("-");
			$('#agent_send_current').text("-");
			
			// Agent 월 조회
			$('#agent_search_avg').text("-");
			$('#agent_search_current').text("-");
			
			// 채팅 누적 상담 건수
			$('#chat_accum_avg').text("-");
			$('#chat_accum_current').text("-");
			
			// 채팅 상담 건수
			$('#chat_counsel_avg').text("-");
			$('#chat_counsel_current').text("-");  */
			
        });
	}
	
	// 실시간 장애 현황 그리드
	function printRealTimeErrorGrid() {
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					url 		: cst.contextPath() + "/watcher/lst_realtimeErrorStatsQry2.htm",
					data 		: function(data) {

						// 그룹 전체 일 경우 에만 Combo box 로 센터 선택가능하고 센터별로 들어갈 경우는 해당 센터 만 조회
						var groupCode = Number(nGroupCode);
						groupCode = $("select[name='ERR_STATS_N_GROUP_CODE'] option:selected").val() === '' ?
									-1 :
									$("select[name='ERR_STATS_N_GROUP_CODE'] option:selected").val();


						return {
							'N_GROUP_CODE' 			: groupCode,
							'ERR_STATS_N_TYPE_CODE' : $("select[name='ERR_STATS_N_TYPE_CODE'] option:selected").val()
						};
					}
				}
			},
			schema			: {
				data	: function(data) {
					return $.isArray(data) ? data : []; // data 가 존재하지 않으면 object('{}') 형식으로 와서 script 에러 발생
				}
			}
		});

		realTimeErrorGrid = $("#real_time_error")
				.kendoGrid($.extend({}, kendoGridDefaultOpt, {
					dataSource	: dataSource,
					dataBound	: girdRowdblclick,
					/*
					 dataBound	: function() {
					 // content checkbox 이벤트 등록
					 $('input[name=S_ALM_KEY]').on('change', releaseAllCheckbox);
					 goServerDetailPage("nMonId", "nGroupCode", "error");
					 },
					 change		: function() {
					 goServerDetailPage(this.dataItem(this.select()).N_MON_ID, this.dataItem(this.select()).N_GROUP_CODE, 'error');
					 },
					 */
					columns		: [
						{headerTemplate: '<input type="checkbox" id="all_check" name="ALL_CHECK" value="Y"/>', width:'5%', attributes:{style:'text-align:center;'}, headerAttributes:{style:'text-align:center;'}, sortable : false, template:kendo.template($('#checkboxTemplate').html())},
						//{width:'5%', attributes:{style:'text-align:center;'}, template : '<img src="<c:url value="/images/botton/ico_aus.gif"/>" alt="">'},
						{field:'S_MON_NAME', title:'장비명', width:'15%', attributes:{style:'text-align:center;'}, headerAttributes:{style:'text-align:center;'}, template:'#=templateServerLink(N_MON_ID, S_MON_NAME, N_GROUP_CODE)#'},
						{field:'S_ALM_MSG', title:'장애내용', width:'60%', attributes:{style:'text-align:left;'}, headerAttributes:{style:'text-align:center;'}},
						{field:'S_ALM_RATING_NAME', title:'등급', width:'10%', attributes:{style:'text-align:center;'}, headerAttributes:{style:'text-align:center;'}},
						{field:'D_UPDATE_TIME', title:'날짜', width:'15%', attributes:{style:'text-align:center;'}, headerAttributes:{style:'text-align:center;'}}
					],
					scrollable	: true,
					selectable	: 'row',
					height		: 200,
					pageable	: false
				})).data('kendoGrid');
	}

	//Grid dblclick Event
	function girdRowdblclick(e) {

		gridDataBound(e);

		$('input[name=S_ALM_KEY]').on('change', releaseAllCheckbox);

		$('#real_time_error table tr td').on('dblclick', function() {
			if($(this).parent().children().index($(this)) == 0) return;
			goServerDetailPage("nMonId", "nGroupCode", "error");
		});
	}

	function releaseAllCheckbox() {
		$('input[name=S_ALM_KEY]').length === $('input[name=S_ALM_KEY]:checked').length
				? $('#all_check').prop('checked', true)
				: $('#all_check').prop('checked', false);
	}

	// 그리드 Row Select 시에 해당 장애상세페이지로 이동

	function reloadRealTimeDataSource(groupCode, typeCode) {

		realTimeErrorGrid && realTimeErrorGrid.dataSource.read({
			'N_GROUP_CODE' 			: groupCode,
			'ERR_STATS_N_TYPE_CODE' : typeCode
		});
	}

</script>

<script id="checkboxTemplate" type="text/x-kendo-template">
	<input type="checkbox" name="S_ALM_KEY" value="#= S_ALM_KEY #"/>
</script>
