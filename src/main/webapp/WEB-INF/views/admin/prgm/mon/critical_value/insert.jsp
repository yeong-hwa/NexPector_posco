<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>임계치 정보 등록</h2><span>Home &gt; 감시장비 관리 &gt; 임계치 정보 등록</span></div></div>
<form id="critical_value_insert_form" name="critical_value_insert_form" data-role="validator">
	<div style="float: left;margin-bottom: 5px;"><a href="#" id="btn_list" class="css_btn_class">목록</a></div>
	

	<!-- 사용자선택 -->
	<div class="mana_box4" style="margin-top:inherit;">
		<div class="box_a" style="padding-right: 20px;">
			<table  cellpadding="0" cellspacing="0" class="table_left_s1">
				<tr>
					<td class="bgtl1"></td>
					<td class="bgtc1">
						<strong>서버리스트</strong>
						<span style="display:inline-block; float:right;">
							<strong>서버타입 : </strong>
							<cmb:combo qryname="common.cmbSvrTypeIncludeDump" seltagname="N_TYPE_CODE" etc="id=\"search_svr_type\" class=\"input_search\" style=\"width:100;\""/>
						</span>
					</td>
					<td class="bgtr1"></td>
				</tr>
				<tr>
					<td class="bgml1"></td>
					<td class="bgmc1">
						<div id="server_grid" class="table_typ2-7" style="margin: 10px 0px 0px 0px;"></div>
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

			<table  cellpadding="0" cellspacing="0" class="table_left_s2" style="width: 69%;">
			<tr>
				<td class="bgtl1"></td>
				<td class="bgtc1">
					<strong>임계치 정보</strong>
					<span style="display:inline-block; float:right;">
						<strong>임계치 타입 : </strong>
						<select id="search_alm_type">
							<option value="">선택</option>
						</select>
					</span>
				</td>
				<td class="bgtr1"></td>
			</tr>
			<tr>
				<td class="bgml1"></td>
				<td class="bgmc1">
					<div class="table_typ2-7">
						<div id="threshold_area"><!-- 임계치 설정 HTML 영역 --></div>
						<!-- botton -->
						<div id="botton_align_center1" style="margin: 10px 0 0 0;">
							<a href="#" class="css_btn_class" id="btn_critical_save">저장</a><%--&nbsp;&nbsp;&nbsp;<a href="#" class="css_btn_class" id="btn_critical_cancel">취소</a>--%>
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
</form>

<form id="go_list_form" method="get">
	<input type="hidden" name="searchParam" value="${param.searchParam}"/>
</form>

<script>

	var grid;

	$(document).ready(function() {
		initServerGrid();
		initEvent();
	});

	function initEvent() {
		// 취소 버튼
		$('#btn_list').on('click', function(event) {
			event.preventDefault();
			if ( confirm("목록으로 이동하시겠습니까?") ) {
				$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.critical_value.retrieve.htm').submit();
//				$("form")[0].reset();
			}
		});

		// 저장 버튼
		$('#btn_critical_save').on('click', critical_save);

		$('input[type=text]').focusout(function() {
			this.value = $.trim(this.value);
		});

		// 서버타입 Combo Box
		$('#search_svr_type').on('change', function() {
			grid.dataSource.read({'N_TYPE_CODE':this.value});

			var jqXhr = $.getJSON(cst.contextPath() + '/admin/searchThresholdType.htm', {'N_TYPE_CODE':parseInt(this.value)});
			jqXhr.done(function(data) {
				var arrayData = $.isArray(data.list) ? data.list : [];
				var $searchAlmType = $('#search_alm_type');
				$searchAlmType.empty();
				$searchAlmType.append('<option value="">선택</option>');

				for (var i = 0, length = arrayData.length; i < length; i++) {
					var obj = arrayData[i];
					$searchAlmType.append('<option value="' + obj.CODE + '">' + obj.VAL + '</option>');
				}
			});
		});

		// 임계치 타입 Combo Box
		$('#search_alm_type').on('change', function(event) {

			if (isSelectedTrafficTrunk()) {
				$('input[type=checkbox]').prop('checked', false);
			}

			var url = cst.contextPath() + '/admin/go_prgm.mon.critical_value.threshold.threshold.htm';

			if (this.value === '<spring:eval expression="@serviceProps['admin.threshold.type.traffic.trunk']"/>' ||
					this.value === '<spring:eval expression="@serviceProps['admin.threshold.type.traffic.trunk.group']"/>') {

				/*// 서버선택이 안되어있으면 임계치 타입을 선택으로 되돌림
				// 그룹 Combo box 조회 때문임
				if ( !$('input:checkbox[name=N_MON_ID]').is(':checked') ) {
					alert("장비를 선택해주세요.");
					$('#search_alm_type').val('');
					return;
				}*/

				url = cst.contextPath() + '/admin/go_prgm.mon.critical_value.threshold.traffic_trunk_threshold.htm';
			} else if (this.value === '<spring:eval expression="@serviceProps['admin.threshold.type.abandoned']"/>') {
				url = cst.contextPath() + '/admin/go_prgm.mon.critical_value.threshold.abandoned_threshold.htm';
			} else if (this.value === '<spring:eval expression="@serviceProps['admin.threshold.type.ivr.app']"/>') {
				url = cst.contextPath() + '/admin/go_prgm.mon.critical_value.threshold.ivr_app_threshold.htm';
			}

			$.get(url).done(function(html) {
				$('#threshold_area').empty().html(html);
				$('#threshold_name').text($('#search_alm_type option:selected').text());
			});
		});

		$('#search_svr_type').eq(0).change();
		$('#search_alm_type').eq(0).change();
	}

	// 알람 사용자 그리드 초기화
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
							'N_TYPE_CODE' : $('#search_svr_type').val()
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
			pageSize		: 15,
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

						if ($('#search_alm_type').val() === '') {
							alert('임계치 타입을 선택해주세요.');
							event.preventDefault();
							return;
						}

						// CM Type 이면 전체 체크 안되도록 처리
						if (isSelectedTrafficTrunk()) {
							event.preventDefault();
							return false;
						}

						if (this.checked) {
							$('input[type=checkbox]').prop('checked', true);
						} else {
							$('input[type=checkbox]').prop('checked', false);
						}
					});

					// 개별 체크
					$('input[name=N_MON_ID]').on('click', function (event) {

						if ($('#search_alm_type').val() === '') {
							alert('임계치 타입을 선택해주세요.');
							event.preventDefault();
							return;
						}

						addSingleCheckboxEvent(this);
					});
				},
//				change		: selectedGridRow,
				pageable	: {
					messages : {
						empty	: "<strong>No data</strong>",
						display : "<span>전체<strong style='color: #f35800;'>{2}</strong> 개 항목</span>"
					}
				},
				sortable	: true,
				scrollable	: false,
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

		if ($('#search_alm_type').val() === '') {
			alert('임계치 타입을 선택해주세요.');
			return;
		}

		var $checkbox = this.select().find(':first').find('input[type=checkbox]');
		if ($checkbox.is(':checked')) {
			$checkbox.prop('checked', false);
		} else {
			$checkbox.prop('checked', true);
		}

		addSingleCheckboxEvent($checkbox);
	}

	function addSingleCheckboxEvent(selector) {
		if (isSelectedTrafficTrunk()) {
			clickCheckboxCmType(selector);
		} else {
			releaseAllCheckbox();
		}
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

	function clickCheckboxCmType(selector) {
		// CM Type 은 하나의 감시장비에 대한 그룹 목록을 출력 하기 때문에
		// 하나의 장비만 체크되도록 설정
		if ($(selector).is(':checked')) {
			$('input[type=checkbox]').prop('checked', false);
			$(selector).prop('checked', true);
		}
	}

	// 임계치 저장
	function critical_save() {

		if (!fn_validation_chk()) {
			return;
		}

		var param = $('#table_threshold :input, #table_threshold [type=select]').serialize();

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
	
	// 벨리데이션 체크
	function fn_validation_chk() {

		if ($('input[name=N_MON_ID]:checked').length === 0) {
			alert('장비를 선택해주세요.');
			return false;
		}
		else if ($('#search_alm_type option:selected').val() === '') {
			alert('임계치 타입을 선택해주세요.');
			return false;
		}
		else if ($('#start_value').val() === '') {
			alert('임계치 시작 값을 설정해주세요.');
			$('#start_value').focus();
			return false;
		}
		else if ($('#end_value').val() === '') {
			alert('임계치 종료 값을 설정해주세요.');
			$('#end_value').focus();
			return false;
		}
		else if ($('#threshold').val() === '') {
			alert('지속시간을 설정해주세요.');
			$('#threshold').focus();
			return false;
		}
		else if (isTimeCheck()) {
			alert('종료시간이 시작시간보다 작을수 없습니다.');
			return false;
		}
		else if (isEmptyTrafficTrunkGroupNum()) {
			alert('그룹을 선택해주세요.');
			return false;
		}
		else if (isEmptyIvrAppId()) {
			alert('시나리오를 선택해주세요.');
			return false;
		}

		return true;
	}

	function isTimeCheck() {
		return parseInt($('select[name=S_START_TIME]').val().replace(':', '')) > parseInt($('select[name=S_END_TIME]').val().replace(':', ''));
	}

	function isSelectedTrafficTrunk() {
		return Number($('#search_svr_type').val()) === 1000 &&
				($('#search_alm_type').val() === '<spring:eval expression="@serviceProps['admin.threshold.type.traffic.trunk']"/>' ||
					$('#search_alm_type').val() === '<spring:eval expression="@serviceProps['admin.threshold.type.traffic.trunk.group']"/>');
	}

	function isEmptyTrafficTrunkGroupNum() {
		return ($('#search_alm_type').val() === '<spring:eval expression="@serviceProps['admin.threshold.type.traffic.trunk']"/>' ||
				$('#search_alm_type').val() === '<spring:eval expression="@serviceProps['admin.threshold.type.traffic.trunk.group']"/>') && $('#N_GROUP_NUM').val() === '';
	}

	function isEmptyIvrAppId() {
		return $('#search_alm_type').val() === '<spring:eval expression="@serviceProps['admin.threshold.type.ivr.app']"/>' && $('#S_APP_ID').val() === '';
	}
</script>