<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript">

	var pMonId = '${param.N_MON_ID}';

	$(function() {
		Initialize();
	});

	function Initialize() {
		// Calendar 초기화
/* 		$("#process_calendar").kendoCalendar({
			format: 'yyyy-MM-dd',
			change: printChart
		});
		var calendar = $("#process_calendar").data("kendoCalendar");
		calendar.value(new Date());
 */
		// 차트 그리기
		printChart();
	}

	function printChart() {
		// 자원 Chart 영역 그리기기
		$.getJSON('/watcher/lst_ProcessLstQry.htm', { 'N_MON_ID' : pMonId })
				.done(function(data) {
					var length = data.length;
					var $grpArea = $('#process_grp_area');
					$grpArea.empty();

					var processRealTimeDsArr = [];
					var mapKeys = [];
					for (var i = 0; i < length; i++) {
						var obj = data[i];
						var grpRealtimeAreaId 	= 'grp_realtime_div_' + obj.S_MAP_KEY,
							grpDailyAreaId 		= 'grp_daily_div_' + obj.S_MAP_KEY,
							resourceTitle		= '프로세스명 : ' + obj.S_MON_TYPE_NAME;

						$grpArea.append( $('<div/>').css({ 'margin-top' : (i === 0 ? '-30px' : '30px'), float : 'left', width : '100%' })
								.append( $('<div/>').addClass('avaya_stitle1')
										.append( $('<div/>').addClass('st_under')
												.append( $('<h4/>').text(resourceTitle) )
												.append( $('<label/>').addClass('cls_run_chk').attr('id', 'run_' + obj.S_MAP_KEY) )
												 ) ) );

					}

					fn_run_check();
					setInterval(fn_run_check, 5000);
				});
		
	}

	function fn_run_check() {
		var param = "N_MON_ID=" + pMonId + "&N_MON_TYPE=3";
		$.getJSON(cst.contextPath() + '/watcher/lst_RealProcessServiceUsageQry3.htm', param, function (data) {
			$(".cls_run_chk").each(function () {
				var tmp_obj = this;
				$(data).each(function () {
					if (tmp_obj.id === "run_" + this.S_MAP_KEY) {
						if (Number(this.F_STATUS) === 1 || Number(this.F_STATUS) === 2) {
							$(tmp_obj).css('color', 'green').html('&nbsp;&nbsp;-&nbsp;(실행중)');
						}
						else {
							$(tmp_obj).css('color', 'red').html('&nbsp;&nbsp;-&nbsp;(중지됨)');
						}
					}
				});
			});
		});
	}
</script>

<form name="frm" method="post">
	<input type="hidden" name="S_MAP_KEY" value="1">
	<input type="hidden" name="N_MON_ID" value="${param.N_MON_ID}">
	<input type="hidden" name="N_DAY" value="">
</form>

<!-- stitle -->
<div class="avaya_stitle1">
	<div class="st_under"><h4>프로세스 정보</h4><span></span></div>
</div>

<!-- table_typ2-1 -->
<div class="cal_grpBox">

	<div id="process_grp_area" class="grp_b">
		

	</div>
</div>