<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>알람 정보 수정</h2><span>Home &gt; 사용자 관리 &gt; 알람 정보 수정</span></div></div>
<!-- location // -->

<!-- 내용 -->
<div style="float: left;margin-bottom: 5px;">
	<a href="#" id="btn_list" class="css_btn_class">목록</a>
</div>

<form id="submit_form">
<input type="hidden" name="N_ALM_TYPE" id="hid_alm_type" value="${data.N_ALM_TYPE}"/>
<input type="hidden" name="N_ALM_CODE" id="hid_alm_code" value="${data.N_ALM_CODE}"/>
<input type="hidden" name="S_USER_ID" id="hid_user_id" value="${data.S_USER_ID}"/>
<input type="hidden" name="N_MON_ID" id="hid_mon_id" value="${data.N_MON_ID}"/>
<!-- manager_contBox1 -->
<div class="manager_contBox1">
	<!-- 사용자등록 -->
	<div class="table_typ2-6">
		<table summary="" cellpadding="0" cellspacing="0">
			<caption></caption>
			<colgroup>
				<col width="15%" />
				<col width="35%" />
				<col width="15%" />
				<col width="35%" />
			</colgroup>
			<tr>
				<td class="filed_A left">사용자</td>
				<td class="filed_B left"><span id="user_info">${data.S_USER_ID}[${data.S_USER_NAME}]</span></td>
				<td class="filed_A left">장비명</td>
				<td class="filed_B left"><span id="mon_inf">${data.N_MON_ID}&nbsp;[${data.S_MON_NAME}]</span></td>
			</tr>
			<tr>
				<td class="filed_A left">장애타입</td>
				<td class="filed_B left"><span id="alm_msg">${data.S_ALM_MSG}</span></td>
				<td class="filed_A left">수신시각</td>
				<td class="filed_B left">
					시간 범위(시작 ~ 종료) :
					<select name="N_ST_TIME" id="sel_start_time">
						<option value="0" <c:if test="${data.N_ST_TIME == '0'}">selected</c:if>>오전 00:00</option><option value="30" <c:if test="${data.N_ST_TIME == '30'}">selected</c:if>>오전 00:30</option>
						<option value="100" <c:if test="${data.N_ST_TIME == '100'}">selected</c:if>>오전 01:00</option><option value="130" <c:if test="${data.N_ST_TIME == '130'}">selected</c:if>>오전 01:30</option>
						<option value="200" <c:if test="${data.N_ST_TIME == '200'}">selected</c:if>>오전 02:00</option><option value="230" <c:if test="${data.N_ST_TIME == '230'}">selected</c:if>>오전 02:30</option>
						<option value="300" <c:if test="${data.N_ST_TIME == '300'}">selected</c:if>>오전 03:00</option><option value="330" <c:if test="${data.N_ST_TIME == '330'}">selected</c:if>>오전 03:30</option>
						<option value="400" <c:if test="${data.N_ST_TIME == '400'}">selected</c:if>>오전 04:00</option><option value="430" <c:if test="${data.N_ST_TIME == '430'}">selected</c:if>>오전 04:30</option>
						<option value="500" <c:if test="${data.N_ST_TIME == '500'}">selected</c:if>>오전 05:00</option><option value="530" <c:if test="${data.N_ST_TIME == '530'}">selected</c:if>>오전 05:30</option>
						<option value="600" <c:if test="${data.N_ST_TIME == '600'}">selected</c:if>>오전 06:00</option><option value="630" <c:if test="${data.N_ST_TIME == '630'}">selected</c:if>>오전 06:30</option>
						<option value="700" <c:if test="${data.N_ST_TIME == '700'}">selected</c:if>>오전 07:00</option><option value="730" <c:if test="${data.N_ST_TIME == '730'}">selected</c:if>>오전 07:30</option>
						<option value="800" <c:if test="${data.N_ST_TIME == '800'}">selected</c:if>>오전 08:00</option><option value="830" <c:if test="${data.N_ST_TIME == '830'}">selected</c:if>>오전 08:30</option>
						<option value="900" <c:if test="${data.N_ST_TIME == '900'}">selected</c:if>>오전 09:00</option><option value="930" <c:if test="${data.N_ST_TIME == '930'}">selected</c:if>>오전 09:30</option>
						<option value="1000" <c:if test="${data.N_ST_TIME == '1000'}">selected</c:if>>오전 10:00</option><option value="1030" <c:if test="${data.N_ST_TIME == '1030'}">selected</c:if>>오전 10:30</option>
						<option value="1100" <c:if test="${data.N_ST_TIME == '1100'}">selected</c:if>>오전 11:00</option><option value="1130" <c:if test="${data.N_ST_TIME == '1130'}">selected</c:if>>오전 11:30</option>
						<option value="1200" <c:if test="${data.N_ST_TIME == '1200'}">selected</c:if>>오후 12:00</option><option value="1230" <c:if test="${data.N_ST_TIME == '1230'}">selected</c:if>>오후 12:30</option>
						<option value="1300" <c:if test="${data.N_ST_TIME == '1300'}">selected</c:if>>오후 01:00</option><option value="1330" <c:if test="${data.N_ST_TIME == '1330'}">selected</c:if>>오후 01:30</option>
						<option value="1400" <c:if test="${data.N_ST_TIME == '1400'}">selected</c:if>>오후 02:00</option><option value="1430" <c:if test="${data.N_ST_TIME == '1430'}">selected</c:if>>오후 02:30</option>
						<option value="1500" <c:if test="${data.N_ST_TIME == '1500'}">selected</c:if>>오후 03:00</option><option value="1530" <c:if test="${data.N_ST_TIME == '1530'}">selected</c:if>>오후 03:30</option>
						<option value="1600" <c:if test="${data.N_ST_TIME == '1600'}">selected</c:if>>오후 04:00</option><option value="1630" <c:if test="${data.N_ST_TIME == '1630'}">selected</c:if>>오후 04:30</option>
						<option value="1700" <c:if test="${data.N_ST_TIME == '1700'}">selected</c:if>>오후 05:00</option><option value="1730" <c:if test="${data.N_ST_TIME == '1730'}">selected</c:if>>오후 05:30</option>
						<option value="1800" <c:if test="${data.N_ST_TIME == '1800'}">selected</c:if>>오후 06:00</option><option value="1830" <c:if test="${data.N_ST_TIME == '1830'}">selected</c:if>>오후 06:30</option>
						<option value="1900" <c:if test="${data.N_ST_TIME == '1900'}">selected</c:if>>오후 07:00</option><option value="1930" <c:if test="${data.N_ST_TIME == '1930'}">selected</c:if>>오후 07:30</option>
						<option value="2000" <c:if test="${data.N_ST_TIME == '2000'}">selected</c:if>>오후 08:00</option><option value="2030" <c:if test="${data.N_ST_TIME == '2030'}">selected</c:if>>오후 08:30</option>
						<option value="2100" <c:if test="${data.N_ST_TIME == '2100'}">selected</c:if>>오후 09:00</option><option value="2130" <c:if test="${data.N_ST_TIME == '2130'}">selected</c:if>>오후 09:30</option>
						<option value="2200" <c:if test="${data.N_ST_TIME == '2200'}">selected</c:if>>오후 10:00</option><option value="2230" <c:if test="${data.N_ST_TIME == '2230'}">selected</c:if>>오후 10:30</option>
						<option value="2300" <c:if test="${data.N_ST_TIME == '2300'}">selected</c:if>>오후 11:00</option><option value="2330" <c:if test="${data.N_ST_TIME == '2330'}">selected</c:if>>오후 11:30</option>
					</select>
					&nbsp;~&nbsp;
					<select name="N_ED_TIME" id="sel_end_time">
						<option value="0" <c:if test="${data.N_ED_TIME == '0'}">selected</c:if>>오전 00:00</option><option value="30" <c:if test="${data.N_ED_TIME == '30'}">selected</c:if>>오전 00:30</option>
						<option value="100" <c:if test="${data.N_ED_TIME == '100'}">selected</c:if>>오전 01:00</option><option value="130" <c:if test="${data.N_ED_TIME == '130'}">selected</c:if>>오전 01:30</option>
						<option value="200" <c:if test="${data.N_ED_TIME == '200'}">selected</c:if>>오전 02:00</option><option value="230" <c:if test="${data.N_ED_TIME == '230'}">selected</c:if>>오전 02:30</option>
						<option value="300" <c:if test="${data.N_ED_TIME == '300'}">selected</c:if>>오전 03:00</option><option value="330" <c:if test="${data.N_ED_TIME == '330'}">selected</c:if>>오전 03:30</option>
						<option value="400" <c:if test="${data.N_ED_TIME == '400'}">selected</c:if>>오전 04:00</option><option value="430" <c:if test="${data.N_ED_TIME == '430'}">selected</c:if>>오전 04:30</option>
						<option value="500" <c:if test="${data.N_ED_TIME == '500'}">selected</c:if>>오전 05:00</option><option value="530" <c:if test="${data.N_ED_TIME == '530'}">selected</c:if>>오전 05:30</option>
						<option value="600" <c:if test="${data.N_ED_TIME == '600'}">selected</c:if>>오전 06:00</option><option value="630" <c:if test="${data.N_ED_TIME == '630'}">selected</c:if>>오전 06:30</option>
						<option value="700" <c:if test="${data.N_ED_TIME == '700'}">selected</c:if>>오전 07:00</option><option value="730" <c:if test="${data.N_ED_TIME == '730'}">selected</c:if>>오전 07:30</option>
						<option value="800" <c:if test="${data.N_ED_TIME == '800'}">selected</c:if>>오전 08:00</option><option value="830" <c:if test="${data.N_ED_TIME == '830'}">selected</c:if>>오전 08:30</option>
						<option value="900" <c:if test="${data.N_ED_TIME == '900'}">selected</c:if>>오전 09:00</option><option value="930" <c:if test="${data.N_ED_TIME == '930'}">selected</c:if>>오전 09:30</option>
						<option value="1000" <c:if test="${data.N_ED_TIME == '1000'}">selected</c:if>>오전 10:00</option><option value="1030" <c:if test="${data.N_ED_TIME == '1030'}">selected</c:if>>오전 10:30</option>
						<option value="1100" <c:if test="${data.N_ED_TIME == '1100'}">selected</c:if>>오전 11:00</option><option value="1130" <c:if test="${data.N_ED_TIME == '1130'}">selected</c:if>>오전 11:30</option>
						<option value="1200" <c:if test="${data.N_ED_TIME == '1200'}">selected</c:if>>오후 12:00</option><option value="1230" <c:if test="${data.N_ED_TIME == '1230'}">selected</c:if>>오후 12:30</option>
						<option value="1300" <c:if test="${data.N_ED_TIME == '1300'}">selected</c:if>>오후 01:00</option><option value="1330" <c:if test="${data.N_ED_TIME == '1330'}">selected</c:if>>오후 01:30</option>
						<option value="1400" <c:if test="${data.N_ED_TIME == '1400'}">selected</c:if>>오후 02:00</option><option value="1430" <c:if test="${data.N_ED_TIME == '1430'}">selected</c:if>>오후 02:30</option>
						<option value="1500" <c:if test="${data.N_ED_TIME == '1500'}">selected</c:if>>오후 03:00</option><option value="1530" <c:if test="${data.N_ED_TIME == '1530'}">selected</c:if>>오후 03:30</option>
						<option value="1600" <c:if test="${data.N_ED_TIME == '1600'}">selected</c:if>>오후 04:00</option><option value="1630" <c:if test="${data.N_ED_TIME == '1630'}">selected</c:if>>오후 04:30</option>
						<option value="1700" <c:if test="${data.N_ED_TIME == '1700'}">selected</c:if>>오후 05:00</option><option value="1730" <c:if test="${data.N_ED_TIME == '1730'}">selected</c:if>>오후 05:30</option>
						<option value="1800" <c:if test="${data.N_ED_TIME == '1800'}">selected</c:if>>오후 06:00</option><option value="1830" <c:if test="${data.N_ED_TIME == '1830'}">selected</c:if>>오후 06:30</option>
						<option value="1900" <c:if test="${data.N_ED_TIME == '1900'}">selected</c:if>>오후 07:00</option><option value="1930" <c:if test="${data.N_ED_TIME == '1930'}">selected</c:if>>오후 07:30</option>
						<option value="2000" <c:if test="${data.N_ED_TIME == '2000'}">selected</c:if>>오후 08:00</option><option value="2030" <c:if test="${data.N_ED_TIME == '2030'}">selected</c:if>>오후 08:30</option>
						<option value="2100" <c:if test="${data.N_ED_TIME == '2100'}">selected</c:if>>오후 09:00</option><option value="2130" <c:if test="${data.N_ED_TIME == '2130'}">selected</c:if>>오후 09:30</option>
						<option value="2200" <c:if test="${data.N_ED_TIME == '2200'}">selected</c:if>>오후 10:00</option><option value="2230" <c:if test="${data.N_ED_TIME == '2230'}">selected</c:if>>오후 10:30</option>
						<option value="2300" <c:if test="${data.N_ED_TIME == '2300'}">selected</c:if>>오후 11:00</option><option value="2330" <c:if test="${data.N_ED_TIME == '2330'}">selected</c:if>>오후 11:30</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="filed_A left">장애수신등급</td>
				<td class="filed_B left"><cmb:combo qryname="cmb_alm_rating" seltagname="N_ALM_RATING" selvalue="${data.N_ALM_RATING}" etc="id=\"sel_alm_rating\" class=\"input_search\" style=\"width:80;\""/></td>
				<td class="filed_A left">알람방법</td>
				<td class="filed_B left">
					<input type="checkbox" id="chk_send_code" value="${data.N_SEND_CODE}" disabled <c:if test="${data.N_SEND_CODE == '1'}">checked</c:if>><label for="chk_send_code">SMS전송</label>
					<input type="hidden" name="N_SEND_CODE" id="hid_send_code" value="${data.N_SEND_CODE}"/>
				</td>

			</tr>
			<tr>
				<td class="filed_A left">장애수신요일</td>
				<td id="day_check" class="filed_B left" colspan="3">
					<input type="checkbox" name="F_SEND_MONDAY" id="chk_send_mon" class="chbox" <c:if test="${data.F_SEND_MONDAY == '1'}">checked</c:if>/><label for="chk_send_mon">월요일</label>
					<input type="checkbox" name="F_SEND_TUESDAY" id="chk_send_tue" class="chbox" <c:if test="${data.F_SEND_TUESDAY == '1'}">checked</c:if>/><label for="chk_send_tue">화요일</label>
					<input type="checkbox" name="F_SEND_WEDNESDAY" id="chk_send_wed" class="chbox" <c:if test="${data.F_SEND_WEDNESDAY == '1'}">checked</c:if>/><label for="chk_send_wed">수요일</label>
					<input type="checkbox" name="F_SEND_THURSDAY" id="chk_send_thu" class="chbox" <c:if test="${data.F_SEND_THURSDAY == '1'}">checked</c:if>/><label for="chk_send_thu">목요일</label>
					<input type="checkbox" name="F_SEND_FRIDAY" id="chk_send_fri" class="chbox" <c:if test="${data.F_SEND_FRIDAY == '1'}">checked</c:if>/><label for="chk_send_fri">금요일</label>
					<input type="checkbox" name="F_SEND_SATURDAY" id="chk_send_sat" class="chbox" <c:if test="${data.F_SEND_SATURDAY == '1'}">checked</c:if>/><label for="chk_send_sat">토요일</label>
					<input type="checkbox" name="F_SEND_SUNDAY" id="chk_send_sun" class="chbox" <c:if test="${data.F_SEND_SUNDAY == '1'}">checked</c:if>/><label for="chk_send_sun">일요일</label>
				</td>
			</tr>
		</table>
		<!-- botton -->
		<div id="botton_align_center1">
			<a href="#" id="btn_save" class="css_btn_class">저장</a>&nbsp;&nbsp;&nbsp;
			<a href="#" id="btn_cancel" class="css_btn_class">취소</a>&nbsp;&nbsp;&nbsp;
			<a href="#" id="btn_remove" class="css_btn_class3">삭제</a>
		</div>
		<!-- botton // -->
	</div>
	<!-- 사용자등록 //-->
</div>
<!-- manager_contBox1 // -->
<!-- 내용 // -->
</form>

<form id="go_list_form" method="get">
	<input type="hidden" name="searchParam" value="${param.searchParam}"/>
</form>

<script type="text/javascript">
	$(document).ready(function() {
		initEvent();
	});

	function initEvent() {
		$('#btn_list').on('click', goListPage);

		$('#btn_cancel').on('click', function(event) {
			event.preventDefault();
			if ( confirm("작성된 데이터를 초기화 하시겠습니까?") ) {
				var data = getOriginalData();
				$('#sel_start_time').val(data.OLD_N_ST_TIME);
				$('#sel_end_time').val(data.OLD_N_ED_TIME);
				$('#sel_alm_rating').val(data.OLD_N_ALM_RATING);
				parseInt(data.OLD_F_SEND_MONDAY) === 1 ? $('#chk_send_mon').prop('checked', true) : $('#chk_send_mon').prop('checked', false);
				parseInt(data.OLD_F_SEND_TUESDAY) === 1 ? $('#chk_send_tue').prop('checked', true) : $('#chk_send_tue').prop('checked', false);
				parseInt(data.OLD_F_SEND_WEDNESDAY) === 1 ? $('#chk_send_wed').prop('checked', true) : $('#chk_send_wed').prop('checked', false);
				parseInt(data.OLD_F_SEND_THURSDAY) === 1 ? $('#chk_send_thu').prop('checked', true) : $('#chk_send_thu').prop('checked', false);
				parseInt(data.OLD_F_SEND_FRIDAY) === 1 ? $('#chk_send_fri').prop('checked', true) : $('#chk_send_fri').prop('checked', false);
				parseInt(data.OLD_F_SEND_SATURDAY) === 1 ? $('#chk_send_sat').prop('checked', true) : $('#chk_send_sat').prop('checked', false);
				parseInt(data.OLD_F_SEND_SUNDAY) === 1 ? $('#chk_send_sun').prop('checked', true) : $('#chk_send_sun').prop('checked', false);
			}
		});

		$('#btn_save').on('click', save);

		$('#btn_remove').on('click', function(event) {
			event.preventDefault();
			if ( confirm("정말 삭제 하시겠습니까?") ) {
				var url 	= cst.contextPath() + '/admin/remove_user_alarm.htm',
					param 	= $.extend({}, serializeParamObject(), getOriginalData());
				$.post(url, param, function (str) {
					var data = $.parseJSON(str);
					if (parseInt(data.RSLT) > 0) {
						alert("삭제되었습니다.");
						goListPage();
					}
					else {
						alert("삭제에 실패 하였습니다.");
					}
				});
			}
		});
	}

	function goListPage(event) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.user.user_alarm.retrieve.htm').submit();
	}

	function save(event) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}
		if (!isValidate()) {
			return;
		}

		var xhr = checkDuplication();
		xhr.done(function(str){
			var data = $.parseJSON(str);
			if(parseInt(data.CNT) == 0) {
				var url 	= cst.contextPath() + '/admin/update_user_alarm.htm',
					param	= $.extend({}, serializeParamObject(), getOriginalData());
				$.post(url, param)
					.done(function(str2){
						var data2 = $.parseJSON(str2);
						if(parseInt(data2.RSLT) > 0) {
							alert("수정되었습니다.");
							goListPage();
						}
						else {
							alert("수정에 실패 하였습니다.");
						}
					});
			}
			else {
				alert("중복된 데이터 입니다.");
				return;
			}
		});
	}

	function checkDuplication() {
		return $.post(cst.contextPath() + '/admin/map_user_alarm.alm_send_info_check.htm', serializeParamObject());
	}

	function isValidate() {
		var flag = false;
		$.each(getOriginalData(), function(key, value) {
			var modify = serializeParamObject();
			if (value != modify['OLD_' + key]) {
				flag = true;
				return false; // jQuery each 문 break;
			}
		});

		if (!flag) {
			alert('수정된 내용이 없습니다.');
			return false;
		}

		if ($('#day_check').find('input[type=checkbox]:checked').length === 0) {
			alert('장애수신 요일을 선택해주세요.');
			return false;
		}

		return true;
	}

	function serializeParamObject() {
		return {
			'S_USER_ID' 		: $('#hid_user_id').val(),
			'N_MON_ID'			: $('#hid_mon_id').val(),
			'N_ALM_TYPE'		: $('#hid_alm_type').val(),
			'N_ALM_CODE'		: $('#hid_alm_code').val(),
			'N_SEND_CODE'		: $('#hid_send_code').val(),
			'N_ST_TIME'			: $('#sel_start_time').val(),
			'N_ED_TIME'			: $('#sel_end_time').val(),
			'N_ALM_RATING'		: $('#sel_alm_rating').val(),
			'F_SEND_MONDAY'		: getCheckboxValue($('#chk_send_mon')),
			'F_SEND_TUESDAY'	: getCheckboxValue($('#chk_send_tue')),
			'F_SEND_WEDNESDAY'	: getCheckboxValue($('#chk_send_wed')),
			'F_SEND_THURSDAY'	: getCheckboxValue($('#chk_send_thu')),
			'F_SEND_FRIDAY'		: getCheckboxValue($('#chk_send_fri')),
			'F_SEND_SATURDAY'	: getCheckboxValue($('#chk_send_sat')),
			'F_SEND_SUNDAY'		: getCheckboxValue($('#chk_send_sun'))
		};
	}

	function getCheckboxValue($obj) {
		return $obj.is(':checked') ? 1 : 0;
	}

	function getOriginalData() {
		return {
			'OLD_N_ST_TIME'			: '${data.N_ST_TIME}',
			'OLD_N_ED_TIME'			: '${data.N_ED_TIME}',
			'OLD_N_ALM_RATING'		: '${data.N_ALM_RATING}',
			'OLD_F_SEND_MONDAY'		: '${data.F_SEND_MONDAY}',
			'OLD_F_SEND_TUESDAY'	: '${data.F_SEND_TUESDAY}',
			'OLD_F_SEND_WEDNESDAY'	: '${data.F_SEND_WEDNESDAY}',
			'OLD_F_SEND_THURSDAY'	: '${data.F_SEND_THURSDAY}',
			'OLD_F_SEND_FRIDAY'		: '${data.F_SEND_FRIDAY}',
			'OLD_F_SEND_SATURDAY'	: '${data.F_SEND_SATURDAY}',
			'OLD_F_SEND_SUNDAY'		: '${data.F_SEND_SUNDAY}',
			'OLD_N_SEND_CODE'		: '${data.N_SEND_CODE}'
		};
	}
</script>