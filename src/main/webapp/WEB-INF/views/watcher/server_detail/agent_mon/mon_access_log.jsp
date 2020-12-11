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
	
	function fn_dateChange(strDate)
	{		
		frm.N_DAY.value = $( "#datepicker" ).val().replace(/-/g,"");
		
		frm.target = "ifm_daily_access";
		frm.action = "<c:url value='/watcher/go_server_detail.agent_mon.mon_access_log_list.htm?req_data=data;MonAccessLogLstQry|page_totalcnt;MonAccessLogLstCntQry'/>";
		frm.submit();
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
    <input type="hidden" name="N_DAY" value="">
    <input type="hidden" name="N_MON_ID" value="${param.N_MON_ID}">
	<input type="hidden" name="nowpage" value="<c:if test='${param.nowpage==null}'>1</c:if>${param.nowpage}">
	<input type="hidden" name="pagecnt" value="15">
</form>     

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="3" background="${img2}/tab_lc.jpg">&nbsp;</td>
                <td width="100%" class="pt15">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="180" rowspan="3" align="center" valign="top" class="pt40" style="padding-top: 1px">
                      <!-- 검색 달력 시작 -->
                      	<div id="datepicker"></div>
                        <!-- 검색 달력 끝 -->
                      </td>
                      <td valign="top" height="450">
						<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
						  <tr>
                            <td height="20" class="b"><img src="${img2}/icon_result.jpg" align="absmiddle">Access Log</td>
                            <td align="right" class="text11 pr15 gray_sub peek_stats"></td>
                          </tr>
                          <tr>
                            <td height="100%" valign="top" colspan="2" class="line_gray">
                            	<iframe name="ifm_daily_access" src="" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>
                            </td>
                          </tr>
                        </table>
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