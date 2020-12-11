<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>

<script type="text/javascript">

	$(document).ready( function() {

		var datepickerOpts = {
			change : function() {
				var date = kendo.toString(this.value(), 'd');
				fn_dateChange(date.replace(/-/g,""));
			}
		};

		createKendoDatepicker('search_date', datepickerOpts); // 검색날짜 Kendo Datepicker 초기화

		$("input[name='stat_type']:radio").change(function () {
			fn_dataTypeChange();
		});

		fn_dateChange($('#search_date').val().replace(/-/g,""));

		getIvrInfo();
		setInterval(getIvrInfo, 10000);
	});

	// daily
	function fn_dateChange(strDate) {

		$("#SVCDAY").val(strDate);

		var lab = "";
		var dataType = parseInt($("#DATATYPE").val());
		if (dataType === 1) {
			lab = "동시 통화";
		} else {
			lab = "전체 통화";
		}

		$("#date_display_area").text("(" + $("#search_date").val() + " " + lab + ")");

		fn_dailyStat();
	}

	function fn_dataTypeChange() {
		/* var dataType = $("input:radio[name='stat_type']:checked").val();
		$("#DATATYPE").val(dataType);

		var lab = "";
		if (dataType == 1) {
			lab = "동시 통화";
		} else {
			lab = "전체 통화";
		}

		$("#date_display_area").text("(" + $("#search_date").val() + " " + lab + ")"); */

		fn_dailyStat();
	}

	function fn_dailyStat() {
		var url 	= cst.contextPath() + '/watcher/go_server_detail.ivr_rec_fax.daily_chart_main.htm',
			param 	= $('#frm').serialize();
		$('#ivr_chart_area').load(url, param);
	}

	function getIvrInfo() {
		$.ajax({
			url:'<c:url value="/watcher/server_detail/ivr_rec_fax/ivr_info.htm"/>',
	        type:"post",
	        data:{N_MON_ID : $('#N_MON_ID').val() },
	        dataType : "json",
	        success: function(RES){

	        if (RES.IVR_CHANNEL_STATUS != null) {
					$.each(RES.IVR_CHANNEL_STATUS, function(key, value) {
						setCountData(value, "IVR_CHANNEL_STATUS", key);
					});
				}

	        },
	        error: function(res,error) {
	            // alert("에러가 발생했습니다."+error);
	        }
		});
	}

	function setCountData(value, key1, key2) {
		var tempValue = value;
		var isZero = true;
		var numChar = "0";
		var tagID = ("#" + key1 + "_" + key2).toLowerCase();

		for (var i = 0; i < tempValue.length; i++) {
			numChar = tempValue.charAt(i);
			if (numChar == "0") {
				if (isZero && (tempValue.length - 1) != i) {
					$(tagID + i).removeClass('t_off').removeClass('t_on').addClass('t_off');
				}
				else {
					$(tagID + i).removeClass('t_off').removeClass('t_on').addClass('t_on');
				}
			}
			else {
				isZero = false;
				$(tagID + i).removeClass('t_off').removeClass('t_on').addClass('t_on');
			}
			$(tagID + i).text(numChar);
		}
	}

	function fn_empty(value) {
		if (value == null || value == "") {
			return "&nbsp;";
		}
		return value;
	}

</script>

<form id="frm" name="frm" method="post">
	<input type="hidden" id="N_MON_ID" name="N_MON_ID" value="${param.N_MON_ID}">
	<input type="hidden" id="SVCDAY" name="SVCDAY" value="">
	<input type="hidden" id="SYSTEMID" name="SYSTEMID" value="${param.N_MON_ID}">
	<input type="hidden" id="SERVICE" name="SERVICE" value="0">
	<input type="hidden" id="DATATYPE" name="DATATYPE" value="1"> <!-- default 1 -->
	<input type="hidden" id="CALLTYPE" name="CALLTYPE" value="0">
</form>

<!-- table_typ2-1 -->
<div class="ivr_Box" style="padding-right: 0px;">
</div>
<!-- ivr_searchBox -->
<div class="ivr_searchBox">
	<span class="image"><label for="search_date"> 검색날짜</label>
		<input type="text" name="search_date" id="search_date" />
	</span>
	<!-- <span class="image"> 통계타입
		<input type="radio" name="stat_type" id="same_stat_type" value="1" checked/><label for="same_stat_type">동시통화</label>
		<input type="radio" name="stat_type" id="all_stat_type" value="0" /><label for="all_stat_type">전체통화</label>
	</span> -->
</div>
<!-- ivr_searchBox // -->
<!-- stitle -->
<div class="avaya_stitle1">
	<div class="st_under">
		<h4>채널 사용 통계 (Peak)</h4>
		<span id="date_display_area" style="font-size: 12px; color: #979797;">(0000-00-00 동시 통화)</span>
	</div>
</div>
<!-- stitle // -->
<div id="ivr_chart_area" style="float: left; width: 100%;">
	<!-- 그래프 영역 -->
</div>
<!-- stitle -->
<div class="avaya_stitle1">
	<div class="st_under"><h4>채널 사용 정보</h4></div>
</div>
<!-- stitle // -->
<div>
	<div class="ivr_num">
		<span class="t1 t_off" id="ivr_channel_status_total0">0</span>
		<span class="t2 t_off" id="ivr_channel_status_total1">1</span>
		<span class="t3 t_on" id="ivr_channel_status_total2">2</span>
		<span class="t4 t_on" id="ivr_channel_status_total3">3</span>
		<span class="text">전체 채널</span>
	</div>
	<div class="ivr_num">
		<span class="t1 t_off" id="ivr_channel_status_wait0">0</span>
		<span class="t2 t_off" id="ivr_channel_status_wait1">1</span>
		<span class="t3 t_on" id="ivr_channel_status_wait2">2</span>
		<span class="t4 t_on" id="ivr_channel_status_wait3">3</span>
		<span class="text">대기</span>
	</div>
	<div class="ivr_num">
		<span class="t1 t_off" id="ivr_channel_status_off0">0</span>
		<span class="t2 t_off" id="ivr_channel_status_off1">1</span>
		<span class="t3 t_on" id="ivr_channel_status_off2">2</span>
		<span class="t4 t_on" id="ivr_channel_status_off3">3</span>
		<span class="text">사용</span>
	</div>
</div>