<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript">
	$(document).ready(function () {
		Initialize();
	});
	
	function Initialize() {
		var param = {'N_GROUP_CODE' : '${param.N_GROUP_CODE}', 'N_MON_ID' : '${param.N_MON_ID}', pageNum : '${param.pageNum}', tabStrip : '${param.tabStrip}'};
		$('#leftNv_Area2').load(cst.contextPath() + '/watcher/server_detail/left.htm', $.param(param));
	}

</script>

<!-- left nv -->
<div id="leftNv_Area2" class="leftNv_Area2"></div>
<!-- left nv // -->

<!-- contents box -->
<div id="contentsbox_Area" class="contentsbox_Area">
	<div class="c_start" id="c_start">
	</div>
</div>
<!-- contents box // -->