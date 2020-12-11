<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>

<style type="text/css">
	.ui-dialog-title {font-size: 16px}
</style>

<script type="text/javascript" src="<c:url value="/js/server-detail.js" />"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.blockUI.js"/>"></script>
<title>DB 현황</title>
<script>
	var pMonId = '${param.N_MON_ID}';

	$(function() {
		// 장애현황 그리드 초기화
		var errorStatsGrid = $("#errorStatsGrid")
				.kendoGrid($.extend({}, kendoGridDefaultOpt, {
					dataSource	: [],
					dataBound	: function(e) {
						gridDataBound(e);
						// content checkbox 이벤트 등록
						$('input[name=S_ALM_KEY]').on('change', releaseAllCheckbox);
					},
					resizable	: true,
					columns		: [
						{headerTemplate: '<input type="checkbox" id="all_check" name="ALL_CHECK" value="Y"/>',attributes:_txtCenter, headerAttributes:_txtCenter, sortable : false, template:kendo.template($('#checkboxTemplate').html())},
						{field:'D_UPDATE_TIME', title:'발생시각', width:'12%', attributes:_txtCenter, headerAttributes:_txtCenter},
						{field:'S_PROCESS', title:'감시종류', width:'12%', attributes:_txtCenter, headerAttributes:_txtCenter},
						{field:'S_ALM_RATING_NAME', title:'등급', width:'12%', attributes:_txtCenter, headerAttributes:_txtCenter},
						{field:'S_ALM_STATUS_NAME', title:'상태', width:'12%', attributes:_txtCenter, headerAttributes:_txtCenter},
						{field:'S_ALM_MSG', title:'내용', width:'38%', attributes:_txtLeft, headerAttributes:_txtCenter, sortable:false},
						{field:'', title:'복구', width:'8%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#= fn_create_alarm_history_popup_btn(S_ALM_KEY, S_MON_NAME, S_ALM) #', sortable:false}
					],
					sortable	: {
						mode : 'single',
						allowUnsort : true
					}
					/* , change		: function(e) {
						e.preventDefault ? e.preventDefault() : e.returnValue = false;
						var almKey = this.dataItem(this.select()).S_ALM_KEY;
						fn_retrieve_error_history(almKey);
					}
 */				}));

		// 장애 히스토리 그리드 초기화
		$("#errorHistoryGrid")
				.kendoGrid($.extend({}, kendoGridDefaultOpt, {
					dataSource	: [],
					dataBound	: gridDataBound,
					resizable	: true,
					columns		: [
						{field:'D_UPDATE_TIME', title:'발생시각', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
						{field:'S_ALM_RATING_NAME', title:'등급', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
						{field:'S_ALM_STATUS_NAME', title:'상태', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
						{field:'S_MSG', title:'내용', width:'40%', attributes:_txtLeft, headerAttributes:_txtCenter, sortable:false}
					],
					sortable	: {
						mode : 'single',
						allowUnsort : true
					}
				}));

		fn_stats_retrieve();
		fn_retrieve_error_history();
		
		$('#all_check').on('click', function() {
			if (this.checked) {
				$('input[name=S_ALM_KEY]').prop('checked', true);
			} else {
				$('input[name=S_ALM_KEY]').prop('checked', false);
			}
		});

		$('#btnMulti').kendoButton();

		$('#btnMulti').on('click', function(event) {
			event.preventDefault();

			var almKeys = [];

			if ( $('input[name=S_ALM_KEY]:checked').length === 0 ) {
				alert("복구대상 장애항목을 선택해주세요.");
				return;
			}

			$('input[name=S_ALM_KEY]:checked').each(function() {
				almKeys.push(this.value);
			});

			fn_alarm_history_popup(pMonId, almKeys.join(','));
		});

	});

	function releaseAllCheckbox() {
		$('input[name=S_ALM_KEY]').length === $('input[name=S_ALM_KEY]:checked').length
				? $('#all_check').prop('checked', true)
				: $('#all_check').prop('checked', false);
	}
	
	// 장애현황
	function fn_stats_retrieve() {
		/*frm_stats.target = "ifm_stats_list";
		frm_stats.action = "<c:url value='/watcher/go_server_detail.error_stats.error_stats_retrieve.htm?req_data=data;ErrorStatsRetrieveQry|page_totalcnt;ErrorStatsRetrieveCntQry:map'/>";
		frm_stats.submit();*/

		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/watcher/kendoPagination_ErrorStatsRetrieveQry.htm",
					data 		: function(data) {
						return { 'N_MON_ID' : pMonId };
					}
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

		$("#errorStatsGrid").data('kendoGrid').setDataSource(dataSource);
	}
	
	// 장애 히스트리
	function fn_retrieve_error_history() {
		/*frm_history.S_ALM_KEY.value = val;
		
		frm_history.target = "ifm_history_list";
		frm_history.action = "<c:url value='/watcher/go_server_detail.error_stats.error_history_retrieve.htm?req_data=data;ErrorHistoryRetrieveQry|page_totalcnt;ErrorHistoryRetrieveCntQry:map'/>";
		frm_history.submit();*/

		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/watcher/kendoPagination_ErrorHistoryRetrieveQry.htm",
					data 		: function(data) {
						return { 'N_MON_ID' : pMonId};
					}
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

		$("#errorHistoryGrid").data('kendoGrid').setDataSource(dataSource);
	}
	
	function fn_alarm_history_popup(v_mon_id, v_alm_key, monName, almMsg, event) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}

		var param = "N_MON_ID=" + v_mon_id;
			param += "&S_ALM_KEY=" + v_alm_key;
			param += "&S_MON_NAME=" + (monName ? monName : '');
			param += "&S_ALM_MSG=" + (almMsg ? almMsg : '');

		var dialogWidth = 900;

		$.post(cst.contextPath() + '/watcher/go_main.error_alarm_history.htm', param)
			.done(function(html) {
				$('#dialog_popup')
					.html(html)
					.dialog({
						title			: '장애확인/수동복구',
						resizable		: false,
						width			: dialogWidth,
						modal			: true,
						position		: [($(window).width() / 2) - (dialogWidth / 2), 150],
						autoReposition	: true,
						open			: function() {
							$(this).parent().css({top:50, left:($(window).width() / 2) - (dialogWidth / 2)});
						},
						buttons			: {
							"취소": function() {
								$( this ).dialog( "close" );
							},
							"확인": function() {
								$('#all_check').prop('checked', false);
								fn_save(); // error_alarm_history.jsp 선언
							}
						}
					});
			});
	}

	function fn_create_alarm_history_popup_btn(almKey, monName, almMsg) {
		var imgSrc = cst.contextPath() + '/images/botton/btn_warnview.gif';
		return '<a href="#" onclick="fn_alarm_history_popup(\'' + pMonId + '\', \'' + almKey + '\', \'' + monName + '\', \'' + almMsg + '\', event);"><img src="' + imgSrc + '" alt="상세정보" /></a>';
	}
</script>

<script id="checkboxTemplate" type="text/x-kendo-template">
	<input type="checkbox" name="S_ALM_KEY" value="#= S_ALM_KEY #"/>
</script>

<!-- stitle -->
<div id="contentsWrap" class="table_typ2-3">
	<div class="avaya_stitle1" style="float: none;">
		<div class="st_under">
			<h4>장애 현황</h4>
			<button type="button" id="btnMulti" style="margin-right: 15px;">다중복구</button>
		</div>
	</div>
	<!-- stitle // -->
	<!-- 장애현황 그리드 -->
	<div id="errorStatsGrid"></div>
	<!-- 장애현황 그리드 // -->

	<!-- stitle -->
	<div class="avaya_stitle1" style="float: none;">
		<div class="st_under"><h4>장애 히스토리</h4></div>
	</div>
	<!-- stitle // -->
	<!-- 장애 히스토리 그리드 -->
	<div id="errorHistoryGrid"></div>
	<!-- 장애 히스토리 그리드 // -->
</div>

<div id="dialog_popup"></div>