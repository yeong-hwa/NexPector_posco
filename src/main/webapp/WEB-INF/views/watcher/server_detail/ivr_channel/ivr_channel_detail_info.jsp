<%--
    Description : CIMS IVR 채널 상세 페이지
    Date : 2015/07/16
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Sub Title S -->
<div class="avaya_stitle1" style="float: none;">
    <div class="st_under"><h4>IVR 채널상세 정보</h4></div>
</div>
<!-- Sub Title E -->

<!-- Grid S -->
<div id="ivr_channel_detail_grid" class="table_typ2-2">
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
                    url 		: cst.contextPath() + "/watcher/kendoPagination_ivr_channel.ivrChannelDetail.htm",
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
        
        $("#ivr_channel_detail_grid")
		.kendoGrid($.extend(kendoGridDefaultOpt, {
			dataSource	: dataSource,
			dataBound	: gridDataBound,
			sortable	: {
				mode 		: 'multiple',
				allowUnsort : true
			},
			scrollable  : false,
			columns		: [
				{field:'S_MON_NAME', title:'장비명', width:'9%', attributes:_txtLeft, headerAttributes:_txtCenter},
				{field:'S_MON_IP', title:'장비 IP', width:'9%', attributes:_txtCenter, headerAttributes:_txtCenter},
				{field:'S_SESSION_ID', title:'세션 ID', width:'213px', attributes:_txtCenter, headerAttributes:_txtCenter},
				{field:'S_CALL_ID', title:'Call ID', width:'228px', attributes:_txtCenter, headerAttributes:_txtCenter},
				{field:'S_STATE', title:'State', width:'9%', attributes:_txtCenter, headerAttributes:_txtCenter},
				{field:'S_ORIGIN', title:'Origin', width:'9%', attributes:_txtCenter, headerAttributes:_txtCenter},
				{field:'S_APP_ID', title:'App ID', width:'9%', attributes:_txtCenter, headerAttributes:_txtCenter},
				{field:'S_APP_NAME', title:'App Name', width:'9%', attributes:_txtLeft, headerAttributes:_txtCenter},
				{field:'S_CCXML', title:'CCXML', width:'9%', attributes:_txtCenter, headerAttributes:_txtCenter},
				{field:'S_DIALOGS', title:'Dialogs', width:'9%', attributes:_txtCenter, headerAttributes:_txtCenter},
				{field:'S_CALLS', title:'Calls', width:'9%', attributes:_txtCenter, headerAttributes:_txtCenter}   		   
			]
		})).data('kendoGrid');
    });
</script>
