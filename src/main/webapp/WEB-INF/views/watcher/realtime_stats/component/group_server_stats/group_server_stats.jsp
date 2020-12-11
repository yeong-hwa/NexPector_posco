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
            <td height="39"><img src="${img2}/comtit_07.png"></td>
            <td align="right"><img src="${img2}/comtit_so01.jpg"></td>
          </tr>
          <tr>
            <td height="2" colspan="2" bgcolor="cad3e2"><img src="${img2}/dot.png"></td>
          </tr>
        </table>
        <div  style="overflow-y:auto;height:390px;">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td colspan="2" align="center" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
            	<c:forEach items="${svrlst}" var="m">
	            	<tr>
	                  <td width="70" class="pl10 b">${m.S_GROUP_NAME}</td>
	                  <td height="125" align="center">
						<table width="85%" height="100%">
		            		<tr valign="top">
		            			<td align="center">
		            				<chart:chart height="85" bgcolor="#FFFFFF" width="73" xmlpath="/component.group_server_chart1.neonex?N_GROUP_CODE=${m.N_GROUP_CODE}"/>            				
		            			</td>
		            			<td>
		            				<chart:chart height="85" bgcolor="#FFFFFF" width="53" xmlpath="/component.group_server_chart1.neonex?N_GROUP_CODE=${m.N_GROUP_CODE}%26N_STYLE_CODE=0"/>
		            			</td>
		            			<td>
		            				<chart:chart height="85" bgcolor="#FFFFFF" width="53" xmlpath="/component.group_server_chart1.neonex?N_GROUP_CODE=${m.N_GROUP_CODE}%26N_STYLE_CODE=1"/>
		            			</td>
		            			<td>
		            				<chart:chart height="85" bgcolor="#FFFFFF" width="53" xmlpath="/component.group_server_chart1.neonex?N_GROUP_CODE=${m.N_GROUP_CODE}%26N_STYLE_CODE=2"/>
		            			</td>
		            		</tr>
		            		<tr valign="top">
		            			<td align="center">
		            				<b style="font-size: 15px;">전체</b>
		            			</td>
		            			<td align="center">
		            				<b style="font-size: 15px;">Agent</b>
		            			</td>
		            			<td align="center">
		            				<b style="font-size: 15px;">ICMP</b>
		            			</td>
		            			<td align="center">
		            				<b style="font-size: 15px;">SNMP</b>
		            			</td>
		            	</table> 
	                  </td>
	                </tr>
            	</c:forEach>                
              </table></td>
          </tr>
        </table>
        </div>