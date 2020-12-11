<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"   prefix="c"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles"  prefix="t"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%   
	response.setHeader("Cache-Control","no-store");   
	response.setHeader("Pragma","no-cache");   
	response.setDateHeader("Expires",0);   
	if (request.getProtocol().equals("HTTP/1.1"))
		response.setHeader("Cache-Control", "no-cache"); 
%>
<!DOCTYPE>
<html xmlns="<c:url value="http://www.w3.org/1999/xhtml"/>"/>
	<head>
		<title><s:message code="common.title"/></title>
		<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/web_common.css"/>" />
		<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/web_contents.css"/>" />
		<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/pagination.css"/>" />
		<link rel="stylesheet" type="text/css" href="<c:url value="/common/js/fullcalendar-1.5.4/fullcalendar/fullcalendar.css"/>" />
        <link rel="stylesheet" type="text/css" href="<c:url value="/common/js/jquery-ui/css/flick/jquery-ui-1.10.1.custom.min.css"/>" />
        <link rel="stylesheet" type="text/css" href="<c:url value="/common/js/jquery-ui/css/flick/jquery-ui-1.10.1.custom.min.css"/>" />
        <script type="text/javascript" src="<c:url value="/common/js/jquery/jquery-1.9.1.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/common/js/jquery/jquery.form.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/common/js/jquery/jquery.pagination.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/common/js/fullcalendar-1.5.4/fullcalendar/fullcalendar.min.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/common/js/jquery-ui/js/jquery-ui-1.10.1.custom.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/common/js/jquery-ui/js/jquery-ui-1.10.1.custom.min.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/common/js/swapimage.js"/>"></script>
        <script type="text/javascript" src="<c:url value="/common/js/commonUtil.js"/>"></script>
	</head>
	<body>
	    <div id="sub">
			<!-- top -->
			<div id="headerWrap" class="fix">
                <t:insertAttribute name="header" />
            </div>
			<!-- middle -->
			<div id="contentWrap">
                <div id="contents" class="fix">
                    <div class="leftWrap">
		                <t:insertAttribute name="left" />
		            </div>
		            <div class="rightWrap">
		            	<div id="subTitleDiv">
		                	<t:insertAttribute name="subTitle" />
		                </div>
		                <div id="rightDiv">
		                    <t:insertAttribute name="right" />
		                </div>
		            </div>
				</div>
			</div>
			<!-- bottom -->
			<div id="footerWrap">
			    <t:insertAttribute name="footer" />
			</div>
		</div>
	</body>
</html>