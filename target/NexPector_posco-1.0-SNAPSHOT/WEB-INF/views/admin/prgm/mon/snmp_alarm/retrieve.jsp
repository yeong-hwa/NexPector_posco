<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>SNMP 임계치 정보 관리</h2><span>Home &gt; 감시장비 관리 &gt; SNMP 임계치 정보 관리</span></div></div>
<!-- location // -->

<!-- 내용 -->
<!-- 검색영역 -->
<form id="snmp_alarm_delete_form" name="snmp_alarm_delete_form" data-role="validator">
<input type="hidden" id="snmp_alarm_delete_list" name="SNMP_ALARM_DELETE_LIST" value=""/>
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<%-- 
				<dd>
					<strong>서버그룹</strong>
					<cmb:combo qryname="cmb_svr_group" seltagname="N_GROUP_CODE" firstdata="전체" etc="class=\"input_search\" id=\"N_GROUP_CODE\""/>
					<strong style="margin-left:30px;">서버타입</strong>
					<cmb:combo qryname="cmb_svr_type" seltagname="N_TYPE_CODE" firstdata="전체" etc="class=\"input_search\"id=\"N_TYPE_CODE\""/>
				</dd>
				 --%>
				<dd>
					<strong>장비그룹</strong><cmb:combo qryname="cmb_svr_group" seltagname="N_GROUP_CODE" firstdata="전체" etc="id=\"N_GROUP_CODE\""/>
					<strong style="margin-left:30px;">장비타입</strong><cmb:combo qryname="cmb_svr_type" seltagname="N_TYPE_CODE" firstdata="전체" etc="id=\"N_TYPE_CODE\""/>
					<select style="margin-left:30px;" name="SEARCH_TYPE" value="${param.SEARCH_TYPE}" id="SEARCH_TYPE">
                		<option value="ID">장비ID</option>
                		<option value="NM">장비명</option>
                		<option value="IP">장비IP</option>
                	</select>
                	<input type="text" name="SEARCH_KEYWORD" id="SEARCH_KEYWORD" value="${param.SEARCH_KEYWORD}" class="int_f input_search"/>
				</dd>				 
			</dl>
			<!-- 검색항목 // -->
			<!-- 버튼 -->
			<span class="his_search_bt"><a href="#" id="search"><img src="<c:url value="/images/botton/search_1.jpg"/>" alt="검색" /></a></span>
			<!-- 버튼 // -->
		</li>
		<li class="rightbg">&nbsp;</li>
	</ul>
</div>
<!-- 검색영역 //-->

<!-- manager_contBox1 -->
<div class="manager_contBox1">
	<!-- stitle -->
	<div class="stitle1" style="float: none;">
		<div class="st_under">
			<h4>건수 : &nbsp;<span id="total_count">0</span></h4>
			<span>
				<a href="<c:url value="/admin/go_prgm.mon.snmp_alarm.insert.htm"/>" id="btn_save" class="css_btn_class">등록</a>
				<a href="#" id="btn_remove" class="css_btn_class">삭제</a>
			</span>
		</div>
	</div>
	
	<!-- stitle // -->
	<!-- table_typ2-4 -->
	<div id="snmp_alarm_gird" class="table_typ2-4">
	</div>
</div>
</form>
<!-- manager_contBox1 // -->
<!-- 내용 // -->

<form id="frm"></form>

<form id="go_list_form" method="get">
	<input type="hidden" name="searchParam" value="${param.searchParam}"/>
</form>

<script type="text/javascript">

	var grid;
	
	$(document).ready(function() {
		InitGrid();
		initEvent();

		var searchParam = '${param.searchParam}';
		if ('' !== searchParam) {
			initSearchData(searchParam);
		}
	});
	
	function initSearchData(searchParam) {
		var param = JSON.parse(decodeURIComponent(searchParam));
		$('#N_GROUP_CODE').val(param.N_GROUP_CODE);
		$('#N_TYPE_CODE').val(param.N_TYPE_CODE);
		$('#SEARCH_TYPE').val(param.SEARCH_TYPE);
		$('#SEARCH_KEYWORD').val(param.SEARCH_KEYWORD);
		var page = parseInt(param.currentPageNo);
		grid.dataSource.fetch(function() {
			grid.dataSource.page(page);
		});
	}

	// 사용자 목록 Grid
	function InitGrid() {
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/kendoPagination_snmp_alarm.select_list.htm",
					data 		: function(data) {
						return {
							'N_GROUP_CODE'  : $.trim($('#N_GROUP_CODE').val()),
							'N_TYPE_CODE'   : $.trim($('#N_TYPE_CODE').val()),
							'SEARCH_TYPE'   : $.trim($('#SEARCH_TYPE').val()),
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
					return data;
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

		grid = $("#snmp_alarm_gird")
			.kendoGrid($.extend(kendoGridDefaultOpt, {
				dataSource	: dataSource,
				//change		: selectedRow,
				sortable	: {
					mode 		: 'multiple',
					allowUnsort : true
				},
				dataBound	: girdRowdblclick,
				columns		: [
					{headerTemplate: '<input type="checkbox" id="all_check" value="Y"/>', template: '<input type="checkbox" name="sel_check" value="Y" onchange="checkAll();">', width:'3%', attributes:alignCenter, headerAttributes:alignCenter, sortable : false},				       		   
					{field:'N_MON_ID', title:'장비ID', width:'5%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_MON_NAME', title:'장비명', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_SNMP_MAN_NAME', title:'SNMP장비명', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_SNMP_MON_NAME', title:'SNMP감시상세명', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_ALM_RATING_NAME', title:'장애등급', width:'7%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_IN_VALUE_NAME', title:'장애조건', width:'9%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_SNMP_TYPE_NAME', title:'감시타입', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_MON_IP', title:'장비IP', width:'8%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'TYPE_NAME', title:'장비타입', width:'8%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'GROUP_NAME', title:'장비그룹', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				]
			})).data('kendoGrid');
	}

	// Event 등록
	function initEvent() {
		
		$(".input_search").keypress(function(event){
			if(kendo.keys.ENTER === event.keyCode) {
				event.preventDefault();
				$("#search").click();
			}
		});
		
		$('#search').on('click', function(event) {
			event.preventDefault();
			grid.dataSource.read();
		});
		
		$('select').on('change', function(event) {
			event.preventDefault();
			grid.dataSource.read();
		});
		
		$('#all_check').on('change', function() {
			if (this.checked) {
				$('input[name=sel_check]').prop('checked', true);
			} else {
				$('input[name=sel_check]').prop('checked', false);
			}
		});
		
		$('#btn_remove').on('click', del);
	}

	//Grid dblclick Event
	function girdRowdblclick(e) {
		
		gridDataBound(e);
		
		$('tr').on('dblclick', function() {
			selectedRow();
		});
	}
	
	//장비 체크 이벤트
	function checkAll() {
		$('input[name=sel_check]').length === $('input[name=sel_check]:checked').length
				? $('#all_check').prop('checked', true)
				: $('#all_check').prop('checked', false);
	}
	
	// Selected Grid Row
	function selectedRow(event) {

		// 검색 조건과 페이지 번호를 JSON 형태의 String 으로 넘겼다가 다시 받아오기 위함
		var param = {
			'N_GROUP_CODE'	: $('#N_GROUP_CODE').val().trim(),
			'N_TYPE_CODE'	: $('#N_TYPE_CODE').val().trim(),
			'SEARCH_TYPE'   : $.trim($('#SEARCH_TYPE').val()),
			'SEARCH_KEYWORD': $.trim($('#SEARCH_KEYWORD').val()),
			'currentPageNo'	: grid.dataSource.page()
		};
		var paramStr = JSON.stringify(param);

		$('#frm')
			.append('<input type="hidden" name="searchParam" value="' + encodeURIComponent(paramStr) + '">')
			.append('<input type="hidden" name="N_MON_ID" value="' + grid.dataItem(grid.select()).N_MON_ID + '">')
			.append('<input type="hidden" name="N_SNMP_MAN_CODE" value="' + grid.dataItem(grid.select()).N_SNMP_MAN_CODE + '">')
			.append('<input type="hidden" name="N_SNMP_MON_CODE" value="' + grid.dataItem(grid.select()).N_SNMP_MON_CODE + '">')
			.append('<input type="hidden" name="N_SNMP_TYPE_CODE" value="' + grid.dataItem(grid.select()).N_SNMP_TYPE_CODE + '">')
			.append('<input type="hidden" name="N_ALM_RATING" value="' + grid.dataItem(grid.select()).N_ALM_RATING + '">')
			.append('<input type="hidden" name="S_SNMP_IP" value="' + grid.dataItem(grid.select()).S_SNMP_IP + '">')
			.append('<input type="hidden" name="updateFlag" value="U">')
			.attr({'action' : cst.contextPath() + '/admin/go_prgm.mon.snmp_alarm.insert.htm'})
			.submit();

		event.preventDefault();
	}

	function fn_validation_chk() {
		if($('input[name=sel_check]:checked').length === 0) {
			alert('삭제하실 항목을 선택해주세요.');
			return false;
		}
		return true;
	}
	
	// 삭제
	function del()
	{
		if(!fn_validation_chk())
			return;
		
		if(!confirm("정말 삭제 하시겠습니까?"))
			return;

		var snmpAlarmGrid = $('#snmp_alarm_gird').data('kendoGrid');
	    var snmpAlarmDataItem = snmpAlarmGrid.dataSource.data();
	    
	    var tmp_snmp_alarm = "";
	    $("input[name=sel_check]").each(function(index) {
	    	if ($("input[name=sel_check]")[index].checked == true) {
				if (tmp_snmp_alarm != "") {	
					tmp_snmp_alarm += ",";
				}
				tmp_snmp_alarm += snmpAlarmDataItem[index].N_MON_ID + ";" + 
								  snmpAlarmDataItem[index].N_SNMP_MAN_CODE + ";" +
								  snmpAlarmDataItem[index].N_SNMP_MON_CODE + ";" +
								  snmpAlarmDataItem[index].N_SNMP_TYPE_CODE + ";" +
								  snmpAlarmDataItem[index].N_ALM_RATING
	    	}
		});
	    $("#snmp_alarm_delete_list").val(tmp_snmp_alarm);
	    
	    var url = "<c:url value='/admin/delete_snmp_alarm.htm'/>";
		var param = $("form[name='snmp_alarm_delete_form']").serialize();
		
		$.post(url, param, function(str){
			var data = $.parseJSON(str);
			if(data.RSLT != null && data.RSLT > 0) {
				alert('삭제되었습니다.');
				goListPage();
				return;
			}
			else {
				alert("삭제 실패 하였습니다.\n" + data.ERRMSG + "");
				goListPage();
				return;
			}
		});
	}
	
	function goListPage(event) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.snmp_alarm.retrieve.htm').submit();
	}
</script>