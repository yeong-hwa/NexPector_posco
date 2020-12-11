<%@ page language="java" contentType="application/vnd.ms-excel;charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:useBean id="serverInfo" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="errorInfo" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="callInfo" class="java.util.ArrayList" scope="request"/>
<%
    String file_name = "Resoruce_History_Report";
    String ExcelName = new String(file_name.getBytes(), "UTF-8") + ".xls";
    response.setContentType("application/vnd.ms-excel;charset=utf-8");
    response.setHeader("Content-Transfer-Encoding", "binary;");
    response.setHeader("Content-Disposition", "attachment; filename=" + ExcelName);
    response.setHeader("Pragma", "no-cache");
%>

<html>
<head>
<meta http-equiv="Content-Type" content="application/vnd.ms-excel;charset=utf-8">
	<title></title>
</head>
<body>
<table width="1000" border="1">
    <tr align="center">
        <td colspan="8"><h1>일일보고서</h1></td>
    </tr>
    <tr>
        <td colspan="8"><h3>검색일자 : ${param.S_ST_DT }</h3></td>
    </tr>
<%--     <tr>
        <td colspan="8"><h3>표시방법 : ${param.REPORT_GUBUN}</h3></td>
    </tr> --%>
</table>
<br><br>



	<c:if test="${not empty serverInfo}">
		<table width="900" border="1" cellspacing="0" cellpadding="0">
			<tr align="center">
				<td colspan="8"><h3>서버정보</h3></td>
			</tr>
		    <tr align="center" style="background: #6e7275">
		        <td width="20%" height="34"><b>서버명</b></td>
		        <td width="20%"><b>IP Address</b></td>
		        <td width="20%" colspan="2"><b>CPU(평균/최대)</b></td>
		        <td width="20%" colspan="2"><b>Memory(평균/최대)</b></td>
		        <td width="20%" colspan="2"><b>Disk(평균/최대)</b></td>
		    </tr>
			
			<c:forEach items="${serverInfo}" var="serverInfo">
		    <tr align="center">
		        <td height="31" align="left">${serverInfo.S_MON_NAME}</td>
		        <td height="31">${serverInfo.S_MON_IP}</td>
		        <td height="31" colspan="2">${serverInfo.CPU}</td>
		        <td height="31" colspan="2">${serverInfo.MEM}</td>
		        <td height="31" colspan="2">${serverInfo.DISK}</td>
		    </tr>
		    </c:forEach>
		</table>
	</c:if>
	<c:if test="${empty serverInfo}">
		<table width="900" border="1" cellspacing="0" cellpadding="0">
			<tr align="center">
				<td colspan="8"><h3>서버정보</h3></td>
			</tr>
		    <tr align="center" style="background: #6e7275">
		        <td width="20%" height="34"><b>서버명</b></td>
		        <td width="20%"><b>IP Address</b></td>
		        <td width="20%" colspan="2"><b>CPU(평균/최대)</b></td>
		        <td width="20%" colspan="2"><b>Memory(평균/최대)</b></td>
		        <td width="20%" colspan="2"><b>Disk(평균/최대)</b></td>
		    </tr>

		    <tr align="center">
		        <td height="31" colspan="8"><b>데이터가 존재 하지 않습니다.</b></td>
		    </tr>
		</table>
	</c:if>

<br><br>

	<c:if test="${not empty errorInfo}">
		<table width="900" border="1" cellspacing="0" cellpadding="0">
			<tr align="center">
				<td colspan="8"><h3>장애이력</h3></td>
			</tr>
		    <tr align="center" style="background: #6e7275">
		        <td width="10%" height="34"><b>발생시각</b></td>
		        <td width="10%"><b>장비명</b></td>
		        <td width="10%"><b>장비IP</b></td>
		        <td width="10%"><b>장애등급</b></td>
		        <td width="10%"><b>상태</b></td>
		        <td width="10%"><b>처리자ID</b></td>
		        <td width="10%"><b>처리자</b></td>
		        <td width="30%"><b>내용</b></td>
		        
		    </tr>
			
			<c:forEach items="${errorInfo}" var="errorInfo">
		    <tr align="center">
		        <td height="31" align="left">${errorInfo.D_UPDATE_TIME}</td>
		        <td height="31">${errorInfo.S_MON_NAME}</td>
		        <td height="31">${errorInfo.S_MON_IP}</td>
		        <td height="31">${errorInfo.S_ALM_RATING_NAME}</td>
		        <td height="31">${errorInfo.N_ALM_STATUS_NAME}</td>
		        <td height="31">${errorInfo.S_USER_ID}</td>
		        <td height="31">${errorInfo.S_USER_NAME}</td>
		        <td height="31">${errorInfo.S_MSG}</td>
		    </tr>
		    </c:forEach>
		</table>
	</c:if>
	<c:if test="${empty errorInfo}">
		<table width="900" border="1" cellspacing="0" cellpadding="0">
			<tr align="center">
				<td colspan="8"><h3>장애이력</h3></td>
			</tr>
		    <tr align="center" style="background: #6e7275">
		        <td width="10%" height="34"><b>발생시각</b></td>
		        <td width="10%"><b>장비명</b></td>
		        <td width="10%"><b>장비IP</b></td>
		        <td width="10%"><b>장애등급</b></td>
		        <td width="10%"><b>상태</b></td>
		        <td width="10%"><b>처리자ID</b></td>
		        <td width="10%"><b>처리자</b></td>
		        <td width="30%"><b>내용</b></td>
		        
		    </tr>
		    <tr align="center">
		        <td height="31" colspan="8"><b>데이터가 존재 하지 않습니다.</b></td>
		    </tr>
		</table>
	</c:if>

<br><br>

	<c:if test="${not empty callInfo}">
		<table width="900" border="1" cellspacing="0" cellpadding="0">
			<tr align="center">
				<td colspan="8"><h3>콜통계</h3></td>
			</tr>
		    <tr align="center" style="background: #6e7275">
		        <td width="34%" colspan="4" height="34"><b>부서명</b></td>
		        <td width="33%" colspan="2"><b>inbound</b></td>
		        <td width="33%" colspan="2"><b>outbound</b></td>
		    </tr>
			
			<c:forEach items="${callInfo}" var="callInfo">
		    <tr align="center">
		        <td height="31" colspan="4" align="left">${callInfo.BRANCH_NAME}</td>
		        <td height="31" colspan="2">${callInfo.OUTBOUND}</td>
		        <td height="31" colspan="2">${callInfo.INBOUND}</td>
		    </tr>
		    </c:forEach>
		</table>
	</c:if>
	<c:if test="${empty callInfo}">
		<table width="900" border="1" cellspacing="0" cellpadding="0">
			<tr align="center">
				<td colspan="8"><h3>콜통계</h3></td>
			</tr>
		    <tr align="center" style="background: #6e7275">
		        <td width="34%" colspan="4" height="34"><b>부서명</b></td>
		        <td width="33%" colspan="2"><b>inbound</b></td>
		        <td width="33%" colspan="2"><b>outbound</b></td>
		    </tr>
		    <tr align="center">
		        <td height="31" colspan="8"><b>데이터가 존재 하지 않습니다.</b></td>
		    </tr>
		</table>
	</c:if>

</body>
</html>