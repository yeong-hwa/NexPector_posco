<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="avaya_stitle1" style="float: none;">
    <div class="st_under"><h4>서버 Alarm 정보</h4></div>
</div>

<div id="grid" class="table_typ2-2">
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
                    url 		: cst.contextPath() + "/watcher/kendoPagination_avaya_cm.serverAlarmListQry.htm",
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

        $("#grid")
	        .kendoGrid($.extend({}, kendoGridDefaultOpt, {
	            dataSource	: dataSource,
	            dataBound	: gridDataBound,
	            sortable	: {
	                mode : 'multiple',
	                allowUnsort : true
	            },
	            scrollable  : false,
	            columns		: [
					{title:'일자', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#=S_MONTH#월#=S_DAY#일 #=S_HOUR#시#=S_MIN#분'},
				    {field:'S_PORT', title:'포트', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_TNAME', title:'S_TNAME', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_BRD', title:'S_BRD', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_ANAME', title:'S_ANAME', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_TYPE', title:'S_TYPE', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_STATE', title:'S_STATE', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter}
				]
	        }));
    });
</script>
