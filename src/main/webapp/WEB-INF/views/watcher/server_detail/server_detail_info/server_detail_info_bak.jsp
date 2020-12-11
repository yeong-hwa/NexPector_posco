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

	      	function fn_realtime_server_info(str1, str2)
	      	{
	      		$("#div_p_s_info").html(str1);
	      		$("#div_resource_info").html(str2);
	      	}

	      	function fn_get_server_info()
	    	{
	      		var param = "N_MON_ID=${param.N_MON_ID}&S_CPU_KEY=${svr_info.S_CPU_KEY}&S_MEM_KEY=${svr_info.S_MEM_KEY}&S_DISK_KEY=${svr_info.S_DISK_KEY}";
          		$.post("<c:url value='/watcher/server_detail/p_s_info.htm'/>", param, function(data){
          			var obj = eval("("+data+")");

          			try{
	          			var p_s_info = obj.p_s_info;

		    			var p_cnt = 0;
		    			var p_err_cnt = 0;

		    			p_cnt = p_s_info.PROCESS_CNT==null?0:p_s_info.PROCESS_CNT;
		    			p_err_cnt = p_s_info.PROCESS_ERR_CNT==null?0:p_s_info.PROCESS_ERR_CNT;

		    			if(p_cnt > p_err_cnt)
	              		{
	              			p_err_cnt = 30 * (p_err_cnt / (p_cnt==0?1:p_cnt));
	              			p_cnt = 30;
	              		}
	              		else if(p_cnt < p_err_cnt)
	              		{
	              			p_cnt = 30 * (p_cnt / (p_err_cnt==0?1:p_err_cnt));
	              			p_err_cnt = 30;
	              		}
	              		else
	              		{
	              			p_cnt = p_cnt==0?0:30;
	              			p_err_cnt = p_err_cnt==0?0:30;
	              		}

		    			$("#t_process_cnt").text(p_s_info.PROCESS_CNT);
		    			$("#t_process_error_cnt").text(p_s_info.PROCESS_ERR_CNT);

		    			$("#t_process_cnt_h").attr("height", p_cnt);
		    			$("#t_process_error_cnt_h").attr("height", p_err_cnt);

		    			var s_cnt = 0;
		    			var s_err_cnt = 0;

		    			s_cnt = p_s_info.SERVICE_CNT==null?0:p_s_info.SERVICE_CNT;
		    			s_err_cnt = p_s_info.SERVICE_ERR_CNT==null?0:p_s_info.SERVICE_ERR_CNT;

		    			if(s_cnt > s_err_cnt)
	              		{
	              			s_err_cnt = 30 * (s_err_cnt / (s_cnt==0?1:s_cnt));
	              			s_cnt = 30;
	              		}
	              		else if(s_cnt < s_err_cnt)
	              		{
	              			s_cnt = 30 * (s_cnt / (s_err_cnt==0?1:s_err_cnt));
	              			s_err_cnt = 30;
	              		}
	              		else
	              		{
	              			s_cnt = s_cnt==0?0:30;
	              			s_err_cnt = s_err_cnt==0?0:30;
	              		}

		    			$("#t_service_cnt").text(p_s_info.SERVICE_CNT);
		    			$("#t_service_error_cnt").text(p_s_info.SERVICE_ERR_CNT);

		    			$("#t_service_cnt_h").attr("height", s_cnt);
		    			$("#t_service_error_cnt_h").attr("height", s_err_cnt);

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
		    			$("#t_cpu_usage").text((cpu_info.N_NOW_USE==null?"%":cpu_info.N_NOW_USE) + "%");
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
          <td width="455">
          <!-- 정보섹션 1 시작 -->
          <table width="440" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9"><img src="${img2}/box_lt.png"></td>
                <td bgcolor="e9e9e9"><img src="${img2}/dot.png"></td>
                <td width="9" height="9"><img src="${img2}/box_rt.png"></td>
              </tr>
              <tr>
                <td bgcolor="e9e9e9">&nbsp;</td>
                <td height="96" bgcolor="e9e9e9">
                <!-- 장비 상세설명 시작 -->
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="70" rowspan="3" align="center">
                      <img onclick="javascript:fn_server_link('${svr_info.get(0).N_LINK_TYPE}','${svr_info.get(0).N_URL}')" src="${img2}/ico_system.png">
                      </td>
                      <td width="70" class="text11 b gray">장비명</td>
                      <td width="177" height="33" background="${img2}/server_name2.jpg" class="pl10">
                      	${svr_info.S_MON_NAME}&nbsp;&nbsp;-&nbsp;&nbsp;[${svr_info.N_MON_ID}]
                      </td>
                    </tr>
                    <tr>
                      <td class="text11 b gray">IP주소</td>
                      <td height="33" background="${img2}/server_name2.jpg" class="pl10">${svr_info.S_MON_IP}</td>
                    </tr>
                    <tr>
                      <td class="text11 b gray">연결상태</td>
                      <td height="33" background="${img2}/server_name2.jpg" class="pl10"><c:if test="${svr_info.B_CON_INFO == '연결'}"><b style="color:blue;">${svr_info.B_CON_INFO}</c:if><c:if test="${svr_info.B_CON_INFO == '연결안됨'}"><b style="color:red;">${svr_info.B_CON_INFO}</c:if></td>
                    </tr>
                  </table>
                  <!-- 장비 상세설명 끝 -->
                  </td>
                <td bgcolor="e9e9e9">&nbsp;</td>
              </tr>
              <tr>
                <td><img src="${img2}/box_lb.png"></td>
                <td bgcolor="e9e9e9"><img src="${img2}/dot.png" width="1" height="1"></td>
                <td><img src="${img2}/box_rb.png"></td>
              </tr>
            </table>
            <!-- 정보섹션 1 끝 -->
            </td>
          <td width="250">
          <!-- 정보섹션 2 시작 -->
         <div id="div_p_s_info">
          <table width="235" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9"><img src="${img2}/box_lt.png"></td>
                <td bgcolor="e9e9e9"><img src="${img2}/dot.png"></td>
                <td width="9" height="9"><img src="${img2}/box_rt.png"></td>
              </tr>
              <tr>
                <td bgcolor="e9e9e9">&nbsp;</td>
                <td height="96" bgcolor="e9e9e9">
                <!-- 장비 장애 현황 시작 -->
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="73" align="center" class="text11 b gray">프로세스</td>
                      <td width="73" align="center" class="text11 b gray">서비스</td>
                      <td width="73" align="center" class="text11 b gray">장애</td>
                    </tr>
                    <tr>
                      <td height="55" align="center" valign="bottom" background="${img2}/server_graph.jpg"><!-- 개별 그래프 시작 -->
                        <table width="38" border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td class="text11 b bblue" id="t_process_cnt">0</td>
                            <td></td>
                            <td class="text11 b red" id="t_process_error_cnt">0</td>
                          </tr>
                          <tr>
                            <td valign="bottom"><img src="${img2}/g_blue.jpg" width="9" height="0" id="t_process_cnt_h"></td>
                            <td>&nbsp;</td>
                            <td valign="bottom"><img src="${img2}/g_red.jpg" width="9" height="0" id="t_process_error_cnt_h"></td>
                          </tr>
                        </table>
                        <!-- 개별 그래프 끝 --></td>
                      <td align="center"  valign="bottom" background="${img2}/server_graph.jpg"><!-- 개별 그래프 시작 -->
                        <table width="38" border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td class="text11 b bblue" id="t_service_cnt">0</td>
                            <td></td>
                            <td class="text11 b red" id="t_service_error_cnt">0</td>
                          </tr>
                          <tr>
                            <td valign="bottom"><img src="${img2}/g_blue.jpg" width="9" height="0" id="t_service_cnt_h"></td>
                            <td>&nbsp;</td>
                            <td valign="bottom"><img src="${img2}/g_red.jpg" width="9" height="0" id="t_service_error_cnt_h"></td>
                          </tr>
                        </table>
                        <!-- 개별 그래프 끝 --></td>
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
                      <td height="18" align="center"  class="text11 b gray">등록 장애</td>
                      <td align="center" class="text11 b gray">등록 장애</td>
                      <td height="18" align="center" class="text11 b gray" style="font-size:9px;">Cri Maj Min</td>
                    </tr>
                  </table>
                  <!-- 장비 장애 현황 끝 -->
                  </td>
                <td bgcolor="e9e9e9">&nbsp;</td>
              </tr>
              <tr>
                <td><img src="${img2}/box_lb.png"></td>
                <td bgcolor="e9e9e9"><img src="${img2}/dot.png" width="1" height="1"></td>
                <td><img src="${img2}/box_rb.png"></td>
              </tr>
            </table>
          </div>
            <!-- 정보섹션 2 끝 -->
            </td>
          <td>
          <!-- 정보섹션 3 시작 -->
        <div id="div_resource_info">
          <table width="245" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9"><img src="${img2}/box_lt.png"></td>
                <td bgcolor="e9e9e9"><img src="${img2}/dot.png"></td>
                <td width="9" height="9"><img src="${img2}/box_rt.png"></td>
              </tr>
              <tr>
                <td bgcolor="e9e9e9">&nbsp;</td>
                <td height="96" bgcolor="e9e9e9">
                <!-- CPU/DISK/MEM 현황 시작-->
                               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="35" class="text11 b gray">CPU</td>
                      <td width="190" height="33" background="${img2}/server_cpu.jpg"><!--개별 막대그래프 시작-->
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td width="94"><img src="${img2}/g_wblue.jpg" width="0%" height="20" id="t_cpu_per"></td>
                            <td align="right"  class="text11 b ggray pr5"><span id="t_cpu_usage"></span></td>
                            <script>
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
                            <td align="right"  class="text11 b ggray pr5"><span id="t_mem_usage"></span></td>
                          </tr>
                        </table>
                        <!--개별 막대그래프 끝--></td>
                    </tr>
                    <tr>
                      <td class="text11 b gray">DISK</td>
                      <td height="33" background="${img2}/server_cpu.jpg"><!--개별 막대그래프 시작-->
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td width="94"><img src="${img2}/g_wblue.jpg" width="0%" height="20" id="t_disk_per"></td>
                            <td align="right"  class="text11 b ggray pr5"><span id="t_disk_usage"></span></td>
                          </tr>
                        </table>
                        <!--개별 막대그래프 끝--></td>
                    </tr>
                  </table>
                  <!-- CPU/DISK/MEM 현황 끝-->
                  </td>
                <td bgcolor="e9e9e9">&nbsp;</td>
              </tr>
              <tr>
                <td><img src="${img2}/box_lb.png"></td>
                <td bgcolor="e9e9e9"><img src="${img2}/dot.png"></td>
                <td><img src="${img2}/box_rb.png"></td>
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
          		$("#tab .b").click(function() {
          			$("#tab .b").attr("background", "${img2}/tab_off.jpg");
          			$(this).attr("background", "${img2}/tab_on.jpg");

          			frm_tab.target = "ifm_svr_detail";
          			frm_tab.action = $(this).children("input[name='tab_url']").val();
          			frm_tab.submit();
          		});

          		$("#tab .b").eq(0).click();
          	});
          </script>
          <!-- SUB TAB 시작 -->
          <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="4"><img src="${img2}/tab_lt.jpg"></td>
                <td valign="bottom" background="${img2}/tab_ce.jpg" class="pl13">
                <!-- TAB MENU 시작 -->
                <jsp:useBean id="data_cnt" class="java.util.HashMap" scope="request"/>
                <%
                	//int tab_width = 565;
                	int tab_width = 0;
                	try{
	                	tab_width += (data_cnt.get("CNT_RESOURCE").toString().equals("0")?0:95);
	                	tab_width += (data_cnt.get("CNT_PROCESS").toString().equals("0")?0:95);
	                	tab_width += (data_cnt.get("CNT_SERVICE").toString().equals("0")?0:95);
	                	tab_width += (data_cnt.get("CNT_ICMP").toString().equals("0")?0:95);
	                	tab_width += (data_cnt.get("CNT_ACCESS").toString().equals("0")?0:95);
	                	tab_width += (data_cnt.get("CNT_CTI_CHANNEL").toString().equals("0")?0:95);
	                	tab_width += (data_cnt.get("CNT_IVR_CHANNEL").toString().equals("0")?0:95);
	                	tab_width += (data_cnt.get("CNT_FAX_CHANNEL").toString().equals("0")?0:95);
	                	tab_width += (data_cnt.get("CNT_REC_CHANNEL").toString().equals("0")?0:95);
	                	tab_width += (data_cnt.get("CNT_PBX_CHANNEL").toString().equals("0")?0:95);
                	}catch(Exception e){
	                	tab_width += 395;
                	}
                	//tab_width += 95;
                	tab_width += 90;
                %>
                <table width="<%=tab_width%>" border="0" cellspacing="0" cellpadding="0">
                    <tr id="tab">
                      <td width="90" height="30" align="center" background="${img2}/tab_off.jpg" class="b" ${data_cnt.CNT_RESOURCE==0?"style='display:none;'":""} style="cursor:pointer;">
                      	자원 <input type="hidden" name="tab_url" value="<c:url value='/watcher/go_server_detail.resource_usage.resource_usage.htm?req_data=lst;ResourceLstQry'/>">
                      </td>
                      <td width="5" ${data_cnt.CNT_RESOURCE==0?"style='display:none;'":""}>&nbsp;</td>
                      <td width="90" align="center" background="${img2}/tab_off.jpg" class="b" ${data_cnt.CNT_PROCESS==0?"style='display:none;'":""} style="cursor:pointer;">
                      	프로세스 <input type="hidden" name="tab_url" value="<c:url value='/watcher/go_server_detail.process_usage.process_usage.htm?req_data=lst;ProcessLstQry'/>">
                      </td>
                      <td width="5" ${data_cnt.CNT_PROCESS==0?"style='display:none;'":""}>&nbsp;</td>
                      <td width="90" align="center" background="${img2}/tab_off.jpg" class="b" ${data_cnt.CNT_SERVICE==0?"style='display:none;'":""} style="cursor:pointer;">
                      	서비스 <input type="hidden" name="tab_url" value="<c:url value='/watcher/go_server_detail.service_usage.service_usage.htm?req_data=lst;ServiceLstQry'/>">
                      </td>
                      <td width="5" ${data_cnt.CNT_SERVICE==0?"style='display:none;'":""}>&nbsp;</td>
                      <td width="90" align="center" background="${img2}/tab_off.jpg" class="b" ${data_cnt.CNT_ICMP==0?"style='display:none;'":""} style="cursor:pointer;">
                      	ICMP <input type="hidden" name="tab_url" value="<c:url value='/watcher/go_server_detail.icmp_usage.icmp_usage.htm?req_data=lst;IcmpLstQry'/>">
                      </td>
                      <td width="5" ${data_cnt.CNT_ICMP==0?"style='display:none;'":""}>&nbsp;</td>
                      <td width="90" align="center" background="${img2}/tab_off.jpg" class="b" ${data_cnt.CNT_ACCESS==0?"style='display:none;'":""} style="cursor:pointer;">
                      	Access Log <input type="hidden" name="tab_url" value="<c:url value='/watcher/go_server_detail.agent_mon.mon_access_log.htm'/>">
                      </td>
                      <td width="5" ${data_cnt.CNT_CTI_CHANNEL==0?"style='display:none;'":""}>&nbsp;</td>
                      <td width="90" align="center" background="${img2}/tab_off.jpg" class="b" ${data_cnt.CNT_CTI_CHANNEL==0?"style='display:none;'":""} style="cursor:pointer;">
                      	CTI채널현황 <input type="hidden" name="tab_url" value="<c:url value='/watcher/go_server_detail.cti_channel.cti_channel.htm'/>">
                      </td>
                      <td width="5" ${data_cnt.CNT_IVR_CHANNEL==0?"style='display:none;'":""}>&nbsp;</td>
                      <td width="90" align="center" background="${img2}/tab_off.jpg" class="b" ${data_cnt.CNT_IVR_CHANNEL==0?"style='display:none;'":""} style="cursor:pointer;">
                      	IVR채널현황 <input type="hidden" name="tab_url" value="<c:url value='/watcher/go_server_detail.ivr_channel.ivr_channel.htm'/>">
                      </td>
                      <td width="5" ${data_cnt.CNT_FAX_CHANNEL==0?"style='display:none;'":""}>&nbsp;</td>
                      <td width="90" align="center" background="${img2}/tab_off.jpg" class="b" ${data_cnt.CNT_FAX_CHANNEL==0?"style='display:none;'":""} style="cursor:pointer;">
                      	FAX채널현황 <input type="hidden" name="tab_url" value="<c:url value='/watcher/go_server_detail.fax_channel.fax_channel.htm'/>">
                      </td>
                      <td width="5" ${data_cnt.CNT_REC_CHANNEL==0?"style='display:none;'":""}>&nbsp;</td>
                      <td width="90" align="center" background="${img2}/tab_off.jpg" class="b" ${data_cnt.CNT_REC_CHANNEL==0?"style='display:none;'":""} style="cursor:pointer;">
                      	REC채널현황 <input type="hidden" name="tab_url" value="<c:url value='/watcher/go_server_detail.rec_channel.rec_channel.htm'/>">
                      </td>
                      <td width="5" ${data_cnt.CNT_PBX_CHANNEL==0?"style='display:none;'":""}>&nbsp;</td>
                      <td width="90" align="center" background="${img2}/tab_off.jpg" class="b" ${data_cnt.CNT_PBX_CHANNEL==0?"style='display:none;'":""} style="cursor:pointer;">
                      	PBX채널현황 <input type="hidden" name="tab_url" value="<c:url value='/watcher/go_server_detail.pbx_channel.pbx_channel.htm'/>">
                      </td>
                      <td width="5">&nbsp;</td>
                      <td width="90" align="center" background="${img2}/tab_off.jpg" class="b" style="cursor:pointer;">
                      	장애현황 <input type="hidden" name="tab_url" value="<c:url value='/watcher/go_server_detail.error_stats.error_stats_main.htm'/>">
                      </td>
                    </tr>
                  </table>
                  <!-- TAB MENU 끝 -->
                  </td>
                <td width="4"><img src="${img2}/tab_rt.jpg"></td>
              </tr>
         	</table>
         	<form name="frm_tab" method="post">
         		<input type="hidden" name="N_MON_ID" value="${param.N_MON_ID}">
         	</form>
         	<iframe name="ifm_svr_detail" src="" width="100%" height="450" frameborder="0" scrolling="yes" allowtransparency="true"></iframe>
            <!-- SUB TAB 끝 -->
            </td>
        </tr>
        <tr>
          <td colspan="3">&nbsp;</td>
        </tr>
      </table></td>
      </tr>
     </table>

           <object id="NEOLinkCtrl" style="LEFT: 0px; VISIBILITY: visible; TOP: 0px; Width:0px; Height:0px; "  codebase="${cab}/NeoLinkCtrl.cab#version=1,0,0,1" classid="clsid:2C7FAF28-06A4-423A-A4CB-F2853E8046CA" VIEWASTEXT></object>