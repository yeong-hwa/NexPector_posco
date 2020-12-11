<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/include.jsp" %>
<%@ taglib prefix="chart" uri="/WEB-INF/views/include/taglib/chart_tag.tld"%>

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td height="1" colspan="2" bgcolor="a8b9d7" ><img src="${img2}/dot.png"></td>
          </tr>
          <tr>
            <td height="2" colspan="2" bgcolor="cad3e2"><img src="${img2}/dot.png"></td>
          </tr>
          <tr>
            <td height="39"><img src="${img2}/comtit_04.png"></td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr>
            <td height="2" colspan="2" bgcolor="cad3e2"><img src="${img2}/dot.png"></td>
          </tr>
          <tr valign="top">
            <td width="200" height="176" colspan="2" align="center">
				<chart:chart height="175" bgcolor="FFFFFF" width="325" xmlpath="/watcher/go_realtime_stats.component.lately_halfyear_stats.lately_halfyear_chart.htm?N_GROUP_CODE=${param.N_GROUP_CODE}%26req_data=data;latelyHalfyearStatsQry"/>
			</td>
          </tr>
        </table>