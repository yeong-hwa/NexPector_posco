<%@ page language="java" contentType="application/vnd.ms-excel;charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:useBean id="data" class="java.util.ArrayList" scope="request" />
<%
	String file_name = "Phone_Error_History_Report";
	String ExcelName = new String(file_name.getBytes(),"UTF-8") + ".xls";
	response.setContentType("application/vnd.ms-excel;charset=utf-8");
	response.setHeader("Content-Transfer-Encoding", "binary;");
	response.setHeader("Content-Disposition", "attachment; filename="+ExcelName);
	response.setHeader("Pragma", "no-cache");
%>
<meta http-equiv="Content-Type" content="application/vnd.ms-excel;charset=utf-8">
<style>
	.text11 {font-size:11px }
	.gray {color:#6e7275 }
	.b { font-weight:bold }
	.line_gray { border-bottom:1px solid #eeeeee; }
	.pl13 {padding-left:13px }
</style>
<table width="1000" border=1>
	<tr align="center">
		<td colspan="8"><h1>전화기 장애 이력 조회</h1></td>
	</tr>
</table>
<table border="1">
	<tr>
		<td colspan="8"><h3>검색기간  :  ${param.S_ST_DT }  ~  ${param.S_ED_DT}</h3></td>
	</tr>
	<tr>
		<td colspan="8"><h3>지역  :  ${param.S_LOCATION}</h3></td>		
	</tr>
</table>
<br><br>
<table width="900" border="1" cellspacing="0" cellpadding="0">
	<tr align="center" style="background: #6e7275">
		<td width="15%">발생시각</td>
		<td width="10%">상태</td>
		<td width="10%">지역</td>
		<td width="8%">지점명</td>
		<td width="8%">러닝명</td>
		<td width="10%">IP Address</td>
		<td width="10%">전화번호</td>
		<td width="30%">미표시기간</td>
	</tr>
	<c:forEach items="${data}" var="m">
	<tr align="center">
		<td height="31" class="line_gray text11">${m.D_UPDATE_TIME}</td>
		<td height="31" class="line_gray text11">${m.S_ALM_STATUS_NAME}</td>
		<td height="31" class="line_gray text11">${m.S_LOCATION}</td>
		<td height="31" class="line_gray text11">${m.S_NAME}</td>
		<td height="31" class="line_gray text11">${m.S_RUNNING}</td>
		<td height="31" class="line_gray text11">${m.S_IP_ADDRESS}</td>
		<td height="31" class="line_gray text11">${m.S_EXT_NUM}</td>
		<td height="31" class="line_gray text11">${m.D_SKIP_TIME}</td>
	</tr>
	</c:forEach>
</table>