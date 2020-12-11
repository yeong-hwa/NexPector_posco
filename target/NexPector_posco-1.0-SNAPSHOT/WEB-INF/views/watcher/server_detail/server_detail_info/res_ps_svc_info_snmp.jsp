<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/include.jsp" %>>

<jsp:useBean id="p_s_info" class="java.util.HashMap" scope="request"/>

<script>
	$(function() {
		parent.fn_realtime_server_info($("#p_s_info").html());
	});
</script>

<div id="p_s_info">
			<table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9"><img src="${img2}/box_lt.png"></td>
                <td bgcolor="e9e9e9"><img src="${img2}/dot.png"></td>
                <td width="9" height="9"><img src="${img2}/box_rt.png"></td>
              </tr>
              <tr>
                <td bgcolor="e9e9e9">&nbsp;</td>
                <td height="96" bgcolor="e9e9e9" align="center"><!-- 장비 장애 현황 시작 -->
                  <table width="70" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="73" align="center" class="text11 b gray">장애</td>
                    </tr>
                    <tr>
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
