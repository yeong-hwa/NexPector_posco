<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/include2.jsp" %>

<script type="text/javascript" src="<c:url value="/common/js/jquery-ui-1.10.3.custom/js/jquery-ui-1.10.3.custom.js"/>"></script>
<script type="text/javascript" src="<c:url value="/common/js/jquery-ui-1.10.3.custom/js/jquery.ui.datepicker-ko.js"/>"></script>
<link rel="stylesheet" href="<c:url value="/common/js/jquery-ui-1.10.3.custom/css/ui-lightness/jquery-ui-1.10.3.custom.css"/>"/>
<script type="text/javascript" src="<c:url value="/common/kendo-ui/js/kendo.all.min.js" />"></script>
<script type="text/javascript" src="<c:url value="/common/kendo-ui/js/kendo.culture.ko-KR.min.js" />"></script>

<script type="text/javascript">

	var channelTimer;

	var datepick;

	$(document).ready( function() {

		var date = new Date();
		/*var dateStr = format_yyyy_mm_dd( date.getFullYear(), date.getMonth() + 1, date.getDate() );
		$("#datepicker").val(dateStr);*/

		var datepickerOpts = {
			format: "yyyy-MM-dd",
			value: date,
			change : function() {
				var date = kendo.toString(this.value(), 'yyyyMMdd');
				fn_dateChange(date.replace(/-/g,""));
			}
		};

		createKendoDatepicker('datepicker', datepickerOpts); // 검색날짜 Kendo Datepicker 초기화


		$("input[name='stat_type']:radio").change(function () {
			fn_dataTypeChange();
		});

		var dateStr = $("#datepicker").val();

		fn_dateChange( dateStr.replace(/-/g,"") );

		getChannelInfo();

		channelTimer = setInterval("getChannelInfo()", 10000);
	});

	function format_yyyy_mm_dd(year,month,day) {
		var str = "";

		str += year;
		str += "-";
		str += (month<10)?"0"+month:month;
		str += "-";
		str += (day<10)?"0"+day:day;

		return str;
	}

	function format_yyyymmdd(year,month,day) {
		var str = "";

		str += year;
		str += (month<10)?"0"+month:month;
		str += (day<10)?"0"+day:day;

		return str;
	}

	// daily
	function fn_dateChange(strDate) {

		$("#N_INDEX").val(-1);

		datepick = $("#datepicker").val();
		$("#N_DAY").val(strDate);

		var nDay = $("#N_DAY").val();
		var lab = "";
		var datatype = $("#DATATYPE").val();
		if (datatype == 1) {
			lab = "동시 통화";
		} else {
			lab = "전체 통화";
		}

		$(".peek_stats").text("(" + datepick + " " + lab + ")");

		fn_dailyStat();
	}

	function fn_dataTypeChange() {

		var datatype = $("input:radio[name='stat_type']:checked").val();
		$("#DATATYPE").val(datatype);

		var lab = "";
		if (datatype == 1) {
			lab = "동시 통화";
		} else {
			lab = "전체 통화";
		}

		$("#datepicker").val(datepick);
		$(".peek_stats").text("(" + datepick + " " + lab + ")");

		fn_dailyStat();
	}

	function fn_dailyStat() {
		document.forms["frm"].target = "ifm_daily_chart";
		document.forms["frm"].action = "<c:url value='/watcher/go_server_detail.snmp_m03.daily_chart_main.htm'/>";
		document.forms["frm"].submit();
		getIndexInfo();
	}

	function getChannelInfo() {

		$.ajax({
			url:'<c:url value="/watcher/server_detail/snmp_m03/e1_channel_info.htm"/>',
			type:"post",
			data:{N_MON_ID : $('#N_MON_ID').val() },
			dataType : "json",
			success: function(RES){

				if (RES.E1_CHANNEL_STATUS != null) {
					$.each(RES.E1_CHANNEL_STATUS, function(key, value) {
						setCountData(value, "E1_CHANNEL_STATUS", key);
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
				if (isZero && (tempValue.length -1) != i) {
					$(tagID + i).css("color","#b5b4b4");

				} else {
					$(tagID + i).css("color","#000000");
				}

			} else {
				isZero = false;
				$(tagID + i).css("color","#000000");
			}
			$(tagID + i).text(numChar);

		}
	}

	function fn_empty(value) {
		if(value == null || value == "") {
			return "&nbsp;";
		}
		return value;
	}


	function getIndexInfo() {
		$("#SEL_INDEX option").remove();

		$.ajax({
			url:'<c:url value="/watcher/server_detail/snmp_m03/e1_channel_index.htm"/>',
			type:"post",
			data:{N_MON_ID : $('#N_MON_ID').val(), N_DAY : $('#N_DAY').val() },
			dataType : "json",
			success: function(RES){
				if(RES.E1_INDEX_LST != null){
					var ilist = new Array();
					ilist = RES.E1_INDEX_LST;

					for(i=0; i < ilist.length; i++){
						if (ilist[i].N_INDEX == -1) {
							$('#SEL_INDEX').append("<option value='" + ilist[i].N_INDEX + "'>전체</option>");
						} else {
							$('#SEL_INDEX').append("<option value='" + ilist[i].N_INDEX + "'>" + ilist[i].N_INDEX + "</option>");
						}
					}
					var nIndexVal = $("#N_INDEX").val();

					$("#SEL_INDEX").val(nIndexVal);
				}
			},
			error: function(res,error) {
				// alert("에러가 발생했습니다."+error);
			}
		});
	}

	$(document).ready( function() {
		$("#SEL_INDEX").change(function() {
			$("#N_INDEX").val($(this).val());
			fn_dailyStat();
		});
	});
</script>

<body style="background-color: transparent;">
<form name="frm" method="post">
	<input type="hidden" id="N_MON_ID" name="N_MON_ID" value="${param.N_MON_ID}">
	<input type="hidden" id="N_DAY" name="N_DAY" value="">
	<input type="hidden" id="N_INDEX" name="N_INDEX" value="<c:choose><c:when test="${empty param.N_INDEX}">-1</c:when><c:otherwise>${param.N_INDEX}</c:otherwise></c:choose>">
	<input type="hidden" id="DATATYPE" name="DATATYPE" value="1"> <!-- default 1 -->
	<input type="hidden" id="CALLTYPE" name="CALLTYPE" value="0">
</form>

<!-- SUB TAB 시작 -->
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td background="${img2}/tab_lc.jpg">&nbsp;</td>
		<td bgcolor="#FFFFFF" style="padding:15px 20px 20px 20px">



			<!--그래프영역-->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="100%" height="30" colspan="3" class="b gray_sub"><img src="${img2}/icon_calenda01.png" style="vertical-align:middle; margin-right:5px;">검색날짜
						<input type="text" id="datepicker" value="" class="textbox1" />
						<span style="border:0; width:80px;"></span><img src="${img2}/icon_calenda01.png" style="vertical-align:middle; margin-right:5px;">그룹 <select id="SEL_INDEX" name="SEL_INDEX"></select>
					</td>
				</tr>
				<tr>
					<td height="30" class="b gray_sub"><img src="${img2}/icon_result.jpg" align="absmiddle">채널 사용 통계 (Peak)</td>
					<td height="30" class="b gray_sub">&nbsp;</td>
					<td height="30" style="text-align:right" class="text11 pr15 gray_sub peek_stats">(0000-00-00 동시 통화)</td>
				</tr>
				<tr>
					<td colspan="3" style="width:950px; height:120px; background-color:#ededed;">
						<iframe name="ifm_daily_chart" src="" width="950px" height="120px" frameborder="0" scrolling="no"></iframe>
					</td>
				</tr>
				<tr>
					<td colspan="3" style="height:10px;"></td>
				</tr>
			</table>
			<!--//그래프영역-->
			<!--채널 사용 정보-->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="100%" height="30"class="b gray_sub"><img src="${img2}/icon_result.jpg" align="absmiddle">채널 사용 정보</td>
				</tr>
				<tr>
					<td>
						<div class="boxbg01_s">
							<!--전체채널-->
							<div class="box_num01">
								<div class="box_num01_s">
									<span id="e1_channel_status_total0" style="color:#b5b4b4; margin:0 5px 0 6px; text-align:center;">0</span>
									<span id="e1_channel_status_total1" style="color:#b5b4b4; text-align:center;">0</span>
									<span id="e1_channel_status_total2" style="color:#b5b4b4; margin:0 2px 0 2px; text-align:center;">0</span>
									<span id="e1_channel_status_total3" style="color:#b5b4b4; margin:0 2px 0 2px; text-align:center;">0</span>
								</div>
								<div class="box_num01_title">전체 채널</div>
							</div>
							<!--//전체채널-->
							<!--사용-->
							<div class="box_num01">
								<div class="box_num01_s">
									<span id="e1_channel_status_on0" style="color:#b5b4b4; margin:0 5px 0 6px; text-align:center;">0</span>
									<span id="e1_channel_status_on1" style="color:#b5b4b4; text-align:center;">0</span>
									<span id="e1_channel_status_on2" style="color:#b5b4b4; margin:0 3px 0 3px; text-align:center;">0</span>
									<span id="e1_channel_status_on3" style="color:#b5b4b4; margin:0 2px 0 2px; text-align:center;">0</span>
								</div>
								<div class="box_num01_title">사용</div>
							</div>
							<!--//사용-->
							<!--대기-->
							<div class="box_num01">
								<div class="box_num01_s">
									<span id="e1_channel_status_wait0" style="color:#b5b4b4; margin:0 5px 0 6px; text-align:center;">0</span>
									<span id="e1_channel_status_wait1" style="color:#b5b4b4; text-align:center;">0</span>
									<span id="e1_channel_status_wait2" style="color:#b5b4b4; margin:0 2px 0 2px; text-align:center;">0</span>
									<span id="e1_channel_status_wait3" style="color:#b5b4b4; margin:0 2px 0 2px; text-align:center;">0</span>
								</div>
								<div class="box_num01_title">대기</div>
							</div>
							<!--//대기-->
						</div>
					</td>
				</tr>
				<tr>
					<td height="10"></td>
				</tr>
			</table>
			<!--//채널 사용 정보-->


		</td>
		<td background="${img2}/tab_rc.jpg">&nbsp;</td>
	</tr>
	<tr>
		<td><img src="${img2}/tab_lb.jpg"></td>
		<td height="4" background="${img2}/tab_ceb.jpg"><img src="${img2}/dot.png"></td>
		<td><img src="${img2}/tab_rb.jpg"></td>
	</tr>
</table>
<!-- SUB TAB 끝 -->
</body>