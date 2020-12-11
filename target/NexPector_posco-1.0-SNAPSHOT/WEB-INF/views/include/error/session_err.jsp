<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>

<script type="text/javascript">
	alert("세션 정보가 존재 하지 않습니다.");
	location.href="<%=request.getContextPath()%>/login.htm";
</script>