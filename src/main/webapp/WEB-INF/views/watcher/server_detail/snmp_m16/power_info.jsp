<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Sub Title S -->
<div class="avaya_stitle1" style="float: none;">
    <div class="st_under"><h4>Power 정보</h4></div>
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
            <col width="10%" />
        </colgroup>
        <tr>
        	<td class="filed_A">Name</td>
            <td class="filed_A">Type</td>
            <td class="filed_A">Description</td>
            <td class="filed_A">HW Vintage</td>
            <td class="filed_A">HW Suffix</td>
            <td class="filed_A">Faults</td>
        </tr>
        <tr>
        	<td class="filed_B" id="S_NAME1" style="text-align: center;"></td>
            <td class="filed_B" id="S_TYPE1" style="text-align: center;"></td>
            <td class="filed_B" id="S_DESC1" style="text-align: center;"></td>
            <td class="filed_B" id="S_HW_VINTAGE1" style="text-align: center;"></td>
            <td class="filed_B" id="S_HW_SUFFIX1" style="text-align: center;"></td>
            <td class="filed_B" id="S_FAULT1" style="text-align: center;"></td>
        </tr>
        <tr>
			<td class="filed_B" id="S_NAME2" style="text-align: center;"></td>        
            <td class="filed_B" id="S_TYPE2" style="text-align: center;"></td>
            <td class="filed_B" id="S_DESC2" style="text-align: center;"></td>
            <td class="filed_B" id="S_HW_VINTAGE2" style="text-align: center;"></td>
            <td class="filed_B" id="S_HW_SUFFIX2" style="text-align: center;"></td>
            <td class="filed_B" id="S_FAULT2" style="text-align: center;"></td>
        </tr>
    </table>
</div>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript" src="<c:url value="/js/server-detail.js" />"></script>

<script type="text/javascript">

    var pMonId = '${param.N_MON_ID}';

    $(document).ready(function() {
        $.get(cst.contextPath() + '/watcher/lst_snmp_m16.PowerInfoQry.htm', {'N_MON_ID' : pMonId})
            .done(function(sData) {
                var data = JSON.parse(sData);
            	
            	$('#S_NAME1').text(data[0].S_NAME);
                $('#S_TYPE1').text(data[0].S_TYPE);
                $('#S_DESC1').text(data[0].S_DESC);
                $('#S_HW_VINTAGE1').text(data[0].S_HW_VINTAGE);
                $('#S_HW_SUFFIX1').text(data[0].S_HW_SUFFIX);
                $('#S_FAULT1').text(data[0].S_FAULT);
                
                $('#S_NAME2').text(data[1].S_NAME);
                $('#S_TYPE2').text(data[1].S_TYPE);
                $('#S_DESC2').text(data[1].S_DESC);
                $('#S_HW_VINTAGE2').text(data[1].S_HW_VINTAGE);
                $('#S_HW_SUFFIX2').text(data[1].S_HW_SUFFIX);
                $('#S_FAULT2').text(data[1].S_FAULT);
            });
    });
</script>
