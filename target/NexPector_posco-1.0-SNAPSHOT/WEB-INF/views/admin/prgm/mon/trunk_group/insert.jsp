<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<style type="text/css">
	.manaint_f{height: 26px;}
	.k-datetimepicker .k-picker-wrap .k-icon{margin:0 2px;margin-top: 5px;}
	.mana_box5 .table_center img{padding: 0 4px 10px 5px;}
</style>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>Trunk Group 관리</h2><span>Home &gt; 감시장비 관리 &gt; Trunk Group 등록</span></div></div>

<form id="trunk_group_insert_form" name="trunk_group_insert_form" data-role="validator">
	<div class="manager_contBox1">
		<!--//사용자등록 -->
		<div class="mana_box5 mgt20">
			<div class="box_a" style="padding:0px;">

				<table  cellpadding="0" cellspacing="0" class="table_left_s2" style="width: 25%;">
					<tr>
						<td class="bgtl1"></td>
						<td class="bgtc1"><strong>작업정보</strong></td>
						<td class="bgtr1"></td>
					</tr>
					<tr>
						<td class="bgml1"></td>
						<td class="bgmc1">
							<div class="table_typ2-7">
								<table summary="" cellpadding="0" cellspacing="0">
									<caption></caption>
									<colgroup>
										<col width="30%" />
										<col width="70%" />
									</colgroup>
									<tr>
										<td class="filed_A">장비그룹</td>
										<td class="filed_B left">
											<cmb:combo qryname="cmb_svr_group" seltagname="N_GROUP_CODE" selvalue="${data.N_GROUP_CODE}" etc="id=\"N_GROUP_CODE\""/>
										</td>
									</tr>
									<tr>
										<td class="filed_A">Trunk 그룹명</td>
										<td class="filed_B left">
											<input type="text" name="S_DIALING_NAME" id="S_DIALING_NAME" value="${data.S_DIALING_NAME}" class="manaint_f" style="width:100%; height: 19px;"/>
											<input type="hidden" name="N_DIALING_CODE" id="N_DIALING_CODE" value="${data.N_DIALING_CODE}"/>
										</td>
									</tr>
								</table>

								<!-- botton -->
								<div id="botton_align_center1">
									<a href="#" class="css_btn_class" id="btn_save">저장</a>&nbsp;&nbsp;&nbsp;
									<a href="#" class="css_btn_class" id="btn_cancel">취소</a>
									<c:if test="${param.updateFlag == 'U'}">
										&nbsp;&nbsp;&nbsp;<a href="#" class="css_btn_class" id="btn_del">삭제</a>
									</c:if>
								</div>

								<!-- botton // -->
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

				<!-- TRUNK 목록 -->
				<table  cellpadding="0" cellspacing="0" bolder="1" class="table_left_s1" style="width: 33%;">
				<tr>
					<td class="bgtl1"></td>
					<td class="bgtc1">
						<span class="admin_left">
							<strong>Trunk 리스트</strong>
						</span>
						<span class="admin_right">
						</span>
					</td>
					<td class="bgtr1"></td>
				</tr>
				<tr>
					<td class="bgml1"></td>
					<td class="bgmc1">
						<div id="trunk_list" class="table_typ1" style="margin: 10px 0px 0px 0px;"></div>
					</td>
					<td class="bgmr1"></td>
				</tr>
				<tr>
					<td class="bgbl1"></td>
					<td class="bgbc1"></td>
					<td class="bgbr1"></td>
				</tr>
				</table>
				<!-- TRUNK 목록 -->
	
				<table class="table_center">
					<tr>
						<td  align="center" valign="middle">
							<a href="#"><img id="btn_left" src="<c:url value="/admin/images/botton/arrow2_1.jpg"/>" alt="이전" /></a>
							<a href="#"><img id="btn_right" src="<c:url value="/admin/images/botton/arrow2_2.jpg"/>" alt="다음" /></a>
						</td>
					</tr>
				</table>

				<table  cellpadding="0" cellspacing="0" class="table_left_s1" style="width: 33%;">
				<tr>
					<td class="bgtl1"></td>
					<td class="bgtc1"><strong>선택 리스트</strong></td>
					<td class="bgtr1"></td>
				</tr>
				<tr>
					<td class="bgml1"></td>
					<td class="bgmc1">
						<div id="sel_trunk_group_list" class="table_typ1" style="margin: 10px 0px 0px 0px;"></div>
					</td>
					<td class="bgmr1"></td>
				</tr>
				<tr>
					<td class="bgbl1"></td>
					<td class="bgbc1"></td>
					<td class="bgbr1"></td>
				</tr>
				</table>
			</div>
		</div>
		<!--사용자등록//-->
	</div>
	<!-- manager_contBox1 // -->
</form>
	

<form id="go_list_form" method="get">
	<input type="hidden" name="searchParam" value="${param.searchParam}"/>
</form>

<script type="text/javascript">

	var grid, selectedGrid;

	$(document).ready(function() {
		initGrid();
		initSelGrid();
		initEvent();
	});

	function initEvent() {
		$("#N_GROUP_CODE").on('change', function(event) {
			$('#trunk_list').data('kendoGrid').dataSource.read();
		});

		$('#btn_cancel').on('click', function(event) {
			event.preventDefault();
			if ( confirm("목록으로 이동하시겠습니까?") ) {
				goListPage();
			}
		});

		$('#btn_right').on('click', fn_right_click);
		$('#btn_left').on('click', fn_left_click);
		$('#btn_save').on('click', save);
		$('#btn_del').on('click', fn_delete);

		$('input[type=text]').focusout(function() {
			this.value = $.trim(this.value);
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
					url 		: cst.contextPath() + "/admin/kendoPagination_trunk_group_info.select_trunk_list.htm",
					data 		: function(data) {
						return {
							'N_GROUP_CODE'  : $.trim($('#N_GROUP_CODE').val())
						};
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
			serverPaging	: false,
			serverSorting	: true
		});

		grid = $("#trunk_list")
				.kendoGrid($.extend({}, kendoGridDefaultOpt, {
					dataSource	: dataSource,
					dataBound	: function (e) {
						$('#all_check').on('click', function() {
							if (this.checked) {
								$('input[name=SERVER_KEY]').prop('checked', true);
							} else {
								$('input[name=SERVER_KEY]').prop('checked', false);
							}
						});

						// content checkbox 이벤트 등록
						$('input[name=SERVER_KEY]').on('change', function(event) {

							var changeValue = this.value;
							var flag = true;
							$('input:checkbox[name=SERVER_KEY]:checked').each(function() {
								if (this.value !== changeValue) {
									return flag = false;
								}
							});

							if (this.checked && !flag) {
								alert("같은 장비만 선택 해주세요.");
								$(this).prop('checked', false);
								return;
							}

							releaseAllCheckbox();
						});
						
						$(".checkbox").bind("change", function(e) {
							var grid = $("#trunk_list").data("kendoGrid");
							var row = $(e.target).closest("tr");
//							row.toggleClass("k-state-selected");
							grid.dataItem(row);
						});

						gridDataBound(e, '장비');
					},
					pageable	: false,
					scrollable	: true,
					selectable	: false,
					sortable	: {
						mode 		: 'multiple',
						allowUnsort : true
					},
					columns		: [
						{headerTemplate: '<input type="checkbox" id="all_check" name="ALL_CHECK" value="Y"/>', template: kendo.template($('#checkboxTemplate').html()),attributes:alignCenter, headerAttributes:{style:'text-align:center;vertical-align:middle'}, sortable : false},
						{field:'N_MON_ID',  title:'장비ID', width:'18%', attributes:alignCenter, headerAttributes:alignCenter},
						{field:'S_MON_IP',  title:'장비IP', width:'23%', attributes:alignCenter, headerAttributes:alignCenter},
						{field:'N_NUM', 	title:'그룹', 	width:'15%', attributes:alignCenter, headerAttributes:alignCenter},
						{field:'S_NAME', 	title:'그룹명', width:'36%', attributes:alignLeft, headerAttributes:alignCenter}
					],
					height		: 500
				})).data('kendoGrid');
	}

	function selectedGridDataSource() {
		return new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/kendoPagination_trunk_group_info.selectDetailDialingInfo.htm",
					data 		: function(data) {
						return {
							N_DIALING_CODE : '${data.N_DIALING_CODE}'
						};
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
			serverPaging	: false,
			serverSorting	: true
		});
	}

	function initSelGrid() {
		selectedGrid = $("#sel_trunk_group_list")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: '${param.updateFlag}' === 'U' ? selectedGridDataSource() : [],
				dataBound	: function (e) {
					$('#all_sel_check').on('click', function() {
						if (this.checked) {
							$('input[name=SERVER_SEL_KEY]').prop('checked', true);
						} else {
							$('input[name=SERVER_SEL_KEY]').prop('checked', false);
						}
					});

					$('input[name=SERVER_SEL_KEY]').on('change', releaseAllSelCheckbox);

					$(".checkboxSel").bind("change", function(e) {
						var row = $(e.target).closest("tr");
//						row.toggleClass("k-state-selected");
					});

					gridDataBound(e, '장비');
				},
				pageable	: false,
				scrollable	: true,
				sortable	: {
					mode 		: 'multiple',
					allowUnsort : true
				},
				columns		: [
					{headerTemplate: '<input type="checkbox" id="all_sel_check" name="ALL_SEL_CHECK" value="Y"/>', template: kendo.template($('#checkboxSelTemplate').html()),attributes:alignCenter, headerAttributes:{style:'text-align:center;vertical-align:middle'}, sortable : false},
					{field:'N_MON_ID',  title:'장비ID', width:'18%', attributes:alignCenter, headerAttributes:alignCenter},
					{field:'S_MON_IP',  title:'장비IP', width:'23%', attributes:alignCenter, headerAttributes:alignCenter},
					{field:'N_NUM', 	title:'그룹', 	width:'15%', attributes:alignCenter, headerAttributes:alignCenter},
					{field:'S_NAME', 	title:'그룹명', width:'36%', attributes:alignLeft, headerAttributes:alignCenter}
				],
				height		: 500
			})).data('kendoGrid');
	}

	// 저장
	function save()
	{
		$("input:checkbox[name='SERVER_SEL_KEY']").prop("checked", true);
		setKeyValue();
		
		if(!fn_validation_chk()) {
			return;
		}

		var params = $("form[name='trunk_group_insert_form']").serialize();

		var selectedData = selectedGrid.dataSource.data(),
			monIds		 = [],
			trunkGrpNums = [];

		for (var i = 0, length = selectedData.length; i < length; i++) {
			var obj = selectedData[i];

			monIds.push(obj.N_MON_ID);
			trunkGrpNums.push(obj.N_NUM);
		}

		var addParams = {
			N_MON_ID 			: monIds,
			N_TRUNK_GROUP_NUM 	: trunkGrpNums
		}

		var url 			= "<c:url value='/admin/trunk_group/insert.htm'/>",
			requestParams 	= params + '&' + $.param(addParams, true);

		if ('${param.updateFlag}' === 'U') {
			url = "<c:url value='/admin/trunk_group/update.htm'/>"
			requestParams += '&_method=put'
		}

		var jqXhr = $.post(url, requestParams);
		jqXhr.done(function(){
			alert('저장되었습니다.');
			goListPage();
		});

		jqXhr.fail(function() {
			alert("저장 실패 하였습니다.");
		});
	}

	function fn_delete()
	{
		if ( confirm('삭제하시겠습니까?') ) {
			var params = {
				'N_DIALING_CODE' : $('#N_DIALING_CODE').val(),
				'_method'		 : 'delete'
			};
			
			var jqXhr = $.post('/admin/trunk_group/delete.htm', params);
			jqXhr.done(function() {
				alert('삭제되었습니다.');
				goListPage();
			});

			jqXhr.fail(function() {
				alert('삭제 실패하였습니다.');
			});
		}
	}

	function goListPage(event) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.trunk_group.retrieve.htm').submit();
	}

	function fn_left_click(event) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}
		$("#sel_trunk_group_list").find("input:checked[name='SERVER_SEL_KEY']").each(function(){
			selectedGrid.removeRow($(this).closest('tr'));
		})
	}
	
	function fn_right_click(event) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}

		var dataSource = selectedGrid.dataSource;
		var data = dataSource.data();
		var selGridRowVal = fn_sel_grid_row("trunk_list","checkbox");

		var before = null;
		for (var i = 0, length = selGridRowVal.length; i < length ; i++) {
			var v = selGridRowVal[i];

			if (before != null && v.N_MON_ID !== before) {
				alert("같은 장비만 선택 해주세요.");
				return;
			}
			before = v.N_MON_ID;
		}

		if (selGridRowVal.length > 0 && data.length > 0) {
			if (selGridRowVal[0].N_MON_ID !== data[0].N_MON_ID) {
				alert("같은 장비만 선택 해주세요.");
				return;
			}
		}

		var leftSelGridVal = merge(selGridRowVal, data);
		dataSource.data([]);

		for (var i = 0; i < leftSelGridVal.length; i++) {
			dataSource.add({
				N_MON_ID	: leftSelGridVal[i].N_MON_ID,
				S_MON_IP	: leftSelGridVal[i].S_MON_IP,
				N_NUM		: leftSelGridVal[i].N_NUM,
				S_NAME		: leftSelGridVal[i].S_NAME
			});
		}
	}
	
 	function merge(prevJson, nextJson){
		$.merge(nextJson, prevJson);

		var existingMonId 		= new Array();
		var existingGroupNum 	= new Array();
		var existingArray 		= new Array();

		$.grep(nextJson, function(v) {
			if ( isDuplication(v, existingMonId, existingGroupNum) ) {
				return false;
			}
			else {
				existingMonId.push(v.N_MON_ID);
				existingGroupNum.push(v.N_NUM);
				existingArray.push(v);
				return true;
			}
		});
		return existingArray;
	}

	function isDuplication(v, monId, groupNum) {
		return $.inArray(v.N_MON_ID, monId) > -1 &&  $.inArray(v.N_NUM, groupNum) > -1;
	}
 	
	function fn_sel_grid_row(gridName, checkName){

		var idsToSend 	= [];
		var grid 		= $("#"+gridName).data("kendoGrid");
		var ds 			= grid.dataSource.view();

		for (var i = 0; i < ds.length; i++) {
			var row = grid.table.find("tr[data-uid='" + ds[i].uid + "']");
			var checkbox = $(row).find("." + checkName);
			if (checkbox.is(":checked")) {
				idsToSend.push(ds[i]);
			}
		}

		console.dir(idsToSend);

		return idsToSend;
	}
	
	function setKeyValue() {

		if ("${param.updateFlag}" != "U") {
			var now 	= new Date();
			var nowTime = now.getFullYear() + "" + (now.getMonth() + 1) + "" + now.getDate() + "" + now.getHours() + "" + now.getMinutes() + "" + now.getSeconds();
			var vkey 	= 'w';

			$("form[name='trunk_group_insert_form'] input[name='S_WORK_KEY']").val(vkey + nowTime);
		}

	    var serverSelKey = "";
	    $("input:checkbox[name='SERVER_SEL_KEY']:checked").each(function(){
	    	serverSelKey += $(this).val()+';';
	    });

	    $("form[name='trunk_group_insert_form'] input[name='SVR_ID']").val(serverSelKey);
	}

	function releaseAllCheckbox() {
		$('input[name=SERVER_KEY]').length === $('input[name=SERVER_KEY]:checked').length
				? $('#all_check').prop('checked', true)
				: $('#all_check').prop('checked', false);
	}
	
	function releaseAllSelCheckbox() {
		$('input[name=SERVER_SEL_KEY]').length === $('input[name=SERVER_SEL_KEY]:checked').length
		? $('#all_sel_check').prop('checked', true)
		: $('#all_sel_check').prop('checked', false);
	}

	// 벨리데이션 체크
	function fn_validation_chk()
	{
		var dialingName 	= $.trim($("#S_DIALING_NAME").val());
		var groupCode 		= $("#N_GROUP_CODE option:selected").val();
		var selectedLength 	= selectedGrid.dataSource.data().length;

		if (groupCode === '') {
			alert("장비그룹을 선택해주세요.");
			return false;
		} else if (dialingName === '') {
			alert("Trunk 그룹명을 입력해주세요.");
			return false;
		} else if (selectedLength === 0) {
			alert("적용할 Trunk Group 을 선택해주세요.");
			return false;
		}

		return true;
	}

</script>

<script id="checkboxSelTemplate" type="text/x-kendo-template">
	<input type="checkbox" name="SERVER_SEL_KEY" class="checkboxSel" value="#= N_MON_ID #"/>
</script>

<script id="checkboxTemplate" type="text/x-kendo-template">
	<input type="checkbox" name="SERVER_KEY" class="checkbox" value="#= N_MON_ID #"/>
</script>