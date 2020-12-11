<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>상담 스킬 관리</h2><span>Home &gt; 감시장비 관리 &gt; 상담 스킬 관리</span></div></div>
<!-- location // -->

<!-- 내용 -->
<!-- 검색영역 -->
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<dd>
					<strong>상담 스킬 ID</strong>
					<input type="text" name="SPLIT_ID" id="SPLIT_ID" value="${param.SPLIT_ID}" class="int_f input_search" style="width:120px;"/>
				</dd>
			</dl>
			<dl>
				<dd>
					<strong>상담 스킬 명</strong>
					<input type="text" name="SPLIT_NAME" id="SPLIT_NAME" value="${param.SPLIT_NAME}" class="int_f input_search" style="width:120px;"/>
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
		<div class="st_under"><h4>건수 : &nbsp;<span id="total_count">0</span></h4><span><a href="<c:url value="/admin/go_prgm.mon.consult_skill.insert.htm"/>" id="btn_save" class="css_btn_class">등록</a></span></div>
	</div>
	<!-- stitle // -->
	<!-- table_typ2-4 -->
	<div id="grid" class="table_typ2-4">
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
		$('#SPLIT_ID').val(param.SPLIT_ID);
		$('#SPLIT_NAME').val(param.SPLIT_NAME);
		$('#grid').data('kendoGrid').dataSource.page(param.currentPageNo);
	}
	
	// Event 등록
	function initEvent() {

		$(".input_search").keypress(function(event){
			if(kendo.keys.ENTER === event.keyCode)
				$("#search").click();
		});
		
		$('#search').on('click', function(event) {
			event.preventDefault();
			$("#grid").data('kendoGrid').dataSource.page(1);
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
					url 		: cst.contextPath() + "/admin/kendoPagination_consult_skill.select_list.htm",
					data 		: function(data) {
						return {
							'SPLIT_ID' : $.trim($('#SPLIT_ID').val()),
							'SPLIT_NAME' : $.trim($('#SPLIT_NAME').val())
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

		$("#grid")
		.kendoGrid($.extend(kendoGridDefaultOpt, {
			dataSource	: dataSource,
			change		: selectedRow,
			sortable	: {
				mode 		: 'multiple',
				allowUnsort : true
			},
			columns		: [
				{field:'SPLIT_ID', title:'상담 스킬 ID', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				{field:'SPLIT_NAME', title:'상담 스킬명', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}}
			]
		}));
	}

	// Selected Grid Row
	function selectedRow(event) {

		// 검색 조건과 페이지 번호를 JSON 형태의 String 으로 넘겼다가 다시 받아오기 위함
		var param = {
			'SPLIT_ID'	: $.trim($('#SPLIT_ID').val()),
			'SPLIT_NAME'	: $.trim($('#SPLIT_NAME').val())
		};
		var paramStr = JSON.stringify(param);
		$('#frm')
			.append('<input type="hidden" name="searchParam" value="' + encodeURIComponent(paramStr) + '">')
			.append('<input type="hidden" name="SPLIT_ID" value="' + this.dataItem(this.select()).SPLIT_ID + '">')
			.append('<input type="hidden" name="updateFlag" value="U">')
			.attr({'action' : cst.contextPath() + '/admin/go_prgm.mon.consult_skill.insert.htm'})
			.submit();

		event.preventDefault();
	}
</script>