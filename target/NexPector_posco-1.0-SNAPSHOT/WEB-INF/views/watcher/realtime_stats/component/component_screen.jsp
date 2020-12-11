<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="locationBox"><div class="st_under"><h2>실시간 통계</h2><span>Home &gt; 실시간 통계</span></div></div>

<!-- 내용 -->
<div class="table_div">
	<c:choose>
		<c:when test="${N_GROUP_CODE == 0}"> <!-- 전체현황 -->
			<!-- 장비현황 Map -->
			<div id="apDiv_map" name="compo">
				<div>
					<div class="stitleBox" style="float: none; height: 25px">
						<div class="st_under">
							<h3 id="map_title">센터 전체 현황</h3>
							<span id="memo" style="margin-top: 10px;display: block;">(장비수량/장애수량)</span>
						</div>
					</div>
					<div id="map_area"></div>
				</div>
				<!-- 실시간 장애 현황 -->
				<div id="apDiv8" name="compo">
					<div class="stitleBox" style="float: none;">
						<div class="st_under" style="height: 30px;">
							<h3>시스템 장애 현황</h3>
							<span style="right: 300px;">센터 :<cmb:combo qryname="cmb_svr_group" firstdata="전체" seltagname="ERR_STATS_N_GROUP_CODE" etc="style=\"width:80;\"" selvalue="${param.N_GROUP_CODE}"/></span>
							<span style="right: 110px;">장비타입 :<cmb:combo qryname="cmb_svr_type" firstdata="전체" seltagname="ERR_STATS_N_TYPE_CODE" etc="style=\"width:80;\"" selvalue="${param.N_TYPE_CODE}"/></span>
							<span style="right: 0px;"><button type="button" id="btnMulti" style="margin-right: 15px;">다중복구</button></span>
						</div>
					</div>
					<div id="real_time_error" class="table_typv1"></div>
				</div>
			</div>
		</c:when>
		<c:when test="${page ne null and page eq 'detail' }"> <!-- 감시장비 상세현황 -->
			<!-- 장비현준황 Map -->
			<div id="apDiv_map" name="compo">
				<div>
					<div class="stitleBox" style="float: none; height: 25px">
						<div class="st_under">
							<h3 id="map_title">센터 현황 - ${S_GROUP_NAME}</h3>
						</div>
					</div>

					<!-- 검색영역 -->
					<div id="server_detail_search" class="history_search_v1" style="float: none;">
						<div>
							<ul>
								<li class="leftbg">
									<!-- 검색항목 -->
									<dl>
										<dd>
											<strong style="display:inline-block; padding-top:5px;">
												<img src="<c:url value="/images/watcher/search_title.gif"/>" alt="검색조건" />
											</strong>
											<strong style="display:inline-block; width:30px;">센터</strong>
											<cmb:combo qryname="cmb_svr_group" seltagname="N_GROUP_CODE" firstdata="전체" firstval="-1" etc="id=\"search_svr_dtl_group_code\" style=\"width:100px;\"" selvalue="${param.N_GROUP_CODE}"/>
											<strong style="display:inline-block; width:60px; margin-left:20px;">장비타입</strong>
											<cmb:combo qryname="cmb_svr_type" seltagname="N_TYPE_CODE" firstdata="전체" etc="id=\"search_svr_dtl_type_code\" style=\"width:100px;\"" selvalue="${param.N_TYPE_CODE}"/>
											<strong style="display:inline-block; width:40px; margin-left:20px;">장비명</strong>
											<input type="text" name="" id="search_svr_dtl_mon_name" class="int_f" size="20"/>
											<strong style="display:inline-block; width:50px; margin-left:20px;">장비IP</strong>
											<input type="text" name="" id="search_svr_dtl_mon_ip" class="int_f" size="20"/>
										</dd>
									</dl>
									<!-- 검색항목 // -->
									<!-- 버튼 -->
									<span class="his_search_bt"><a href="#" onclick="searchSvrDtlMonitoring(); return false;"><img src="<c:url value="/images/botton/search_1.jpg"/>" alt="검색" /></a></span>
									<!-- 버튼 // -->
								</li>
								<li class="rightbg">&nbsp;</li>
							</ul>
						</div>
					</div>
					<!-- 검색영역 //-->

					<div id="server_detail_area" class="table_typv2" style="float:none;margin-top: 10px;">
					</div>

				</div>
				<!-- 실시간 장애 현황 -->
				<div id="apDiv8" name="compo">
					<div class="stitleBox" style="float: none;">
						<div class="st_under" style="height: 30px;">
							<h3>시스템 장애 현황</h3>
							<span style="right: 300px;">센터 :<cmb:combo qryname="cmb_svr_group" firstdata="전체" seltagname="ERR_STATS_N_GROUP_CODE" etc="style=\"width:80;\"" selvalue="${param.N_GROUP_CODE}"/></span>
							<span style="right: 110px;">장비타입 :<cmb:combo qryname="cmb_svr_type" firstdata="전체" seltagname="ERR_STATS_N_TYPE_CODE" etc="style=\"width:80;\"" selvalue="${param.N_TYPE_CODE}"/></span>
							<button type="button" id="btnMulti" style="margin-right: 15px;">다중복구</button>
						</div>
					</div>
					<div id="real_time_error" class="table_typv1"></div>
				</div>
			</div>
		</c:when>
		<c:otherwise> <!-- 센터별 현황 -->
			<!-- 실시간 장애 현황 -->
			<div id="apDiv8" name="compo" style="margin-bottom: 10px;">
				<div class="stitleBox" style="float: none;">
					<div class="st_under" style="height: 30px;">
						<h3>시스템 장애 현황</h3>
						<span style="right: 110px;">장비타입 :<cmb:combo qryname="cmb_svr_type" firstdata="전체" seltagname="ERR_STATS_N_TYPE_CODE" etc="style=\"width:80;\"" selvalue="${param.N_TYPE_CODE}"/></span>
						<button type="button" id="btnMulti" style="margin-right: 0px;">다중복구</button>
					</div>
				</div>
				<div id="real_time_error" class="table_typv1"></div>
			</div>
			<div id="dynamicChartDiv">
				<!-- 최근 한달간 장애 top5 -->

				<!-- .contens_wd100 -->
				<div class="contens_wd100">
					<div id="apDiv2" class="wd101_1">
						<h3>최근 6개월간 등급별 차트</h3>
						<span id="six_month_chart" class="chart-wrapper" style="height: 200px;"></span>
					</div>
					<div id="apDiv7" class="wd101_2">
						<h3>최근 한달간 장애 Top10</h3>
						<span id="month_top5_chart" class="chart-wrapper" style="height: 200px;"></span>
					</div>
					<div id="apDiv3" class="wd101_3">
						<h3>최근 일주일간 장애 Top10</h3>
						<span id="week_top5_chart" class="chart-wrapper" style="height: 200px;"></span>
					</div>
						<%--<div id="apDiv3" name="compo"></div>--%>
				</div>

				<div class="contens_wd100">
					<div id="apDiv4" class="wd101_1">
						<h3>실시간 사용률 Top10 (CPU)</h3>
						<span id="real_time_cpu_chart" class="chart-wrapper" style="height: 200px;"></span>
					</div>
					<div class="wd101_2">
						<h3>실시간 사용률 Top10 (MEMORY)</h3>
						<span id="real_time_memory_chart" class="chart-wrapper" style="height: 200px;"></span>
					</div>
					<div class="wd101_3">
						<h3>실시간 사용률 Top10 (DISK)</h3>
						<span id="real_time_disk_chart" class="chart-wrapper" style="height: 200px;"></span>
					</div>
						<%--<div id="apDiv3" name="compo"></div>--%>
					<!-- //.contens_wd100 -->
				</div>

			</div>
		</c:otherwise>
	</c:choose>
</div>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript">

	var nGroupCode 		= '${N_GROUP_CODE}';
	var realTimeErrorGrid;
	var test;

	$(document).ready(function () {
		initialize();

		$('#all_check').on('click', function() {
			if (this.checked) {
				$('input[name=S_ALM_KEY]').prop('checked', true);
			} else {
				$('input[name=S_ALM_KEY]').prop('checked', false);
			}
		});

		$('#btnMulti').kendoButton();

		$('#btnMulti').on('click', function(event) {
			event.preventDefault();

			var monId;
			var almKeys = [];

			if ( $('input[name=S_ALM_KEY]:checked').length === 0 ) {
				alert("복구대상 장애항목을 선택해주세요.");
				return;
			}

			$('input[name=S_ALM_KEY]:checked').each(function() {
				almKeys.push(this.value);
			});

			var realTimeErrorDataItem = realTimeErrorGrid.dataSource.data();
			var tmp_realTimeError = "";
			$("input[name=S_ALM_KEY]").each(function(index) {
				if ($("input[name=S_ALM_KEY]")[index].checked == true) {
					monId = realTimeErrorDataItem[index].N_MON_ID;
					if (tmp_realTimeError != "") {
						tmp_realTimeError += ",";
					}
					tmp_realTimeError += realTimeErrorDataItem[index].N_MON_ID + ";" +
							realTimeErrorDataItem[index].S_ALM_KEY
				}
			});

			fn_alarm_history_popup(tmp_realTimeError, monId, almKeys.join(','));
		});

/* 		$('#real_time_error div .k-grid-content table td').on('click', function() {
			var col = $(this).parent().children().index($(this));
		}); */
	});

	function fn_alarm_history_popup(v_realTimeErrorGroup, v_mon_id, v_alm_key, monName, almMsg, event) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}

		var param = "S_REAL_TIME_ERROR_GROUP=" + v_realTimeErrorGroup;
		param += "&N_MON_ID=" + v_mon_id;
		param += "&S_ALM_KEY=" + v_alm_key;
		param += "&S_MON_NAME=" + (monName ? monName : '');
		param += "&S_ALM_MSG=" + (almMsg ? almMsg : '');

		var dialogWidth = 900;

		$.post(cst.contextPath() + '/watcher/go_main.error_alarm_history.htm', param)
				.done(function(html) {
					$('#dialog_popup')
							.html(html)
							.dialog({
								title			: '장애확인/수동복구',
								resizable		: false,
								width			: dialogWidth,
								modal			: true,
								position		: [($(window).width() / 2) - (dialogWidth / 2), 150],
								autoReposition	: true,
								open			: function() {
									$(this).parent().css({top:50, left:($(window).width() / 2) - (dialogWidth / 2)});
								},
								buttons			: {
									"취소": function() {
										$( this ).dialog( "close" );
									},
									"확인": function() {
										$('#all_check').prop('checked', false);
										fn_save(); // error_alarm_history.jsp 선언
									}
								}
							});
				});
	}

	function initialize() {
		// -->
		// 실시간 장애현황 장비타입 Select Box Change Event
		$("select[name='ERR_STATS_N_TYPE_CODE'], select[name='ERR_STATS_N_GROUP_CODE']").on('change', function() {
			// 그룹 전체 일 경우 에만 Combo box 로 센터 선택가능하고 센터별로 들어갈 경우는 해당 센터 만 조회
			var groupCode = Number(nGroupCode);
			if ( groupCode === -1 ) {
				groupCode = $("select[name='ERR_STATS_N_GROUP_CODE'] option:selected").val() === '' ?
						-1 :
						$("select[name='ERR_STATS_N_GROUP_CODE'] option:selected").val();
			}
			reloadRealTimeDataSource(groupCode, $("select[name='ERR_STATS_N_TYPE_CODE'] option:selected").val());
		});

		// -->
		fn_get_server_info();

		// -->

		// TODO 일단 주석처리 차후 주석 제거할것!!!! 2016-07-21
		window.setInterval(reloadRealTimeDataSource, 10000);

	}

	// 상단 센터 전체현황
	function fn_write_map() {
		var url 	= cst.contextPath() + '/ajax/watcher/realtime_stats.component.map_group_stats/map_screen.htm',
				param 	= {
					'S_GROUP_FULL_CODE'	: nGroupCode,
					'N_GROUP_CODE'		: nGroupCode,
					'req_data'			: 'data;groupBySvrStatusQry|svr_type;compo_svr_type'
				};

//		$('#map_area').load(url, $.param(param));

		$.get(url, $.param(param), function(html) {
			$('#map_area').html(html);
		});
	}

	function fn_get_server_info() {
		if (document.all.apDiv1 != null) {
			$.post("<c:url value='/watcher/go_realtime_stats.component.all_server_stats.all_server_stats.htm'/>?N_GROUP_CODE=${N_GROUP_CODE}&req_data=data;serverStatusQry|svr_style;compo_svr_style|svr_type;compo_svr_type", function (data) {
				if (document.all.apDiv1 != null) document.all.apDiv1.innerHTML = data;
			});
		}

		if ($('#apDiv2').length > 0) {
			$("#six_month_chart").kendoChart({
				legend: {
					position: "top"
				},
				dataSource: {
					transport		: {
						read		: {
							type		: 'post',
							dataType	: 'json',
							url 		: cst.contextPath() + "/watcher/lst_latelyHalfyearStatsQry.htm",
							data 		: function() {
								return {
									'N_GROUP_CODE' : nGroupCode
								};
							}
						}
					},
					sort : {
						field	: "MON",
						dir		: "desc"
					}
				},
				series: [{
					field: "MINOR",
					name: "MINOR",
					color: "black"
				}, {
					field: "MAJOR",
					name: "MAJOR",
					color: "blue"
				}, {
					field: "CRITICAL",
					name: "CRITICAL",
					color: "red"
				}],
				categoryAxis: {
					field: "MON",
					majorGridLines: {
						visible: false
					}
				},
				valueAxis: {
					/* majorUnit: 20, */
					line: {
						visible: false
					},
					labels: {
						format: "{0}건"
					}
				},
				tooltip: {
					visible: true,
					format: "{0}",
					template: "#= value #건",
					color: 'white'
				}
			});
		}

		if ($('#apDiv3').length > 0) {
			$("#week_top5_chart").kendoChart({
				dataSource: {
					transport		: {
						read		: {
							type		: 'post',
							dataType	: 'json',
							url 		: cst.contextPath() + "/watcher/lst_latelyWeekServerErrorQry.htm",
							data 		: function() {
								return {
									'N_GROUP_CODE' : nGroupCode
								};
							}
						}
					}
				},
				legend: {
					visible: false
				},
				seriesDefaults: {
					type: "bar"
				},
				series: [{
					field : "CNT"
				}],
				valueAxis: {
					line: {
						visible: false
					},
					minorGridLines: {
						visible: true
					},
					labels: {
						format: "{0}건"
					}
				},
				categoryAxis: {
					field: "S_MON_NAME"
				},
				tooltip: {
					visible: true,
					format: "{0}",
					template: "#= value #건",
					color: 'white'
				}
			});
		}

		if ($('#apDiv4').length > 0) {
			/*$.post("<c:url value='/watcher/go_realtime_stats.component.realtime_resource_top5.realtime_resource_top5.htm'/>?N_GROUP_CODE=${N_GROUP_CODE}", function (data) {
			 if (document.all.apDiv4 != null) document.all.apDiv4.innerHTML = data;

			 });*/

			createRealTimeAmountUseChart();
		}

		if ($('#apDiv6').length > 0) {
			/*$.post("<c:url value='/watcher/go_realtime_stats.component.lastweek_error_stats.thisweek_server_error.htm'/>?N_GROUP_CODE=${N_GROUP_CODE}", function (data) {
			 if (document.all.apDiv6 != null) document.all.apDiv6.innerHTML = data;
			 });*/

			$("#this_week_chart").kendoChart({
				legend: {
					position: "top"
				},
				dataSource: {
					transport		: {
						read		: {
							type		: 'post',
							dataType	: 'json',
							url 		: cst.contextPath() + "/watcher/lst_thisweekServerErrorQry.htm",
							data 		: function() {
								return {
									'N_GROUP_CODE' : nGroupCode
								};
							}
						}
					},
					sort : {
						field	: "MON",
						dir		: "desc"
					}
				},
				series: [{
					field: "MINOR",
					name: "MINOR",
					color: "black"
				}, {
					field: "MAJOR",
					name: "MAJOR",
					color: "blue"
				}, {
					field: "CRITICAL",
					name: "CRITICAL",
					color: "red"
				}],
				categoryAxis: {
					field: "WEEK",
					majorGridLines: {
						visible: false
					}
				},
				valueAxis: {
					line: {
						visible: false
					}
				},
				tooltip: {
					visible: true,
					color: 'white'
				}
			});
		}

		if ($('#apDiv7').length > 0) {
			$("#month_top5_chart").kendoChart({
				dataSource: {
					transport		: {
						read		: {
							type		: 'post',
							dataType	: 'json',
							url 		: cst.contextPath() + "/watcher/lst_latelyMonthServerErrorQry.htm",
							data 		: function() {
								return {
									'N_GROUP_CODE' : nGroupCode
								};
							}
						}
					}
				},
				legend: {
					visible: false
				},
				seriesDefaults: {
					type: "bar"
				},
				series: [{
					field : "CNT"
				}],
				valueAxis: {
					line: {
						visible: false
					},
					minorGridLines: {
						visible: true
					},
					labels: {
						format: "{0}건"
					}
				},
				categoryAxis: {
					field: "S_MON_NAME"
				},
				tooltip: {
					visible: true,
					format: "{0}",
					template: "#= value #건",
					color:"white"
				}
			});
		}

		if ($('#apDiv8').length > 0) {

			if ($('#map_area').length > 0) {
				fn_write_map();
			}

			printRealTimeErrorGrid();
		}

		var $svrDtlArea = $('#server_detail_area');
		if ( $svrDtlArea.length > 0 ) {
			writeServerDetailMonitoring($svrDtlArea);
		}
	}

	// 장비 상세현황 그리드
	function writeServerDetailMonitoring(jObj) {
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					url 		: cst.contextPath() + "/watcher/lst_selectDetailDashboard.htm",
					data 		: function(data) {
						return {
							'N_GROUP_CODE' : $('#search_svr_dtl_group_code').val(),
							'N_TYPE_CODE'  : $('#search_svr_dtl_type_code').val()
						};
					}
				}
			},
			schema			: {
				data	: function(data) {
					return $.isArray(data) ? data : []; // data 가 존재하지 않으면 object('{}') 형식으로 와서 script 에러 발생
				}
			},
			group: {
				field: "S_TYPE_NAME",
				aggregates: [
					{ field: "S_TYPE_NAME", aggregate: "count" }
				]
			},
			sort : {
				field: "RECENT_UPDATE_TIME", dir: "desc"
			}
		});

		jObj.kendoGrid($.extend({}, kendoGridDefaultOpt, {
			dataSource	: dataSource,
			dataBound	: function(e) {
				$('.k-grouping-row td').css({ 'background-color' : '#dbeded', 'text-align' : 'left' });
				$('.k-grouping-row .k-group-cell, .k-grouping-row+tr .k-group-cell').css({'border-top-width':1});
//				$('.k-grouping-row td').attr({colspan:12});
				$('th[role=columnheader]').css({'background':'#e9e9e9', 'text-align':'center'});

				var grid = e.sender;
				if (grid.dataSource.total() == 0) {
					var colCount = grid.columns.length;
					$(e.sender.wrapper)
							.find('tbody')
							.append('<tr class="kendo-data-row"><td colspan="' + colCount + '" style="text-align:center;">감시장비가 존재하지 않습니다.</td></tr>');
				}

//				$(".k-group-col,.k-group-cell").hide();

				// 좌측 그룹 Cell 제거 로직
				// 제거 하면 그룹 열고 닫기가 실행안됨
//				$(".k-group-col,.k-group-cell").remove();
//				var spanCells = $(".k-grouping-row").children("td");
//				spanCells.attr("colspan", spanCells.attr("colspan") - 1);
			},
			selectable: "multiple row",
			pageable:false,
			scrollable: true,
			groupable: false,
			columns: [
				{field: "S_TYPE_NAME", title: "장비타입", width:'6%', aggregates:["count"], groupHeaderTemplate:'#=value# (#=count#)', sortable: false},
				{field: "S_MON_NAME", title: "장비명", width:'12%', template:'#=templateServerLink(N_MON_ID, S_MON_NAME, N_GROUP_CODE)#'},
				{field: "S_DESC", title: "호스트명", width:'12%'},
				{field: "S_MON_IP", title: "장비 IP", width:'7%'},
				{field: "B_CON_INFO", title: "연결상태", width:'6%', template:'# if (B_CON_INFO === "Y") { # 연결 # } else { # <div style="color: red;">연결안됨</div> # } #'},
				{field: "ALM_CNT", title: "상태/장애수", width:'7%', template:'#=templateSvrDtlAlmCount(ALM_CNT, N_GROUP_CODE, N_MON_ID)#'},
				{field: "CPU_PER_USE", title: "CPU", width:'7%', template:'#=templateSvrDtlCpu(CPU_PER_USE, CPU_PER_USE, CPU_PER_USE, "%")#'},
				{field: "DISK_FULL_SIZE", title: "디스크 용량", width:'7%', template:'#=kendo.toString(DISK_FULL_SIZE/1024, "n0")#GB'},
				{field: "DISK_NOW_SIZE", title: "디스크", width:'7%', template:'#=templateSvrDtlCpu(DISK_PER_USE, DISK_NOW_SIZE, DISK_NOW_SIZE/1024, "GB")#'},
				{field: "MEM_FULL_SIZE", title: "메모리 용량", width:'7%', template:'#=kendo.toString(MEM_FULL_SIZE/1024, "n")#GB'},
				{field: "MEM_NOW_USE", title: "메모리", width:'7%', template:'#=templateSvrDtlMemory(MEM_PER_USE, MEM_NOW_USE, MEM_NOW_USE/1024, "GB")#'},
				{field: "PRC_ALL_CNT", title: "프로세스", width:'6%', template:'<ul class="pro_num">' +
				'#if (PRC_RUN_CNT === PRC_ALL_CNT) {# <li class="left_succ_pbg">#=PRC_RUN_CNT#/#=PRC_ALL_CNT#</li><li class="right_succ_pbg"></li> '+
				'#} else {# <li class="left_pbg">#=PRC_RUN_CNT#/#=PRC_ALL_CNT#</li><li class="right_pbg"></li> #}#' +
				'</ul>'},
				//{field: "SVC_ALL_CNT", title: "서비스", width:'7%', template:'<ul class="pro_num"><li class="left_pbg">#=SVC_RUN_CNT#/#=SVC_ALL_CNT#</li><li class="right_pbg"></li></ul>'}
				{field: "SVC_ALL_CNT", title: "서비스", width:'6%', template:'<ul class="pro_num">' +
				'#if (SVC_RUN_CNT === SVC_ALL_CNT) {# <li class="left_succ_pbg">#=SVC_RUN_CNT#/#=SVC_ALL_CNT#</li><li class="right_succ_pbg"></li> '+
				'#} else {# <li class="left_pbg">#=SVC_RUN_CNT#/#=SVC_ALL_CNT#</li><li class="right_pbg"></li> #}#' +
				'</ul>'}
			],
			height: 300,
			sortable : true
		}));

		// TODO 일단 주석처리 차후 주석 제거할것!!!! 2016-07-21
		window.setInterval(searchSvrDtlMonitoring, 30000);
	}

	function searchSvrDtlMonitoring() {
		$('#server_detail_area').data('kendoGrid').dataSource.read({
			'N_GROUP_CODE' : $('#search_svr_dtl_group_code').val(),
			'N_TYPE_CODE'  : $('#search_svr_dtl_type_code').val(),
			'S_MON_NAME'   : $('#search_svr_dtl_mon_name').val(),
			'S_MON_IP'	   : $('#search_svr_dtl_mon_ip').val()
		});

		reloadRealTimeDataSource($('#search_svr_dtl_group_code option:selected').val(),
				$('#search_svr_dtl_type_code option:selected').val());
	}

	function templateServerLink(nMonId, sMonName, nGroupCode) {
		return '<a href="#" style="text-decoration: underline;" onclick="goServerDetailPage(' + nMonId + ', ' + nGroupCode + '); return false;">' + sMonName + '</a>';
	}

	function templateSvrDtlAlmCount(almCnt, nGroupCode, nMonId) {
		var html = '';

		if ( parseInt(almCnt) > 0 ) {
			html += '<a href="#" onclick="goServerDetailPage(' + nMonId + ', ' + nGroupCode + ', \'error\'); return false;">';
			html += '<img src="<c:url value="/images/watcher/ico_err.gif"/>" alt="" />';
			<%--html += '<a href="#"><img src="<c:url value="/images/watcher/ico_err2.gif"/>" alt="" /></a>';--%>
			html += '<ul class="pro_num1"  style="width:30px;"><li class="left_pbg" style="width:20px;">' + almCnt + '</li><li class="right_pbg"></li></ul>';
			html += '</a>';
		}

		return html;
	}

	function templateSvrDtlCpu(perUse, orgnNowUse, nowUse, unit) {
		var _perUse = Number(perUse) > 0 ? perUse : 0,
				_nowUse = Number(orgnNowUse) > 0 ? nowUse : 0;
		return '<div class="grp_ty1_bg"><span style="width:' + _perUse + '%;"></span><div class="grp_txt">' + kendo.toString(_nowUse, "n0") + unit + '</div></div>';
	}
	
	function templateSvrDtlMemory(perUse, orgnNowUse, nowUse, unit) {
		var _perUse = Number(perUse) > 0 ? perUse : 0,
				_nowUse = Number(orgnNowUse) > 0 ? nowUse : 0;
		return '<div class="grp_ty1_bg"><span style="width:' + _perUse + '%;"></span><div class="grp_txt">' + kendo.toString(_nowUse, "n2") + unit + '</div></div>';
	}

	// 센터별 상세 페이지 차트 생성
	function createRealTimeAmountUseChart() {
		$("#real_time_cpu_chart").kendoChart(getRealTimeAmountUseChartOption(0));

		$("#real_time_memory_chart").kendoChart(getRealTimeAmountUseChartOption(1));

		$("#real_time_disk_chart").kendoChart(getRealTimeAmountUseChartOption(2));
	}

	// 센터별 상세 페이지 차트 생성 Options
	function getRealTimeAmountUseChartOption(monType) {
		return {
			dataSource: {
				transport		: {
					read		: {
						type		: 'post',
						dataType	: 'json',
						url 		: cst.contextPath() + "/watcher/lst_realtimeResourceTop5.htm",
						data 		: function() {
							return {
								'N_GROUP_CODE' 	: nGroupCode,
								'N_MON_TYPE'	: monType
							};
						}
					}
				}
			},
			legend: {
				visible: false
			},
			seriesDefaults: {
				type: "bar"
			},
			series: [{
				field : "N_PER_USE"
			}],
			valueAxis: {
				max: 100,
				line: {
					visible: false
				},
				minorGridLines: {
					visible: true
				},
				labels: {
					format: "{0}%"
				}
			},
			categoryAxis: {
				field: "S_MON_NAME"
			},
			tooltip: {
				visible: true,
				format: "{0}",
				template: "#= value #%",
				color: "white"
			}
		}
	}

	// 실시간 장애 현황 그리드
	function printRealTimeErrorGrid() {
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					url 		: cst.contextPath() + "/watcher/lst_realtimeErrorStatsQry2.htm",
					data 		: function(data) {

						// 그룹 전체 일 경우 에만 Combo box 로 센터 선택가능하고 센터별로 들어갈 경우는 해당 센터 만 조회
						var groupCode = Number(nGroupCode);
						if ( groupCode === -1 ) {
							groupCode = $("select[name='ERR_STATS_N_GROUP_CODE'] option:selected").val() === '' ?
									-1 :
									$("select[name='ERR_STATS_N_GROUP_CODE'] option:selected").val();
						}

						return {
							'N_GROUP_CODE' 			: groupCode,
							'ERR_STATS_N_TYPE_CODE' : $("select[name='ERR_STATS_N_TYPE_CODE']").length > 0 ?
									$("select[name='ERR_STATS_N_TYPE_CODE'] option:selected").val() :
									$("#search_svr_dtl_type_code option:selected").val()
						};
					}
				}
			},
			schema			: {
				data	: function(data) {
					return $.isArray(data) ? data : []; // data 가 존재하지 않으면 object('{}') 형식으로 와서 script 에러 발생
				}
			}
		});

		realTimeErrorGrid = $("#real_time_error")
				.kendoGrid($.extend({}, kendoGridDefaultOpt, {
					dataSource	: dataSource,
					dataBound	: girdRowdblclick,
					/*
					 dataBound	: function() {
					 // content checkbox 이벤트 등록
					 $('input[name=S_ALM_KEY]').on('change', releaseAllCheckbox);
					 goServerDetailPage("nMonId", "nGroupCode", "error");
					 },
					 change		: function() {
					 goServerDetailPage(this.dataItem(this.select()).N_MON_ID, this.dataItem(this.select()).N_GROUP_CODE, 'error');
					 },
					 */
					columns		: [
						{headerTemplate: '<input type="checkbox" id="all_check" name="ALL_CHECK" value="Y"/>', width:'5%', attributes:{style:'text-align:center;'}, headerAttributes:{style:'text-align:center;'}, sortable : false, template:kendo.template($('#checkboxTemplate').html())},
						//{width:'5%', attributes:{style:'text-align:center;'}, template : '<img src="<c:url value="/images/botton/ico_aus.gif"/>" alt="">'},
						{field:'S_MON_NAME', title:'장비명', width:'15%', attributes:{style:'text-align:center;'}, headerAttributes:{style:'text-align:center;'}, template:'#=templateServerLink(N_MON_ID, S_MON_NAME, N_GROUP_CODE)#'},
						{field:'S_ALM_MSG', title:'장애내용', width:'55%', attributes:{style:'text-align:left;'}, headerAttributes:{style:'text-align:center;'}},
						{field:'S_ALM_RATING_NAME', title:'등급', width:'10%', attributes:{style:'text-align:center;'}, headerAttributes:{style:'text-align:center;'}},
						{field:'D_UPDATE_TIME', title:'날짜', width:'15%', attributes:{style:'text-align:center;'}, headerAttributes:{style:'text-align:center;'}}
					],
					scrollable	: true,
					selectable	: 'row',
					height		: 200,
					pageable	: false
				})).data('kendoGrid');
	}

	//Grid dblclick Event
	function girdRowdblclick(e) {

		gridDataBound(e);
		/*
		$('input[name=S_ALM_KEY]').on('change', releaseAllCheckbox);

 		$('#real_time_error table tr td').on('dblclick', function() {
			if($(this).parent().children().index($(this)) == 0) return;
			goServerDetailPage("nMonId", "nGroupCode", "error");
		}); */
	}

	function releaseAllCheckbox() {
		$('input[name=S_ALM_KEY]').length === $('input[name=S_ALM_KEY]:checked').length
				? $('#all_check').prop('checked', true)
				: $('#all_check').prop('checked', false);
	}

	// 그리드 Row Select 시에 해당 장애상세페이지로 이동
	function goServerDetailPage(nMonId, nGroupCode, tabStript) {

		if(nMonId === "nMonId" && nGroupCode === "nGroupCode") {
			nMonId = realTimeErrorGrid.dataItem(realTimeErrorGrid.select()).N_MON_ID;
			nGroupCode = realTimeErrorGrid.dataItem(realTimeErrorGrid.select()).N_GROUP_CODE;
		}

		var monId = nMonId;
		var groupCode = nGroupCode ? nGroupCode : '';
		var leftNaviCountPerPage = parseInt('<spring:eval expression="@serviceProps['watcher.detail.navi.countperpage']"/>');
		$.getJSON('<c:url value="/watcher/map_SvrLstByMonIdPageNum.htm"/>', {'MON_ID' : monId, 'N_GROUP_CODE' : groupCode}, function(data) {
			var pageNum = "";
			if(parseInt(data.NUM % leftNaviCountPerPage) > 0) {
				pageNum=parseInt(data.NUM / leftNaviCountPerPage) + 1;
			} else {
				pageNum=parseInt(data.NUM / leftNaviCountPerPage);
			}

			var param = {'N_GROUP_CODE' : groupCode, 'N_MON_ID' : monId, pageNum : pageNum, tabStrip : (tabStript ? tabStript : '')};
			goMenu(document.getElementById('mnavi01_02'), param, 'E'); // watcher_template.jsp 에 선언되어있음.
		});
	}

	function reloadRealTimeDataSource(groupCode, typeCode) {

		realTimeErrorGrid && realTimeErrorGrid.dataSource.read({
			'N_GROUP_CODE' 			: groupCode,
			'ERR_STATS_N_TYPE_CODE' : typeCode
		});
	}


	function addStyleApDiv8(top) {
		$('#apDiv8').css('margin-top', top + 'px');
	}

	function changeTitle(title) {
		$('#map_title').text(title);
	}

	function createChart(selector, dataSource, extOpt) {

		var chartOpt = {
			dataSource: dataSource,
			/*dataSource:{
				data:[{
					inCall: 42,
					outCall: 31,
					companyCall: 53
				},{
					inCall: 20,
					outCall: 10,
					companyCall: 30
				}]
			},*/
			autoBind: true,
			legend: {
				position: "bottom"
			},
//			seriesColors : ['blue'],
			seriesDefaults: {
				type: "column"
				,style: "smooth"
				,stack:true
			},
			/*series: [
			 { name : "시간별추이", field: "value", markers: { visible: false } }
			 ],*/
			seriesColors : ['blue', 'green', 'red'],
			series		 : [
				{ name : '수신', field : "inCall" },
				{ name : '발신', field : "outCall"},
				{ name : '내선', field : "companyCall"}
			],
			/*valueAxis: {
				min : 0,
				max : 100,
				majorUnit: 1,
				labels: {
					format: "{0}"
				},
				line: {
					visible: true
				},
				axisCrossingValue: 0
			},*/
			categoryAxis: {
				categories: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23],
				majorGridLines: {
					visible: true
				},
				visible: true
			},
			chartArea: {
				height : 200
			},
			tooltip: {
				visible: true,
				format: "{0}",
				template: "#= series.name #: #= value #",
				color: "white"
			}
		};

		extOpt && $.extend(chartOpt, extOpt);

		return $(selector).kendoChart(chartOpt).data('kendoChart');
	}
</script>

<script id="checkboxTemplate" type="text/x-kendo-template">
	<input type="checkbox" name="S_ALM_KEY" value="#= S_ALM_KEY #"/>
</script>

<div id="dialog_popup"></div>