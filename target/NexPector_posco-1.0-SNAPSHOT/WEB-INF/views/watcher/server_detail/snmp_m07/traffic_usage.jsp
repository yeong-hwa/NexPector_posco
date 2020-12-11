<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript">

	var pMonId = '${param.N_MON_ID}';

	$(function() {
		Initialize();
	});

	function Initialize() {
		// Calendar 초기화
		$("#traffic_calendar").kendoCalendar({
			format: 'yyyy-MM-dd',
			change: createGraph
		});
		var calendar = $("#traffic_calendar").data("kendoCalendar");
		calendar.value(new Date());

		// M07 IF List Create
		createIfList();
	}
	
	function createIfList() {
		$.getJSON('/watcher/lst_qry_combo_m07_if.htm', { 'N_MON_ID' : pMonId })
			.done(function(data) {
				$('#m07_if_list').empty();
				var length = data ? data.length : 0;
				for (var i = 0; i < length; i++) {
					var obj 	= data[i];
					var $a 		= $('<a/>');
					var $radio 	= $('<input/>').attr({type : 'radio', id : 'm4_if_' + obj.CODE, name : 'm4_if_radio'}).val(obj.CODE);
					var $label 	= $('<label/>').attr('for', 'm4_if_' + obj.CODE).text(obj.VAL);
					var $li 	= $('<li/>');

					if (i === 0) {
						$radio.prop('checked', true);
					}

					$('#m07_if_list').append($li.append($a.append($radio).append($label)));
//					<li><a href="#" onclick=""><input type="radio" name="" id="m4_if_1"/> <label for="m4_if_1">M-Ethernet0/0/0</label> </a></li>
				}

				createGraph();

				$('input[name=m4_if_radio]').on('change', function() {
					createGraph();
				});
			});
	}

	function createGraph() {
		var date = kendo.toString($('#traffic_calendar').data('kendoCalendar').value(), 'd');
		var index = $('input[name=m4_if_radio]:checked').val();

		//트래픽 출력 데이터 컬럼 리스트   컬럼명 : 표시이름
		var arr = [
			{key : 'N_IN_TOTAL_PKT', value : 'IN Total Packet'},
			{key : 'N_IN_TOTAL_SPEED', value : 'IN Total Speed'},
			{key : 'N_IN_BCAST_PKT', value : 'IN Broadcast Packet'},
			{key : 'N_IN_BCAST_SPEED', value : 'IN Broadcast Speed'},
			{key : 'N_IN_UCAST_PKT', value : 'IN Unicast Packet'},
			{key : 'N_IN_UCAST_SPEED', value : 'IN Unicast Speed'},
			{key : 'N_IN_MCAST_PKT', value : 'IN Multicast Packet'},
			{key : 'N_IN_MCAST_SPEED', value : 'IN Multicast Speed'},
			{key : 'N_OUT_TOTAL_PKT', value : 'OUT Total Packet'},
			{key : 'N_OUT_TOTAL_SPEED', value : 'OUT Total Speed'},
			{key : 'N_OUT_BCAST_PKT', value : 'OUT Broadcast Packet'},
			{key : 'N_OUT_BCAST_SPEED', value : 'OUT Broadcast Speed'},
			{key : 'N_OUT_BCAST_PKT', value : 'OUT Unicast Packet'},
			{key : 'N_OUT_BCAST_SPEED', value : 'OUT Unicast Speed'},
			{key : 'N_OUT_MCAST_PKT', value : 'OUT Multicast Packet'},
			{key : 'N_OUT_MCAST_SPEED', value : 'OUT Multicast Speed'}
		];

		var length = arr.length;
		// Chart 영역 초기화
		var $grpArea = $('#traffic_grp_area');
		$grpArea.empty();

		// 출력할 Chart 수만큼 돌면서 동적 DOM 생성 및 Chart 출력
		for (var i = 0; i < length; i++) {
			var columnObj = arr[i];

			var grpTrafficAreaId 	= 'grp_traffic_div_' + i,
				resourceTitle		= columnObj.value;

			// Chart 영역 동적 생성
			$grpArea.append( $('<div/>').css({ 'margin-top' : (i === 0 ? '-30px' : '30px'), float : 'left', width : '100%' })
									.append( $('<div/>').addClass('avaya_stitle1')
													.append( $('<div/>').addClass('st_under')
																.append( $('<h4/>').text(resourceTitle) )
																.append( $('<span/>').text('(' + date + ' 평균)') ) ) )
									.append( $('<div/>').attr('id', grpTrafficAreaId).addClass('grp2_div chart-wrapper').css({width : '100%', 'margin-left' : '0px'}) ) );

			// Chart 출력력
		$('#' + grpTrafficAreaId).kendoChart({
				dataSource: {
					transport		: {
						read		: {
							type		: 'post',
							dataType	: 'json',
							url 		: cst.contextPath() + "/watcher/map_M07TrafficUsageQry.htm",
							data 		: function() {
								return {N_MON_ID : pMonId, N_INDEX : index, S_COLUMN : columnObj.key, N_DAY : date.replace(/-/g,"")};
							}
						}
					},
					schema			: {
						data	: function(data) {
							var dataSource 	= [],
								columnName 	= ['TIME_00', 'TIME_01', 'TIME_02', 'TIME_03', 'TIME_04', 'TIME_05', 'TIME_06', 'TIME_07', 'TIME_08', 'TIME_09', 'TIME_10',
									'TIME_11', 'TIME_11', 'TIME_12', 'TIME_13', 'TIME_14', 'TIME_15', 'TIME_16', 'TIME_17', 'TIME_18', 'TIME_19', 'TIME_20',
									'TIME_21', 'TIME_21', 'TIME_22', 'TIME_23'];

							if ($.isEmptyObject(data)) {
								dataSource = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
							}
							else {
								var length = columnName.length;
								for (var j = 0; j < length; j++) {
									var key = columnName[j];
									dataSource.push(data[key]);
								}
							}
							return dataSource;
						}
					}
				},
				legend: {
					position: "bottom"
				},
				seriesDefaults: {
					type: "line"
				},
				series: [
					{ field: "value", markers: { visible: false } }
				],
				valueAxis: {
					min : 0,
					max : 100,
					majorUnit: 100,
					labels: {
						format: "{0}"
					},
					line: {
						visible: true
					},
					axisCrossingValue: 0
				},
				categoryAxis: {
					categories: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23],
					majorGridLines: {
						visible: true
					}
				},
				chartArea: {
					height : 100
				},
				tooltip: {
					visible: true,
					format: "{0}",
					template: "#= value #",
					color: "white"
				}
			}).data('kendoChart');

			/*// Traffic Chart 영역 그리기
			$.getJSON('/watcher/lst_M07TrafficUsageQry.htm', {N_MON_ID : pMonId, N_INDEX : index, S_COLUMN : columnObj.key, N_DAY : date.replace(/-/g,"")})
				.done(function(data) {
					var dataSource = [],
						columnName = ['TIME_00', 'TIME_01', 'TIME_02', 'TIME_03', 'TIME_04', 'TIME_05', 'TIME_06', 'TIME_07', 'TIME_08', 'TIME_09', 'TIME_10',
									'TIME_11', 'TIME_11', 'TIME_12', 'TIME_13', 'TIME_14', 'TIME_15', 'TIME_16', 'TIME_17', 'TIME_18', 'TIME_19', 'TIME_20',
									'TIME_21', 'TIME_21', 'TIME_22', 'TIME_23'];

					if ($.isEmptyObject(data)) {
						dataSource = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
					}
					else {
						var length = columnName.length;
						for (var j = 0; j < length; j++) {
							var key = columnName[j];
							dataSource.push(data[key]);
						}
					}
				});*/
		}
	}

	function printTrafficChart(date, index, columnObj, i) {

	}
</script>

<!-- stitle -->
<div class="avaya_stitle1">
	<div class="st_under"><h4>Traffic 정보</h4></div>
</div>
<!-- stitle // -->
<div class="cal_grpBox">
	<div class="cal_b">
		<!-- list -->
		<div class="listBox">
			<ul id="m07_if_list">
				<!-- 동적생성 -->
			</ul>
		</div>
		<!-- list // -->
		<!--달력-->
		<div id="traffic_calendar"/>
		<!-- //달력-->
	</div>
	<div id="traffic_grp_area" class="grp_b"></div>
</div>