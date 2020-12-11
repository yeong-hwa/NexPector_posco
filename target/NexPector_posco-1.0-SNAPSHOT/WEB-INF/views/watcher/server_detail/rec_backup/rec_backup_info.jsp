<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- stitle -->
<div class="avaya_stitle1" style="float: none;">
    <div class="st_under"><h4>녹취 건수</h4></div>
</div>
<!-- stitle // -->
<!-- table_typ2-2 -->
<div id="rec_backup_count_grid" class="table_typ2-2" style="width: 50%;">
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
                    url 		: cst.contextPath() + "/watcher/kendoPagination_server_detail.recDbBackupCountInfo.htm",
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
            }
        });

        $("#rec_backup_count_grid")
                .kendoGrid($.extend({}, kendoGridDefaultOpt, {
                    dataSource	: dataSource,
                    sortable	: false,
                    pageable    : false,
                    columns		: [
                        {field:'N_TOTAL_COUNT', title:'총 녹취건수', width:'50%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=$.trim(N_TOTAL_COUNT) === "" ? 0 : kendo.toString(N_TOTAL_COUNT, "n0")#'},
                        {field:'N_BACKUP_COUNT', title:'총 백업건수', width:'50%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=$.trim(N_BACKUP_COUNT) === "" ? 0 : kendo.toString(N_BACKUP_COUNT, "n0")#'}
                    ]
                }));
    });
</script>
