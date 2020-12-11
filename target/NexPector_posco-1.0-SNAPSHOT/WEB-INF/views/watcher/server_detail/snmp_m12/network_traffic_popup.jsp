<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- stitle -->
<div class="">
   <ul>
       <li class="">
           <!-- 검색항목 -->
           <dl>
               <dd>
                    <span style="width:80px; display:inline-block; font-weight: bold;">Interface</span> 
                    <input type="text" id="sel_network_interface" style="width:550px;"/>
                    <span style="float:right;" class="">
                    	<a href="javascript:searchNetworkTrafficChart();" id="search"><img src="<c:url value="/images/botton/search_1.jpg"/>" alt="검색" /></a>
                    </span>
               </dd>
               <dd>
                   	<span style="width:80px; display:inline-block; font-weight: bold;">시간</span>
                   	<input type="text" name="S_ST_DT" id="start_date" class="input_search" value="" /> 
               		<input type="text" name="S_TIME" id="S_TIME" value="" class="" style="width:80px;"/> 
               		~ 
               		<input type="text" name="S_ED_DT" id="end_date" class="input_search" value=""/> 
               		<input type="text" name="E_TIME" id="E_TIME" value="" style="width:80px;"/>
               </dd>
           </dl>
           <!-- 검색항목 // -->
        </li>
        <li class="rightbg">&nbsp;</li>
    </ul>
</div>

<!-- stitle // -->

<div id="popup_grp_area"></div>
<div style="margin-top:10px; margin-left:250px;">
		    	<table>
		    		<tr>
		    			<th>IN 평균: </th>
		    			<td id="in_avg_popup"></td>
		    			<th>IN Max: </th>
		    			<td id="in_max_popup"></td>
		    		</tr>
		    		<tr>
		    			<th>OUT 평균: </th>
		    			<td id="out_avg_popup"></td>
		    			<th>OUT Max: </th>
		    			<td id="out_max_popup"></td>
		    		</tr>    	
		    	</table>
</div>

<script type="text/javascript">

	var nMonId = '${param.N_MON_ID}';	
	
	var calendar;
	var startDay, endDay;
	var sTimePick, eTimePick;
	
	$(document).ready(function() {
		Initialize();
	});

	function Initialize() {
		var now = new Date();
		var startDate = new Date(now.getFullYear(), now.getMonth(), 1, 0, 0, 0, 0);
				
		startDay = createStartKendoDatepickerWithDate('start_date', startDate);
		endDay = createEndKendoDatepicker('end_date');
		startDay.max(endDay.value());
		endDay.min(startDay.value());

		
		sTimePick = $('#S_TIME').kendoTimePicker({
			format: "HH:mm",
			interval: 1,
			value:startDate
		}).data('kendoTimePicker');
		
		eTimePick = $('#E_TIME').kendoTimePicker({
			format: "HH:mm",
			interval: 1,
			value:new Date()
		}).data('kendoTimePicker');
		
		// Interface DropDownList
		var dataSource = new kendo.data.DataSource({
			transport: {
				read: {
					url: cst.contextPath() + '/watcher/lst_cmb_standard_interface.htm'
					, dataType: "json"
					, data : {N_MON_ID : nMonId}
				}
			}
		});

		createDropDownList('sel_network_interface', dataSource);
		//-- Interface DropDownList

		// 차트 그리기
		createPopupChart($('#popup_grp_area')) // empty chart create
		// printChart();
	}

	function formatDateHour(dateHour) {
		var str = "";
		str += dateHour.substr(0, 4) + "년 ";
		str += dateHour.substr(4, 2) + "월 ";
		str += dateHour.substr(6, 2) + "일 ";
		str += dateHour.substr(8, 2) + "시";
		
		return str;
	}	
	
	function searchNetworkTrafficChart() {
		// 자원 Chart 영역 그리기기
		var series = [];
		
		var colorArray = ["#ff6b2a", "#2f96d0", "#7dd94b", "#d25bb8"];
        
		// validation 
		var temp1 = kendo.toString(startDay.value(), 'd').replace(/-/gi, "").substr(4, 2);
		var temp2 = kendo.toString(endDay.value(), 'd').replace(/-/gi, "").substr(4, 2);
		
		console.log("Start : " + temp1 + ", " + kendo.toString(startDay.value(), 'd').replace(/-/gi, ""));
		console.log("End : " + temp2 + ", " + kendo.toString(endDay.value(), 'd').replace(/-/gi, ""));
		
		if (temp1 != temp2) {
			alert('같은 달의 데이터를 선택해주세요.');
			return false;
		}
		
		var param = { 
				'N_MON_ID' : pMonId
				, 'N_INDEX' : $("#sel_network_interface").data('kendoDropDownList').value()
				, 'N_DAY': kendo.toString(startDay.value(), 'd').replace(/-/gi, "")
				, 'START_DATE': kendo.toString(startDay.value(), 'd').replace(/-/gi, "") + kendo.toString(sTimePick.value(), 'HHmm')
				, 'END_DATE': kendo.toString(endDay.value(), 'd').replace(/-/gi, "") + kendo.toString(eTimePick.value(), 'HHmm')
		};
		                                  
		$.getJSON('/watcher/server_detail/standardTrafficUsingDetailHistoryQry.htm', param)
		.done(function(data) {
			console.log(data.avg_info);
			console.log(data.max_info);
			
			var statsHistory = data.detail_list;
			
			var inArr = new Array(statsHistory.length);
			var outArr = new Array(statsHistory.length);
			var categories = new Array(statsHistory.length);
			var totalTraffic = "";
			
			for (var j = 0; j < statsHistory.length; j++) { // 값이 있는 것만 배열에 넣어줌
				categories[j] = statsHistory[j].TIMES.substr(6,2) + "일" + statsHistory[j].TIMES.substr(8,2) + "시 " + statsHistory[j].TIMES.substr(10,2) + "분";
				inArr[j] = statsHistory[j].N_IN_OCTETS;
				outArr[j] = statsHistory[j].N_OUT_OCTETS;
				totalTraffic = statsHistory[j].N_TOTAL_OCTETS;

				if((j+1) == statsHistory.length) {
					$('#in_now_popup').text(comma(statsHistory[j].N_IN_OCTETS));
					$('#out_now_popup').text(comma(statsHistory[j].N_OUT_OCTETS));
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
			
			var skipLength;
			if (statsHistory.length > 60) {
				skipLength = (statsHistory.length / 8).toFixed(0);
			} else {
				skipLength = 5;
			}
			createPopupChart($('#popup_grp_area'), series, categories, skipLength);
			
			var avgInfo = data.avg_info;
			var maxInfo = data.max_info;
			if (avgInfo) {
				$('#in_avg_popup').text((avgInfo.AVG_IN / 1024).toFixed(3) + "Mbps");
				$('#out_avg_popup').text((avgInfo.AVG_OUT / 1024).toFixed(3) + "Mbps");
			}
			if (maxInfo) {
				$('#in_max_popup').text((maxInfo.N_IN_OCTETS / 1024).toFixed(3) + "Mbps (" + maxInfo.MAX_IN_DATE  + ")");
				$('#out_max_popup').text((maxInfo.N_OUT_OCTETS / 1024).toFixed(3) + "Mbps (" + maxInfo.MAX_OUT_DATE  + ")");
			}				
		});
	}

	function createPopupChart($chartArea, series, categories, skipLength, opts) {

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
				//	size: 1,
                    visible: false
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
					step : skipLength
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
			},
		}

		opts && $.extend(options, opts)

		return $chartArea.kendoChart(options).data('kendoChart');
	}
</script>
