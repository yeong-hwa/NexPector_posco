<%--
    Description : CIMS Avaya CM 장비 Trunk Traffic 페이지
    Date : 2015/07/16
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Sub Title S -->
<div class="avaya_stitle1" style="float: none;">
    <div class="st_under"><h4>Network Traffic 정보</h4></div>
</div>
<!-- Sub Title E -->

<!-- 검색영역 -->
<div class="server_search" style="padding-right: 0px;">
    <ul>
        <li class="leftbg">
            <!-- 검색항목 -->
            <dl>
                <dd>
                    <!-- <strong style="margin-left:20px;"></strong> <input type="text" name="S_NAME" id="search_group_name" value="" class="int_f input_search" style="width: 200px;"/> -->
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

<div id="grid" class="table_typ2-2">
</div>

<!-- stitle -->
<div class="avaya_stitle1">
    <div class="st_under"><h4>날짜별 Traffic 정보</h4></div>
</div>
<!-- stitle // -->

<!-- table_typ2-1 -->
<div class="cal_grpBox">
    <div class="cal_b">
        <!--달력-->
        <div id="calendar"/>
    </div>
    <div id="grp_area" class="grp_b">
        <div style="margin-top:; width:100%;">
			<div class="avaya_stitle1">
				<div class="st_under">
                    <span id="day_title">(2015-05-06 평균 현황 동시 사용 채널수)</span>
                </div>
			</div>
			<div id="single_grp" class="chart-wrapper" style="width: 100%; height:250px; margin-left:0px;">
			</div>
		    <div style="margin-top:30px; margin-left:500px;">
		    	<table>
		    		<tr>
		    			<th>IN 현재: </th>
		    			<td id="in_now"></td>
		    			<th>IN 평균: </th>
		    			<td id="in_avg"></td>
		    			<th>IN Max: </th>
		    			<td id="in_max"></td>
		    		</tr>
		    		<tr>
		    			<th>OUT 현재: </th>
		    			<td id="out_now"></td>
		    			<th>OUT 평균: </th>
		    			<td id="out_avg"></td>
		    			<th>OUT Max: </th>
		    			<td id="out_max"></td>
		    		</tr>    	
		    	</table>
		    </div>
		</div>
    </div>
</div>
<div id="popup"></div>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript" src="<c:url value="/js/server-detail.js" />"></script>

<script type="text/javascript">

    var pMonId = '${param.N_MON_ID}',
        calendar,
        grid,
        singleChart,
        singleTimer;

    var pageConfig = { chartRefreshTime : 7000 };
    
    $(document).ready(function() {

    	// Calendar 초기화
        $("#calendar").kendoCalendar({
            format: 'yyyy-MM-dd',
            change: function() {
            	if((grid.dataItem(grid.select()) == "" || grid.dataItem(grid.select()) == null)) {
            		alert("Interface를 선택해 주세요.");
            		return;
            	}
            	drawChart();
            }
        });
    	calendar = $("#calendar").data("kendoCalendar");
        calendar.value(new Date());

		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/watcher/kendoPagination_M03IfInfoLstQry.htm",
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
			serverSorting	: true
		});
        
        // Trunk Grid
        grid = $("#grid")
            .kendoGrid($.extend({}, kendoGridDefaultOpt, {
                dataSource	: dataSource,
                dataBound   : gridDataBound,
                change		: function(e) {
                	if (this.select().length >= 1) {
	                	drawChart();
                	}
                },
                sortable	: {
                    mode : 'multiple',
                    allowUnsort : true
                },
    		    pageable	: {
    		        pageSizes: [5, 10, 15, 20, 30, 50, 100],
    		        messages : {
    		            empty	: "<strong>No data</strong>",
    		            display : "<span>전체 <strong style='color: #f35800;'>{2}</strong> 개 항목 중 <strong style='color: #f35800;'>{0}~{1}</strong> 번째 항목 출력</span>"
    		        }
    		    },
                scrollable  : false,
				columns		: [
				    {field:'N_INDEX', title:'INDEX', width:'5%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_DESC', title:'DESC', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_ALIAS', title:'ALIAS', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'D_INS_DATE', title:'INS_DATE', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'N_TYPE', title:'TYPE', width:'5%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'N_MTU', title:'MTU', width:'5%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'N_SPEED', title:'SPEED', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_PHYTS_ADDR', title:'PHYTS_ADDR', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_ADMIN_STATUS', title:'ADMIN_STATUS', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#= fn_change_text_color(N_ADMIN_STATUS, S_ADMIN_STATUS) #'},
				    {field:'S_OPER_STATUS', title:'OPER_STATUS', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#= fn_change_text_color(N_OPER_STATUS, S_OPER_STATUS) #'}
				]
        	})).data('kendoGrid');
		
        // Event 등록
        $(".input_search").keypress(function(event){
            if(kendo.keys.ENTER === event.keyCode)
                $("#search").click();
        });

        $('#search').on('click', function() {
        	event.preventDefault();
        	openDetailPopup();
        });
        
        $('#single_grp').kendoChart(); // empty chart create
        $('#day_title').text(kendo.toString(calendar.value(), 'd') + ' Traffic 현황');
    });

    function drawChart() {
		var series = [];
		var searchDay = kendo.toString(calendar.value(), 'd').replace(/-/gi, "");
		
		var colorArray = ["#ff6b2a", "#2f96d0", "#7dd94b", "#d25bb8"];
        
		$.getJSON('/watcher/server_detail/ciscovgTrafficUsingHistory.htm', { 'N_MON_ID' : pMonId, 'N_INDEX' : grid.dataItem(grid.select()).N_INDEX, 'N_DAY': searchDay})
		.done(function(data) {
			console.log(data);
			$('#in_now').text('');
			$('#in_avg').text('');
			$('#out_now').text('');
			$('#out_avg').text('');
			$('#in_max').text('');
			$('#out_max').text('');
			
			$('#day_title').text(kendo.toString(calendar.value(), 'd') + ' Traffic 현황');
			
			var statsHistory = data.list;
			
			var inArr = new Array(statsHistory.length);
			var outArr = new Array(statsHistory.length);
			var categories = new Array(data.list.length);
			var totalTraffic = "";
			
			for (var j = 0; j < statsHistory.length; j++) { // 값이 있는 것만 배열에 넣어줌
				categories[j] = statsHistory[j].TIMES.substr(8,2) + "시 " + statsHistory[j].TIMES.substr(10,2) + "분";
				inArr[j] = statsHistory[j].N_IN_OCTETS;
				outArr[j] = statsHistory[j].N_OUT_OCTETS;
				totalTraffic = statsHistory[j].N_TOTAL_OCTETS;

				if((j+1) == statsHistory.length) {
					$('#in_now').text((statsHistory[j].N_IN_OCTETS / 1024).toFixed(3) + "Mbps");
					$('#out_now').text((statsHistory[j].N_OUT_OCTETS / 1024).toFixed(3) + "Mbps");
				}
			}

			var inSeriesObject = {
				name : 'IN',
				color : colorArray[0],
				data : inArr
			};
			
			var outSeriesObject = {
				name : 'OUT',
				color : colorArray[1],
				data : outArr
			};
			series.push(inSeriesObject);
			series.push(outSeriesObject);
			
			createChart($('#single_grp'), series, categories);
			
			var avgInfo = data.avg_info;
			var maxInfo = data.max_info;
			if (avgInfo) {
				$('#in_avg').text((avgInfo.AVG_IN / 1024).toFixed(3) + "Mbps");
				$('#out_avg').text((avgInfo.AVG_OUT / 1024).toFixed(3) + "Mbps");
			}
			if (maxInfo) {
				$('#in_max').text((maxInfo.N_IN_OCTETS / 1024).toFixed(3) + "Mbps (" + maxInfo.MAX_IN_DATE  + ")");
				$('#out_max').text((maxInfo.N_OUT_OCTETS / 1024).toFixed(3) + "Mbps (" + maxInfo.MAX_OUT_DATE  + ")");
			}			
		});
    }
    
    function refreshGrid() {
        var data = {
            'N_MON_ID' : pMonId,
            // 'S_NAME'   : $('#search_group_name').val()
        };
    	grid.dataSource.read(data);
    	// setTimeout("refreshGrid()", 7000);
    }
   
	function createChart($chartArea, series, categories, opts) {

		var options = {
			autoBind: true,
			legend: {
				position: "bottom"
				, visible: true
			},
			seriesColors : ['red'],
			seriesDefaults: {
				type : "line",
				// style: "smooth",
				markers: {
					size: 5,
                    visible: true
                }
			},
			series: series,
			valueAxis: {
				min : 0,
				// max : 100,
				// majorUnit: 20,
				labels: {
					format: "{0}",
					template: "#= (value / 1024).toFixed(3) #Mbps",
				},
				line: {
					visible: true
				}
			},
			categoryAxis: {
				categories: categories,
				majorGridLines: {
					visible: true
				},
				visible: true,
				labels: {
					format: "{0}",
					step : 5
					// template : "#= value.substr(0,2) #"
				}
			},
			chartArea: {
				height : 250
			},
			tooltip: {
				visible: true,
				format: "{0}",
				template: "#=category #: #= (value / 1024).toFixed(3) #Mbps",
				color: "white"
			}
			//,	seriesClick: onSeriesClick
		}

		opts && $.extend(options, opts)

		return $chartArea.kendoChart(options).data('kendoChart');
	}
 
    function refreshSingleChart() {
    	clearTimeout(singleTimer);
    	
	    singleChart.dataSource.read();
    	
   		singleTimer = setTimeout("refreshSingleChart()", pageConfig.chartRefreshTime);
    } 
/*    
    function createTrafficChart($chartArea, series, categories, opts) {
        var chartOpt = {
            dataSource: dataSource,
            autoBind: false,
            legend: {
                position: "bottom"
            },
            seriesColors : ['blue'],
            seriesDefaults: {
                type: "line"
            },
            series: series,
            valueAxis: {
             //	title: {
            //		text: '(채널)',
            //		postition: 'left top',
            //	}, 
                min : 0,
//                max : 100,
                labels: {
                    template: "#= kendo.toString(value, 'n0') # KB"
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
    } */
 
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
                            'N_GROUP_NUM' 	 : grid.dataItem(grid.select()).GROUP_NUM,
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
 
	function fn_change_text_color(status, value) {
		var className = '';

		var nStatus = parseInt(status);
		
		if (nStatus === 1) {
			className = 'tcolor_blue';
		} else if (nStatus === 2) { // 연결안됨
			return '';
		} else if (nStatus === 3) { // 테스트
		} else if (nStatus === 4) { // 알수없음
		}
 
		return '<span class="' + className + '">' + value + '</span>';
	}

	function comma(num) {
	    var len, point, str; 
	       
	    num = num + ""; 
	    point = num.length % 3 ;
	    len = num.length; 
	   
	    str = num.substring(0, point); 
	    while (point < len) { 
	        if (str != "") str += ","; 
	        str += num.substring(point, point + 3); 
	        point += 3; 
	    } 
	     
	    return str;
	}
	
	function openDetailPopup() {
        
		var param = "N_MON_ID=" + pMonId;
		var dialogWidth = 900;
		// encodeURIComponent(param);
		$.post(cst.contextPath() + '/watcher/go_server_detail.snmp_m03.network_traffic_popup.htm', param)
		.done(function(html) {
			$('#popup')
			.html(html)
			.dialog({
				title			: '네트워크 트래픽 조회',
				resizable		: false,
				width			: dialogWidth,
				height			: 480,
				modal			: true,
				position		: [($(window).width() / 2) - (dialogWidth / 2), 150],
				autoReposition	: true,
				open			: function() {
					$(this).parent().css({top:50, left:($(window).width() / 2) - (dialogWidth / 2)});
				},
				close			: function() {
					$(this).dialog("destroy");
					$('#popup').html("");
				},
				buttons			: {
					"확인": function() {
						$(this).dialog("destroy");
						$('#popup').html("");
					}
				}
			});
		});
	}
</script>
