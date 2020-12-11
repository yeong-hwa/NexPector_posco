<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<style type="text/css">
	.table_typ2-7{height: 500px;}
</style>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>알람 정보 등록</h2><span>Home &gt; 사용자 관리 &gt; 알람 정보 등록</span></div></div>
<!-- location // -->

<div style="float: left;margin-bottom: 5px;">
	<a href="#" id="btn_list" class="css_btn_class">목록</a>
</div>
<form id="register_form" method="post">
<!-- manager_contBox1 -->
<div class="manager_contBox1">
	<!-- 사용자리스트 -->
	<div class="mana_box2">
		<div class="box_a">
			<table  cellpadding="0" cellspacing="0" class="table_left_s1">
				<tr>
					<td class="bgtl1"></td>
					<td class="bgtc1"><strong>알람 사용자</strong></td>
					<td class="bgtr1"></td>
				</tr>
				<tr>
					<td class="bgml1"></td>
					<td class="bgmc1">
						<div id="user_grid" class="table_typ2-7" style="margin: 10px 0px 0px 0px;">
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
			<table  cellpadding="0" cellspacing="0" class="table_left_s2" style="width: 30%;">
				<tr>
					<td class="bgtl1"></td>
					<td class="bgtc1">
						<strong>서버 리스트</strong>
						<cmb:combo qryname="cmb_svr_type" seltagname="N_TYPE_CODE" firstdata="선택" etc="id=\"sel_server_list\" class=\"input_search\" style=\"width:120px;\""/>
					</td>
					<td class="bgtr1"></td>
				</tr>
				<tr>
					<td class="bgml1"></td>
					<td class="bgmc1">
						<div id="server_list_grid" class="table_typ2-7" style="margin: 10px 0px 0px 0px;">
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
			<table class="table_left_s1-b">
				<tr><td></td></tr>
			</table>
			<table  cellpadding="0" cellspacing="0" class="table_left_s3">
				<tr>
					<td class="bgtl1"></td>
					<td class="bgtc1"><strong>알람 정보</strong></td>
					<td class="bgtr1"></td>
				</tr>
				<tr>
					<td class="bgml1"></td>
					<td class="bgmc1" valign="top">
						<div class="table_typ2-7">
							<table summary="" cellpadding="0" cellspacing="0">
								<caption></caption>
								<colgroup>
									<col width="20%" />
									<col width="80%" />
								</colgroup>
								<tr>
									<td class="filed_A left">수신시간</td>
									<td class="filed_B left">
										<p>시간범위(시작~종료) :</p>
										<p>
											<select name="N_ST_TIME">
												<option value="0000">오전 00:00</option><option value="0030">오전 00:30</option>
												<option value="0100">오전 01:00</option><option value="0130">오전 01:30</option>
												<option value="0200">오전 02:00</option><option value="0230">오전 02:30</option>
												<option value="0300">오전 03:00</option><option value="0330">오전 03:30</option>
												<option value="0400">오전 04:00</option><option value="0430">오전 04:30</option>
												<option value="0500">오전 05:00</option><option value="0530">오전 05:30</option>
												<option value="0600">오전 06:00</option><option value="0630">오전 06:30</option>
												<option value="0700">오전 07:00</option><option value="0730">오전 07:30</option>
												<option value="0800">오전 08:00</option><option value="0830">오전 08:30</option>
												<option value="0900">오전 09:00</option><option value="0930">오전 09:30</option>
												<option value="1000">오전 10:00</option><option value="1030">오전 10:30</option>
												<option value="1100">오전 11:00</option><option value="1130">오전 11:30</option>
												<option value="1200">오후 12:00</option><option value="1230">오후 12:30</option>
												<option value="1300">오후 01:00</option><option value="1330">오후 01:30</option>
												<option value="1400">오후 02:00</option><option value="1430">오후 02:30</option>
												<option value="1500">오후 03:00</option><option value="1530">오후 03:30</option>
												<option value="1600">오후 04:00</option><option value="1630">오후 04:30</option>
												<option value="1700">오후 05:00</option><option value="1730">오후 05:30</option>
												<option value="1800">오후 06:00</option><option value="1830">오후 06:30</option>
												<option value="1900">오후 07:00</option><option value="1930">오후 07:30</option>
												<option value="2000">오후 08:00</option><option value="2030">오후 08:30</option>
												<option value="2100">오후 09:00</option><option value="2130">오후 09:30</option>
												<option value="2200">오후 10:00</option><option value="2230">오후 10:30</option>
												<option value="2300">오후 11:00</option><option value="2330">오후 11:30</option>
											</select> ~
											<select name="N_ED_TIME">
												<option value="0000">오전 00:00</option><option value="0030">오전 00:30</option>
												<option value="0100">오전 01:00</option><option value="0130">오전 01:30</option>
												<option value="0200">오전 02:00</option><option value="0230">오전 02:30</option>
												<option value="0300">오전 03:00</option><option value="0330">오전 03:30</option>
												<option value="0400">오전 04:00</option><option value="0430">오전 04:30</option>
												<option value="0500">오전 05:00</option><option value="0530">오전 05:30</option>
												<option value="0600">오전 06:00</option><option value="0630">오전 06:30</option>
												<option value="0700">오전 07:00</option><option value="0730">오전 07:30</option>
												<option value="0800">오전 08:00</option><option value="0830">오전 08:30</option>
												<option value="0900">오전 09:00</option><option value="0930">오전 09:30</option>
												<option value="1000">오전 10:00</option><option value="1030">오전 10:30</option>
												<option value="1100">오전 11:00</option><option value="1130">오전 11:30</option>
												<option value="1200">오후 12:00</option><option value="1230">오후 12:30</option>
												<option value="1300">오후 01:00</option><option value="1330">오후 01:30</option>
												<option value="1400">오후 02:00</option><option value="1430">오후 02:30</option>
												<option value="1500">오후 03:00</option><option value="1530">오후 03:30</option>
												<option value="1600">오후 04:00</option><option value="1630">오후 04:30</option>
												<option value="1700">오후 05:00</option><option value="1730">오후 05:30</option>
												<option value="1800">오후 06:00</option><option value="1830">오후 06:30</option>
												<option value="1900">오후 07:00</option><option value="1930">오후 07:30</option>
												<option value="2000">오후 08:00</option><option value="2030">오후 08:30</option>
												<option value="2100">오후 09:00</option><option value="2130">오후 09:30</option>
												<option value="2200">오후 10:00</option><option value="2230">오후 10:30</option>
												<option value="2300">오후 11:00</option><option value="2330">오후 11:30</option>
											</select>
										</p>
									</td>
								</tr>
								<tr>
									<td class="filed_A left">장애타입</td>
									<td class="filed_B left">
										<div class="table_typ2-7_s" style="height: 352px;">
											<table summary="" cellpadding="0" cellspacing="0" id="alarm_list">
											</table>
										</div>
									</td>
								</tr>
								<tr>
									<td class="filed_A left">장애수신등급</td>
									<td class="filed_B left" id="alarm_rating_area"></td>
								</tr>
								<tr>
									<td class="filed_A left">장애수신요일</td>
									<td class="filed_B left">
										<label><input type="checkbox" name="F_SEND_MONDAY" class="chbox cls_send_day" value="1"/>월요일</label>
										<label><input type="checkbox" name="F_SEND_TUESDAY" class="chbox cls_send_day" value="1"/>화요일</label>
										<label><input type="checkbox" name="F_SEND_WEDNESDAY" class="chbox cls_send_day" value="1"/>수요일</label>
										<label><input type="checkbox" name="F_SEND_THURSDAY" class="chbox cls_send_day" value="1"/>목요일</label>
										<label><input type="checkbox" name="F_SEND_FRIDAY" class="chbox cls_send_day" value="1"/>금요일</label>
										<label><input type="checkbox" name="F_SEND_SATURDAY" class="chbox cls_send_day" value="1"/>토요일</label>
										<label><input type="checkbox" name="F_SEND_SUNDAY" class="chbox cls_send_day" value="1"/>일요일</label>
										<span style="display:none;"><label><input type="checkbox" name="F_SEND_FREE_DAY" class="chbox cls_send_day" value="1">공휴일</label></span>
									</td>
								</tr>
								<tr>
									<td class="filed_A left">알림방법</td>
									<td class="filed_B left" id="alarm_send_area"></td>
								</tr>
							</table>
						</div>
						<!-- botton -->
						<div id="botton_align_center1" style="margin: 10px 0 0 0;"><a href="#" class="css_btn_class" id="btn_save">저장</a></div>
						<!-- botton // -->
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
	<!-- 사용자리스트 //-->
</div>
<!-- manager_contBox1 // -->
<!-- 내용 // -->
</form>

<form id="go_list_form" method="get">
	<input type="hidden" name="searchParam" value="${param.searchParam}"/>
</form>

<script type="text/javascript">
	$(document).ready(function() {
		initUserGrid();
		initServerGrid();

		// 사용자, 서버리스트 전체 Checkbox Change Event
		$('#user_all_check,#server_all_check').on('change', function() {
			var $obj = this.id === 'user_all_check' ? $('input[name=USER_ID]') : $('input[name=SVR_ID]');
			if (this.checked) {
				$obj.prop('checked', true);
			} else {
				$obj.prop('checked', false);
			}
		});

		$.getJSON(cst.contextPath() + '/admin/lst_almRatingCodeQry.htm')
			.done(function(data) {
				var innerHtml = '';
				for (var i = 0, length = data.length; i < length; i++) {
					var obj = data[i];
					innerHtml += ' <label for="alarm_rating_check_' + i + '"> ';
					innerHtml += ' 	<input type="checkbox" name="ALM_RATING_CODE" id="alarm_rating_check_' + i + '" class="chbox" value="' + obj.N_ALM_RATING + '" />' + obj.S_ALM_RATING_NAME;
					innerHtml += ' </label> ';
				}
				$('#alarm_rating_area').html(innerHtml);
			});

		$.getJSON(cst.contextPath() + '/admin/lst_almSendCodeQry.htm')
			.done(function(data) {
				var innerHtml = '';
				for (var i = 0, length = data.length; i < length; i++) {
					var obj = data[i];
					innerHtml += ' <label for="alarm_send_check_' + i + '"> ';
					innerHtml += ' 	<input type="checkbox" name="ALM_SEND_CODE" id="alarm_send_check_' + i + '" class="chbox" value="' + obj.N_SEND_CODE + '" />' + obj.S_SEND_NAME;
					innerHtml += ' </label> ';
				}
				$('#alarm_send_area').html(innerHtml);
			});

		initEvent();
	});

	// 이벤트 등록
	function initEvent() {

		// 목록
		$('#btn_list').on('click', goListPage);

		// 서버리스트 Select Box Change Event
		$('#sel_server_list').on('change', function() {
			$("#server_list_grid").data('kendoGrid').dataSource.read();

			var tmp_alm_type = '<spring:eval expression="@serviceProps['admin.user.alarm.type.common']"/>'.split(',');

			switch (parseInt($(this).val())) {
				case 1000 :
					tmp_alm_type.push('<spring:eval expression="@serviceProps['admin.user.alarm.type.cm']"/>');
					break;
				case 2000 :
					tmp_alm_type.push('<spring:eval expression="@serviceProps['admin.user.alarm.type.vg']"/>');
					break;
//				case 3000 :
//					tmp_alm_type.push("10001,10002");
//					break;
				case 9001 : // UPS
					tmp_alm_type.push('<spring:eval expression="@serviceProps['admin.user.alarm.type.ups']"/>');
					break;
				case 9002 : //  항온항습
					tmp_alm_type.push('<spring:eval expression="@serviceProps['admin.user.alarm.type.temperature.humidity']"/>');
					break;
				default :
					tmp_alm_type = '<spring:eval expression="@serviceProps['admin.user.alarm.type.common']"/>'.split(',')
					break;
			}

			var url 	= cst.contextPath() + '/admin/searchAlarmCode.htm',
				param 	= {'N_ALM_TYPE' : tmp_alm_type};

			// 알람 정보 리스트
			$.post(url, param)
				.done(function(data) {
					var jsonData = data.list;
					var innerHtml = '<tr><td><input type="checkbox" id="alarm_all_check"/>&nbsp;<label for="alarm_all_check">전체</label></td></tr>';
					for (var i = 0, length = jsonData.length; i < length; i++) {
						var obj = jsonData[i];
						innerHtml += ' <tr class="alarm_check"> ';
						innerHtml += ' 	<td> ';
						innerHtml += '		<input type="checkbox" id="alarm_' + i + '" name="ALM_TYPE_CODE" value="' + obj.N_ALM_TYPE + '-' + obj.N_ALM_CODE + '"/>&nbsp;';
						innerHtml += ' 		<label for="alarm_'+ i + '">' + obj.S_ALM_MSG + '</label> ';
						innerHtml += ' 	</td> ';
						innerHtml += ' </tr>';
					}
					$('#alarm_list').html(innerHtml);

					// 알람 정보 All Check Change Event
					var $alarmAllCheck = $('#alarm_all_check');
						$alarmAllCheck.on('change', function() {
						if (this.checked) {
							$('#alarm_list').find('input[type=checkbox]').prop('checked', true);
						} else {
							$('#alarm_list').find('input[type=checkbox]').prop('checked', false);
						}
					});

					// 알람 정보 리스트 Check Change Event
					var	$alarmCheck = $('.alarm_check');
					$alarmCheck.on('change', function() {
						if ($alarmCheck.length === $('.alarm_check').find('input[type=checkbox]:checked').length) {
							$alarmAllCheck.prop('checked', true);
						} else {
							$alarmAllCheck.prop('checked', false);
						}
					});
				});
		});

		// 저장 버튼 Click Event
		$('#btn_save').on('click', function(event) {
			if (event) {
				event.preventDefault ? event.preventDefault() : event.returnValue = false;
			}

			if ($('input[name=USER_ID]:checked').length === 0) {
				alert('알람 대상 사용자가 선택 되지 않았습니다.');
				return;
			}
			else if ($('input[name=SVR_ID]:checked').length === 0) {
				alert('대상 서버가 선택 되지 않았습니다.');
				return;
			}
			else if ($('input[name=ALM_TYPE_CODE]:checked').length === 0) {
				alert('장애 타입이 선택 되지 않았습니다.');
				return;
			}
			else if ($('input[name=ALM_RATING_CODE]:checked').length === 0) {
				alert('장애 수신 등급이 선택 되지 않았습니다.');
				return;
			}
			else if($('.cls_send_day:checked').length === 0) {
				alert("장애 수신 요일이 선택 되지 않았습니다.");
				return;
			}
			else if ($('input[name=ALM_SEND_CODE]:checked').length === 0) {
				alert('알림 방법이 선택 되지 않았습니다.');
				return;
			}

			var url 	= cst.contextPath() + '/admin/reg_user_alarm.htm',
				param 	= $('#register_form').serialize();
			$.post(url, param)
				.done(function(data) {
					var code = parseInt(data.RSLT);
					switch (code) {
						case 1 :
							goListPage();
							break;
						default :
							alert("등록에 실패하였습니다.");
							break;
					}
				});
		});
	}

	// 알람 사용자 그리드 초기화
	function initUserGrid() {
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/kendoPagination_user_alarm.regAlarmUserLstQry.htm",
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
					return data;
				},
				total 	: function(response) {
					var totalCount = response.length > 0 ? response[0].TOTAL_COUNT : 0;
					$('#total_count').text(totalCount);
					return totalCount;
				}
			},
//			pageSize		: 15,
			serverPaging	: false,
			serverSorting	: true
		});

		$("#user_grid")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: dataSource,
				change		: selectedGridRow,
				pageable	: {
					messages : {
						empty	: "<strong>No data</strong>",
						display : "<span>전체<strong style='color: #f35800;'>{2}</strong> 개 항목</span>"
					}
				},
				sortable	: true,
				scrollable	: true,
				resizable	: false,
				selectable	: 'multiple',
				columns		: [
					{headerTemplate: '<input type="checkbox" id="user_all_check" value="Y"/>', template: '<input type="checkbox" name="USER_ID" value="#=S_USER_ID#"/>', width:'10%', attributes:alignCenter, headerAttributes:alignCenter, sortable : false},
					{field:'S_USER_ID', title:'사용자ID', width:'45%', attributes:alignCenter, headerAttributes:alignCenter},
					{field:'S_USER_NAME', title:'사용자명', width:'45%', attributes:alignCenter, headerAttributes:alignCenter}
				]
			}));
	}

	// 서버리스트 그리드 초기화
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
							'N_TYPE_CODE' : $('#sel_server_list').val()
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
//			pageSize		: 15,
			serverPaging	: false,
			serverSorting	: true
		});

		$("#server_list_grid")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: dataSource,
				autoBind	: false,
				change		: selectedGridRow,
				pageable	: {
					messages : {
						empty	: "<strong>No data</strong>",
						display : "<span>전체<strong style='color: #f35800;'>{2}</strong> 개 항목</span>"
					}
				},
				sortable	: true,
				scrollable	: true,
				resizable	: false,
				selectable	: 'multiple',
				columns		: [
					{headerTemplate: '<input type="checkbox" id="server_all_check" value="Y"/>', template: '<input type="checkbox" name="SVR_ID" value="#=N_MON_ID#">', width:'10%', attributes:alignCenter, headerAttributes:alignCenter, sortable : false},
					{field:'N_MON_ID', title:'서버ID', width:'15%', attributes:alignCenter, headerAttributes:alignCenter},
					{field:'S_MON_NAME', title:'서버명', width:'45%', attributes:alignLeft, headerAttributes:alignCenter},
					{field:'S_MON_IP', title:'서버IP', width:'30%', attributes:alignCenter, headerAttributes:alignCenter}
				]
			}));
	}

	// 사용자, 서버 그리드 클릭시 체크박스 처리로직
	function selectedGridRow() {
		var $checkbox = this.select().find(':first').find('input[type=checkbox]');
		if ($checkbox.is(':checked')) {
			$checkbox.prop('checked', false);
		} else {
			$checkbox.prop('checked', true);
		}

		releaseAllCheckbox(this);
	}

	// 사용자, 서버 그리드 전체 체크박스 처리 로직
	function releaseAllCheckbox(grid) {
		var $allCheck, contentSelector;
		if (grid.element.wrap().attr('id') === 'user_grid') {
			$allCheck 		= $('#user_all_check');
			contentSelector = 'input[name=USER_ID]';
		}
		else {
			$allCheck 		= $('#server_all_check');
			contentSelector = 'input[name=SVR_ID]';
		}

		$(contentSelector).length === $(contentSelector + ':checked').length
				? $allCheck.prop('checked', true)
				: $allCheck.prop('checked', false);
	}

	function goListPage(event) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.user.user_alarm.retrieve.htm').submit();
	}
</script>