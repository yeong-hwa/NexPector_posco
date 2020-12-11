<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/include.jsp" %>
<%@ taglib prefix="chart" uri="/WEB-INF/views/include/taglib/chart_tag.tld"%>

<jsp:useBean id="svr_type" class="java.util.ArrayList" scope="request"/>

				<table width="100%" border="0" cellspacing="0" cellpadding="0">
		          <tr>
		            <td height="1" colspan="2" bgcolor="a8b9d7" ><img src="${img2}/dot.png"></td>
		          </tr>
		          <tr>
		            <td height="2" colspan="2" bgcolor="cad3e2"><img src="${img2}/dot.png"></td>
		          </tr>
		          <tr>
		            <td height="39"><img src="${img2}/comtit_01.png"></td>
		            <td align="right"><img src="${img2}/comtit_so01.jpg"></td>
		          </tr>
		          <tr>
		            <td height="2" colspan="2" bgcolor="cad3e2"><img src="${img2}/dot.png"></td>
		          </tr>
		          <tr>
		            <td height="100" colspan="2" valign="top">
		            	<table width="100%" height="100%">
		            		<tr valign="top">
		            			<td align="center" colspan="4">
		            				<chart:chart height="155" bgcolor="#FFFFFF" width="${(101 * svr_type.size()) + (303 - (101 * (svr_type.size() % 3)))}" xmlpath="/watcher/go_realtime_stats.component.all_server_stats.all_chart_type.htm?N_GROUP_CODE=${param.N_GROUP_CODE}%26req_data=data;serverStatusQry|svr_style;compo_svr_style|svr_type;compo_svr_type"/>
		            			</td>
		            		</tr>
		            	</table>
		            </td>
		          </tr>
		        </table>



