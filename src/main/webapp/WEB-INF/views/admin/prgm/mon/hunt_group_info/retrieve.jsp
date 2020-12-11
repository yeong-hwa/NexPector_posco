<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>HUNT 그룹 정보 관리</h2><span>Home &gt; 감시장비 관리 &gt; HUNT 그룹 정보 관리</span></div></div>
<!-- location // -->

<!-- 내용 -->
<!-- 검색영역 -->
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<dd>
					<strong>회사구분</strong>
					<cmb:combo qryname="common.cmb_code" seltagname="S_COMPANY" firstdata="전체"
							   etc="id=\"S_COMPANY\" class=\"input_search\" style=\"width:100;\"" param="S_GROUP_CODE=COMPANY"/>

					<strong style="margin-left:30px;">센터구분</strong>
					<cmb:combo qryname="common.cmb_code" seltagname="S_CENTER" firstdata="전체"
							   etc="id=\"S_CENTER\" class=\"input_search\" style=\"width:100;\"" param="S_GROUP_CODE=CENTER"/>
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
		<div class="st_under"><h4>건수 : &nbsp;<span id="total_count">0</span></h4><span><a href="<c:url value="/admin/go_prgm.mon.hunt_group_info.insert.htm"/>" id="btn_save" class="css_btn_class">등록</a></span></div>
	</div>
	<!-- stitle // -->
	<!-- table_typ2-4 -->
	<div id="hunt_group_info_gird" class="table_typ2-4">
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
		$('#S_SKILL_GROUP').val(param.S_SKILL_GROUP);
		$('#S_COMPANY').val(param.S_COMPANY);
		$('#S_CENTER').val(param.S_CENTER);
		$('#hunt_group_info_gird').data('kendoGrid').dataSource.page(param.currentPageNo);
	}
	
	// Event 등록
	function initEvent() {

		$(".input_search").keypress(function(event){
			if(kendo.keys.ENTER === event.keyCode)
				$("#search").click();
		});
		
		$('#search').on('click', function(event) {
			event.preventDefault();
			$("#hunt_group_info_gird").data('kendoGrid').dataSource.read();
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
					url 		: cst.contextPath() + "/admin/kendoPagination_hunt_group_info.select_list.htm",
					data 		: function(data) {
						return {
							'S_SKILL_GROUP'   : $.trim($('#S_SKILL_GROUP').val()),
							'S_COMPANY'   : $.trim($('#S_COMPANY').val()),
							'S_CENTER'   : $.trim($('#S_CENTER').val())
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

		$("#hunt_group_info_gird")
		.kendoGrid($.extend(kendoGridDefaultOpt, {
			dataSource	: dataSource,
			change		: selectedRow,
			sortable	: {
				mode 		: 'multiple',
				allowUnsort : true
			},
			columns		: [
				{field:'S_SKILL_GROUP', title:'스킬 그룹', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				{field:'S_COMPANY', title:'회사구분', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				{field:'S_CENTER', title:'센터구분', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				{field:'S_TEAM', title:'팀', width:'20%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				{field:'S_CME_GROUP', title:'CME 그룹', width:'20%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				{field:'S_DESC', title:'상세설명', width:'40%', attributes:{style:'text-align:left'}, headerAttributes:{style:'text-align:center'}}
			]
		}));
	}

	// Selected Grid Row
	function selectedRow(event) {

		// 검색 조건과 페이지 번호를 JSON 형태의 String 으로 넘겼다가 다시 받아오기 위함
		var param = {
			'S_SKILL_GROUP'	: $.trim($('#S_SKILL_GROUP').val()),
			'S_COMPANY'	: $.trim($('#S_COMPANY').val()),
			'S_CENTER'	: $.trim($('#S_CENTER').val()),
			'currentPageNo'		: $('#hunt_group_info_gird').data('kendoGrid').dataSource.page()
		};
		var paramStr = JSON.stringify(param);
		$('#frm')
			.append('<input type="hidden" name="searchParam" value="' + encodeURIComponent(paramStr) + '">')
			.append('<input type="hidden" name="S_SKILL_GROUP" value="' + this.dataItem(this.select()).S_SKILL_GROUP + '">')
			.append('<input type="hidden" name="S_COMPANY" value="' + this.dataItem(this.select()).S_COMPANY + '">')
			.append('<input type="hidden" name="S_CENTER" value="' + this.dataItem(this.select()).S_CENTER + '">')
			.append('<input type="hidden" name="updateFlag" value="U">')
			.attr({'action' : cst.contextPath() + '/admin/go_prgm.mon.hunt_group_info.insert.htm'})
			.submit();

		event.preventDefault();
	}
</script>