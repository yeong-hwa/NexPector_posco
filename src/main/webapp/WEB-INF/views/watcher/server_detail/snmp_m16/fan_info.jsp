<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Sub Title S -->
<div class="avaya_stitle1" style="float: none;">
    <div class="st_under"><h4>Fan 정보</h4></div>
</div>
<!-- Sub Title E -->

<div class="table_typ2-4">
    <table summary="" cellpadding="0" cellspacing="0" style="width:100%;">
        <caption></caption>
        <colgroup>
            <col width="10%" />
            <col width="10%" />
            <col width="10%" />
            <col width="10%" />
            <col width="10%" />
        </colgroup>
        <tr>
            <td class="filed_A">Type</td>
            <td class="filed_A">Description</td>
            <td class="filed_A">HW Vintage</td>
            <td class="filed_A">HW Suffix</td>
            <td class="filed_A">Faults</td>
        </tr>
        <tr>
            <td class="filed_B" id="S_TYPE" style="text-align: center;"></td>
            <td class="filed_B" id="S_DESC" style="text-align: center;"></td>
            <td class="filed_B" id="S_HW_VINTAGE" style="text-align: center;"></td>
            <td class="filed_B" id="S_HW_SUFFIX" style="text-align: center;"></td>
            <td class="filed_B" id="S_FAULT" style="text-align: center;"></td>
        </tr>
    </table>
</div>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript" src="<c:url value="/js/server-detail.js" />"></script>

<script type="text/javascript">

    var pMonId = '${param.N_MON_ID}';

    $(document).ready(function() {
        $.get(cst.contextPath() + '/watcher/map_snmp_m16.FanInfoQry.htm', {'N_MON_ID' : pMonId})
            .done(function(sData) {
                var data = JSON.parse(sData);
                $('#S_TYPE').text(data.S_TYPE);
                $('#S_DESC').text(data.S_DESC);
                $('#S_HW_VINTAGE').text(data.S_HW_VINTAGE);
                $('#S_HW_SUFFIX').text(data.S_HW_SUFFIX);
                $('#S_FAULT').text(data.S_FAULT);
            });
    });
</script>
