<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<script type="text/javascript">

    var pMonId = '${param.N_MON_ID}';

    $(function() {
        fn_getSnmpM03Vg3945Info();
    });

    function fn_getSnmpM03Vg3945Info() {
        var url     = '/watcher/map_SnmpM03InfoQry.htm',
                param   = { 'N_MON_ID' : pMonId };

        $.getJSON(url, param)
                .done(function(data) {
                    $('#model_name').text(data.S_MODEL);
                    $('#server_name').text(data.S_NAME);
                    $('#vg3945_network_interface').text(data.IF_CNT);
                    $('#vg3945_dsp').text(data.DSP_CNT);
                    $('#vg3945_pri').text(data.PRI_CNT);
                    $('#vg3945_voltage').text(data.ENV_VOLT_CNT);
                    $('#vg3945_temperature').text(data.ENV_TEMP_CNT);
                    $('#vg3945_fan').text(data.ENV_FAN_CNT);
                    $('#vg3945_power').text(data.ENV_POWER_CNT);
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
            <td class="filed_A">장비명</td>
            <td class="filed_B" id="server_name"></td>
        </tr>
        <tr>
            <td class="filed_A">모델명</td>
            <td class="filed_B" id="model_name"></td>
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
                <col width="70%" />
                <col width="30%" />
            </colgroup>
            <tr>
                <td class="filed_A">서비스명</td>
                <td class="filed_A">운용정보(개수)</td>
            </tr>
            <tr>
                <td class="filed_B" >Network Interface</td>
                <td class="filed_B" id="vg3945_network_interface"></td>
            </tr>
            <tr>
                <td class="filed_B" >DSP</td>
                <td class="filed_B" id="vg3945_dsp"></td>
            </tr>
            <tr>
                <td class="filed_B" >PRI 회선</td>
                <td class="filed_B" id="vg3945_pri"></td>
            </tr>
        </table>
    </div>

    <!-- stitle -->
    <div class="avaya_stitle1">
        <div class="st_under"><h4>장비 동작 정보</h4><span></span></div>
    </div>
    <!-- stitle // -->
    <!-- table_typ2-4 -->
    <div class="table_typ2-4">
        <table summary="" cellpadding="0" cellspacing="0" style="width:100%;">
            <caption></caption>
            <colgroup>
                <col width="70%" />
                <col width="30%" />
            </colgroup>
            <tr>
                <td class="filed_A">타입</td>
                <td class="filed_A">운용정보(개수)</td>
            </tr>
            <tr>
                <td class="filed_B" >Voltage(전압)</td>
                <td class="filed_B" id="vg3945_voltage"></td>
            </tr>
            <tr>
                <td class="filed_B" >Temperature(온도)</td>
                <td class="filed_B" id="vg3945_temperature"></td>
            </tr>
            <tr>
                <td class="filed_B" >Fan(팬)</td>
                <td class="filed_B" id="vg3945_fan"></td>
            </tr>
            <tr>
                <td class="filed_B" >Power(전원)</td>
                <td class="filed_B" id="vg3945_power"></td>
            </tr>
        </table>
    </div>
</div>