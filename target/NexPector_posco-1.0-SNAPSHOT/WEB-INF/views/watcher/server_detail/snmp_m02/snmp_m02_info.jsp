<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<script type="text/javascript">

    var pMonId = '${param.N_MON_ID}';

    $(function() {
        fn_getSnmpM02Info();
    });

    function fn_getSnmpM02Info() {
        var url     = '/watcher/map_SnmpM02InfoQry.htm',
                param   = { 'N_MON_ID' : pMonId };

        $.getJSON(url, param)
                .done(function(data) {
                    $('#model_name').text(data.S_MODEL);
                    $('#server_name').text(data.S_NAME);
                    $('#version').text(data.S_VERSION);
                    $('#start_time').text(data.D_ST_TIME);
                    $('#phone_type').text('전화기');
                    $('#phone_registration_number').text(data.N_PHONE_REG);
                    $('#gateway_type').text('Gateway');
                    $('#gateway_registration_number').text(data.N_GW_REG);
                    $('#h323_type').text('H323');
                    $('#h323_registration_number').text(data.N_H323_REG);
                    $('#sip_type').text('SIP');
                    $('#sip_registration_number').text(data.N_SIP_REG);
                });
    }
</script>

<!-- stitle -->
<div class="avaya_stitle1">
    <div class="st_under"><h4>장비 정보</h4><span></span></div>
</div>
<!-- stitle // -->
<!-- table_typ2-1 -->
<div class="table_typ2-1">
    <table summary="" cellpadding="0" cellspacing="0">
        <caption></caption>
        <colgroup>
            <col width="15%" />
            <col width="35%" />
            <col width="15%" />
            <col width="35%" />
        </colgroup>
        <tr>
            <td class="filed_A">모델명</td>
            <td class="filed_B" id="model_name"></td>
            <td class="filed_A">장비명</td>
            <td class="filed_B" id="server_name"></td>
        </tr>
        <tr>
            <td class="filed_A">버전</td>
            <td class="filed_B" id="version"></td>
            <td class="filed_A">시작시간</td>
            <td class="filed_B" id="start_time"></td>
        </tr>
    </table>
    <!-- table_typ2-1 // -->
    <!-- stitle -->
    <div class="avaya_stitle1">
        <div class="st_under"><h4>서비스 정보</h4><span></span></div>
    </div>
    <!-- stitle // -->
    <!-- table_typ2-4 -->
    <div class="table_typ2-4">
        <table summary="" cellpadding="0" cellspacing="0" style="width:100%;">
            <caption></caption>
            <colgroup>
                <col width="50%" />
                <col width="50%" />
            </colgroup>
            <tr>
                <td class="filed_A">타입</td>
                <td class="filed_A">등록 수량</td>
            </tr>
            <tr>
                <td class="filed_B" id="phone_type"></td>
                <td class="filed_B" id="phone_registration_number"></td>
            </tr>
            <tr>
                <td class="filed_B" id="gateway_type"></td>
                <td class="filed_B" id="gateway_registration_number"></td>
            </tr>
            <tr>
                <td class="filed_B" id="h323_type"></td>
                <td class="filed_B" id="h323_registration_number"></td>
            </tr>
            <tr>
                <td class="filed_B" id="sip_type"></td>
                <td class="filed_B" id="sip_registration_number"></td>
            </tr>
        </table>
    </div>
</div>