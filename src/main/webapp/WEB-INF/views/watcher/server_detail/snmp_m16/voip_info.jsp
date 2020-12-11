<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript" src="<c:url value="/js/server-detail.js" />"></script>

<script type="text/javascript">

	var pMonId = '${param.N_MON_ID}';

	$(document).ready(function() {
        $.get(cst.contextPath() + '/watcher/map_snmp_m16.VoipInfoQry.htm', {'N_MON_ID' : pMonId})
        .done(function(sData) {
            var data = JSON.parse(sData);
            
            console.log(data);
            $('#S_INSERT_TIME').text(data.S_INSERT_TIME);
            $('#S_FAULT').text(data.S_FAULT);
            $('#S_ADDSTATUS').text(data.S_ADDSTATUS);
            $('#S_INUSE').text(data.S_INUSE);
        });
		
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/watcher/kendoPagination_snmp_m16.VoipDspInfoQry.htm",
					data 		: function(data) {
						return { 'N_MON_ID' : pMonId };
					}
				},
				parameterMap: function (data, opperation) {
					return JSON.stringify(data);
				}
			},
			schema			: {
				data	: function(data) {
					return data;
				},
				total 	: function(response) {
					return response.length > 0 ? response[0].TOTAL_COUNT : 0;
				}
			},
			pageSize		: cst.countPerPage(),
			serverPaging	: true,
			serverSorting	: true
		});

		$("#grid")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: dataSource,
				sortable	: {
					mode : 'multiple',
					allowUnsort : true
				},
				columns	: [
				    {field:'S_SLOT', title:'SLOT', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
					/* {field:'S_INSERT_TIME', title:'INSERT TIME', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter}, */
				    {field:'S_BOARD', title:'BOARD', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_TYPE', title:'TYPE', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_SUFFIX', title:'SUFFIX', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    /* {field:'S_HWVINTAGE', title:'HW VINTAGE', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter}, */
				    {field:'S_FWVINTAGE', title:'FW VINTAGE', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_INUSE', title:'INUSE', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_ADMIN_STATUS', title:'ADMIN STATUS', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_OPER_STATUS', title:'OPER STATUS', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_FAULT_STATUS', title:'FAULT STATUS', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter}
				]
			}));
	});

	function fn_change_text_color(status, value) {
		var className = 'tcolor_red';

		if (parseInt(status) === 1) {
			className = 'tcolor_blue';
		}

		return '<span class="' + className + '">' + value + '</span>';
	}
</script>

<!-- stitle  -->
<div class="avaya_stitle1" style="float: none;">
	<div class="st_under"><h4>VOIP 정보</h4></div>
</div>
<!--// stitle -->

<div class="table_typ2-4">
    <table summary="" cellpadding="0" cellspacing="0" style="width:100%;">
        <caption></caption>
        <colgroup>
            <col width="10%" />
            <col width="10%" />
            <col width="10%" />
            <col width="10%" />
        </colgroup>
        <tr>
            <td class="filed_A">Insert Time</td>
            <td class="filed_A">FAULT</td>
            <td class="filed_A">ADD STATUS</td>
            <td class="filed_A">INUSE</td>
        </tr>
        <tr>
            <td class="filed_B" id="S_INSERT_TIME" style="text-align: center;"></td>
            <td class="filed_B" id="S_FAULT" style="text-align: center;"></td>
            <td class="filed_B" id="S_ADDSTATUS" style="text-align: center;"></td>
            <td class="filed_B" id="S_INUSE" style="text-align: center;"></td>
        </tr>
    </table>
</div>

<!-- stitle  -->
<div class="avaya_stitle1" style="float: none;">
	<div class="st_under"><h4>VOIP DSP 리스트</h4></div>
</div>
<!--// stitle -->

<!-- table_typ2-2 -->
<div id="grid" class="table_typ2-2">
</div>
<!-- table_typ2-2 // -->