<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="avaya_stitle1" style="float: none;">
    <div class="st_under"><h4>PNLOAD 정보</h4></div>
</div>

<div id="pnload_info_grid" class="table_typ2-2" style="width: 50%;">
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
                    url 		: cst.contextPath() + "/watcher/lst_avaya_cm.avayaCmPnload.htm",
                    data 		: function(data) {
                        return { 'N_MON_ID' : pMonId };
                    }
                }
            },
            schema			: {
                data	: function(data) {
                    return data;
                }
            }
        });

        $("#pnload_info_grid")
            .kendoGrid($.extend({}, kendoGridDefaultOpt, {
                dataSource	: dataSource,
                columns		: [
                    {field:'N_PN_NUMBER', title:'PN_NUMBER', width:'50%', attributes:_txtCenter, headerAttributes:_txtCenter},
                    {field:'N_TDM_OCCUPANCY', title:'TDM_OCCUPANCY', width:'50%', attributes:_txtCenter, headerAttributes:_txtCenter}
                ],
                pageable    : false
            }));
    });
</script>
