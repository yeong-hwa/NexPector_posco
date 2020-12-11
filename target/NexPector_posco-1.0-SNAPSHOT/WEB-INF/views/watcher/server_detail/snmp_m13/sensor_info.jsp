<%--
    Description : CIMS Avaya CM 장비 Trunk Traffic 페이지
    Date : 2015/07/16
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Sub Title S -->
<div class="avaya_stitle1" style="float: none;">
    <div class="st_under"><h4>SENSOR 정보</h4></div>
</div>
<!-- Sub Title E -->

<!-- Grid S -->
<div id="sensor_grid" class="table_typ2-2">
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
                    url 		: cst.contextPath() + "/watcher/lst_server_detail.selectM13Sensor.htm",
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

        $("#sensor_grid")
            .kendoGrid($.extend({}, kendoGridDefaultOpt, {
                dataSource	: dataSource,
                sortable	: {
                    mode : 'multiple',
                    allowUnsort : true
                },
                scrollable  : false,
                pageable    : false,
                columns		: [
   					{field:'N_SENSOR_NUM', title:'INDEX', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'N_NOW_TEMPERATURE', title:'현재온도', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#=N_NOW_TEMPERATURE# ℃'},
				    {field:'N_NOW_HUMIDITY', title:'현재습도', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#=N_NOW_HUMIDITY# %'},
				    {field:'N_REVISE_TEMPERATURE', title:'온도보정', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#=N_REVISE_TEMPERATURE# ℃'},
				    {field:'N_REVISE_HUMIDITY', title:'습도보정', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#=N_REVISE_HUMIDITY# %'},
				    {field:'N_TEMP_CURRENT_OUTPUT', title:'온도전류출력', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#=N_TEMP_CURRENT_OUTPUT# mA'},
				    {field:'N_HUMI_CURRENT_OUTPUT', title:'습도전류출력', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#=N_HUMI_CURRENT_OUTPUT# mA'},
				    {field:'N_TEMP_CURRENT_REVISION', title:'온도전류보정', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#=N_TEMP_CURRENT_REVISION# ℃'},
				    {field:'N_HUMI_CURRENT_REVISION', title:'습도전류보정', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#=N_HUMI_CURRENT_REVISION# %'},
				    {field:'N_DEW_POINT_TEMPERATURE', title:'노정온도', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#=N_DEW_POINT_TEMPERATURE# ℃'},
				    {field:'S_NET_CONNECTION_ALARM', title:'통신경보', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#=writeNetConnectionHtml(S_NET_CONNECTION_ALARM, S_NET_CONNECTION_ALARM_NAME)#'}
   				]
            }));
    });

    function writeNetConnectionHtml(code, name) {
        var nCode = parseInt(code);
        if (nCode === 0) {
            return name;
        } else if (nCode === 1) {
            return '<span style="color: #f2641a">' + name + '</span>';
        } else {
            return '<span style="color: #F00000">' + name + '</span>';
        }
    }
</script>
