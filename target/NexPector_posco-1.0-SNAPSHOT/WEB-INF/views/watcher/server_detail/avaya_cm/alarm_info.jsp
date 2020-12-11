<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="avaya_stitle1" style="float: none;">
    <div class="st_under"><h4>Alarm 정보</h4></div>
</div>

<div id="alarm_info_grid" class="table_typ2-2">
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
                    contentType	: 'application/json;charset=UTF-8',
                    url 		: cst.contextPath() + "/watcher/kendoPagination_avaya_cm.avayaCmAlmInfo.htm",
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

        $("#alarm_info_grid")
	        .kendoGrid($.extend({}, kendoGridDefaultOpt, {
	            dataSource	: dataSource,
	            dataBound	: gridDataBound,
	            sortable	: {
	                mode : 'multiple',
	                allowUnsort : true
	            },
	            scrollable  : false,
	            columns		: [
					{title:'일자', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#=S_CRE_MONTH#월#=S_CRE_DAY#일 #=S_CRE_HOUR#시#=S_CRE_MIN#분'},
				    {field:'S_PORT', title:'포트', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_MAINT_NAME', title:'MAINT_NAME', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_ON_BRD', title:'ON_BRD', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_ALT_NAME', title:'ALT_NAME', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_ALARM_TYPE', title:'ALARM_TYPE', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_SVC_STATE', title:'SVC_STATE', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter}
				]
	        }));
    });
</script>
