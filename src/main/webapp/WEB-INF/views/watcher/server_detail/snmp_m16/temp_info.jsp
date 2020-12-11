<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Sub Title S -->
<div class="avaya_stitle1" style="float: none;">
    <div class="st_under"><h4>온도</h4></div>
</div>
<!-- Sub Title E -->

<div class="table_typ2-4">
    <table summary="" cellpadding="0" cellspacing="0" style="width:100%;">
        <caption></caption>
        <colgroup>
            <col width="10%" />
            <col width="10%" />
            <col width="10%" />
        </colgroup>
        <tr>
            <td class="filed_A">Temperature</td>
            <td class="filed_A">High Warning</td>
            <td class="filed_A">Low Warning</td>
        </tr>
        <tr>
            <td class="filed_B" id="S_TEMPERATURE" style="text-align: center;"></td>
            <td class="filed_B" id="S_HIGHWARN" style="text-align: center;"></td>
            <td class="filed_B" id="S_LOWWARN" style="text-align: center;"></td>
        </tr>
    </table>
</div>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript" src="<c:url value="/js/server-detail.js" />"></script>

<script type="text/javascript">

    var pMonId = '${param.N_MON_ID}';

    $(document).ready(function() {
        $.get(cst.contextPath() + '/watcher/map_snmp_m16.TempInfoQry.htm', {'N_MON_ID' : pMonId})
            .done(function(sData) {

            	var data = JSON.parse(sData);
            	
            	var curTemp = Number(data.S_TEMPERATURE.replace(/C/gi, ''));
            	var highTemp = Number(data.S_HIGHWARN.replace(/C/gi, ''));
            	var rowTemp = Number(data.S_LOWWARN.replace(/C/gi, ''));
            	
            	if (curTemp > highTemp || curTemp < rowTemp) {
            		$('#S_TEMPERATURE').addClass('tcolor_red');
            	}
                $('#S_TEMPERATURE').text(data.S_TEMPERATURE);
                $('#S_HIGHWARN').text(data.S_HIGHWARN);
                $('#S_LOWWARN').text(data.S_LOWWARN);
            });
    });
</script>
