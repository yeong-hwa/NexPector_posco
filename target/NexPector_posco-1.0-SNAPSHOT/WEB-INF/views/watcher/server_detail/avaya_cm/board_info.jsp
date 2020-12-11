<%--
    Description : CIMS Avaya CM Board 정보
    Date : 2015/07/16
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Sub Title S -->
<div class="avaya_stitle1" style="float: none;">
    <div class="st_under"><h4>보드 구성내역</h4></div>
</div>
<!-- Sub Title E -->

<!-- Grid S -->
<div id="m01Board_info_grid" class="table_typ2-2">
</div>
<!-- Grid E -->

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
                    url 		: cst.contextPath() + "/watcher/kendoPagination_avaya_cm.avayaCmBoardInfo.htm",
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
            serverSorting	: false
        });

        $("#m01Board_info_grid")
                .kendoGrid($.extend({}, kendoGridDefaultOpt, {
                    dataSource	: dataSource,
                    dataBound	: gridDataBound,
                    sortable	: {
                        mode : 'multiple',
                        allowUnsort : true
                    },
                    scrollable  : false,
                    columns		: [
       					{field:'S_NUM', title:'보드설정위치', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter},
					    {field:'S_TYPE', title:'보드명', width:'20%', attributes:_txtLeft, headerAttributes:_txtCenter},
					    {field:'S_CODE', title:'코드', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter},
					    {field:'S_SUFFIX', title:'구분', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter},
					    {field:'S_VINTAGE', title:'버전', width:'20%', attributes:_txtLeft, headerAttributes:_txtCenter}
       				]
                }));
    });
</script>
