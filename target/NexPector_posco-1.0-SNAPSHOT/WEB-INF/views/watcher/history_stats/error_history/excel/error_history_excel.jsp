<%@ page language="java" contentType="application/vnd.ms-excel;charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:useBean id="data" class="java.util.ArrayList" scope="request"/>

<%
	String file_name = "Error_History_Report";
	String ExcelName  = new String(file_name.getBytes(),"UTF-8")+".xls";
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
		<td colspan="8"><h1>장애 이력 조회</h1></td>
	</tr>
</table>

<table border="1">
	<tr>
		<td colspan="8"><h3>검색기간  :  ${param.S_ST_DT }  ~  ${param.S_ED_DT}</h3></td>
	</tr>
	<tr>
		<td colspan="8"><h3>장애등급  :  ${param.ALM_RATING_NAME}</h3></td>		
	</tr>
	<tr>
		<td colspan="8"><h3>서버그룹 / 서버명  : ${param.SERVER_GROUP}  /  ${param.SERVER_TYPE_NAME}</h3></td>
	</tr>
	<tr>
		<td colspan="8"><h3>수신자  :  ${param.USER_NAME}</h3></td>
	</tr>
</table>
<br><br>
                  <table width="900" border="1" cellspacing="0" cellpadding="0">
                    <tr align="center" style="background: #6e7275">
                      <td width="15%">발생시각</td>
                      <td width="10%">장비명</td>
                      <td width="10%">장비IP</td>
                      <td width="8%">장애등급</td>
                      <td width="8%">상태</td>
                      <td width="10%">처리자ID</td>
                      <td width="10%">처리자</td>
                      <td width="30%">내용</td>
                    </tr>
                <c:forEach items="${data}" var="m">
                	<tr  align="center">
                      <td height="31" class="line_gray text11">${m.D_UPDATE_TIME}</td>
                      <td height="31" class="line_gray text11">${m.S_MON_NAME}</td>
                      <td height="31" class="line_gray text11">${m.S_MON_IP}</td>
                      <td height="31" class="line_gray text11">${m.S_ALM_RATING_NAME}</td>
                      <td height="31" class="line_gray text11">${m.N_ALM_STATUS_NAME}</td>
                      <td height="31" class="line_gray text11">${m.S_USER_ID}</td>
                      <td height="31" class="line_gray text11">${m.S_USER_NAME}</td>
                      <td height="31" class="line_gray text11">${m.S_MSG}</td>
                    </tr>
                </c:forEach>
                  </table>