<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="avaya_stitle1" style="float: none;">
    <div class="st_under"><h4>시간대별 성능정보</h4></div>
</div>

<div id="occupancy_info_grid" class="table_typ2-2">
</div>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript" src="<c:url value="/js/server-detail.js" />"></script>

<script type="text/javascript">

    var pMonId = '${param.N_MON_ID}';

    $(document).ready(function() {
        var dataSource = new kendo.data.DataSource({
            transport		: {
                read		: {
                    type		: 'post',
                    dataType	: 'json',
                    contentType	: 'application/json;charset=UTF-8',
                    url 		: cst.contextPath() + "/watcher/kendoPagination_avayaCmOccupancy.htm",
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
                }
            },
            serverSorting	: true
        });

        $("#occupancy_info_grid")
            .kendoGrid($.extend({}, kendoGridDefaultOpt, {
                dataSource	: dataSource,
                dataBound	: gridDataBound,
                autoBind    : true,
                sortable	: {
                    mode : 'multiple',
                    allowUnsort : true
                },
                scrollable  : true,
                pageable	: false,
                height      : 400,
                columns		: [
   					{field:'N_MEAS_HOUR', title:'시간', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#= parseInt(N_MEAS_HOUR) / 100#시'},
				    {field:'N_STAT_OCC', title:'STAT_OCC', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#=kendo.toString(N_STAT_OCC, "n0")#%'},
				    {field:'N_CP_OCC', title:'CP_OCC', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#=kendo.toString(N_CP_OCC, "n0")#%'},
				    {field:'N_SM_OCC', title:'SM_OCC', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#=kendo.toString(N_SM_OCC, "n0")#%'},
				    {field:'N_IDLE_OCC', title:'IDLE_OCC', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#=kendo.toString(N_IDLE_OCC, "n0")#%'},
				    {field:'N_TOT_CALL', title:'TOT_CALL', width:'20%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=kendo.toString(N_TOT_CALL, "n0")#'},
				    {field:'N_TAND_CALL', title:'TAND_CALL', width:'20%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=kendo.toString(N_TAND_CALL, "n0")#'},
				    {field:'N_TOT_ATT', title:'TOT_ATT', width:'20%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=kendo.toString(N_TOT_ATT, "n0")#'},
				    {field:'N_INTCOM_ATT', title:'INTCOM_ATT', width:'20%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=kendo.toString(N_INTCOM_ATT, "n0")#'},
				    {field:'N_INC_ATT', title:'INC_ATT', width:'20%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=kendo.toString(N_INC_ATT, "n0")#'},
				    {field:'N_OUT_ATT', title:'OUT_ATT', width:'20%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=kendo.toString(N_OUT_ATT, "n0")#'},
				    {field:'N_PNET_ATT', title:'PNET_ATT', width:'20%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=kendo.toString(N_PNET_ATT, "n0")#'}
   				]
            }));
    });
</script>