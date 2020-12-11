<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style type="text/css">
	.k-window-title {font-family: "NGB";}
	.k-button.k-button-icontext .k-icon, .k-button.k-button-icontext .k-image {vertical-align: inherit;}
	.k-grid-toolbar {height: 30px;}
</style>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>알람코드 정보 관리</h2><span>Home &gt; 감시장비 관리 &gt; 알람코드 정보 관리</span></div></div>
<!-- location // -->

<!-- 내용 -->
<!-- 검색영역 -->
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<dd>
					<strong>알람타입</strong> <input type="text" name="N_ALM_TYPE" id="search_alm_type" class="int_f input_search"/>
					<strong style="margin-left:20px;">알람명</strong> <input type="text" name="S_ALM_NAME" id="search_alm_name" class="int_f input_search"/>
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
		<div class="st_under"><h4>건수 : &nbsp;<span id="total_count">0</span></h4><%--<span><a href="#" id="btn_save" class="css_btn_class">등록</a></span>--%></div>
	</div>
	<!-- stitle // -->
	<!-- table_typ2-4 -->
	<form id="register_frm" method="post">
		<div id="alm_code_info_gird" class="table_typ2-4">
		</div>
	</form>
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
		$('#search_group_code').val(param.search_menu_name);
		$('#search_value').val(param.search_use);
		var page = parseInt(param.currentPageNo);
		$('#menu_info_gird').data('kendoGrid').dataSource.fetch(function() {
			$('#menu_info_gird').data('kendoGrid').dataSource.page(page);
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
					url 		: "<c:url value="/admin/kendoPagination_alm_code_info.select_list.htm"/>",
					data 		: function(data) {
						return {
							'N_ALM_TYPE'   : $('#search_alm_type').val(),
							'S_ALM_NAME'   : $('#search_alm_name').val()
						};
					}
				},
				update		: {
					url		: "<c:url value="/admin/almCodeInfo/update.htm"/>",
					type	: 'post',
					dataType: "json",
					complete: function(jqXHR, textStatus) {
						if (jqXHR.readyState === 4) {
							if (jqXHR.status === 200) {
								alert("수정 되었습니다.");
								return;
							} else {
								alert("수정 실패하였습니다.");
								return;
							}
						}
					}
				},
				destroy		: {
					url		: "<c:url value="/admin/almCodeInfo/delete.htm"/>",
					type	: 'post',
					dataType: "json",
					complete: function(jqXHR, textStatus) {
						if (jqXHR.readyState === 4) {
							if (jqXHR.status === 200) {
								alert("삭제 되었습니다.");
								return;
							} else {
								grid.cancelChanges();
								alert("삭제 실패하였습니다.");
								return;
							}
						}
					}
				},
				create		: {
					url		: "<c:url value="/admin/almCodeInfo/insert.htm"/>",
					type	: 'post',
					dataType: "json",
					complete: function(jqXHR, textStatus) {
						if (jqXHR.readyState === 4) {
							if (jqXHR.status === 200) {
								alert("등록 되었습니다.");
								return;
							} else {
								alert("등록 실패하였습니다.");
								grid.cancelChanges();
								return;
							}
						}
					}
				},
				parameterMap: function (data, operation) {
					if (operation === "read") {
						return kendo.stringify(data);
					} else if (operation === "create") {
						return data;
					} else if (operation === "update") {
						/* RESTful 방식 사용 시
						http 파라미터에 _method = "put|delete" 를 지정하고 dataType 을 post 로 지정하면
						Spring httpMethodFilter 에서 내부적으로 해당 method 타입으로 변환하여 파라미터가 정상적으로 전송된다. */
						data._method = "put";
						return data;
					} else if (operation === "destroy") {
						data._method = "delete";
						return data;
					}
				}
			},
			schema			: {
				model: {
					id : "N_ALM_TYPE",
					fields: {
						'N_ALM_TYPE'	: { type: "string", validation: { required: {message : "알람타입은 필수 값 입니다."} } },
						'N_ALM_CODE'	: { type: "string", validation: { required: {message : "알람코드는 필수 값 입니다."} } },
						'S_ALM_NAME'	: { type: "string", validation: { required: {message : "알람명은 필수 값 입니다."} } },
						'S_ALM_MSG'		: { type: "string", validation: { required: {message : "알람메시지는 필수 값 입니다."} } },
						'S_ALM_SMS_MSG'	: { type: "string" }
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
			pageSize		: cst.countPerPage(),
			serverPaging	: true,
			serverSorting	: true
		});

		grid = $("#alm_code_info_gird")
			.kendoGrid($.extend(kendoGridDefaultOpt, {
				dataSource	: dataSource,
				sortable	: {
					mode 		: 'multiple',
					allowUnsort : true
				},
				columns		: [
					{field:'N_ALM_TYPE',  	title:'알람타입', 	width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'N_ALM_CODE',	title:'알람코드', 	width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_ALM_NAME', 	title:'알람명', 	 	width:'20%', attributes:{style:'text-align:left'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_ALM_MSG', 	title:'알람메시지', 	width:'22%', attributes:{style:'text-align:left'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_ALM_SMS_MSG', title:'알람문자메시지', 	 width:'23%', attributes:{style:'text-align:left'}, headerAttributes:{style:'text-align:center'}},
					{ command: [
						{
							name: "edit",
							text: { edit: "수정", update: "확인", cancel: "취소"}
						},
						{ name: "destroy", text: "삭제" }
					], title: "&nbsp;", width: "15%" }
				],
				toolbar: [{name : "create", text : "등록"}],
				editable: {
					mode : "popup",
					window : {
						title: "등록/수정" // Localization for Edit in the popup window
					},
					confirmation : "정말 삭제하시겠습니까?"
				},
				edit : function(e) {
					if (!e.model.isNew()) {
						$(".k-window input[name=N_ALM_TYPE]").css("background-color", "#EAE6E6").prop("readonly", true);
						$(".k-window input[name=N_ALM_CODE]").css("background-color", "#EAE6E6").prop("readonly", true);
					}
				}
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

		$('#btn_save').on('click', function(event) {
			alert($('#register_frm').serialize());
		});
	}
</script>