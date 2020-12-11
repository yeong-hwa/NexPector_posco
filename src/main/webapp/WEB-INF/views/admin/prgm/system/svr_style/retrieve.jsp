<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>서버 스타일 관리</h2><span>Home &gt; 시스템정보 관리 &gt; 서버 스타일 관리</span></div></div>
<!-- location // -->

<!-- 내용 -->
<!-- 검색영역 -->
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<dd>
					<strong>감시종류명</strong><input type="text" name="S_DESC" id="search_style_name" value="${param.S_DESC}" class="int_f" style="width:150px;height:20px" />
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
		<div class="st_under"><h4>건수 : &nbsp;<span id="total_count">0</span></h4><span><a href="<c:url value="/admin/go_prgm.system.svr_style.insert.htm"/>" id="btn_save" class="css_btn_class">등록</a></span></div>
	</div>
	<!-- stitle // -->
	<!-- table_typ2-4 -->
	<div id="svr_style_gird" class="table_typ2-4">
	</div>
</div>
<!-- manager_contBox1 // -->
<!-- 내용 // -->

<form id="frm"></form>

<script type="text/javascript">

	var grid;

	$(document).ready(function() {
		InitGrid();
		initEvent();

		var searchParam = '${param.searchParam}';
		if ('' !== searchParam) {
			initSearchData(searchParam);
		}
	});

	// 사용자 목록 Grid
	function InitGrid() {
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/kendoPagination_svr_style.select_list.htm",
					data 		: function(data) {
						return {
							'S_DESC'   : $.trim($('#search_style_name').val())
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

		grid = $("#svr_style_gird")
			.kendoGrid($.extend(kendoGridDefaultOpt, {
				dataSource	: dataSource,
				//change		: selectedRow,
				sortable	: {
					mode 		: 'multiple',
					allowUnsort : true
				},
				dataBound	: gridRowdblclick,
				columns		: [
					{field:'N_STYLE_CODE', title:'장비종류코드', width:'50%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_DESC', title:'장비종류명', width:'50%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}}
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
			$("#svr_style_gird").data('kendoGrid').dataSource.read();
		});
	}
	
	//Grid dblclick Event
	function gridRowdblclick(e) {
		
		gridDataBound(e);
		
		$('tr').on('dblclick', function() {
			selectedRow();
		});
	}

	// Selected Grid Row
	function selectedRow(event) {

		// 검색 조건과 페이지 번호를 JSON 형태의 String 으로 넘겼다가 다시 받아오기 위함
		var param = {
			'search_style_name'	: $('#search_style_name').val().trim(),
			'currentPageNo'		: $('#svr_style_gird').data('kendoGrid').dataSource.page()
		};
		var paramStr = JSON.stringify(param);

		$('#frm')
			.append('<input type="hidden" name="searchParam" value="' + encodeURIComponent(paramStr) + '">')
			.append('<input type="hidden" name="N_STYLE_CODE" value="' + grid.dataItem(grid.select()).N_STYLE_CODE + '">')
			.append('<input type="hidden" name="updateFlag" value="U">')
			.attr({'action' : cst.contextPath() + '/admin/go_prgm.system.svr_style.insert.htm'})
			.submit();

		event.preventDefault();
	}

	function initSearchData(searchParam) {
		var param = JSON.parse(decodeURIComponent(searchParam));
		$('#search_style_name').val(param.search_style_name);
		$('#svr_stype_gird').data('kendoGrid').dataSource.page(param.currentPageNo);
	}
</script>