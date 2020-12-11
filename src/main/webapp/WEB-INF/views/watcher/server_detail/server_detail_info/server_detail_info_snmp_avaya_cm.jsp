<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/include.jsp" %>


<form name="frm" method="post">
	<input type="hidden" name="N_MON_ID" value="${param.N_MON_ID}">
	<input type="hidden" name="S_CPU_KEY" value="${svr_info.S_CPU_KEY}">
	<input type="hidden" name="S_MEM_KEY" value="${svr_info.S_MEM_KEY}">
	<input type="hidden" name="S_DISK_KEY" value="${svr_info.S_DISK_KEY}">
</form>
<iframe name="ifm_realtime_svr_info" src="" width="0" height="0"></iframe>
<script type="text/javascript">
function fn_server_link(type, url) {
	if (url == null) {
		alert("url is null");
		return;
	}

	if (url == "") {
		alert("url is Empty");
		return;
	}

 	if(type == 0)
	{
 		open (url,"NMS","width=550, height=500");
	}
 	else if(type == 1)
	{
  		NEOLinkCtrl.RemoteWindow(url);
	}
	else if(type == 2)
	{
 		NEOLinkCtrl.RemotePutty(url);
	}

}
</script>

<script>
          	$(function() {
          		fn_get_server_info();
          	});

          	function fn_get_server_info()
	    	{
	      		//var param = "N_MON_ID=${param.N_MON_ID}";
	      		var param = "N_MON_ID=${param.N_MON_ID}&S_CPU_KEY=${svr_info.S_CPU_KEY}&S_MEM_KEY=${svr_info.S_MEM_KEY}&S_DISK_KEY=${svr_info.S_DISK_KEY}";
          		$.post("<c:url value='/watcher/server_detail/p_s_info.htm'/>?" + param, function(data){
          			var obj = eval("("+data+")");
          			try{
	          			var p_s_info = obj.p_s_info;

		    			var cri_cnt = 0;
	              		var maj_cnt = 0;
	              		var min_cnt = 0;

	              		cri_cnt = p_s_info.CRITICAL_ERR_CNT==null?0:p_s_info.CRITICAL_ERR_CNT;
	              		maj_cnt = p_s_info.MAJOR_ERR_CNT==null?0:p_s_info.MAJOR_ERR_CNT;
	              		min_cnt = p_s_info.MINOR_ERR_CNT==null?0:p_s_info.MINOR_ERR_CNT;

	              		if(cri_cnt > maj_cnt)
	              		{
	              			if(cri_cnt > min_cnt)
	              			{
	              				maj_cnt = 30 * (maj_cnt / cri_cnt);
	              				min_cnt = 30 * (min_cnt / cri_cnt);
	              				cri_cnt = 30;
	              			}
	              			else if(cri_cnt < min_cnt)
	              			{
	              				maj_cnt = 30 * (maj_cnt / min_cnt);
	              				cri_cnt = 30 * (cri_cnt / min_cnt);
	              				min_cnt = 30;
	              			}
	              			else
	              			{
	              				maj_cnt = maj_cnt==0?0:30*(maj_cnt/cri_cnt);
	              				cri_cnt = cri_cnt==0?0:30;
	              				min_cnt = min_cnt==0?0:30;
	              			}
	              		}
	              		else if(cri_cnt < maj_cnt)
	              		{
	              			if(maj_cnt > min_cnt)
	              			{
	              				cri_cnt = 30 * (cri_cnt / maj_cnt);
	              				min_cnt = 30 * (min_cnt / maj_cnt);
	              				maj_cnt = 30;
	              			}
	              			else if(maj_cnt < min_cnt)
	              			{
	              				maj_cnt = 30 * (maj_cnt / min_cnt);
	              				cri_cnt = 30 * (cri_cnt / min_cnt);
	              				min_cnt = 30;
	              			}
	              			else
	              			{
	              				cri_cnt = cri_cnt==0?0:30*(cri_cnt/maj_cnt);
	              				maj_cnt = maj_cnt==0?0:30;
	              				min_cnt = min_cnt==0?0:30;
	              			}
	              		}
	              		else
	              		{
	              			min_cnt = min_cnt==0?0:30*(min_cnt/cri_cnt);
	              			cri_cnt = cri_cnt==0?0:30;
	          				maj_cnt = maj_cnt==0?0:30;
	              		}

	              		$("#t_error_cnt_critcal").text(p_s_info.CRITICAL_ERR_CNT);
		    			$("#t_error_cnt_major").text(p_s_info.MAJOR_ERR_CNT);
		    			$("#t_error_cnt_minor").text(p_s_info.MINOR_ERR_CNT);
		    			//alert(cri_cnt + "-" + maj_cnt + "-" + min_cnt);
		    			$("#t_error_cnt_critcal_h").attr("height", cri_cnt);
		    			$("#t_error_cnt_major_h").attr("height", maj_cnt);
		    			$("#t_error_cnt_minor_h").attr("height", min_cnt);
          			}catch(e){}

          			function fn_resource_bar(val)
	    			{
	    				return val<50?(val*2):(val*2-(Math.floor((val-50)/10)*3));
	    			}
          			try{
		    			var cpu_info = obj.cpu_info;
		    			$("#t_cpu_per").attr("width", fn_resource_bar(cpu_info.N_PER_USE));
		    			$("#t_cpu_usage").text((cpu_info.N_NOW_USE==null?"":cpu_info.N_NOW_USE) + "%");
          			}catch(e){}

          			try{
		    			var mem_info = obj.mem_info;
		    			$("#t_mem_per").attr("width", fn_resource_bar(mem_info.N_PER_USE));
	// 	    			$("#t_mem_usage").text((mem_info.N_NOW_USE==null?"":mem_info.N_NOW_USE) + "/" + (mem_info.N_FULL_SIZE==null?"":mem_info.N_FULL_SIZE) + "MB");
						$("#t_mem_usage").text(mem_info.N_PER_USE==null?"":mem_info.N_PER_USE + "%");
          			}catch(e){}

          			try{
		    			var disk_info = obj.disk_info;
		    			$("#t_disk_per").attr("width", fn_resource_bar(disk_info.N_PER_USE));
	// 	    			$("#t_disk_usage").text((disk_info.N_NOW_USE==null?"":disk_info.N_NOW_USE) + "/" + (disk_info.N_FULL_SIZE==null?"":disk_info.N_FULL_SIZE) + "MB");
						$("#t_disk_usage").text(disk_info.N_PER_USE==null?"":disk_info.N_PER_USE + "%");
          			}catch(e){}

	    			window.setTimeout("fn_get_server_info()", 1500);
	    		});
	    	}
          	$(function(){
         		var offset = $("#t_cpu_usage").offset();

				var top_px = navigator.userAgent.toLowerCase().indexOf("msie") != -1?12:1;

        		$("#t_cpu_usage").css({
        			left : offset.left+65
        			, top : offset.top-top_px
        			, position: "absolute"
        		});

        		offset = $("#t_mem_usage").offset();
        		$("#t_mem_usage").css({
        			left : offset.left+65
        			, top : offset.top-top_px
        			, position: "absolute"
        		});

        		offset = $("#t_disk_usage").offset();
        		offset = $("#t_disk_usage").offset();
        		$("#t_disk_usage").css({
        			left : offset.left+65
        			, top : offset.top-top_px
        			, position: "absolute"
        		});
         	});
 </script>

<table height="100%" width="100%" background="${img2}/bg_center.jpg" style="background-repeat:no-repeat" class="pl54 pt34">
	<tr>
	<td height="100%" valign="top" align="center" style="padding-top:30px">
		<table width="998" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td height="1" colspan="3" bgcolor="a8b9d7" ><img src="${img2}/dot.png"></td>
        </tr>
        <tr>
          <td height="2" colspan="3" bgcolor="cad3e2"><img src="${img2}/dot.png"></td>
        </tr>
        <tr>
          <td height="39" colspan="3"><img src="${img2}/sotitle_view.png"></td>
        </tr>
        <tr>
          <td height="2" colspan="3" bgcolor="cad3e2"><img src="${img2}/dot.png"></td>
        </tr>
        <tr>
          <td height="17" colspan="3"></td>
        </tr>
        <tr>
          <td width="615">
          <!-- 정보섹션 1 시작 -->
          <table width="600" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9"><img src="${img2}/box01_lt.png"></td>
                <td style="background-image:url(${img2}/box01_ct.png)"></td>
                <td width="9" height="9"><img src="${img2}/box01_rt.png"></td>
              </tr>
              <tr>
                <td style="background:url('${img2}/box01_bgc.png') left top repeat-x;"><img src="${img2}/box01_bgl.png" width="9" height="99" /></td>
                <td height="96" style="background:url('${img2}/box01_bgc.png') left top repeat-x;">
                <!-- 장비 상세설명 시작 -->
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="70" rowspan="3" align="center">
                      <img onclick="javascript:fn_server_link('${svr_info.get(0).N_LINK_TYPE}','${svr_info.get(0).N_URL}')" src="${img2}/ico_cm.png">
                      </td>
                      <td width="70" class="text11 b gray">장비명</td>
                      <td width="257" height="33" background="${img2}/server_name3.jpg" class="pl10">
                      	${svr_info.S_MON_NAME}&nbsp;&nbsp;-&nbsp;&nbsp;[${svr_info.N_MON_ID}]
                      </td>
                    </tr>
                    <tr>
                      <td class="text11 b gray">IP주소</td>
                      <td height="33" background="${img2}/server_name3.jpg" class="pl10">${svr_info.S_MON_IP}</td>
                    </tr>
                    <tr>
                      <td class="text11 b gray">연결상태</td>
                      <td height="33" background="${img2}/server_name3.jpg" class="pl10"><c:if test="${svr_info.B_CON_INFO == '연결'}"><b style="color:blue;">${svr_info.B_CON_INFO}</c:if><c:if test="${svr_info.B_CON_INFO == '연결안됨'}"><b style="color:red;">${svr_info.B_CON_INFO}</c:if></td>
                    </tr>
                  </table>
                  <!-- 장비 상세설명 끝 -->
                  </td>
                <td><img src="${img2}/box01_bgr.png" width="9" height="99" /></td>
              </tr>
              <tr>
                <td><img src="${img2}/box01_lb.png"></td>
                <td style="background-image:url(${img2}/box01_cb.png)"></td>
                <td><img src="${img2}/box01_rb.png"></td>
              </tr>
            </table>
            <!-- 정보섹션 1 끝 -->
            </td>
          <td width="103">
          <!-- 정보섹션 2 시작 -->
         <div id="div_p_s_info">
          <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9"><img src="${img2}/box01_lt.png"></td>
                <td style="background-image:url(${img2}/box01_ct.png)"><img src="${img2}/dot.png"></td>
                <td width="9" height="9"><img src="${img2}/box01_rt.png"></td>
              </tr>
              <tr>
                <td><img src="${img2}/box01_bgl.png" width="9" height="99" /></td>
                <td height="96" style="background:url('${img2}/box01_bgc.png') left top repeat-x;" align="center"><!-- 장비 장애 현황 시작 -->
                  <table width="70" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="73" align="center" class="text11 b gray">장애</td>
                    </tr>
                    <tr>
                      <td height="55" align="center"  valign="bottom" background="${img2}/server_graph.jpg"><!-- 개별 그래프 시작 -->
                        <table width="38" border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td class="text11 b red" id="t_error_cnt_critcal">0</td>
                            <td></td>
                            <td class="text11 b red" id="t_error_cnt_major">0</td>
                            <td></td>
                            <td class="text11 b red" id="t_error_cnt_minor">0</td>
                          </tr>
                          <tr>
                            <td valign="bottom"><img src="${img2}/g_red.jpg" width="9" height="0" id="t_error_cnt_critcal_h"></td>
                            <td>&nbsp;</td>
                            <td valign="bottom"><img src="${img2}/g_red.jpg" width="9" height="0" id="t_error_cnt_major_h"></td>
                            <td>&nbsp;</td>
                            <td valign="bottom"><img src="${img2}/g_red.jpg" width="9" height="0" id="t_error_cnt_minor_h"></td>
                          </tr>
                        </table>
                        <!-- 개별 그래프 끝 --></td>
                    </tr>
                    <tr>
                      <td height="18" align="center"   class="text11 b gray" style="font-size:9px;">Cri Maj Min</td>
                    </tr>
                  </table>
                  <!-- 장비 장애 현황 끝 -->
                </td>
                <td><img src="${img2}/box01_bgr.png" width="9" height="99" /></td>
              </tr>
              <tr>
                <td><img src="${img2}/box01_lb.png"></td>
                <td style="background-image:url(${img2}/box01_cb.png)"></td>
                <td><img src="${img2}/box01_rb.png"></td>
              </tr>
            </table>
          </div>
            <!-- 정보섹션 2 끝 -->
            </td>
          <td width="500">
          <!-- 정보섹션 3 시작 -->
        <div id="div_resource_info">
          <table width="245" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9"><img src="${img2}/box01_lt.png"></td>
                <td style="background-image:url(${img2}/box01_ct.png)"></td>
                <td width="9" height="9"><img src="${img2}/box01_rt.png"></td>
              </tr>
              <tr>
                <td bgcolor="e9e9e9"><img src="${img2}/box01_bgl.png" width="9" height="99" /></td>
                <td height="96" style="background:url('${img2}/box01_bgc.png') left top repeat-x;">
                <!-- CPU/DISK/MEM 현황 시작-->
                               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="35" class="text11 b gray">CPU</td>
                      <td width="190" height="33" background="${img2}/server_cpu.jpg"><!--개별 막대그래프 시작-->
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td width="94"><img src="${img2}/g_wblue.jpg" width="0%" height="20" id="t_cpu_per"></td>
                            <td align="right"  class="text11 b ggray pr5"><span style="background-color:#FFFFFF;" id="t_cpu_usage"></span></td>
                          </tr>
                        </table>
                        <!--개별 막대그래프 끝-->
                      </td>
                    </tr>
                    <tr>
                      <td class="text11 b gray">MEM</td>
                      <td height="33" background="${img2}/server_cpu.jpg"><!--개별 막대그래프 시작-->
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td width="94"><img src="${img2}/g_wblue.jpg" width="0%" height="20" id="t_mem_per"></td>
                            <td align="right"  class="text11 b ggray pr5"><span style="background-color:#FFFFFF;" id="t_mem_usage"></span></td>
                          </tr>
                        </table>
                        <!--개별 막대그래프 끝--></td>
                    </tr>
                    <tr style="display:none;">
                      <td class="text11 b gray">DISK</td>
                      <td height="33" background="${img2}/server_cpu.jpg"><!--개별 막대그래프 시작-->
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td width="94"><img src="${img2}/g_wblue.jpg" width="0%" height="20" id="t_disk_per"></td>
                            <td align="right"  class="text11 b ggray pr5"><span style="background-color:#FFFFFF;" id="t_disk_usage"></span></td>
                          </tr>
                        </table>
                        <!--개별 막대그래프 끝--></td>
                    </tr>
                  </table>
                  <!-- CPU/DISK/MEM 현황 끝-->
                  </td>
                <td bgcolor="e9e9e9"><img src="${img2}/box01_bgr.png" width="9" height="99" /></td>
              </tr>
              <tr>
                <td><img src="${img2}/box01_lb.png"></td>
                <td style="background-image:url(${img2}/box01_cb.png)"></td>
                <td><img src="${img2}/box01_rb.png"></td>
              </tr>
            </table>
          </div>
            <!-- 정보섹션3 끝 -->
            </td>
        </tr>
        <tr>
          <td height="17" colspan="3"></td>
        </tr>
        <tr>
          <td colspan="3">
          <script>
          	$(function(){
          		$("#tab_menu .b").css("cursor", "hand");
          		$("#tab_menu .b").click(function() {
          			$("#tab_menu .b").attr({
          				"background" : "${img2}/tab_off2.png"
          				, "class" : "b pt2"
          			});
          			$(this).attr({
          				"background" : "${img2}/tab_on2.png"
              				, "class" : "b white pt2"
              			});

          			frm_tab.target = "ifm_svr_detail";
          			frm_tab.action = $(this).children("input[name='tab_url']").val();
          			frm_tab.submit();
          		});

          		$("#tab_menu .b").eq(0).click();
          	});
          </script>
          <!-- SUB TAB 시작 -->
          <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="4" valign="top"><img src="${img2}/box02_l.png" width="4" height="86" /></td>
                <td align="center" style="background:url('${img2}/box02_c.png') left top repeat-x;" style="padding:10px 0 10px 0">
          		  <table border="0" cellspacing="0" cellpadding="0" id="tab_menu">
          		  	<c:if test="${svr_info.S_CM_TYPE == 'Call서버'}">
          		  		<tr align="center">
	                      <td width="106" height="33" valign="top" background="${img2}/tab_on2.png" class="b white pt2">장비정보<input type="hidden" name="tab_url" value="<c:url value='/watcher/go_server_detail.snmp_m01.snmp_m01_info.htm?req_data=data;SnmpM01InfoQry:map'/>"></td>
	                      <td width="106" valign="top" background="${img2}/tab_off2.png" class="b pt2">자원정보<input type="hidden" name="tab_url" value="<c:url value='/watcher/go_server_detail.resource_usage.resource_usage.htm?req_data=lst;ResourceLstQry'/>"></td>
	                      <td width="106" valign="top" background="${img2}/tab_off2.png" class="b pt2">전화기<input type="hidden" name="tab_url" value="<c:url value='/watcher/go_server_detail.snmp_m01.phone_info.htm?req_data=data;M01PhoneInfoLstQry|page_totalcnt;M01PhoneInfoLstCntQry'/>"></td>
	                      <td width="106" valign="top" background="${img2}/tab_off2.png" class="b pt2">IPSI<input type="hidden" name="tab_url" value="<c:url value='/watcher/go_server_detail.snmp_m01.ipsi_info.htm?req_data=data;M01IpsiInfoLstQry|page_totalcnt;M01IpsiInfoLstCntQry'/>"></td>
	                      <td width="106" valign="top" background="${img2}/tab_off2.png" class="b pt2">Board<input type="hidden" name="tab_url" value="<c:url value='/watcher/go_server_detail.snmp_m01.board_info.htm?req_data=data;M01BoardInfoLstQry|page_totalcnt;M01BoardInfoLstCntQry'/>"></td>
	                      <td width="106" valign="top" background="${img2}/tab_off2.png" class="b pt2">장애<input type="hidden" name="tab_url" value="<c:url value='/watcher/go_server_detail.error_stats.error_stats_main.htm'/>"></td>
	                      <td width="106" valign="top"></td>
	                      <td width="106" valign="top"></td>
	                      <td width="106" valign="top"></td>
	                    </tr>
          		  	</c:if>
          		  	<c:if test="${svr_info.S_CM_TYPE != 'Call서버' and svr_info.S_CM_TYPE != '기타'}">
          		  		<tr align="center">
	                      <td width="106" height="33" valign="top" background="${img2}/tab_on2.png" class="b white pt2">장비정보<input type="hidden" name="tab_url" value="<c:url value='/watcher/go_server_detail.snmp_m01.snmp_m01_info.htm?req_data=data;SnmpM01InfoQry:map'/>"></td>
	                      <td width="106" valign="top" background="${img2}/tab_off2.png" class="b pt2">자원정보<input type="hidden" name="tab_url" value="<c:url value='/watcher/go_server_detail.resource_usage.resource_usage.htm?req_data=lst;ResourceLstQry'/>"></td>
	                      <td width="106" valign="top" background="${img2}/tab_off2.png" class="b pt2">전화기<input type="hidden" name="tab_url" value="<c:url value='/watcher/go_server_detail.snmp_m01.phone_info.htm?req_data=data;M01PhoneInfoLstQry|page_totalcnt;M01PhoneInfoLstCntQry'/>"></td>
	                      <td width="106" valign="top" background="${img2}/tab_off2.png" class="b pt2">IPSI<input type="hidden" name="tab_url" value="<c:url value='/watcher/go_server_detail.snmp_m01.ipsi_info.htm?req_data=data;M01IpsiInfoLstQry|page_totalcnt;M01IpsiInfoLstCntQry'/>"></td>
	                      <td width="106" valign="top" background="${img2}/tab_off2.png" class="b pt2">Board<input type="hidden" name="tab_url" value="<c:url value='/watcher/go_server_detail.snmp_m01.board_info.htm?req_data=data;M01BoardInfoLstQry|page_totalcnt;M01BoardInfoLstCntQry'/>"></td>
	                      <td width="106" valign="top" background="${img2}/tab_off2.png" class="b pt2">장애<input type="hidden" name="tab_url" value="<c:url value='/watcher/go_server_detail.error_stats.error_stats_main.htm'/>"></td>
	                      <td width="106" valign="top"></td>
	                      <td width="106" valign="top"></td>
	                      <td width="106" valign="top"></td>
	                    </tr>
          		  	</c:if>
          		  	<c:if test="${svr_info.S_CM_TYPE == '기타'}">
          		  		<tr align="center">
	                      <td width="106" height="33" valign="top" background="${img2}/tab_on2.png" class="b white pt2">장비정보<input type="hidden" name="tab_url" value="<c:url value='/watcher/go_server_detail.snmp_m01.snmp_m01_info.htm?req_data=data;SnmpM01InfoQry:map'/>"></td>
	                      <td width="106" valign="top" background="${img2}/tab_off2.png" class="b pt2">자원정보<input type="hidden" name="tab_url" value="<c:url value='/watcher/go_server_detail.resource_usage.resource_usage.htm?req_data=lst;ResourceLstQry'/>"></td>
	                      <td width="106" valign="top" background="${img2}/tab_off2.png" class="b pt2">전화기<input type="hidden" name="tab_url" value="<c:url value='/watcher/go_server_detail.snmp_m01.phone_info.htm?req_data=data;M01PhoneInfoLstQry|page_totalcnt;M01PhoneInfoLstCntQry'/>"></td>
	                      <td width="106" valign="top" background="${img2}/tab_off2.png" class="b pt2">IPSI<input type="hidden" name="tab_url" value="<c:url value='/watcher/go_server_detail.snmp_m01.ipsi_info.htm?req_data=data;M01IpsiInfoLstQry|page_totalcnt;M01IpsiInfoLstCntQry'/>"></td>
	                      <td width="106" valign="top" background="${img2}/tab_off2.png" class="b pt2">Board<input type="hidden" name="tab_url" value="<c:url value='/watcher/go_server_detail.snmp_m01.board_info.htm?req_data=data;M01BoardInfoLstQry|page_totalcnt;M01BoardInfoLstCntQry'/>"></td>
	                      <td width="106" valign="top" background="${img2}/tab_off2.png" class="b pt2">장애<input type="hidden" name="tab_url" value="<c:url value='/watcher/go_server_detail.error_stats.error_stats_main.htm'/>"></td>
	                      <td width="106" valign="top"></td>
	                      <td width="106" valign="top"></td>
	                      <td width="106" valign="top"></td>
	                    </tr>
          		  	</c:if>
                    <tr align="center">
                      <td height="33" valign="top"></td>
                      <td valign="top">&nbsp;</td>
<%--                       <td width="106" valign="top" background="${img2}/tab_off2.png" class="b pt2">CTI<input type="hidden" name="tab_url" value="server_detail.cti_info.neonex"></td> --%>
                      <td valign="top">&nbsp;</td>
                      <td valign="top">&nbsp;</td>
                      <td valign="top">&nbsp;</td>
                      <td valign="top">&nbsp;</td>
                      <td valign="top">&nbsp;</td>
                      <td valign="top">&nbsp;</td>
                      <td valign="top">&nbsp;</td>
                    </tr>
                  </table>
                 </td>
                <td width="4" valign="top"><img src="${img2}/box02_r.png" width="4" height="86" /></td>
              </tr>
              <tr>
              	<td colspan="3">
	         		<form name="frm_tab" method="post">
	         			<input type="hidden" name="N_MON_ID" value="${param.N_MON_ID}">
	         			<input type="hidden" name="nowpage" value="<c:if test='${param.nowpage==null}'>1</c:if>${param.nowpage}">
						<input type="hidden" name="pagecnt" value="10">
	         		</form>
         			<iframe name="ifm_svr_detail" src="" width="100%" height="430" frameborder="0" scrolling="auto" allowtransparency="true"></iframe>
            <!-- SUB TAB 끝 -->
            	</td>
        	</tr>
      </table></td>
      </tr>
     </table>

    <object id="NEOLinkCtrl" style="LEFT: 0px; VISIBILITY: visible; TOP: 0px; Width:0px; Height:0px; "  codebase="${cab}/NeoLinkCtrl.cab#version=1,0,0,1" classid="clsid:2C7FAF28-06A4-423A-A4CB-F2853E8046CA" VIEWASTEXT></object>