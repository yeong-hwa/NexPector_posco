<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/include.jsp" %>

<jsp:useBean id="cpu_info" class="java.util.HashMap" scope="request"/>
<jsp:useBean id="mem_info" class="java.util.HashMap" scope="request"/>
<jsp:useBean id="disk_info" class="java.util.HashMap" scope="request"/>

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
