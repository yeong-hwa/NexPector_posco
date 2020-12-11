<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>감시장비 프로세스 관리</h2><span>Home &gt; 감시장비 관리 &gt; 감시장비 프로세스 관리</span></div></div>
<!-- location // -->

<!-- 내용 -->
<!-- 검색영역 -->
<form id="delete_form" name="delete_form" data-role="validator">
<input type="hidden" id="delete_list" name="delete_list" value=""/>
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				 <dd>
					<strong>장비그룹</strong><cmb:combo qryname="cmb_svr_group" seltagname="N_GROUP_CODE" firstdata="전체" etc="id=\"N_GROUP_CODE\""/>
					<strong style="margin-left:30px;">장비타입</strong><cmb:combo qryname="cmb_svr_type" seltagname="N_TYPE_CODE" firstdata="전체" etc="id=\"N_TYPE_CODE\""/>
					<select style="margin-left:30px;" name="SEARCH_TYPE" value="${param.SEARCH_TYPE}" id="SEARCH_TYPE">
                		<option value="ID">장비ID</option>
                		<option value="NM">장비명</option>
                		<option value="IP">장비IP</option>
                	</select>
                	<input type="text" name="SEARCH_KEYWORD" id="SEARCH_KEYWORD" value="${param.SEARCH_KEYWORD}" class="int_f input_search"/>
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
		<div class="st_under">
			<h4>건수 : &nbsp;<span id="total_count">0</span></h4>
			<span>
				<a href="<c:url value='/admin/go_prgm.mon.process_info.insert.htm'/>" id="btn_save" class="css_btn_class">등록</a>
			</span>
		</div>
	</div>
	<!-- stitle // -->
	<!-- table_typ2-4 -->
	<div id="grid" class="table_typ2-4">
	</div>
</div>
</form>
<!-- manager_contBox1 // -->
<!-- 내용 // -->

<form id="frm"></form>

<form id="go_list_form" method="get">
	<input type="hidden" name="searchParam" value="${param.searchParam}"/>
</form>

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

	function initSearchData(searchParam) {
		var param = JSON.parse(decodeURIComponent(searchParam));
		$('#N_GROUP_CODE').val(param.N_GROUP_CODE);
		$('#N_TYPE_CODE').val(param.N_TYPE_CODE);
		$('#SEARCH_TYPE').val(param.SEARCH_TYPE);
		$('#SEARCH_KEYWORD').val(param.SEARCH_KEYWORD);
		
		var page = parseInt(param.currentPageNo);
		grid.dataSource.fetch(function() {
			grid.dataSource.page(page);
		});
	}
	
	// 사용자 목록 Grid
	function InitGrid() {
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/kendoPagination_process_info.select_list.htm",
					data 		: function(data) {
						return {
							'N_GROUP_CODE'  : $.trim($('#N_GROUP_CODE').val()),
							'N_TYPE_CODE'   : $.trim($('#N_TYPE_CODE').val()),
							'SEARCH_TYPE'   : $.trim($('#SEARCH_TYPE').val()),
							'SEARCH_KEYWORD': $.trim($('#SEARCH_KEYWORD').val())
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
				//change		: selectedRow,
				sortable	: {
					mode 		: 'multiple',
					allowUnsort : true
				},
				dataBound	: girdRowdblclick,
				columns		: [
					{field:'N_MON_ID', title:'장비ID', width:'7%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center;vertical-align:middle'}},
					{field:'S_MON_NAME', title:'장비명', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center;vertical-align:middle'}},
					{field:'S_MON_IP', title:'장비IP', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center;vertical-align:middle'}},
					{field:'TYPE_NAME', title:'장비타입', width:'8%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center;vertical-align:middle'}},
					{field:'GROUP_NAME', title:'장비그룹', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center;vertical-align:middle'}},
					{field:'S_ALIAS', title:'프로세스', width:'20%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center;vertical-align:middle'}}
				]
			})).data('kendoGrid');
	}

	// Event 등록
	function initEvent() {
		
		$(".input_search").keypress(function(event){
			if(kendo.keys.ENTER === event.keyCode) {
				event.preventDefault();
				$("#search").click();
			}
		});
				
		$('#search').on('click', function(event) {
			event.preventDefault();
			grid.dataSource.read();
		});
		
		$('select').on('change', function(event) {
			event.preventDefault();
			grid.dataSource.read();
		});
	}
	
	//Grid dblclick Event
	function girdRowdblclick(e) {
		
		gridDataBound(e);
		
		$('tr').on('dblclick', function() {
			selectedRow();
		});
	}

	// Selected Grid Row
	function selectedRow(event) {

		// 검색 조건과 페이지 번호를 JSON 형태의 String 으로 넘겼다가 다시 받아오기 위함
		var param = {
			'N_GROUP_CODE'		: $('#N_GROUP_CODE').val(),
			'N_TYPE_CODE'		: $('#N_TYPE_CODE').val(),
			'SEARCH_TYPE'   	: $.trim($('#SEARCH_TYPE').val()),
			'SEARCH_KEYWORD'	: $.trim($('#SEARCH_KEYWORD').val()),
			'currentPageNo'		: grid.dataSource.page()
		};
		var paramStr = JSON.stringify(param);

		$('#frm')
			.append('<input type="hidden" name="searchParam" value="' + encodeURIComponent(paramStr) + '">')
			.append('<input type="hidden" name="N_MON_ID" value="' + grid.dataItem(grid.select()).N_MON_ID + '">')
			.append('<input type="hidden" name="updateFlag" value="U">')
			.attr({'action' : cst.contextPath() + '/admin/go_prgm.mon.process_info.insert.htm'})
			.submit();

		event.preventDefault();
	}

	function goListPage(event) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.process_info.retrieve.htm').submit();
	}
</script>