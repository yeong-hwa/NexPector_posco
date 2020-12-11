<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript">

	var pMonId = '${param.N_MON_ID}';

	$(document).ready(function () {
		initialize();
	});

	function initialize() {
		fn_data_polling();
		setInterval(fn_data_polling, 10000);
	}

	function fn_data_polling() {

		$.ajax({
			url		: cst.contextPath() + '/watcher/server_detail/temp_humidity/temp_humidity_info.htm',
			type	: "post",
			data	: { 'N_MON_ID' : pMonId },
			dataType: "json",
			success: function (RES) {

				if (RES.CURRENT_STATUS != null && RES.CURRENT_STATUS.N_MON_ID != null) {

					var oper_status = parseInt(RES.CURRENT_STATUS.S_OPERATION_STATUS);
					if (oper_status === 2) {
						// 운전2
						$("#oper_status").empty().html('<img src="' + cst.contextPath() + '/common/images/watcher/temp_on.jpg" alt="운전 중"/>');
					} else {
						// 정지1
						$("#oper_status").empty().html('<img src="' + cst.contextPath() + '/common/images/watcher/temp_off.jpg" alt="정지"/>');
					}

					$("#now_temp").text(fn_empty(RES.CURRENT_STATUS.N_NOW_TEMPERATURE));
					$("#now_humid").text(fn_empty(RES.CURRENT_STATUS.N_NOW_HUMIDITY));
					$("#set_temp").text(fn_empty(RES.CURRENT_STATUS.N_SET_TEMPERATURE));
					$("#set_humid").text(fn_empty(RES.CURRENT_STATUS.N_SET_HUMIDITY));
					$("#total_alarm").text(fn_empty(RES.CURRENT_STATUS.S_TOTAL_ALARM));
					$("#system_up_time").text(fn_empty(RES.CURRENT_STATUS.N_SYSTEM_UP_TIME));
				}

				if (RES.OPERATION_STATUS != null && RES.OPERATION_STATUS.N_MON_ID != null) {
					var fan_oper = parseInt(RES.OPERATION_STATUS.S_FAN_STATUS);
					if (fan_oper == 1) {
						// 동작1
						$("#fan_oper").find('img').attr({src : cst.contextPath() + '/images/watcher/tmp_switch_on.png', alt : '송풍기 동작'});
					} else {
						// 정지0
						$("#fan_oper").find('img').attr({src : cst.contextPath() + '/images/watcher/tmp_switch_off.png', alt : '송풍기 정지'});
					}

					var cool_oper = parseInt(RES.OPERATION_STATUS.S_COOLER_STATUS);
					if (cool_oper == 1) {
						// 동작1
						$("#cool_oper").find('img').attr({src : cst.contextPath() + '/images/watcher/tmp_switch_on.png', alt : '냉방 동작'});
					} else {
						// 정지0
						$("#cool_oper").find('img').attr({src : cst.contextPath() + '/images/watcher/tmp_switch_off.png', alt : '냉방 정지'});
					}

					var heater_oper = parseInt(RES.OPERATION_STATUS.S_HEATER_STATUS);
					if (heater_oper == 1) {
						// 동작1
						$("#hot_oper").find('img').attr({src : cst.contextPath() + '/images/watcher/tmp_switch_on.png', alt : '난방 동작'});
					} else {
						// 정지0
						$("#hot_oper").find('img').attr({src : cst.contextPath() + '/images/watcher/tmp_switch_off.png', alt : '난방 정지'});
					}

					var humid_oper = parseInt(RES.OPERATION_STATUS.S_HUMIDIFIER_STATUS);
					if (humid_oper == 1) {
						// 동작1
						$("#humid_oper").find('img').attr({src : cst.contextPath() + '/images/watcher/tmp_switch_on.png', alt : '가습 동작'});
					} else {
						// 정지0
						$("#humid_oper").find('img').attr({src : cst.contextPath() + '/images/watcher/tmp_switch_off.png', alt : '가습 정지'});
					}

					var dehumid_oper = parseInt(RES.OPERATION_STATUS.S_DEHUMIDIFIER_STATUS);
					if (dehumid_oper == 1) {
						// 동작1
						$("#nohumid_oper").find('img').attr({src : cst.contextPath() + '/images/watcher/tmp_switch_on.png', alt : '제습 동작'});
					} else {
						// 정지0
						$("#nohumid_oper").find('img').attr({src : cst.contextPath() + '/images/watcher/tmp_switch_off.png', alt : '제습 정지'});
					}
				}

				if (RES.ALARM_STATUS != null && RES.ALARM_STATUS.N_MON_ID != null) {
					var main_fan_alarm = RES.ALARM_STATUS.S_MAIN_FAN_ALARM;
					if (main_fan_alarm === "unknown") {
						// UNKNOWN
						$("#main_fan_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/gray.jpg', alt : '메인팬 UNKNOWN'});
					} else if(main_fan_alarm === "normal") {
						// 정상
						$("#main_fan_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/green.jpg', alt : '메인팬 정상'});
					} else {
						// 경보 => alarm
						$("#main_fan_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/red.jpg', alt : '메인팬 경보'});
					}

					var leak_alarm = RES.ALARM_STATUS.S_LEAK_ALARM;
					if (leak_alarm === "unknown") {
						// UNKNOWN
						$("#leak_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/gray.jpg', alt : '누수 UNKNOWN'});
					} else if(leak_alarm === "normal") {
						// 정상
						$("#leak_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/green.jpg', alt : '누수 정상'});
					} else {
						// 경보 => alarm
						$("#leak_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/red.jpg', alt : '누수 경보'});
					}

					var heater_alarm = RES.ALARM_STATUS.S_HEATER_ALARM;
					if (heater_alarm === "unknown") {	
						// UNKNOWN
						$("#heater_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/gray.jpg', alt : '히터 UNKNOWN'});
					} else if(heater_alarm === "normal") {
						// 정상
						$("#heater_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/green.jpg', alt : '히터 정상'});
					} else {
						// 경보 => alarm
						$("#heater_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/red.jpg', alt : '히터 경보'});
					}

					var humid_alarm = RES.ALARM_STATUS.S_HUMIDIFIER_ALARM;
					if (humid_alarm === "unknown") {	
						// UNKNOWN
						$("#humidifier_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/gray.jpg', alt : '가습기 UNKNOWN'});
					} else if(humid_alarm === "normal") {
						// 정상
						$("#humidifier_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/green.jpg', alt : '가습기 정상'});
					} else {
						// 경보 => alarm
						$("#humidifier_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/red.jpg', alt : '가습기 경보'});
					}

					var temp_alarm = RES.ALARM_STATUS.S_TEMPERATURE_ALARM;
					if (temp_alarm === "unknown") {
						// UNKNOWN
						$("#temp_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/gray.jpg', alt : '온도 UNKNOWN'});
					} else if(temp_alarm === "normal") {
						// 정상
						$("#temp_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/green.jpg', alt : '온도 정상'});
					} else {
						// 경보 => alarm
						$("#temp_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/red.jpg', alt : '온도 경보'});
					}

					var humidity_alarm = RES.ALARM_STATUS.S_HUMIDITY_ALARM;
					if (humidity_alarm === "unknown") {
						// UNKNOWN
						$("#humi_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/gray.jpg', alt : '습도 UNKNOWN'});
					} else if(humidity_alarm === "normal") {
						// 정상
						$("#humi_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/green.jpg', alt : '습도 정상'});
					} else {
						// 경보 => alarm
						$("#humi_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/red.jpg', alt : '습도 경보'});
					}

					var comp1_over_alarm = RES.ALARM_STATUS.S_COMP1_OVERCUR_ALARM;
					if (comp1_over_alarm === "unknown") {
						// UNKNOWN
						$("#comp1_over_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/gray.jpg', alt : '압축기1 과전류 UNKNOWN'});
					} else if(comp1_over_alarm === "normal") {
						// 정상
						$("#comp1_over_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/green.jpg', alt : '압축기1 과전류 정상'});
					} else {
						// 경보 => alarm
						$("#comp1_over_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/red.jpg', alt : '압축기1 과전류 경보'});
					}

					var comp1_low_alarm = RES.ALARM_STATUS.S_COMP1_LOWPRESSURE_ALARM;
					if (comp1_low_alarm === "unknown") {
						// UNKNOWN
						$("#comp1_low_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/gray.jpg', alt : '압축기1 저압 UNKNOWN'});
					} else if(comp1_low_alarm === "normal") {
						// 정상
						$("#comp1_low_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/green.jpg', alt : '압축기1 저압 정상'});
					} else {
						// 경보 => alarm
						$("#comp1_low_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/red.jpg', alt : '압축기1 저압 경보'});
					}

					var comp1_high_alarm = RES.ALARM_STATUS.S_COMP1_HIGHPRESSURE_ALARM;
					if (comp1_high_alarm === "unknown") {
						// UNKNOWN
						$("#comp1_high_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/gray.jpg', alt : '압축기1 고압 UNKNOWN'});
					} else if(comp1_high_alarm === "normal") {
						// 정상
						$("#comp1_high_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/green.jpg', alt : '압축기1 고압 정상'});
					} else {
						// 경보 => alarm
						$("#comp1_high_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/red.jpg', alt : '압축기1 고압 경보'});
					}

					var comp2_over_alarm = RES.ALARM_STATUS.S_COMP2_OVERCUR_ALARM;
					if (comp2_over_alarm === "unknown") {
						// UNKNOWN
						$("#comp2_overcur_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/gray.jpg', alt : '압축기2 과전류 UNKNOWN'});
					} else if(comp2_over_alarm === "normal") {
						// 정상
						$("#comp2_overcur_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/green.jpg', alt : '압축기2 과전류 정상'});
					} else {
						// 경보 => alarm
						$("#comp2_overcur_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/red.jpg', alt : '압축기2 과전류 경보'});
					}

					var comp2_high_alarm = RES.ALARM_STATUS.S_COMP2_HIGHPRESSURE_ALARM;
					if (comp2_high_alarm === "unknown") {
						// UNKNOWN
						$("#comp2_high_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/gray.jpg', alt : '압축기2 고압 UNKNOWN'});
					} else if(comp2_high_alarm === "normal") {
						// 정상
						$("#comp2_high_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/green.jpg', alt : '압축기2 고압 정상'});
					} else {
						// 경보 => alarm
						$("#comp2_high_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/red.jpg', alt : '압축기2 고압 경보'});
					}

					var comp2_low_alarm = RES.ALARM_STATUS.S_COMP2_LOWPRESSURE_ALARM;
					if (comp2_low_alarm === "unknown") {
						// UNKNOWN
						$("#comp2_low_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/gray.jpg', alt : '압축기2 저압 UNKNOWN'});
					} else if(comp2_low_alarm === "normal") {
						// 정상
						$("#comp2_low_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/green.jpg', alt : '압축기2 저압 정상'});
					} else {
						// 경보 => alarm
						$("#comp2_low_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/red.jpg', alt : '압축기2 저압 경보'});
					}

					var out_fan1_over_alarm = RES.ALARM_STATUS.S_OUTDOOR_FAN1_OVERCUR_ALARM;
					if (out_fan1_over_alarm === "unknown") {
						// UNKNOWN
						$("#fan1_over_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/gray.jpg', alt : '실외기팬1 과전류 UNKNOWN'});
					} else if(out_fan1_over_alarm === "normal") {
						// 정상
						$("#fan1_over_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/green.jpg', alt : '실외기팬1 과전류 정상'});
					} else {
						// 경보 => alarm
						$("#fan1_over_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/red.jpg', alt : '실외기팬1 과전류 경보'});
					}

					var out_fan2_over_alarm = RES.ALARM_STATUS.S_OUTDOOR_FAN2_OVERCUR_ALARM;
					if (out_fan2_over_alarm === "unknown") {
						// UNKNOWN
						$("#fan2_over_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/gray.jpg', alt : '실외기팬2 과전류 UNKNOWN'});
					} else if(out_fan2_over_alarm === "normal") {
						// 정상
						$("#fan2_over_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/green.jpg', alt : '실외기팬2 과전류 정상'});
					} else {
						// 경보 => alarm
						$("#fan2_over_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/red.jpg', alt : '실외기팬2 과전류 경보'});
					}

					var net_conn_alarm = RES.ALARM_STATUS.S_NET_CONNECTION_ALARM;
					if (net_conn_alarm === "unknown") {
						// 경보2
						$("#not_conn_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/gray.jpg', alt : '통신 UNKNOWN'});
					} else if(net_conn_alarm === "normal") {
						// 정상
						$("#not_conn_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/green.jpg', alt : '통신 정상'});
					} else {
						// 경보 => alarm
						$("#not_conn_alarm").find('img').attr({src : cst.contextPath() + '/images/watcher/red.jpg', alt : '통신 경보'});
					}
				}
			},
			error: function (res, error) {
				// alert("에러가 발생했습니다."+error);
			}
		});

	}

	function fn_empty(value) {
		if (!value) {
			return "";
		}
		return value;
	}

</script>

<!-- contents-->
<div class="voltage_area">
	<div class="pdr20">
		<div class="hangon_box1">
			<!-- stitle -->
			<div class="hangon_stitle">
				<div class="st_under"><h4>현재 상태</h4></div>
			</div>
			<!-- stitle // -->
			<!--s-contents-->
			<table class="hangon_bgtable1" cellpadding="0" cellspacing="0">
				<tr>
					<td class="bgtl1"></td>
					<td class="bgtc1"></td>
					<td class="bgtr1"></td>
				</tr>
				<tr>
					<td class="bgml1"></td>
					<td class="bgmc1">
						<span id="oper_status"><img src="<c:url value="/images/watcher/temp_on.jpg"/>" alt="항온항습계 이미지" /></span>
						<ul>
							<li class="h-filed1">&nbsp;현재 온도</li>
							<li class="h-filed2"><span id="now_temp">0</span></li>
							<li class="h-filed3">℃</li>
							<li class="h-filed1">&nbsp;현재 습도</li>
							<li class="h-filed2"><span id="now_humid">0</span></li>
							<li class="h-filed3">%</li>
							<li class="h-filed1">&nbsp;설정 온도</li>
							<li class="h-filed2"><span id="set_temp">0</span></li>
							<li class="h-filed3">℃</li>
							<li class="h-filed1">&nbsp;설정 습도</li>
							<li class="h-filed2"><span id="set_humid">0</span></li>
							<li class="h-filed3">%</li>
							<li class="h-filed1">&nbsp;종합경보발생</li>
							<li class="h-filed2"><span id="total_alarm">정상</span></li>
							<li class="h-filed3"></li>
							<li class="h-filed1">&nbsp;시스템 운전시간</li>
							<li class="h-filed2"><span id="system_up_time">0</span></li>
							<li class="h-filed3">시간</li>
						</ul>
					</td>
					<td class="bgmr1"></td>
				</tr>
				<tr>
					<td class="bgbl1"></td>
					<td class="bgbc1"></td>
					<td class="bgbr1"></td>
				</tr>
			</table>
			<!--s-contents //-->
		</div>
		<div class="hangon_box1" style="float:right;">
			<!-- stitle -->
			<div class="hangon_stitle">
				<div class="st_under"><h4>운전 상태</h4></div>
			</div>
			<!-- stitle // -->
			<!--s-contents-->
			<table class="hangon_bgtable1" cellpadding="0" cellspacing="0">
				<tr>
					<td class="bgtl1"></td>
					<td class="bgtc1"></td>
					<td class="bgtr1"></td>
				</tr>
				<tr>
					<td class="bgml1"></td>
					<td class="bgmc1">
						<span class="on_off" id="fan_oper">
							<strong>송풍기</strong>
							<img src="<c:url value="/images/watcher/tmp_switch_off.png"/>" alt="" />
						</span>
						<span class="on_off" id="hot_oper">
							<strong>난방</strong>
							<img src="<c:url value="/images/watcher/tmp_switch_off.png"/>" alt="" />
						</span>
						<span class="on_off" id="cool_oper">
							<strong>냉방</strong>
							<img src="<c:url value="/images/watcher/tmp_switch_off.png"/>" alt="" />
						</span>
						<span class="on_off" id="humid_oper">
							<strong>가습</strong>
							<img src="<c:url value="/images/watcher/tmp_switch_off.png"/>" alt="" />
						</span>
						<span class="on_off" id="nohumid_oper">
							<strong>제습</strong>
							<img src="<c:url value="/images/watcher/tmp_switch_off.png"/>" alt="" />
						</span>
					</td>
					<td class="bgmr1"></td>
				</tr>
				<tr>
					<td class="bgbl1"></td>
					<td class="bgbc1"></td>
					<td class="bgbr1"></td>
				</tr>
			</table>
			<!--s-contents //-->
		</div>
		<div class="hangon_box2">
			<!-- stitle -->
			<div class="hangon_stitle">
				<div class="st_under"><h4>경보 상태</h4></div>
			</div>
			<!-- stitle // -->
			<!--s-contents-->
			<table class="hangon_bgtable2" cellpadding="0" cellspacing="0">
				<tr>
					<td class="bgtl1"></td>
					<td class="bgtc1"></td>
					<td class="bgtr1"></td>
				</tr>
				<tr>
					<td class="bgml1"></td>
					<td class="bgmc1">
						<span class="on_off" id="main_fan_alarm">
							<strong>메인펜<br/>과전류</strong>
							<img src="<c:url value="/images/watcher/green.jpg"/>" alt="" />
						</span>
						<span class="on_off" id="leak_alarm">
							<strong style="padding: 0 0 39px 0px;">누수</strong>
							<img src="<c:url value="/images/watcher/green.jpg"/>" alt="" />
						</span>
						<span class="on_off" id="heater_alarm">
							<strong style="padding: 0 0 39px 0px;">히터</strong>
							<img src="<c:url value="/images/watcher/green.jpg"/>" alt="" />
						</span>
						<span class="on_off" id="humidifier_alarm">
							<strong style="padding: 0 0 39px 0px;">가습기</strong>
							<img src="<c:url value="/images/watcher/green.jpg"/>" alt="" />
						</span>
						<span class="on_off" id="temp_alarm">
							<strong style="padding: 0 0 39px 0px;">온도</strong>
							<img src="<c:url value="/images/watcher/green.jpg"/>" alt="" />
						</span>
						<span class="on_off" id="humi_alarm">
							<strong style="padding: 0 0 39px 0px;">습도</strong>
							<img src="<c:url value="/images/watcher/green.jpg"/>" alt="" />
						</span>
						<span class="on_off" id="comp1_over_alarm">
							<strong>압축기#1<br/>과전류</strong>
							<img src="<c:url value="/images/watcher/green.jpg"/>" alt="" />
						</span>
						<span class="on_off" id="comp1_low_alarm">
							<strong>압축기#1<br/>저압</strong>
							<img src="<c:url value="/images/watcher/green.jpg"/>" alt="" />
						</span>
						<span class="on_off" id="comp1_high_alarm">
							<strong>압축기#1<br/>고압</strong>
							<img src="<c:url value="/images/watcher/green.jpg"/>" alt="" />
						</span>
						<span class="on_off" id="comp2_overcur_alarm">
							<strong>압축기#2<br/>과전류</strong>
							<img src="<c:url value="/images/watcher/green.jpg"/>" alt="" />
						</span>
						<span class="on_off" id="comp2_low_alarm">
							<strong>압축기#2<br/>저압</strong>
							<img src="<c:url value="/images/watcher/green.jpg"/>" alt="" />
						</span>
						<span class="on_off" id="comp2_high_alarm">
							<strong>압축기#2<br/>고압</strong>
							<img src="<c:url value="/images/watcher/green.jpg"/>" alt="" />
						</span>
						<span class="on_off" id="fan1_over_alarm">
							<strong>실외기팬#1 과전류</strong>
							<img src="<c:url value="/images/watcher/green.jpg"/>" alt="" />
						</span>
						<span class="on_off" id="fan2_over_alarm">
							<strong>실외기팬#2 과전류</strong>
							<img src="<c:url value="/images/watcher/green.jpg"/>" alt="" />
						</span>
						<span class="on_off" id="not_conn_alarm">
							<strong style="padding: 0 0 39px 0px;">통신경보</strong>
							<img src="<c:url value="/images/watcher/green.jpg"/>" alt="" />
						</span>
					</td>
					<td class="bgmr1"></td>
				</tr>
				<tr>
					<td class="bgbl1"></td>
					<td class="bgbc1"></td>
					<td class="bgbr1"></td>
				</tr>
			</table>
			<!--s-contents //-->
		</div>
	</div>
</div>
<!-- contents //-->