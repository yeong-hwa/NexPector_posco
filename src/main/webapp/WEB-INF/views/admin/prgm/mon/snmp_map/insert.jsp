<%@ page import="com.nns.common.util.RSACrypt" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>SNMP MAP 코드 정보등록</h2><span>Home &gt; 감시장비 관리 &gt; SNMP MAP 코드 정보등록</span></div></div>
<form id="snmp_map_insert_form" name="snmp_map_insert_form" data-role="validator">
	<input type="hidden" id="equipment_detail_list" name="EQUIPMENT_DETAIL_LIST" value=""/>
	<div style="float: left;margin-bottom: 5px;">
		<!-- <a href="#" id="btn_list" class="css_btn_class">목록</a> -->
	</div>
	
	<!-- manager_contBox1 -->
	<div class="manager_contBox1">
		<!-- 사용자선택 -->
		<div class="mana_box3">
			<div class="box_a">
				<table  cellpadding="0" cellspacing="0" class="table_left_s1">
					<tr>
						<td class="bgtl1"></td>
						<td class="bgtc1">
							<strong>서버그룹</strong>
							<select name="sel_group_code" id="sel_group_code"><option value="">전체</option></select>
							<strong style="margin-left:30px;">SNMP 장비</strong>
							<select name="N_SNMP_MAN_CODE" id="sel_snmp_man_code"></select>
						</td>
						<td class="bgtr1"></td>
					</tr>
					
					<tr style="height: 320px;">
						<td class="bgml1"></td>
						<td class="bgmc1">
							<div id="equipment_info_grid" style="margin: 10px 0px 0px 0px;">
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
				<table  cellpadding="0" cellspacing="0" class="table_left_s2">
					<tr>
						<td class="bgtl1"></td>
						<td class="bgtc1">
							<strong>SNMP감시상세 리스트</strong>
						</td>
						<td class="bgtc1"></td>
						<td class="bgtr1"></td>
					</tr>
					<tr style="height: 320px;">
						<td class="bgml1"></td>
						<td class="bgmc1" colspan="2">
							<div id="equipment_detail_info_grid" style="margin: 10px 0px 0px 0px;">
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
				<!-- botton -->
				<div id="botton_align_center1">
					<a href="#" id="btn_save" class="css_btn_class">저장</a>&nbsp;&nbsp;&nbsp;
					<a href="#" id="btn_cancel" class="css_btn_class">취소</a>&nbsp;&nbsp;&nbsp;
					<!--
					<a href="#" id="btn_remove" class="css_btn_class3">삭제</a>
					 -->
				</div>
				<!-- botton // -->
			</div>
		</div>
		<!-- 사용자선택//-->
	</div>	
</form>

<form id="go_list_form" method="get">
	<input type="hidden" name="searchParam" value="${param.searchParam}"/>
</form>

<script src="<c:url value="/common/js/rsa/jsbn.js"/>" type="text/JavaScript"></script>
<script src="<c:url value="/common/js/rsa/rsa.js"/>" type="text/JavaScript"></script>
<script src="<c:url value="/common/js/rsa/prng4.js"/>" type="text/JavaScript"></script>
<script src="<c:url value="/common/js/rsa/rng.js"/>" type="text/JavaScript"></script>

<script type="text/javascript">

	$(document).ready(function() {
		
		cfn_makecombo_opt($('#sel_group_code'), cst.contextPath() + '/admin/lst_cmb_svr_group.htm');
		cfn_makecombo_opt($('#sel_snmp_man_code'), cst.contextPath() + '/admin/lst_cmb_snmp_man_code.htm');
		
		initEquipmentGrid();
		initEquipmentDetailGrid();
		initEvent();
		
	});
	
	function initEvent() {
		
		//목록 버튼 클릭 이벤트
		$('#btn_list').on('click', function() {
			$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.snmp_map.retrieve.htm').submit();
		});
		
		//취소 버튼 클릭 이벤트
		$('#btn_cancel').on('click', function() {
			event.preventDefault();
			if (confirm("목록 페이지로 이동하시겠습니까?") ) {
				$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.snmp_map.retrieve.htm').submit();
			}
		});
		
		//서버그룹 변경 이벤트
		$('#sel_group_code').on('change', function(event) {
			event.preventDefault();
			$("#equipment_info_grid").data('kendoGrid').dataSource.read();
			$('#equipment_all_check').prop('checked', false);
			$('#equipment_detail_all_check').prop('checked', false);
			initEquipmentDetailGrid();
		});
		
		//SNMP장비 변경 이벤트
		$('#sel_snmp_man_code').on('change', function(event) {
			event.preventDefault();
			$("#equipment_info_grid").data('kendoGrid').dataSource.read();
			$('#equipment_all_check').prop('checked', false);
			$('#equipment_detail_all_check').prop('checked', false);
			initEquipmentDetailGrid();
		});
		
		//감시장비 전체 체크 이벤트
		$('#equipment_all_check').on('change', function() {
			if (this.checked) {
				$('input[name=N_MON_ID]').prop('checked', true);
			} else {
				$('input[name=N_MON_ID]').prop('checked', false);
			}
		});
		
		//SNMP감시상세 전체 체크 이벤트
		$('#equipment_detail_all_check').on('change', function() {
			if (this.checked) {
				$('input[name=equipment_detail_check]').prop('checked', true);
			} else {
				$('input[name=equipment_detail_check]').prop('checked', false);
			}
		});
		
		//저장
		$('#btn_save').on('click', save);
	}
	
	//감시장비 체크 이벤트
	function equipmentAllCheckbox() {
		$('input[name=N_MON_ID]').length === $('input[name=N_MON_ID]:checked').length
				? $('#equipment_all_check').prop('checked', true)
				: $('#equipment_all_check').prop('checked', false);
	}
	
	//SNMP감시상세 체크 이벤트
	function equipmentDetailAllCheckbox() {
		$('input[name=equipment_detail_check]').length === $('input[name=equipment_detail_check]:checked').length
				? $('#equipment_detail_all_check').prop('checked', true)
				: $('#equipment_detail_all_check').prop('checked', false);
	}

	// 감시장비 목록 Grid
	function initEquipmentGrid() {
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/snmp_map/equipmentList.htm",
					data 		: function(data) {
						return {
							'N_GROUP_CODE'    : $.trim($('#sel_group_code').val()),
							'N_SNMP_MAN_CODE' : $.trim($('#sel_snmp_man_code').val())
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
					var totalCount = response.length > 0 ? response[0].TOTAL_COUNT : 0;
					$('#total_count').text(totalCount);
					return totalCount;
				}
			},
			pageSize		: cst.countPerPage(),
			serverPaging	: true,
			serverSorting	: true
		});

		$("#equipment_info_grid")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				change		: equipmentDetailDataSource,
				dataSource	: dataSource,
				pageable	: {
					messages : {
						empty	: "<strong>No data</strong>",
						display : "<span>전체<strong style='color: #f35800;'>{2}</strong> 개 항목</span>"
					}
				},
				sortable	: true,
				scrollable	: true,
				resizable	: false,				
				columns		: [
					{headerTemplate: '<input type="checkbox" id="equipment_all_check" value="Y"/>', template: '<input type="checkbox" name="N_MON_ID" value="#=N_MON_ID#" onchange="equipmentAllCheckbox();"/>', width:'10%', attributes:alignCenter, headerAttributes:alignCenter, sortable : false},   		   
					{field:'S_MON_NAME', title:'감시장비', width:'90%', attributes:alignCenter, headerAttributes:alignCenter}
				],
				height		: '305px'
			}));
	}
	
	//SNMP감시상세 리스트
	function initEquipmentDetailGrid() {		
		$("#equipment_detail_info_grid")
		.kendoGrid($.extend({}, kendoGridDefaultOpt, {
			dataSource	: [],
			pageable	: {
				messages : {
					empty	: "<strong>No data</strong>",
					display : "<span>전체<strong style='color: #f35800;'>{2}</strong> 개 항목</span>"
				}
			},
			sortable	: true,
			scrollable	: true,
			resizable	: false,	
			editable	: true,
			selectable	: 'multiple',
			columns		: [
				//{headerTemplate: '<input type="checkbox" id="equipment_detail_all_check"/>', template: '<input type="checkbox" name="equipment_detail_check" onchange="equipmentDetailAllCheckbox();">', width:'10%', attributes:alignCenter, headerAttributes:alignCenter, sortable : false},
				{headerTemplate: '<input type="checkbox" id="equipment_detail_all_check"/>', template: kendo.template($('#checkboxTemplate').html()), width:'10%', attributes:alignCenter, headerAttributes:alignCenter, sortable : false},
				{field:'S_DESC', title:'SNMP감시상세', width:'65%', attributes:alignCenter, headerAttributes:alignCenter},
				{field:'N_TIMEM', title:'SNMP 기본 수집 주기(초)', width:'30%', attributes:alignCenter, headerAttributes:alignCenter}
			],
			height		: '305px'
		}));
	}
	
	function equipmentDetailDataSource() {
		
		var selectRow = $("#equipment_info_grid").data("kendoGrid");
		var selectedItem = selectRow.dataItem(selectRow.select());
		
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/snmp_map/equipmentList_detail.htm",
					data 		: function(data) {
						return {
							'N_SNMP_MAN_CODE' : $.trim($('#sel_snmp_man_code').val()),
							'N_MON_ID' : selectedItem.N_MON_ID
						};
					}
				},
				parameterMap: function (data, opperation) {
					return JSON.stringify(data);
				}
			},
			schema			: {
				model: {
					id : "S_DESC",
					fields: {
						'S_DESC'	: { editable: false }
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
			//pageSize		: cst.countPerPage(),
			//serverPaging	: true,
			serverSorting	: true
		});
		
		var equipmentDetail = $('#equipment_detail_info_grid').data('kendoGrid');
		equipmentDetail.setDataSource(dataSource);
		
	}
	
	//밸리데이션 체크
	function fn_validation_chk() {
		
		if($('input[name=N_MON_ID]:checked').length == 0) 
		{
			alert("감시장비를 선택해 주세요");
			return false;
		}
		
		if($('input[name=equipment_detail_check]:checked').length == 0) 
		{
			alert("SNMP감시상세를 선택해 주세요");
			return false;
		}
		
		return true;
	}
	
	//저장
	function save()
	{
		if(!fn_validation_chk()) {
			return;
		}
		
		var equipmentDetailGrid = $('#equipment_detail_info_grid').data('kendoGrid');
	    var equipmentDetailDataItem = equipmentDetailGrid.dataSource.data();
	    
	    var tmp_equipment_detail = "";
	    $("input[name=equipment_detail_check]").each(function(index) {
	    	if ($("input[name=equipment_detail_check]")[index].checked == true) {
				if (tmp_equipment_detail != "") {	
					tmp_equipment_detail += ",";
				}
	    		tmp_equipment_detail += equipmentDetailDataItem[index].N_SNMP_MON_CODE + ";" + equipmentDetailDataItem[index].N_TIMEM
	    	}
		});
	    $("#equipment_detail_list").val(tmp_equipment_detail);
	    	    
		var url = "<c:url value='/admin/snmp_map/insert.htm'/>";
		var param = $("form[name='snmp_map_insert_form']").serialize();
		
		$.post(url, param, function(str){
			var data = $.parseJSON(str);
			if(data.RSLT != null && data.RSLT > 0) {
				alert('저장되었습니다.');
				goListPage();
				return;
			}
			else {
				alert("저장 실패 하였습니다.\n" + data.ERRMSG + "");
				goListPage();
				return;
			}
		});
	}
	
	function goListPage(event) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.snmp_map.retrieve.htm').submit();
	}
</script>

<script id="checkboxTemplate" type="text/x-kendo-template">
	<input type="checkbox" name="equipment_detail_check" # if (CHK_VAL != -1) { # checked="checked" # } #/>
</script>