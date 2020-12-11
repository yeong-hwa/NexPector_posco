<%@ page language="java" contentType="application/vnd.ms-excel;charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:useBean id="serverInfo" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="errorInfo" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="callInfo" class="java.util.ArrayList" scope="request"/>
<html>
<head>
<meta http-equiv="Content-Type" content="application/vnd.ms-excel;charset=utf-8">
<%
    String file_name = "Resoruce_History_Report";
    String ExcelName = new String(file_name.getBytes(), "UTF-8") + ".xls";
    response.setContentType("application/vnd.ms-excel;charset=utf-8");
    response.setHeader("Content-Transfer-Encoding", "binary;");
    response.setHeader("Content-Disposition", "attachment; filename=" + ExcelName);
    response.setHeader("Pragma", "no-cache");
%>

	<title></title>
</head>
<body>
<table width="1000" border="1">
    <tr align="center">
        <td colspan="11"><h1>일일보고서</h1></td>
    </tr>
    <tr>
        <td colspan="11"><h3>검색일자 : 
        <c:choose>
				<c:when test="${params.R_TYPE eq 1}">${params.T_ST_DT } ~ ${params.T_ED_DT }</c:when>
				<c:when test="${params.R_TYPE eq 2}">${fn:substring(params.S_ST_DT,0,7) }</c:when>
				<c:otherwise>${params.S_ST_DT }</c:otherwise>
		</c:choose></h3></td>
    </tr>
      <tr>
        <td colspan="11"><h3>보고서 구분 : 
        <c:choose>
				<c:when test="${params.R_TYPE eq 1}">주간보고서</c:when>
				<c:when test="${params.R_TYPE eq 2}">월간보고서</c:when>
				<c:otherwise>일일보고서</c:otherwise>
		</c:choose>
		</h3>
        </td>
    </tr> 
    
<%--     <tr>
        <td colspan="8"><h3>표시방법 : ${param.REPORT_GUBUN}</h3></td>
    </tr> --%>
</table>
<br><br>
	<table width="900" border="1" cellspacing="0" cellpadding="0">
			<tr align="center">
				<th scope="col" colspan="11"><h3>서버정보</h3></th>
			</tr>
		    <tr align="center" style="background: #6e7275">
		        <th scope="col" width="10%" height="34"><b>그룹</b></td>
		        <th scope="col" width="10%" ><b>구분</b></td>
		        <th scope="col"  width="15%" ><b>장비명</b></th>
		        <th scope="col" width="15%"><b>IP Address</b></th>
	        	<th scope="col" width="10%" ><b>자원</b></th>
		        <th scope="col" width="5%" ><b>현재값(%)</b></th>
		        <th scope="col" width="5%" ><b>평균값(%)</b></th>
		        <th scope="col" width="5%"><b>피크(%)</b></th>
		        <th scope="col" width="15%"><b>피크 일시</b></th>
		        <th scope="col" width="5%"><b>전 (일/주/월) 평균</b></th>
		        <th scope="col" width="5%"><b>증감</b></th>
		    </tr>
			<c:choose>
				<c:when test="${not empty serverInfo}">
					<c:forEach items="${serverInfo}" var="serverInfo">
					    <tr align="center">
					        <td scope="row" height="31" align="left">${serverInfo.S_GROUP_NAME}</td>
					        <td scope="row" >${serverInfo.S_TYPE_NAME}</td>
						    <td scope="row" >${serverInfo.S_MON_NAME}</td>
						    <td>${serverInfo.S_MON_IP}</td>
						    <td>${serverInfo.S_MAP_NAME}</td>
						    <td>${serverInfo.N_CUR_USE}</td>
						    <td>${serverInfo.N_AVG_USE}</td>
							<td>${serverInfo.N_MAX_USE}</td>
							<td>${serverInfo.D_MAX_DATE}</td>
							<td>${serverInfo.PRE_AVG_USE}</td>
							<td>${serverInfo.INCREASE}</td>
					    </tr>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<tr align="center">
						<td height="31" colspan="11"><b>데이터가 존재 하지 않습니다.</b></td>
					</tr>
				</c:otherwise>
			</c:choose>
		</table>
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
</body>
</html>