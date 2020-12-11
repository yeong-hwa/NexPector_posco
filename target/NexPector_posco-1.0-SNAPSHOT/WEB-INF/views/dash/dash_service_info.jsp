<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>

<head>
  <meta charset="utf-8">
  <title>::: [대교] IPT/IPCC 시스템 현황 :::</title>

	<jsp:include page="../include/dash_service_include.jsp"></jsp:include>
	<jsp:include page="../include/dash_common_include.jsp"></jsp:include>

  <!-- 탭 자동롤링-->
  <script>
    $(function() {
        $(".webwidget_scroller_tab").webwidget_scroller_tab({
            scroller_time_interval: '300000',
            scroller_window_padding: '10',
            scroller_window_width: '740',
            scroller_window_height: '127',
            scroller_head_text_color: '#adb2b7',
            scroller_head_current_text_color: '#fff',
//            directory: 'images'
        });
    });
  </script>
  <!-- //탭 자동롤링-->

<script type="text/javascript">
var	s_url = "/dashboard/dash_service_info.htm";
var intervalgetTime = 0;
// var refreshTime = 0;
// var pageTime = 0;

var StringBuffer = function() {
    this.buffer = new Array();
};
StringBuffer.prototype.append = function(str) {
    this.buffer[this.buffer.length] = str;
};
StringBuffer.prototype.toString = function() {
    return this.buffer.join("");
};

$(document).ready(function() {
	chkBtnStatService();
	
	intervalgetTime = setInterval("currentDateTimer()", s_defaultInterval);
	/*
	init_time(s_url, disp_dashServiceInfo);
	
	// setTimeout에 설정할 초단위 시간을 DB에서 가져오기
	get_refresh_time();	// 새로고침 시간 구하기
	get_page_time();	// Page 전환 시간 구하기
	
	disp_dashServiceInfo();
	*/
});

function go_refresh() {
	// console.log("go_refresh() refreshTime : " + refreshTime);
	disp_dashServiceInfo();
/* 	if(refreshTime > 0) {
		setInterval(function() {
			disp_dashServiceInfo();
		}, refreshTime);
	} */
}

function go_page() {
	// console.log("go_page() pageTime : " + pageTime);
	
	location.href="dash_system_info.htm";
/* 	if(pageTime > 0) {
		setTimeout(function() {
			location.href="dash_system_info.htm";
		}, pageTime);
	}
 */
 }

function disp_dashServiceInfo() {
	var url = cst.contextPath() + '/dashboard/ajax_service_info.htm';
	var param = {
		S_URL: s_url, 
		NUM_LIST: '080-077-0202,080-222-0909,080-777-1000,080-223-0909' 
	};

	//currentDateTimer();
	$.getJSON(url, param, function(resp){
		cmLog(resp);
		disp_vgRealtimeUseBonsa(resp.VG_REALTIME_USE_BONSA);
		disp_vgRealtimeUseJijum(resp.VG_REALTIME_USE_JIJUM);
		disp_vgRealtimeUseCount(resp.VG_RTCNT_USE_BONSA, resp.VG_RTCNT_USE_JIJUM);
		disp_callRealtimeAccrueBonsa(resp.CALL_REALTIME_ACCRUE_BONSA);
		disp_callRealtimeAccrueJijum(resp.CALL_REALTIME_ACCRUE_JIJUM);
		
		disp_callDaepyoIncallState(resp.CALL_DAEPYO_INCALL_STATE);
		
		disp_callUsePeakGroup(resp.CALL_USE_PEAK_GROUP);
		disp_callNowSummaryState(resp.CALL_NOW_SUMMARY_STATE);
		
		disp_callTotSummaryState(resp.CALL_TOT_SUMMARY_STATE, resp.CALL_EXTRA_INFO);
		disp_callMonthSummaryList(resp.CALL_MONTH_SUMMARY_LIST, resp.CALL_EXTRA_INFO);
		//disp_intervalTime(resp.INTERVAL_INFO);
	});
}

/* VG 실시간 사용현황 */
function disp_vgRealtimeUseBonsa(res_data) {
	var	series = [
		{ category: "대기",  value: 0, color: "#f57420" },
		{ category: "사용",   value: 0, color: "#00af43" }
	];
	res_data.WAIT_COUNT = res_data.TOT_COUNT - res_data.USE_COUNT;

	series[0].value = res_data.WAIT_COUNT;
	series[1].value = res_data.USE_COUNT;

	//cmLog('disp_vgRealtimeUseBonsa');
	//cmLog(series);
	createChart_Donut('chart_vgRealtimeBonsa', series);
	$('#'+ 'BonTotCount').html(res_data.TOT_COUNT);
	$('#'+ 'BonUseCount').html(res_data.USE_COUNT);
}
function disp_vgRealtimeUseJijum(res_data) {
	var	series = [
		{ category: "대기",  value: 0, color: "#f57420" },
		{ category: "사용",   value: 0, color: "#00af43" }
	];
	res_data.WAIT_COUNT = res_data.TOT_COUNT - res_data.USE_COUNT;

	series[0].value = res_data.WAIT_COUNT;
	series[1].value = res_data.USE_COUNT;

	//cmLog('disp_vgRealtimeUseJijum');
	//cmLog(series);
	createChart_Donut('chart_vgRealtimeJijum', series);
	$('#'+ 'JiTotCount').html(res_data.TOT_COUNT);
	$('#'+ 'JiUseCount').html(res_data.USE_COUNT);
}
function disp_vgRealtimeUseCount(res_bonsa, res_jijum) {
	/////////////////////
	var categories = [ ];
	var series1 =  {name:"active", data: [ ], color: "#05F953"};
	var series2 = {name:"idle", data: [ ], color: "#006A35"};
	
	//////////////////////
	var	chart_data1 = [ ];
	var	sum = 0;
	for (var i = 0; i < res_bonsa.length; i ++) {
		sum += res_bonsa[i].USE_COUNT;
	}
	for (var i = 0; i < res_bonsa.length; i ++) {
		var	item = { category: "",  value: 0, color: "#05F953" };
		item.value		= Math.round(res_bonsa[i].USE_COUNT * 100 / res_bonsa[i].TOT_COUNT);
		item.category	= res_bonsa[i].MON_NAME;
		if (item.value >= 90)
			item.color = '#F90505';
		else if (item.value >= 80)
			item.color = '#F96705';
		else if (item.value >= 70)
			item.color = '#F9CA05';
		chart_data1.push(item);
		
		if(res_bonsa[i].TOT_COUNT > 0) {
			series1.data.push(Math.round(res_bonsa[i].USE_COUNT * 100 / res_bonsa[i].TOT_COUNT));
			series2.data.push(100-Math.round(res_bonsa[i].USE_COUNT * 100 / res_bonsa[i].TOT_COUNT));
		} else {
			series1.data.push(0);
			series2.data.push(100);	
		}
		
		categories.push(res_bonsa[i].MON_NAME);
	}
	//createChart_vgBar2('chart_vgRtcntUseBonsa', chart_data1);
	createChart_stackvgBar3('chart_vgRtcntUseBonsa', categories, series1, series2);

	var categoriesJijum = [ ];
	var seriesJijum1 =  {name:"active", data: [ ], color: "#05F953"};
	var seriesJijum2 = {name:"idle", data: [ ], color: "#006A35"};	
	
	var	chart_data2 = [ ];
	sum = 0;
	for (var i = 0; i < res_bonsa.length; i ++) {
		sum += res_jijum[i].USE_COUNT;
	}
	for (var i = 0; i < res_jijum.length; i ++) {
		var	item = { category: "",  value: 0, color: "#05F953" };
		item.value		= Math.round(res_jijum[i].USE_COUNT * 100 / res_jijum[i].TOT_COUNT);
		item.category	= res_jijum[i].MON_NAME;
		if (item.value >= 90)
			item.color = '#F90505';
		else if (item.value >= 80)
			item.color = '#F96705';
		else if (item.value >= 70)
			item.color = '#F9CA05';
		chart_data1.push(item);
		chart_data2.push(item);
		
		if(res_jijum[i].TOT_COUNT > 0) {
			seriesJijum1.data.push(Math.round(res_jijum[i].USE_COUNT * 100 / res_jijum[i].TOT_COUNT));
			seriesJijum2.data.push(100-Math.round(res_jijum[i].USE_COUNT * 100 / res_jijum[i].TOT_COUNT));
		} else {
			seriesJijum1.data.push(0);			
			seriesJijum2.data.push(100);			
		} 
		
		categoriesJijum.push(res_jijum[i].MON_NAME);		
	}
	//createChart_vgBar2('chart_vgRtcntUseJijum', chart_data2);
	createChart_stackvgBar3('chart_vgRtcntUseJijum', categoriesJijum, seriesJijum1, seriesJijum2);
}

/* 실시간 IN·OUT 현황 */
function disp_callRealtimeAccrueBonsa(res_data) {
	if(res_data.OB_COUNT < 1 && res_data.IB_COUNT < 1)
	{
		var	series = [
			{ category: "Idle",  value: 1, color: "#021f3f" }
		];		
		
		createChart_Donut_Zero('chart_realtimeInoutBonsa', series);
		return;
	}
	
	var	series = [
		{ category: "Outbound",  value: 0, color: "#f57420" },
		{ category: "Inbound",   value: 0, color: "#00af43" }
	];
	
	series[0].value = res_data.OB_COUNT;
	series[1].value = res_data.IB_COUNT;

	//cmLog('disp_callRealtimeAccrueBonsa');
	//cmLog(series);
	createChart_Donut('chart_realtimeInoutBonsa', series);
}
function disp_callRealtimeAccrueJijum(res_data) {
	if(res_data.OB_COUNT < 1 && res_data.IB_COUNT < 1)
	{
		var	series = [
			{ category: "Idle",  value: 1, color: "#021f3f" }
		];		
		
		createChart_Donut_Zero('chart_realtimeInoutJijum', series);
		return;
	}
	
	var	series = [
		{ category: "Outbound",  value: 0, color: "#f57420" },
		{ category: "Inbound",   value: 0, color: "#00af43" }
	];
	series[0].value = res_data.OB_COUNT;
	series[1].value = res_data.IB_COUNT;

	//cmLog('disp_callRealtimeAccrueJijum');
	//cmLog(series);
	createChart_Donut('chart_realtimeInoutJijum', series);
}

/* 콜센터 대표번호별 인입현황 */
function disp_callDaepyoIncallState(res_list) {
	if (res_list.length === undefined) {
		res_list = [];
	}
	var	series1 = [
		{ category: "대표1",  value: 0, color: "#119bc9" },
		{ category: "대표2",  value: 0, color: "#f8716d" },
		{ category: "대표3",  value: 0, color: "#ffd401" },
		{ category: "대표4",  value: 0, color: "#a6ce39" }
	];
	var	series2 = [
		{ category: "대표1",  value: 0, color: "#119bc9" },
		{ category: "대표2",  value: 0, color: "#f8716d" },
		{ category: "대표3",  value: 0, color: "#ffd401" },
		{ category: "대표4",  value: 0, color: "#a6ce39" }
	];

	var	sum_val = 0;
	for (var i = 0; i < res_list.length; i ++) {
		sum_val += res_list[i].IN_COUNT;
	}
	for (var idx = 0; idx < res_list.length; idx ++) {
		var	item = res_list[idx];
		series1[idx].category	= item.S_NAME;
		series1[idx].value		= item.IN_COUNT;
		
		var	tag_id = 'daepyo_';
		var	percent = 0;
		if (item.IN_COUNT > 0) {
			percent = Math.round(item.IN_COUNT * 100 / sum_val);
		}
		
		series2[idx].value		= percent;
		series2[idx].category	= item.S_NAME;
		
		
		$('#' + tag_id + 'name_' + idx).html(item.S_NAME);
		$('#' + tag_id + 'num_' + idx).html(item.S_NUM);
		$('#' + tag_id + 'per_' + idx).html(percent);
		$('#' + tag_id + 'val_' + idx).html(makeCommaStr(item.IN_COUNT));
	}
	//cmLog('disp_callDaepyoIncallDonut');
	//cmLog(series1);
	//cmLog('disp_callDaepyoIncallBar');
	//cmLog(series2);
	createChart_Donut_NoLabel('chart_callDaepyoIncallDonut', series1);
	createChart_DaepyoBar2('chart_callDaepyoIncallBar', series2);
}

/* 콜사용 현황 (PEAK) */
function disp_callUsePeakGroup(res_list) {
	if (res_list.length === undefined) {
		res_list = [];
	}
	var	series = [
		{ name: '본사·콜센터',	data: [ ], color: '#015ab8', markers: { visible: false } }, 
		{ name: '전국',      data: [ ], color: '#c05c5f', markers: { visible: false } }
	];
	
	for (var i = 0; i < res_list.length; i ++) {
		var	c_idx = parseInt(res_list[i].N_GROUP_ID) == 8000 ? 0 : 1;
		var	t_idx = parseInt(res_list[i].N_TIME);
		series[c_idx].data[t_idx] = res_list[i].TOT_COUNT;
	}

	createChart_callState('chart_callUsePeakGroup', series);
}

/* 콜 누적 현황 */
function disp_callNowSummaryState(res_list) {
	if (res_list.length === undefined) {
		res_list = [];
	}
	var	series = [
		{ name: '본사·콜센터',	data: [], color: '#015ab8', markers: { visible: false } }, 
		{ name: '전국',      data: [], color: '#c05c5f', markers: { visible: false } }
	];
	
	for (var i = 0; i < res_list.length; i ++) {
		var	c_idx = parseInt(res_list[i].CLUSTER_NO) - 1;
		var	t_idx = parseInt(res_list[i].N_TIME);
		series[c_idx].data[t_idx] = res_list[i].TOT_COUNT;
	}

	createChart_callState2('chart_callNowSummaryState', series);
}

/* 콜 현황 (전체) */
function disp_callTotSummaryState(data, info) {
	var dd_id	= '';

	for (var i = 0; i < data.length; i ++) {
		var item		= data[i];
		var cluster		= item.N_CLUSTER;

		if (cluster == 0) {
			dd_id	= 'BO_' + item.D_TYPE + '_';
		}
		else if (cluster == 1) {
			dd_id	= 'CC_' + item.D_TYPE + '_';
		}
		else if (cluster == 2) {
			dd_id	= 'JI_' + item.D_TYPE + '_';
		}
		
		$('#' + dd_id + 'IN').html(makeCommaStr(item.IN_COUNT));
		$('#' + dd_id + 'OUT').html(makeCommaStr(item.OUT_COUNT));
		$('#' + dd_id + 'TOT').html(makeCommaStr(item.TOT_COUNT));
	}

	dd_id	= 'BO_';
	$('#' + dd_id + 'NOW').html('('+info.D_NOW_STR+')');
	$('#' + dd_id + 'WEEK').html('(' + info.W_S_STR + '~' + info.W_E_STR + ')');
	$('#' + dd_id + 'MONTH').html('(' + info.M_S_STR + '~' + info.M_E_STR + ')');

	dd_id	= 'CC_';
	$('#' + dd_id + 'NOW').html('('+info.D_NOW_STR+')');
	$('#' + dd_id + 'WEEK').html('(' + info.W_S_STR + '~' + info.W_E_STR + ')');
	$('#' + dd_id + 'MONTH').html('(' + info.M_S_STR + '~' + info.M_E_STR + ')');

	dd_id	= 'JI_';
	$('#' + dd_id + 'NOW').html('('+info.D_NOW_STR+')');
	$('#' + dd_id + 'WEEK').html('(' + info.W_S_STR + '~' + info.W_E_STR + ')');
	$('#' + dd_id + 'MONTH').html('(' + info.M_S_STR + '~' + info.M_E_STR + ')');
}

function disp_callMonthSummaryList(data, info) {
	if (data.length === undefined) {
		data = [];
	}
	var		alist = [];
	var		d_start = parseInt(info.M_START);
	var		d_end = parseInt(info.M_END);
	var		fweek = info.M_01_WEEK;
	var		idx = 0;
	var		peak = { val: 0, index: 0 };	// 해당월 peak value / index

	//cmLog("SummaryList-DAY: " + d_start + "~" + d_end);
	for (var day = d_start; day <= d_end; day ++) {
		var	item = { N_DAY: day, N_WEEK: fweek, IN_COUNT: 0, OUT_COUNT: 0, TOT_COUNT: 0 };
		
		alist.push(item);
		fweek ++;
		if (fweek >= 7) fweek = 0;
	}

	for (var i = 0; i < data.length; i ++) {
		idx 	= parseInt(data[i].N_DAY) - d_start;

		if (idx >= 0) {
			alist[idx].IN_COUNT		= data[i].IN_COUNT;
			alist[idx].OUT_COUNT	= data[i].OUT_COUNT;
			alist[idx].TOT_COUNT	= data[i].TOT_COUNT;
			if (peak.val < data[i].TOT_COUNT) {
				peak.val = data[i].TOT_COUNT;
				peak.index = idx;
			}
		}
	}
	//cmLog(alist);
	makeMonthSummaryHtml(alist, info, peak);
}

function makeMonthSummaryHtml(data, info, peak) {
	var week_0		= new StringBuffer();
	var week_1		= new StringBuffer();
	var arr_week	= ['일', '월', '화', '수', '목', '금', '토'];
	
	for (var i = 0; i < data.length; i ++) {
		var item		= data[i];
		var mdate		= item.N_DAY.toString();
		var	week		= item.N_WEEK;
		var in_cnt		= item.IN_COUNT;
		var out_cnt		= item.OUT_COUNT;
		var tot_cnt		= item.TOT_COUNT;
		
		var title		= mdate.substr(6, mdate.length);
		var	day			= parseInt(title);
		var sHtml		= '';
		var tr_class	= '';
		
		if (peak.index == i && peak.val > 0) {
			if (week == 0) {
				tr_class	= 'class="sunday peak"';
			}
			else if (week == 6) {
				tr_class	= 'class="saturday peak"';
			}
			else {
				tr_class	= 'class="peak"';
			}
		}
		else {
			if (week == 0) {
				tr_class	= 'class="sunday"';
			}
			else if (week == 6) {
				tr_class	= 'class="saturday"';
			} 
		}

		sHtml += '<tr ' + tr_class + '>';
		sHtml += '<td>' + title + '.<span>(' + arr_week[week] + ')</span></td>';
		sHtml += '<td>' + makeCommaStr(in_cnt) + '</td>';
		sHtml += '<td>' + makeCommaStr(out_cnt) + '</td>';
		sHtml += '<td class="txt_white">' + makeCommaStr(tot_cnt) + '</td>';
		sHtml += '</tr>';
		
		if (i < 16) {
			week_0.append(sHtml);
		}
		else {
			week_1.append(sHtml);
		}
	}
	
	$('#monthSummary_0').html(week_0.toString());
	$('#monthSummary_1').html(week_1.toString());
	
	$('#curr_month').html(info.M_CURR_STR);

	$('#prev_month_link').attr('href', 'javascript:searchCallSummaryList(' + info.M_PREV_STR + ')');
	$('#next_month_link').attr('href', 'javascript:searchCallSummaryList(' + info.M_NEXT_STR + ')');
}

function searchCallSummaryList(sch_date) {
	var url = cst.contextPath() + '/dashboard/ajax_call_summary_list.htm';
	var param = { SCH_DATE: sch_date };

	$.getJSON(url, param, function(resp){
		disp_callMonthSummaryList(resp.CALL_MONTH_SUMMARY_LIST, resp.CALL_EXTRA_INFO);
	});

}

/* 차트 생성 */
function createChart_Donut(chart_id, d_series) {
    $("#"+chart_id).kendoChart({
        title: {
        	visible: false,
            position: "bottom"
        },
        legend: {
            visible: false
        },
        chartArea: {
            background: ""
        },
        seriesDefaults: {
            type: "donut"
        },
        series: [{
            overlay: {
                gradient: "none"
            },
            data: d_series,
            labels: {
                visible: true,
                background: "transparent",
                position: "outsideEnd",
              	distance: 15,
            	color: "#f8f8f0",
            	font: "13px sans-serif",
            	template: "#= kendo.format('{0:P}', percentage)#"
            }
        }],
        tooltip: {
            visible: true,
            color: "#f8f8f0",
            template: "#= category # / #= comma(value) #"
        }
    });
}


/* 차트 생성 */
function createChart_Donut_NoLabel(chart_id, d_series) {
    $("#"+chart_id).kendoChart({
        title: {
        	visible: false,
            position: "bottom"
        },
        legend: {
            visible: false
        },
        chartArea: {
            background: ""
        },
        seriesDefaults: {
            type: "donut",
            startAngle: 150
        },
        series: [{
            overlay: {
                gradient: "none"
            },
            data: d_series,
            labels: {
                visible: false,
                background: "transparent",
                position: "center",
            	color: "#f8f8f0",
            	font: "14px sans-serif",
            	align: "circle",
            	template: "#= kendo.format('{0:P}', percentage)#"
            }
        }],
        tooltip: {
            visible: true,
            color: "#f8f8f0",
            template: "#= category # / #= comma(value) #콜"
        }
    });
}


/* 차트 생성 */
function createChart_Donut_Zero(chart_id, d_series) {
    $("#"+chart_id).kendoChart({
        title: {
        	visible: false,
            position: "bottom"
        },
        legend: {
            visible: false
        },
        chartArea: {
            background: ""
        },
        seriesDefaults: {
            type: "donut",
            startAngle: 150
        },
        series: [{
            overlay: {
                gradient: "none"
            },
            data: d_series,
            labels: {
                visible: false,
                background: "transparent",
                position: "center",
            	color: "#f8f8f0",
            	font: "14px sans-serif",
            	align: "circle",
            	template: "#= kendo.format('{0:P}', percentage)#"
            }
        }],
        tooltip: {
            visible: true,
            color: "#f8f8f0",
            template: "#= category # / #= comma(0) #콜"
        }
    });
}

function createChart_callState(chart_id, d_series) {
	$("#"+chart_id).kendoChart({
		legend: {
			visible: false,
			position: "bottom"
		},
		seriesDefaults: {
			type: "line"
		},
		chartArea: {
			background: "#051731"
		},
		series: d_series,
		valueAxis: {
			labels: {
				color: "#74878d",
				format: "{0}"
			},
			majorGridLines: {
				color: "#304355",
				visible: true
			},
			line: {
				visible: true
			},
			axisCrossingValue: 0
		},
		categoryAxis: {
			categories: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23],
			majorGridLines: {
				color: "#304355",
				visible: true
			},
			labels: {
				color: "#74878d",
				format: "{0}"
			}
		},
		tooltip: {
			visible: true,
			format: "{0}%",
			template: "#= series.name # - #= category #시 : #= value #콜",
			color: 'white'
		}
	});
}


function createChart_callState2(chart_id, d_series) {
	$("#"+chart_id).kendoChart({
		legend: {
			visible: false,
			position: "bottom"
		},
		seriesDefaults: {
			type: "line"
		},
		chartArea: {
			background: "#051731"
		},
		series: d_series,
		valueAxis: {
			labels: {
				color: "#74878d",
				format: "{0}"
			},
			majorGridLines: {
				color: "#304355",
				visible: true
			},
			line: {
				visible: true
			},
			axisCrossingValue: 0
		},
		categoryAxis: {
			categories: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23],
			majorGridLines: {
				color: "#304355",
				visible: true
			},
			labels: {
				color: "#74878d",
				format: "{0}"
			}
		},
		tooltip: {
			visible: true,
			format: "{0}%",
			template: "#= series.name # - #= category #시 : #= value #콜",
			color: 'white'
		}
	});
}

function createChart_vgBar(chart_id, d_series) {
    $("#"+chart_id).kendoChart({
        title: {
        	visible: false
        },
        legend: {
            visible: false
        },
		chartArea: {
			background: "#051731"
		},
        seriesDefaults: {
            type: "bar",
            stack: {
                type: "100%"
            }
        },
        series: d_series,
        valueAxis: {
            line: {
                visible: false
            },
            majorGridLines: {
                visible: false
            },
            minorGridLines: {
                visible: false
            },
            labels: {
                rotation: "auto"
            }
        },
        categoryAxis: {
            categories: ["VG"],
            labels: {
            	color: "#ffffff"
            },
            majorGridLines: {
                visible: false
            }
        },
        tooltip: {
            visible: true,
            color: "#ffffff", 
            template: "#= value #"
        }
    });
}


function createChart_stackvgBar3(chart_id, categories, series1, series2) {
    $("#"+chart_id).kendoChart({
        title: {
        	visible: false
        },
        
        series: [{
        	overlay: {
                gradient: "none"
            },
        	name: series1.name,
            data: series1.data,
            color: series1.color
        }, {
        	overlay: {
                gradient: "none"
            },        	
        	name: series2.name,
            data: series2.data,
            color: series2.color
        }],
        legend: {
            visible: false
        },
		chartArea: {
			background: "transparent"
		},
        seriesDefaults: {
            type: "bar", 
            stack: {
                type: "100%"
            },
			labels: {
                visible: true,
                color: 'white',
				
                background: "transparent", 
                template : '#= value #%'
            }
        },
        valueAxis: {
            line: {
                visible: false
            },
            majorGridLines: {
                visible: false
            },
            minorGridLines: {
                visible: false
            },
            labels: {
                rotation: "auto"
            }
        },
        categoryAxis: {
        	categories: categories, 
            labels: {
            	color: "#ffffff"
            },
            majorGridLines: {
                visible: false
            }
        },
        tooltip: {
            visible: true,
            format: "{0}",
            color: "#ffffff", 
            template: "#= value #"
        }
    });
}

function createChart_vgBar2(chart_id, chart_data) {
    $("#"+chart_id).kendoChart({
        title: {
        	visible: false
        },
        dataSource: {
            data: chart_data
        },
        legend: {
            visible: false
        },
		chartArea: {
			background: "transparent"
		},
        seriesDefaults: {
            type: "bar", 
            stack: {
                type: "100%"
            },
			labels: {
                visible: true,
                color: 'white',

                background: "transparent", 
                template : '#= value #%'
            }
        },
        series: [{
            field: "value",
            categoryField: "category",
            colorField: "color"
        }],
        valueAxis: {
            max: 103,
            min: 0,        	
            line: {
                visible: false
            },
            majorGridLines: {
                visible: false
            },
            minorGridLines: {
                visible: false
            },
            labels: {
                rotation: "auto"
            }
        },
        categoryAxis: {
            labels: {
            	color: "#ffffff"
            },
            majorGridLines: {
                visible: false
            }
        },
        tooltip: {
            visible: true,
            format: "{0}",
            color: "#ffffff", 
            template: "#= value #"
        }
    });
}

function createChart_DaepyoBar2(chart_id, chart_data) {
    $("#"+chart_id).kendoChart({
        title: {
        	visible: false
        },
        dataSource: {
            data: chart_data
        },
        legend: {
            visible: false
        },
		chartArea: {
			background: "#051731"
		}, 
		labels: {
        font: "NotoS_R, 굴림, Dotum, tahoma, sans-serif"
        , margin : 0 // { left: -5 }
    	, padding : 0
    	}, 	
        seriesDefaults: {
        	
            type: "bar", 
			labels: {
                visible: true,
                color: 'white',
                background: "transparent", 
                template : '#=comma(value)#%'
            }
        },
        series: [{
            field: "value",
            categoryField: "category",
            colorField: "color"
        }],
        valueAxis: {
            max: 103,
            min: 0,          	
            line: {
                visible: false
            },
            majorGridLines: {
                visible: false
            },
            minorGridLines: {
                visible: false
            },
            labels: {
                rotation: "auto"
            }
        },
        categoryAxis: {
            //categories: ["대표1", "대표2", "대표3", "대표4"],
            labels: {
            	color: "#ffffff"
            },
            majorGridLines: {
                visible: false
            }
        },
        tooltip: {
            visible: true,
            color: "#ffffff", 
            template: "#= value #"
        }
    });
}
function createChart_DaepyoBar(chart_id, d_series) {
    $("#"+chart_id).kendoChart({
        title: {
        	visible: false
        },
        legend: {
            visible: false
        },
		chartArea: {
			background: "#051731"
		},
        seriesDefaults: {
            type: "bar", 
			labels: {
                visible: true,
                color: 'white',
                background: "transparent", 
                template : '#=comma(value)#'
            }
        },
        series: [{
            name: "대표",
            data: d_series
        }],
        valueAxis: {
            line: {
                visible: false
            },
            majorGridLines: {
                visible: false
            },
            minorGridLines: {
                visible: false
            },
            labels: {
                rotation: "auto"
            }
        },
        categoryAxis: {
            categories: ["대표1", "대표2", "대표3", "대표4"],
            labels: {
            	color: "#ffffff"
            },
            majorGridLines: {
                visible: false
            }
        },
        tooltip: {
            visible: true,
            color: "#ffffff", 
            template: "#= value #"
        }
    });
}
//
//
function makeCommaStr(num) {
 	var regexp = /\B(?=(\d{3})+(?!\d))/g;
	return num.toString().replace(regexp, ',');
}
</script>
</head>

<body>
  <!--Wrapper-->
  <div class="wrapper">
    <!--Header-->
    <div class="header">
      <div class="logo fl">
        <a href="/watcher/realtime_stats/component/center_total.htm?menu=mnavi01_01"><img src="/common/dashdaekyo/images/logo.png" alt="대교" /></a>
      </div>
      <div class="title fl">
        <p class="maintit">IPT/IPCC 시스템 현황</p>
      </div>
      <div class="antena fl">
        <img src="/common/dashdaekyo/images/antena01.gif" alt="작동중" />
      </div>
      <!--탭-->
      <div class="tab fl">
        <a id="sysInfo" class="" href="/dashboard/dash_system_info.htm">시스템 현황</a>
        <a id="svcInfo" class="on" href="/dashboard/dash_service_info.htm">서비스 현황</a>
      </div>
      <!--//탭-->
      <div class="date_wrap fr">
        <div class="play_pause mgr16">
          <a id="reload_play" href="javascript:setReloadStart()"><img src="/common/dashdaekyo/images/btn_play.png" alt="play"></a>
          <a id="reload_stop" href="javascript:setReloadStop()"><img src="/common/dashdaekyo/images/btn_pause.png" alt="pause"></a>
        </div>
        <span id="dday"  class="date">2018.01.01(수)</span>
        <span id="dtime" class="time">01:28</span>
        <span id="ampm"  class="time_ap">PM</span>
        <span class="setting"><a href="javascript:openPopup_Setting();"><img src="/common/dashdaekyo/images/btn_setting.png" alt="설정" /></a></span>
      </div>
    </div>
    <!--//Header-->

    <!--Content-->
    <div class="content_wrapper">
      <!-- 그래프 영역 -->
      <div class="graph_wrap fl">
        <div class="col2_wrap mgr20 fl">
          <!-- VG 실시간 사용현황 -->
          <div class="panel vg mgb20">
            <div class="panel_header">
              <p class="p_title fl">실시간 VG 사용현황</p>
              <div class="legend_wrap fr">
                <ul class="legend">
                  <li class="mgr13"><span class="square green"></span>사용</li>
                  <li><span class="square orange"></span>대기</li>
                </ul>              
              </div>
            </div>
            <div class="graph_cicle_wrap">
              <div class="g_cicle br1">
                <div id="chart_vgRealtimeBonsa" style="width: 235px; height: 135px"></div>
                <p class="g_cicle_tit">본사·콜센터</p>
              </div>
              <div class="g_cicle">
                <div id="chart_vgRealtimeJijum" style="width: 234px; height: 135px"></div>
                <p class="g_cicle_tit_r">전국</p>
              </div>
            </div>
            <div class="vg_data_wrap">
              <div class="vg_left_data mgr10">
                <ul>
                  <li>
                    <dl>
                      <dt>전체</dt>
                      <dd id="BonTotCount">0</dd>
                    </dl>
                  </li>
                  <li class="br0">
                    <dl>
                      <dt>사용</dt>
                      <dd id="BonUseCount" class="color_green_l2">0</dd>
                    </dl>
                  </li>
                </ul>
                <div class="vg_left_data_g">
                  <div id="chart_vgRtcntUseBonsa" style="width: 182px; height: 149px"></div>
                </div>
              </div>
              <div class="vg_left_data">
                <ul>
                  <li>
                    <dl>
                      <dt>전체</dt>
                      <dd id="JiTotCount">0</dd>
                    </dl>
                  </li>
                  <li class="br0">
                    <dl>
                      <dt>사용</dt>
                      <dd id="JiUseCount" class="color_green_l2">0</dd>
                    </dl>
                  </li>
                </ul>
                <div class="vg_left_data_g">
                  <div id="chart_vgRtcntUseJijum" style="width: 182px; height: 149px"></div>
                </div>
              </div>
            </div>
          </div>
          <!-- //VG 실시간 사용현황 -->
          
          <!-- 콜사용 현황 (PEAK) -->
          <div class="panel peak">
             <div class="panel_header">
              <p class="p_title fl">콜 사용 현황 (PEAK)</p>
              <div class="legend_wrap fr">
                <ul class="legend">
                  <li class="mgr10"><span class="square blue"></span>본사·콜센터</li>
                  <li><span class="square orange"></span>전국</li>
                </ul>              
              </div>
            </div>
            <div id="chart_callUsePeakGroup" style="width: 471px; height: 125px"></div>
          </div>
          <!-- //콜사용 현황 (PEAK) -->
        </div>
        
        <div class="col2_wrap fl">
          <!-- 실시간 IN·OUT 현황 -->
          <div class="panel in_out mgb20"> 
            <div class="panel_header">
              <p class="p_title fl">실시간 IN·OUT 현황</p>
              <div class="legend_wrap fr">
                  <ul class="legend">
                    <li class="mgr13"><span class="square green"></span>Inbound</li>
                    <li><span class="square orange"></span>Outbound</li>
                  </ul>              
              </div>
            </div>
            <div class="graph_cicle_wrap">
              <div class="g_cicle br1">
                <div id="chart_realtimeInoutBonsa" style="width: 235px; height: 135px"></div>
                <p class="g_cicle_tit">본사·콜센터</p>
              </div>
              <div class="g_cicle">
                <div id="chart_realtimeInoutJijum" style="width: 234px; height: 135px"></div>
                <p class="g_cicle_tit_r">전국</p>
              </div>
            </div>
          </div>
          <!-- //실시간 IN·OUT 현황 -->
          
          <!-- 콜센터 대표번호별 인입현황 -->
          <div class="panel call_in mgb20">
            <div class="panel_header mgb4">
              <p class="p_title fl">콜센터 대표번호별 인입누적현황(금일)</p>
              <div class="legend_wrap fr">
                  <p class="block fr">(%)콜</p>            
              </div>
           
            </div>
            <div class="graph_cicle_wrap">
              <div class="g_cicle">
                <div id="chart_callDaepyoIncallDonut" style="width: 235px; height: 135px"></div>
              </div>
              <div class="g_cicle">
                <div id="chart_callDaepyoIncallBar" style="width: 234px; height: 135px"></div>
              </div>
            </div>
            <!-- <img src="/common/dashdaekyo/images/guide01_05.png" alt="그래프 가이드"> -->
            <div class="call_in_data">
              <ul>
                <li>
                  <dl>
                    <dt><span id="daepyo_name_0">대표번호1</span> <br><span id="daepyo_num_0">0000-0000</span></dt>
                    <dd><span id="daepyo_per_0">0</span>% / <span id="daepyo_val_0" class="f13">0</span></dd>
                  </dl>
                </li>
                <li>
                  <dl>
                    <dt><span id="daepyo_name_1">대표번호2</span> <br><span id="daepyo_num_1">0000-0000</span></dt>
                    <dd><span id="daepyo_per_1">0</span>% / <span id="daepyo_val_1" class="f13">0</span></dd>
                  </dl>
                </li>
                <li>
                  <dl>
                    <dt><span id="daepyo_name_2">대표번호3</span> <br><span id="daepyo_num_2">0000-0000</span></dt>
                    <dd><span id="daepyo_per_2">0</span>% / <span id="daepyo_val_2" class="f13">0</span></dd>
                  </dl>
                </li>
                <li>
                  <dl>
                    <dt><span id="daepyo_name_3">대표번호4</span> <br><span id="daepyo_num_3">0000-0000</span></dt>
                    <dd><span id="daepyo_per_3">0</span>% / <span id="daepyo_val_3" class="f13">0</span></dd>
                  </dl>
                </li>
              </ul>
            </div>  
          </div>
          <!-- //콜센터 대표번호별 인입현황 -->
          
          <!-- 콜 누적 현황 -->         
          <div class="panel call_cumu">
            <div class="panel_header">
              <p class="p_title fl">콜 사용 현황 (누적)</p>
              <div class="legend_wrap fr">
                  <ul class="legend">
                    <li class="mgr10"><span class="square blue"></span>본사·콜센터</li>
                    <li><span class="square orange"></span>전국</li>
                  </ul>              
              </div>
            </div>
            <div id="chart_callNowSummaryState" style="width: 471px; height: 125px"></div>         
          </div>   
          <!-- //콜 누적 현황 -->          
        </div>
      </div>
      <!-- //그래프 영역 -->

      <!-- 콜현황 영역 -->
      <div class="callboard_wrap fl">
        <!-- 지점, 본사, 콜센터 탭 -->
        <div class="call_situation">
          <p class="p_title">콜 현황</p>
          <div id="wdg_scroller_tab" class="webwidget_scroller_tab call_data">
           <div class="tabContainer">
              <ul class="tabHead mgb9">
                <li class="currentBtn"><a href="javascript:;">전국</a></li>
                <li><a href="javascript:;">본사</a></li>
                <li><a href="javascript:;">콜센터</a></li>
              </ul>
            </div>
            <div class="tabBody">
             <ul id="call_status">
              <li class="panel_dwm">
                <div class="p_day">
                  <p class="dwm_tit">금일 <span id="JI_NOW">(01.01)</span></p>
                  <ul class="bb0">
                     <li>
                       <dl>
                          <dt class="blue">In</dt>
                          <dd id="JI_D_IN">0</dd>
                       </dl>
                     </li>
                     <li>
                       <dl>
                          <dt class="orange">Out</dt>
                          <dd id="JI_D_OUT">0</dd>
                       </dl>
                     </li>
                     <li>
                       <dl>
                          <dt class="blue_r">Total</dt>
                          <dd id="JI_D_TOT">0</dd>
                       </dl>
                     </li>
                   </ul>
                </div>
                <div class="p_week">
                 <p class="dwm_tit">주간 <span id="JI_WEEK">(01.01~01.07)</span></p>
                  <ul class="bb0">
                     <li>
                       <dl>
                          <dt class="blue">In</dt>
                          <dd id="JI_W_IN">0</dd>
                       </dl>
                     </li>
                     <li>
                       <dl>
                          <dt class="orange">Out</dt>
                          <dd id="JI_W_OUT">0</dd>
                       </dl>
                     </li>
                     <li>
                       <dl>
                          <dt class="blue_r">Total</dt>
                          <dd id="JI_W_TOT">0</dd>
                       </dl>
                     </li>
                   </ul>

                </div>
                <div class="p_month">
                   <p class="dwm_tit">월간 <span id="JI_MONTH">(01.01~01.31)</span></p>
                  <ul class="bb0">
                     <li>
                       <dl>
                          <dt class="blue">In</dt>
                          <dd id="JI_M_IN">0</dd>
                       </dl>
                     </li>
                     <li>
                       <dl>
                          <dt class="orange">Out</dt>
                          <dd id="JI_M_OUT">0</dd>
                       </dl>
                     </li>
                     <li>
                       <dl>
                          <dt class="blue_r">Total</dt>
                          <dd id="JI_M_TOT">0</dd>
                       </dl>
                     </li>
                   </ul>
                </div>
              </li>
              
              <li class="panel_dwm">
                <div class="p_day">
                  <p class="dwm_tit">금일 <span id="BO_NOW">(01.01)</span></p>
                  <ul class="bb0">
                     <li>
                       <dl>
                          <dt class="blue">In</dt>
                          <dd id="BO_D_IN">0</dd>
                       </dl>
                     </li>
                     <li>
                       <dl>
                          <dt class="orange">Out</dt>
                          <dd id="BO_D_OUT">0</dd>
                       </dl>
                     </li>
                     <li>
                       <dl>
                          <dt class="blue_r">Total</dt>
                          <dd id="BO_D_TOT">0</dd>
                       </dl>
                     </li>
                   </ul>
                </div>
                <div class="p_week">
                 <p class="dwm_tit">주간 <span id="BO_WEEK">(01.01~01.07)</span></p>
                  <ul class="bb0">
                     <li>
                       <dl>
                          <dt class="blue">In</dt>
                          <dd id="BO_W_IN">0</dd>
                       </dl>
                     </li>
                     <li>
                       <dl>
                          <dt class="orange">Out</dt>
                          <dd id="BO_W_OUT">0</dd>
                       </dl>
                     </li>
                     <li>
                       <dl>
                          <dt class="blue_r">Total</dt>
                          <dd id="BO_W_TOT">0</dd>
                       </dl>
                     </li>
                   </ul>

                </div>
                <div class="p_month">
                   <p class="dwm_tit">월간 <span id="BO_MONTH">(01.01~01.31)</span></p>
                  <ul class="bb0">
                     <li>
                       <dl>
                          <dt class="blue">In</dt>
                          <dd id="BO_M_IN">0</dd>
                       </dl>
                     </li>
                     <li>
                       <dl>
                          <dt class="orange">Out</dt>
                          <dd id="BO_M_OUT">0</dd>
                       </dl>
                     </li>
                     <li>
                       <dl>
                          <dt class="blue_r">Total</dt>
                          <dd id="BO_M_TOT">0</dd>
                       </dl>
                     </li>
                   </ul>
                </div>
              </li>
              
              <li class="panel_dwm">
                <div class="p_day">
                  <p class="dwm_tit">금일 <span id="CC_NOW">(01.01)</span></p>
                  <ul class="bb0">
                     <li>
                       <dl>
                          <dt class="blue">In</dt>
                          <dd id="CC_D_IN">0</dd>
                       </dl>
                     </li>
                     <li>
                       <dl>
                          <dt class="orange">Out</dt>
                          <dd id="CC_D_OUT">0</dd>
                       </dl>
                     </li>
                     <li>
                       <dl>
                          <dt class="blue_r">Total</dt>
                          <dd id="CC_D_TOT">0</dd>
                       </dl>
                     </li>
                   </ul>
                </div>
                <div class="p_week">
                 <p class="dwm_tit">주간 <span id="CC_WEEK">(01.01~01.07)</span></p>
                  <ul class="bb0">
                     <li>
                       <dl>
                          <dt class="blue">In</dt>
                          <dd id="CC_W_IN">0</dd>
                       </dl>
                     </li>
                     <li>
                       <dl>
                          <dt class="orange">Out</dt>
                          <dd id="CC_W_OUT">0</dd>
                       </dl>
                     </li>
                     <li>
                       <dl>
                          <dt class="blue_r">Total</dt>
                          <dd id="CC_W_TOT">0</dd>
                       </dl>
                     </li>
                   </ul>

                </div>
                <div class="p_month">
                   <p class="dwm_tit">월간 <span id="CC_MONTH">(01.01~01.31)</span></p>
                  <ul class="bb0">
                     <li>
                       <dl>
                          <dt class="blue">In</dt>
                          <dd id="CC_M_IN">0</dd>
                       </dl>
                     </li>
                     <li>
                       <dl>
                          <dt class="orange">Out</dt>
                          <dd id="CC_M_OUT">0</dd>
                       </dl>
                     </li>
                     <li>
                       <dl>
                          <dt class="blue_r">Total</dt>
                          <dd id="CC_M_TOT">0</dd>
                       </dl>
                     </li>
                   </ul>
                </div>
              </li>
             </ul>             
           </div>
          </div>
         
        </div>
        <!-- //지점, 본사, 콜센터 탭 -->
        
        <!-- 달력 -->
        <div class="call_calendar">
          <div class="date">
             <a id="prev_month_link" href="#" class="arrow_l"><img src="/common/dashdaekyo/images/btn_c_left.png"></a>
             <span id="curr_month">2018.01</span>
             <a id="next_month_link" href="#" class="arrow_r"><img src="/common/dashdaekyo/images/btn_c_right.png"></a>
          </div>           
          <!-- 달력 데이블 -->
          <div class="cal_table_wrap">
            <div class="tbl_l mgr10">
               <table cellspacing="0" border="0" summary="달력 테이블 니다." class="tbl_type1 bor_type1">
                  <caption>달력</caption>
                  <colgroup>
                    <col width="80px">
                    <col width="95px">
                    <col width="95px">
                    <col width="95px">
                  </colgroup>
                  <thead>
                    <tr>
                      <th scope="col" class="bg_navy">날짜</th>
                      <th scope="col" >Inbound</th>
                      <th scope="col">Outbound</th>
                      <th scope="col">Total</th>
                    </tr>
                  </thead>
                  <tbody id="monthSummary_0"> </tbody>
                </table>
            </div>
            <div class="tbl_r">
               <table cellspacing="0" border="0" summary="달력 테이블 입니다." class="tbl_type1 bor_type1">
                  <caption>달력</caption>
                  <colgroup>
                    <col width="80px">
                    <col width="95px">
                    <col width="95px">
                    <col width="95px">
                  </colgroup>
                  <thead>
                    <tr>
                      <th scope="col" class="bg_navy">날짜</th>
                      <th scope="col" >Inbound</th>
                      <th scope="col">Outbound</th>
                      <th scope="col">Total</th>
                    </tr>
                  </thead>
                  <tbody id="monthSummary_1"></tbody>
                </table>
            </div>
          </div>   
             <div class="legend_wrap fr">
                <ul class="legend">
                  <li class="mgr10"></span>- 전체 통화량(내선 포함) 통계</li>
                </ul>              
             </div>
          <!-- //달력 데이블 -->
        </div>
        <!-- //달력 -->
      </div>
      <!-- //콜현황 영역 -->
      
      <!--//Content-->
    </div>
  </div>
  <!--//Wrapper -->
</body>

</html>