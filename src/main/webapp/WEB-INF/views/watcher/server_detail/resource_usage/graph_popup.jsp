<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">

	var nMonId = '${param.N_MON_ID}';	
	var sMapKey = '${param.S_MAP_KEY}';
	var nDateHour = '${param.N_DATE_HOUR}';
	
	var calendar;

	$(document).ready(function() {
		Initialize();
	});

	function Initialize() {
		var xhr = $.getJSON(cst.contextPath() + "/watcher/map_detailMonMapInfo.htm", {
			'N_MON_ID' 		 : nMonId,
			'S_MAP_KEY' 	 : sMapKey
		}).done(function(data) {
			$('#txt_mon_name').html(data.S_MON_NAME);
			$('#txt_mon_ip').html(data.S_MON_IP);
			$('#txt_map_name').html(data.S_MAP_NAME);
			$('#txt_date_hour').html(formatDateHour(nDateHour));
		}); 
		// 차트 그리기
		printChart();
	}

	function formatDateHour(dateHour) {
		var str = "";
		str += dateHour.substr(0, 4) + "년 ";
		str += dateHour.substr(4, 2) + "월 ";
		str += dateHour.substr(6, 2) + "일 ";
		str += dateHour.substr(8, 2) + "시";
		
		return str;
	}	
	
	function printChart() {
		// 자원 Chart 영역 그리기기
		$.getJSON('/watcher/server_detail/resourceUsingHistory.htm', { 'N_MON_ID' : nMonId, 'S_MAP_KEY' : sMapKey, 'N_DATE_HOUR' : nDateHour })
		.done(function(data) {
			var categories = new Array();
			var series = new Array();
			
			for (var i = 0; i < 60; i++) {
				if (i < 10) { categories[i] = '0' + i; }
				else { categories[i] = '' + i; }
				
			}
				
			var arr = new Array(60);
	
			for (var j = 0; j < data.list.length; j++) {
				arr[Number(data.list[j].TIMES)] = data.list[j].N_PER_USE;
			}
			
			series.push({
				name: nDateHour,
				data : arr,
				param : nDateHour
			}); 
			
			createChart($('#popup_grp_area'), series, categories, true, true, {seriesClick: onSeriesClick});
		});
	}

	function createChart($chartArea, series, categories, opts) {

		var options = {
			autoBind: true,
			legend: {
				position: "bottom"
				, visible: false
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
				max : 100,
				majorUnit: 20,
				labels: {
					format: "{0}%"
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
					format: "{0}분",
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
				template: "#=category #분: #= value #%",
				color: "white"
			},
			seriesClick: onSeriesClick
		}

		opts && $.extend(options, opts)

		return $chartArea.kendoChart(options).data('kendoChart');
	}

	function onSeriesClick(e) {
        var minute = e.category;
        var dateTime = "" + e.series.param + pad(minute, 2);
        
		param = "N_MON_ID=" + pMonId + "&N_DATE_TIME=" + dateTime + "&S_MAP_KEY=" + sMapKey;
		
		$.getJSON(cst.contextPath() + '/watcher/server_detail/resourceUsingProcessTopHistoryQry.htm', param)
		.done(function(data) {
			$('#process_top_list').empty();
			
			var html = "";
			for (var i = 0; i < data.list.length; i++) {
				var process = data.list[i];
				html += "<tr>";
				html += 	"<td>" + (i + 1) + "</td>";
				html += 	"<td>" + process.COMMAND + "</td>";
				html += 	"<td>" + process.PID + "</td>";
				html += 	"<td>" + process.CPU + "%</td>";
				html += 	"<td>" + process.MEMORY + "%</td>";				
				html += "</tr>";
			}
			
			$('#process_top_list').append(html);
			
			var dialogWidth = 1000;
	
			$('#process_top_popup')
			.dialog({
				title			: '프로세스 TOP',
				resizable		: false,
				width			: dialogWidth,
				modal			: true,
				position		: [($(window).width() / 2) - (dialogWidth / 2), 150],
				autoReposition	: true,
				open			: function() {
					$(this).parent().css({top:150, left:($(window).width() / 2) - (dialogWidth / 2)});
				},
				close			: function() {
					$(this).dialog("destroy");
				},
				buttons			: {
					"확인": function() {
						$(this).dialog("destroy");
					}
				}
			}); 
		});
    }
</script>
<!-- stitle -->
<div class="server_search">
   <ul>
       <li class="leftbg">
           <!-- 검색항목 -->
           <dl>
               <dd>
                   <strong style="margin-left:20px;">장비명: </strong><span id="txt_mon_name"></span>
                   <strong style="margin-left:20px;">장비 IP: </strong><span id="txt_mon_ip"></span>
                   <strong style="margin-left:20px;">명칭: </strong><span id="txt_map_name"></span>
                   <strong style="margin-left:20px;">날짜: </strong><span id="txt_date_hour"></span>
               </dd>
           </dl>
           <!-- 검색항목 // -->
        </li>
        <li class="rightbg">&nbsp;</li>
    </ul>
</div>



<!-- stitle // -->

<div id="popup_grp_area"></div>
<div id="process_top_popup" class="table_typ2-4" style="display:none;">
	<table>
		<thead>
			<tr>
				<th class="filed_A">No.</th>
				<th class="filed_A" style="width:300px;">프로세스</th>
				<th class="filed_A">PID</th>
				<th class="filed_A">CPU</th>
				<th class="filed_A">MEMORY</th>
			</tr>
		</thead>
		<tbody id="process_top_list">
		</tbody>
	</table>
</div>