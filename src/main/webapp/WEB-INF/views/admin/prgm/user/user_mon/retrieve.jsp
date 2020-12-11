<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style type="text/css">
	select{width: 100px;}
	.k-grid td{padding: 0.2em 0.2em}
	/*.k-grid .k-grid-header .k-header .k-link {padding: 0.2em 0.2em}*/
</style>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>사용자 감시대상장비 관리</h2><span>Home &gt; 사용자 관리 &gt; 사용자 감시대상장비 관리</span></div></div>
<!-- location // -->

<!-- 내용 -->
<!-- 사용자선택 -->
<div class="mana_box3">
	<div class="box_a">
		<table  cellpadding="0" cellspacing="0" class="table_left_s1">
			<tr>
				<td class="bgtl1"></td>
				<td class="bgtc1"><strong>사용자 선택</strong></td>
				<td class="bgtr1"></td>
			</tr>
			<tr style="height: 320px;">
				<td class="bgml1"></td>
				<td class="bgmc1">
					<div id="user_info_grid" style="margin: 10px 0px 0px 0px;">
					</div>
				</td>
				<td class="bgmr1"></td>
			</tr>
			<tr>
				<td class="bgbl1"></td>
				<td class="bgbc1"></td>
				<td class="bgbr1"></td>
			</tr>
		</table>
		<table class="table_left_s1-f">
			<tr><td></td></tr>
		</table>
		<form id="server_info_form" method="post">
			<table  cellpadding="0" cellspacing="0" class="table_left_s2">
				<tr>
					<td class="bgtl1"></td>
					<td class="bgtc1">
						<strong>그룹</strong>
						<select name="N_GROUP_CODE" id="sel_group_code"><option value="">전체</option></select>
						<strong>타입</strong>
						<select name="N_TYPE_CODE" id="sel_type_code"><option value="">전체</option></select>
						<strong>종류</strong>
						<select name="N_STYLE_CODE" id="sel_style_code"><option value="">전체</option></select>
					</td>
					<td class="bgtc1">
						<a href="#" id="btn_apply" class="css_btn_class" style="float: right;">적용</a>
					</td>
					<%--<td class="bgtc1" style="float: right;">
						<a href="#" id="btn_save" class="css_btn_class">저장</a>
					</td>--%>
					<td class="bgtr1"></td>
				</tr>
				<tr style="height: 320px;">
					<td class="bgml1"></td>
					<td class="bgmc1" colspan="2">
						<div id="user_svr_grid" style="margin: 10px 0px 0px 0px;">
						</div>
					</td>
					<td class="bgmr1"></td>
				</tr>
				<tr>
					<td class="bgbl1"></td>
					<td class="bgbc1" colspan="2"></td>
					<td class="bgbr1"></td>
				</tr>
			</table>
		</form>

	</div>
</div>
<!-- 사용자선택//-->

<script type="text/javascript">
	$(document).ready(function() {
		initEvent();
		initUserInfoGrid();
		initServerGrid();

		cfn_makecombo_opt($('#sel_group_code'), cst.contextPath() + '/admin/lst_cmb_svr_group.htm');
		cfn_makecombo_opt($('#sel_type_code'), cst.contextPath() + '/admin/lst_cmb_svr_type.htm');
		cfn_makecombo_opt($('#sel_style_code'), cst.contextPath() + '/admin/lst_cmb_svr_style.htm');

		// initServerGrid() 에서 checkbox 를 생성하기 때문에 function 실행 뒤에 와야한다.
		$('#all_check').on('click', function() {
			if (this.checked) {
				$('input[name=N_MON_ID]').prop('checked', true);
			} else {
				$('input[name=N_MON_ID]').prop('checked', false);
			}
		});
	});

	function initEvent() {
		// Server 검색조건 Select
		$('select').on('change', function(event) {
			if ($('#user_info_grid').data('kendoGrid').select().length > 0) {
				$('#user_svr_grid').data('kendoGrid').dataSource.read();
			}
		});

		// 적용버튼
		$('#btn_apply').on('click', applyUserServerInfo);
	}

	// 사용자 목록 Grid
	function initUserInfoGrid() {
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/kendoPagination_user_mon.user_list_qry.htm",
					data 		: function(data) {
						return data;
					}
				},
				parameterMap: function (data, opperation) {
					return JSON.stringify(data);
				}
			},
			schema			: {
				data	: function(data) {
					return $.isArray(data) ? data : [];
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

		$("#user_info_grid")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: dataSource,
				change		: searchServerDataSource,
				pageable	: {
					messages : {
						empty	: "<strong>No data</strong>",
						display : "<span>전체<strong style='color: #f35800;'>{2}</strong> 개 항목</span>"
					}
				},
				sortable	: true,
				columns		: [
					{field:'S_USER_ID', title:'사용자ID', width:'50%', attributes:alignCenter, headerAttributes:alignCenter},
					{field:'S_USER_NAME', title:'사용자명', width:'50%', attributes:alignCenter, headerAttributes:alignCenter}
				],
				height		: '305px'
			}));
	}

	function initServerGrid() {
		$("#user_svr_grid")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: [],
				dataBound	: gridDataBound,
				change		: selectedServerGridRow,
				pageable	: {
					messages : {
						empty	: "<strong>No data</strong>",
						display : "<span>전체<strong style='color: #f35800;'>{2}</strong> 개 항목</span>"
					}
				},
				scrollable	: true,
				sortable	: true,
				columns		: [
					{headerTemplate: '<input type="checkbox" id="all_check" name="ALL_CHECK" value="Y"/>', template: kendo.template($('#checkboxTemplate').html()),attributes:alignCenter, headerAttributes:alignCenter, sortable : false},
					{field:'N_MON_ID', title:'장비ID', width:'24%', attributes:alignCenter, headerAttributes:alignCenter},
					{field:'S_GROUP_NAME', title:'장비그룹', width:'24%', attributes:alignCenter, headerAttributes:alignCenter},
					{field:'S_MON_NAME', title:'장비명', width:'24%', attributes:alignCenter, headerAttributes:alignCenter},
					{field:'S_STYLE_NAME', title:'감시타입', width:'24%', attributes:alignCenter, headerAttributes:alignCenter}
				],
				height		: '305px'
			}));
	}

	function selectedServerGridRow() {
		var $checkbox = this.select().find(':first').find('input[type=checkbox]');
		if ($checkbox.is(':checked')) {
			$checkbox.prop('checked', false);
		} else {
			$checkbox.prop('checked', true);
		}

		releaseAllCheckbox();
	}

	function releaseAllCheckbox() {
		$('input[name=N_MON_ID]').length === $('input[name=N_MON_ID]:checked').length
				? $('#all_check').prop('checked', true)
				: $('#all_check').prop('checked', false);
	}

	function searchServerDataSource() {
		var userId = this.dataItem(this.select()).S_USER_ID;
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
//					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/lst_user_mon.RetrieveUserMonQry2.htm",
					data 		: function(data) {
						return {
							'S_USER_ID' 	: userId,
							'N_GROUP_CODE' 	: $('#sel_group_code').val(),
							'N_TYPE_CODE' 	: $('#sel_type_code').val(),
							'N_STYLE_CODE' 	: $('#sel_style_code').val()
						};
					}
				},
				parameterMap: function (data, opperation) {
					return data;
				}
			},
			schema			: {
				data	: function(data) {
					return $.isArray(data) ? data : [];
				},
				total 	: function(response) {
					var totalCount = response.length > 0 ? response[0].TOTAL_COUNT : 0;
					$('#total_count').text(totalCount);
					return totalCount;
				}
			},
//			pageSize		: cst.countPerPage(),
//			serverPaging	: true,
			serverSorting	: true
		});

		var serverGrid = $('#user_svr_grid').data('kendoGrid');
		serverGrid.setDataSource(dataSource);
		// Grid Data 출력 완료 후 전체체크 여부 체크
		serverGrid.bind("dataBound", function(e) {
			if ($('input[name=N_MON_ID]').length === $('input[name=N_MON_ID]:checked').length) {
				$('#all_check').prop('checked', true);
			} else {
				$('#all_check').prop('checked', false);
			}

			// content checkbox 이벤트 등록
			$('input[name=N_MON_ID]').on('change', releaseAllCheckbox);
		});
	}

	function applyUserServerInfo(event) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}

		var userGrid = $('#user_info_grid').data('kendoGrid');
		if ($('#user_info_grid').data('kendoGrid').select().length === 0) {
			alert("사용자를 선택해주세요.");
			return;
		}
		else {
			$.blockUI(blockUIOption);
			var url   = cst.contextPath() + '/admin/registerUserServerInfo.htm',
				param = $('#server_info_form').serialize() + '&S_USER_ID=' + userGrid.dataItem(userGrid.select()).S_USER_ID;

			var xhr = $.post(url, param);
			xhr.done(function(data) {
				$.unblockUI();
				var resultCode = parseInt(data.RSLT);
				if (resultCode === 1) {
					alert("적용되었습니다.");
					$('#user_svr_grid').data('kendoGrid').dataSource.read();
				} else {
					alert("적용실패하였습니다.");
				}
			});
			xhr.always($.unblockUI);
		}
	}
</script>

<script id="checkboxTemplate" type="text/x-kendo-template">
	<input type="checkbox" name="N_MON_ID" value="#= N_MON_ID #" # if (N_MON_ID === CHK_MON_ID) { # checked="checked" # } #/>
</script>

