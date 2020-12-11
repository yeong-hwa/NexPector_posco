<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript">
	var now_page = 'compo', // 현재페이지 component or map
		frm = document.frm,
		img_url,
		full_grp_code,
		grp_code;

	// Document Ready
	$(document).ready(function () {
		initialize();
	});

	// 초기화
	function initialize() {
		var url 	= cst.contextPath() + '/watcher/realtime_stats/left.htm',
			param	= { 'req_data' : 'tree_data;watcher_main.TreeSvrGroupQry' };

		$('#leftNv_Area').load(url, $.param(param), function () {
			// 초기 화면 선택
			$('.dTreeNode').eq(0).children('a').click();
			eval($('.dTreeNode').eq(0).children('a').attr('href'));
		});
	}

	function fn_stats_screen() {
		now_page = 'compo';
		$('#n_group_code').val(grp_code);

		var url = cst.contextPath() + '/ajax/watcher/realtime_stats/component/component_screen.htm';

		$('#contents').load(url, $('#frm').serialize());
	}

	function fn_map_screen() {
		now_page = 'map';
		frm.N_GROUP_CODE.value = grp_code;
		frm.S_GROUP_FULL_CODE.value = full_grp_code;

		frm.target = 'ifm_sub';
		frm.action = 'realtime_stats.map.neonex';
		frm.submit();
	}

	// Left Menu Click
	function fn_tree_click(obj) {
		$("#browser li a").css("font", "normal");
		$(obj).css("font", "bold");

		img_url 		= $(obj).children("input[name='S_IMAGE_URL']").val();
		full_grp_code 	= $(obj).children("input[name='PARENT_CODE']").val();
		grp_code 		= $(obj).children("input[name='N_GROUP_CODE']").val();

		if (now_page == 'compo') {
			fn_stats_screen();
		} else if (now_page == 'map') {
			fn_map_screen();
		}
	}

	// Left Menu Click
	function fn_tree_click(obj, v_img_url, v_parent_code, v_group_code, v_group_name) {
		fn_title_text_change(v_group_code, v_group_name);

		img_url 		= v_img_url;
		full_grp_code 	= v_parent_code;
		grp_code 		= v_parent_code == "-1" ? "-1" : v_group_code;

		if (now_page == 'compo') {
			fn_stats_screen();
		} else if (now_page == 'map') {
			fn_map_screen();
		}
	}

	// 선택 메뉴에 따른 Sub Title 변환
	function fn_title_text_change(groupCode, groupName) {
		if (Number(groupCode) === 0) {
			$('.st_under h2').text('실시간 통계');
		} else {
			$('.st_under h2').text('실시간 통계' + '(' + groupName + ')');
		}
	}
</script>

<!-- left nv -->
<div id="leftNv_Area" class="leftNv_Area">
</div>
<!-- left nv // -->

<!-- contents box -->
<div id="contentsbox_Area" class="contentsbox_Area">
	<form id="frm" name="frm" method="post">
		<input type="hidden" id="n_group_code" name="N_GROUP_CODE" value="-1"/>
		<input type="hidden" id="s_group_full_code" name="S_GROUP_FULL_CODE" value="-1"/>
		<input type="hidden" id="req_data" name="req_data" value=""/>
	</form>

	<div class="c_start">
		<div class="locationBox"><div class="st_under"><h2>실시간 통계</h2><span>Home &gt; 실시간 통계</span></div></div>
		<!-- 내용 -->
		<div id="contents"></div>
		<!-- 내용 // -->
	</div>
</div>
<!-- contents box // -->