<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<style type="text/css">
	.k-window-title {font-family: "NGB";}
	.k-button.k-button-icontext .k-icon, .k-button.k-button-icontext .k-image {vertical-align: inherit;}
	.k-grid-toolbar {height: 30px;}
	.k-edit-label {width: 15%;}
	.k-edit-field {width: 75%;}
</style>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>감시장비 SUB 메뉴 관리</h2><span>Home &gt; 시스템정보 관리 &gt; 감시장비 SUB 메뉴 관리</span></div></div>
<!-- location // -->

<!-- 내용 -->
<!-- 검색영역 -->
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<dd>
					<strong>장비타입</strong> <cmb:combo qryname="common.cmbSvrTypeIncludeDump" firstdata="없음" seltagname="N_TYPE_CODE" selvalue="${data.N_TYPE_CODE}"
													 	etc="id=\"N_TYPE_CODE\" class=\"input_search\" style=\"width:100;\""/>
					<strong style="margin-left:30px;">탭이름</strong> <input type="text" name="TAB_NAME" id="search_tab_name" class="int_f input_search"/>
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
		<div id="code_info_gird" class="table_typ2-4">
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
					url 		: "<c:url value="/admin/kendoPagination_svr_sub_menu_info.select_list.htm"/>",
					data 		: function(data) {
						return {
							'N_TYPE_CODE'   : $('#N_TYPE_CODE option:selected').val(),
							'TAB_NAME' 		: $('#search_tab_name').val()
						};
					}
				},
				update		: {
					url		: "<c:url value="/admin/server_sub_menu/update.htm"/>",
					type	: 'post',
					dataType: "json",
					complete: function(jqXHR, textStatus) {
						if (jqXHR.readyState === 4) {
							if (jqXHR.status === 200) {
								alert("수정 되었습니다.");
								grid.dataSource.read();
								return;
							} else {
								alert("수정 실패하였습니다.");
								return;
							}
						}
					}
				},
				destroy		: {
					url		: "<c:url value="/admin/server_sub_menu/delete.htm"/>",
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
					url		: "<c:url value="/admin/server_sub_menu/insert.htm"/>",
					type	: 'post',
					dataType: "json",
					complete: function(jqXHR, textStatus) {
						if (jqXHR.readyState === 4) {
							if (jqXHR.status === 200) {
								alert("등록 되었습니다.");
								grid.dataSource.read();
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
					id : "SEQ_SVR_TAB_MENU",
					fields: {
						'SEQ_SVR_TAB_MENU'  : { type: "number" },
						'N_TYPE_CODE'		: { defaultValue: 1000 },
						'S_TYPE_NAME'		: { type: "string" },
						'TAB_KEY'			: { type: "string" },
						'TAB_NAME'			: { type: "string", validation: { required: {message : "탭 이름은 필수 값 입니다."} } },
						'TAB_URL'			: { type: "string", validation: { required: {message : "탭 URL은 필수 값 입니다."} } },
						'ORDER_NUM'			: { type: "number" }
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

		grid = $("#code_info_gird")
			.kendoGrid($.extend(kendoGridDefaultOpt, {
				dataSource	: dataSource,
				dataBound	: gridDataBound,
//				change		: selectedRow,
				sortable	: {
					mode 		: 'multiple',
					allowUnsort : true
				},
				columns		: [
					{field:'N_TYPE_CODE', title:'장비타입',  width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}, editor: svrTypeDropDownEditor, template : '#=S_TYPE_NAME ? S_TYPE_NAME : ""#'},
					{field:'TAB_KEY', 	  title:'탭 KEY',  width:'15%', attributes:{style:'text-align:left'}, headerAttributes:{style:'text-align:center'}},
					{field:'TAB_NAME', 	  title:'탭 이름', 	 width:'15%', attributes:{style:'text-align:left'}, headerAttributes:{style:'text-align:center'}},
					{field:'TAB_URL', 	  title:'탭 URL', 	 width:'30%', attributes:{style:'text-align:left'}, headerAttributes:{style:'text-align:center'}},
					{field:'ORDER_NUM',   title:'정렬순서', 	 	width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}, format:"{0:n0}"},
					{ command: [
						{
							name: "edit",
							text: { edit: "수정", update: "확인", cancel: "취소"}
						},
						{ name: "destroy", text: "삭제" }
					], title: "&nbsp;", width: "20%" }
				],
				toolbar: [{name : "create", text : "등록"}],
				editable: {
					mode : "popup",
					window : {
						title: "등록/수정" // Localization for Edit in the popup window
					},
					confirmation : "정말 삭제하시겠습니까?"
				}
			})).data('kendoGrid');

		grid.bind('edit', function(ev) {
			$('input[name=TAB_URL]').css('width', 300)
		});
	}

	function svrTypeDropDownEditor(container, options) {
		$('<input id="N_TYPE_CODE" name="N_TYPE_CODE"/>')
				.appendTo(container)
				.kendoDropDownList({
					dataTextField	: "VAL",
					dataValueField	: "CODE",
					autoBind		: false,
					dataSource		: {
						transport: {
							read: {
								url		: "<c:url value="/admin/lst_common.cmbSvrTypeIncludeDump.htm"/>",
								dataType: 'json'
							}
						}
					}
				});
	}

	function setPopupDimensions(ev) {
		window.setTimeout(function(){
			$(".k-edit-form-container").parent().width(600).height(400).data("kendoWindow").center();
		}, 100);
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

	// Selected Grid Row
	function selectedRow(event) {

		// 검색 조건과 페이지 번호를 JSON 형태의 String 으로 넘겼다가 다시 받아오기 위함
		var param = {
			'search_menu_name'	: $.trim($('#search_menu_name').val()),
			'search_use'	: $.trim($('#search_use').val()),
			'currentPageNo'		: $('#menu_info_gird').data('kendoGrid').dataSource.page()
		};
		var paramStr = JSON.stringify(param);

		$('#frm')
			.append('<input type="hidden" name="search_group_code" value="' + encodeURIComponent(paramStr) + '">')
			.append('<input type="hidden" name="search_value" value="' + this.dataItem(this.select()).N_MENU_CODE + '">')
			.append('<input type="hidden" name="updateFlag" value="U">')
			.attr({'action' : cst.contextPath() + '/admin/go_prgm.system.menu_info.insert.htm'})
			.submit();

		event.preventDefault();
	}
	
</script>