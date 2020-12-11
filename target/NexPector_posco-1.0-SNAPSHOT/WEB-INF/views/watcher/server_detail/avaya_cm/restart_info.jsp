<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript" src="<c:url value="/js/server-detail.js" />"></script>

<script type="text/javascript">

    var pMonId = '${param.N_MON_ID}';

    $(function() {
        var dataSource = new kendo.data.DataSource({
            transport		: {
                read		: {
                    type		: 'post',
                    dataType	: 'json',
                    contentType	: 'application/json;charset=UTF-8',
                    url 		: cst.contextPath() + "/watcher/kendoPagination_AvayaCmRestartInfoLstQry.htm",
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

        var columns = kendoGridColumns();

        $("#restartInfoGrid")
            .kendoGrid($.extend({}, kendoGridDefaultOpt, {
                dataSource	: dataSource,
                dataBound	: gridDataBound,
                sortable	: {
                    mode : 'multiple',
                    allowUnsort : true
                },
                columns		: [
   					{field:'S_DATE', title:'일시', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_LEVEL', title:'구분', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_DEMAND', title:'Craft Demanded', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_ESCAL', title:'Escalated', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_CAUSE', title:'원인', width:'30%', attributes:_txtLeft, headerAttributes:_txtCenter}
   				]
            }));
    });
</script>

<!-- stitle -->
<div class="avaya_stitle1" style="float: none;">
    <div class="st_under"><h4>Restart 정보</h4></div>
</div>
<!-- stitle // -->
<!-- table_typ2-2 -->
<div id="restartInfoGrid" class="table_typ2-2">
</div>
<!-- table_typ2-2 // -->


