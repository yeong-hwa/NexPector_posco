<%--
    Description : CIMS Avaya CM 장비 UPS 상태 페이지
    Date : 2015/07/16
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Input -->
<div class="avaya_stitle1" style="float: none;">
    <div class="st_under"><h4>Input Total</h4></div>
</div>

<div id="input_total_grid" class="table_typ2-2" style="width: 50%">
</div>

<div class="avaya_stitle1" style="float: none;">
    <div class="st_under"><h4>Input Entry</h4></div>
</div>

<div id="input_entry_grid" class="table_typ2-2">
</div>

<!-- Output -->
<div class="avaya_stitle1" style="float: none;">
    <div class="st_under"><h4>Output Total</h4></div>
</div>

<div id="ouput_total_grid" class="table_typ2-2" style="width: 50%">
</div>

<div class="avaya_stitle1" style="float: none;">
    <div class="st_under"><h4>Output Entry</h4></div>
</div>

<div id="ouput_entry_grid" class="table_typ2-2">
</div>

<!-- Bypass -->
<div class="avaya_stitle1" style="float: none;">
    <div class="st_under"><h4>Bypass Total</h4></div>
</div>

<div id="bypass_total_grid" class="table_typ2-2" style="width: 50%">
</div>

<div class="avaya_stitle1" style="float: none;">
    <div class="st_under"><h4>Bypass Entry</h4></div>
</div>

<div id="bypass_entry_grid" class="table_typ2-2">
</div>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript" src="<c:url value="/js/server-detail.js" />"></script>

<script type="text/javascript">

    var pMonId = '${param.N_MON_ID}';

    $(document).ready(function() {
        var inputTotalColumn = [
            {field:'N_IN_LINE_BADS', title:'LineBads', width:'50%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'N_IN_NUM_LINES', title:'Input 개수', width:'50%', attributes:_txtCenter, headerAttributes:_txtCenter}
        ];

        var inputEntryColumn = [
            {field:'N_IN_LINE_INDEX', title:'Input Line ID', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'N_IN_FREQUENCY', title:'Frequency', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'N_IN_VOLTAGE', title:'Voltage', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'N_IN_VOLTAGE_MIN', title:'Volt Min', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'N_IN_VOLTAGE_MAX', title:'Volt Max', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter}
        ];

        var outputTotalColumn = [
            {field:'S_OUT_SOURCE', title:'Source', width:'40%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'N_OUT_FREQUENCY', title:'Frequency', width:'30%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'N_OUT_NUM_LINES', title:'Output 개수', width:'30%', attributes:_txtCenter, headerAttributes:_txtCenter}
        ];

        var outputEntryColumn = [
            {field:'N_OUT_LINE_INDEX', title:'Output Line ID', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'N_OUT_VOLTAGE', title:'Voltage', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'N_OUT_CURRENT', title:'Current', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'N_OUT_POWER', title:'Power', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'N_OUT_PERCENT_LOAD', title:'Load', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter}
        ];

        var bypassTotalColumn = [
            {field:'N_BYPASS_FREQUENCY', title:'Frequency', width:'50%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'N_BYPASS_NUM_LINES', title:'Bypass 개수', width:'50%', attributes:_txtCenter, headerAttributes:_txtCenter}
        ];

        var bypassEntryColumn = [
            {field:'N_BYPASS_LINE_INDEX', title:'Bypass Line ID', width:'50%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'N_BYPASS_VOLTAGE', title:'RMS Volts', width:'50%', attributes:_txtCenter, headerAttributes:_txtCenter}
        ];

        createGrid($('#input_total_grid'), getDataSource(cst.contextPath() + '/watcher/lst_getInputTotal.htm'), inputTotalColumn);
        createGrid($('#input_entry_grid'), getDataSource(cst.contextPath() + '/watcher/lst_getInputEntry.htm'), inputEntryColumn);
        createGrid($('#ouput_total_grid'), getDataSource(cst.contextPath() + '/watcher/lst_getOutputTotal.htm'), outputTotalColumn);
        createGrid($('#ouput_entry_grid'), getDataSource(cst.contextPath() + '/watcher/lst_getOutputEntry.htm'), outputEntryColumn);
        createGrid($('#bypass_total_grid'), getDataSource(cst.contextPath() + '/watcher/lst_getBypassTotal.htm'), bypassTotalColumn);
        createGrid($('#bypass_entry_grid'), getDataSource(cst.contextPath() + '/watcher/lst_getBypassEntry.htm'), bypassEntryColumn);
    });

    function getDataSource(url) {
        return new kendo.data.DataSource({
            transport		: {
                read		: {
                    type		: 'post',
                    dataType	: 'json',
                    url 		: url,
                    data 		: function(data) {
                        return { 'N_MON_ID' : pMonId };
                    }
                }
            },
            schema			: {
                data	: function(data) {
                    return $.isArray(data) ? data : [];
                }
            }
        });
    }

    function createGrid(selector, dataSource, columns) {
        $(selector).kendoGrid($.extend({}, kendoGridDefaultOpt, {
            dataSource	: dataSource,
            dataBound	: gridDataBound,
            autoBind    : true,
//            scrollable  : true,
            pageable	: false,
//            height      : 400,
            columns		: columns
        }));
    }
</script>
