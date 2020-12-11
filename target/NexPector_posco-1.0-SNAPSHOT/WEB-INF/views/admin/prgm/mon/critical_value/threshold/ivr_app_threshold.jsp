<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<form id="frm_threshold" method="post">
	<table id="table_threshold" summary="" cellpadding="0" cellspacing="0">
		<caption></caption>
		<colgroup>
			<col width="15%" />
			<col width="30%" />
			<col width="20%" />
			<col width="15%" />
			<col width="20%" />
		</colgroup>
		<tr>
			<td class="filed_A" rowspan="2">타입</td>
			<td class="filed_A" colspan="4">임계치 설정</td>
		</tr>
		<tr>
			<td class="filed_A">등급</td>
			<td class="filed_A">회사</td>
			<td class="filed_A">센터</td>
			<td class="filed_A">시나리오</td>
		</tr>
		<tr>
			<td class="filed_A" rowspan="3"><span id="threshold_name">임계치</span></td>
			<td class="filed_B">
				<select id="N_ALM_RATING" name="N_ALM_RATING">
					<option value="3">주의</option>
					<option value="2">경고</option>
					<option value="1">장애</option>
				</select>
			</td>
			<td class="filed_B">
				<cmb:combo qryname="common.cmb_company" seltagname="S_COMPANY" selvalue="${data.S_COMPANY}" etc="id=\"S_COMPANY\" class=\"input_search\" style=\"width:100;\""/>
			</td>
			<td class="filed_B">
				<cmb:combo qryname="common.cmbSvrGroupIsNotNullUpCode" seltagname="N_GROUP_CODE" selvalue="${data.N_GROUP_CODE}" etc="id=\"N_GROUP_CODE\" class=\"input_search\" style=\"width:100;\""/>
			</td>
			<td class="filed_B">
				<select id="S_APP_ID" name="S_APP_ID">
					<option value="">없음</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="filed_A">시간</td>
			<td class="filed_A">값</td>
			<td class="filed_A">반복횟수</td>
			<td class="filed_A">사용여부</td>
		</tr>
		<tr>
			<td class="filed_B">
				<select id="S_START_TIME" name="S_START_TIME">
					<option value="00:00">오전 00:00</option><option value="00:30">오전 00:30</option>
					<option value="01:00">오전 01:00</option><option value="01:30">오전 01:30</option>
					<option value="02:00">오전 02:00</option><option value="02:30">오전 02:30</option>
					<option value="03:00">오전 03:00</option><option value="03:30">오전 03:30</option>
					<option value="04:00">오전 04:00</option><option value="04:30">오전 04:30</option>
					<option value="05:00">오전 05:00</option><option value="05:30">오전 05:30</option>
					<option value="06:00">오전 06:00</option><option value="06:30">오전 06:30</option>
					<option value="07:00">오전 07:00</option><option value="07:30">오전 07:30</option>
					<option value="08:00">오전 08:00</option><option value="08:30">오전 08:30</option>
					<option value="09:00">오전 09:00</option><option value="09:30">오전 09:30</option>
					<option value="10:00">오전 10:00</option><option value="10:30">오전 10:30</option>
					<option value="11:00">오전 11:00</option><option value="11:30">오전 11:30</option>
					<option value="12:00">오후 12:00</option><option value="12:30">오후 12:30</option>
					<option value="13:00">오후 01:00</option><option value="13:30">오후 01:30</option>
					<option value="14:00">오후 02:00</option><option value="14:30">오후 02:30</option>
					<option value="15:00">오후 03:00</option><option value="15:30">오후 03:30</option>
					<option value="16:00">오후 04:00</option><option value="16:30">오후 04:30</option>
					<option value="17:00">오후 05:00</option><option value="17:30">오후 05:30</option>
					<option value="18:00">오후 06:00</option><option value="18:30">오후 06:30</option>
					<option value="19:00">오후 07:00</option><option value="19:30">오후 07:30</option>
					<option value="20:00">오후 08:00</option><option value="20:30">오후 08:30</option>
					<option value="21:00">오후 09:00</option><option value="21:30">오후 09:30</option>
					<option value="22:00">오후 10:00</option><option value="22:30">오후 10:30</option>
					<option value="23:00">오후 11:00</option><option value="23:30">오후 11:30</option>
				</select> ~
				<select id="S_END_TIME" name="S_END_TIME">
					<option value="24:00">오전 00:00</option><option value="00:30">오전 00:30</option>
					<option value="01:00">오전 01:00</option><option value="01:30">오전 01:30</option>
					<option value="02:00">오전 02:00</option><option value="02:30">오전 02:30</option>
					<option value="03:00">오전 03:00</option><option value="03:30">오전 03:30</option>
					<option value="04:00">오전 04:00</option><option value="04:30">오전 04:30</option>
					<option value="05:00">오전 05:00</option><option value="05:30">오전 05:30</option>
					<option value="06:00">오전 06:00</option><option value="06:30">오전 06:30</option>
					<option value="07:00">오전 07:00</option><option value="07:30">오전 07:30</option>
					<option value="08:00">오전 08:00</option><option value="08:30">오전 08:30</option>
					<option value="09:00">오전 09:00</option><option value="09:30">오전 09:30</option>
					<option value="10:00">오전 10:00</option><option value="10:30">오전 10:30</option>
					<option value="11:00">오전 11:00</option><option value="11:30">오전 11:30</option>
					<option value="12:00">오후 12:00</option><option value="12:30">오후 12:30</option>
					<option value="13:00">오후 01:00</option><option value="13:30">오후 01:30</option>
					<option value="14:00">오후 02:00</option><option value="14:30">오후 02:30</option>
					<option value="15:00">오후 03:00</option><option value="15:30">오후 03:30</option>
					<option value="16:00">오후 04:00</option><option value="16:30">오후 04:30</option>
					<option value="17:00">오후 05:00</option><option value="17:30">오후 05:30</option>
					<option value="18:00">오후 06:00</option><option value="18:30">오후 06:30</option>
					<option value="19:00">오후 07:00</option><option value="19:30">오후 07:30</option>
					<option value="20:00">오후 08:00</option><option value="20:30">오후 08:30</option>
					<option value="21:00">오후 09:00</option><option value="21:30">오후 09:30</option>
					<option value="22:00">오후 10:00</option><option value="22:30">오후 10:30</option>
					<option value="23:00">오후 11:00</option><option value="23:30">오후 11:30</option>
					<option value="24:00">오후 12:00</option>
				</select>
			</td>
			<td class="filed_B">
				<input type="text" name="N_VALUE_A" id="start_value" value="${data.N_VALUE_A}" class="int_f" style="width:30px;ime-mode:disabled;" onKeyDown="onlyNumber(event);" onContextMenu="return false;"/> ~
				<input type="text" name="N_VALUE_B" id="end_value" value="${data.N_VALUE_B}" class="int_f" style="width:30px;ime-mode:disabled;" onKeyDown="onlyNumber(event);" onContextMenu="return false;"/>
			</td>
			<td class="filed_B">
				<input type="text" name="N_THRESHOLD" id="threshold" value="${data.N_THRESHOLD}" class="int_f" style="width:30px;ime-mode:disabled;"
					   onKeyDown="onlyNumber(event);" onContextMenu="return false;"/>
			</td>
			<td class="filed_B">
				<select id="N_USE" name="N_USE">
					<option value="0">사용</option>
					<option value="1">사용안함</option>
				</select>
			</td>
		</tr>
	</table>
</form>

<script type="text/javascript">
	$(document).ready(function() {

		if ($('select[name=S_COMPANY] option:selected').val() !== '' &&
				$('select[name=N_GROUP_CODE] option:selected').val() !== '') {
			appendIvrAppSelectBox();
		}

		$('select[name=N_GROUP_CODE]').on('change', function(event) {
			appendIvrAppSelectBox();
		});
	});

	function appendIvrAppSelectBox() {
		var url 	= '<c:url value="lst_common.cmb_app.htm"/>',
			params  = {
				'S_COMPANY' 	: $('select[name=S_COMPANY] option:selected').val(),
				'N_GROUP_CODE'	: $('select[name=N_GROUP_CODE] option:selected').val()
			};

		var xhr = $.getJSON(url, params);
		xhr.done(function(data) {
			var $ivrApp = $('select[name=S_APP_ID]');

			$ivrApp.empty();
			$ivrApp.append('<option value="">선택</option>');
			for (var i = 0, length = data.length; i < length; i++) {
				var obj = data[i];
				$ivrApp.append('<option value="' + obj.CODE + '">' + obj.VAL + '</option>');
			}

			if ('${param.updateFlag}' === 'U') {
				// 시나리오 Select Box 생성 완료 후 기존 정보 값 Setting
				$('#N_ALM_RATING').val('${data.N_ALM_RATING}');
				$('#S_APP_ID').val('${data.S_APP_ID}');
				$('#S_START_TIME').val('${data.S_START_TIME}');
				$('#S_END_TIME').val('${data.S_END_TIME}');
				$('#N_USE').val('${data.N_USE}');

				// Key 가 되는 값 Disabled 처리
				$('#N_ALM_RATING').prop('disabled', true);
				$('#S_COMPANY').prop('disabled', true);
				$('#N_GROUP_CODE').prop('disabled', true);
				$('#S_APP_ID').prop('disabled', true);
				$('#S_START_TIME').prop('disabled', true);
				$('#S_END_TIME').prop('disabled', true);
			}
		});
	}
</script>