<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>

<style type="text/css">
	.k-grid-header, .k-grid-toolbar {height: 30px;}
</style>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>설정 변경 이력</h2><span>Home &gt; 사용자 관리 &gt; 설정 변경 이력</span></div></div>
<!-- location // -->

<!-- 내용 -->
<!-- 검색영역 -->
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<dd>
					<strong style="display:inline-block; width:60px;">검색기간</strong>
					<input type="text" name="S_ST_DT" id="start_date" class="input_search" value="" /> ~ <input type="text" name="S_ED_DT" id="end_date" class="input_search" value=""/>
					<strong>사용자 ID</strong> 
					<input type="text" name="S_USER_ID" id="search_user_id" value="" class="int_f input_search"/>
					<strong style="margin-left:50px;">사용자명</strong> 
					<input type="text" name="S_USER_NAME" id="search_user_name" value="" class="int_f input_search"/>
					<strong style="margin-left:50px;">이벤트 구분</strong> 
					<cmb:combo qryname="common.cmb_event_type" seltagname="N_EVENT_TYPE" firstdata="전체" etc="id=\"search_event_type\" class=\"input_search\""/>
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
	<div id="change_history_grid" class="table_typ2-4">
	</div>
</div>
<!-- manager_contBox1 // -->
<!-- 내용 // -->

<form id="frm"></form>

<div id="window" class="k-block k-success-colored" style="visibility:hidden;">
	<label for="popup_event_type"><strong>이벤트 구분:</strong></label>
    <input type="text" id="popup_event_type" class="k-textbox" disabled="true"/><br/><br/>
	
	<label for="popup_event_name"><strong>이벤트 명:</strong></label>
	<input type="text" id="popup_event_name" class="k-textbox" disabled="true"/><br/><br/>
	
	<label for="popup_user_id"><strong>사용자 ID:</strong></label>
	<input type="text" id="popup_user_id" class="k-textbox" disabled="true"/><br/><br/>
	
	<label for="popup_user_name"><strong>사용자 명:</strong></label>
	<input type="text" id="popup_user_name" class="k-textbox" disabled="true"/><br/><br/>
	
	<div id="popup_target_user_box" display="none">
		<label for="popup_target_user"><strong>대상 ID:</strong></label>
		<input type="text" id="popup_target_user" class="k-textbox" disabled="true"/><br/><br/>
	</div>
	
	<label for="popup_update_date"><strong>일시:</strong></label>
	<input type="text" id="popup_update_date" class="k-textbox" disabled="true"/><br/><br/>
	
	<label for="popup_content"><strong>정보</strong></label><br/><br/>
	<textarea id="popup_content" style="width:100%; height:50%; align:center" class="k-textbox" disabled="true"></textarea>
</div>

<script type="text/javascript">
	var grid;

	$(document).ready(function() {
		var start = createStartKendoDatepicker('start_date');
		var end = createEndKendoDatepicker('end_date');
		start.max(end.value());
		end.min(start.value());
		
		initGrid();
		initEvent();
		var searchParam = '${param.searchParam}';
		if ('' !== searchParam) {
			initSearchData(searchParam);
		}
	});

	function initSearchData(searchParam) {
		var param = JSON.parse(decodeURIComponent(searchParam));
		$('#search_user_id').val(param.search_user_id);
		$('#search_user_name').val(param.search_user_name);
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
					url 		: '<c:url value="/admin/kendoPagination_change_history.select_list.htm"/>',
					data 		: function(data) {
						return {
							'S_USER_ID'		: $('#search_user_id').val().trim(),
							'S_USER_NAME'	: $('#search_user_name').val().trim(),
							'N_EVENT_TYPE'	: $('#search_event_type').val().trim(),
							'S_ST_DT'		: $('#start_date').val().replace(/-/gi, ''),
							'S_ED_DT' 		: $('#end_date').val().replace(/-/gi, ''),
						};
					}
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
					id : "S_EVENT_ID",
					fields: {
						'S_VALUE'				: { type: "string" },
						'S_TARGET_USER'			: { type: "string" },
						'S_EVENT_NAME'			: { type: "string" },
						'S_DATA'				: { type: "string" },
						'S_USER_ID'				: { type: "string" },
						'S_USER_NAME'			: { type: "string" },
						'D_IN_DATE'				: { type: "string" }
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

		grid = $("#change_history_grid")
			.kendoGrid($.extend(kendoGridDefaultOpt, {
				dataSource	: dataSource,
				dataBound	: onDataBound,
				//change		: openPopup,
				selectable	: true,
				sortable	: {
					mode 		: 'multiple',
					allowUnsort : true
				},
				columns		: [
					{
						field:'S_VALUE', title:'이벤트 구분', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}
					},
					{
						field:'S_EVENT_NAME', title:'이벤트 명', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}
					},
					{
						field:'S_DATA', title:'정보', width:'20%', attributes:{style:'text-align:center'}, 
						headerAttributes:{style:'text-align:center'},
 						template: "<div class='' style='white-space:nowrap;overflow:hidden;text-overflow:ellipsis;'>" + 
 									"#if (S_DATA.length >= 50) {var arr = S_DATA.split(','); #<span>#=S_EVENT_NAME# [#=arr[0]#] 외 #=arr.length - 1# 건  </span>#}" + 
 									"else {#<span> # if(!S_EVENT_NAME) {S_EVENT_NAME=''};# #=S_EVENT_NAME# [#=S_DATA#]</span>#} #</div>"
 					},

					/* {
						field:'S_DATA', title:'내용', width:'20%', attributes:{style:'text-align:center'}, 
						headerAttributes:{style:'text-align:center'},
 						template: "#if (S_DATA.length >= 100) {alert('yes');}; #<div class='k-block k-success-colored' style='white-space:nowrap;overflow:hidden;text-overflow:ellipsis;'> # if (false) {#<span> test  </span>#} else {#<span>#:S_DATA#</span>#} #</div>",
					}, */
					
					{
						field:'S_USER_ID', title:'사용자 ID', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}
					},
					{
						field:'S_USER_NAME', title:'사용자명', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}
					},
					{
						field:'D_IN_DATE', title:'일시', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}
					}
				]
			})).data("kendoGrid");
		
        $("#window").kendoWindow({
            modal: true,
            width: "600px",
            height: "400px",
            title: "상세 정보",
            actions: ["Close"],
            visible: false
        });
	}
	
    function onDataBound(e) {
     var grid = $("#change_history_grid").data("kendoGrid");
        $(grid.tbody).off('click');
        $(grid.tbody).on("click", "tr", function (e) {
            var row = $(this);
            //var grid = $("#change_history_grid").getKendoGrid();
            var dialog = $("#window").data("kendoWindow");
            dialog.open();
            dialog.center();

            $("#popup_event_type").val(grid.dataItem(row).S_VALUE);
            $("#popup_event_name").val(grid.dataItem(row).S_EVENT_NAME);
            
            if (grid.dataItem(row).S_TARGET_USER != null && grid.dataItem(row).S_TARGET_USER != "") 
            	$("#popup_target_user_box").show();
			else 
            	$("#popup_target_user_box").hide();

            $("#popup_target_user").val(grid.dataItem(row).S_TARGET_USER);
            $("#popup_user_id").val(grid.dataItem(row).S_USER_ID);
            $("#popup_user_name").val(grid.dataItem(row).S_USER_NAME);
            $("#popup_update_date").val(grid.dataItem(row).D_IN_DATE);
            $("#popup_content").val(grid.dataItem(row).S_DATA);
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
			$("#change_history_grid").data('kendoGrid').dataSource.read();
		});
	}
	
</script>