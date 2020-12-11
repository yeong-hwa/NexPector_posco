<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>기존 관제 연동코드 정보 등록</h2><span>Home &gt; 감시장비 관리 &gt;기존 관제 연동코드 정보등록</span></div></div>
<form id="form" name="form">
	<div style="float: left;margin-bottom: 5px;"><a href="javascript:goListPage();" id="btn_list" class="css_btn_class">목록</a></div>
	
	<div class="manager_contBox1">
		<div class="table_typ2-5">
			<table summary="" cellpadding="0" cellspacing="0">
				<caption></caption>
				<colgroup>
					<col width="15%" />
					<col width="35%" />
					<col width="15%" />
					<col width="35%" />
				</colgroup>
				<tr>
					<td class="filed_A left">
					<label for="txt_user_id" class="required">알람키</label></td>
					<td class="filed_B left">
						<c:choose>
							<c:when test="${param.updateFlag eq 'U'}">
								<span id="txt_alm_key"></span>
								<input type="hidden" id="S_ALM_KEY" name="S_ALM_KEY" value="${param.S_ALM_KEY}"/>
							</c:when>
							<c:otherwise>
								<input type="text" name="S_ALM_KEY" id="S_ALM_KEY" value="" class="manaint_f" style="width:300px;"/></td>
							</c:otherwise>
						</c:choose>
					</td>
					<td class="filed_A left"></td>
					<td class="filed_B left"></td>
				</tr>
				<tr>
					<td class="filed_A left">알람타입</td>
					<td class="filed_B left">
						<select name="N_ALM_TYPE" id="N_ALM_TYPE" style="width:300px;">
							<option value="">선택</option>
						</select>
					</td>
					<td class="filed_A left">알람코드</td>
					<td class="filed_B left">
						<select name="N_ALM_CODE" id="N_ALM_CODE" style="width:300px;">
							<option value="">선택</option>
						</select>
					</td>
				</tr>
				<tr id="map_key_tr">
					<td class="filed_A left">맵 키</td>
					<td class="filed_B left">
						<input type="text" name="S_MAP_KEY" id="S_MAP_KEY" value="" class="manaint_f" style="width:300px;"/></td>
					</td>
					<td class="filed_A left"></td>
					<td class="filed_B left">
					</td>
				</tr>
				<tr>
					<td class="filed_A left">알람 제목</td>
					<td class="filed_B left">
						<input type="text" name="S_SUBJECT" id="S_SUBJECT" value="" class="manaint_f" style="width:300px;"/></td>
					</td>
					<td class="filed_A left">알람 메시지</td>
					<td class="filed_B left">
						<input type="text" name="S_MSG" id="S_MSG" value="" class="manaint_f" style="width:300px;"/></td>
					</td>
				</tr>
			</table>
			<!-- botton -->
			<div id="botton_align_center1">
				<a href="javascript:save();" id="btn_save" class="css_btn_class">저장</a>&nbsp;&nbsp;&nbsp;
				<a href="#" id="btn_cancel" class="css_btn_class">취소</a>&nbsp;&nbsp;&nbsp;
				<c:if test="${param.updateFlag == 'U'}">
					&nbsp;&nbsp;&nbsp;<a href="#" id="btn_remove" class="css_btn_class3">삭제</a>
				</c:if>
			</div>
			<!-- botton // -->
		</div>
	</div>
</form>	
<div class="mana_box4" style="margin-top:inherit;">
	<div class="box_a" style="padding-right: 20px;">
		<table  cellpadding="0" cellspacing="0" class="table_left_s1">
			<tr>
				<td class="bgtl1"></td>
				<td class="bgtc1">
					<strong>서버리스트</strong>
					<span style="display:inline-block; float:right;">
						<%-- <strong>서버타입 : </strong>
						<cmb:combo qryname="common.cmbSvrTypeIncludeDump" seltagname="N_TYPE_CODE" etc="id=\"search_svr_type\" class=\"input_search\" style=\"width:100;\""/> --%>
					</span>
				</td>
				<td class="bgtr1"></td>
			</tr>
			<tr>
				<td class="bgml1"></td>
				<td class="bgmc1">
					<div id="server_grid" class="table_typ2-7" style="margin: 10px 0px 0px 0px;" style="display:none;"></div>
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
	</div>
</div>

<form id="go_list_form" method="get">
	<input type="hidden" name="searchParam" value="${param.searchParam}"/>
</form>

<script>

	var grid;

	$(document).ready(function() {
		initServerGrid();
		initEvent();

		makeCombo($("#N_ALM_TYPE"), "<c:url value='/admin/lst_common.cmb_alm_type.htm'/>");

		// 수정 페이지
		if ('U' === '${param.updateFlag}') {
			makeCombo($("#N_ALM_CODE"), "<c:url value='/admin/lst_common.cmb_alm_code.htm'/>", {ALM_TYPE : '${param.N_ALM_TYPE}'}, function () {
				detailInfoDataSetting('${param.S_ALM_KEY}');
			});
		}
	});

	function initEvent() {
		// 알람타입 콤보박스
		$("#N_ALM_TYPE").on('change', function() {
			makeCombo($('#N_ALM_CODE'), "<c:url value='/admin/lst_common.cmb_alm_code.htm'/>", { ALM_TYPE : $(this).val() });
			var almType = $("#N_ALM_TYPE").val();
			var almCode = $("#N_ALM_CODE").val();
			
			// 알람타입이 10002면서 알람코드가 3일 경우 OR 알람타입이 10400 일경우 맵키입력, 장비 선택가능 하게끔 변경
			if (hasMapKey(almType, almCode)) {
				$('.mana_box4').show();
				// $('#map_key_tr').show();
			}
			else {
				$('.mana_box4').hide();
				// $('#map_key_tr').hide();
			}
		});		
		// 알람코드 콤보박스
		$("#N_ALM_CODE").on('change', function() {
			var almType = $("#N_ALM_TYPE").val();
			var almCode = $("#N_ALM_CODE").val();
			
			// 알람타입이 10002면서 알람코드가 3일 경우 OR 알람타입이 10400 일경우 맵키입력, 장비 선택가능 하게끔 변경
			if (hasMapKey(almType, almCode)) {
				$('.mana_box4').show();
				// $('#map_key_tr').show();
			}
			else {
				$('.mana_box4').hide();
				// $('#map_key_tr').hide();
			}
		});		
		
		// 서버타입 Combo Box
/* 		$('#search_svr_type').on('change', function() {
			grid.dataSource.read({'N_TYPE_CODE':this.value});
		}); */

		$('#N_ALM_TYPE').eq(0).change();
		
		$('#btn_remove').on('click', deleteInfo);
	}

	function goListPage() {
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.mon_linkage.retrieve.htm').submit();
	}
	
	function makeCombo(obj, url, param, fn_callback) {
		var jqXhr = $.post(url, param);
		jqXhr.done(function (str) {
			var data = JSON.parse(str);
			
			$(obj).empty();
			$(obj).append("<option value=''>선택</option>");
			
			for (var i = 0; i < data.length; i++) {
				$(obj).append("<option value=" + data[i].CODE + ">" + data[i].VAL + "</option>");
			}
			
			fn_callback && fn_callback();
		});
	}
	
	// 장비 그리드 초기화
	function initServerGrid() {
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/kendoPagination_common.pagingSvrList.htm",
					data 		: function(data) {
						return {
							// 'N_TYPE_CODE' : $('#search_svr_type').val()
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

		grid = $("#server_grid")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: dataSource,
				dataBound	: function(e) {

					gridDataBound(e);

					// 전체 체크
					$('#server_all_check').off('click').on('click', function (event) {
						if (this.checked) {
							$('input[type=checkbox]').prop('checked', true);
						} else {
							$('input[type=checkbox]').prop('checked', false);
						}
					});

					// 개별 체크
					$('input[name=N_MON_ID]').on('click', function (event) {

						addSingleCheckboxEvent(this);
					});
				},
//				change		: selectedGridRow,
				pageable	: false,
				height : 400,
				sortable	: true,
				scrollable	: true,
				resizable	: false,
				selectable	: 'multiple',
				columns		: [
					{headerTemplate: '<input type="checkbox" id="server_all_check" value="Y"/>', template: '<input type="checkbox" name="N_MON_ID" value="#=N_MON_ID#"/>', width:'10%', attributes:alignCenter, headerAttributes:alignCenter, sortable : false},
					{field:'N_MON_ID', title:'서버ID', width:'20%', attributes:alignCenter, headerAttributes:alignCenter},
					{field:'S_MON_NAME', title:'서버명', width:'45%', attributes:alignCenter, headerAttributes:alignCenter},
					{field:'S_MON_IP', title:'서버IP', width:'35%', attributes:alignCenter, headerAttributes:alignCenter}
				]
			})).data('kendoGrid');
	}

	// 사용자, 서버 그리드 클릭시 체크박스 처리로직
	function selectedGridRow() {
		var $checkbox = this.select().find(':first').find('input[type=checkbox]');
		if ($checkbox.is(':checked')) {
			$checkbox.prop('checked', false);
		} else {
			$checkbox.prop('checked', true);
		}

		addSingleCheckboxEvent($checkbox);
	}

	function addSingleCheckboxEvent(selector) {
		releaseAllCheckbox();
	}

	// 사용자, 서버 그리드 전체 체크박스 처리 로직
	function releaseAllCheckbox() {
		var $allCheck, contentSelector;
			$allCheck 		= $('#server_all_check');
			contentSelector = 'input[name=N_MON_ID]';

		$(contentSelector).length === $(contentSelector + ':checked').length
				? $allCheck.prop('checked', true)
				: $allCheck.prop('checked', false);
	}

	function save() {
		if (!fn_validation_chk()) {
			return;
		}
		
		var jqxhr = getJqXhrCheckDuplication($('#S_ALM_KEY').val());
		jqxhr.done(function (data) {
			if (data.length > 0 && 'U' != '${param.updateFlag}') {
				alert('중복된 ID 입니다.');
			} else {
				saveData();
			}
		});
	}

	function saveData() {
		
		var url = ('${param.updateFlag}' != 'U') ? "<c:url value='/admin/mon_linkage/insert.htm'/>" : "<c:url value='/admin/mon_linkage/update.htm'/>";
		
		var param = $("#form").serialize();
		
		var almType = $("#N_ALM_TYPE").val();
		var almCode = $("#N_ALM_CODE").val();
		
		if(hasMapKey(almType, almCode)) {
			param += '&' + $('#server_grid table [type=checkbox]:checked').serialize();
		}
		
		var jqXhr = $.post(url, param);
		jqXhr.done(function (data) {
			if (Number(data.RSLT) > 0) {
				alert('저장되었습니다.');
				goListPage();
				return;
			}
			else {
				alert("저장 실패 하였습니다.");
				return;
			}
		});
	}
	
	function getJqXhrCheckDuplication(sAlmKey) {
		var url = "<c:url value='/admin/lst_mon_linkage.detail_info.htm'/>";
		return $.getJSON(url, $.param({'S_ALM_KEY' : sAlmKey}));
	}
	
	/*
	function save() {

		if (!fn_validation_chk()) {
			return;
		}

		var param = $('#frm').serialize();

		var arr = $('#search_alm_type option:selected').val().split(';');
		param += '&N_ALM_TYPE=' + arr[0] + '&N_ALM_CODE=' + arr[1];
		param += '&' + $('#server_grid table [type=checkbox]:checked').serialize();

		var jqXhr = $.getJSON(cst.contextPath() + '/admin/duplicateThresholdTime.htm', param);

		jqXhr.done(function(data) {

			if (Number(data.RSLT) < 0) {
				alert("저장 실패 하였습니다.");
				return;
			}

			if (Number(data.count) > 0) {
				alert(data.names + '\n장비의 임계치 시간값이 중복되었습니다.');
				return;
			}

			$.post(cst.contextPath() + "/admin/saveThreshold.htm", param, function(data){
				var result = Number(data.RSLT);
				if(result > 0) {
					alert('저장되었습니다.');
					return;
				}
				else {
					alert("저장 실패 하였습니다.");
					return;
				}
			});
		});
	}
*/	
	// 벨리데이션 체크
	function fn_validation_chk() {
		if (!$('#S_ALM_KEY').val()) {
			alert('알람키를 입력해 주세요.');
			return false;
		}
		if (!$('#S_SUBJECT').val()) {
			alert('제목을 입력해 주세요.');
			return false;
		}
		if (!$('#S_MSG').val()) {
			alert('메시지를 입력해 주세요.');
			return false;
		}
		
		var almType = $('#N_ALM_TYPE').val();
		var almCode = $('#N_ALM_CODE').val();
		if (!almType) {
			alert('알람 타입을 선택해주세요.');
			return false;
		}
		if (!almCode) {
			alert('알람 코드를 선택해주세요.');
			return false;
		}
		if (hasMapKey(almType, almCode)) {
			var sMapKey = $('#S_MAP_KEY').val();
			if(!sMapKey) {
				alert('맵 키를 입력해주세요.');
				return false;
			}
			
			if ($('input[name=N_MON_ID]:checked').length === 0) {
				alert('장비를 선택해주세요.');
				return false;
			}
		}
		return true;
	}
	
	// mon_map 정보를 가지고 있는 지 확인
	function hasMapKey(almType, almCode) {
		if ((almType == 10002 && (almCode == 3 || almCode == 4)) || almType == 10400) { 
			return true;			
		}
		else {
			return false;
		}
	}
	
	function detailInfoDataSetting(sAlmKey){
		
		var param = {
			'S_ALM_KEY'	: sAlmKey
		};
		
		$.getJSON("<c:url value='/admin/map_mon_linkage.detail_info.htm'/>", param, function(data){
			$("#txt_alm_key").html(data.S_ALM_KEY);
			
			$("#S_SUBJECT").val(data.S_SUBJECT);
			$("#S_MSG").val(data.S_MSG);
			$("#N_ALM_TYPE").val(data.N_ALM_TYPE);
			$("#N_ALM_CODE").val(data.N_ALM_CODE);
			$("#S_MAP_KEY").val(data.S_MAP_KEY);
			
			if (hasMapKey(data.N_ALM_TYPE, data.N_ALM_CODE)) {
				$('.mana_box4').show();
				// $('#map_key_tr').show();
				
				$.getJSON("<c:url value='/admin/lst_mon_linkage.select_mon_map_list.htm'/>", param, function(data){
					var tdsize = $(data).size();
					if(tdsize>=1){
						$(data).each(function(){
							// grid.dataSource.read();
							$("input:checkbox[NAME='N_MON_ID']:checkbox[value='"+this.N_MON_ID+"']").attr("checked", true);
						});
					}
				});
			}
		});
	}
	
	function deleteInfo() {
		if (!confirm("삭제 하시겠습니까?")) {
			return;
		}
		var url 	= "<c:url value='/admin/mon_linkage/delete.htm'/>",
			param 	= $("form[name='form']").serialize();

		var jqXhr = $.post(url, param);
		jqXhr.done(function (data) {
			if (Number(data.RSLT) > 0) {
				alert('삭제되었습니다.');
				goListPage();
				return;
			} else {
				alert("삭제 실패 하였습니다.");
				return;
			}
		});
	}
</script>