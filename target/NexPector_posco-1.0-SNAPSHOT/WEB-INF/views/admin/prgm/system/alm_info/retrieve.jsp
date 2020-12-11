<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<style type="text/css">
	.k-grid-header, .k-grid-toolbar {height: 30px;}
</style>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>알람 코드 관리</h2><span>Home &gt; 시스템정보 관리 &gt; 알람 코드 관리</span></div></div>
<!-- location // -->

<!-- 내용 -->
<!-- 검색영역 -->
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<dd>
					<strong>알람 타입</strong> <input type="text" name="N_ALM_TYPE" id="n_alm_type" value="${param.N_ALM_TYPE}" class="int_f input_search"/>
					<select style="margin-left:20px;" name="SEARCH_TYPE" value="${param.SEARCH_TYPE}" id="SEARCH_TYPE">
                		<option value="NM">알람명</option>
                		<option value="MSG">알람 메시지</option>
                		<option value="SMS_MSG">알람 SMS 메시지</option>
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
	<div id="alm_info_gird" class="table_typ2-4">
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
	});

	// 사용자 목록 Grid
	function initGrid() {
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: '<c:url value="/admin/kendoPagination_alm_info.select_list.htm"/>',
					data 		: function(data) {
						return {
							'N_ALM_TYPE'		: $.trim($('#n_alm_type').val()),
							'SEARCH_TYPE'   	: $('#SEARCH_TYPE').val(),
							'SEARCH_KEYWORD' 	: $.trim($('#SEARCH_KEYWORD').val())
						};
					}
				},
				update		: {
					url		: "<c:url value="/admin/alm/update.htm"/>" + "?_method=put",
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
					url		: "<c:url value="/admin/alm/delete.htm"/>" + "?_method=delete",
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
					url		: "<c:url value="/admin/alm/insert.htm"/>",
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
					id : "N_ALM_TYPE",
					fields: {
						'N_ALM_TYPE'	: { type: "number", validation: { required: {message : "알람 타입은 필수 값 입니다."} } },
						'N_ALM_CODE'	: { type: "number", validation: { required: {message : "알람 코드는 필수 값 입니다."} } },
						'S_ALM_NAME'	: { type: "string", validation: { required: {message : "알람명은 필수 값 입니다."} } },
						'S_ALM_MSG'		: { type: "string", validation: { required: {message : "알람 메시지는 필수 값 입니다."} } },
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

		grid = $("#alm_info_gird")
			.kendoGrid($.extend(kendoGridDefaultOpt, {
				dataSource	: dataSource,
				selectable	: false,
				sortable	: {
					mode 		: 'multiple',
					allowUnsort : true
				},
				columns		: [
					{field:'N_ALM_TYPE', title:'알람 타입', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'N_ALM_CODE', title:'알람 코드', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_ALM_NAME', title:'알람명', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_ALM_MSG', title:'알람 메시지', width:'30%', attributes:{style:'text-align:left'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_ALM_SMS_MSG', title:'알람 SMS 메시지', width:'20%', attributes:{style:'text-align:left'}, headerAttributes:{style:'text-align:center'}},
					{command: { name: "destroy", text: "삭제" }, title: "&nbsp;", width: '10%' }
				],
				toolbar		: [{name:"create", text:"신규등록"}, {name:"save", text:"변경적용"}, {name:"cancel", text:"변경취소"}],
				editable	: {
					confirmation : "정말 삭제하시겠습니까?"
				},
				edit : function(e) {
					if (!e.model.isNew()) {
						if(this.cellIndex(e.container) == 0 || this.cellIndex(e.container) == 1) {
							this.closeCell();
						}
					}
				}
			})).data("kendoGrid");
	}
	
	// Event 등록
	function initEvent() {

		$(".input_search").keypress(function(event){
			if(kendo.keys.ENTER === event.keyCode)
				$("#search").click();
		});
		
		$('#search').on('click', function(event) {
			event.preventDefault();
			$("#alm_info_gird").data('kendoGrid').dataSource.read();
		});
	}

</script>