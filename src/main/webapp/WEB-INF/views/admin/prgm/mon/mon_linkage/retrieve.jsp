<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>기존 관제 연동코드 관리</h2><span>Home &gt; 감시장비 관리 &gt; 기존 관제 연동코드 관리</span></div></div>
<!-- location // -->

<!-- 검색영역 -->
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<dd>
					<strong>알람타입</strong> <input type="text" name="SEARCH_N_ALM_TYPE" id="SEARCH_N_ALM_TYPE" class="int_f input_search"/>
					<strong>알람코드</strong> <input type="text" name="SEARCH_N_ALM_CODE" id="SEARCH_N_ALM_CODE" class="int_f input_search"/>
					<strong style="margin-left:20px;">알람명</strong> <input type="text" name="SEARCH_S_ALM_NAME" id="SEARCH_S_ALM_NAME" class="int_f input_search"/>
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
<form id="frm">
</form>
<!-- manager_contBox1 -->
<div class="manager_contBox1">
	<!-- stitle -->
	<div class="stitle1" style="float: none;">
		<div class="st_under">
			<h4>건수 : &nbsp;<span id="total_count">0</span></h4>
			<span><a href="<c:url value="/admin/go_prgm.mon.mon_linkage.insert.htm"/>" id="btn_save" class="css_btn_class">등록</a></span>
		</div>
	</div>
	<!-- stitle // -->
	<!-- table_typ2-4 -->
	<div id="grid" class="table_typ2-4">
	</div>
</div>
<!-- manager_contBox1 // -->
<!-- 내용 // -->

<script type="text/javascript">
	var grid;
	$(document).ready(function() {
		var searchParam = '${param.searchParam}';
		if ('' !== searchParam) {
			initSearchData(searchParam);
		}
		
		initEvent();
		initGrid();
	});

	function initSearchData(searchParam) {
		var param = JSON.parse(decodeURIComponent(searchParam));
		console.log(param);
		$('#SEARCH_N_ALM_TYPE').val(param.SEARCH_N_ALM_TYPE);
		$('#SEARCH_N_ALM_CODE').val(param.SEARCH_N_ALM_CODE);
		$('#SEARCH_S_ALM_NAME').val(param.SEARCH_S_ALM_NAME);
		
		// $('#grid').data('kendoGrid').dataSource.page(param.currentPageNo);
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
	}

	// Grid
	function initGrid() {
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/kendoPagination_mon_linkage.select_list.htm",
					data 		: function(data) {
						return {
							'N_ALM_TYPE'	: $('#SEARCH_N_ALM_TYPE').val(),
							'N_ALM_CODE'	: $('#SEARCH_N_ALM_CODE').val(),
							'S_ALM_NAME'	: $('#SEARCH_S_ALM_NAME').val()
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

		grid = $("#grid")
			.kendoGrid($.extend(kendoGridDefaultOpt, {
				dataSource	: dataSource,
				dataBound	: function (e) {

					gridDataBound(e);
					$('tr').on('dblclick', function(event) {
						selectedRow(event);
					});
				},
//				change		: selectedRow,
				sortable	: {
					mode 		: 'multiple',
					allowUnsort : true
				},
				columns		: [
					{field:'S_ALM_KEY',  	title:'알람키', 	width:'5%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_ALM_TYPE',  	title:'알람타입', 	width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_ALM_CODE',	title:'알람코드', 	width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_MAP_KEY', 	title:'맵 키', 	width:'5%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_SUBJECT', 	title:'알람제목', 	width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_MSG', 		title:'알람메시지', 	width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}}
					
				]
			})).data('kendoGrid');
	}

	// Selected Grid Row
	function selectedRow(event) {
		// 검색 조건과 페이지 번호를 JSON 형태의 String 으로 넘겼다가 다시 받아오기 위함
		var	param = {
				'SEARCH_N_ALM_CODE'    : $('#SEARCH_N_ALM_CODE').val(),
				'SEARCH_N_ALM_TYPE'    : $('#SEARCH_N_ALM_TYPE').val(),
				'SEARCH_S_ALM_NAME'    : $('#SEARCH_S_ALM_NAME').val(),
				'currentPageNo'	: grid.dataSource.page()
		}
		var paramStr 	= JSON.stringify(param);
		
		var $frm = $('#frm')
				.append('<input type="hidden" name="searchParam" value="' + encodeURIComponent(paramStr) + '">')
				.append('<input type="hidden" name="S_ALM_KEY" value="' + grid.dataItem(grid.select()).S_ALM_KEY + '">')
				.append('<input type="hidden" name="N_ALM_TYPE" value="' + grid.dataItem(grid.select()).N_ALM_TYPE + '">')
				.append('<input type="hidden" name="N_ALM_CODE" value="' + grid.dataItem(grid.select()).N_ALM_CODE + '">')
				.append('<input type="hidden" name="S_ALM_NAME" value="' + grid.dataItem(grid.select()).S_ALM_NAME + '">')
				.append('<input type="hidden" name="updateFlag" value="U">');

		$frm.attr({'action' : '<c:url value="/admin/go_prgm.mon.mon_linkage.insert.htm"/>'}).submit();

		event.preventDefault();
	}
</script>
