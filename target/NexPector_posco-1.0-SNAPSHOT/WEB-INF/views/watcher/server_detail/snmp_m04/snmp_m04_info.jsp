<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<script type="text/javascript">

    var pMonId = '${param.N_MON_ID}';

    $(function() {
        fn_getSnmpM04Info();
    });

    function fn_getSnmpM04Info() {
        var url     = '/watcher/map_SnmpM04InfoQry.htm',
            param   = { 'N_MON_ID' : pMonId };

        $.getJSON(url, param)
            .done(function(data) {
                $('#server_name').text(data.S_NAME);
                $('#model_name').text(data.S_DESC);
                $('#interface_count').text(data.N_IF_CNT);
                $('#oper_count_01').text(data.N_OPER_CNT1);
                $('#oper_count_02').text(data.N_OPER_CNT2);
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
            <col width="85%" />
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
                <col width="55%" />
                <col width="15%" />
                <col width="15%" />
                <col width="15%" />
            </colgroup>
            <tr>
                <td class="filed_A">서비스명</td>
                <td class="filed_A">운용 정보(개수)</td>
                <td class="filed_A">운영상태-연결(개수)</td>
                <td class="filed_A">운영상태-기타(개수)</td>
            </tr>
            <tr>
                <td class="filed_B">Network Interface</td>
                <td class="filed_B" id="interface_count"></td>
                <td class="filed_B" id="oper_count_01"></td>
                <td class="filed_B" id="oper_count_02"></td>
            </tr>
        </table>
    </div>
</div>