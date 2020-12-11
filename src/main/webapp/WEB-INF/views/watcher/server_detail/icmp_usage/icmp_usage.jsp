<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript">

	var pMonId = '${param.N_MON_ID}';

	$(document).ready(function() {
		printChart();
	});

	function printChart() {

		$.getJSON('/watcher/lst_IcmpLstQry.htm', {"N_MON_ID": pMonId})
			.done(function(data) {
				var length = data.length;
				var $grpArea = $('#icmp_grp_area');
				$grpArea.empty();

				for (var i = 0; i < length; i++) {
					var obj = data[i];
					var grpIcmpAreaId 	= 'grp_icmp_div_' + i,
						resourceTitle	= 'IP : ' + obj.S_ICMP_IP;

					$grpArea.append( $('<div/>').css({ 'margin-top' : i === 0 ? '0px' : '30px', float : 'left', width : '100%' })
							.append( $('<div/>').addClass('avaya_stitle1')
									.append( $('<div/>').addClass('st_under')
											.append( $('<h4/>').text(resourceTitle) ) ) )
							.append( $('<div/>').attr('id', grpIcmpAreaId).addClass('grp1_div chart-wrapper') ) );


					var dataSource = getIcmpChartData(pMonId, obj.S_ICMP_IP);
					var categories = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
					createChart($('#' + grpIcmpAreaId), dataSource, categories, true, true);

					setInterval(function() {
						dataSource.read();
					}, 1000);
				}
			});
	}

	function getIcmpChartData(monId, icmpIp) {
		return new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					url 		: cst.contextPath() + "/watcher/server_detail/icmp_chart_IcmpLstQry2.htm",
					data 		: function() {
						return {
							'N_MON_ID' 		 : monId,
							'S_ICMP_IP' 	 : icmpIp
						};
					}
				}
			},
			schema			: {
				data	: function(data) {
					var jsonData = JSON.parse(data);
					var length = jsonData ? jsonData.length : 0;
					var arr = [];
					for (var i = 0; i < length; i++) {
						var obj = { value : jsonData[i] };
						arr.push(obj);
					}
					return arr;
				}
			}
		});
	}

	function createChart($chartArea, dataSource, categories) {
		return $chartArea.kendoChart({
			dataSource: dataSource,
			autoBind: true,
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
				min : 1,
				max : 10,
				labels: {
					format: "{0}"
				},
				line: {
					visible: true
				},
				axisCrossingValue: 0
			},
			categoryAxis: {
				categories: categories,
				majorGridLines: {
					visible: false
				},
				visible: false
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
	}
</script>


<div class="cal_grpBox">
	<div id="icmp_grp_area" style="width: 100%;">
	</div>
</div>