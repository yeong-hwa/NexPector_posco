<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="avaya_stitle1" style="float: none;">
    <div class="st_under"><h4>버전 정보</h4></div>
</div>

<div id="version_info_grid" class="table_typ2-2">
</div>

<div class="avaya_stitle1" style="float: none;">
    <div class="st_under"><h4>업데이트 정보</h4></div>
</div>

<div id="update_info_grid" class="table_typ2-2">
</div>


<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript" src="<c:url value="/js/server-detail.js" />"></script>

<script type="text/javascript">

    var pMonId = '${param.N_MON_ID}';

    $(document).ready(function() {
        var versionColumns = [
            {field:'S_RLS_NUMBER', title:'RLS_NUMBER', width:'25%', attributes:{style:'text-align:left'}, headerAttributes:{style:'text-align:center'}},
            {field:'S_RLS_STRING', title:'RLS_STRING', width:'25%', attributes:{style:'text-align:left'}, headerAttributes:{style:'text-align:center'}},
            {field:'S_TRANS_SAVED', title:'TRANS_SAVED', width:'25%', attributes:{style:'text-align:left'}, headerAttributes:{style:'text-align:center'}},
            {field:'S_LIC_INSTALLED', title:'LIC_INSTALLED', width:'25%', attributes:{style:'text-align:left'}, headerAttributes:{style:'text-align:center'}}
        ];

        var updateColumns = [
            {field:'S_UPDATE_ID', title:'ID', width:'25%', attributes:{style:'text-align:left'}, headerAttributes:{style:'text-align:center'}},
            {field:'S_UPDATE_STATUS', title:'상태', width:'25%', attributes:{style:'text-align:left'}, headerAttributes:{style:'text-align:center'}},
            {field:'S_UPDATE_TYPE', title:'타입', width:'25%', attributes:{style:'text-align:left'}, headerAttributes:{style:'text-align:center'}},
            {field:'S_UPDATE_DESC', title:'설명', width:'25%', attributes:{style:'text-align:left'}, headerAttributes:{style:'text-align:center'}}
        ];

        createGrid($('#version_info_grid'), getDataSource(cst.contextPath() + '/watcher/lst_avayaCmVersion.htm'), versionColumns);
        createGrid($('#update_info_grid'), getDataSource(cst.contextPath() + '/watcher/lst_avayaCmUpdate.htm'), updateColumns);
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