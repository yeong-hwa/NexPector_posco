<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>
<style type="text/css">
	.k-grid-header, .k-grid-toolbar {height: 30px;}
</style>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>VDN 관리</h2><span>Home &gt; 감시장비 관리 &gt; VDN 관리</span></div></div>
<!-- location // -->

<!-- 내용 -->
<!-- 검색영역 -->
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<dd>
					<strong>VDN 그룹 ID</strong>
					<cmb:combo qryname="vdn_info.select_vdn_group_info" seltagname="VDN_ID" firstdata="전체" etc="id=\"search_group_id\" class=\"input_search\""/>
					<strong>VDN</strong>
					<input type="text" name="VDN" id="VDN" value="${param.VDN}" class="int_f input_search"/>
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
	<div id="grid" class="table_typ2-4">
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
		
		$("#search_group_id").change(function() {
			$("#search").click();
		});
		
	});
	
 	function initSearchData(searchParam) {
		var param = JSON.parse(decodeURIComponent(searchParam));
		$('#search_group_id').val(param.search_group_id);
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
					url 		: "<c:url value='/admin/kendoPagination_vdn_info.select_list.htm'/>",
					data 		: function(data) {
						return {
							'VDN_ID'  : $.trim($('#search_group_id').val())
							, 'VDN'  : $.trim($('#VDN').val())
						};
					}
				},
				update		: {
					url		: "<c:url value='/admin/vdn_info/update.htm'/>" + "?_method=put",
					type	: 'post',
					dataType: "json",
					contentType	: 'application/json;charset=UTF-8'
				},
				destroy		: {
					url		: "<c:url value='/admin/vdn_info/delete.htm'/>" + "?_method=delete",
					type	: 'post',
					dataType: "json",
					contentType	: 'application/json;charset=UTF-8'
				},
				create		: {
					url		: "<c:url value='/admin/vdn_info/insert.htm'/>",
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
					id : "VDN_ID",
					fields: {
						'VDN_NAME'	: { type: "string", defaultValue:"선택하세요", validation: { required: {message : "선택하세요"} } },
						'VDN'		: { type: "string", defaultValue: "", validation: { required: {message : "VDN은 필수 값 입니다."} }  },
						'VDN_TEMP'	: { type: "string", defaultValue: ""  }
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

		grid = $("#grid")
			.kendoGrid($.extend(kendoGridDefaultOpt, {
				dataSource	: dataSource,
				//change		: selectedRow,
				selectable	: false,
				sortable	: {
					mode 		: 'multiple',
					allowUnsort : true
				},
				columns		: [
					{field:'VDN_NAME', title:'VDN 그룹', width:'10%'	,attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}, editor:dropDownEditor},
					{field:'VDN', title:'VDN', width:'10%'	,attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'VDN_TEMP', title:'VDN_TEMP', width:'10%', hidden: true}, 
					{command: { name: "destroy", text: "삭제" }, title: "&nbsp;", width: '10%' }
				],
				toolbar		: [{name:"create", text:"신규등록"}, {name:"save", text:"변경적용"}, {name:"cancel", text:"변경취소"}],
				editable	: {
					confirmation : "정말 삭제하시겠습니까?"
				},
				edit: function (e) {
			        var fieldName = e.container.find("input[name]").attr("name");
			    
			        if (fieldName === "VDN_ID" && !e.model.isNew()) {
			            this.closeCell();
			        }
			    }
			})).data('kendoGrid');
	}
	
	function dropDownEditor(container, options) {
		$('<input id="VDN_ID" name="VDN_ID" data-text-field="VAL" data-value-field="CODE" data-bind="value:VDN_ID"/>')
				.appendTo(container)
				.kendoDropDownList({
					optionLabel		: {
						VAL : '선택하세요'
						// CODE : ''
					},
					dataTextField	: "VAL",
					dataValueField	: "CODE",
					autoBind		: false,
					dataSource		: {
						transport: {
							read: {
								url		: "<c:url value='/admin/lst_vdn_info.select_vdn_group_info.htm'/>",
								dataType: 'json'
							}
						}
					},
					change : function() {
						options.model.VDN_NAME =  this.text();
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
			grid.dataSource.page(1);
		});
	}

</script>