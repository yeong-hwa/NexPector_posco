<%--
    Description : CIMS Avaya CM 장비 Hunt List 페이지
    Date : 2015/07/16
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Sub Title S -->
<div class="avaya_stitle1" style="float: none;">
    <div class="st_under"><h4>Hunt List 정보</h4></div>
</div>
<!-- Sub Title E -->

<!-- Grid S -->
<div id="huntList_grid" class="table_typ2-2">
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
                    url 		: cst.contextPath() + "/watcher/kendoPagination_avayaCmHuntList.htm",
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

        var columns = kendoGridColumns();

        $("#huntList_grid")
            .kendoGrid($.extend({}, kendoGridDefaultOpt, {
                dataSource	: dataSource,
                dataBound	: gridDataBound,
                sortable	: {
                    mode : 'multiple',
                    allowUnsort : true
                },
                scrollable  : false,
                columns		: [
   					{field:'N_NUM', title:'NUM', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_NAME', title:'Name', width:'22%', attributes:_txtLeft, headerAttributes:_txtCenter},
				    {field:'S_EXT', title:'내선번호', width:'17%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_TYPE', title:'타입', width:'17%', attributes:_txtCenter, headerAttributes:_txtCenter}
   				]
            }));
    });
</script>
