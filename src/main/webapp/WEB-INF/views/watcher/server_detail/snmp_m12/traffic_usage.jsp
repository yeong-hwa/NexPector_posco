<%@page import="java.util.Iterator"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/include.jsp" %>

<jsp:useBean id="lst" class="java.util.ArrayList" scope="request"/>

<jsp:useBean id="col_map" class="java.util.LinkedHashMap" scope="request"/>

<script src="<c:url value="/common/js/jquery-ui-1.10.3.custom/js/jquery-ui-1.10.3.custom.js"/>"></script>
<script src="<c:url value="/common/js/jquery-ui-1.10.3.custom/js/jquery.ui.datepicker-ko.js"/>"></script>
<link rel="stylesheet" href="<c:url value="/common/js/jquery-ui-1.10.3.custom/css/ui-lightness/jquery-ui-1.10.3.custom.css"/>"/>

<script>
	$(function() {
		$( "#datepicker" ).datepicker({
			onSelect : function (dateText, inst){
							fn_dateChange(dateText.replace(/-/g,""));
						}
		});
	});

	function format_yyyymmdd(year,month,day)
	{
		var str = "";

		str += year;
		str += (month<10)?"0"+month:month;
		str += (day<10)?"0"+day:day;

		return str;
	}

	<%
		//트래픽 출력 데이터 컬럼 리스트   컬럼명 : 표시이름
		/*
		col_map.put("N_IN_TOTAL_PKT", "IN Total Packet");
		col_map.put("N_IN_TOTAL_SPEED", "IN Total Speed");
		col_map.put("N_IN_BCAST_PKT", "IN Broadcast Packet");
		col_map.put("N_IN_BCAST_SPEED", "IN Broadcast Speed");
		col_map.put("N_IN_UCAST_PKT", "IN Unicast Packet");
		col_map.put("N_IN_UCAST_SPEED", "IN Unicast Speed");
		col_map.put("N_IN_MCAST_PKT", "IN Multicast Packet");
		col_map.put("N_IN_MCAST_SPEED", "IN Multicast Speed");
		col_map.put("N_OUT_TOTAL_PKT", "OUT Total Packet");
		col_map.put("N_OUT_TOTAL_SPEED", "OUT Total Speed");
		col_map.put("N_OUT_BCAST_PKT", "OUT Broadcast Packet");
		col_map.put("N_OUT_BCAST_SPEED", "OUT Broadcast Speed");
		col_map.put("N_OUT_UCAST_PKT", "OUT Unicast Packet");
		col_map.put("N_OUT_UCAST_SPEED", "OUT Unicast Speed");
		col_map.put("N_OUT_MCAST_PKT", "OUT Multicast Packet");
		col_map.put("N_OUT_MCAST_SPEED", "OUT Multicast Speed");
		*/

		col_map.put("N_IF_IN_OCTETS", "IN OCTETS");
		col_map.put("N_IF_IN_UCASTPKTS", "IN UCASTPKTS");
		col_map.put("N_IF_IN_NUCASTPKTS", "IN NUCASTPKTS");
		col_map.put("N_IF_IN_UNKNOWNPROTOS", "IN UNKNOWNPROTOS");
		col_map.put("N_IF_OUT_OCTETS", "OUT OCTETS");
		col_map.put("N_IF_OUT_UCASTPKTS", "OUT UCASTPKTS");
		col_map.put("N_IF_OUT_NUCASTPKTS", "NUCASTPKTS");
	%>

	function fn_dateChange(strDate)
	{
		frm.N_DAY.value = $( "#datepicker" ).val().replace(/-/g,"");
		frm.N_IF_INDEX.value = $("#div_if_lst table tr td input[type='radio']:checked").val();

		$(".peek_stats").text("(" + $( "#datepicker" ).val() + " 평균)");

		var check = frm.N_IF_INDEX.value;
		if (check == 'undefined') {
			return;
		}

		<%
			Iterator ir = col_map.keySet().iterator();
			while(ir.hasNext())
			{
				String key = ir.next().toString();
		%>
				//<%=key%> <%=col_map.get(key)%>
				frm.target = "ifm_daily_chart_<%=key%>";
				frm.action = "<c:url value='/watcher/go_server_detail.snmp_m12.hour_history_chart_main.htm'/>?N_MON_ID=${param.N_MON_ID}&S_COLUMN=<%=key%>&OBJ_TOP=${205+(85*(1))}&OBJ_LEFT=200";
				frm.submit();
		<%  }
			ir = null;
		%>


	}

	$(function (){
		var date = $("#datepicker").datepicker("getDate");
        fn_dateChange(format_yyyymmdd(date.getYear(), date.getMonth() + 1, date.getDate()));
		$("select[name='N_IF_INDEX']").change(function(){
			fn_dateChange();
		});
	});

    $(function(){
        $('#daybutton').click(function(){
    		var year = $("#daypicker .ui-datepicker-year :selected").val();
    		var month = $("#daypicker .ui-datepicker-month :selected").val();
    		var day = (new Date(year, parseInt(month) + 1, 0)).getDate();
            fn_dayChange(format_yyyymmdd(year, parseInt(month) + 1, day));
    		$("select[name='N_IF_INDEX']").change(function(){
    			fn_dayChange();
    		});
        });

        $('#monthbutton').click(function(){
        	var year = $("#monthpicker .ui-datepicker-year :selected").val();
            fn_monthChange(format_yyyymmdd(year, 1, 1));
    		$("select[name='N_IF_INDEX']").change(function(){
    			fn_monthChange();
    		});
        });
    });

	function fn_dayChange(strDate)
	{
		frm.N_MONTH.value = strDate.replace(/-/g,"");
		frm.N_IF_INDEX.value = $("#div_if_lst table tr td input[type='radio']:checked").val();
		$(".peek_stats").text("(" + strDate.substr(0,4) + "-" + strDate.substr(4,2) + " 평균)");

		var check = frm.N_IF_INDEX.value;
		if (check == 'undefined') {
			return;
		}

		<%
			ir = col_map.keySet().iterator();
			while(ir.hasNext())
			{
				String key = ir.next().toString();
		%>
				//<%=key%> <%=col_map.get(key)%>
				frm.target = "ifm_daily_chart_<%=key%>";
				frm.action = "<c:url value='/watcher/go_server_detail.snmp_m12.day_history_chart_main.htm'/>?N_MON_ID=${param.N_MON_ID}&S_COLUMN=<%=key%>&OBJ_TOP=${205+(85*(1))}&OBJ_LEFT=200";
				frm.submit();
		<%  }
			ir = null;
		%>
	}

	function fn_monthChange(strDate)
	{
		frm.N_YEAR.value = strDate.replace(/-/g,"");
		frm.N_IF_INDEX.value = $("#div_if_lst table tr td input[type='radio']:checked").val();

		$(".peek_stats").text("(" + strDate.substr(0,4) + " 평균)");

		var check = frm.N_IF_INDEX.value;
		if (check == 'undefined') {
			return;
		}

		<%
			ir = col_map.keySet().iterator();
			while(ir.hasNext())
			{
				String key = ir.next().toString();
		%>
				//<%=key%> <%=col_map.get(key)%>
				frm.target = "ifm_daily_chart_<%=key%>";
				frm.action = "<c:url value='/watcher/go_server_detail.snmp_m12.month_history_chart_main.htm'/>?N_MON_ID=${param.N_MON_ID}&S_COLUMN=<%=key%>&OBJ_TOP=${205+(85*(1))}&OBJ_LEFT=200";
				frm.submit();
		<%  }
			ir = null;
		%>
	}
</script>

<style>
.ui-datepicker th { padding: .7em .3em; text-align: center; font-weight: normal; border: 0;  width: 25 }
.ui-state-default, .ui-widget-content .ui-state-default, .ui-widget-header .ui-state-default { font-weight: bold; font-size:10px; width:15; padding-bottom: .1px; padding-top: .1px; }
.ui-datepicker { width: 12em; padding: .1em .1em 0; display: none; }
#daypicker table.ui-datepicker-calendar, #monthpicker table.ui-datepicker-calendar { display:none; }
</style>
<body style="background-color: transparent;">
<form name="frm" method="post">
	<input type="hidden" name="N_MON_TYPE" value="0">
    <input type="hidden" name="N_MON_ID" value="${param.N_MON_ID}">
    <input type="hidden" name="N_DAY" value="">
    <input type="hidden" name="N_MONTH" value="">
    <input type="hidden" name="N_YEAR" value="">
    <input type="hidden" name="N_IF_INDEX" value="0">
</form>

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="3" background="${img2}/tab_lc.jpg">&nbsp;</td>
                <td width="100%" class="pt15">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="180" rowspan="3" align="center" valign="top" class="pt40" style="padding-top: 1px">
<%--                       <cmb:combo qryname="qry_combo_m12_if" seltagname="N_IF_INDEX" param="N_MON_ID=${param.N_MON_ID}"/> --%>
                      <b>Interface List</b>
                      <div id="div_if_lst" style="width: 100%;height: 150;overflow-y:auto;">
                      	  <table width="100%" border="1" style="border-collapse: collapse;">
	                      	<c:forEach items="${lst}" var="m">
		                      	<tr>
		                      		<td><label><input type="radio" style="border: 0;" name="if_val" value="${m.CODE}"> ${m.VAL}</label></td>
		                      	</tr>
	                      	</c:forEach>
	                      </table>
                      </div>
                      <script>
                      	$(function(){
                      		$("#div_if_lst table tr td input[type='radio']").eq(0).attr("checked", true);

                            fn_dateChange();

                      		$("#div_if_lst table tr").hover(function(){
                      			$(this).attr("bgcolor", "#CCEEAA");
                      			$(this).css("cursor", "hand");
                      		}, function(){
                      			$(this).attr("bgcolor", "");
                      			$(this).css("cursor", "");
                      		});

                      		$("#div_if_lst table tr").click(function(){
                      			//alert($(this).children("td").children("input[type='radio']").val());
                      			$(this).children("td").children("input[type='radio']").attr("checked", true);
                      			fn_dateChange();
                      		});
                      	});
                      </script>
                      <br>

					  <div style="width: 100%; height:25px;">
						  <b>날짜 구분 :</b>
						  <select id="SearchKind" name="SearchKind">
							<option value="hour" selected>시간별</option>
							<option value="day">일별</option>
							<option value="month">월별</option>
						  </select>
						  <br>
					  </div>

					  <br>
                      <!-- 검색 달력 시작 -->
                      	<div id="datepicker"></div>
                      	<div id="daydiv">
	                      	<div id="daypicker"></div>
	                      	<div id="daybutton" align="right" style="padding-right:10px;"><img src="/common/images/watcher/btn_search.jpg" style="cursor:pointer;" val="daypicker"></div>
                      	</div>
                      	<div id="monthdiv">
	                      	<div id="monthpicker" ></div>
	                      	<div id="monthbutton" align="right" style="padding-right:10px;"><img src="/common/images/watcher/btn_search.jpg" style="cursor:pointer;" val="monthpicker"></div>
                      	</div>
                        <!-- 검색 달력 끝 -->
                      </td>
                      <td>
                      		<%
								ir = col_map.keySet().iterator();
								while(ir.hasNext())
								{
									String key = ir.next().toString();
							%>
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
			                          <tr>
			                            <td height="20" class="b"><img src="${img2}/icon_result.jpg" align="absmiddle"><%=col_map.get(key)%></td>
			                            <td align="right" class="text11 pr15 gray_sub peek_stats"></td>
			                          </tr>
			                          <tr>
			                            <td height="75" colspan="2" class="line_gray">
			                            	<iframe name="ifm_daily_chart_<%=key%>" src="" width="770" height="80" frameborder="0" scrolling="no"></iframe>
			                            </td>
			                          </tr>
			                          <tr>
			                            <td height="1" colspan="2" bgcolor="eeeeee"><img src="${img2}/dot.png"></td>
			                          </tr>
			                        </table>
							<%  }
								ir = null;
							%>
	                   </td>
                    </tr>
                  </table>
                </td>
                <td background="${img2}/tab_rc.jpg">&nbsp;</td>
              </tr>
              <tr>
                <td><img src="${img2}/tab_lb.jpg"></td>
                <td height="4" background="${img2}/tab_ceb.jpg"><img src="${img2}/dot.png"></td>
                <td><img src="${img2}/tab_rb.jpg"></td>
              </tr>
            </table>
</body>

<script>
jQuery(function($){
	$.datepicker.regional['ko'] = {
		minDate: '-6m',
		maxDate: '+0d'
		};
	$.datepicker.setDefaults($.datepicker.regional['ko']);
});

$("#daypicker").datepicker({
	changeMonth: true, // 월을 바꿀수 있는 셀렉트 박스를 표시한다.
	changeYear: true, // 년을 바꿀 수 있는 셀렉트 박스를 표시한다.
	minDate: '-1y', // 현재날짜로부터 100년이전까지 년을 표시한다.
	maxDate: '+0d',
	nextText: '다음달', // next 아이콘의 툴팁.
	prevText: '이전달', // prev 아이콘의 툴팁.
	numberOfMonths: [1,1], // 한번에 얼마나 많은 월을 표시할것인가. [2,3] 일 경우, 2(행) x 3(열) = 6개의 월을 표시한다.
	stepMonths: 1, // next, prev 버튼을 클릭했을때 얼마나 많은 월을 이동하여 표시하는가.
	//yearRange: 'c-1:c+0', // 년도 선택 셀렉트박스를 현재 년도에서 이전, 이후로 얼마의 범위를 표시할것인가.
	yearSuffix: "",
	showButtonPanel: false, // 캘린더 하단에 버튼 패널을 표시한다.
	dateFormat: "yy-mm-dd", // 텍스트 필드에 입력되는 날짜 형식.
	showAnim: "slide", //애니메이션을 적용한다.
	showMonthAfterYear: true , // 월, 년순의 셀렉트 박스를 년,월 순으로 바꿔준다.
	monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] // 월의 한글 형식.
});

$("#monthpicker").datepicker({
	changeMonth: false, // 월을 바꿀수 있는 셀렉트 박스를 표시한다.
	changeYear: true, // 년을 바꿀 수 있는 셀렉트 박스를 표시한다.
	minDate: '-2y', // 현재날짜로부터 100년이전까지 년을 표시한다.
	maxDate: '+0d',
	nextText: '다음해', // next 아이콘의 툴팁.
	prevText: '작년', // prev 아이콘의 툴팁.
	numberOfMonths: [1,1], // 한번에 얼마나 많은 월을 표시할것인가. [2,3] 일 경우, 2(행) x 3(열) = 6개의 월을 표시한다.
	stepMonths: 12, // next, prev 버튼을 클릭했을때 얼마나 많은 월을 이동하여 표시하는가.
	//yearRange: 'c-2:c+0', // 년도 선택 셀렉트박스를 현재 년도에서 이전, 이후로 얼마의 범위를 표시할것인가.
	yearSuffix: "년",
	showButtonPanel: false, // 캘린더 하단에 버튼 패널을 표시한다.
	dateFormat: "yy-mm-dd", // 텍스트 필드에 입력되는 날짜 형식.
	showAnim: "slide", //애니메이션을 적용한다.
	showMonthAfterYear: true , // 월, 년순의 셀렉트 박스를 년,월 순으로 바꿔준다.
	monthNames: ['','','','','','','','','','','',''],
	monthNamesShort: ['','','','','','','','','','','',''] // 월의 한글 형식.
});

$('#daydiv').hide();
$('#monthdiv').hide();

$("#SearchKind").change(function() {
	if ($(this).val() == 'hour') {
		$('#datepicker').show();
		$('#daydiv').hide();
		$('#monthdiv').hide();
	} else if ($(this).val() == 'day') {
		$('#datepicker').hide();
		$('#daydiv').show();
		$('#monthdiv').hide();
	} else if ($(this).val() == 'month') {
		$('#datepicker').hide();
		$('#daydiv').hide();
		$('#monthdiv').show();
	}
});
</script>
