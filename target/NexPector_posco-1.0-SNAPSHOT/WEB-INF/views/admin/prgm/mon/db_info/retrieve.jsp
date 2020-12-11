<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>DB 정보 관리</h2><span>Home &gt; 감시장비 관리 &gt; DB 정보 관리</span></div></div>
<!-- location // -->

<!-- 내용 -->
<!-- 검색영역 -->
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<dd>
					<strong>DB ID</strong>
					<input type="text" name="N_DB_ID" id="N_DB_ID" value="${param.N_DB_ID}" class="int_f input_search" style="width:70px;"/>
				</dd>
			</dl>
			<dl>
				<dd>
					<strong>DB 명</strong>
					<input type="text" name="S_NAME" id="S_NAME" value="${param.S_NAME}" class="int_f input_search" style="width:70px;"/>
				</dd>
			</dl>
			<dl>
				<dd>
					<strong>SID</strong>
					<input type="text" name="S_DBNAME" id="S_DBNAME" value="${param.S_DBNAME}" class="int_f input_search" style="width:70px;"/>
				</dd>
			</dl>			
			<dl>
				<dd>
					<strong>DB 종류</strong>
					<select name="N_TYPE" id="N_TYPE" style="width:50px;">
                		<option value="">전체</option>
                		<option value="0">Oracle</option>
                		<option value="1">MS SQL</option>
                		<option value="2">Sybase</option>
                		<option value="3">Tibero</option>
                	</select>
				</dd>
			</dl>
			<dl>
				<dd>
					<select style="margin-left:30px;" name="SEARCH_TYPE" value="${param.SEARCH_TYPE}" id="SEARCH_TYPE" style="width:70px;">
                		<option value="ID">장비ID</option>
                		<option value="NM">장비명</option>
                		<option value="IP">장비IP</option>
                	</select>
                	<input type="text" name="SEARCH_KEYWORD" id="SEARCH_KEYWORD" value="${param.SEARCH_KEYWORD}" class="int_f input_search" style="width:70px;"/>
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
		<div class="st_under"><h4>건수 : &nbsp;<span id="total_count">0</span></h4><span><a href="<c:url value="/admin/go_prgm.mon.db_info.insert.htm"/>" id="btn_save" class="css_btn_class">등록</a></span></div>
	</div>
	<!-- stitle // -->
	<!-- table_typ2-4 -->
	<div id="db_info_gird" class="table_typ2-4">
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
		$('#N_GROUP_CODE').val(param.N_GROUP_CODE);
		$('#S_COMPANY').val(param.S_COMPANY);
		$('#db_info_gird').data('kendoGrid').dataSource.page(param.currentPageNo);
	}
	
	// Event 등록
	function initEvent() {

		$(".input_search").keypress(function(event){
			if(kendo.keys.ENTER === event.keyCode)
				$("#search").click();
		});
		
		$('#search').on('click', function(event) {
			event.preventDefault();
			$("#db_info_gird").data('kendoGrid').dataSource.read();
		});
	}

	// db info Grid
	function InitGrid() {
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/kendoPagination_db_info.select_list.htm",
					data 		: function(data) {
						return {
							'N_DB_ID'   	: $.trim($('#N_DB_ID').val()),
							'N_TYPE'   		: $.trim($('#N_TYPE').val()),
							'S_NAME'   		: $.trim($('#S_NAME').val()),
							'S_DBNAME'   	: $.trim($('#S_DBNAME').val()),
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

		$("#db_info_gird")
		.kendoGrid($.extend(kendoGridDefaultOpt, {
			dataSource	: dataSource,
			change		: selectedRow,
			sortable	: {
				mode 		: 'multiple',
				allowUnsort : true
			},
			columns		: [
				{field:'N_DB_ID', title:'DB ID', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				{field:'S_NAME', title:'DB명', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				{field:'S_DBNAME', title:'SID', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				{field:'S_DB_TYPE', title:'TYPE', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				{field:'N_MON_ID', title:'장비ID', width:'10%', attributes:{style:'text-align:left'}, headerAttributes:{style:'text-align:center'}},
				{field:'S_IPADDRESS', title:'장비IP', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				{field:'N_PORT', title:'Port', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				{field:'S_MON_NAME', title:'장비명', width:'10%', attributes:{style:'text-align:left'}, headerAttributes:{style:'text-align:center'}},
				{field:'N_USE_LIMIT', title:'TableSpace(임계치)', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				{field:'N_CON_LIMIT', title:'동시 접속세션(임계치)', width:'10%', attributes:{style:'text-align:left'}, headerAttributes:{style:'text-align:center'}},
				{field:'N_INTERVAL', title:'감시주기(ms)', width:'10%', attributes:{style:'text-align:left'}, headerAttributes:{style:'text-align:center'}}
			]
		}));
	}

	// Selected Grid Row
	function selectedRow(event) {

		// 검색 조건과 페이지 번호를 JSON 형태의 String 으로 넘겼다가 다시 받아오기 위함
		var param = {
			'S_COMPANY'	: $.trim($('#S_COMPANY').val()),
			'N_GROUP_CODE'	: $.trim($('#N_GROUP_CODE').val()),
			'S_APP_ID'	: $.trim($('#S_APP_ID').val()),
			'currentPageNo'		: $('#db_info_gird').data('kendoGrid').dataSource.page()
		};
		var paramStr = JSON.stringify(param);
		$('#frm')
			.append('<input type="hidden" name="searchParam" value="' + encodeURIComponent(paramStr) + '">')
			.append('<input type="hidden" name="N_DB_ID" value="' + this.dataItem(this.select()).N_DB_ID + '">')
			.append('<input type="hidden" name="updateFlag" value="U">')
			.attr({'action' : cst.contextPath() + '/admin/go_prgm.mon.db_info.insert.htm'})
			.submit();

		event.preventDefault();
	}
</script>