<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- stitle -->
<div class="avaya_stitle1">
    <div class="st_under"><h4>분단위 성능 정보</h4></div>
</div>
<!-- stitle // -->
<!-- table_typ2-4 -->
<div class="table_typ2-4">
    <table summary="" cellpadding="0" cellspacing="0" style="width:100%;">
        <caption></caption>
        <colgroup>
            <col width="25%" />
            <col width="25%" />
            <col width="25%" />
            <col width="25%" />
        </colgroup>
        <tr>
            <td class="filed_A">Static OCC</td>
            <td class="filed_A">CP OCC</td>
            <td class="filed_A">SM OCC</td>
            <td class="filed_A">USED OCC</td>
        </tr>
        <tr>
            <td class="filed_B" id="static_occ"></td>
            <td class="filed_B" id="callp_occ"></td>
            <td class="filed_B" id="sys_mgmt_occ"></td>
            <td class="filed_B" id="used_occ"></td>
        </tr>
    </table>
</div>

<!-- stitle -->
<div class="avaya_stitle1">
    <div class="st_under"><h4>시간대별 성능 정보</h4></div>
</div>
<!-- stitle // -->

<!-- table_typ2-1 -->
<div class="cal_grpBox">
    <div class="cal_b">
        <!--달력-->
        <div id="health_resource_calendar"/>
    </div>
    <div id="health_resource_grp_area" class="grp_b">
        <%--<div style="margin-top:-30px; width:100%;">
			<div class="avaya_stitle1">
				<div class="st_under">
                    <h4>CPU : </h4>
                    <span id="peek_day">(2015-05-06 피크 현황)</span>
                </div>
			</div>
			<div id="peek_grp" class="chart-wrapper" style="width: 100%; margin-left:0px;">
			</div>
		</div>

        <div style="margin-top:40px; width:100%;">
            <div class="avaya_stitle1">
                <div class="st_under">
                    <span id="avg_day">(2015-05-06 평균 현황)</span>
                </div>
            </div>
            <div id="avg_grp" class="chart-wrapper" style="width: 100%; margin-left:0px;">
            </div>
        </div>--%>
    </div>
</div>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript" src="<c:url value="/js/server-detail.js" />"></script>

<script type="text/javascript">

    var pMonId      = '${param.N_MON_ID}',
        dailyCharts = [],
        mapKeys     = [],
        calendar;

    $(document).ready(function() {
        // Calendar 초기화
        calendar = $("#health_resource_calendar").kendoCalendar({
            format: 'yyyy-MM-dd',
            change: function() {
//                var calendar = $("#resource_calendar").data("kendoCalendar");
//                $('#peek_day').text('(' + kendo.toString(calendar.value(), 'd') + ' 피크 현황)');
//                $('#avg_day').text('(' + kendo.toString(calendar.value(), 'd') + ' 평균 현황)');

                readChartDataSource();
            }
        }).data("kendoCalendar");

        calendar.value(new Date());

        // 분단위 성능정보 데이터 출력
        writeAvayaCmHealthInfoData();

        // 시간대별 성능정보 차트 출력
        $.getJSON(cst.contextPath() + '/watcher/lst_monitoringMapCodes.htm', {'N_MON_ID' : pMonId}).done(writeDailyChart);

        // Chart 생성시 position relative 속성이 추가되어 위에 CPU Select Box 가 선택이 안되는 문제로 인해 강제 제거
        $('#peek_grp').css('position', 'static');
    });

    function writeDailyChart(data) {
        var $resourceGrpArea = $('#health_resource_grp_area');
        var day              = kendo.toString(calendar.value(), 'd');

        // 시간대별 성능정보 자원 개수 만큼 차트 생성
        for (var i = 0, length = data.length; i < length; i++) {
            var obj         = data[i];
            var marginTop   = i === 0 ? '-30' : '40';
            var innerHtml   = '';

            innerHtml += '<div style="margin-top:' + marginTop + 'px; width:100%;">';
            innerHtml += '  <div class="avaya_stitle1">';
            innerHtml += '      <div class="st_under">';
            innerHtml += '          <h4>' + obj.VAL + '</h4>';
//            innerHtml += '          <span id="' + obj.CODE + '_day">(' + day + ' 피크 현황)</span>';
            innerHtml += '      </div>';
            innerHtml += '  </div>';
            innerHtml += '  <div id="' + obj.CODE + 'health_grp" class="chart-wrapper" style="width: 100%; margin-left:0px;"></div>';
            innerHtml += '</div>';

            $resourceGrpArea.append(innerHtml);

            var chart = createChart(
                    $('#' + obj.CODE + 'health_grp'),
                    getDailyChartDataSource(pMonId, obj.CODE, day.replace(/-/gi, ""))
            );

            dailyCharts.push(chart);
            mapKeys.push(obj.CODE);
        }
    }

    function readChartDataSource() {
        for (var i = 0, length = dailyCharts.length; i < length; i++) {
            dailyCharts[i].dataSource.read({
                'N_MON_ID'  : pMonId,
                'S_MAP_KEY' : mapKeys[i],
                'N_DAY'     : kendo.toString(calendar.value(), 'd').replace(/-/gi, "")
            });
        }
    }

    function writeAvayaCmHealthInfoData() {
        $.get(cst.contextPath() + '/watcher/map_avaya_cm.avayaCmHealthInfo.htm', {'N_MON_ID':pMonId})
            .done(function(sData) {
                var data = JSON.parse(sData);
                var unit = '%';
                $('#static_occ').text($.trim(data.N_STATIC_OCC) + unit);
                $('#callp_occ').text($.trim(data.N_CALLP_OCC) + unit);
                $('#sys_mgmt_occ').text($.trim(data.N_SYS_MGMT_OCC) + unit);
                $('#used_occ').text($.trim(data.N_USED_OCC) + unit);
            });
    }

    function getDailyChartDataSource(monId, mapKey, day) {
        return new kendo.data.DataSource({
            transport		: {
                read		: {
                    type		: 'post',
                    dataType	: 'json',
                    url 		: cst.contextPath() + "/watcher/lst_AccrueResourcePeekAndAvgUsageQry.htm",
                    data 		: function() {
                        return {
                            'N_MON_ID' 		 : monId,
                            'S_MAP_KEY' 	 : mapKey,
                            'N_DAY' 	 	 : day.replace(/-/gi, "")
                        };
                    }
                }
            },
            schema			: {
                data	: callbackChartSchemaData
            }
        });
    }

    function callbackChartSchemaData(data) {
        var series = [];
        if ($.isArray(data)) {
            for (var i = 0; i <= 23; i++) { // 0시 부터 23시
                var sIndex = i < 10 ? '0' + i : i; // 1자리수 일때 00, 01, 02...
                series.push({
                    peek	: $.defaultStr(data[0]['TIME_' + sIndex], 0),
                    avg 	: $.defaultStr(data[1]['TIME_' + sIndex], 0)
                });
            }
        }
        else {
            for (var i = 0; i <= 23; i++) { // 0시 부터 23시
                series.push({
                    peek 	: 0,
                    avg 	: 0
                });
            }
        }

        return series;
    }

    function createChart($chartArea, dataSource) {
        var chartOpt = {
            dataSource: dataSource,
            autoBind: true,
            legend: {
                position: "bottom"
            },
            seriesColors : ['red', 'green'],
            seriesDefaults: {
                type: "area"
            },
            series: [
                { name : '최대', field : "peek" },
                { name : '평균', field : "avg" }
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
                },
                visible: true
            },
            chartArea: {
                height   : 150
            },
            tooltip: {
                visible: true,
                shared: true,
                format: "N0",
                color: "white"
            }
        };

        return $chartArea.kendoChart(chartOpt).data('kendoChart');
    }
</script>