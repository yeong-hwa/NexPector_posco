<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="data" value="" />
<c:forEach begin="1" end="10" step="1" varStatus="vt">
	<c:choose>
	<c:when test="${10-lst.size() >= vt.count}">${data.value = '0' }</c:when>
	<c:otherwise>
		${lst.get(vt.count+lst.size()-1-10)}
	</c:otherwise>
	</c:choose>
</c:forEach>
