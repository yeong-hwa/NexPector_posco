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
	%>

	function fn_dateChange(strDate)
	{
		frm.N_DAY.value = $( "#datepicker" ).val().replace(/-/g,"");
		frm.N_INDEX.value = $("#div_if_lst table tr td input[type='radio']:checked").val();

		$(".peek_stats").text("(" + $( "#datepicker" ).val() + " 평균)");

		var check = frm.N_INDEX.value;
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
				frm.action = "<c:url value='/watcher/go_server_detail.snmp_m04.daily_history_chart_main.htm'/>?N_MON_ID=${param.N_MON_ID}&S_COLUMN=<%=key%>&OBJ_TOP=${205+(85*(1))}&OBJ_LEFT=200";
				frm.submit();
		<%  }
			ir = null;
		%>


	}

	$(function (){
		var date = $("#datepicker").datepicker("getDate");
        fn_dateChange(format_yyyymmdd(date.getYear(), date.getMonth() + 1, date.getDate()));
		$("select[name='N_INDEX']").change(function(){
			fn_dateChange();
		});
	});
</script>

<style>
.ui-datepicker th { padding: .7em .3em; text-align: center; font-weight: normal; border: 0;  width: 25 }
.ui-state-default, .ui-widget-content .ui-state-default, .ui-widget-header .ui-state-default { font-weight: bold; font-size:10px; width:15; padding-bottom: .1px; padding-top: .1px; }
.ui-datepicker { width: 12em; padding: .1em .1em 0; display: none; }
</style>
<body style="background-color: transparent;">
<form name="frm" method="post">
	<input type="hidden" name="N_MON_TYPE" value="0">
    <input type="hidden" name="N_MON_ID" value="${param.N_MON_ID}">
    <input type="hidden" name="N_DAY" value="">
    <input type="hidden" name="N_INDEX" value="0">
</form>

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="3" background="${img2}/tab_lc.jpg">&nbsp;</td>
                <td width="100%" class="pt15">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="180" rowspan="3" align="center" valign="top" class="pt40" style="padding-top: 1px">
<%--                       <cmb:combo qryname="qry_combo_m04_if" seltagname="N_INDEX" param="N_MON_ID=${param.N_MON_ID}"/> --%>
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
                      <br><br>
                      <!-- 검색 달력 시작 -->
                      	<div id="datepicker"></div>
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