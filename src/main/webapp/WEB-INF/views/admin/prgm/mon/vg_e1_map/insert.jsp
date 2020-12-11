<%@ page import="com.nns.common.util.RSACrypt" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>VG E1 지점 맵핑 등록</h2><span>Home &gt; 감시장비 관리 &gt; VG E1 지점 맵핑 등록</span></div></div>
<form id="vg_e1_map_insert_form" name="vg_e1_map_insert_form" data-role="validator">
	<input type="hidden" id="equipment_vge1_list" name="EQUIPMENT_VGE1_LIST" value=""/>
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
							<strong>VG E1 Port 리스트</strong>
						</td>
						<td class="bgtc1"></td>
						<td class="bgtr1"></td>
					</tr>
					<tr style="height: 320px;">
						<td class="bgml1"></td>
						<td class="bgmc1" colspan="2">
							<div id="equipment_vge1_info_grid" style="margin: 10px 0px 0px 0px;">
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
				<div id="vge1s"></div>
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
		
		initEquipmentGrid();
		initEquipmentVge1Grid();
		initEvent();
	});
	
	function initEvent() {
		
		//목록 버튼 클릭 이벤트
		$('#btn_list').on('click', function() {
			$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.vg_e1_map.retrieve.htm').submit();
		});
		
		//취소 버튼 클릭 이벤트
		$('#btn_cancel').on('click', function() {
			event.preventDefault();
			if (confirm("목록 페이지로 이동하시겠습니까?") ) {
				$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.vg_e1_map.retrieve.htm').submit();
			}
		});
		
		//서버그룹 변경 이벤트
		$('#sel_group_code').on('change', function(event) {
			event.preventDefault();
			$("#equipment_info_grid").data('kendoGrid').dataSource.read();
			initEquipmentVge1Grid();
		});
		
		//저장
		$('#btn_save').on('click', save);
	}

	// 장비 목록 Grid
	function initEquipmentGrid() {
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/vg_e1_map/equipmentList.htm",
					data 		: function(data) {
						return {
							'N_GROUP_CODE'    : $.trim($('#sel_group_code').val()),
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
				change		: equipmentVge1DataSource,
				dataSource	: dataSource,
				pageable	: {
					messages : {
						empty	: "<strong>No data</strong>",
						display : "<span>전체<strong style='color: #f35800;'>{2}</strong> 개 항목</span>"
					}
				},
				sortable	: false,
				scrollable	: true,
				resizable	: false,				
				columns		: [
					{field:'S_MON_NAME', title:'장비명', width:'90%', attributes:alignCenter, headerAttributes:alignCenter}
				],
				height		: '305px'
			}));
	}
	
	//VO E1 Port 리스트
	function initEquipmentVge1Grid() {		
		$("#equipment_vge1_info_grid")
		.kendoGrid($.extend({}, kendoGridDefaultOpt, {
			dataSource	: [],
			pageable	: {
				messages : {
					empty	: "<strong>No data</strong>",
					display : "<span>전체<strong style='color: #f35800;'>{2}</strong> 개 항목</span>"
				}
			},
			sortable	: false,
			scrollable	: true,
			resizable	: false,	
			editable	: true,
			change: onChange,
            dataBinding: onDataBinding,
			selectable	: 'multiple',
			toolbar: ["cancel"],
			columns		: [
				{field:'S_DESC', title:'E1 Port', width:'65%', attributes:alignCenter, headerAttributes:alignCenter},
				{field:'JUM_CODE', title:'지점 코드', width:'30%', attributes:alignCenter, headerAttributes:alignCenter, editor: categoryDropDownEditor, template: "#=JUM_CODE#"},
				{field:'GROUP_NAME', title:'지점명', width:'30%', attributes:alignCenter, headerAttributes:alignCenter, editor: categoryDropDownEditor, template: "#=GROUP_NAME#"},
				],
            editable: true,
			height		: '305px'
		}));
	}
	
	function categoryDropDownEditor(container, options) {
        $('<input required name="' + options.field + '"/>')
            .appendTo(container)
            .kendoDropDownList({
                autoBind: false,
                dataTextField: "GROUP_NAME",
                dataValueField: "JUM_CODE",
                change: onComboChange,
                dataSource: {
                    type: "json",
                    transport: {
                    	read		: {
        					type		: 'post',
        					dataType	: 'json',
        					contentType	: 'application/json;charset=UTF-8',
        					url 		: cst.contextPath() + '/admin/vg_e1_map/comboOrgInfo.htm',
        					data 		: function(data) {
        						return {
        							/* 'CODE'   : $("#equipment_info_grid").data("kendoGrid").dataItem(selectRow.select()).JUM_CODE,
        							'VAL'    : $("#equipment_info_grid").data("kendoGrid").dataItem(selectRow.select()).GROUP_NAME, */
        						};
        					}
        				},
                    }
                }
            });
    }
	
	function onChange(arg) {
/* 		var selectRow = $("#equipment_info_grid").data("kendoGrid");
		var selectedItem = selectRow.dataItem(selectRow.select());
		console.log(arg.sender._data[0]); */
    }

    function onDataBound(arg) {
        console.log("Grid data bound");
    }

    function onDataBinding(arg) {
        console.log("Grid data binding");
    }

	function onComboChange(e) {
		var value = this.value();
		var text = this.text();
		console.log(value + " : " + text);
		//var combo = e.sender;
		var grid = $('#equipment_vge1_info_grid').data('kendoGrid');
		var selectedItem = grid.dataItem(grid.select());
		console.log("current");
		selectedItem.set("JUM_CODE", this.value());
		selectedItem.set("GROUP_NAME", this.text()); 
		console.log(selectedItem);
		//console.log(selectedItem);
		
		/* var dataItem = grid.dataItem(grid.current().closest("tr"));

		// You can then set properties as you want.
		dataItem.set("JUM_CODE", "foo");
		dataItem.set("JUM_NAME", "bar"); */
		
        //input.val("");
	    // check if new value is a custom one
		/* var selectRow = $("#equipment_info_grid").data("kendoGrid");
		var selectedItem = selectRow.dataItem(selectRow.select()); 
 		selectedItem.JUM_CODE = options.sender._old;  */
		/* var selectRow = $("#equipment_info_grid").data("kendoGrid");
		var selectedItem = selectRow.dataItem(selectRow.select()); 
		console.log(options);
 		selectedItem.JUM_CODE = options.sender._old;
 		selectedItem.GROUP_NAME = options.sender._old;
		console.log(selectedItem.JUM_CODE);
		console.log(selectedItem.GROUP_NAME); */
	}
	
	function equipmentVge1DataSource() {
		
		var selectRow = $("#equipment_info_grid").data("kendoGrid");
		var selectedItem = selectRow.dataItem(selectRow.select());
		
		var dataSource = new kendo.data.DataSource({
            transport: {
            	read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/vg_e1_map/equipmentE1List.htm",
					data 		: function(data) {
						return {
							'N_MON_ID' : selectedItem.N_MON_ID,
							'N_GROUP_CODE' : selectedItem.N_GROUP_CODE
						};
					}
					 
				},
                update: {
                	type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
                    url: cst.contextPath() + "/admin/vg_e1_map/save.htm",
                },
                success : function(data){
                	console.log("success" + data);
                },
                error : function(data){
                	console.log("fail" + data);
                },
                parameterMap: function(data, type) {
                	if(type === 'read'){
                		return JSON.stringify(data);
                	}
                	else{
                		console.log(JSON.stringify(data));
                    	return JSON.stringify(data);
                	}
                	
                },
            },
            batch: true,
			schema			: {
				model: {
					id :"N_INDEX",
					fields: {
						'S_DESC'	: { editable: false },
						'JUM_CODE': { editable: true },
						'GROUP_NAME': { editable: true }
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
		
		console.log(dataSource);
		var equipmentvge1 = $('#equipment_vge1_info_grid').data('kendoGrid');
		equipmentvge1.setDataSource(dataSource);
		
	}
	
	//밸리데이션 체크
	function fn_validation_chk() {
		
		if($('input[name=equipment_vge1_check]:checked').length == 0) 
		{
			alert("E1 Port를 선택해 주세요");
			return false;
		}
		
		var equipmentVge1Grid = $('#equipment_vge1_info_grid').data('kendoGrid');
	    var equipmentVge1DataItem = equipmentVge1Grid.dataSource.data();
	    
		$("input[name=equipment_vge1_check]").each(function(index) {
	    	if ($("input[name=equipment_vge1_check]")[index].checked == true) {
	    		if(equipmentVge1DataItem[index].JUM_CODE == null || equipmentVge1DataItem[index].JUM_CODE == "" || equipmentVge1DataItem[index].JUM_CODE == "undefined"){
	    			alert("지점을 지정해 주세요 (E1 Port :" + equipmentVge1DataItem[index].S_DESC + ")");
	    			return false;
	    		}
	    	}
		});
		
		return true;
	}
	
	//저장
	function save()
	{
		console.log($('#equipment_vge1_info_grid').data('kendoGrid')._data.length);
		var savedata = "";
		for(var i=0; i<$('#equipment_vge1_info_grid').data('kendoGrid')._data.length; i++) {
		    if($('#equipment_vge1_info_grid').data('kendoGrid')._data[i].dirty){
		    	var tempdata = $('#equipment_vge1_info_grid').data('kendoGrid')._data[i];
		    	console.log(tempdata);
		    	savedata += "," + tempdata.N_MON_ID + ";" + tempdata.N_INDEX + ";" + tempdata.JUM_CODE;
		    }
		}
		if(savedata.length <= 0){
			alert("저장할 데이터가 없습니다");
			return;
		}
		else if(savedata.length > 0){
	    	var url = "<c:url value='/admin/vg_e1_map/save.htm'/>";
	    	$("#equipment_vge1_list").val(savedata.replace(",", ""));
		    
	    	var url = "<c:url value='/admin/vg_e1_map/save.htm'/>";
			var param = $("form[name='vg_e1_map_insert_form']").serialize();
			console.log(param);
			console.log(param);
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
	}
	
	function goListPage(event) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.vg_e1_map.retrieve.htm').submit();
	}
</script>

<script id="checkboxTemplate" type="text/x-kendo-template">
	<input type="checkbox" name="equipment_vge1_check" # if (CHK_VAL != -1) { # checked="checked" # } #/>
</script>