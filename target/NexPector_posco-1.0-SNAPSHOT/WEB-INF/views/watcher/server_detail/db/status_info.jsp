<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- stitle -->
<div class="avaya_stitle1" style="float: none;">
    <div class="st_under"><h4>STATUS 정보</h4></div>
</div>
<!-- stitle // -->
<!-- table_typ2-2 -->
<div id="status_info_grid" class="table_typ2-2">
</div>
<!-- table_typ2-3 // -->

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript" src="<c:url value="/js/server-detail.js" />"></script>

<script type="text/javascript">

    var pMonId = '${param.N_MON_ID}';
    var grid;

    $(document).ready(function() {

        var columns;

        var status1Columns = [
            {field:'JOB_ID', title:'Job ID', width:'9%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'BACKUP_TYPE', title:'Bacup Type', width:'7%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'STATE', title:'State', width:'7%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'STATUS', title:'Status', width:'7%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'POLICY', title:'Policy', width:'7%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'SCHEDULE', title:'Schedule', width:'7%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'DEST_MED', title:'Dest Med', width:'7%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'CLIENT', title:'Client', width:'7%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'STARTED', title:'Started', width:'7%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'ENDED', title:'Ended', width:'7%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'ELAPSED', title:'Elapsed', width:'7%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'ATTEM', title:'Attem', width:'7%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'FILES', title:'Files', width:'7%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'KILOBYTE', title:'Kilobyte', width:'7%', attributes:_txtCenter, headerAttributes:_txtCenter}
        ];

        var status2Columns = [
            {field:'JOB_ID', title:'Job ID', width:'9%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'JOB_TYPE', title:'Job Type', width:'7%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'STATE', title:'State', width:'7%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'STATUS', title:'Status', width:'7%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'POLICY', title:'Policy', width:'7%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'SCHEDULE', title:'Schedule', width:'7%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'CLIENT', title:'Client', width:'7%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'DEST_MED', title:'Dest Med', width:'7%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'ACTIVE_PID', title:'Active Pid', width:'7%', attributes:_txtCenter, headerAttributes:_txtCenter},
            {field:'FATPIPE', title:'FatPipe', width:'7%', attributes:_txtCenter, headerAttributes:_txtCenter}
        ];

        $.getJSON(cst.contextPath() + '/watcher/server_detail/db/status/count.htm', {'N_MON_ID' : pMonId})
            .done(function(data) {
                if ( data.status === 'status' ) {
                    columns = status1Columns;
                } else {
                    columns = status2Columns;
                }

                var dataSource = new kendo.data.DataSource({
                    transport		: {
                        read		: {
                            type		: 'post',
                            dataType	: 'json',
                            contentType	: 'application/json;charset=UTF-8',
                            url 		: cst.contextPath() + "/watcher/server_detail/db/status.htm",
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
                            return data.list;
                        },
                        total 	: function(response) {
                            return response.list.length > 0 ? response.list[0].TOTAL_COUNT : 0;
                        }
                    },
                    serverSorting	: true
                });

                grid = $("#status_info_grid")
                        .kendoGrid($.extend({}, kendoGridDefaultOpt, {
                            dataSource	: dataSource,
                            dataBound   : gridDataBound,
                            autoBind    : true,
                            pageable    : false,
                            sortable	: {
                                mode : 'multiple',
                                allowUnsort : true
                            },
                            columns		: columns
                        })).data('kendoGrid');
            });



    });
</script>
