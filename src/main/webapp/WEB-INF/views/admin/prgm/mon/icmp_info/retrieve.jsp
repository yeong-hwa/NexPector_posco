<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<style type="text/css">
	select{width: 100px;}
	.k-grid td{padding: 0.2em 0.2em}
	/*.k-grid .k-grid-header .k-header .k-link {padding: 0.2em 0.2em}*/
</style>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>ICMP 정보 관리</h2><span>Home &gt; 감시장비 관리 &gt; ICMP 정보 관리</span></div></div>
<!-- location // -->

<!-- 내용 -->
<!-- 검색영역 -->
<%-- 
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<dd>
					<strong>장비ID</strong><input type="text" name="SN_MON_ID" id="SN_MON_ID" value="${param.SN_MON_ID}" class="int_f input_search"/>
					<strong style="margin-left:30px;">장비명</strong><input type="text" name="SS_MON_NAME" id="SS_MON_NAME" value="${param.SS_MON_NAME}" class="int_f input_search"/>
					<strong style="margin-left:30px;">장비IP</strong><input type="text" name="SS_MON_IP" id="SS_MON_IP" value="${param.SS_MON_IP}" class="int_f input_search"/>
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
 --%>
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
				<a href="<c:url value="/admin/go_prgm.mon.icmp_info.insert.htm"/>" id="btn_save" class="css_btn_class">등록</a>&nbsp;
				<!-- <a href="#" id="btn_remove" class="css_btn_class">삭제</a> -->
			</span>
		</div>
	</div>	
	<!-- stitle // -->

	<!-- 사용자선택 -->
	<div class="mana_box3">
		<div class="box_a">
			<table  cellpadding="0" cellspacing="0" class="table_left_s1">
				<!-- 
				<tr>
					<td class="bgtl1"></td>
					<td class="bgtc1">
						<strong>장비그룹</strong><select name="sel_group_code" id="sel_group_code"><option value="">전체</option></select>
						<strong style="margin-left:30px;">장비타입</strong><select name="sel_type_code" id="sel_type_code"><option value="">전체</option></select>
					</td>
					<td class="bgtr1"></td>
				</tr>
				 -->
				<tr>
					<td class="bgtl1"></td>
					<td class="bgtc1">
						<strong>장비리스트</strong>
					</td>
					<td class="bgtr1"></td>
				</tr>
				<tr style="height: 320px;">
					<td class="bgml1"></td>
					<td class="bgmc1">
						<div id="server_info_grid" style="margin: 10px 0px 0px 0px;">
						</div>
					</td>
					<td class="bgmr1"></td>
				</tr>
				<tr>
					<td class="bgbl1"></td>
					<td class="bgbc1"></td>
					<td class="bgbr1"></td>
				</tr>
			</table>
			<table class="table_left_s1-f">
				<tr><td></td></tr>
			</table>
			<form id="icmp_list_info_form" method="post">
				<table  cellpadding="0" cellspacing="0" class="table_left_s2">
					<tr>
						<td class="bgtl1"></td>
						<td class="bgtc1">
							<strong>ICMP리스트</strong>
						</td>
						<td class="bgtc1"></td>
						<td class="bgtr1"></td>
					</tr>
					<tr style="height: 320px;">
						<td class="bgml1"></td>
						<td class="bgmc1" colspan="2">
							<div id="icmp_list_grid" style="margin: 10px 0px 0px 0px;">
							</div>
						</td>
						<td class="bgmr1"></td>
					</tr>
					<tr>
						<td class="bgbl1"></td>
						<td class="bgbc1" colspan="2"></td>
						<td class="bgbr1"></td>
					</tr>
				</table>
			</form>
	
		</div>
	</div>
	<!-- 사용자선택//-->

</div>
<!-- manager_contBox1 // -->
<form id="frm">
		<input type="hidden" id="sMonName" value=""/>
		<input type="hidden" id="sMonIp" value=""/>
		<input type="hidden" id="groupName" value=""/>
		<input type="hidden" id="typeName" value=""/>
		<input type="hidden" id="styleName" value=""/>
</form>
<!-- 내용 // -->
<script type="text/javascript">
	
	var grid;

	$(document).ready(function() {
		initEvent();
		initServerInfoGrid();
		initIcmpGrid();

		/* 
		cfn_makecombo_opt($('#sel_group_code'), cst.contextPath() + '/admin/lst_cmb_svr_group.htm');
		cfn_makecombo_opt($('#sel_type_code'), cst.contextPath() + '/admin/lst_cmb_svr_type.htm');
		 */

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
		/* 
		var param = JSON.parse(decodeURIComponent(searchParam));
		$('#SN_MON_ID').val(param.SN_MON_ID);
		$('#SS_MON_NAME').val(param.SS_MON_NAME);
		$('#SS_MON_IP').val(param.SS_MON_IP);
		$('#critical_value_info_gird').data('kendoGrid').dataSource.page(param.currentPageNo);
		 */
	}
	
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
			$("#server_info_grid").data('kendoGrid').dataSource.read();
		});
		
		// 적용버튼
		//$('#btn_apply').on('click', applyUserServerInfo);
	}

	// 장비 목록 Grid
	function initServerInfoGrid() {
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/kendoPagination_icmp_info.icmp_svrlst.htm",
					data 		: function(data) {
						return {
							/* 
							'SN_MON_ID'   : $.trim($('#SN_MON_ID').val()),
							'SS_MON_NAME' : $.trim($('#SS_MON_NAME').val()),
							'SS_MON_IP' : $.trim($('#SS_MON_IP').val()),
							'f_N_GROUP_CODE' : $.trim($('#sel_group_code').val()),
							'f_N_TYPE_CODE' : $.trim($('#sel_type_code').val()),
							 */
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

		grid = $("#server_info_grid")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: dataSource,
				change		: searchIcmpDataSource,
				pageable	: {
					messages : {
						empty	: "<strong>No data</strong>",
						display : "<span>전체<strong style='color: #f35800;'>{2}</strong> 개 항목</span>"
					}
				},
				sortable	: true,
				scrollable	: true,
				resizable	: false,				
				columns		: [
					{field:'N_MON_ID', title:'장비ID', width:'15%', attributes:alignCenter, headerAttributes:alignCenter},
					{field:'S_MON_NAME', title:'장비명', width:'30%', attributes:alignCenter, headerAttributes:alignCenter},
					{field:'S_MON_IP', title:'장비IP', width:'20%', attributes:alignCenter, headerAttributes:alignCenter},
					{field:'TYPE_NAME', title:'장비타입', width:'15%', attributes:alignCenter, headerAttributes:alignCenter},
					{field:'GROUP_NAME', title:'장비그룹', width:'20%', attributes:alignCenter, headerAttributes:alignCenter},
				],
				height		: '305px'
			})).data('kendoGrid');
	}

	function initIcmpGrid() {
		$("#icmp_list_grid")
		.kendoGrid($.extend({}, kendoGridDefaultOpt, {
			dataSource	: [],
			change		: selectedServerGridRow,
			pageable	: {
				messages : {
					empty	: "<strong>No data</strong>",
					display : "<span>전체<strong style='color: #f35800;'>{2}</strong> 개 항목</span>"
				}
			},
			sortable	: true,
			scrollable	: true,
			resizable	: false,
			columns		: [
				{field:'OLD_S_ICMP_IP', title:'장비IP', width:'15%', attributes:alignCenter, headerAttributes:alignCenter},
				{field:'OLD_N_MON_ID', title:'장비ID', width:'20%', attributes:alignCenter, headerAttributes:alignCenter},
				{field:'N_CHECK_TIME', title:'체크주기', width:'15%', attributes:alignCenter, headerAttributes:alignCenter},
				{field:'N_RES_TIME', title:'응답시간(초)', width:'15%', attributes:alignCenter, headerAttributes:alignCenter},
				{field:'N_TIME_OUT', title:'타임아웃(초)', width:'15%', attributes:alignCenter, headerAttributes:alignCenter},
				{field:'N_ALM_CNT', title:'장애인식카운트', width:'15%', attributes:alignCenter, headerAttributes:alignCenter},
				{field:'S_ALM_RATING_NAME', title:'장애등급', width:'15%', attributes:alignCenter, headerAttributes:alignCenter}
			],
			height		: '305px'
		}));
	}

	function selectedServerGridRow(event) {
		
		$('#frm')
			.append('<input type="hidden" name="N_MON_ID" value="' + this.dataItem(this.select()).N_MON_ID + '">')
			.append('<input type="hidden" name="S_MON_NAME1" value="' + encodeURIComponent($("#sMonName").val()) + '">')
			.append('<input type="hidden" name="S_MON_IP1" value="' + $("#sMonIp").val() + '">')
			.append('<input type="hidden" name="GROUP_NAME1" value="' + encodeURIComponent($("#groupName").val()) + '">')
			.append('<input type="hidden" name="TYPE_NAME1" value="' + $("#typeName").val() + '">')
			.append('<input type="hidden" name="STYLE_NAME1" value="' + $("#styleName").val() + '">')
			.append('<input type="hidden" name="updateFlag" value="U">')
			.attr({'action' : cst.contextPath() + '/admin/go_prgm.mon.icmp_info.insert.htm'})
			.submit();

		event.preventDefault();
	}

	function searchIcmpDataSource() {

		var monId = this.dataItem(this.select()).N_MON_ID;
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/kendoPagination_icmp_info.select_list.htm",
					data 		: function(data) {
						return {
							'N_MON_ID' 	: monId
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
			pageSize		: 10,
			serverPaging	: true,
			serverSorting	: true
		});

		var serverGrid = $('#icmp_list_grid').data('kendoGrid');
		serverGrid.setDataSource(dataSource);
		
		$("#sMonName").val(this.dataItem(this.select()).S_MON_NAME);
		$("#sMonIp").val(this.dataItem(this.select()).S_MON_IP);
		$("#groupName").val(this.dataItem(this.select()).GROUP_NAME);
		$("#typeName").val(this.dataItem(this.select()).TYPE_NAME);
		$("#styleName").val(this.dataItem(this.select()).STYLE_NAME);
		
	}

</script>