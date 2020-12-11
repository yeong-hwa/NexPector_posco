<%@ page language="java" contentType="application/vnd.ms-excel;charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<meta http-equiv="Content-Type" content="application/vnd.ms-excel;charset=utf-8">
<%
    String file_name = "IP_Phone_Status_Report";
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
        <td colspan="11"><h1>IP-Phone 현황</h1></td>
    </tr>
    <tr>
        <td colspan="11"><h3>전화번호: ${param.search_phone }</h3></td>
    </tr>
      <tr>
        <td colspan="11"><h3>IP Address : ${param.ip_address }</h3></td>
    </tr> 
      <tr>
        <td colspan="11"><h3>전화기 상태 : ${param.phone_state }</h3></td>
    </tr> 
</table>
<br><br>
	<table width="900" border="1" cellspacing="0" cellpadding="0">
		    <tr align="center" style="background: #6e7275">
		        <th scope="col" width="20%" height="34"><b>전화기명</b></td>
		        <th scope="col" width="20%" ><b>내선번호</b></td>	
		        <th scope="col" width="20%"><b>IP Address</b></th>
	        	<th scope="col" width="10%" ><b>전화기 상태</b></th>
		        <th scope="col" width="10%" ><b>Reason Code</b></th>
		        <th scope="col" width="20%" ><b>Description</b></th>
		    </tr>
			<c:choose>
				<c:when test="${not empty resultList}">
					<c:forEach items="${resultList}" var="item">
					    <tr align="center">
					        <td scope="row" height="31" align="left">${item.NAME}</td>
					        <td scope="row" >${item.DIRECTNUM1}</td>
						    <td scope="row" >${item.IPADDRESS1}</td>
						    <td>${item.STATUS}</td>
						    <td>${item.STATUSREASON}</td>
						    <td>${item.DESCRIPTION}</td>
					    </tr>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<tr align="center">
						<td height="31" colspan="6"><b>데이터가 존재 하지 않습니다.</b></td>
					</tr>
				</c:otherwise>
			</c:choose>
		</table>
</body>
</html>