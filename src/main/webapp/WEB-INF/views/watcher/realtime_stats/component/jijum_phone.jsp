<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="locationBox"><div class="st_under"><h2>전국 전화기 현황</h2><span>Home &gt; 전국 전화기 현황</span></div></div>

<!-- 내용 -->
<div class="table_div">
	<!-- 장비현준황 Map -->
	<div id="apDiv_map" name="compo">
		<div style="width:100%; height:420px;">
			<div style="float:left; width:35%;">
				<div class="stitleBox" style="height:25px; width: 530px;">
					<div class="st_under">
						<h3 id="map_title">전국 전화기 현황</h3>
					</div>
				</div>
				<div id="jijum_total_grid" class="table_typ2-4" style="float:left;"></div>
			</div>

			<div style="width:62%; float:left; margin-left: 15px;">
				<div class="stitleBox" style="height:55px; width: 100%;">
					<div class="st_under">
						<h3 id="map_title">전화기 현황</h3>
					</div>
					<form id="search_form" method="post">
					<table  cellpadding="0" cellspacing="0" class="table_left_s2">
						<tr>
							<td class="bgtl1"></td>
							<td class="bgtc1">
								<strong>지역</strong>
								<cmb:combo qryname="cmb_nMonJijumId" seltagname="N_GROUP_CODE" firstdata="전체" />
								&nbsp;&nbsp;

								<strong>구분</strong>
								<select name="SEARCH_TYPE" value="${param.SEARCH_TYPE}" id="SEARCH_TYPE">
			                		<option value="S_GUBUN">구분</option>
			                		<option value="S_NAME">사업국</option>
			                		<option value="S_RUNNING">러닝명</option>
			                		<option value="S_EXT_NUM">내선번호</option>
			                		<option value="S_IP_ADDRESS">IP주소</option>
			                		<option value="S_ADDRESS">주소</option>
			                	</select>
			                	<input type="text" name="SEARCH_KEYWORD" id="SEARCH_KEYWORD" value="${param.SEARCH_KEYWORD}" class="int_f input_search" />
			                	&nbsp;&nbsp;

								<strong>싱태</strong>
								<select name="SEL_STATUS" id="sel_status">
									<option value="">전체</option>
			                		<option value="S_ALARM">장애</option>
			                		<option value="S_NORMAL">정상</option>
								</select>
							</td>
							<td class="bgtc1">
								<a href="#" id="btn_search" class="k-primary k-button" style="float: right;">검색</a>
								<a href="#" id="btn_export" class="k-primary k-button" style="float: right; margin-right:8px;">Export</a>
							</td>
							<td class="bgtr1"></td>
						</tr>
					</table>
					</form>
				</div>

				<div id="jijum_alarm_grid" class="table_typ2-4" style="float:left;"></div>
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
</div>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript">

	var nGroupCode 		= '${N_GROUP_CODE}';
	var realTimeErrorGrid;

	$(document).ready(function () {
		initialize();
		initJijumTotalGrid();
		initJijumAlarmGrid();

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

			realTimeErrorDataItem = realTimeErrorGrid.dataSource.data();
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

		$('#real_time_error div .k-grid-content table td').on('click', function() {
			var col = $(this).parent().children().index($(this));
		});
		
		g_cb_funcTimer = refreshJijumTotalGrid;
		
		$("#SEARCH_KEYWORD").keypress(function(event){
	         if(event.keyCode == '13')
	        	 $("#btn_search").click();
	       });
	});

	function initialize() {
		// 실시간 장애현황 장비타입 Select Box Change Event
		$("select[name='ERR_STATS_N_TYPE_CODE'], select[name='ERR_STATS_N_GROUP_CODE']").on('change', function() {
			// 그룹 전체 일 경우 에만 Combo box 로 센터 선택가능하고 센터별로 들어갈 경우는 해당 센터 만 조회
			var groupCode = Number(nGroupCode);
			groupCode = $("select[name='ERR_STATS_N_GROUP_CODE'] option:selected").val() === '' ?
						-1 :
						$("select[name='ERR_STATS_N_GROUP_CODE'] option:selected").val();

			reloadRealTimeDataSource(groupCode, $("select[name='ERR_STATS_N_TYPE_CODE'] option:selected").val());
		});

		printRealTimeErrorGrid();
		
		// TODO 일단 주석처리 차후 주석 제거할것!!!! 2016-07-21
		//interval.push(window.setInterval(reloadRealTimeDataSource, 10000));
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
						groupCode = $("select[name='ERR_STATS_N_GROUP_CODE'] option:selected").val() === '' ?
									-1 :
									$("select[name='ERR_STATS_N_GROUP_CODE'] option:selected").val();


						return {
							'N_GROUP_CODE' 			: groupCode,
							'ERR_STATS_N_TYPE_CODE' : $("select[name='ERR_STATS_N_TYPE_CODE'] option:selected").val()
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
						{field:'S_ALM_MSG', title:'장애내용', width:'60%', attributes:{style:'text-align:left;'}, headerAttributes:{style:'text-align:center;'}},
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

		$('input[name=S_ALM_KEY]').on('change', releaseAllCheckbox);

		$('#real_time_error table tr td').on('dblclick', function() {
			if($(this).parent().children().index($(this)) == 0) return;
			goServerDetailPage("nMonId", "nGroupCode", "error");
		});
	}

	function releaseAllCheckbox() {
		$('input[name=S_ALM_KEY]').length === $('input[name=S_ALM_KEY]:checked').length
				? $('#all_check').prop('checked', true)
				: $('#all_check').prop('checked', false);
	}

	// 그리드 Row Select 시에 해당 장애상세페이지로 이동

	function reloadRealTimeDataSource(groupCode, typeCode) {

		realTimeErrorGrid && realTimeErrorGrid.dataSource.read({
			'N_GROUP_CODE' 			: groupCode,
			'ERR_STATS_N_TYPE_CODE' : typeCode
		});
	}

	
	// 지점전화기현황 Grid
	function initJijumTotalGrid() {
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/kendoPagination_jijum.phone_alm_total_list_qry.htm",
					data 		: function(data) {
						return data;
					}
				},
				parameterMap: function (data, opperation) {
					return JSON.stringify(data);
				}
			},
			schema			: {
				data	: function(data) {
					return $.isArray(data) ? data : [];
				},
				total 	: function(response) {
					var totalCount = response.length > 0 ? response[0].TOTAL_COUNT : 0;
					$('#total_count').text(totalCount);
					return totalCount;
				}
			},
			pageSize		: cst.countPerPage(),
			serverPaging	: true,
			serverSorting	: true
		});

		$("#jijum_total_grid")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: dataSource,
				change		: searchServerDataSource,
				pageable	: {
					messages : {
						empty	: "<strong>No data</strong>",
						display : "<span>전체<strong style='color: #f35800;'>{2}</strong> 개 항목</span>"
					}
				},
				sortable	: true,
				columns		: [
					{field:'GROUP_NAME', title:'지역구분', width:'20%', attributes:alignCenter, headerAttributes:alignCenter},
					{field:'TOT_COUNT', title:'전체전화기', width:'40%', attributes:alignCenter, headerAttributes:alignCenter},
					{field:'ALM_COUNT', title:'장애전화기', width:'40%', attributes:alignCenter, headerAttributes:alignCenter}
				],
				height		: '100%'
			}));
	}
	function refreshJijumTotalGrid() {
		$("#jijum_total_grid").data('kendoGrid').dataSource.read();
	}
	function searchServerDataSource() {
		
	}
	
	// 전화기(정상/장애) 현황
	function initJijumAlarmGrid() {
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/kendoPagination_jijum.phone_alm_list_qry.htm",
					data 		: function(data) {
						return {
							'N_GROUP_CODE'	: $('select[name=N_GROUP_CODE]').val(),
							'SEL_STATUS'	: $('select[name=SEL_STATUS]').val(),
							'SEARCH_TYPE' 	: $('#SEARCH_TYPE').val(),
							'SEARCH_KEYWORD': $.trim($('#SEARCH_KEYWORD').val())
						};
					}
				},
				parameterMap: function (data, opperation) {
					return JSON.stringify(data);
				}
			},
			schema			: {
				data	: function(data) {
					return $.isArray(data) ? data : [];
				},
				total 	: function(response) {
					var totalCount = response.length > 0 ? response[0].TOTAL_COUNT : 0;
					$('#total_count').text(totalCount);
					return totalCount;
				}
			},
			pageSize		: cst.countPerPage(),
			serverPaging	: true,
			serverSorting	: true
		});

		$("#jijum_alarm_grid")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: dataSource,
				change		: selectedServerGridRow,
				pageable	: {
					messages : {
						empty	: "<strong>No data</strong>",
						display : "<span>전체<strong style='color: #f35800;'>{2}</strong> 개 항목</span>"
					}
				},
				scrollable	: true,
				sortable	: true,
				columns		: [
					{template:'# if(N_ALM_STATUS == 0) {# <span style="color:green;font-size:10pt">●</span> #} else {# <span style="color:red;font-size:10pt">●</span> #}#', title:"<span style='font-size:10pt;'>○</span>", width:'5%', attributes:alignCenter, headerAttributes:alignCenter},
					{field:'N_ALM_STATUS == 0 ? "정상" : "장애"', 	title:'상태', width:'8%', attributes:alignCenter, headerAttributes:alignCenter},
					{field:'S_GROUP_NAME',	title:'본부', width:'10%', attributes:alignCenter, headerAttributes:alignCenter},
					{field:'S_NAME', 		title:'사업국', width:'10%', attributes:alignCenter, headerAttributes:alignCenter},
					{field:'S_RUNNING', 	title:'러닝', width:'10%', attributes:alignCenter, headerAttributes:alignCenter},
					{field:'S_GUBUN', 		title:'구분', width:'10%', attributes:alignCenter, headerAttributes:alignCenter},
					{field:'S_EXT_NUM', 	title:'전화번호', width:'15%', attributes:alignCenter, headerAttributes:alignCenter},
					{field:'S_ADDRESS', 	title:'주소', width:'35%', attributes:alignCenter, headerAttributes:alignCenter}
				],
				height		: '332px'
			}));

		$('#btn_search').on('click', function(event) {
			
			g_cb_funcTimer = null;
			event.preventDefault();
			$("#jijum_alarm_grid").data('kendoGrid').dataSource.read();
			g_cb_funcTimer = refreshJijumTotalGrid;
		});
	}

	function selectedServerGridRow() {
		
	}
	$('#btn_export').on('click', function(event) {
		var n_group_code	= $('select[name=N_GROUP_CODE]').val();
		var sel_status		= $('select[name=SEL_STATUS]').val();
		var search_type		= $('#SEARCH_TYPE').val();
		var search_keyword	= $.trim($('#SEARCH_KEYWORD').val());
		
		location.href = '/admin/dash_file_export.htm?N_GROUP_CODE=' + n_group_code + '&SEL_STATUS=' + sel_status + '&SEARCH_TYPE=' + search_type + '&SEARCH_KEYWORD=' + search_keyword;
	});
	
</script>

<script id="checkboxTemplate" type="text/x-kendo-template">
	<input type="checkbox" name="S_ALM_KEY" value="#= S_ALM_KEY #"/>
</script>
