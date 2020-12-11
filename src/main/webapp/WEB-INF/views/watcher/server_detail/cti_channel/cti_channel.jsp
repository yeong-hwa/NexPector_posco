<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/include.jsp" %>

<jsp:useBean id="lst" class="java.util.ArrayList" scope="request"/>

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
		var date = $("#datepicker").datepicker("getDate");
		fn_dateChange(format_yyyymmdd(date.getFullYear(), date.getMonth() + 1, date.getDate()));
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
		frm.N_DAY.value = strDate;
		
		$(".peek_stats").text("(" + $( "#datepicker" ).val() + " 피크 현황)");
		
		frm.target = "ifm_daily_chart_ALL";
		frm.action = "<c:url value='/watcher/go_server_detail.cti_channel.daily_history_chart_main.htm'/>?N_MON_ID=${param.N_MON_ID}&OBJ_TOP=${205+(85)}&OBJ_LEFT=200";
		frm.submit();
	}

</script>

<style>
.ui-datepicker th { padding: .7em .3em; text-align: center; font-weight: normal; border: 0;  width: 25 }
.ui-state-default, .ui-widget-content .ui-state-default, .ui-widget-header .ui-state-default { font-weight: bold; font-size:10px; width:15; padding-bottom: .1px; padding-top: .1px; }
.ui-datepicker { width: 12em; padding: .1em .1em 0; display: none; }
</style>
<body style="background-color: transparent;">
<form name="frm" method="post">
	<input type="hidden" name="CH_NO" value="1">
    <input type="hidden" name="N_MON_ID" value="${param.N_MON_ID}">
    <input type="hidden" name="N_DAY" value="">
</form>     

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td background="${img2}/tab_lc.jpg">&nbsp;</td>
                <td width="100%" class="pt15">
                	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	                    <tr>
	                      <td width="180" align="left" valign="top" class="pt40" style="padding-top: 10px">
	                      <!-- 검색 달력 시작 -->
	                      	<div id="datepicker"></div>
	                        <!-- 검색 달력 끝 -->
	                        </td>
	                      <td>
	                      <script>
	                      	var s_key_lst = "";
	                      	function fn_runchk()
                	    	{
                	    		var param = "N_MON_ID="+${param.N_MON_ID};
                	    		param += "&N_MON_TYPE=3";
                	    		
                	    		$.getJSON("<c:url value='/watcher/lst_RealProcessServiceUsageQry3.htm'/>", param, function(data){
                	    			$(".cls_run_chk").each(function(){
                	    				var tmp_flag = false;
                	    				var tmp_obj = this;
                	    				$(data).each(function(){
                	    					if(tmp_obj.id == "run_"+this.S_MAP_KEY && this.F_STATUS == "1")
                        	    			{
                	    						$(tmp_obj).html('<img align="absmiddle" src="${img2}/run_process.gif">');
                        	    				tmp_flag = true;
                        	    			}
                	    				});
                    	    			if(!tmp_flag)
                    	    			{
                    	    				$(tmp_obj).html("");
                    	    			}
                    	    		});
                	    		});
                	    	}
	                      </script>
	                      		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                          <tr>
		                          	<td height="20" class="b"><img src="${img2}/icon_result.jpg" align="absmiddle">상태별 Peak 
		                          		[<span style="color:#FF0000;font-weight:bold;">전체</span>
		                          		<span style="color:#00FF00;font-weight:bold;">로그인</span>
		                          		<span style="color:#0000FF;font-weight:bold;">대기</span>
		                          		<span style="color:#FFFF00;font-weight:bold;">이석</span>
		                          		<span style="color:#00FFFF;font-weight:bold;">후처리</span>
		                          		<span style="color:#FF00FF;font-weight:bold;">통화중</span>]
		                          	</td>
		                            <td align="right" class="text11 pr15 gray_sub peek_stats"></td>
		                          </tr>
		                          <tr>
		                            <td height="75" colspan="2" class="line_gray">
		                            	<iframe name="ifm_daily_chart_ALL" src="" width="820" height="200" frameborder="0" scrolling="no"></iframe>
		                            </td>
		                          </tr>
		                          <tr>
		                            <td height="1" colspan="2" bgcolor="eeeeee"><img src="${img2}/dot.png"></td>
		                          </tr>
		                        </table>
	                      </td>
	                    </tr>
                  </table></td>
                <td background="${img2}/tab_rc.jpg">&nbsp;</td>
              </tr>
              <tr>
                <td><img src="${img2}/tab_lb.jpg"></td>
                <td height="4" background="${img2}/tab_ceb.jpg"><img src="${img2}/dot.png"></td>
                <td><img src="${img2}/tab_rb.jpg"></td>
              </tr>
            </table>
</body>