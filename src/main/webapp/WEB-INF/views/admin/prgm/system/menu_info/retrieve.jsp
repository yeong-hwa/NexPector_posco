<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<style type="text/css">
	.k-grid-header, .k-grid-toolbar {height: 30px;}
</style>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>메뉴 정보 관리</h2><span>Home &gt; 시스템정보 관리 &gt; 메뉴 정보 관리</span></div></div>
<!-- location // -->

<!-- 내용 -->
<!-- 검색영역 -->
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<dd>
					<strong>상위 메뉴명</strong>
					<cmb:combo qryname="common.cmb_lmenu" seltagname="P_MENU" firstdata="전체" etc="id=\"search_menu_code\" class=\"input_search\""/>
					<strong style="margin-left:20px;">메뉴명</strong> <input type="text" name="S_MENU_NAME" id="search_menu_name" value="${param.S_MENU_NAME}" class="int_f input_search"/>
					<strong style="margin-left:20px;">사용여부</strong>
					<cmb:combo qryname="common.cmb_code" seltagname="F_USE" firstdata="전체" etc="id=\"search_use\" class=\"input_search\"" param="S_GROUP_CODE=USE_YN"/>
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
	<div id="menu_info_gird" class="table_typ2-4">
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
		$('#search_menu_code').val(param.search_menu_code);
		$('#search_menu_name').val(param.search_menu_name);
		grid.dataSource.fetch(function() {
			grid.dataSource.page(param.currentPageNo);
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
					url 		: '<c:url value="/admin/kendoPagination_menu_info.select_list.htm"/>',
					data 		: function(data) {
						return {
							'P_MENU'		: $('#search_menu_code').val(),
							'S_MENU_NAME'   : $.trim($('#search_menu_name').val()),
							'F_USE' : $.trim($('#search_use').val())
						};
					}
				},
				update		: {
					url		: "<c:url value="/admin/menu/update.htm"/>" + "?_method=put",
					type	: 'post',
					dataType: "json",
					contentType	: 'application/json;charset=UTF-8'
					/*complete: function(jqXHR, textStatus) {
						if (jqXHR.readyState === 4) {
							if (jqXHR.status === 200) {
								alert("수정 되었습니다.");
								return;
							} else {
								alert("수정 실패하였습니다.");
								return;
							}
						}
					}*/
				},
				destroy		: {
					url		: "<c:url value="/admin/menu/delete.htm"/>" + "?_method=delete",
					type	: 'post',
					dataType: "json",
					contentType	: 'application/json;charset=UTF-8'
					/*complete: function(jqXHR, textStatus) {
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
					}*/
				},
				create		: {
					url		: "<c:url value="/admin/menu/insert.htm"/>",
					type	: 'post',
					dataType: "json",
					contentType	: 'application/json;charset=UTF-8'
					/*complete: function(jqXHR, textStatus) {
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
					}*/
				},
				parameterMap: function (data, operation) {

					/* RESTful 방식 사용 시
					 http 파라미터에 _method = "put|delete" 를 지정하고 dataType 을 post 로 지정하면
					 Spring httpMethodFilter 에서 내부적으로 해당 method 타입으로 변환하여 파라미터가 정상적으로 전송된다. */

					return kendo.stringify(data);
				}
			},
			schema			: {
				model: {
					id : "N_MENU_CODE",
					fields: {
						'P_MENU_CODE'	: { type: "number" },
						'P_MENU_NAME'	: { type: "string" },
						'N_MENU_CODE'	: { type: "number", editable:false },
						'S_MENU_NAME'	: { type: "string", validation: { required: {message : "메뉴명은 필수 값 입니다."} } },
						'S_MENU_URL'	: { type: "string", validation: { required: {message : "메뉴URL은 필수 값 입니다."} } },
						'F_USE'			: { type: "string", defaultValue: "Y", validation: { min: 1, required: {message : "사용여부는 필수 값 입니다."} } },
						'F_USE_NAME'	: { type: "string", defaultValue: "사용" },
						'ORDER_NUM'		: { type: "number", validation: { min: 1, required: {message : "정렬순서는 필수 값 입니다."} } }
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

		grid = $("#menu_info_gird")
			.kendoGrid($.extend(kendoGridDefaultOpt, {
				dataSource	: dataSource,
//				change		: selectedRow,
				selectable	: false,
				sortable	: {
					mode 		: 'multiple',
					allowUnsort : true
				},
				columns		: [
					{field:'P_MENU_NAME', title:'상위 메뉴명', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}, editor:parentMenuEditor, template:'#=P_MENU_CODE === N_MENU_CODE ? "" : P_MENU_NAME#'},
					{field:'N_MENU_CODE', title:'메뉴코드', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_MENU_NAME', title:'메뉴명', width:'15%', attributes:{style:'text-align:left'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_MENU_URL', title:'메뉴URL', width:'35%', attributes:{style:'text-align:left'}, headerAttributes:{style:'text-align:center'}},
					{field:'F_USE_NAME', title:'사용여부', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}, editor:useEditor},
					{field:'ORDER_NUM', title:'정렬순서', width:'5%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{command: { name: "destroy", text: "삭제" }, title: "&nbsp;", width: '10%' }
				],
				toolbar		: [{name:"create", text:"신규등록"}, {name:"save", text:"변경적용"}, {name:"cancel", text:"변경취소"}],
				editable	: {
					confirmation : "정말 삭제하시겠습니까?"
				}
			})).data("kendoGrid");
	}

	function parentMenuEditor(container, options) {
		$('<input id="P_MENU_CODE" name="P_MENU_CODE" data-text-field="VAL" data-value-field="CODE" data-bind="value:P_MENU_CODE"/>')
				.appendTo(container)
				.kendoDropDownList({
					optionLabel		: {
						VAL : '없음',
						CODE : 0
					},
					dataTextField	: "VAL",
					dataValueField	: "CODE",
					autoBind		: false,
					dataSource		: {
						transport: {
							read: {
								url		: "<c:url value="/admin/lst_common.cmb_lmenu.htm"/>",
								dataType: 'json'
							}
						}
					},
					change : function() {
						options.model.P_MENU_NAME = $('#P_MENU_CODE').data('kendoDropDownList').text();
					}
				});
	}

	function useEditor(container, options) {
		$('<input id="F_USE" name="F_USE" data-text-field="VAL" data-value-field="CODE" data-bind="value:F_USE"/>')
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
						options.model.F_USE_NAME = $('#F_USE').data('kendoDropDownList').text();
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
			$("#menu_info_gird").data('kendoGrid').dataSource.read();
		});
	}

	// Selected Grid Row
	function selectedRow(event) {

		// 검색 조건과 페이지 번호를 JSON 형태의 String 으로 넘겼다가 다시 받아오기 위함
		var param = {
			'search_menu_name'	: $('#search_menu_name').val().trim(),
			'currentPageNo'		: $('#menu_info_gird').data('kendoGrid').dataSource.page()
		};
		var paramStr = JSON.stringify(param);

		$('#frm')
			.append('<input type="hidden" name="searchParam" value="' + encodeURIComponent(paramStr) + '">')
			.append('<input type="hidden" name="N_MENU_CODE" value="' + this.dataItem(this.select()).N_MENU_CODE + '">')
			.append('<input type="hidden" name="updateFlag" value="U">')
			.attr({'action' : cst.contextPath() + '/admin/go_prgm.system.menu_info.insert.htm'})
			.submit();

		event.preventDefault();
	}
	
</script>