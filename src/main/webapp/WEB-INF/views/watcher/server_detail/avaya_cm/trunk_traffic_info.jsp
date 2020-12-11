<%--
    Description : CIMS Avaya CM 장비 Trunk Traffic 페이지
    Date : 2015/07/16
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Sub Title S -->
<div class="avaya_stitle1" style="float: none;">
    <div class="st_under"><h4>Trunk Traffic 정보</h4></div>
</div>
<!-- Sub Title E -->

<!-- 검색영역 -->
<div class="server_search" style="padding-right: 0px;">
    <ul>
        <li class="leftbg">
            <!-- 검색항목 -->
            <dl>
                <dd>
                    <!-- 
                    <strong>선택</strong>
                    <select id="selectedView">
                        <option value="S">개별</option>
                        <option value="G">그룹</option>
                    </select>
                     -->
                    <strong style="margin-left:20px;">국선명</strong> <input type="text" name="S_NAME" id="search_group_name" value="" class="int_f input_search" style="width: 200px;"/>
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

<!-- Grid S -->
<div id="trunk_traffic_grid" class="table_typ2-2">
</div>

<div id="trunk_traffic_group_grid" class="table_typ2-2" style="display: none;">
</div>
<!-- Grid E -->

<!-- stitle -->
<div class="avaya_stitle1">
    <div class="st_under"><h4>시간대별 성능 정보</h4></div>
</div>
<!-- stitle // -->

<!-- table_typ2-1 -->
<div class="cal_grpBox">
    <div class="cal_b">
        <!--달력-->
        <div id="trunk_calendar"/>
    </div>
    <div id="resource_grp_area" class="grp_b">
        <div style="margin-top:-30px; width:100%;">
			<div class="avaya_stitle1">
				<div class="st_under">
                    <span id="avg_day">(2015-05-06 평균 현황 동시 사용 채널수)</span>
                </div>
			</div>
			<div id="trunk_traffic_single_grp" class="chart-wrapper" style="width: 100%; margin-left:0px;">
			</div>
			<div id="trunk_traffic_group_grp" class="chart-wrapper" style="width: 100%; margin-left:0px; display: none;">
			</div>
		</div>
    </div>
</div>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript" src="<c:url value="/js/server-detail.js" />"></script>

<script type="text/javascript">

    var pMonId = '${param.N_MON_ID}',
        calendar,
        trunkTrafficGrid,
        trunkTrafficGroupGrid,
        singleChart,
        groupChart,
        singleTimer,
        groupTimer;

    var pageConfig = { chartRefreshTime : 7000 };
    
    $(document).ready(function() {

    	// Calendar 초기화
        $("#trunk_calendar").kendoCalendar({
            format: 'yyyy-MM-dd',
            change: function() {
				/*             	
            	if($('#selectedView').val() === 'G' && (trunkTrafficGroupGrid.dataItem(trunkTrafficGroupGrid.select()) == "" || trunkTrafficGroupGrid.dataItem(trunkTrafficGroupGrid.select()) == null)) {
            		alert("Group을 선택해 주세요.");
            		return;
            	} 
				*/
            	if((trunkTrafficGrid.dataItem(trunkTrafficGrid.select()) == "" || trunkTrafficGrid.dataItem(trunkTrafficGrid.select()) == null)) {
            		alert("Group을 선택해 주세요.");
            		return;
            	}
				
                $('#avg_day').text('(' + kendo.toString(this.value(), 'd') + ' 평균 현황)');
				
                // if ($('#selectedView').val() === 'S') {
                	singleChart.dataSource.read({
                        'N_MON_ID' 		 : pMonId,
                        'N_GROUP_NUM' 	 : trunkTrafficGrid.dataItem(trunkTrafficGrid.select()).GROUP_NUM,
                        'S_DAY' 	 	 : kendo.toString(this.value(), 'd').replace(/-/gi, "")
                    });
                	
                	refreshSingleChart(); // interval 함수
                // } 
/*                 else if ($('#selectedView').val() === 'G') {
                	groupChart.dataSource.read({
	                	'N_DIALING_CODE' : trunkTrafficGroupGrid.dataItem(trunkTrafficGroupGrid.select()).N_DIALING_CODE,
                    	'S_COMPANY' 	 : trunkTrafficGroupGrid.dataItem(trunkTrafficGroupGrid.select()).S_COMPANY,
                    	'S_CENTER' 	     : trunkTrafficGroupGrid.dataItem(trunkTrafficGroupGrid.select()).S_CENTER,
                    	'S_DAY' 	 	 : kendo.toString(calendar.value(), 'd').replace(/-/gi, "")
	                });
                	
                	// refreshGroupChart(); // interval 함수
                } */
            }
        });
        calendar = $("#trunk_calendar").data("kendoCalendar");
        calendar.value(new Date());

        $('#avg_day').text('(' + kendo.toString(calendar.value(), 'd') + ' 평균 현황)');

        // Trunk Grid
        trunkTrafficGrid = $("#trunk_traffic_grid")
            .kendoGrid($.extend({}, kendoGridDefaultOpt, {
                dataSource	: getDataSource('S'),
                dataBound   : gridDataBound,
                change		: function(e) {
                	if (this.select().length >= 1) {
/* 	                    singleChart.dataSource.read({
	                        'N_MON_ID' 		 : pMonId,
	                        'N_GROUP_NUM' 	 : this.dataItem(this.select()).GROUP_NUM,
	                        'S_DAY' 	 	 : kendo.toString(calendar.value(), 'd').replace(/-/gi, "")
	                    }); */
	                    // singleChart.dataSource.read();
	                	refreshSingleChart();
                	}
                },
                sortable	: {
                    mode : 'multiple',
                    allowUnsort : true
                },
                scrollable  : false,
                columns		: [
                    {field:'GROUP_NUM', title:'국선번호', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter, filterable: false},
                    {field:'S_NAME', title:'국선명', width:'22%', attributes:_txtLeft, headerAttributes:_txtCenter},
                    {field:'GRP_SIZE', title:'전체 채널', width:'17%', attributes:_txtRight, headerAttributes:_txtCenter, filterable: false, template:'#=kendo.toString(GRP_SIZE, "n0")#'},
                    {field:'ACTIVE_MEMBERS', title:'사용채 널', width:'17%', attributes:_txtRight, headerAttributes:_txtCenter, filterable: false, template:'#=kendo.toString(ACTIVE_MEMBERS, "n0")#'},
                    {field:'Q_LENGTH', title:'Q Length', width:'17%', attributes:_txtRight, headerAttributes:_txtCenter, filterable: false, template:'#=kendo.toString(Q_LENGTH, "n0")#'},
                    {field:'CALLS_WAITING', title:'Call Wait', width:'17%', attributes:_txtRight, headerAttributes:_txtCenter, filterable: false, template:'#=kendo.toString(CALLS_WAITING, "n0")#'}
                ]
            })).data('kendoGrid');

        // Trunk Group Grid
        trunkTrafficGroupGrid = $("#trunk_traffic_group_grid")
                .kendoGrid($.extend({}, kendoGridDefaultOpt, {
                    dataSource	: getDataSource('G'),
                    dataBound   : gridDataBound,
                    change		: function(e) {
                    	if (this.select().length >= 1) {
/* 	                    	groupChart.dataSource.read({
	                            'N_DIALING_CODE' : this.dataItem(this.select()).N_DIALING_CODE,
	                            'S_COMPANY' 	 : this.dataItem(this.select()).S_COMPANY,
	                            'S_CENTER' 	     : this.dataItem(this.select()).S_CENTER,
	                            'S_DAY' 	 	 : kendo.toString(calendar.value(), 'd').replace(/-/gi, "")
	                        }); */
	                        groupChart.dataSource.read();
                    		// refreshGroupChart();
                    	}
                    },
                    sortable	: {
                        mode : 'multiple',
                        allowUnsort : true
                    },
                    scrollable  : false,
                    columns		: [
                        {field:'S_DIALING_NAME', title:'Dialing Name', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter, filterable: false},
                        {field:'S_NAME', title:'Group Name', width:'22%', attributes:_txtLeft, headerAttributes:_txtCenter, template: '#=S_NAME#외 #=CNT#건'},
                        {field:'GRP_SIZE', title:'Group Size', width:'17%', attributes:_txtRight, headerAttributes:_txtCenter, filterable: false, template:'#=kendo.toString(GRP_SIZE, "n0")#'},
                        {field:'ACTIVE_MEMBERS', title:'Active', width:'17%', attributes:_txtRight, headerAttributes:_txtCenter, filterable: false, template:'#=kendo.toString(ACTIVE_MEMBERS, "n0")#'},
                        {field:'Q_LENGTH', title:'Q Length', width:'17%', attributes:_txtRight, headerAttributes:_txtCenter, filterable: false, template:'#=kendo.toString(Q_LENGTH, "n0")#'},
                        {field:'CALLS_WAITING', title:'Call Wait', width:'17%', attributes:_txtRight, headerAttributes:_txtCenter, filterable: false, template:'#=kendo.toString(CALLS_WAITING, "n0")#'}
                    ]
                })).data('kendoGrid');

        // 차트 생성
        var singleChartDS = getTrafficDailySingleChartDataSource('<c:url value="/watcher/map_trafficTrunkAvg.htm"/>');
        var groupChartDS = getTrafficDailyGroupChartDataSource('<c:url value="/watcher/map_trafficTrunkGroupAvg.htm"/>');
        
        singleChart = createTrafficChart($('#trunk_traffic_single_grp'), singleChartDS);
        groupChart = createTrafficChart($('#trunk_traffic_group_grp'), groupChartDS);
        
        // Event 등록
        $(".input_search").keypress(function(event){
            if(kendo.keys.ENTER === event.keyCode)
                $("#search").click();
        });

        $('#search').on('click', function() {
        	event.preventDefault();
        	
        	// clearTimeout(groupTimer);
        	// clearTimeout(singleTimer);
        	
            var data = {
                'N_MON_ID' : pMonId,
                'S_NAME'   : $('#search_group_name').val()
            };

            if ($("#trunk_traffic_grid").is(":visible")) {
                trunkTrafficGrid.dataSource.read(data);
            }
            else {
                trunkTrafficGroupGrid.dataSource.read(data);
            }
            
        });

/*         $('#selectedView').on('change', function() {
            if (this.value === 'S') {
                $('#trunk_traffic_group_grp').hide();
                $('#trunk_traffic_single_grp').show();
                $("#trunk_traffic_group_grid").hide();
                $("#trunk_traffic_grid").show();
				
                // timer 초기화
            	// clearTimeout(groupTimer);
    			// clearTimeout(singleTimer);
    			
    			singleChart.refresh(); // 같은 div 내에 차트가 여러개 존재하면 차트 크기가 줄어드는 경우가 있어 refresh 해야함 
            	trunkTrafficGrid.clearSelection();
                trunkTrafficGroupGrid.clearSelection();
            }
            else {
            	$('#trunk_traffic_single_grp').hide();
            	$('#trunk_traffic_group_grp').show();
                $("#trunk_traffic_grid").hide();
                $("#trunk_traffic_group_grid").show();

             	// timer 초기화
            	// clearTimeout(groupTimer);
    			// clearTimeout(singleTimer);
    			
    			groupChart.refresh(); // 같은 div 내에 차트가 여러개 존재하면 차트 크기가 줄어드는 경우가 있어 refresh 해야함 
            	trunkTrafficGrid.clearSelection();
                trunkTrafficGroupGrid.clearSelection();
            }
        }); */
        
        refreshGrid();
    });
	
    
    function refreshGrid() {
        var data = {
                'N_MON_ID' : pMonId,
                'S_NAME'   : $('#search_group_name').val()
        };
    	trunkTrafficGrid.dataSource.read(data);
    	trunkTrafficGroupGrid.dataSource.read(data);
    	
    	// setTimeout("refreshGrid()", 7000);
    }
    
    function refreshSingleChart() {
    	clearTimeout(groupTimer);
    	clearTimeout(singleTimer);
    	
    	if (trunkTrafficGrid.select().length >= 1) {
	    	singleChart.dataSource.read();
    	};
    	
   		singleTimer = setTimeout("refreshSingleChart()", pageConfig.chartRefreshTime);
    }
    
    function refreshGroupChart() {
    	clearTimeout(groupTimer);
    	clearTimeout(singleTimer);
    	
    	if (trunkTrafficGroupGrid.select().length >= 1) {
	    	groupChart.dataSource.read();
    	};
    	groupTimer = setTimeout("refreshGroupChart()", 6000);
    }
    
    function getDataSource(type) {
        var url = '<c:url value="/watcher/kendoPagination_avayaCmTrunkTrafficInfo.htm"/>';
        if (type === 'G') {
            url = '<c:url value="/watcher/kendoPagination_avayaCmTrunkTrafficGroupInfo.htm"/>';
        }

        return new kendo.data.DataSource({
            transport		: {
                read		: {
                    type		: 'post',
                    dataType	: 'json',
                    contentType	: 'application/json;charset=UTF-8',
                    url 		: url,
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
            pageSize		: 5,
            serverPaging	: true,
            serverSorting	: false
        });
    }

    function createTrafficChart($chartArea, dataSource) {
        var chartOpt = {
            dataSource: dataSource,
            autoBind: false,
            legend: {
                position: "bottom"
            },
            seriesColors : ['blue'],
            seriesDefaults: {
                type: "area"
            },
            series: [
                { field: "value", markers: { visible: false } }
            ],
            valueAxis: {
/*             	title: {
            		text: '(채널)',
            		postition: 'left top',
            	}, */
                min : 0,
//                max : 100,
                labels: {
                    template: "#= kendo.toString(value, 'n0') #채널"
                },
                line: {
                    visible: true
                },
                axisCrossingValue: 0
            },
            categoryAxis: {
                categories: ['0시', '1시', '2시', '3시', '4시', '5시', '6시', '7시', '8시', '9시', '10시', '11시', '12시', '13시', '14시', '15시', '16시', '17시', '18시', '19시', '20시', '21시', '22시', '23시'],
                majorGridLines: {
                    visible: true
                },
                visible: true
            },
            chartArea: {
                height   : 200
            },
            tooltip: {
                visible: true,
                format: "{0}",
                template: "#= value #",
                color: "white"
            }
        };

        return $chartArea.kendoChart(chartOpt).data('kendoChart');
    }

    function getTrafficDailySingleChartDataSource(url) {
        return new kendo.data.DataSource({
            transport		: {
                read		: {
                    type		: 'post',
                    dataType	: 'json',
                    url 		: url,
                    data 		: function() {
                        var data = {
                            'N_MON_ID' 		 : pMonId,
                            'N_GROUP_NUM' 	 : trunkTrafficGrid.dataItem(trunkTrafficGrid.select()).GROUP_NUM,
                            'S_DAY' 	 	 : kendo.toString(calendar.value(), 'd').replace(/-/gi, "")
                        };
                        return data;
                    }
                }
            },
            schema			: {
                data	: function(data) {
                    var series = [ { value : $.defaultStr(data.TIME_00, 0) }, { value : $.defaultStr(data.TIME_01, 0) }, { value : $.defaultStr(data.TIME_02, 0) }, { value : $.defaultStr(data.TIME_03, 0) }, { value : $.defaultStr(data.TIME_04, 0) },
                        { value : $.defaultStr(data.TIME_05, 0) }, { value : $.defaultStr(data.TIME_06, 0) }, { value : $.defaultStr(data.TIME_07, 0) }, { value : $.defaultStr(data.TIME_08, 0) }, { value : $.defaultStr(data.TIME_09, 0) },
                        { value : $.defaultStr(data.TIME_10, 0) }, { value : $.defaultStr(data.TIME_11, 0) }, { value : $.defaultStr(data.TIME_12, 0) }, { value : $.defaultStr(data.TIME_13, 0) }, { value : $.defaultStr(data.TIME_14, 0) },
                        { value : $.defaultStr(data.TIME_15, 0) }, { value : $.defaultStr(data.TIME_16, 0) }, { value : $.defaultStr(data.TIME_17, 0) }, { value : $.defaultStr(data.TIME_18, 0) }, { value : $.defaultStr(data.TIME_19, 0) },
                        { value : $.defaultStr(data.TIME_20, 0) }, { value : $.defaultStr(data.TIME_21, 0) }, { value : $.defaultStr(data.TIME_22, 0) }, { value : $.defaultStr(data.TIME_23, 0) }];
                    return series;
                }
            }
        });
    }
    
    function getTrafficDailyGroupChartDataSource(url) {
        return new kendo.data.DataSource({
            transport		: {
                read		: {
                    type		: 'post',
                    dataType	: 'json',
                    url 		: url,
                    data 		: function() {
                        var data = {
                            'N_DIALING_CODE' : trunkTrafficGroupGrid.dataItem(trunkTrafficGroupGrid.select()).N_DIALING_CODE,
                            'S_COMPANY' 	 : trunkTrafficGroupGrid.dataItem(trunkTrafficGroupGrid.select()).S_COMPANY,
                            'S_CENTER' 	     : trunkTrafficGroupGrid.dataItem(trunkTrafficGroupGrid.select()).S_CENTER,
                            'S_DAY' 	 	 : kendo.toString(calendar.value(), 'd').replace(/-/gi, "")
                        };
                        return data;
                    }
                }
            },
            schema			: {
                data	: function(data) {
                    var series = [ { value : $.defaultStr(data.TIME_00, 0) }, { value : $.defaultStr(data.TIME_01, 0) }, { value : $.defaultStr(data.TIME_02, 0) }, { value : $.defaultStr(data.TIME_03, 0) }, { value : $.defaultStr(data.TIME_04, 0) },
                        { value : $.defaultStr(data.TIME_05, 0) }, { value : $.defaultStr(data.TIME_06, 0) }, { value : $.defaultStr(data.TIME_07, 0) }, { value : $.defaultStr(data.TIME_08, 0) }, { value : $.defaultStr(data.TIME_09, 0) },
                        { value : $.defaultStr(data.TIME_10, 0) }, { value : $.defaultStr(data.TIME_11, 0) }, { value : $.defaultStr(data.TIME_12, 0) }, { value : $.defaultStr(data.TIME_13, 0) }, { value : $.defaultStr(data.TIME_14, 0) },
                        { value : $.defaultStr(data.TIME_15, 0) }, { value : $.defaultStr(data.TIME_16, 0) }, { value : $.defaultStr(data.TIME_17, 0) }, { value : $.defaultStr(data.TIME_18, 0) }, { value : $.defaultStr(data.TIME_19, 0) },
                        { value : $.defaultStr(data.TIME_20, 0) }, { value : $.defaultStr(data.TIME_21, 0) }, { value : $.defaultStr(data.TIME_22, 0) }, { value : $.defaultStr(data.TIME_23, 0) }];
                    return series;
                }
            }
        });
    }
</script>
