<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/include.jsp" %>

<script type="text/javascript" src="<c:url value="/common/js/jquery-ui-1.10.3.custom/js/jquery-ui-1.10.3.custom.js"/>"></script>
<script type="text/javascript" src="<c:url value="/common/js/jquery-ui-1.10.3.custom/js/jquery.ui.datepicker-ko.js"/>"></script>
<link rel="stylesheet" href="<c:url value="/common/js/jquery-ui-1.10.3.custom/css/ui-lightness/jquery-ui-1.10.3.custom.css"/>"/>

<script type="text/javascript">

	var faxTimer;

	var datepick;

	var serviceMainType = 2;
	var serviceSubTypes = [0,1,2];
	var serviceSubNames = ["FAX_MGR_SERVICE_STATE","FAX_DOC_SERVICE_STATE","FAX_DEV_SERVICE_STATE"];

	var componentMainType = 2;
	var componentSubTypes = [0,1,2];
	var componentSubNames = ["DB_COMPONENT","CTI_COMPONENT","EX_COMPONENT"];

	$(document).ready( function() {

		$("#datepicker").datepicker({
			onSelect : function (dateText, inst) {
							fn_dateChange(dateText.replace(/-/g,""));
						}
		});

		$("input[name='stat_type']:radio").change(function () {
			fn_dataTypeChange();
		});

		var date = new Date();
		var dateStr = format_yyyy_mm_dd( date.getFullYear(), date.getMonth() + 1, date.getDate() );

		$("#datepicker").val(dateStr);

		fn_dateChange( dateStr.replace(/-/g,"") );

		getFaxInfo();

		faxTimer = setInterval("getFaxInfo()", 10000);
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

		datepick = $("#datepicker").val();
		$("#SVCDAY").val(strDate);

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
		document.frm.target = "ifm_daily_chart";
		document.frm.action = "<c:url value='/watcher/go_server_detail.ivr_rec_fax.daily_chart_main.htm'/>";
		document.frm.submit();
	}

	function getFaxInfo() {

		$.ajax({
			url:'<c:url value="/watcher/server_detail/ivr_rec_fax/fax_info.htm"/>',
	        type:"post",
	        data:{N_MON_ID : $('#N_MON_ID').val(), SERVICE_MAIN_TYPE : serviceMainType, SERVICE_SUB_TYPES : serviceSubTypes, SERVICE_SUB_NAMES : serviceSubNames, COMPONENT_MAIN_TYPE : componentMainType, COMPONENT_SUB_TYPES : componentSubTypes, COMPONENT_SUB_NAMES : componentSubNames },
	        dataType : "json",
	        success: function(RES){

				var inHtml = "";
	        	if (RES.FAX_MGR_SERVICE_STATE != null && RES.FAX_MGR_SERVICE_STATE.SERVICE_STATE != null) {
	        		var faxMgrServiceState = RES.FAX_MGR_SERVICE_STATE.SERVICE_STATE;
	        		if (faxMgrServiceState == 1) {
	        			inHtml += "<li><img src=\"${img2}/btn_service01_on.png\" alt=\"팩스매니저 서비스중\"></li>";

	        		} else {
	        			inHtml += "<li><img src=\"${img2}/btn_service01_off.png\" alt=\"팩스매니저 서비스중지\"></li>";
	        		}
	        	}

	        	if (RES.FAX_DEV_SERVICE_STATE != null && RES.FAX_DEV_SERVICE_STATE.SERVICE_STATE != null) {
	        		var faxDevServiceState = RES.FAX_DEV_SERVICE_STATE.SERVICE_STATE;
	        		if (faxDevServiceState == 1) {
	        			inHtml += "<li><img src=\"${img2}/btn_service02_on.png\" alt=\"팩스마스터 서비스중\"></li>";

	        		} else {
	        			inHtml += "<li><img src=\"${img2}/btn_service02_off.png\" alt=\"팩스마스터 서비스중지\"></li>";
	        		}
	        	}

	        	if (RES.FAX_DOC_SERVICE_STATE != null && RES.FAX_DOC_SERVICE_STATE.SERVICE_STATE != null) {
	        		var faxDocServiceState = RES.FAX_DOC_SERVICE_STATE.SERVICE_STATE;
	        		if (faxDocServiceState == 1) {
	        			inHtml += "<li><img src=\"${img2}/btn_service03_on.png\" alt=\"문서마스터 서비스중\"></li>";

	        		} else {
	        			inHtml += "<li><img src=\"${img2}/btn_service03_off.png\" alt=\"문서마스터 서비스중지\"></li>";
	        		}
	        	}
	        	$("#fax_service").empty().html(inHtml);
	        	inHtml = "";


				if (RES.FAX_CHANNEL_STATUS != null) {
					$.each(RES.FAX_CHANNEL_STATUS, function(key, value) {
						setCountData(value, "FAX_CHANNEL_STATUS", key);
					});
				}


				if (RES.FAX_CHANNEL_TYPE != null) {
					$.each(RES.FAX_CHANNEL_TYPE, function(key, value) {
						setCountData(value, "FAX_CHANNEL_TYPE", key);
					});
				}


				if (RES.QUEUE_STATE != null) {
					$.each(RES.QUEUE_STATE, function(key, value) {
						setCountData(value, "QUEUE_STATE", key);
					});
				}


				if (RES.FAX_DOC_CVT != null) {
					$.each(RES.FAX_DOC_CVT, function(key, value) {
						setCountData(value, "FAX_DOC_CVT", key);
					});
				}


				if (RES.FAX_DOC_FOD != null) {
					$.each(RES.FAX_DOC_FOD, function(key, value) {
						setCountData(value, "FAX_DOC_FOD", key);
					});
				}


				if (RES.DB_COMPONENT != null) {
					$.each(RES.DB_COMPONENT, function(key, value) {
						setCountData(value, "DB_COMPONENT", key);
					});
				}

				if (RES.CTI_COMPONENT != null) {
					$.each(RES.CTI_COMPONENT, function(key, value) {
						setCountData(value, "CTI_COMPONENT", key);
					});
				}

				if (RES.EX_COMPONENT != null) {
					$.each(RES.EX_COMPONENT, function(key, value) {
						setCountData(value, "EX_COMPONENT", key);
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

</script>

<style>
.ui-datepicker th { padding: .7em .3em; text-align: center; font-weight: normal; border: 0;  width: 25 }
.ui-state-default, .ui-widget-content .ui-state-default, .ui-widget-header .ui-state-default { font-weight: bold; font-size:10px; width:15; padding-bottom: .1px; padding-top: .1px; }
.ui-datepicker { width: 190px; padding: .1em .1em 0; display: none; }
</style>

<body style="background-color: transparent;">
<form name="frm" method="post">
    <input type="hidden" id="N_MON_ID" name="N_MON_ID" value="${param.N_MON_ID}">
    <input type="hidden" id="SVCDAY" name="SVCDAY" value="">
    <input type="hidden" id="SYSTEMID" name="SYSTEMID" value="${param.N_MON_ID}">
    <input type="hidden" id="SERVICE" name="SERVICE" value="3">
    <input type="hidden" id="DATATYPE" name="DATATYPE" value="1"> <!-- default 1 -->
    <input type="hidden" id="CALLTYPE" name="CALLTYPE" value="0">
</form>

<!-- SUB TAB 시작 -->
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td background="${img2}/tab_lc.jpg">&nbsp;</td>
    <td bgcolor="#FFFFFF" style="padding:15px 20px 20px 20px">



     <!-- 장비정보 시작 -->
       <table width="950" border="0" cellspacing="0" cellpadding="0">
         <tr>
           <td class="b gray_sub"><img src="${img2}/icon_result.jpg" align="absmiddle" >서비스 상태</td>
         </tr>
         <tr>
           <td>
           <div class="servicebox_fax01">
           	<ul id="fax_service">
           		<li>&nbsp;</li>
           	</ul>
           </div>
           </td>
         </tr>
         <tr>
           <td style="height:20px;"></td>
         </tr>
       </table>
       <!--그래프영역-->
       <table width="100%" border="0" cellspacing="0" cellpadding="0">
         <tr>
           <td width="100%" height="30" colspan="3" class="b gray_sub"><img src="${img2}/icon_calenda01.png" style="vertical-align:middle; margin-right:5px;">검색날짜
            <input type="text" id="datepicker" value="" class="textbox1" /><span style="border:0; width:80px;"></span><img src="${img2}/icon_calenda01.png" style="vertical-align:middle; margin-right:5px;">통계타입<span class="b text11 gray pl13 tbin tbinrg" style="border:0;"><input type="radio" name="stat_type" id="stat_peak" style="border:0;" value="1" checked/>동시통화&nbsp;<input type="radio" name="stat_type" id="stat_total" style="border:0;" value="0" />전체통화</span>
           </td>
         </tr>
         <tr>
           <td height="30" class="b gray_sub"><img src="${img2}/icon_result.jpg" align="absmiddle">FAX 채널</td>
           <td height="30" class="b gray_sub">&nbsp;</td>
           <td height="30" style="text-align:right" class="text11 pr15 gray_sub peek_stats">(0000-00-00 동시 통화)</td>
         </tr>
         <tr>
           <!--
           <td style="width:200px; height:80px; background-color:#ededed;">
             <iframe name="ifm_realtime_chart" src="<c:url value='/watcher/go_server_detail.ivr_rec_fax.realtime_chart_main.htm'/>?N_MON_ID=${param.N_MON_ID}&VIEW_NAME=fax" width="200px" height="80px" frameborder="0" scrolling="no"></iframe>
           </td>
           <td style="width:30px;"></td>
           <td style="width:720px; height:80px; background-color:#ededed;">
             <iframe name="ifm_daily_chart" src="" width="720px" height="80px" frameborder="0" scrolling="no"></iframe>
           </td>
           -->
           <td colspan="3" style="width:950px; height:120px; background-color:#ededed;">
             <iframe name="ifm_daily_chart" src="" width="950px" height="120px" frameborder="0" scrolling="no"></iframe>
           </td>
         </tr>
         <tr>
           <td colspan="3" style="height:10px;"></td>
         </tr>
       </table>
       <!--//그래프영역-->

       <!--넥오팩스 채널 상태-->
       <table width="100%" border="0" cellspacing="0" cellpadding="0">
         <tr>
           <td width="100%" height="30"class="b gray_sub"><img src="${img2}/icon_result.jpg" align="absmiddle">넥오팩스 채널 상태</td>
         </tr>
         <tr>
           <td>
           <div class="boxbg01">
           	<!--전체채널-->
             <div class="box_num01">
             	<div class="box_num01_s"><span id="fax_channel_status_total0" style="width:18px; color:#b5b4b4; margin-left:6px; text-align:center;">0</span><span id="fax_channel_status_total1" style="width:25px; color:#b5b4b4; text-align:center;">0</span><span id="fax_channel_status_total2" style="width:23px; color:#b5b4b4; text-align:center;">0</span><span id="fax_channel_status_total3" style="width:21px; color:#b5b4b4; text-align:center;">0</span></div>
                 <div class="box_num01_title">전체 채널</div>
             </div>
             <!--//전체채널-->
             <!--비사용-->
             <div class="box_num01">
             	<div class="box_num01_s"><span id="fax_channel_status_off0" style="width:18px; color:#b5b4b4; margin-left:6px; text-align:center;">0</span><span id="fax_channel_status_off1" style="width:25px; color:#b5b4b4; text-align:center;">0</span><span id="fax_channel_status_off2" style="width:23px; color:#b5b4b4; text-align:center;">0</span><span id="fax_channel_status_off3" style="width:21px; color:#b5b4b4; text-align:center;">0</span></div>
                 <div class="box_num01_title">비사용</div>
             </div>
             <!--//비사용-->
             <!--대기-->
             <div class="box_num01">
             	<div class="box_num01_s"><span id="fax_channel_status_wait0" style="width:18px; color:#b5b4b4; margin-left:6px; text-align:center;">0</span><span id="fax_channel_status_wait1" style="width:25px; color:#b5b4b4; text-align:center;">0</span><span id="fax_channel_status_wait2" style="width:23px; color:#b5b4b4; text-align:center;">0</span><span id="fax_channel_status_wait3" style="width:21px; color:#b5b4b4; text-align:center;">0</span></div>
                 <div class="box_num01_title">대기</div>
             </div>
             <!--//대기-->
             <!--수신준비-->
             <div class="box_num01">
             	<div class="box_num01_s"><span id="fax_channel_status_get0" style="width:18px; color:#b5b4b4; margin-left:6px; text-align:center;">0</span><span id="fax_channel_status_get1" style="width:25px; color:#b5b4b4; text-align:center;">0</span><span id="fax_channel_status_get2" style="width:23px; color:#b5b4b4; text-align:center;">0</span><span id="fax_channel_status_get3" style="width:21px; color:#b5b4b4; text-align:center;">0</span></div>
                 <div class="box_num01_title">수신준비</div>
             </div>
             <!--//수신준비-->
             <!--수신-->
             <div class="box_num01">
             	<div class="box_num01_s"><span id="fax_channel_status_recv0" style="width:18px; color:#b5b4b4; margin-left:6px; text-align:center;">0</span><span id="fax_channel_status_recv1" style="width:25px; color:#b5b4b4; text-align:center;">0</span><span id="fax_channel_status_recv2" style="width:23px; color:#b5b4b4; text-align:center;">0</span><span id="fax_channel_status_recv3" style="width:21px; color:#b5b4b4; text-align:center;">0</span></div>
                 <div class="box_num01_title">수신</div>
             </div>
             <!--//수신-->
             <!--전화걸기-->
             <div class="box_num01">
             	<div class="box_num01_s"><span id="fax_channel_status_makecall0" style="width:18px; color:#b5b4b4; margin-left:6px; text-align:center;">0</span><span id="fax_channel_status_makecall1" style="width:25px; color:#b5b4b4; text-align:center;">0</span><span id="fax_channel_status_makecall2" style="width:23px; color:#b5b4b4; text-align:center;">0</span><span id="fax_channel_status_makecall3" style="width:21px; color:#b5b4b4; text-align:center;">0</span></div>
                 <div class="box_num01_title">전화걸기</div>
             </div>
             <!--//전화걸기-->
             <!--발송-->
             <div class="box_num01">
             	<div class="box_num01_s"><span id="fax_channel_status_send0" style="width:18px; color:#b5b4b4; margin-left:6px; text-align:center;">0</span><span id="fax_channel_status_send1" style="width:25px; color:#b5b4b4; text-align:center;">0</span><span id="fax_channel_status_send2" style="width:23px; color:#b5b4b4; text-align:center;">0</span><span id="fax_channel_status_send3" style="width:21px; color:#b5b4b4; text-align:center;">0</span></div>
                 <div class="box_num01_title">발송</div>
             </div>
             <!--//발송-->
           </div>
           </td>
         </tr>
         <tr>
           <td height="10"></td>
         </tr>
       </table>
       <!--//넥오팩스 채널 상태-->

       <!--넥오팩스 채널 구성-->
       <table width="100%" border="0" cellspacing="0" cellpadding="0">
         <tr>
           <td width="100%" height="30"class="b gray_sub"><img src="${img2}/icon_result.jpg" align="absmiddle">넥오팩스 채널 구성</td>
         </tr>
         <tr>
           <td>
           <div class="boxbg01">
           	<!--전체채널-->
             <div class="box_num01">
             	<div class="box_num01_s"><span id="fax_channel_type_total0" style="width:18px; color:#b5b4b4; margin-left:6px; text-align:center;">0</span><span id="fax_channel_type_total1" style="width:25px; color:#b5b4b4; text-align:center;">0</span><span id="fax_channel_type_total2" style="width:23px; color:#b5b4b4; text-align:center;">0</span><span id="fax_channel_type_total3" style="width:21px; color:#b5b4b4; text-align:center;">0</span></div>
                <div class="box_num01_title">전체 채널</div>
             </div>
             <!--//전체채널-->
             <!--비사용-->
             <div class="box_num01">
             	<div class="box_num01_s"><span id="fax_channel_type_notuse0" style="width:18px; color:#b5b4b4; margin-left:6px; text-align:center;">0</span><span id="fax_channel_type_notuse1" style="width:25px; color:#b5b4b4; text-align:center;">0</span><span id="fax_channel_type_notuse2" style="width:23px; color:#b5b4b4; text-align:center;">0</span><span id="fax_channel_type_notuse3" style="width:21px; color:#b5b4b4; text-align:center;">0</span></div>
                <div class="box_num01_title">비사용</div>
             </div>
             <!--//비사용-->
             <!--송신-->
             <div class="box_num01">
             	<div class="box_num01_s"><span id="fax_channel_type_send0" style="width:18px; color:#b5b4b4; margin-left:6px; text-align:center;">0</span><span id="fax_channel_type_send1" style="width:25px; color:#b5b4b4; text-align:center;">0</span><span id="fax_channel_type_send2" style="width:23px; color:#b5b4b4; text-align:center;">0</span><span id="fax_channel_type_send3" style="width:21px; color:#b5b4b4; text-align:center;">0</span></div>
                <div class="box_num01_title">송신</div>
             </div>
             <!--//송신-->
             <!--수신-->
             <div class="box_num01">
             	<div class="box_num01_s"><span id="fax_channel_type_recv0" style="width:18px; color:#b5b4b4; margin-left:6px; text-align:center;">0</span><span id="fax_channel_type_recv1" style="width:25px; color:#b5b4b4; text-align:center;">0</span><span id="fax_channel_type_recv2" style="width:23px; color:#b5b4b4; text-align:center;">0</span><span id="fax_channel_type_recv3" style="width:21px; color:#b5b4b4; text-align:center;">0</span></div>
                <div class="box_num01_title">수신</div>
             </div>
             <!--//수신-->
             <!--송/수신-->
             <div class="box_num01">
             	<div class="box_num01_s"><span id="fax_channel_type_both0" style="width:18px; color:#b5b4b4; margin-left:6px; text-align:center;">0</span><span id="fax_channel_type_both1" style="width:25px; color:#b5b4b4; text-align:center;">0</span><span id="fax_channel_type_both2" style="width:23px; color:#b5b4b4; text-align:center;">0</span><span id="fax_channel_type_both3" style="width:21px; color:#b5b4b4; text-align:center;">0</span></div>
                <div class="box_num01_title">송/수신</div>
             </div>
             <!--//송/수신-->
           </div>
           </td>
         </tr>
         <tr>
           <td height="10"></td>
         </tr>
       </table>
       <!--//넥오팩스 채널 구성-->
       <!--네오팩스 큐 상태-->
       <table border="0" cellspacing="0" cellpadding="0" style="width:465px; float:left;">
         <tr>
           <td width="100%" height="30"class="b gray_sub"><img src="${img2}/icon_result.jpg" align="absmiddle">네오팩스 큐 상태</td>
         </tr>
         <tr>
           <td>
           <div class="boxbg01_s">
           	<!--큐 크기-->
             <div class="box_num01">
             	<div class="box_num01_s"><span id="queue_state_total0" style="width:18px; color:#b5b4b4; margin-left:6px; text-align:center;">0</span><span id="queue_state_total1" style="width:25px; color:#b5b4b4; text-align:center;">0</span><span id="queue_state_total2" style="width:23px; color:#b5b4b4; text-align:center;">0</span><span id="queue_state_total3" style="width:21px; color:#b5b4b4; text-align:center;">0</span></div>
                <div class="box_num01_title">큐 크기</div>
             </div>
             <!--//큐 크기-->
             <!--대기-->
             <div class="box_num01">
             	<div class="box_num01_s"><span id="queue_state_item0" style="width:18px; color:#b5b4b4; margin-left:6px; text-align:center;">0</span><span id="queue_state_item1" style="width:25px; color:#b5b4b4; text-align:center;">0</span><span id="queue_state_item2" style="width:23px; color:#b5b4b4; text-align:center;">0</span><span id="queue_state_item3" style="width:21px; color:#b5b4b4; text-align:center;">0</span></div>
                <div class="box_num01_title">대기</div>
             </div>
             <!--//대기-->
             <!--유휴-->
             <div class="box_num01">
             	<div class="box_num01_s"><span id="queue_state_idle0" style="width:18px; color:#b5b4b4; margin-left:6px; text-align:center;">0</span><span id="queue_state_idle1" style="width:25px; color:#b5b4b4; text-align:center;">0</span><span id="queue_state_idle2" style="width:23px; color:#b5b4b4; text-align:center;">0</span><span id="queue_state_idle3" style="width:21px; color:#b5b4b4; text-align:center;">0</span></div>
                <div class="box_num01_title">유휴</div>
             </div>
             <!--//유휴-->
           </div>
           </td>
         </tr>
         <tr>
           <td height="10"></td>
         </tr>
       </table>
       <!--//네오팩스 큐 상태-->
       <!--네오팩스 문서 변환 상태-->
       <table border="0" cellspacing="0" cellpadding="0" style="width:465px; float:left; margin-left:20px;">
         <tr>
           <td width="100%" height="30"class="b gray_sub"><img src="${img2}/icon_result.jpg" align="absmiddle">네오팩스 문서 변환 상태</td>
         </tr>
         <tr>
           <td>
           <div class="boxbg01_s">
           	<!--처리된 건수-->
             <div class="box_num01">
             	<div class="box_num01_s"><span id="fax_doc_cvt_total0" style="width:18px; color:#b5b4b4; margin-left:6px; text-align:center;">0</span><span id="fax_doc_cvt_total1" style="width:25px; color:#b5b4b4; text-align:center;">0</span><span id="fax_doc_cvt_total2" style="width:23px; color:#b5b4b4; text-align:center;">0</span><span id="fax_doc_cvt_total3" style="width:21px; color:#b5b4b4; text-align:center;">0</span></div>
                <div class="box_num01_title">처리된 건수</div>
             </div>
             <!--//처리된 건수-->
             <!--성공 건수-->
             <div class="box_num01">
             	<div class="box_num01_s"><span id="fax_doc_cvt_success0" style="width:18px; color:#b5b4b4; margin-left:6px; text-align:center;">0</span><span id="fax_doc_cvt_success1" style="width:25px; color:#b5b4b4; text-align:center;">0</span><span id="fax_doc_cvt_success2" style="width:23px; color:#b5b4b4; text-align:center;">0</span><span id="fax_doc_cvt_success3" style="width:21px; color:#b5b4b4; text-align:center;">0</span></div>
                <div class="box_num01_title">성공 건수</div>
             </div>
             <!--//성공 건수-->
             <!--실패건수-->
             <div class="box_num01">
             	<div class="box_num01_s"><span id="fax_doc_cvt_fail0" style="width:18px; color:#b5b4b4; margin-left:6px; text-align:center;">0</span><span id="fax_doc_cvt_fail1" style="width:25px; color:#b5b4b4; text-align:center;">0</span><span id="fax_doc_cvt_fail2" style="width:23px; color:#b5b4b4; text-align:center;">0</span><span id="fax_doc_cvt_fail3" style="width:21px; color:#b5b4b4; text-align:center;">0</span></div>
                <div class="box_num01_title">실패 건수</div>
             </div>
             <!--//실패건수-->
             <!--처리중-->
             <div class="box_num01">
             	<div class="box_num01_s"><span id="fax_doc_cvt_now0" style="width:18px; color:#b5b4b4; margin-left:6px; text-align:center;">0</span><span id="fax_doc_cvt_now1" style="width:25px; color:#b5b4b4; text-align:center;">0</span><span id="fax_doc_cvt_now2" style="width:23px; color:#b5b4b4; text-align:center;">0</span><span id="fax_doc_cvt_now3" style="width:21px; color:#b5b4b4; text-align:center;">0</span></div>
                <div class="box_num01_title">처리중</div>
             </div>
             <!--//처리중-->
           </div>
           </td>
         </tr>
         <tr>
           <td height="10"></td>
         </tr>
       </table>
       <!--//네오팩스 문서 변환 상태-->
       <!--네오팩스 문서 합성 상태-->
       <table border="0" cellspacing="0" cellpadding="0" style="width:465px; float:left;">
         <tr>
           <td width="100%" height="30"class="b gray_sub"><img src="${img2}/icon_result.jpg" align="absmiddle">네오팩스 문서 합성 상태</td>
         </tr>
         <tr>
           <td>
           <div class="boxbg01_s">
           	<!--처리된 건수-->
             <div class="box_num01">
             	<div class="box_num01_s"><span id="fax_doc_fod_total0" style="width:18px; color:#b5b4b4; margin-left:6px; text-align:center;">0</span><span id="fax_doc_fod_total1" style="width:25px; color:#b5b4b4; text-align:center;">0</span><span id="fax_doc_fod_total2" style="width:23px; color:#b5b4b4; text-align:center;">0</span><span id="fax_doc_fod_total3" style="width:21px; color:#b5b4b4; text-align:center;">0</span></div>
                <div class="box_num01_title">처리된 건수</div>
             </div>
             <!--//처리된 건수-->
             <!--성공 건수-->
             <div class="box_num01">
             	<div class="box_num01_s"><span id="fax_doc_fod_success0" style="width:18px; color:#b5b4b4; margin-left:6px; text-align:center;">0</span><span id="fax_doc_fod_success1" style="width:25px; color:#b5b4b4; text-align:center;">0</span><span id="fax_doc_fod_success2" style="width:23px; color:#b5b4b4; text-align:center;">0</span><span id="fax_doc_fod_success3" style="width:21px; color:#b5b4b4; text-align:center;">0</span></div>
                <div class="box_num01_title">성공 건수</div>
             </div>
             <!--//성공 건수-->
             <!--실패건수-->
             <div class="box_num01">
             	<div class="box_num01_s"><span id="fax_doc_fod_fail0" style="width:18px; color:#b5b4b4; margin-left:6px; text-align:center;">0</span><span id="fax_doc_fod_fail1" style="width:25px; color:#b5b4b4; text-align:center;">0</span><span id="fax_doc_fod_fail2" style="width:23px; color:#b5b4b4; text-align:center;">0</span><span id="fax_doc_fod_fail3" style="width:21px; color:#b5b4b4; text-align:center;">0</span></div>
                <div class="box_num01_title">실패 건수</div>
             </div>
             <!--//실패건수-->
             <!--처리중-->
             <div class="box_num01">
             	<div class="box_num01_s"><span id="fax_doc_fod_now0" style="width:18px; color:#b5b4b4; margin-left:6px; text-align:center;">0</span><span id="fax_doc_fod_now1" style="width:25px; color:#b5b4b4; text-align:center;">0</span><span id="fax_doc_fod_now2" style="width:23px; color:#b5b4b4; text-align:center;">0</span><span id="fax_doc_fod_now3" style="width:21px; color:#b5b4b4; text-align:center;">0</span></div>
                <div class="box_num01_title">처리중</div>
             </div>
             <!--//처리중-->
           </div>
           </td>
         </tr>
         <tr>
           <td height="10"></td>
         </tr>
       </table>
       <!--//네오팩스 문서 합성 상태-->
       <!--데이터베이스 컴포넌트 현황-->
       <table border="0" cellspacing="0" cellpadding="0" style="width:465px; float:left; margin-left:20px;">
         <tr>
           <td width="100%" height="30"class="b gray_sub"><img src="${img2}/icon_result.jpg" align="absmiddle">데이터베이스 컴포넌트 현황</td>
         </tr>
         <tr>
           <td>
           <div class="boxbg01_s">
           	<!--등록 수량-->
             <div class="box_num01">
             	<div class="box_num01_s"><span id="db_component_total0" style="width:18px; color:#b5b4b4; margin-left:6px; text-align:center;">0</span><span id="db_component_total1" style="width:25px; color:#b5b4b4; text-align:center;">0</span><span id="db_component_total2" style="width:23px; color:#b5b4b4; text-align:center;">0</span><span id="db_component_total3" style="width:21px; color:#b5b4b4; text-align:center;">0</span></div>
                <div class="box_num01_title">등록 수량</div>
             </div>
             <!--//등록 수량-->
             <!--정상 동작-->
             <div class="box_num01">
             	<div class="box_num01_s"><span id="db_component_used0" style="width:18px; color:#b5b4b4; margin-left:6px; text-align:center;">0</span><span id="db_component_used1" style="width:25px; color:#b5b4b4; text-align:center;">0</span><span id="db_component_used2" style="width:23px; color:#b5b4b4; text-align:center;">0</span><span id="db_component_used3" style="width:21px; color:#b5b4b4; text-align:center;">0</span></div>
                <div class="box_num01_title">정상 동작</div>
             </div>
             <!--//정상 동작-->
             <!--동작 정지-->
             <div class="box_num01">
             	<div class="box_num01_s"><span id="db_component_notused0" style="width:18px; color:#b5b4b4; margin-left:6px; text-align:center;">0</span><span id="db_component_notused1" style="width:25px; color:#b5b4b4; text-align:center;">0</span><span id="db_component_notused2" style="width:23px; color:#b5b4b4; text-align:center;">0</span><span id="db_component_notused3" style="width:21px; color:#b5b4b4; text-align:center;">0</span></div>
                <div class="box_num01_title">동작 정지</div>
             </div>
             <!--//동작 정지-->
           </div>
           </td>
         </tr>
         <tr>
           <td height="10"></td>
         </tr>
       </table>
       <!--//데이터베이스 컴포넌트 현황-->
       <!--CTI 컴포넌트 현황-->
       <table border="0" cellspacing="0" cellpadding="0" style="width:465px; float:left; margin-right:15px;">
         <tr>
           <td width="100%" height="30"class="b gray_sub"><img src="${img2}/icon_result.jpg" align="absmiddle">CTI 컴포넌트 현황</td>
         </tr>
         <tr>
           <td>
           <div class="boxbg01_s">
           	<!--등록 수량-->
             <div class="box_num01">
             	<div class="box_num01_s"><span id="cti_component_total0" style="width:18px; color:#b5b4b4; margin-left:6px; text-align:center;">0</span><span id="cti_component_total1" style="width:25px; color:#b5b4b4; text-align:center;">0</span><span id="cti_component_total2" style="width:23px; color:#b5b4b4; text-align:center;">0</span><span id="cti_component_total3" style="width:21px; color:#b5b4b4; text-align:center;">0</span></div>
                <div class="box_num01_title">등록 수량</div>
             </div>
             <!--//등록 수량-->
             <!--정상 동작-->
             <div class="box_num01">
             	<div class="box_num01_s"><span id="cti_component_used0" style="width:18px; color:#b5b4b4; margin-left:6px; text-align:center;">0</span><span id="cti_component_used1" style="width:25px; color:#b5b4b4; text-align:center;">0</span><span id="cti_component_used2" style="width:23px; color:#b5b4b4; text-align:center;">0</span><span id="cti_component_used3" style="width:21px; color:#b5b4b4; text-align:center;">0</span></div>
                <div class="box_num01_title">정상 동작</div>
             </div>
             <!--//정상 동작-->
             <!--동작 정지-->
             <div class="box_num01">
             	<div class="box_num01_s"><span id="cti_component_notused0" style="width:18px; color:#b5b4b4; margin-left:6px; text-align:center;">0</span><span id="cti_component_notused1" style="width:25px; color:#b5b4b4; text-align:center;">0</span><span id="cti_component_notused2" style="width:23px; color:#b5b4b4; text-align:center;">0</span><span id="cti_component_notused3" style="width:21px; color:#b5b4b4; text-align:center;">0</span></div>
                <div class="box_num01_title">동작 정지</div>
             </div>
             <!--//동작 정지-->
           </div>
           </td>
         </tr>
         <tr>
           <td height="10"></td>
         </tr>
       </table>
       <!--//CTI 컴포넌트 현황-->
       <!--기타 서버 컴포넌트 현황-->
       <table border="0" cellspacing="0" cellpadding="0" style="width:465px; margin-left:20px;">
         <tr>
           <td width="100%" height="30"class="b gray_sub"><img src="${img2}/icon_result.jpg" align="absmiddle">기타 서버 컴포넌트 현황</td>
         </tr>
         <tr>
           <td>
           <div class="boxbg01_s">
           	<!--등록 수량-->
             <div class="box_num01">
             	<div class="box_num01_s"><span id="ex_component_total0" style="width:18px; color:#b5b4b4; margin-left:6px; text-align:center;">0</span><span id="ex_component_total1" style="width:25px; color:#b5b4b4; text-align:center;">0</span><span id="ex_component_total2" style="width:23px; color:#b5b4b4; text-align:center;">0</span><span id="ex_component_total3" style="width:21px; color:#b5b4b4; text-align:center;">0</span></div>
                <div class="box_num01_title">등록 수량</div>
             </div>
             <!--//등록 수량-->
             <!--정상 동작-->
             <div class="box_num01">
             	<div class="box_num01_s"><span id="ex_component_used0" style="width:18px; color:#b5b4b4; margin-left:6px; text-align:center;">0</span><span id="ex_component_used1" style="width:25px; color:#b5b4b4; text-align:center;">0</span><span id="ex_component_used2" style="width:23px; color:#b5b4b4; text-align:center;">0</span><span id="ex_component_used3" style="width:21px; color:#b5b4b4; text-align:center;">0</span></div>
                <div class="box_num01_title">정상 동작</div>
             </div>
             <!--//정상 동작-->
             <!--동작 정지-->
             <div class="box_num01">
             	<div class="box_num01_s"><span id="ex_component_notused0" style="width:18px; color:#b5b4b4; margin-left:6px; text-align:center;">0</span><span id="ex_component_notused1" style="width:25px; color:#b5b4b4; text-align:center;">0</span><span id="ex_component_notused2" style="width:23px; color:#b5b4b4; text-align:center;">0</span><span id="ex_component_notused3" style="width:21px; color:#b5b4b4; text-align:center;">0</span></div>
                <div class="box_num01_title">동작 정지</div>
             </div>
             <!--//동작 정지-->
           </div>
           </td>
         </tr>
         <tr>
           <td height="10"></td>
         </tr>
       </table>
       <!--//기타 서버 컴포넌트 현황-->




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