<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
    <div class="breadcrumb">
    	<a href="<c:url value='main.htm'/>">Home</a> > <c:out value="${CURR_MENU_NM }" /> > <strong><c:out value="${CURR_SUBMENU_NM }" /></strong>
    </div>
    <h2><c:out value="${CURR_SUBMENU_NM }" /></h2>
</body>
</html>