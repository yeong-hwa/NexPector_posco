<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld" %>


<form id="frm_threshold" method="post">
    <table id="table_threshold" summary="" cellpadding="0" cellspacing="0">
        <caption></caption>
        <colgroup>
            <col width="15%"/>
            <col width="10%"/>
            <col width="10%"/>
            <col width="30%"/>
            <col width="15%"/>
            <col width="10%"/>
            <col width="10%"/>
        </colgroup>
        <tr>
            <td class="filed_A" rowspan="2">타입</td>
            <td class="filed_A" colspan="6">임계치 설정</td>
        </tr>
        <tr>
            <td class="filed_A">등급</td>
            <td class="filed_A">그룹</td>
            <td class="filed_A">시간</td>
            <td class="filed_A">값</td>
            <td class="filed_A">반복횟수</td>
            <td class="filed_A">사용여부</td>
        </tr>
        <tr>
            <td class="filed_A"><span id="threshold_name">임계치</span></td>
            <td class="filed_B">
                <select id="N_ALM_RATING" name="N_ALM_RATING">
										<option value="3">주의</option>
										<option value="2">경고</option>
										<option value="1">장애</option>
                </select>
            </td>
            <td class="filed_B">
                <select id="N_GROUP_NUM" name="N_GROUP_NUM">
                    <option value="">없음</option>
                </select>
            </td>
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
                <input type="text" name="N_VALUE_A" id="start_value" value="${data.N_VALUE_A}" class="int_f"
                       style="width:30px;ime-mode:disabled;" onKeyDown="onlyNumber(event);"
                       onContextMenu="return false;"/> ~
                <input type="text" name="N_VALUE_B" id="end_value" value="${data.N_VALUE_B}" class="int_f"
                       style="width:30px;ime-mode:disabled;" onKeyDown="onlyNumber(event);"
                       onContextMenu="return false;"/>
            </td>
            <td class="filed_B">
                <input type="text" name="N_THRESHOLD" id="threshold" value="${data.N_THRESHOLD}" class="int_f"
                       style="width:30px;ime-mode:disabled;" onKeyDown="onlyNumber(event);"
                       onContextMenu="return false;"/>
            </td>
            <td class="filed_B">
                <select name="N_USE">
                    <option value="0">사용</option>
                    <option value="1">사용안함</option>
                </select>
            </td>
        </tr>
    </table>
</form>

<script type="text/javascript">
    $(document).ready(function() {

        // Event 등록
        $('input[type=checkbox]').on('click', function() {
            createGroupNumberSelectBox(this.value);
        });

        if ('${param.updateFlag}' === 'U') {
            createGroupNumberSelectBox('${param.N_MON_ID}', function() {
                // 시나리오 Select Box 생성 완료 후 기존 정보 값 Setting
                $('#N_GROUP_NUM').val('${data.N_GROUP_NUM}');
                $('#N_ALM_RATING').val('${data.N_ALM_RATING}');
                $('#S_START_TIME').val('${data.S_START_TIME}');
                $('#S_END_TIME').val('${data.S_END_TIME}');
                $('#N_USE').val('${data.N_USE}');

                // Key 가 되는 값 Disabled 처리
                $('#N_GROUP_NUM').prop('disabled', true);
                $('#N_ALM_RATING').prop('disabled', true);
                $('#S_START_TIME').prop('disabled', true);
                $('#S_END_TIME').prop('disabled', true);
            });
        }
    });

    function createGroupNumberSelectBox(monId, fn){
        var param = {
            'N_MON_ID' : monId
        };

        var jqXhr = $.getJSON(cst.contextPath() + '/admin/lst_critical_value.trafficTrunkGroupNumber.htm', param);
        jqXhr.done(function(data) {
            var $groupNum = $('#N_GROUP_NUM');
            var length = $.isArray(data) ? data.length : 0;
            $groupNum.empty();

            if (length === 0) {
                $groupNum.append('<option value="">없음</option>');
                return;
            }

            for (var i = 0; i < length; i++) {
                var obj = data[i];
                $groupNum.append('<option value="' + obj.CODE + '">' + obj.VAL + '</option>');
            }

            fn && fn.apply(this, []);
        });
    }
</script>