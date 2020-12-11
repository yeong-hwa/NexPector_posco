<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- stitle -->
<div class="avaya_stitle1" style="float: none;">
    <div class="st_under"><h4>MEDIA 정보</h4></div>
</div>
<!-- stitle // -->
<!-- table_typ2-2 -->
<div id="media_info_grid" class="table_typ2-2">
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
                    url 		: cst.contextPath() + "/watcher/server_detail/db/media.htm",
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
            pageSize		: cst.countPerPage(),
            serverPaging	: true,
            serverSorting	: true
        });


        $("#media_info_grid")
            .kendoGrid($.extend({}, kendoGridDefaultOpt, {
                dataSource	: dataSource,
                sortable	: {
                    mode : 'multiple',
                    allowUnsort : true
                },
                columns		: [
                    {field:'MEDIA_ID', title:'ID', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
                    {field:'MEDIA_TYPE', title:'Media Type', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
                    {field:'ROBOT_TYPE', title:'Robot Type', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
                    {field:'ROBOT_NUM', title:'Robot Num', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
                    {field:'ROBOT_SLOT', title:'Robot Slot', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
                    {field:'SIDE_FACE', title:'Side Face', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
                    {field:'RET_LEVEL', title:'Ret Level', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
                    {field:'SIZE_KBYTES', title:'Size Kbytes', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
                    {field:'STATUS', title:'상태', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter}
                ]
            }));
    });
</script>
