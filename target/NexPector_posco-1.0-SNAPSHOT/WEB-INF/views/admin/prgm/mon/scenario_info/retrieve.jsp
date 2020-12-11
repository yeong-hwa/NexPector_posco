<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>시나리오 정보 관리</h2><span>Home &gt; 감시장비 관리 &gt; 시나리오 정보 관리</span></div></div>
<!-- location // -->

<!-- 내용 -->
<!-- 검색영역 -->
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<dd>
					<strong>장비그룹</strong>
					<cmb:combo qryname="cmb_svr_group" seltagname="N_GROUP_CODE" firstdata="전체" 
					           etc="id=\"N_GROUP_CODE\" class=\"input_search\" style=\"width:100;\""/>
					
					<strong style="margin-left:30px;">회사구분</strong>
					<cmb:combo qryname="common.cmb_code" seltagname="S_COMPANY" firstdata="전체"
							   etc="id=\"S_COMPANY\" class=\"input_search\" style=\"width:100;\"" param="S_GROUP_CODE=COMPANY"/>
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
		<div class="st_under"><h4>건수 : &nbsp;<span id="total_count">0</span></h4><span><a href="<c:url value="/admin/go_prgm.mon.scenario_info.insert.htm"/>" id="btn_save" class="css_btn_class">등록</a></span></div>
	</div>
	<!-- stitle // -->
	<!-- table_typ2-4 -->
	<div id="scenario_info_gird" class="table_typ2-4">
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
		$('#scenario_info_gird').data('kendoGrid').dataSource.page(param.currentPageNo);
	}
	
	// Event 등록
	function initEvent() {

		$(".input_search").keypress(function(event){
			if(kendo.keys.ENTER === event.keyCode)
				$("#search").click();
		});
		
		$('#search').on('click', function(event) {
			event.preventDefault();
			$("#scenario_info_gird").data('kendoGrid').dataSource.read();
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
					url 		: cst.contextPath() + "/admin/kendoPagination_scenario_info.select_list.htm",
					data 		: function(data) {
						return {
							'N_GROUP_CODE'   : $.trim($('#N_GROUP_CODE').val()),
							'S_COMPANY'   : $.trim($('#S_COMPANY').val())
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

		$("#scenario_info_gird")
		.kendoGrid($.extend(kendoGridDefaultOpt, {
			dataSource	: dataSource,
			change		: selectedRow,
			sortable	: {
				mode 		: 'multiple',
				allowUnsort : true
			},
			columns		: [
				{field:'S_NAME', title:'회사구분', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				{field:'S_GROUP_NAME', title:'서버그룹', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				{field:'S_APP_ID', title:'시나리오ID', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				{field:'S_APP_NAME', title:'시나리오 명', width:'35%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				{field:'S_APP_DESC', title:'시나리오 설명', width:'35%', attributes:{style:'text-align:left'}, headerAttributes:{style:'text-align:center'}}
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
			'currentPageNo'		: $('#scenario_info_gird').data('kendoGrid').dataSource.page()
		};
		var paramStr = JSON.stringify(param);
		$('#frm')
			.append('<input type="hidden" name="searchParam" value="' + encodeURIComponent(paramStr) + '">')
			.append('<input type="hidden" name="S_COMPANY" value="' + this.dataItem(this.select()).S_COMPANY + '">')
			.append('<input type="hidden" name="N_GROUP_CODE" value="' + this.dataItem(this.select()).N_GROUP_CODE + '">')
			.append('<input type="hidden" name="S_APP_ID" value="' + this.dataItem(this.select()).S_APP_ID + '">')
			.append('<input type="hidden" name="updateFlag" value="U">')
			.attr({'action' : cst.contextPath() + '/admin/go_prgm.mon.scenario_info.insert.htm'})
			.submit();

		event.preventDefault();
	}
</script>