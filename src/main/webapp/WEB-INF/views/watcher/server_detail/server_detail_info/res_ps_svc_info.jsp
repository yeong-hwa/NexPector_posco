<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/include.jsp" %>

<jsp:useBean id="p_s_info" class="java.util.HashMap" scope="request"/>
<jsp:useBean id="cpu_info" class="java.util.HashMap" scope="request"/>
<jsp:useBean id="mem_info" class="java.util.HashMap" scope="request"/>
<jsp:useBean id="disk_info" class="java.util.HashMap" scope="request"/>

<script>
	$(function() {
		parent.fn_realtime_server_info($("#p_s_info").html(), $("#resource_info").html());
	});
</script>

<div id="p_s_info">
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
                            <td class="text11 b bblue">${p_s_info.PROCESS_CNT}</td>
                            <td></td>
                            <td class="text11 b red">${p_s_info.PROCESS_ERR_CNT}</td>
                          </tr>
                          <tr>
                          	<%
                          		float p_cnt = 0;
                          		float p_err_cnt = 0;
                          		
                          		if(p_s_info.get("PROCESS_CNT") != null) p_cnt = Integer.parseInt(p_s_info.get("PROCESS_CNT").toString());
                          		if(p_s_info.get("PROCESS_ERR_CNT") != null) p_err_cnt = Integer.parseInt(p_s_info.get("PROCESS_ERR_CNT").toString());
                          		
                          		p_cnt *= 1.0;
                          		p_err_cnt *= 1.0;
                          		
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
                          	%>
                            <td valign="bottom"><img src="${img2}/g_blue.jpg" width="9" height="<%=p_cnt%>"></td>
                            <td>&nbsp;</td>
                            <td valign="bottom"><img src="${img2}/g_red.jpg" width="9" height="<%=p_err_cnt%>"></td>
                          </tr>
                        </table>
                        <!-- 개별 그래프 끝 --></td>
                      <td align="center"  valign="bottom" background="${img2}/server_graph.jpg"><!-- 개별 그래프 시작 -->
                        <table width="38" border="0" cellspacing="0" cellpadding="0">
                          <tr>
                          	<%
                          		float s_cnt = 0;
                          		float s_err_cnt = 0;
                          		
                          		if(p_s_info.get("SERVICE_CNT") != null) s_cnt = Integer.parseInt(p_s_info.get("SERVICE_CNT").toString());
                          		if(p_s_info.get("SERVICE_ERR_CNT") != null) s_err_cnt = Integer.parseInt(p_s_info.get("SERVICE_ERR_CNT").toString());
                          		
                          		s_cnt *= 1.0;
                          		s_err_cnt *= 1.0;
                          		
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
                          	%>
                            <td class="text11 b bblue">${p_s_info.SERVICE_CNT}</td>
                            <td></td>
                            <td class="text11 b red">${p_s_info.SERVICE_ERR_CNT}</td>
                          </tr>
                          <tr>
                            <td valign="bottom"><img src="${img2}/g_blue.jpg" width="9" height="<%=s_cnt%>"></td>
                            <td>&nbsp;</td>
                            <td valign="bottom"><img src="${img2}/g_red.jpg" width="9" height="<%=s_err_cnt%>"></td>
                          </tr>
                        </table>
                        <!-- 개별 그래프 끝 --></td>
                      <td height="55" align="center"  valign="bottom" background="${img2}/server_graph.jpg"><!-- 개별 그래프 시작 -->
                        <table width="38" border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td class="text11 b red">${p_s_info.CRITICAL_ERR_CNT}</td>
                            <td></td>
                            <td class="text11 b red">${p_s_info.MAJOR_ERR_CNT}</td>
                            <td></td>
                            <td class="text11 b red">${p_s_info.MINOR_ERR_CNT}</td>
                          </tr>
                            <%
                          		float cri_cnt = 0;
                          		float maj_cnt = 0;
                          		float min_cnt = 0;
                          		
                          		if(p_s_info.get("CRITICAL_ERR_CNT") != null) cri_cnt = Integer.parseInt(p_s_info.get("CRITICAL_ERR_CNT").toString());
                          		if(p_s_info.get("MAJOR_ERR_CNT") != null) maj_cnt = Integer.parseInt(p_s_info.get("MAJOR_ERR_CNT").toString());
                          		if(p_s_info.get("MINOR_ERR_CNT") != null) min_cnt = Integer.parseInt(p_s_info.get("MINOR_ERR_CNT").toString());
                          		
                          		cri_cnt *= 1.0;
                          		maj_cnt *= 1.0;
                          		min_cnt *= 1.0;
                          		
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
                          	%>
                          <tr>
                            <td valign="bottom"><img src="${img2}/g_red.jpg" width="9" height="<%=cri_cnt%>"></td>
                            <td>&nbsp;</td>
                            <td valign="bottom"><img src="${img2}/g_red.jpg" width="9" height="<%=maj_cnt%>"></td>
                            <td>&nbsp;</td>
                            <td valign="bottom"><img src="${img2}/g_red.jpg" width="9" height="<%=min_cnt%>"></td>
                          </tr>
                        </table>
                        <!-- 개별 그래프 끝 --></td>
                    </tr>
                    <tr>
                      <td height="18" align="center"  class="text11 b gray">등록 장애</td>
                      <td align="center" class="text11 b gray">등록 장애</td>
                      <td height="18" align="center"   class="text11 b gray">상 중 하</td>
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


<div id="resource_info">
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
                <%
                	String[] cpu = {"0","0","0"};
                	String[] mem = {"0","0","0"};
                	String[] disk = {"0","0","0"};
                
                	//for(int i=0;i<resource_info.size();i++)
                	//{
                		//java.util.HashMap m = (java.util.HashMap)resource_info.get(i);
                		if(cpu_info.get("S_KEY") != null)
                		{
                			cpu[0] = cpu_info.get("N_FULL_SIZE").toString();
                			cpu[1] = cpu_info.get("N_NOW_USE").toString();
                			cpu[2] = cpu_info.get("N_PER_USE").toString();
                		}
                		if(mem_info.get("S_KEY") != null)
                		{
                			mem[0] = mem_info.get("N_FULL_SIZE").toString();
                			mem[1] = mem_info.get("N_NOW_USE").toString();
                			mem[2] = mem_info.get("N_PER_USE").toString();
                		}
                		if(disk_info.get("S_KEY") != null)
                		{
                			disk[0] = disk_info.get("N_FULL_SIZE").toString();
                			disk[1] = disk_info.get("N_NOW_USE").toString();
                			disk[2] = disk_info.get("N_PER_USE").toString();
                		}
                	//}
                	//System.out.println(cpu_info + "-" + AppData.REALTIME_PROCESS_SERVICE_STATS_LOCK);
                %>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="35" class="text11 b gray">CPU</td>
                      <td width="190" height="33" background="${img2}/server_cpu.jpg"><!--개별 막대그래프 시작-->
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td width="94"><img src="${img2}/g_wblue.jpg" width="<%=Integer.parseInt(cpu[2])*2%>%" height="20"></td>
                            <td align="right"  class="text11 b ggray pr5"><span style="background-color:#FFFFFF;"><%=cpu[1]%>/<%=cpu[0]%>%</span></td>
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
                            <td width="94"><img src="${img2}/g_wblue.jpg" width="<%=Integer.parseInt(mem[2])*2%>%" height="20"></td>
                            <td align="right"  class="text11 b ggray pr5"><span style="background-color:#FFFFFF;"><%=mem[1]%>/<%=mem[0]%>MB</span></td>
                          </tr>
                        </table>
                        <!--개별 막대그래프 끝--></td>
                    </tr>
                    <tr>
                      <td class="text11 b gray">DISK</td>
                      <td height="33" background="${img2}/server_cpu.jpg"><!--개별 막대그래프 시작-->
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td width="94"><img src="${img2}/g_wblue.jpg" width="<%=Integer.parseInt(disk[2])*2%>%" height="20"></td>
                            <td align="right"  class="text11 b ggray pr5"><span style="background-color:#FFFFFF;"><%=disk[1]%>/<%=disk[0]%>MB</span></td>
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
