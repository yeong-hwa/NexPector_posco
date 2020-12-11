<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>
<style type="text/css">
	.k-grid-header, .k-grid-toolbar {height: 30px;}
</style>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>Trunk 관리</h2><span>Home &gt; 감시장비 관리 &gt; Trunk 관리</span></div></div>
<!-- location // -->

<!-- 내용 -->
<!-- 검색영역 -->
<input type="hidden" id="N_GROUP_CODE" name="N_GROUP_CODE" value="${sessionScope.N_GROUP_CODE}"/>
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<dd>
					<strong>장비명</strong>
					<cmb:combo qryname="trunk_info.select_mon_info" seltagname="N_MON_ID" firstdata="전체" etc="id=\"search_mon_id\" class=\"input_search\""/>
					<%-- <input type="text" name="N_MON_ID" id="N_MON_ID" value="${param.N_MON_ID}" class="int_f input_search"/> --%>
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
		<div class="st_under"><h4>건수 : &nbsp;<span id="total_count">0</span></h4>
		<%-- <span>
			<a href="<c:url value="/admin/go_prgm.mon.trunk_group.insert.htm"/>" id="btn_save" class="css_btn_class">등록</a>
			<a href="#" id="btn_remove" class="css_btn_class">삭제</a>
		</span> --%>
	</div>
		
	</div>
	<!-- stitle // -->
	<!-- table_typ2-4 -->
	<div id="trunk_info_gird" class="table_typ2-4">
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
		
		$("#search_mon_id").change(function() {
			$("#search").click();
		});
		
	});
	
 	function initSearchData(searchParam) {
		var param = JSON.parse(decodeURIComponent(searchParam));
		$('#search_mon_id').val(param.search_mon_id);
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
					//url 		: cst.contextPath() + "/admin/kendoPagination_trunk_info.select_list.htm",
					url 		: '<c:url value="/admin/kendoPagination_trunk_info.select_trunk_list.htm"/>',
					data 		: function(data) {
						return {
							'N_MON_ID'  : $.trim($('#search_mon_id').val())
						};
					}
				},
				update		: {
					url		: "<c:url value="/admin/trunk/update.htm"/>" + "?_method=put",
					type	: 'post',
					dataType: "json",
					contentType	: 'application/json;charset=UTF-8'
				},
				destroy		: {
					url		: "<c:url value="/admin/trunk/delete.htm"/>" + "?_method=delete",
					type	: 'post',
					dataType: "json",
					contentType	: 'application/json;charset=UTF-8'
				},
				create		: {
					url		: "<c:url value="/admin/trunk/insert.htm"/>",
					type	: 'post',
					dataType: "json",
					contentType	: 'application/json;charset=UTF-8'
				},
				parameterMap: function (data, operation) {

					/* RESTful 방식 사용 시
					 http 파라미터에 _method = "put|delete" 를 지정하고 dataType 을 post 로 지정하면
					 Spring httpMethodFilter 에서 내부적으로 해당 method 타입으로 변환하여 파라미터가 정상적으로 전송된다. */

					return kendo.stringify(data);
				},
			},
			schema	: {
				model: {
					id : "N_MON_ID",
					fields: {
						'S_MON_NAME'	: { type: "string", defaultValue:"선택하세요.", validation: { required: {message : "장비명은 필수 값 입니다."} } },
						'N_MON_ID'		: { type: "number" },
						'N_NUM'			: { type: "string", validation: { required: {message : "국선번호는 필수 값 입니다."} } },
						'S_NAME'		: { type: "string", defaultValue: ""  },
						'S_DESC'		: { type: "string", defaultValue: ""  },
						'S_DIRECTION'	: { type: "string", defaultValue: ""  },
						'N_SIZE'		: { type: "number", defaultValue: 0 },
						'N_TAC'			: { type: "number", defaultValue: 0 },
						'S_TYPE'		: { type: "string", defaultValue: "" }
					}
				},
				
				data : function(data) {
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

		grid = $("#trunk_info_gird")
			.kendoGrid($.extend(kendoGridDefaultOpt, {
				dataSource	: dataSource,
				//change		: selectedRow,
				selectable	: false,
				sortable	: {
					mode 		: 'multiple',
					allowUnsort : true
				},
				columns		: [
					{field:'S_MON_NAME'	,title:'장비명'		,width:'10%'	,attributes:{style:'text-align:center'}	,headerAttributes:{style:'text-align:center'}, editor:monCodeEditor},
					/* {field:'N_MON_ID'	,title:'장비명'		,width:'15%'	,attributes:{style:'text-align:center'}	,headerAttributes:{style:'text-align:center'}}, */
					{field:'N_NUM'		,title:'국선번호'		,width:'10%'	,attributes:{style:'text-align:right'}	,headerAttributes:{style:'text-align:center'}},
					{field:'S_NAME'		,title:'국선명'		,width:'20%'	,attributes:{style:'text-align:center'}	,headerAttributes:{style:'text-align:center'}},
					{field:'S_DESC'		,title:'설명'		,width:'20%'	,attributes:{style:'text-align:center'}	,headerAttributes:{style:'text-align:center'}},
					{field:'S_DIRECTION',title:'DIRECTION'	,width:'15%'	,attributes:{style:'text-align:center'}	,headerAttributes:{style:'text-align:center'}},
					{field:'N_SIZE'		,title:'SIZE'		,width:'10%'	,attributes:{style:'text-align:right'}	,headerAttributes:{style:'text-align:center'}},
					{field:'N_TAC'		,title:'TAC'		,width:'10%'	,attributes:{style:'text-align:right'}	,headerAttributes:{style:'text-align:center'}},
					{field:'S_TYPE'		,title:'국선타입'		,width:'15%'	,attributes:{style:'text-align:right'}	,headerAttributes:{style:'text-align:center'}},
					{command: { name: "destroy", text: "삭제" }, title: "&nbsp;", width: '10%' }
				],
				toolbar		: [{name:"create", text:"신규등록"}, {name:"save", text:"변경적용"}, {name:"cancel", text:"변경취소"}],
				editable	: {
					confirmation : "정말 삭제하시겠습니까?"
				},
				edit: function (e) {
			        var fieldName = e.container.find("input[name]").attr("name");
			    
			        if (fieldName === "N_MON_ID" && !e.model.isNew()) {
			            this.closeCell();
			        }
			        
			        if (fieldName === "N_NUM" && !e.model.isNew()) {
			            this.closeCell();
			        }
			    }
			})).data('kendoGrid');
	}
	
	function monCodeEditor(container, options) {
		$('<input id="N_MON_ID" name="N_MON_ID" data-text-field="VAL" data-value-field="CODE" data-bind="value:N_MON_ID"/>')
				.appendTo(container)
				.kendoDropDownList({
					optionLabel		: {
						VAL : '선택하세요',
						CODE : 0
					},
					dataTextField	: "VAL",
					dataValueField	: "CODE",
					autoBind		: false,
					dataSource		: {
						transport: {
							read: {
								url		: "<c:url value="/admin/lst_trunk_info.select_mon_info.htm"/>",
								dataType: 'json'
							}
						}
					},
					change : function() {
						options.model.S_MON_NAME =  this.text();
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
			grid.dataSource.read();
		});
	}

</script>