<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>SNMP Map 코드 관리</h2><span>Home &gt; 감시장비 관리 &gt; SNMP Map 코드 관리</span></div></div>
<!-- location // -->

<!-- 내용 -->
<!-- 검색영역 -->
<form id="snmp_map_delete_form" name="snmp_map_delete_form" data-role="validator">
<input type="hidden" id="snmp_map_delete_list" name="SNMP_MAP_DELETE_LIST" value=""/>
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<%-- 
				<dd>
					<strong>감시장비</strong>
					<cmb:combo qryname="svrComboQry2" seltagname="N_MON_ID" firstdata="전체" etc="id=\"N_MON_ID\""/>
					<strong style="margin-left:30px;">SNMP장비</strong>
					<cmb:combo qryname="cmb_snmp_man_code" seltagname="N_SNMP_MAN_CODE" firstdata="전체" etc="id=\"N_SNMP_MAN_CODE\" onchange=\"fn_snmp_map_code_change(this.value);\""/>
					<strong style="margin-left:30px;">SNMP 상세 코드</strong>
                	<span id="snmp_mon_code_selbox">
	            		<SELECT id="N_SNMP_MON_CODE" name="N_SNMP_MON_CODE">
	            			<OPTION value="">전체</OPTION>
	            		</SELECT>
	            	</span>
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
                	<%-- 
                	<strong style="margin-left:30px;">SNMP장비</strong>
					<cmb:combo qryname="cmb_snmp_man_code" seltagname="N_SNMP_MAN_CODE" firstdata="전체" etc="id=\"N_SNMP_MAN_CODE\" onchange=\"fn_snmp_map_code_change(this.value);\""/>
					<strong style="margin-left:30px;">SNMP 상세 코드</strong>
                	<span id="snmp_mon_code_selbox">
	            		<SELECT id="N_SNMP_MON_CODE" name="N_SNMP_MON_CODE">
	            			<OPTION value="">전체</OPTION>
	            		</SELECT>
	            	</span>
	            	 --%>
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
				<a href="<c:url value="/admin/go_prgm.mon.snmp_map.insert.htm"/>" id="btn_save" class="css_btn_class">등록</a>
				<a href="#" id="btn_remove" class="css_btn_class">삭제</a>			
			</span>
		</div>
	</div>
	<!-- stitle // -->
	<!-- table_typ2-4 -->
	<div id="snmp_map_gird" class="table_typ2-4">
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
		/* 
		$('#N_SNMP_MAN_CODE').val(param.N_SNMP_MAN_CODE);
		$('#N_SNMP_MON_CODE').val(param.N_SNMP_MON_CODE);
		 */
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
					url 		: cst.contextPath() + "/admin/kendoPagination_snmp_map.select_list.htm",
					data 		: function(data) {
						return {
							/* 
							'N_SNMP_MAN_CODE'   : $.trim($('#N_SNMP_MAN_CODE').val()),
							'N_SNMP_MON_CODE'   : $.trim($('#N_SNMP_MON_CODE').val())
							 */
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

		grid = $("#snmp_map_gird")
			.kendoGrid($.extend(kendoGridDefaultOpt, {
				dataSource	: dataSource,
				//change		: selectedRow,
				sortable	: {
					mode 		: 'multiple',
					allowUnsort : true
				},
				dataBound	: girdRowdblclick,
				columns		: [
					{headerTemplate: '<input type="checkbox" id="all_check" value="Y"/>', template: '<input type="checkbox" name="sel_check" value="Y" onchange="checkAll();">', width:'3%', attributes:alignCenter, headerAttributes:{style:'text-align:center;vertical-align:middle'}, sortable : false},
					{field:'N_MON_ID', title:'장비ID', width:'7%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center;vertical-align:middle'}},
					{field:'S_MON_NAME', title:'장비명', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center;vertical-align:middle'}},
					{field:'SNMP_MAN_NAME', title:'SNMP장비명', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center;vertical-align:middle'}},
					{field:'SNMP_MON_NAME', title:'SNMP감시 상세코드', width:'21%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center;vertical-align:middle'}},
					{field:'N_TIMEM', title:'기본<br/ >수집주기(초)', width:'8%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center;vertical-align:middle'}},
					{field:'S_MON_IP', title:'장비IP', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center;vertical-align:middle'}},
					{field:'TYPE_NAME', title:'장비타입', width:'8%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center;vertical-align:middle'}},
					{field:'GROUP_NAME', title:'장비그룹', width:'13%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center;vertical-align:middle'}}
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
		
		//장비 전체 체크 이벤트
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
			/* 	
			'N_SNMP_MAN_CODE'	: $('#N_SNMP_MAN_CODE').val().trim(),
			'N_SNMP_MON_CODE'	: $('#N_SNMP_MON_CODE').val().trim(),
			 */
			'N_GROUP_CODE'		: $('#N_GROUP_CODE').val(),
			'N_TYPE_CODE'		: $('#N_TYPE_CODE').val(),
			'SEARCH_TYPE'   	: $.trim($('#SEARCH_TYPE').val()),
			'SEARCH_KEYWORD'	: $.trim($('#SEARCH_KEYWORD').val()),
			'currentPageNo'		: grid.dataSource.page()
		};
		var paramStr = JSON.stringify(param);

		$('#frm')
			.append('<input type="hidden" name="searchParam" value="' + encodeURIComponent(paramStr) + '">')
			.append('<input type="hidden" name="N_MON_ID" value="' + grid.dataItem(grid.select()).N_MON_ID + '">')
			.append('<input type="hidden" name="N_SNMP_MAN_CODE" value="' + grid.dataItem(grid.select()).N_SNMP_MAN_CODE + '">')
			.append('<input type="hidden" name="N_SNMP_MON_CODE" value="' + grid.dataItem(grid.select()).N_SNMP_MON_CODE + '">')
			.append('<input type="hidden" name="updateFlag" value="U">')
			.attr({'action' : cst.contextPath() + '/admin/go_prgm.mon.snmp_map.update.htm'})
			.submit();

		event.preventDefault();
	}

	// SNMP 장비 선택시 SNMP 상세 코드 값 가져 옴
	function fn_snmp_map_code_change(val, val2)
	{
		$.ajaxSetup({ async:false });
		cfn_makecombo_opt($("#N_SNMP_MON_CODE"), "<c:url value="/admin/lst_common.cmb_snmp_mon_code.htm"/>?N_SNMP_MAN_CODE="+val, function(){
			$("#N_SNMP_MON_CODE").val(val2);
		});
		$.ajaxSetup({ async:true });
	}
	
	// 삭제
	function del()
	{
		if(!confirm("정말 삭제 하시겠습니까?"))
			return;

		var snmpMapGrid = $('#snmp_map_gird').data('kendoGrid');
	    var snmpMapDataItem = snmpMapGrid.dataSource.data();
	    
	    var tmp_snmp_map = "";
	    $("input[name=sel_check]").each(function(index) {
	    	if ($("input[name=sel_check]")[index].checked == true) {
				if (tmp_snmp_map != "") {	
					tmp_snmp_map += ",";
				}
				tmp_snmp_map += snmpMapDataItem[index].N_MON_ID + ";" + 
								snmpMapDataItem[index].N_SNMP_MAN_CODE + ";" +
								snmpMapDataItem[index].N_SNMP_MON_CODE
	    	}
		});
	    $("#snmp_map_delete_list").val(tmp_snmp_map);
	    
		var url = "<c:url value='/admin/snmp_map/delete.htm'/>";
		var param = $("form[name='snmp_map_delete_form']").serialize();
		
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
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.snmp_map.retrieve.htm').submit();
	}
</script>