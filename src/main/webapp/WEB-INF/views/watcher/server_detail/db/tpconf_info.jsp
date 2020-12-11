<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- stitle -->
<div class="avaya_stitle1" style="float: none;">
    <div class="st_under"><h4>TPCONF 정보</h4></div>
</div>
<!-- stitle // -->
<!-- table_typ2-2 -->
<div id="tpconf_info_grid" class="table_typ2-2">
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
                    url 		: cst.contextPath() + "/watcher/server_detail/db/tpconf.htm",
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
                    console.log(data.list);
                    return data.list;
                },
                total 	: function(response) {
                    return response.list.length > 0 ? response.list[0].TOTAL_COUNT : 0;
                }
            },
            pageSize		: cst.countPerPage(),
            serverPaging	: true,
            serverSorting	: true
        });

        $("#tpconf_info_grid")
            .kendoGrid($.extend({}, kendoGridDefaultOpt, {
                dataSource	: dataSource,
                sortable	: {
                    mode : 'multiple',
                    allowUnsort : true
                },
                columns		: [
                    {field:'DRIVE_ID', title:'ID', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
                    {field:'DRIVE_NAME', title:'이름', width:'20%', attributes:_txtLeft, headerAttributes:_txtCenter},
                    {field:'DRIVE_TYPE', title:'타입', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
                    {field:'RESIDENCE', title:'Residence', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter},
                    {field:'DRIVE_PATH', title:'Path', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter},
                    {field:'DRIVE_STATUS', title:'상태', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter}
                ]
            }));
    });
</script>
