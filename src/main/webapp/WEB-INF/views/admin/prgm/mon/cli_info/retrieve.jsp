<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>CLI 정보 관리</h2><span>Home &gt; 감시장비 관리 &gt; CLI 정보 관리</span></div></div>
<!-- location // -->

<!-- 검색영역 -->
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<dd>
					<strong>장비그룹</strong><cmb:combo qryname="cmb_svr_group" seltagname="N_GROUP_CODE" firstdata="전체" etc="id=\"N_GROUP_CODE\""/>
					<select style="margin-left:30px;" name="SEARCH_TYPE" value="${param.SEARCH_TYPE}" id="SEARCH_TYPE">
                		<option value="ID">장비ID</option>
                		<option value="NM">장비명</option>
                		<option value="IP">장비IP</option>
                	</select>
                	<input type="text" name="SEARCH_KEYWORD" id="SEARCH_KEYWORD" value="${param.SEARCH_KEYWORD}" class="int_f input_search"/>
					<strong style="margin-left:30px;">구분</strong>
						<select name="TERMINAL" id="TERMINAL">
							<option value="">전체</option>
							<option value="TELNET">Telnet</option>
							<option value="SSH">SSH</option>
					</select>
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

<!-- Grid -->
<div class="manager_contBox1">
	<!-- stitle -->
	<div class="stitle1" style="float: none;">
		<div class="st_under">
			<h4>건수 : &nbsp;<span id="server_total_count">0</span></h4>
			<span>
				<a href="<c:url value="/admin/go_prgm.mon.cli_info.server_insert.htm"/>" id="btn_server_save" class="css_btn_class">등록</a>
				<!-- <a href="#" id="btn_server_modify" class="css_btn_class">수정</a> -->
			</span>
		</div>
	</div>
	<!-- stitle // -->
	<!-- table_typ2-4 -->
	<div id="cli_server_info_gird" class="table_typ2-4">
	</div>
</div>
<div class="manager_contBox1">
	<!-- stitle -->
	<div class="stitle1" style="float: none;">
		<div class="st_under">
			<h4>건수 : &nbsp;<span id="script_total_count">0</span></h4>
			<span>
				<a href="#" id="btn_script_save" class="css_btn_class">등록</a>
				<!-- <a href="#" id="btn_script_modify" class="css_btn_class">수정</a> -->
			</span>
		</div>
	</div>
	<!-- stitle // -->
	<!-- table_typ2-4 -->
	<div id="cli_script_info_gird" class="table_typ2-4">
	</div>
</div>
<!-- Grid // -->

<form id="frm"></form>

<script type="text/javascript">

	var serverGrid, scriptGrid;

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
		$('#N_GROUP_CODE').val(param.N_GROUP_CODE);
		$('#SEARCH_TYPE').val(param.SEARCH_TYPE);
		$('#SEARCH_KEYWORD').val(param.SEARCH_KEYWORD);
		$('#TERMINAL').val(param.TERMINAL);
		var page = parseInt(param.currentPageNo);
		serverGrid.dataSource.fetch(function() {
			serverGrid.dataSource.page(page);
		});
	}
	
	// Event 등록
	function initEvent() {

		$(".input_search").keypress(function(event){
			if(kendo.keys.ENTER === event.keyCode)
				$("#search").click();
		});
		
		$('#search').on('click', function(event) {
			event.preventDefault();
			$("#cli_server_info_gird").data('kendoGrid').dataSource.read();
		});

		/* 서버정보 수정
		$('#btn_server_modify').on('click', function(event) {

			if (serverGrid.select().length === 0) {
				alert("수정 할 데이터를 선택해주세요.");
				return;
			}

			var params = {
				'updateFlag' : 'U',
				'MON_ID'	 : serverGrid.dataItem(serverGrid.select()).MON_ID,
				'req_data'	 : 'data;cli_info.server_detail_info:map'
			};

			location.href = '<c:url value="/admin/go_prgm.mon.cli_info.server_insert.htm"/>' + '?' + $.param(params);

			event.preventDefault();
		});
		 */
		
		// 스크립트 정보 등록
		$('#btn_script_save').on('click', function() {
			if (serverGrid.select().length === 0) {
				alert("Server 데이터를 선택해주세요.");
				return;
			}

			var params = {
				'MON_ID' : serverGrid.dataItem(serverGrid.select()).MON_ID,
				'SVR_IP' : serverGrid.dataItem(serverGrid.select()).SVR_IP
			};
			location.href = '<c:url value="/admin/go_prgm.mon.cli_info.script_insert.htm"/>' + '?' + $.param(params);
		});

		// 스크립트 정보 수정
		$('#btn_script_modify').on('click', function(event) {
			if (scriptGrid.select().length === 0) {
				alert('수정 할 데이터를 선택해주세요.');
				return;
			}

			var params = {
				'updateFlag' : 'U',
				'MON_ID'	 : serverGrid.dataItem(serverGrid.select()).MON_ID,
				'SVR_IP'	 : serverGrid.dataItem(serverGrid.select()).SVR_IP,
				'SCRIPT_ID'	 : scriptGrid.dataItem(scriptGrid.select()).SCRIPT_ID,
				'req_data'	 : 'data;cli_info.script_detail_info:map'
			};

			location.href = '<c:url value="/admin/go_prgm.mon.cli_info.script_insert.htm"/>' + '?' + $.param(params);

			event.preventDefault();
		});
	}

	// SERVER Grid dblclick Event
	function serverGirdRowdblclick(e) {
		gridDataBound(e);

		// 서버 그리드 더블클릭 이벤트
		$('#cli_server_info_gird').find('table tr').on('dblclick', function() {
			serverUpdatePageMove();
		});
	}
	
	// SCRIPT Grid dblclick Event
	function scriptGirdRowdblclick(e) {
		gridDataBound(e);

		// 스크립트 그리드 더블클릭 이벤트
		$('#cli_script_info_gird').find('table tr').on('dblclick', function() {
			scriptUpdatePageMove();
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
					url 		: cst.contextPath() + "/admin/kendoPagination_cli_info.select_server_list.htm",
					data 		: function(data) {
						return {
							'N_GROUP_CODE'  : $.trim($('#N_GROUP_CODE').val()),
							'SEARCH_TYPE'   : $.trim($('#SEARCH_TYPE').val()),
							'SEARCH_KEYWORD': $.trim($('#SEARCH_KEYWORD').val()),
							'TERMINAL' 	: $('#TERMINAL').val()
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
					$('#server_total_count').text(totalCount);
					return totalCount;
				}
			},
			pageSize		: cst.countPerPage(),
			serverPaging	: true,
			serverSorting	: true
		});

		serverGrid = $("#cli_server_info_gird")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: dataSource,
				dataBound	: serverGirdRowdblclick,
				change		: selectedRow,
				sortable	: {
					mode 		: 'multiple',
					allowUnsort : true
				},
				columns		: [
					{field:'MON_ID', 		title:'장비ID', 	width:'10%',  attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'MON_NAME', 		title:'장비명', 	width:'20%',  attributes:{style:'text-align:left'},   headerAttributes:{style:'text-align:center'}},
					{field:'SVR_IP', 		title:'장비IP', 	width:'20%',  attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'SVR_PORT', 		title:'Port', 	width:'10%',  attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'TERMINAL', 		title:'구분',	 	width:'20%',  attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'MODIFY_DATE', 	title:'등록일자', 	width:'20%',  attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}}
				]
			})).data('kendoGrid');

		scriptGrid = $("#cli_script_info_gird")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: [],
				dataBound	: scriptGirdRowdblclick,
				sortable	: {
					mode 		: 'multiple',
					allowUnsort : true
				},
				columns		: [
					{field:'MON_ID', 		title:'장비ID', 			width:'10%',  attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'SCRIPT_ID', 	title:'Script ID', 		width:'10%',  attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'PATH', 			title:'Script 경로', 		width:'25%',  attributes:{style:'text-align:left'},   headerAttributes:{style:'text-align:center'}},
					{field:'TIMEOUT', 		title:'Timeout', 		width:'10%',  attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'INTERVAL_VAL', 	title:'Script 실행주기',	width:'10%',  attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'RETRY_CNT', 	title:'재시도 횟수', 		width:'10%',  attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'USE_YN', 		title:'사용여부', 			width:'10%',  attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'MODIFY_DATE', 	title:'등록일자', 			width:'15%',  attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}}
				]
			})).data('kendoGrid');
	}

	// Selected Grid Row
	function selectedRow(event) {

		var monId = this.dataItem(this.select()).MON_ID;

		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/kendoPagination_cli_info.select_script_list.htm",
					data 		: function(data) {
						return {
							'MON_ID' : monId
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
					$('#script_total_count').text(totalCount);
					return totalCount;
				}
			},
			pageSize		: cst.countPerPage(),
			serverPaging	: true,
			serverSorting	: true
		});

		$("#cli_script_info_gird").data('kendoGrid').setDataSource(dataSource);
	}
	
	function serverUpdatePageMove() {
		
		// 검색 조건과 페이지 번호를 JSON 형태의 String 으로 넘겼다가 다시 받아오기 위함
		var param = {
			'N_GROUP_CODE'	: $.trim($('#N_GROUP_CODE').val()),
			'SEARCH_TYPE'   : $.trim($('#SEARCH_TYPE').val()),
			'SEARCH_KEYWORD': $.trim($('#SEARCH_KEYWORD').val()),
			'TERMINAL'		: $.trim($('#TERMINAL').val()),
			'currentPageNo'	: serverGrid.dataSource.page()
		};
		var paramStr = JSON.stringify(param);

		$('#frm')
			.append('<input type="hidden" name="searchParam" value="' + encodeURIComponent(paramStr) + '">')
			.append('<input type="hidden" name="MON_ID" value="' + serverGrid.dataItem(serverGrid.select()).MON_ID + '">')
			.append('<input type="hidden" name="updateFlag" value="U">')
			.attr({'action' : cst.contextPath() + '/admin/go_prgm.mon.cli_info.server_insert.htm'})
			.submit();
		
		event.preventDefault();
	}
	
	function scriptUpdatePageMove() {
		
		// 검색 조건과 페이지 번호를 JSON 형태의 String 으로 넘겼다가 다시 받아오기 위함
		var param = {
			'N_GROUP_CODE'	: $.trim($('#N_GROUP_CODE').val()),
			'SEARCH_TYPE'   : $.trim($('#SEARCH_TYPE').val()),
			'SEARCH_KEYWORD': $.trim($('#SEARCH_KEYWORD').val()),
			'TERMINAL'		: $.trim($('#TERMINAL').val()),
			'currentPageNo'	: serverGrid.dataSource.page()
		};
		var paramStr = JSON.stringify(param);

		$('#frm')
			.append('<input type="hidden" name="searchParam" value="' + encodeURIComponent(paramStr) + '">')
			.append('<input type="hidden" name="MON_ID" value="' + serverGrid.dataItem(serverGrid.select()).MON_ID + '">')
			.append('<input type="hidden" name="SVR_IP" value="' + serverGrid.dataItem(serverGrid.select()).SVR_IP + '">')
			.append('<input type="hidden" name="SCRIPT_ID" value="' + scriptGrid.dataItem(scriptGrid.select()).SCRIPT_ID + '">')
			.append('<input type="hidden" name="updateFlag" value="U">')
			.attr({'action' : cst.contextPath() + '/admin/go_prgm.mon.cli_info.script_insert.htm'})
			.submit();
		
		event.preventDefault();
	}
	
</script>