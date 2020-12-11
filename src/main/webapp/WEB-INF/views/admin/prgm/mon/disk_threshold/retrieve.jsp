<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<style type="text/css">
	.k-grid-header, .k-grid-toolbar {height: 30px;}
</style>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>임계치(Disk) 적용 관리</h2><span>Home &gt; 감시장비 관리 &gt; 임계치(Disk) 적용 관리</span></div></div>
<!-- location // -->

<!-- 내용 -->
<!-- 검색영역 -->
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
		<div class="st_under"><h4>건수 : &nbsp;<span id="total_count">0</span></h4><%--<span><a href="<c:url value="/admin/go_prgm.system.menu_info.insert.htm"/>" id="btn_save" class="css_btn_class">등록</a></span>--%></div>
	</div>
	<!-- stitle // -->
	<!-- table_typ2-4 -->
	<div id="disk_threshold_grid" class="table_typ2-4">
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
	function initGrid() {
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: '<c:url value="/admin/kendoPagination_disk_threshold.select_list.htm"/>',
					data 		: function(data) {
						return {
							'N_GROUP_CODE'  : $.trim($('#N_GROUP_CODE').val()),
							'N_TYPE_CODE'   : $.trim($('#N_TYPE_CODE').val()),
							'SEARCH_TYPE'   : $.trim($('#SEARCH_TYPE').val()),
							'SEARCH_KEYWORD': $.trim($('#SEARCH_KEYWORD').val())
						};
					}
				},
				update		: {
					url		: "<c:url value="/admin/disk_threshold/update.htm"/>" + "?_method=put",
					type	: 'post',
					dataType: "json",
					contentType	: 'application/json;charset=UTF-8'
				},
				/*
				destroy		: {
					url		: "<c:url value="/admin/menu/delete.htm"/>" + "?_method=delete",
					type	: 'post',
					dataType: "json",
					contentType	: 'application/json;charset=UTF-8'
				},
				create		: {
					url		: "<c:url value="/admin/menu/insert.htm"/>",
					type	: 'post',
					dataType: "json",
					contentType	: 'application/json;charset=UTF-8'
				},
				*/
				parameterMap: function (data, operation) {

					/* RESTful 방식 사용 시
					 http 파라미터에 _method = "put|delete" 를 지정하고 dataType 을 post 로 지정하면
					 Spring httpMethodFilter 에서 내부적으로 해당 method 타입으로 변환하여 파라미터가 정상적으로 전송된다. */

					return kendo.stringify(data);
				}
			},
			schema			: {
				model: {
					id : "N_MON_ID",
					fields: {
						'N_MON_ID'		: { type: "number", editable:false},
						'S_MON_NAME'	: { type: "string", editable:false},
						'S_MON_IP'		: { type: "string", editable:false},
						'S_DISK_PATH'	: { type: "string", editable:false},
						'S_GROUP_NAME'	: { type: "string", editable:false},
						'S_TYPE_NAME'	: { type: "string", editable:false},
						'F_THRESHOLD'	: { type: "string", defaultValue: "Y", validation: { min: 1, required: {message : "사용여부는 필수 값 입니다."} } },
						'F_USE_NAME'	: { type: "string", defaultValue: "사용" }
					}
				},
				data	: function(data) {
					return data;
				},
				total 	: function(response) {
					var totalCount = response.length > 0 ? response[0].TOTAL_COUNT : 0;
					$('#total_count').text(totalCount);
					return totalCount;
				}
			},
			sync			: function() { // close edit window when update request finished
				grid.dataSource.read();
				alert("적용 완료되었습니다.");
			},
			error			: function(e) {
				alert("변경 실패하였습니다.");
				console.log(e.status);
			},
			pageSize		: cst.countPerPage(),
			batch			: true,
			serverPaging	: true,
			serverSorting	: true
		});

		grid = $("#disk_threshold_grid")
			.kendoGrid($.extend(kendoGridDefaultOpt, {
				dataSource	: dataSource,
//				change		: selectedRow,
				selectable	: false,
				sortable	: {
					mode 		: 'multiple',
					allowUnsort : true
				},
				columns		: [
					{field:'N_MON_ID', title:'장비 ID', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_MON_NAME', title:'장비명', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_MON_IP', title:'장비 IP', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_GROUP_NAME', title:'그룹', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_TYPE_NAME', title:'장비종류', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_DISK_PATH', title:'디스크명', width:'35%', attributes:{style:'text-align:left'}, headerAttributes:{style:'text-align:center'}},
					{field:'F_USE_NAME', title:'사용여부', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}, editor:useEditor}
				],
				toolbar		: [{name:"save", text:"변경적용"}, {name:"cancel", text:"변경취소"}],
				editable	: true
			})).data("kendoGrid");
	}


	function useEditor(container, options) {
		$('<input id="F_THRESHOLD" name="F_THRESHOLD" data-text-field="VAL" data-value-field="CODE" data-bind="value:F_THRESHOLD"/>')
				.appendTo(container)
				.kendoDropDownList({
					dataTextField	: "VAL",
					dataValueField	: "CODE",
					autoBind		: false,
					dataSource		: {
						transport: {
							read: {
								url		: "<c:url value="/admin/lst_common.cmb_code.htm"/>",
								dataType: 'json'
							},
							parameterMap: function (data, operation) {
								return {
									"S_GROUP_CODE" : "USE_YN"
								};
							}
						}
					},
					change : function() {
						options.model.F_USE_NAME = $('#F_THRESHOLD').data('kendoDropDownList').text();
					}
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
			$("#disk_threshold_grid").data('kendoGrid').dataSource.read();
		});
	}

</script>