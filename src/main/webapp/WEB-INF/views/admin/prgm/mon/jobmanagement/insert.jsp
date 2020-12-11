<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<style type="text/css">
	.manaint_f{height: 26px;}
	.k-datetimepicker .k-picker-wrap .k-icon{margin:0 2px;margin-top: 5px;}
	.mana_box5 .table_center img{padding: 0 4px 10px 5px;}
</style>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>작업관리</h2><span>Home &gt; 감시장비 관리 &gt; 작업관리</span></div></div>

<form id="job_manager_insert_form" name="job_manager_insert_form" data-role="validator">
<input type="hidden" id="jobmanagement_delete_list" name="JOBMANAGEMENT_DELETE_LIST" value=""/>
	<div class="manager_contBox1">
		<!--//사용자등록 -->
		<div class="mana_box5 mgt20">
			<div class="box_a" style="padding:0px;">
				<table  cellpadding="0" cellspacing="0" bolder="1" class="table_left_s1">
				<tr>
					<td class="bgtl1"></td>
					<td class="bgtc1">
						<span class="admin_left">
						</span>
						<span class="admin_right" style="margin-left: 5px;">
							<strong>장비타입 :</strong>
							<select name="N_TYPE_ID" id="sel_type_list" class="serverList"><option value="">선택</option></select>
						</span>
						<span class="admin_right">
							<strong>센터 :</strong>
							<select name="N_GROUP_ID" id="sel_group_list" class="serverList"><option value="">선택</option></select>
						</span>
						<span class="admin_right">
						</span>
					</td>
					<td class="bgtr1"></td>
				</tr>
				<tr>
					<td class="bgml1"></td>
					<td class="bgmc1">
						<div id="server_list" class="table_typ1" style="margin: 10px 0px 0px 0px;"></div>
					</td>
					<td class="bgmr1"></td>
				</tr>
				<tr>
					<td class="bgbl1"></td>
					<td class="bgbc1"></td>
					<td class="bgbr1"></td>
				</tr>
				</table>
	
				<table class="table_center">
					<tr>
						<td  align="center" valign="middle">
							<a href="#"><img id="btn_left" src="<c:url value="/admin/images/botton/arrow2_1.jpg"/>" alt="이전" /></a>
							<a href="#"><img id="btn_right" src="<c:url value="/admin/images/botton/arrow2_2.jpg"/>" alt="다음" /></a>
						</td>
					</tr>
				</table>

				<table  cellpadding="0" cellspacing="0" class="table_left_s1">
				<tr>
					<td class="bgtl1"></td>
					<td class="bgtc1"><strong>작업서버</strong></td>
					<td class="bgtr1"></td>
				</tr>
				<tr>
					<td class="bgml1"></td>
					<td class="bgmc1">
						<div id="sel_server_list" class="table_typ1" style="margin: 10px 0px 0px 0px;"></div>
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
									<col width="15%" />
									<col width="35%" />
									<col width="15%" />
									<col width="35%" />
								</colgroup>
								<tr>
									<td class="filed_A">작업명</td>
									<td class="filed_B left" colspan="3"><input type="text" name="S_NAME" id="S_NAME" value="" class="manaint_f" style="height: 19px;"/></td>
								</tr>
								
								<tr>
									<td class="filed_A">그룹명</td>
									<td class="filed_B left">
										<select id="N_GROUP_CODE" name="N_GROUP_CODE">
											<option value="">선택</option>
										</select>
									</td>
									<td class="filed_A left">장비타입</td>
									<td class="filed_B left">
										<select id="N_TYPE_CODE" name="N_TYPE_CODE">
											<option value="">선택</option>
										</select>
									</td>
								</tr>
								
								<tr>
									<td class="filed_A"  rowspan="2">작업일시</td>
									<td class="filed_B left" colspan="3">
										<label><input type="radio" id="N_REPEAT_TYPE" name="N_REPEAT_TYPE" value="0" checked/>지정</label>
									    <label><input type="radio" id="N_REPEAT_TYPE" name="N_REPEAT_TYPE" value="2"/>반복</label>
									</td>
								</tr>
								<tr>
									<td id='dateContainer' class="filed_B left" colspan="3">
										<div id='dateTimePick'>
											<input type="text" name="S_DATE_TIME" id="S_DATE_TIME" value="" class="manaint_f"/> ~
											<input type="text" name="E_DATE_TIME" id="E_DATE_TIME" value="" class="manaint_f"/>
										</div>
										<div id='timePick' style='display:none'>
											<input type="text" name="S_TIME" id="S_TIME" value="" class="manaint_f"/> ~
											<input type="text" name="E_TIME" id="E_TIME" value="" class="manaint_f"/>
										</div>									
									</td>
								</tr>
								
								<tr>
									<td class="filed_A">작업내용</td>
									<td class="filed_B left" colspan="3"><textarea rows="10" cols="70" id="S_DESC" name="S_DESC" class="text_area_ty1"></textarea></td>
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
			
			</div>
		</div>
		<!--사용자등록//-->
	</div>
	<!-- manager_contBox1 // -->
	<input type="hidden" name="N_MON_ID" id="N_MON_ID" value="">
	<input type="hidden" name="SVR_ID" id="SVR_ID" value="">
	<input type="hidden" name="S_WORK_KEY" id="S_WORK_KEY" value="${param.S_WORK_KEY}">
</form>
	

<form id="go_list_form" method="get">
	<input type="hidden" name="searchParam" value="${param.searchParam}"/>
</form>

<script src="<c:url value="/common/js/rsa/jsbn.js"/>" type="text/JavaScript"></script>
<script src="<c:url value="/common/js/rsa/rsa.js"/>" type="text/JavaScript"></script>
<script src="<c:url value="/common/js/rsa/prng4.js"/>" type="text/JavaScript"></script>
<script src="<c:url value="/common/js/rsa/rng.js"/>" type="text/JavaScript"></script>

<script type="text/javascript">

	var sDateTimePick, eDateTimePick;
	var sTimePick, eTimePick;
	var tempDateTimePick, tempTimePick;
	var grid;

	$(document).ready(function() {
		cfn_makecombo_opt($("#N_GROUP_CODE"), "<c:url value="/admin/lst_common.cmb_svr_group.htm"/>");
		cfn_makecombo_opt($("#N_TYPE_CODE"), "<c:url value="/admin/lst_common.cmb_svr_type.htm"/>");
		cfn_makecombo_opt($("#sel_group_list"), "<c:url value="/admin/lst_common.cmb_svr_group.htm"/>");
		cfn_makecombo_opt($("#sel_type_list"), "<c:url value="/admin/lst_common.cmb_svr_type.htm"/>");
		
		// create DateTimePicker from input HTML element
		sDateTimePick = $("#S_DATE_TIME").kendoDateTimePicker({
			format: "yyyy/MM/dd HH:mm",
			value:new Date(),
			interval:30 // Combo Box 30분 단위 출력
		}).data('kendoDateTimePicker');

		eDateTimePick = $("#E_DATE_TIME").kendoDateTimePicker({
			format: "yyyy/MM/dd HH:mm",
			value:new Date(),
			interval:30 // Combo Box 30분 단위 출력
		}).data('kendoDateTimePicker');
		
		sTimePick = $('#S_TIME').kendoTimePicker({
			format: "HH:mm",
			value:new Date()
		}).data('kendoTimePicker');
		
		eTimePick = $('#E_TIME').kendoTimePicker({
			format: "HH:mm",
			value:new Date()
		}).data('kendoTimePicker');
		
		$("#job_manager_insert_form").kendoValidator().data("kendoValidator");
		initGrid();
		initSelGrid();
		initEvent();
		
		fn_changeCalendarType();
	});

	function detailInfoDataSetting(){
		
		var sWorkKey = "${param.S_WORK_KEY}";
		var param = {
				'S_WORK_KEY'	: sWorkKey
			};

		$.getJSON("<c:url value='/admin/lst_jobmanagement.detail_info.htm'/>", param, function(data){

			var tdsize = $(data).size();
			if(tdsize>=1){
				$(data).each(function(){
					$("input:checkbox[NAME='SERVER_KEY']:checkbox[value='"+this.N_MON_ID+"']").attr("checked", true);
				});
				fn_right_click();
			}

			$("#S_DESC").html(data[0].S_DESC);
			$("#S_NAME").val(data[0].S_NAME);
			
			$('input:radio[name=N_REPEAT_TYPE]:input[value=' + data[0].N_REPEAT_TYPE + ']').attr("checked", true);
			fn_changeCalendarType();
			
			if (data[0].N_REPEAT_TYPE == 2) {
				sTimePick.value(data[0].D_STIME.substr(11, 5));
				eTimePick.value(data[0].D_ETIME.substr(11, 5));
			}
			else {
				sDateTimePick.value(data[0].D_STIME);
				eDateTimePick.value(data[0].D_ETIME);
			}

			$("#N_GROUP_CODE").val(data[0].N_GROUP_CODE).attr("selected","selected");
			$("#N_TYPE_CODE").val(data[0].N_TYPE_CODE).attr("selected","selected");
		});
	}
	
	function initEvent() {
		// Server 검색조건 Select
		$(".serverList").on('change', function(event) {
			$('#server_list').data('kendoGrid').dataSource.read();
		});

		$('#btn_cancel').on('click', function(event) {
			event.preventDefault();
			if ( confirm("목록으로 이동하시겠습니까?") ) {
				goListPage();
//				detailInfoDataSetting();
			}
		});

		$('#btn_right').on('click', fn_right_click);
		$('#btn_left').on('click', fn_left_click);
		$('#btn_save').on('click', save);
		$('#btn_del').on('click', fn_delete);
		$('input[type=text]').focusout(function() {
			this.value = $.trim(this.value);
		});
		
		$('input:radio[name=N_REPEAT_TYPE]').on('change', fn_changeCalendarType);
	}

	function fn_changeCalendarType() {
		
 		if ($('input:radio[name=N_REPEAT_TYPE]:checked').val() == 2) {
			$('#dateTimePick').hide();
			$('#timePick').show();
		}
		else {
			$('#timePick').hide();
			$('#dateTimePick').show();
		}
	}
	
	// 사용자 목록 Grid
	function initGrid() {
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/kendoPagination_common.pagingSvrList.htm",
					data 		: function(data) {
						return {
							N_GROUP_CODE : $.trim($("select[name='N_GROUP_ID']").val()),
							N_TYPE_CODE : $.trim($("select[name='N_TYPE_ID']").val())
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
			serverPaging	: false,
			serverSorting	: true
		});

		grid = $("#server_list")
				.kendoGrid($.extend({}, kendoGridDefaultOpt, {
					dataSource	: dataSource,
					dataBound	: function () {
						$('#all_check').on('click', function() {
							if (this.checked) {
								$('input[name=SERVER_KEY]').prop('checked', true);
							} else {
								$('input[name=SERVER_KEY]').prop('checked', false);
							}
						});

						// content checkbox 이벤트 등록
						$('input[name=SERVER_KEY]').on('change', releaseAllCheckbox);
						
						$(".checkbox").bind("change", function(e) {
							var grid = $("#server_list").data("kendoGrid");
							var row = $(e.target).closest("tr");
							row.toggleClass("k-state-selected");
							grid.dataItem(row);
						});
						
						if ('U' === '${param.updateFlag}') {
							detailInfoDataSetting();
						}
					},
					pageable	: false,
					scrollable	: true,
					sortable	: {
						mode 		: 'multiple',
						allowUnsort : true
					},
					filterable  : {
						extra : false,
						operators : {
							string : { contains : "Contains"}
						}
					},
					columns		: [
						{width:'10%', headerTemplate: '<input type="checkbox" id="all_check" name="ALL_CHECK" value="Y"/>', template: kendo.template($('#checkboxTemplate').html()),attributes:alignCenter, headerAttributes:{style:'text-align:center;vertical-align:middle'}, sortable : false},
						{field:'N_MON_ID', title:'장비ID', width:'15%', attributes:alignCenter, headerAttributes:alignCenter, filterable : false},
						{field:'S_MON_NAME', title:'장비명', width:'45%', attributes:alignCenter, headerAttributes:alignCenter, filterable : false},
						{field:'S_MON_IP', title:'장비IP', width:'30%', attributes:alignCenter, headerAttributes:alignCenter}
					],
					height		: 500
				})).data('kendoGrid');
	}

	function initSelGrid() {
		$("#sel_server_list")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: [],
				dataBound	: function () {
					$('#all_sel_check').on('click', function() {
						if (this.checked) {
							$('input[name=SERVER_SEL_KEY]').prop('checked', true);
						} else {
							$('input[name=SERVER_SEL_KEY]').prop('checked', false);
						}
					});
					$('input[name=SERVER_SEL_KEY]').on('change', releaseAllSelCheckbox);
					$(".checkboxSel").bind("change", function(e) {
						var grid = $("#sel_server_list").data("kendoGrid");
						var row = $(e.target).closest("tr");
						row.toggleClass("k-state-selected");
//						var data = grid.dataItem(row);
					});
				},
				pageable	: false,
				scrollable	: true,
				sortable	: {
					mode 		: 'multiple',
					allowUnsort : true
				},
				columns		: [
					{width:'10%', headerTemplate: '<input type="checkbox" id="all_sel_check" name="ALL_SEL_CHECK" value="Y"/>', template: kendo.template($('#checkboxSelTemplate').html()),attributes:alignCenter, headerAttributes:{style:'text-align:center;vertical-align:middle'}, sortable : false},
					{field:'N_MON_ID', title:'장비ID', width:'15%', attributes:alignCenter, headerAttributes:alignCenter},
					{field:'S_MON_NAME', title:'장비명', width:'45%', attributes:alignCenter, headerAttributes:alignCenter},
					{field:'S_MON_IP', title:'장비IP', width:'30%', attributes:alignCenter, headerAttributes:alignCenter}
				],
				height		: 500
			})).data('kendoGrid');
	}

	// 저장
	function save()
	{
		$("input:checkbox[name='SERVER_SEL_KEY']").attr("checked",true);
		setKeyValue();
		
		if(!fn_validation_chk())
			return;

		
		if ($('input:radio[name=N_REPEAT_TYPE]:checked').val() == 2) {
			// 작업 일시 시작, 종료 일시 time일때
			$("#S_TIME").val(kendo.toString(sTimePick.value(), '20010101HHmm'));
			$("#E_TIME").val(kendo.toString(eTimePick.value(), '20010101HHmm'));
		} 
		else {
			// 작업 일시 시작, 종료 일시 dateTime일때
			$("#S_DATE_TIME").val(kendo.toString(sDateTimePick.value(), 'yyyyMMddHHmm'));
			$("#E_DATE_TIME").val(kendo.toString(eDateTimePick.value(), 'yyyyMMddHHmm'));
		}

		var param = $("form[name='job_manager_insert_form']").serialize();

		var url = ('${param.updateFlag}' != 'U')?"<c:url value='/admin/jobwork_insert.htm'/>":"<c:url value='/admin/jobwork_update.htm'/>";

		$.post(url, param, function(str){
			var data = $.parseJSON(str);
			if(data != null && data > 0) {
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

	function fn_delete()
	{
		if ( confirm('삭제하시겠습니까?') ) {
			var svr_id = "";

			$("input[name='SVR_ID']").val(svr_id);
			$("#jobmanagement_delete_list").val($("#S_WORK_KEY").val());

			var param = $("form[name='job_manager_insert_form']").serialize();
			$.post("<c:url value='/admin/jobwork_delete.htm'/>", param, function(str){
				var data = $.parseJSON(str);
				if(data.RSLT != null && data.RSLT > 0) {
					alert('삭제되었습니다.');
					goListPage();
					return;
				}
				else {
					alert("삭제 실패 하였습니다.\n" + data.ERRMSG + "");
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
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.jobmanagement.retrieve.htm').submit();
	}

	function clearFormData() {
		if ('U' === '${param.updateFlag}') {
			detailInfoDataSetting();
		} else {
			$("form")[0].reset();
		}
		$("#job_manager_insert_form span.k-tooltip-validation").hide(); // kendo validator 문구 초기화
	}

	function fn_left_click(event) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}
		var grid = $("#sel_server_list").data("kendoGrid");
		$("#sel_server_list").find("input:checked[name='SERVER_SEL_KEY']").each(function(){
			grid.removeRow($(this).closest('tr'));
		})
	}
	
	function fn_right_click() {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}

		var dataSource = $("#sel_server_list").data("kendoGrid").dataSource;
		var data = dataSource.data();
		var selGridRowVal = fn_sel_grid_row("server_list","checkbox");
		var leftSelGridVal = merge(selGridRowVal, data);
		dataSource.data([]);

		for(var i=0; i<leftSelGridVal.length;i++){
			dataSource.add({
				N_MON_ID	: leftSelGridVal[i].N_MON_ID,
				S_MON_NAME	: leftSelGridVal[i].S_MON_NAME,
				S_MON_IP	: leftSelGridVal[i].S_MON_IP
			});
		}
	}
	
 	function merge(prevJson, nextJson){
		$.merge(nextJson, prevJson);
		var existingMonId = new Array();
		var existingArray = new Array();
		$.grep(nextJson, function(v) {
			if ($.inArray(v.N_MON_ID, existingMonId) !== -1) {
				return false;
			}
			else {
				existingMonId.push(v.N_MON_ID);
				existingArray.push(v);
				return true;
			}
		});
		return existingArray;
	}
 	
	function fn_sel_grid_row(gridName, checkName){

		var idsToSend = [];
		var grid = $("#"+gridName).data("kendoGrid");
		var ds = grid.dataSource.view();
		for (var i = 0; i < ds.length; i++) {
			var row = grid.table.find("tr[data-uid='" + ds[i].uid + "']");
			var checkbox = $(row).find("."+checkName);
			if (checkbox.is(":checked")) {
				idsToSend.push(ds[i]);
			}
		}
		console.log("idsToSend :: "+idsToSend);
		return idsToSend;
	}
	
	function setKeyValue() {

		if("${param.updateFlag}" != "U"){
			var now = new Date();
			var nowTime = now.getFullYear() + "" + (now.getMonth()+1) + "" + now.getDate() + "" + now.getHours() + "" + now.getMinutes() + "" + now.getSeconds();
			var vkey = 'w';
		    $("form[name='job_manager_insert_form'] input[name='S_WORK_KEY']").val(vkey+nowTime);
		}

	    var serverSelKey = "";
	    $("input:checkbox[name='SERVER_SEL_KEY']:checked").each(function(){
	    	serverSelKey += $(this).val()+';';
	    });

	    $("form[name='job_manager_insert_form'] input[name='SVR_ID']").val(serverSelKey);
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
//		var sworkkey = $("#S_WORK_KEY").val();
		var sname = $.trim($("#S_NAME").val());
		var dstime = kendo.toString(sDateTimePick.value(), 'yyyyMMddHHmm');
		var detime = kendo.toString(eDateTimePick.value(), 'yyyyMMddHHmm');
		var sdesc = $.trim($("#S_DESC").val());
		var checkboxSel = $(".checkboxSel").val();
		var nGroupCode = $("#N_GROUP_CODE").val();
//		var nTypeCode = $("#N_TYPE_CODE").val();
		
		if ('U' !== '${param.updateFlag}') {
			if(checkboxSel == "" || checkboxSel == null){
				alert("서버가 선택되지 않았습니다.");
				return false;				
			}
		}

		if(sname == "" || sname == null){
			alert("작업명을 입력하셔야함");
			$("#S_NAME").focus();
			return false;
		}

		if(dstime == "" || dstime == null){
			alert("작업 시작 일시를 입력하셔함")
			$("#D_STIME").focus();
			return false;
		}

		if(detime == "" || detime == null){
			alert("작업 종료 일시를 입력 하셔야함")
			$("#D_ETIME").focus();
			return false;
		}

		if(nGroupCode == "" || nGroupCode == null){
			alert("그룹명을 선택 하셔야합니다.")
			$("#N_GROUP_CODE").focus();
			return false;
		}
		
		/*if(nTypeCode == "" || nTypeCode == null){
			alert("감시종류를 선택 하셔야합니다.")
			$("#N_TYPE_CODE").focus();
			return false;
		}*/
		
		if(sdesc == "" || sdesc == null){
			alert("작업 내용을 입력 하셔야함")
			$("#S_DESC").focus();
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