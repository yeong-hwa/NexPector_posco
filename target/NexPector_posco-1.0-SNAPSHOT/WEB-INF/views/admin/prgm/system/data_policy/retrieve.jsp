<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<style type="text/css">
	.k-grid-header, .k-grid-toolbar {height: 30px;}
</style>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>데이터 보관기준 설정</h2><span>Home &gt; 시스템정보 관리 &gt; 데이터 보관기준 설정</span></div></div>
<!-- location // -->

<!-- 내용 -->
<!-- 검색영역 -->
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<dd>
					<strong>명칭</strong>
					<input type="text" name="S_NAME" id="search_s_name" value="${param.S_NAME}" class="int_f input_search"/>
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
	<div id="data_policy_gird" class="table_typ2-4">
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
		$('#search_s_name').val(param.search_s_name);
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
					url 		: '<c:url value="/admin/kendoPagination_data_policy.select_list.htm"/>',
					data 		: function(data) {
						return {
							'S_NAME'		: $('#search_s_name').val()
						};
					}
				},
				update		: {
					url		: "<c:url value="/admin/data/policy/update.htm"/>" + "?_method=put",
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
					url		: "<c:url value="/admin/data/policy/delete.htm"/>" + "?_method=delete",
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
					url		: "<c:url value="/admin/data/policy/insert.htm"/>",
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
					id : "S_TABLE",
					fields: {
						'S_NAME'		: { type: "string" },
						'S_TABLE'		: { type: "string" },
						'N_DAY'			: { type: "number" },
						'S_COL'			: { type: "string" },
						'S_PATTERN'		: { type: "string" },
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

		grid = $("#data_policy_gird")
			.kendoGrid($.extend(kendoGridDefaultOpt, {
				dataSource	: dataSource,
//				change		: selectedRow,
				selectable	: false,
				sortable	: {
					mode 		: 'multiple',
					allowUnsort : true
				},
				columns		: [
					{field:'S_NAME', title:'이름', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_TABLE', title:'관련 테이블 명', width:'20%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'N_DAY', title:'보관 기준(일)', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_COL', title:'비교 컬럼', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_PATTERN', title:'패턴 명칭', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'F_USE_NAME', title:'사용여부', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}, editor:useEditor},
					{field:'ORDER_NUM', title:'정렬순서', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{command: { name: "destroy", text: "삭제" }, title: "&nbsp;", width: '10%' }
				],
				toolbar		: [{name:"create", text:"신규등록"}, {name:"save", text:"변경적용"}, {name:"cancel", text:"변경취소"}],
				editable	: {
					confirmation : "정말 삭제하시겠습니까?"
				}
			})).data("kendoGrid");
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
			$("#data_policy_gird").data('kendoGrid').dataSource.read();
		});
	}

	// Selected Grid Row
	function selectedRow(event) {

		// 검색 조건과 페이지 번호를 JSON 형태의 String 으로 넘겼다가 다시 받아오기 위함
		var param = {
			'search_menu_name'	: $('#search_s_name').val().trim(),
			'currentPageNo'		: $('#menu_info_gird').data('kendoGrid').dataSource.page()
		};
		var paramStr = JSON.stringify(param);

		$('#frm')
			.append('<input type="hidden" name="searchParam" value="' + encodeURIComponent(paramStr) + '">')
			.append('<input type="hidden" name="S_TABLE" value="' + this.dataItem(this.select()).S_TABLE + '">')
			.append('<input type="hidden" name="updateFlag" value="U">')
			.attr({'action' : cst.contextPath() + '/admin/go_prgm.system.menu_info.insert.htm'})
			.submit();

		event.preventDefault();
	}
	
</script>