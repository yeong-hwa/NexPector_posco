<%--
    Description : CIMS Avaya CM 장비 License 페이지
    Date : 2015/07/16
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Sub Title S -->
<div class="avaya_stitle1" style="float: none;">
    <div class="st_under"><h4>알람 Count 정보</h4></div>
</div>
<!-- Sub Title E -->

<div class="table_typ2-4">
    <table summary="" cellpadding="0" cellspacing="0" style="width:50%;">
        <caption></caption>
        <colgroup>
            <col width="50%" />
            <col width="50%" />
        </colgroup>
        <tr>
            <td class="filed_A">MAJOR</td>
            <td class="filed_B" id="major_count" style="text-align: right;"></td>
        </tr>
        <tr>
            <td class="filed_A">MINOR</td>
            <td class="filed_B" id="minor_count" style="text-align: right;"></td>
        </tr>
        <tr>
            <td class="filed_A">WARN</td>
            <td class="filed_B" id="warn_count" style="text-align: right;"></td>
        </tr>
    </table>
</div>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript" src="<c:url value="/js/server-detail.js" />"></script>

<script type="text/javascript">

    var pMonId = '${param.N_MON_ID}';

    $(document).ready(function() {
        $.get(cst.contextPath() + '/watcher/map_avaya_cm.avayaCmAlarmCount.htm', {'N_MON_ID' : pMonId})
            .done(function(sData) {
                var data = JSON.parse(sData);
                $('#major_count').text(kendo.toString(data.N_MAJOR_CNT, 'n0'));
                $('#minor_count').text(kendo.toString(data.N_MINOR_CNT, 'n0'));
                $('#warn_count').text(kendo.toString(data.N_WARN_CNT, 'n0'));
            });
    });
</script>
