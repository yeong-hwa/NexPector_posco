<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!--왼쪽영역-->
<div id="left">
	<!-- left 트리 구조  -->
	<script type="text/javascript">
		d = new dTree('d');
		<c:forEach items="${tree_data}" var="m" varStatus="vt">
		d.add('${m.N_GROUP_CODE}', '${m.N_UP_CODE}',
				'${m.S_GROUP_NAME}<span style="display:none;">${m.S_IMAGE_URL},${m.PARENT_CODE},${m.N_GROUP_CODE}</span>',
				'javascript:fn_tree_click(\'${m.N_GROUP_CODE}\');');
		</c:forEach>
		document.getElementById('left').innerHTML = d;

		var html = '';
		html += ' <ul class="watcher_banner_box"> ';
		
		//html += ' 	<li><button id="btn01" href="#" onclick="fn_jijumphone_click();" class="k-primary" style="height:45px; width:180px; font-size: 15px;  line-height: 25px; vertical-align:middle;">전국 전화기 현황</button></li> ';
		html += ' 	<li><button id="btn02" href="#" onclick="fn_dashboard_list(); return false;"  class="k-primary" style="height:45px; width:180px; font-size: 15px;  line-height: 25px; vertical-align:middle; margin-top: 15px;">대시보드 현황</button></li> ';
		html += ' </ul> ';

		document.getElementById('left').innerHTML = document.getElementById('left').innerHTML + html;
		$("#btn01").kendoButton();
		$("#btn02").kendoButton();
	</script>
</div>

<script type="text/javascript">
	// Left Menu Click
	function fn_tree_click(groupCode) {
		location.href = cst.contextPath() + '/watcher/realtime_stats/component/center_chart.htm?N_GROUP_CODE=' + groupCode;
	}

	function fn_jijumphone_click() {
		location.href = cst.contextPath() + '/watcher/realtime_stats/component/jijum_phone.htm';
	}

	/* dashboard 팝업 */
	function fn_dashboard_list(){
		location.href = cst.contextPath() + '/dashboard/dashboard_network_info.htm';
	}
	
</script>
<!--//왼쪽영역-->