<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/button.css"/>"/>
<script>
	alert("<s:message code="system.error403.message"/>");
</script>
<div style="margin-top: 13%;" align="center"">
	<img src="<c:url value="/images/error/403.jpg"/>">
	<div style="color:#252525; font-size:18px;font-family:Tahoma, gotham, 고딕;text-shadow:2px 2px 2px #D3D3D3;font-weight:bold; position:relative; top:-40px; left:80px">
		<s:message code="system.error403.message"/>
	</div>
	<div style="position:relative; top:-20px; left:40px">
		<span class="button medium icon"  onclick="parent.location='<c:url value="/logout.htm"/>'" ><span class="round_red"></span><button type="button"><s:message code="system.error403.goLogin"/></button></span>
	</div>
</div>