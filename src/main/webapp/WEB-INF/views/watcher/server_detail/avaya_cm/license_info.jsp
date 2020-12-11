<%--
    Description : CIMS Avaya CM 장비 License 페이지
    Date : 2015/07/16
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Sub Title S -->
<div class="avaya_stitle1" style="float: none;">
    <div class="st_under"><h4>License 정보</h4></div>
</div>
<!-- Sub Title E -->

<div class="table_typ2-4">
    <table summary="" cellpadding="0" cellspacing="0" style="width:100%;">
        <caption></caption>
        <colgroup>
            <col width="25%" />
            <col width="25%" />
            <col width="25%" />
            <col width="25%" />
        </colgroup>
        <tr>
            <td class="filed_A">항목</td>
            <td class="filed_A">사용중</td>
            <td class="filed_A">사용가능</td>
            <td class="filed_A">최대</td>
        </tr>
        <tr>
            <td class="filed_A">Logged-In ACD Agents</td>
            <td class="filed_B" id="acd_used" style="text-align: right;"></td>
            <td class="filed_B" id="acd_available" style="text-align: right;"></td>
            <td class="filed_B" id="acd_sys_limit" style="text-align: right;"></td>
        </tr>
        <tr>
            <td class="filed_A">Station Capacity</td>
            <td class="filed_B" id="capacity_used" style="text-align: right;"></td>
            <td class="filed_B" id="capacity_available" style="text-align: right;"></td>
            <td class="filed_B" id="capacity_sys_limit" style="text-align: right;"></td>
        </tr>
    </table>
</div>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript" src="<c:url value="/js/server-detail.js" />"></script>

<script type="text/javascript">

    var pMonId = '${param.N_MON_ID}';

    $(document).ready(function() {
        $.get(cst.contextPath() + '/watcher/map_avaya_cm.avayaCmLicenseInfo.htm', {'N_MON_ID' : pMonId})
            .done(function(sData) {
                var data                = JSON.parse(sData),
                    acdUsed             = $.trim(data.ACD_USED) === '' ? '' : kendo.toString(data.ACD_USED, 'n0'),
                    acd_available       = $.trim(data.ACD_AVAILABLE) === '' ? '' : kendo.toString(data.ACD_AVAILABLE, 'n0'),
                    acd_sys_limit       = $.trim(data.ACD_SYS_LIMIT) === '' ? '' : kendo.toString(data.ACD_SYS_LIMIT, 'n0'),
                    capacity_used       = $.trim(data.CAP_USED) === '' ? '' : kendo.toString(data.CAP_USED, 'n0'),
                    capacity_available  = $.trim(data.CAP_AVAILABLE) === '' ? '' : kendo.toString(data.CAP_AVAILABLE, 'n0'),
                    capacity_sys_limit  = $.trim(data.CAP_LIC_LIMIT) === '' ? '' : kendo.toString(data.CAP_LIC_LIMIT, 'n0');

                $('#acd_used').text(acdUsed);
                $('#acd_available').text(acd_available);
                $('#acd_sys_limit').text(acd_sys_limit);
                $('#capacity_used').text(capacity_used);
                $('#capacity_available').text(capacity_available);
                $('#capacity_sys_limit').text(capacity_sys_limit);
            });
    });
</script>
