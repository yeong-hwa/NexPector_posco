<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>Trunk Group 관리</h2><span>Home &gt; 감시장비 관리 &gt; Trunk Group 관리</span></div></div>
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
					<cmb:combo qryname="cmb_svr_group" seltagname="N_GROUP_CODE" firstdata="전체" etc="id=\"N_GROUP_CODE\""/>
					<%-- 
					<cmb:combo qryname="common.cmb_code" seltagname="S_CENTER" firstdata="전체"
												  	etc="id=\"S_CENTER\" class=\"input_search\" style=\"width:100;\"" param="S_GROUP_CODE=CENTER"/>
					 --%>							  	
					<strong style="margin-left:30px;">그룹명</strong><input type="text" name="S_DIALING_NAME" id="S_DIALING_NAME" value="${param.S_DIALING_NAME}" class="int_f input_search"/>
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
		<div class="st_under"><h4>건수 : &nbsp;<span id="total_count">0</span></h4><span><a href="<c:url value="/admin/go_prgm.mon.trunk_group.insert.htm"/>" id="btn_save" class="css_btn_class">등록</a></span></div>
	</div>
	<!-- stitle // -->
	<!-- table_typ2-4 -->
	<div id="trunk_group_info_gird" class="table_typ2-4">
	</div>
</div>
<!-- manager_contBox1 // -->
<!-- 내용 // -->

<form id="frm"></form>

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

	// 사용자 목록 Grid
	function initGrid() {
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/kendoPagination_trunk_group_info.select_list.htm",
					data 		: function(data) {
						return {
							'N_GROUP_CODE'   	: $('#N_GROUP_CODE').val(),
							'S_DIALING_NAME'   	: $.trim($('#S_DIALING_NAME').val())
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

		grid = $("#trunk_group_info_gird")
			.kendoGrid($.extend(kendoGridDefaultOpt, {
				dataSource	: dataSource,
				//change		: selectedRow,
				sortable	: {
					mode 		: 'multiple',
					allowUnsort : true
				},
				dataBound	: girdRowdblclick,
				columns		: [
					{field:'S_COMPANY', title:'장비그룹', width:'30%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					//{field:'S_CENTER', title:'센터', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_DIALING_NAME', title:'Trunk 그룹명', width:'20%', attributes:{style:'text-align:left'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_NAME', title:'Trunk Traffic', width:'50%', attributes:{style:'text-align:left'}, headerAttributes:{style:'text-align:center'}, template:'# if (S_NAME == "-") { # #=S_NAME# # } else { # #=S_NAME#외 #=CNT#건 # } #'}
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
			'N_GROUP_CODE'   	: $('#N_GROUP_CODE').val(),
			'S_DIALING_NAME'   	: $.trim($('#S_DIALING_NAME').val()),
			'currentPageNo'		: grid.dataSource.page()
		};
		var paramStr = JSON.stringify(param);

		$('#frm')
			.append('<input type="hidden" name="searchParam" value="' + encodeURIComponent(paramStr) + '">')
			.append('<input type="hidden" name="N_DIALING_CODE" value="' + grid.dataItem(grid.select()).N_DIALING_CODE + '">')
			.append('<input type="hidden" name="updateFlag" value="U">')
			.append('<input type="hidden" name="req_data" value="data;trunk_group_info.selectDetailDialingType:map">')
			.attr({'action' : cst.contextPath() + '/admin/go_prgm.mon.trunk_group.insert.htm'})
			.submit();

		event.preventDefault();
	}

	function initSearchData(searchParam) {
		var param = JSON.parse(decodeURIComponent(searchParam));
		$('#N_GROUP_CODE').val(param.N_GROUP_CODE);
		$('#S_DIALING_NAME').val(param.S_DIALING_NAME);
		var page = parseInt(param.currentPageNo);
		grid.dataSource.fetch(function() {
			grid.dataSource.page(page);
		});
	}
</script>