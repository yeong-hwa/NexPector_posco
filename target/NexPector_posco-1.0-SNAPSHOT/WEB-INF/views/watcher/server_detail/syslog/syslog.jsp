<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Sub Title S -->
<div class="avaya_stitle1" style="float: none;">
    <div class="st_under"><h4>SysLog</h4></div>
</div>
<!-- Sub Title E -->

<!-- 검색영역 -->
<div class="server_search" style="padding-right: 0px;">
    <ul>
        <li class="leftbg">
            <!-- 검색항목 -->
            <dl>
                <dd>
                	<strong style="margin-left:20px;">조회 일시</strong>
					<input type="text" id="START_DT" class="input_search" value="" />
					 <input type="text" id="S_TM" value="" class="" style="width:80px;"/>
					 ~ 
					 <input type="text" id="END_DT" class="input_search" value=""/>
					 <input type="text" id="E_TM" value="" class="" style="width:80px;"/>
                </dd>
            </dl>
            <!-- 검색항목 // -->
            <!-- 버튼 -->
            <span class="svr_search_bt"><a href="#" id="search"><img src="<c:url value="/images/botton/search_1.jpg"/>" alt="검색" /></a></span>
            <!-- 버튼 // -->
        </li>
        <li class="rightbg">&nbsp;</li>
    </ul>
</div>
<!-- 검색영역 //-->

<div id="sysloggrid" class="table_typ2-2">
</div>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>

<script type="text/javascript">
   
	 // Grid Header
    var _txtRight = {style:'text-align:right'},
        _txtLeft = {style:'text-align:left'},
        _txtCenter = {style:'text-align:center'};
 
 
    $(document).ready(function() {
    	var start = createStartKendoDatepicker('START_DT');
		var end = createEndKendoDatepicker('END_DT');
		start.max(end.value());
		end.min(start.value());
		
		 var tDate = new Date();
		tDate.setHours(tDate.getHours()-1)
		var sTimePick = $('#S_TM').kendoTimePicker({
			format: "HH",
			interval: 60,
			value :tDate
		}).data('kendoTimePicker');
		
		var eTimePick = $('#E_TM').kendoTimePicker({
			format: "HH",
			interval: 60,
			value:new Date()
		}).data('kendoTimePicker'); 
		
		fn_list();
        // Event 등록
        $('#search').on('click', function() {
        	event.preventDefault();
        	fn_list();
        });
        
    });
    
    function fn_list(){
    	var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/watcher/kendoPagination_ServerDetailSysLogList.htm",
					data 		: function(data) {
						return { 
								'N_MON_ID' : '${param.N_MON_ID}'
								, 'S_ST_DT'	: $('#START_DT').val().replace(/-/gi, '')+$('#S_TM').val()
								, 'S_ED_DT' : $('#END_DT').val().replace(/-/gi, '')+$('#E_TM').val()
						};
					}
				},
				parameterMap: function (data, opperation) {
					return JSON.stringify(data);
				}
			},
			schema			: {
				data	: function(data) {
					console.log(data);
					return data;
				},
				total 	: function(response) {
					return response.length > 0 ? response[0].TOTAL_COUNT : 0;
				}
			},
			pageSize		: 10,
			serverPaging	: true,
			serverSorting	: true
		});
        
        // Trunk Grid
        $("#sysloggrid").kendoGrid($.extend({}, kendoGridDefaultOpt, {
                dataSource	: dataSource,
                dataBound   : gridDataBound,
				columns		: [
				    {field:'D_REG_TIME', title:'Time', width:'80px', headerAttributes:_txtCenter},
				    {field:'IPADDRESS', title:'IP', width:'50px', headerAttributes:_txtCenter},
				    {field:'HOST', title:'HOST', width:'50px', headerAttributes:_txtCenter},
				    {field:'Facility', title:'Facility', width:'50px', headerAttributes:_txtCenter},
				    {field:'Priority', title:'Priority', width:'50px', headerAttributes:_txtCenter},
				    {field:'Tag', title:'Tag', width:'30px', headerAttributes:_txtCenter},
				    {field:'Message', title:'Message', width:'300px', headerAttributes:_txtCenter, Attributes:_txtLeft}
				]
        	})).data('kendoGrid');
    }

</script>
