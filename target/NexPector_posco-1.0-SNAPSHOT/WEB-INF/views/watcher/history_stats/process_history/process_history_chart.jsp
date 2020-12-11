<%@page import="java.util.Enumeration"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/include.jsp" %>
<%@ taglib prefix="chart" uri="/WEB-INF/views/include/taglib/chart_tag.tld"%>

<script>
	$(function() {
		$("#btn_list,#btn_chart,#btn_excel").css("cursor", "hand");
		
		$("#btn_list").click(function() {
			parent.fn_list();
		});
		
		$("#btn_chart").click(function() {
			parent.fn_chart();
		});
		
		$("#btn_excel").click(function() {
			parent.fn_excel();
		});
	});
</script>
<%
	Enumeration en = request.getParameterNames();

	String param = "";
	while(en.hasMoreElements())
	{
		String p_name = (String)en.nextElement();
		param += p_name;
		param += "=" + request.getParameter(p_name);
		param += "%26";
	}
%>
<body style="background:transparent;">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
           <tr>
                <td width="4"><img src="${img2}/tab_lt.jpg"></td>
                <td align="right" background="${img2}/tab_ce.jpg" class="pl13"><table width="200" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td align="right">
                      	<img id="btn_list" src="${img2}/chart_table_on.jpg" hspace="8"/><img id="btn_chart" src="${img2}/chart_chart_off.jpg"/><img id="btn_excel" src="${img2}/btn_excel.jpg" hspace="15"/>
                      </td>
                    </tr>
                  </table></td>
                <td width="4"><img src="${img2}/tab_rt.jpg"></td>
              </tr>
              <tr>
                <td background="${img2}/tab_lc.jpg">&nbsp;</td>
                <td bgcolor="#FFFFFF" style="padding:15px 20px 20px 20px"><!-- 콜 이력 조회 시작 -->
					<c:set var="req_param" value="<%=param%>"/>
					<chart:chart height="515" bgcolor="#FFFFFF" width="930" xmlpath="/watcher/go_history_stats.process_history.process_history_chart_data.htm?req_data=data;ProcessHistoryRetrieveQry%26${req_param}"/>
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