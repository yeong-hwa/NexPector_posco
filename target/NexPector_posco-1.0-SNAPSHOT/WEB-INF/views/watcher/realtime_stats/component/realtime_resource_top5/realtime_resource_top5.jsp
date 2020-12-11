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
            <td height="39"><img src="${img2}/comtit_12.png"></td>
            <td align="right">&nbsp;</td>
          </tr>
          <tr>
            <td height="2" colspan="2" bgcolor="cad3e2"><img src="${img2}/dot.png"></td>
          </tr>
          <tr>
            <td height="176" colspan="2" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="313" height="20"><b style="padding-left:1px;">CPU</b></td>
                  <td width="313"><b style="padding-left:1px;">MEMORY</b></td>
                  <td width="313"><b style="padding-left:1px;">DISK</b></td>
                </tr>
                <tr>
                  <td height="136" align="center">
                  		<chart:chart height="150" bgcolor="FFFFFF" width="320" xmlpath="/watcher/go_realtime_stats.component.realtime_resource_top5.realtime_resource_top5_chart.htm?N_GROUP_CODE=${param.N_GROUP_CODE}%26req_data=data;realtimeResourceTop5%26N_MON_TYPE=0"/>
                  </td>
                  <td align="center">
                  		<chart:chart height="150" bgcolor="FFFFFF" width="320" xmlpath="/watcher/go_realtime_stats.component.realtime_resource_top5.realtime_resource_top5_chart.htm?N_GROUP_CODE=${param.N_GROUP_CODE}%26req_data=data;realtimeResourceTop5%26N_MON_TYPE=1"/>
                  </td>
                  <td align="center">
                  		<chart:chart height="150" bgcolor="FFFFFF" width="320" xmlpath="/watcher/go_realtime_stats.component.realtime_resource_top5.realtime_resource_top5_chart.htm?N_GROUP_CODE=${param.N_GROUP_CODE}%26req_data=data;realtimeResourceTop5%26N_MON_TYPE=2"/>
				  </td>
                </tr>
              </table></td>
          </tr>
        </table>