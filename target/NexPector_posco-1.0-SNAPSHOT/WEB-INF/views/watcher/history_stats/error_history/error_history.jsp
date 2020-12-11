<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript" src="<c:url value="/js/history.js" />"></script>
<script>
	$(function() {
		initialize();

		// Event 등록
		$(".input_search").keypress(function(event){
			if(event.keyCode == '13')
				$("#search").click();
		});

		// 검색 버튼
		$('#search').on('click', function(event) {
			event.preventDefault();
			fn_retrieve();
		});

		// 엑셀 저장 버튼
		$('#excel_download_button').on('click', function(event) {
			event.preventDefault();
			fn_excel_download();
		});
		//-- Event 등록
	});

	function initialize() {
		var start = createStartKendoDatepicker('start_date');
		var end = createEndKendoDatepicker('end_date');
		start.max(end.value());
		end.min(start.value());

		// 서버그룹 DropDownList
		var dataSource = new kendo.data.DataSource({
			transport: {
				read: {
					url: cst.contextPath() + '/watcher/lst_cmb_svr_group.htm',
					dataType: "json"
				}
			}
		});

		createDropDownList('group_code', dataSource, {optionLabel : '전체'});
		//-- 서버그룹 DropDownList

		// 장비타입 DropDownList
		var dataSource = new kendo.data.DataSource({
			transport: {
				read: {
					url: cst.contextPath() + '/watcher/lst_cmb_svr_type.htm',
					dataType: "json"
				}
			}
		});

		createDropDownList('server_type_code', dataSource, {optionLabel : '전체'});
		//-- 장비타입 DropDownList

		// 장애등급 DropDownList
		var almRatingDataSource = new kendo.data.DataSource({
			transport: {
				read: {
					url: cst.contextPath() + '/watcher/lst_cmb_alm_rating.htm',
					dataType: "json"
				}
			}
		});
		createDropDownList('alm_rating', almRatingDataSource, {optionLabel : '전체'});
		//-- 장애등급 DropDownList

		// User ID DropDownList
		var userIdDataSource = new kendo.data.DataSource({
			transport: {
				read: {
					url: cst.contextPath() + '/watcher/lst_cmb_id.htm',
					dataType: "json"
				}
			}
		});
		createDropDownList('user_id2', userIdDataSource, {optionLabel : '전체'});
		//-- User ID DropDownList
	
		// 장애구분 DropDownList

		fn_retrieve();
	}

	function fn_retrieve() {
		var $contentsTr = $('#contents_tr');
		var param = {
			'S_ST_DT' 		: $("#start_date").val().replace(/-/gi, ""),
			'S_ED_DT' 		: $("#end_date").val().replace(/-/gi, ""),
			'S_USER_ID' 	: $("#user_id2").data('kendoDropDownList').value(),
			'N_GROUP_CODE' 	: $("#group_code").data('kendoDropDownList').value(),
			'N_TYPE_CODE' 	: $("#server_type_code").data('kendoDropDownList').value(),
			'N_ALM_RATING' 	: $("#alm_rating").data('kendoDropDownList').value()
			};

		$contentsTr
			.empty()
			.append( $('<td/>').addClass('bgml1') )
			.append( $('<td/>').addClass('bgmc1')
						.append( $('<div/>')
									.addClass('avaya_stitle1')
									.css('float', 'none')
									.append( $('<div/>')
												.addClass('st_under')
												.append( $('<h4/>').text('장애 이력 조회'))))
						.append( $('<div/>').attr('id', 'grid') ))
			.append( $('<td/>').addClass('bgmr1') );

		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/watcher/kendoPagination_statsErrorHistoryRetrieveQry.htm",
					data 		: param
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
					return response.length > 0 ? response[0].TOTAL_COUNT : 0;
				}
			},
			pageSize		: cst.countPerPage(),
			serverPaging	: true,
			serverSorting	: true
		});

		var columns = kendoGridColumns();

		$("#grid")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: dataSource,
				sortable	: {
					mode : 'multiple',
					allowUnsort : true
				},
				columns		: columns.error()
			}));
	}

	function fn_change_alm_rating_background_color(code, name, obj) {
		var c = code == undefined ? 0 : parseInt(code);
		if (c === 1) {
			return '<b style="color: #FF2222">' + name + '</b>';
		}
		else if (c === 2) {
			return '<b style="color: #FF8833">' + name + '</b>';
		}
		else if (c === 3) {
			return '<b style="color: #FF88AA">' + name + '</b>';
		}
		else {
			return '<b>' + name + '</b>';
		}
	}

	function fn_excel_download() {

		var url = cst.contextPath() + '/watcher/go_history_stats.error_history.excel.error_history_excel.htm?req_data=data;statsErrorHistoryRetrieveExcelQry';

		$('#excel_start_date').val($("#start_date").val().replace(/-/gi, ""));
		$('#excel_end_date').val($("#end_date").val().replace(/-/gi, ""));
		$('#excel_alm_rating_name').val($("#alm_rating").data('kendoDropDownList').text());
		$('#excel_server_group').val($("#group_code").data('kendoDropDownList').text());
		$('#excel_server_type_name').val($("#server_type_code").data('kendoDropDownList').text());
		$('#excel_user_name').val($("#user_id2").data('kendoDropDownList').text());
		$('#excel_s_user_id').val($("#user_id2").data('kendoDropDownList').value());
		$('#excel_n_group_code').val($("#group_code").data('kendoDropDownList').value());
		$('#excel_n_type_code').val($("#server_type_code").data('kendoDropDownList').value());
		$('#excel_n_alm_rating').val($("#alm_rating").data('kendoDropDownList').value());
		$('#excel_down_form').attr({ method : 'post', 'action' : url }).submit();

		/*frm.S_ST_DT.value = $("#datepicker1").val().replace(/-/gi, "");
		frm.S_ED_DT.value = $("#datepicker2").val().replace(/-/gi, "");

		frm.ALM_RATING_NAME.value = $("select[name='N_ALM_RATING'] option:selected").text();
		frm.USER_NAME.value = $("select[name='S_USER_ID'] option:selected").text();
		frm.SERVER_GROUP.value = $("select[name='N_GROUP_CODE'] option:selected").text();
		frm.SERVER_NAME.value = $("select[name='N_MON_ID'] option:selected").text();

		frm.target = "ifm_list";
		frm.action = "<c:url value='/watcher/go_history_stats.error_history.error_history_excel.htm?req_data=data;statsErrorHistoryRetrieveExcelQry'/>";
		frm.submit();*/
	}
</script>

<!-- excel download form -->
<form id="excel_down_form" name="excelDownFrm" style="display:none;">
	<input type="hidden" id="excel_start_date" name="S_ST_DT" value=""/>
	<input type="hidden" id="excel_end_date" name="S_ED_DT" value=""/>
	<input type="hidden" id="excel_alm_rating_name" name="ALM_RATING_NAME" value=""/>
	<input type="hidden" id="excel_server_group" name="SERVER_GROUP" value=""/>
	<input type="hidden" id="excel_server_type_name" name="SERVER_TYPE_NAME" value=""/>
	<input type="hidden" id="excel_user_name" name="USER_NAME" value=""/>
	<input type="hidden" id="excel_s_user_id" name="S_USER_ID" value=""/>
	<input type="hidden" id="excel_n_group_code" name="N_GROUP_CODE" value=""/>
	<input type="hidden" id="excel_n_type_code" name="N_TYPE_CODE" value=""/>
	<input type="hidden" id="excel_n_alm_rating" name="N_ALM_RATING" value=""/>
</form>

<script id="cellTemplate" type="text/x-kendo-tmpl">
	<td>
	   <img src="../content/web/Employees/#:data.EmployeeID#.jpg" alt="#: data.EmployeeID #" />
	</td>
</script>


<!-- location -->
<div class="locationBox"><div class="st_under"><h2>장애 이력</h2><span>Home &gt; 이력/통계 조회 &gt; 장애 이력</span></div></div>
<!-- location // -->
<!-- 내용 -->
<!-- 검색영역 -->
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<dd>
					<strong>검색기간</strong>
					<input type="text" name="S_ST_DT" id="start_date" class="input_search" value="" /> ~ <input type="text" name="S_ED_DT" id="end_date" class="input_search" value="" />
				</dd>
				<dd>
					<strong>서버그룹 / 개별</strong>
					<input id="group_code" name="N_GROUP_CODE" class="input_search" style="width: 140px" />
					&nbsp;
					<input id="server_type_code" name="N_TYPE_CODE" class="input_search" style="width: 145px;" />
				</dd>
			</dl>
			<dl>
				<dd>
					<strong style="display:inline-block; width:60px;">장애등급</strong>
					<input id="alm_rating" name="N_ALM_RATING" class="input_search" style="width: 120px;" />
				</dd>
				<dd>
					<strong style="display:inline-block; width:60px;">처리자</strong>
					<input id="user_id2" name="S_USER_ID" class="input_search" style="width: 120px;" />
				</dd>
			</dl>
			<dl>
				<dd>
					&nbsp;
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
<!-- his_contBox -->
<div class="his_contBox">
	<table cellpadding="0" cellspacing="0">
		<tr>
			<td class="bgtl1"></td>
			<td class="bgtc1">
				<span class="stop_btbox">
					<a href="#" id="excel_download_button"><img src="<c:url value="/images/botton/excel.jpg"/>" alt="엑셀저장" /></a>
				</span>
			</td>
			<td class="bgtr1"></td>
		</tr>
		<tr id="contents_tr">
			<!-- 동적 생성 -->
		</tr>
		<tr>
			<td class="bgbl1"></td>
			<td class="bgbc1"></td>
			<td class="bgbr1"></td>
		</tr>
	</table>
</div>
<!-- his_contBox // -->
<!-- 내용 // -->