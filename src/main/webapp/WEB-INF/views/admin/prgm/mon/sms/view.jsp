<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>
<style type="text/css">
	.k-grid-header, .k-grid-toolbar {height: 30px;}
</style>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>SMS 체크</h2><span>Home &gt; 시스템정보 관리 &gt; SMS 체크</span></div></div>
<!-- location // -->

<!-- 내용 -->
<!-- 검색영역 -->
<input type="hidden" id="N_GROUP_CODE" name="N_GROUP_CODE" value="${sessionScope.N_GROUP_CODE}"/>
<input type="TEXT" id="charset" name="charset" value="${param.charset}"/>
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 버튼 -->
			<span class="his_search_bt"><a href="#" id="search"><img src="<c:url value="/images/botton/search_1.jpg"/>" alt="검색" /></a></span>
			<!-- 버튼 // -->
		</li>
		<li class="rightbg">&nbsp;</li>
	</ul>
</div>
<!-- 검색영역 //-->

<!-- manager_contBox1 -->
<div class="manager_contBox1">
	<!-- stitle -->
	<div class="stitle1" style="float: none;">
		</div>
	</div>
	<!-- stitle // -->
	<div class="table_typ2-4">
			<tr>
				<td><textarea id="msg" rows="10" cols="100">${param.msg}</textarea></td>	
			</tr>
	</div>
	<!-- table_typ2-4 -->
</div>
<!-- manager_contBox1 // -->
<!-- 내용 // -->

<form id="frm"></form>

<script type="text/javascript">
	var grid;

	$(document).ready(function() {
		start();
		initEvent();

		var searchParam = '${param.searchParam}';
		if ('' !== searchParam) {
			initSearchData(searchParam);
		}
		
		$("#search_msg").change(function() {
			$("#search").click();
		});
		
	});            
	//"ed959ceab880ed858cec8aa4ed8ab8"
	function start(){
		$.ajax({
			contentType: "application/json; charset=UTF-8",
			method: "POST",
			dataType : "json", 
			data :  JSON.stringify({ "msg" : $("#msg").val(),"charset" : $("#charset").val() }), 
            url:'/admin/sms/view.htm',
	        success:function(data){
	        	$("#msg").val(data.result);
            }
        })
	}
	
	// 사용자 목록 Grid
 	function initSearchData(searchParam) {
		var param = JSON.parse(decodeURIComponent(searchParam));
		$('#search_mon_id').val(param.search_mon_id);
		var page = parseInt(param.currentPageNo);
		grid.dataSource.fetch(function() {
			grid.dataSource.page(page);
		});
	}
	
	// Event 등록
	function initEvent() {
		$(".input_search").keypress(function(event){
			if(kendo.keys.ENTER === event.keyCode)
				$("#search").click();
		});
		
		$('#search').on('click', function(event) {z
			event.preventDefault();
			grid.dataSource.read();
		});
	}

</script>