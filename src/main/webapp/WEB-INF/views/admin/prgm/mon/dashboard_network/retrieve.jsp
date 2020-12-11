<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>메뉴 정보 관리</h2><span>Home &gt; 시스템정보 관리 &gt; 메뉴 정보 관리</span></div></div>
<!-- location // -->

<!-- 내용 -->
<!-- 검색영역 -->
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<dd>
					<strong>노드ID</strong><input type="text" name="N_NE_ID" id="N_NE_ID" value="${param.N_NE_ID}" class="int_f input_search"/>
					<strong style="margin-left:30px;">노드명</strong><input type="text" name="S_NE_NAME" id="S_NE_NAME" value="${param.S_NE_NAME}" class="int_f input_search"/>
					<strong style="margin-left:30px;">감시장비ID</strong><input type="text" name="N_MON_ID" id="N_MON_ID" value="${param.N_MON_ID}" class="int_f input_search"/>
					<strong style="margin-left:30px;">감시장비명</strong><input type="text" name="S_MON_NAME" id="S_MON_NAME" value="${param.S_MON_NAME}" class="int_f input_search"/>
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
		<div class="st_under"><h4>건수 : &nbsp;<span id="total_count">0</span></h4></div>
	</div>
	<!-- stitle // -->
	<!-- table_typ2-4 -->
	<div id="dashboard_network_gird" class="table_typ2-4">
	</div>
</div>
<!-- manager_contBox1 // -->
<!-- 내용 // -->

<form id="frm"></form>

<script type="text/javascript">
	$(document).ready(function() {
		InitGrid();
		initEvent();

		var searchParam = '${param.searchParam}';
		if ('' !== searchParam) {
			initSearchData(searchParam);
		}
	});

	function initSearchData(searchParam) {
		var param = JSON.parse(decodeURIComponent(searchParam));
		$('#N_NE_ID').val(param.N_NE_ID);
		$('#S_NE_NAME').val(param.S_NE_NAME);
		$('#N_MON_ID').val(param.N_MON_ID);
		$('#S_MON_NAME').val(param.S_MON_NAME);
		$('#dashboard_network_gird').data('kendoGrid').dataSource.page(param.currentPageNo);
	}
	
	// 사용자 목록 Grid
	function InitGrid() {
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/kendoPagination_dashboard_network.select_list.htm",
					data 		: function(data) {
						return {
							'N_NE_ID'    : $.trim($('#N_NE_ID').val()),
							'S_NE_NAME'  : $.trim($('#S_NE_NAME').val()),
							'N_MON_ID'   : $.trim($('#N_MON_ID').val()),
							'S_MON_NAME' : $.trim($('#S_MON_NAME').val())
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

		$("#dashboard_network_gird")
			.kendoGrid($.extend(kendoGridDefaultOpt, {
				dataSource	: dataSource,
				change		: selectedRow,
				sortable	: {
					mode 		: 'multiple',
					allowUnsort : true
				},
				columns		: [
					{field:'N_NE_ID', title:'노드ID', width:'6%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'N_NE_SUB_ID', title:'서브ID', width:'6%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_NE_NAME', title:'노드명', width:'25%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_DESC', title:'노드설명', width:'25%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'N_MON_ID', title:'감시장비ID', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_MON_NAME', title:'감시장비명', width:'16%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_MON_IP', title:'감시장비IP', width:'12%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}}
				]
			}));
	}
	
	// Event 등록
	function initEvent() {

		$(".input_search").keypress(function(event){
			if(kendo.keys.ENTER === event.keyCode)
				$("#search").click();
		});
		
		$('#search').on('click', function(event) {
			event.preventDefault();
			$("#dashboard_network_gird").data('kendoGrid').dataSource.read();
		});
	}

	// Selected Grid Row
	function selectedRow(event) {

		// 검색 조건과 페이지 번호를 JSON 형태의 String 으로 넘겼다가 다시 받아오기 위함
		var param = {
			'N_NE_ID'	: $('#N_NE_ID').val().trim(),
			'S_NE_NAME'	: $('#S_NE_NAME').val().trim(),
			'N_MON_ID'	: $('#N_MON_ID').val().trim(),
			'S_MON_NAME': $('#S_MON_NAME').val().trim(),
			'currentPageNo'		: $('#dashboard_network_gird').data('kendoGrid').dataSource.page()
		};

		var paramStr = JSON.stringify(param);

		$('#frm')
			.append('<input type="hidden" name="searchParam" value="' + encodeURIComponent(paramStr) + '">')
			.append('<input type="hidden" name="N_NE_ID" value="' + this.dataItem(this.select()).N_NE_ID + '">')
			.append('<input type="hidden" name="N_NE_SUB_ID" value="' + this.dataItem(this.select()).N_NE_SUB_ID + '">')
			.append('<input type="hidden" name="S_NE_NAME" value="' + this.dataItem(this.select()).S_NE_NAME + '">')
			.append('<input type="hidden" name="N_MON_ID" value="' + this.dataItem(this.select()).N_MON_ID + '">')
			.append('<input type="hidden" name="S_MON_NAME" value="' + this.dataItem(this.select()).S_MON_NAME + '">')
			.append('<input type="hidden" name="updateFlag" value="U">')
			.attr({'action' : cst.contextPath() + '/admin/go_prgm.mon.dashboard_network.insert.htm'})
			.submit();

		event.preventDefault();
	}

	<!-- 추가 -->
	function fn_insert()
	{
		frm.target = "";
		frm.action="${app_url}.insert.htm";
		frm.submit();
	}
	<!-- 추가 -->
	function fn_excel()
	{
		frm.target = "";
		frm.action=".excel.neonex";
		frm.submit();	
	}
</script>
