<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- stitle -->
<div class="avaya_stitle1" style="float: none;">
    <div class="st_under"><h4>Trunk 정보</h4></div>
</div>
<!-- stitle // -->
<!-- table_typ2-2 -->
<div id="trunkInfoGrid" class="table_typ2-2">
</div>
<!-- table_typ2-3 // -->

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
                    url 		: cst.contextPath() + "/watcher/kendoPagination_AvayaCmTrunkInfoLstQry.htm",
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

        $("#trunkInfoGrid")
            .kendoGrid($.extend({}, kendoGridDefaultOpt, {
                dataSource	: dataSource,
                dataBound	: gridDataBound,
                sortable	: {
                    mode : 'multiple',
                    allowUnsort : true
                },
                columns		: [
					{field:'N_NUM', title:'국선번호', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_TYPE', title:'국선타입', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_NAME', title:'국선명', width:'25%', attributes:_txtLeft, headerAttributes:_txtCenter},
				    {field:'S_DESC', title:'설명', width:'25%', attributes:_txtLeft, headerAttributes:_txtCenter},
				    {field:'S_DIRECTION', title:'Direction', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'N_SIZE', title:'Size', width:'15%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=kendo.toString(N_SIZE, "n0")#'},
				    {field:'N_TAC', title:'TAC', width:'15%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=kendo.toString(N_TAC, "n0")#'}
				]
            }));
    });
</script>
