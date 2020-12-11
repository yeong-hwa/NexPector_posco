<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<style type="text/css">
	.manaint_f{height: 26px;}
	.k-datetimepicker .k-picker-wrap .k-icon{margin:0 2px;margin-top: 5px;}
	.k-i-calendar{margin-top: 4px;}
</style>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>작업 관리</h2><span>Home &gt; 감시장비 관리 &gt; 작업 관리</span></div></div>
<!-- location // -->

<!-- 내용 -->
<!-- 검색영역 -->
<form id="jobmanagement_delete_form" name="jobmanagement_delete_form" data-role="validator">
<input type="hidden" id="jobmanagement_delete_list" name="JOBMANAGEMENT_DELETE_LIST" value=""/>
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<dd>
					<strong>작업명</strong><input type="text" name="S_NAME" id="S_NAME" value="${param.S_NAME}" class="int_f input_search"/>
					<strong style="margin-left:10px;">작업시작일</strong>
						<input type="text" name="D_STIME" id="D_STIME" value="" class="manaint_f input_search" onkeydown="return false;"/> ~
						<input type="text" name="D_ETIME" id="D_ETIME" value="" class="manaint_f input_search" onkeydown="return false;"/>
<!-- 					<select style="margin-left:10px;" name="SEARCH_TYPE" id="SEARCH_TYPE">
                		<option value="ID">장비ID</option>
                		<option value="NM">장비명</option>
                		<option value="IP">장비IP</option>
                	</select> 
                	<input type="text" name="SEARCH_KEYWORD" id="SEARCH_KEYWORD" value="${param.SEARCH_KEYWORD}" class="int_f input_search"/>	-->			
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
				<!-- <a href="#" id="btn_export" class="css_btn_class3" style="margin-left:5px;">Export</a> -->
				<a href="<c:url value="/admin/go_prgm.mon.jobmanagement.insert.htm"/>" id="btn_save" class="css_btn_class">등록</a>
				<a href="#" id="btn_remove" class="css_btn_class">삭제</a>
			</span>
		</div>
	</div>

	<!-- stitle // -->
	<!-- table_typ2-4 -->
	<div id="jobmanagement_gird" class="table_typ2-4">
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
	var sDateTime, eDateTime;
	var grid;
	
	$(document).ready(function() {
		// create DateTimePicker from input HTML element
		var currentDate = new Date(),
			beforeSevenDate = new Date();

		beforeSevenDate.setDate(currentDate.getDate() - 7);

		sDateTime = $("#D_STIME").kendoDatePicker({
			format: "yyyy-MM-dd",
			value: beforeSevenDate
		}).data('kendoDatePicker');

		eDateTime = $("#D_ETIME").kendoDatePicker({
			format: "yyyy-MM-dd",
			value:currentDate
		}).data('kendoDatePicker');
		
		initGrid();
		initEvent();

		var searchParam = '${param.searchParam}';
		if ('' !== searchParam) {
			initSearchData(searchParam);
		}
	});
	
	function initSearchData(searchParam) {
		var param = JSON.parse(decodeURIComponent(searchParam));
		$('#S_NAME').val(param.S_NAME);
		sDateTime.value(param.D_STIME);
		eDateTime.value(param.D_ETIME);
		$('#SEARCH_TYPE').val(param.SEARCH_TYPE);
		$('#SEARCH_KEYWORD').val(param.SEARCH_KEYWORD);
		var page = parseInt(param.currentPageNo);
		grid.dataSource.fetch(function() {
			grid.dataSource.page(page);
		});
	}
	
	// 사용자 목록 Grid
	function initGrid() {
		
/* 		// 작업 일시 시작 일시
		$("#D_STIME").val(kendo.toString(sDateTime.value(), 'yyyyMMddHHmm'));

		// 작업 일시 종료 일시
		$("#D_ETIME").val(kendo.toString(eDateTime.value(), 'yyyyMMddHHmm')); */
		
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/kendoPagination_jobmanagement.select_list.htm",
					data 		: function(data) {
						return {
							'S_NAME'   : $.trim($('#S_NAME').val()),
							'S_MON_NAME'   : $.trim($('#S_MON_NAME').val()),
							'S_MON_IP'   : $.trim($('#S_MON_IP').val()),
							'D_STIME'   : $.trim(kendo.toString(sDateTime.value(), 'yyyyMMdd')),
							'D_ETIME'   : $.trim(kendo.toString(eDateTime.value(), 'yyyyMMdd')),
							'D_UPDATE_TIME'   : $.trim($('#D_UPDATE_TIME').val())
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

		grid = $("#jobmanagement_gird")
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
					{field:'S_NAME', title:'작업명', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_GROUP_NAME', title:'센터구분', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_TYPE_NAME', title:'장비타입', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'MON_CNT', title:'장비대수', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'D_STIME', title:'작업시작일', width:'20%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'D_ETIME', title:'작업종료일', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'D_UPDATE_TIME', title:'등록일', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_REPEAT_TYPE', title:'반복', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}}
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

		$('#btn_export').on('click', function(event) {
			event.preventDefault();

			var params = {
				'S_NAME'   : $.trim($('#S_NAME').val()),
				'S_MON_NAME'   : $.trim($('#S_MON_NAME').val()),
				'S_MON_IP'   : $.trim($('#S_MON_IP').val()),
				'D_STIME'   : $.trim(kendo.toString(sDateTime.value(), 'yyyyMMdd')),
				'D_ETIME'   : $.trim(kendo.toString(eDateTime.value(), 'yyyyMMdd')),
				'D_UPDATE_TIME'   : $.trim($('#D_UPDATE_TIME').val())
			};

			location.href = '<c:url value="/admin/jobmanagement_file_export.htm"/>' + '?' + $.param(params);
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
		
		$("#jobmanagement_gird").on("dblclick", "tbody > tr", selectedRow);
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
			'S_NAME'		: $('#S_NAME').val().trim(),
			'D_STIME'		: $('#D_STIME').val().trim(),
			'D_ETIME'		: $('#D_ETIME').val().trim(),
			'SEARCH_TYPE'   : $.trim($('#SEARCH_TYPE').val()),
			'SEARCH_KEYWORD': $.trim($('#SEARCH_KEYWORD').val()),
			'currentPageNo'	: grid.dataSource.page()
		};
		var paramStr = JSON.stringify(param);

		$('#frm')
			.append('<input type="hidden" name="searchParam" value="' + encodeURIComponent(paramStr) + '">')
			.append('<input type="hidden" name="S_NAME" value="' + grid.dataItem(grid.select()).S_NAME + '">')
			.append('<input type="hidden" name="S_WORK_KEY" value="' + grid.dataItem(grid.select()).S_WORK_KEY + '">')
			.append('<input type="hidden" name="updateFlag" value="U">')
			.attr({'action' : cst.contextPath() + '/admin/go_prgm.mon.jobmanagement.insert.htm'})
			.submit();

		event.preventDefault();
	}

	// 삭제
	function del()
	{
		if(!confirm("정말 삭제 하시겠습니까?"))
			return;

		var jobmanagementGrid = $('#jobmanagement_gird').data('kendoGrid');
	    var jobmanagementDataItem = jobmanagementGrid.dataSource.data();
	    
	    var tmp_jobmanagement = "";
	    $("input[name=sel_check]").each(function(index) {
	    	if ($("input[name=sel_check]")[index].checked == true) {
				if (tmp_jobmanagement != "") {	
					tmp_jobmanagement += ",";
				}
				tmp_jobmanagement += jobmanagementDataItem[index].S_WORK_KEY;
	    	}
		});
	    $("#jobmanagement_delete_list").val(tmp_jobmanagement);
	    
		var url = "<c:url value='/admin/jobwork_delete.htm'/>";
		var param = $("form[name='jobmanagement_delete_form']").serialize();
		
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
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.jobmanagement.retrieve.htm').submit();
	}
</script>
