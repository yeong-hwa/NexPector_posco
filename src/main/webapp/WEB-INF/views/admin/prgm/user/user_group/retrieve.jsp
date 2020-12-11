<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<!-- location -->
<div class="locationBox"><div class="st_under"><h2>사용자 그룹 정보 관리</h2><span>Home &gt; 사용자 관리 &gt; 사용자 그룹 정보 관리</span></div></div>
<!-- location // -->

<!-- 내용 -->
<!-- 검색영역 -->
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<dd>
					<strong>그룹명</strong> <input type="text" name="S_GROUP_NAME" id="search_group_name" value="" class="int_f input_search"/>
				</dd>
			</dl>
			<!-- 검색항목 // -->

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
		<div class="st_under"><h4>건수 : &nbsp;<span id="total_count">0</span></h4><span><a href="<c:url value="/admin/go_prgm.user.user_group.insert.htm"/>" id="btn_save" class="css_btn_class">등록</a></span></div>
	</div>
	<!-- stitle // -->
	<!-- table_typ2-4 -->
	<div id="user_group_grid" class="table_typ2-4">
	</div>
</div>
<!-- manager_contBox1 // -->
<!-- 내용 // -->

<form id="frm"></form>

<script type="text/javascript">
	var grid;
	$(document).ready(function() {
		initGrid();
		initEvent();

		var searchParam = '${param.searchParam}';
		if ('' !== searchParam) {
			initSearchData(searchParam);
		}
	});

	function initSearchData(searchParam) {
		var param = JSON.parse(decodeURIComponent(searchParam));
		$('#search_group_name').val(param.search_group_name);
		var page = parseInt(param.currentPageNo);
		grid.dataSource.fetch(function() {
			grid.dataSource.page(page);
		});
	}

	// 사용자 목록 Grid
	function initGrid() {
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/kendoPagination_user_group.select_list.htm",
					data 		: function(data) {
						return {
							'S_GROUP_NAME'   : $.trim($('#search_group_name').val())
						};
					}
				},
				parameterMap: function (data, opperation) {
					return JSON.stringify(data);
				}
			},
			schema			: {
				data	: function(data) {
					return data;
				},
				total 	: function(response) {
					var totalCount = response.length > 0 ? response[0].TOTAL_COUNT : 0;
					$('#total_count').text(totalCount);
					return totalCount;
				}
			},
			pageSize		: cst.countPerPage(),
			serverPaging	: true,
			serverSorting	: true
		});

		grid = $("#user_group_grid")
					.kendoGrid($.extend({}, kendoGridDefaultOpt, {
						dataSource	: dataSource,
						change		: selectedRow,
						sortable	: {
							mode 		: 'multiple',
							allowUnsort : true
						},
						columns		: [
							{field:'N_GROUP_CODE', title:'사용자그룹코드', width:'16%', attributes:alignCenter, headerAttributes:alignCenter},
							{field:'S_GROUP_NAME', title:'사용자그룹명', width:'16%', attributes:alignCenter, headerAttributes:alignCenter},
							{field:'PARENT_NAME', title:'상위그룹명', width:'16%', attributes:alignCenter, headerAttributes:alignCenter},
							{field:'F_USE', title:'사용여부', width:'16%', attributes:alignCenter, headerAttributes:alignCenter},
							{field:'D_IN_DATE', title:'등록일시', width:'18%', attributes:alignCenter, headerAttributes:alignCenter},
							{field:'D_UP_DATE', title:'수정일시', width:'18%', attributes:alignCenter, headerAttributes:alignCenter}
						]
					})).data('kendoGrid');
	}

	// Event 등록
	function initEvent() {
		$(".input_search").keypress(function(event){
			if(kendo.keys.ENTER === event.keyCode)
				$("#search").click();
		});

		$('#search').on('click', function(event) {
			event.preventDefault();
			grid.dataSource.read();
		});

		$('input[type=text]').focusout(function() {
			this.value = $.trim(this.value);
		});
	}

	// Selected Grid Row
	function selectedRow(event) {
		// 검색 조건과 페이지 번호를 JSON 형태의 String 으로 넘겼다가 다시 받아오기 위함
		var param = {
			'search_group_name' 	: $('#search_group_name').val().trim(),
			'currentPageNo'		: grid.dataSource.page()
		};
		var paramStr = JSON.stringify(param);

		$('#frm')
			.append('<input type="hidden" name="searchParam" value="' + encodeURIComponent(paramStr) + '">')
			.append('<input type="hidden" name="N_GROUP_CODE" value="' + this.dataItem(this.select()).N_GROUP_CODE + '">')
			.append('<input type="hidden" name="updateFlag" value="U">')
			.attr({'action' : cst.contextPath() + '/admin/go_prgm.user.user_group.insert.htm'})
			.submit();

		event.preventDefault();
	}
</script>
