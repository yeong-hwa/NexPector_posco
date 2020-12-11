<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<style type="text/css">
	.manaint_f{height: 26px;}
	.k-datetimepicker .k-picker-wrap .k-icon{margin:0 2px;margin-top: 5px;}
	.k-i-calendar{margin-top: 4px;}
</style>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>Trunk 이름 관리</h2><span>Home &gt; 감시장비 관리 &gt; Trunk 이름 관리</span></div></div>
<!-- location // -->

<!-- 내용 -->
<!-- 검색영역 -->
<form id="trunk_name_delete_form" name="trunk_name_delete_form" data-role="validator">
<input type="hidden" id="trunk_name_delete_list" name="TRUNK_NAME_DELETE_LIST" value=""/>

<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<dd>
					<strong>Trunk Number</strong><input type="text" name="N_TRUNK_NUMBER" id="N_TRUNK_NUMBER" value="${param.S_TRUNK_NAME}" class="int_f input_search"/>
					<strong>Trunk Name</strong><input type="text" name="S_TRUNK_NAME" id="S_TRUNK_NAME" value="${param.S_TRUNK_NAME}" class="int_f input_search"/>
					<select style="margin-left:10px;" name="SEARCH_TYPE" id="SEARCH_TYPE">
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
		<div class="st_under"><h4>건수 : &nbsp;<span id="total_count">0</span></h4>
			<span>
				<a href="<c:url value="/admin/go_prgm.mon.trunk_name.insert.htm"/>" id="btn_save" class="css_btn_class">등록</a>
				<a href="#" id="btn_remove" class="css_btn_class">삭제</a>
			</span>
		</div>
	</div>

	<!-- stitle // -->
	<!-- table_typ2-4 -->
	<div id="trunk_name_grid" class="table_typ2-4">
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
		initGrid();
		initEvent();
		var searchParam = '${param.searchParam}';
		if ('' !== searchParam) {
			initSearchData(searchParam);
		}
	});
	
	function initSearchData(searchParam) {
		var param = JSON.parse(decodeURIComponent(searchParam));
		$('#N_TRUNK_NUMBER').val(param.N_TRUNK_NUMBER);
		$('#S_TRUNK_NAME').val(param.S_TRUNK_NAME);
		$('#SEARCH_TYPE').val(param.SEARCH_TYPE);
		$('#SEARCH_KEYWORD').val(param.SEARCH_KEYWORD);

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
					url 		: cst.contextPath() + "/admin/kendoPagination_trunk_name.select_list.htm",
					data 		: function(data) {
						return {
							'S_TRUNK_NAME'  	: $.trim($('#S_TRUNK_NAME').val()),
							'N_TRUNK_NUMBER'  	: $.trim($('#N_TRUNK_NUMBER').val()),
							'SEARCH_TYPE'   	: $.trim($('#SEARCH_TYPE').val()),
							'SEARCH_KEYWORD'	: $.trim($('#SEARCH_KEYWORD').val())
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
		
		grid = $("#trunk_name_grid")
			.kendoGrid($.extend(kendoGridDefaultOpt, {
				dataSource	: dataSource,
				//change		: selectedRow,
				sortable	: {
					mode 		: 'multiple',
					allowUnsort : true
				},
				dataBound	: gridDataBound,
				columns		: [
					{headerTemplate: '<input type="checkbox" id="all_check" value="Y"/>', template: '<input type="checkbox" name="sel_check" value="Y" onchange="checkAll();">', width:'3%', attributes:alignCenter, headerAttributes:alignCenter, sortable : false},   		   
					{field:'N_MON_ID', title:'장비 ID', width:'25%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'N_TRUNK_NUMBER', title:'Trunk Number', width:'25%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_TRUNK_NAME', title:'Trunk Name', width:'25%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_MON_NAME', title:'장비 명', width:'25%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_MON_IP', title:'장비 IP', width:'25%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_GROUP_NAME', title:'센터 구분', width:'25%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}}
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

		//장비 전체 체크 이벤트
		$('#all_check').on('change', function() {
			if (this.checked) {
				$('input[name=sel_check]').prop('checked', true);
			} else {
				$('input[name=sel_check]').prop('checked', false);
			}
		});
		
		$('#btn_remove').on('click', del);
		
		$("#trunk_name_grid").on("dblclick", "tbody > tr", selectedRow);
	}

	//장비 체크 이벤트
	function checkAll() {
		$('input[name=sel_check]').length === $('input[name=sel_check]:checked').length
				? $('#all_check').prop('checked', true)
				: $('#all_check').prop('checked', false);
	}
	
	// Selected Grid Row
	function selectedRow(event) {

		// 검색 조건과 페이지 번호를 JSON 형태의 String 으로 넘겼다가 다시 받아오기 위함
		var param = {
			'S_TRUNK_NAME'	: $('#S_TRUNK_NAME').val().trim(),
			'N_TRUNK_NUMBER': $('#N_TRUNK_NUMBER').val().trim(),
			'SEARCH_TYPE'   : $.trim($('#SEARCH_TYPE').val()),
			'SEARCH_KEYWORD': $.trim($('#SEARCH_KEYWORD').val()),
			'currentPageNo'	: grid.dataSource.page()
		};
		var paramStr = JSON.stringify(param);

		$('#frm')
			.append('<input type="hidden" name="searchParam" value="' + encodeURIComponent(paramStr) + '">')
			.append('<input type="hidden" name="S_TRUNK_NAME" value="' + grid.dataItem(grid.select()).S_TRUNK_NAME + '">')
			.append('<input type="hidden" name="N_TRUNK_NUMBER" value="' + grid.dataItem(grid.select()).N_TRUNK_NUMBER + '">')
			.append('<input type="hidden" name="N_MON_ID" value="' + grid.dataItem(grid.select()).N_MON_ID + '">')
			.attr({'action' : cst.contextPath() + '/admin/go_prgm.mon.trunk_name.update.htm'})
			.submit();

		event.preventDefault();
	}

	// 삭제
	function del()
	{
		if(!confirm("정말 삭제 하시겠습니까?"))
			return;

		var trunkNameGrid = $('#trunk_name_grid').data('kendoGrid');
	    var trunkNameDataItem = trunkNameGrid.dataSource.data();
	    
	    var tmp_trunkName = "";
	    $("input[name=sel_check]").each(function(index) {
	    	if ($("input[name=sel_check]")[index].checked == true) {
				if (tmp_trunkName != "") {	
					tmp_trunkName += ",";
				}
				tmp_trunkName += trunkNameDataItem[index].S_TRUNK_NAME;
				tmp_trunkName += "::" + trunkNameDataItem[index].N_TRUNK_NUMBER;
				tmp_trunkName += "::" + trunkNameDataItem[index].N_MON_ID;
	    	}
		});
	    $("#trunk_name_delete_list").val(tmp_trunkName);
	    
		var url = "<c:url value='/admin/trunk_name/delete.htm'/>";
		var param = $("form[name='trunk_name_delete_form']").serialize();
		
		$.post(url, param, function(str){
			var data = $.parseJSON(str);
			if(data.RSLT != null && data.RSLT > 0) {
				alert('삭제되었습니다.');
				goListPage();
				return;
			}
			else {
				alert("삭제 실패 하였습니다.\n" + data.ERRMSG + "");
				goListPage();
				return;
			}
		});
	}
	
	function goListPage(event) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.trunk_name.retrieve.htm').submit();
	}
</script>
