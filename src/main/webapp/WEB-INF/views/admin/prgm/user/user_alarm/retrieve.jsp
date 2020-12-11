<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>알람 정보 관리</h2><span>Home &gt; 사용자 관리 &gt; 알람 정보 관리</span></div></div>
<!-- location // -->

<!-- 내용 -->
<!-- 검색영역 -->
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<dd>
					<strong>사용자 ID</strong> <input type="text" name="S_USER_ID" id="search_user_id" value="" class="int_f input_search"/>
					<strong style="margin-left:50px;">사용자명</strong> <input type="text" name="S_USER_NAME" id="search_user_name" value="" class="int_f input_search"/>
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
			<span><a href="#" id="btn_save" class="css_btn_class">등록</a></span>
			<span><a href="#" id="btn_remove" class="css_btn_class" style="margin-right: 10px;">선택삭제</a></span>
		</div>
	</div>
	<!-- stitle // -->
	<!-- table_typ2-4 -->
	<form id="remove_frm">
		<div class="table_typ2-4" id="alarm_info_grid">
		</div>
	</form>
</div>
<!-- manager_contBox1 // -->
<!-- 내용 // -->

<form id="frm"></form>

<script type="text/javascript">
	var grid;
	$(document).ready(function() {
		initEvent();
		initGrid();

		var searchParam = '${param.searchParam}';
		if ('' !== searchParam) {
			initSearchData(searchParam);
		}
	});

	function initSearchData(searchParam) {
		var param = JSON.parse(decodeURIComponent(searchParam));
		$('#search_user_id').val(param.search_user_id);
		$('#search_user_name').val(param.search_user_name);
		$('#SEARCH_TYPE').val(param.SEARCH_TYPE);
		$('#SEARCH_KEYWORD').val(param.SEARCH_KEYWORD);
		
		var page = parseInt(param.currentPageNo);
		grid.dataSource.fetch(function() {
			grid.dataSource.page(page);
		});
	}

	// 이벤트 등록
	function initEvent() {
		$(".input_search").keypress(function(event){
			if(kendo.keys.ENTER === event.keyCode)
				$("#search").click();
		});

		$('#search').on('click', function(event) {
			event.preventDefault();
			grid.dataSource.read();
		});

		$('#btn_save').on('click', function(event) {
			event.preventDefault();

			// 검색 조건과 페이지 번호를 JSON 형태의 String 으로 넘겼다가 다시 받아오기 위함
			var param = {
				'search_user_id' 	: $('#search_user_id').val().trim(),
				'search_user_name'	: $('#search_user_name').val().trim(),
				'currentPageNo'		: grid.dataSource.page()
			};
			var paramStr = JSON.stringify(param);

			$('#frm')
				.append('<input type="hidden" name="searchParam" value="' + encodeURIComponent(paramStr) + '">')
				.attr({'action' : cst.contextPath() + '/admin/go_prgm.user.user_alarm.insert.htm'})
				.submit();
		});

		$('#btn_remove').on('click', function(event) {
			event.preventDefault();

			if ($('input[name=DEL_KEY]:checked').length === 0) {
				alert('삭제하실 항목을 선택해주세요.');
				return;
			}

			if ( confirm('선택하신 알람을 삭제하시겠습니까?') ) {
				$.post(cst.contextPath() + '/admin/multiRemoveUserAlarm.htm', $('#remove_frm').serialize())
					.done(function(data) {
						if ( parseInt(data.RSLT) > 0 ) {

							$('input[type=checkbox]').prop('checked', false);

							grid.dataSource.read({
								'S_USER_ID' : $.trim($('#search_user_id').val()),
								'S_USER_NAME' : $.trim($('#search_user_name').val()),
								'SEARCH_TYPE'   : $.trim($('#SEARCH_TYPE').val()),
								'SEARCH_KEYWORD': $.trim($('#SEARCH_KEYWORD').val())
							});
						}
					});
			}
		});
	}

	// 그리드 등록
	function initGrid() {
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/kendoPagination_user_alarm.select_list.htm",
					data 		: function(data) {
						return {
							S_USER_ID : $('#search_user_id').val().trim(),
							S_USER_NAME : $('#search_user_name').val().trim(),
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

		grid = $("#alarm_info_grid")
					.kendoGrid($.extend({}, kendoGridDefaultOpt, {
						dataSource	: dataSource,
						//change		: selectedRow,
						sortable	: true,
						dataBound	: gridRowdblclick,
						columns		: [
							{headerTemplate: '<input type="checkbox" id="all_check" name="ALL_CHECK" value="Y"/>', template: kendo.template($('#checkboxTemplate').html()),attributes:alignCenter, headerAttributes:{style:'text-align:center;vertical-align:middle'}, sortable : false},
							{field:'S_USER_NAME', title:'사용자명', width:'9%', attributes:alignCenter, headerAttributes:{style:'text-align:center;vertical-align:middle'}},
							{field:'N_MON_ID', title:'서버ID', width:'9%', attributes:alignCenter, headerAttributes:{style:'text-align:center;vertical-align:middle'}},
							{field:'S_MON_NAME', title:'서버명', width:'9%', attributes:alignCenter, headerAttributes:{style:'text-align:center;vertical-align:middle'}},
							{field:'ALM_TIME', title:'알림시간', width:'9%', attributes:alignCenter, headerAttributes:{style:'text-align:center;vertical-align:middle'}},
							{field:'S_ALM_NAME', title:'장애타입', width:'10%', attributes:alignLeft, headerAttributes:{style:'text-align:center;vertical-align:middle'}},
							{field:'S_ALM_MSG', title:'장애상세', width:'20%', attributes:alignLeft, headerAttributes:{style:'text-align:center;vertical-align:middle'}, sortable:false},
							{
								title:'발송요일', attributes:alignCenter, headerAttributes:alignCenter,
								columns:[
									{field:'F_SEND_MONDAY', title:'월', width:'3%', attributes:alignCenter, headerAttributes:alignCenter, template:'#= printSendDayImage(F_SEND_MONDAY) #'},
									{field:'F_SEND_TUESDAY', title:'화', width:'3%', attributes:alignCenter, headerAttributes:alignCenter, template:'#= printSendDayImage(F_SEND_TUESDAY) #'},
									{field:'F_SEND_WEDNESDAY', title:'수', width:'3%', attributes:alignCenter, headerAttributes:alignCenter, template:'#= printSendDayImage(F_SEND_WEDNESDAY) #'},
									{field:'F_SEND_THURSDAY', title:'목', width:'3%', attributes:alignCenter, headerAttributes:alignCenter, template:'#= printSendDayImage(F_SEND_THURSDAY) #'},
									{field:'F_SEND_FRIDAY', title:'금', width:'3%', attributes:alignCenter, headerAttributes:alignCenter, template:'#= printSendDayImage(F_SEND_FRIDAY) #'},
									{field:'F_SEND_SATURDAY', title:'토', width:'3%', attributes:alignCenter, headerAttributes:alignCenter, template:'#= printSendDayImage(F_SEND_SATURDAY) #'},
									{field:'F_SEND_SUNDAY', title:'일', width:'3%', attributes:alignCenter, headerAttributes:alignCenter, template:'#= printSendDayImage(F_SEND_SUNDAY) #'}
								]
							},
							{field:'S_ALM_RATING_NAME', title:'장애등급', width:'9%', attributes:alignCenter, headerAttributes:{style:'text-align:center;vertical-align:middle'}}
						]
					})).data('kendoGrid');
	}

	function printSendDayImage(value) {
		if (value && parseInt(value) === 1) {
			return '<img src="' + cst.contextPath() + '/admin/images/manager/icon_check01.png' + '"/>';
		} else {
			return '';
		}
	}

	//Grid dblclick Event
	function gridRowdblclick(e) {
		
		gridDataBound(e);
		
		$('#all_check').on('click', function() {
			if (this.checked) {
				$('input[name=DEL_KEY]').prop('checked', true);
			} else {
				$('input[name=DEL_KEY]').prop('checked', false);
			}
		});

		// content checkbox 이벤트 등록
		$('input[name=DEL_KEY]').on('change', releaseAllCheckbox);
		
		$('tr').on('dblclick', function() {
			selectedRow();
		});
	}
	
	// Selected Grid Row
	function selectedRow(event) {
		// 검색 조건과 페이지 번호를 JSON 형태의 String 으로 넘겼다가 다시 받아오기 위함
		var param = {
			'search_user_id' 	: $.trim($('#search_user_id').val()),
			'search_user_name'	: $.trim($('#search_user_name').val()),
			'SEARCH_TYPE'   	: $.trim($('#SEARCH_TYPE').val()),
			'SEARCH_KEYWORD'	: $.trim($('#SEARCH_KEYWORD').val()),
			'currentPageNo'		: grid.dataSource.page()
		};
		var paramStr = JSON.stringify(param);

		$('#frm')
				.append('<input type="hidden" name="searchParam" value="' + encodeURIComponent(paramStr) + '">')
				.append('<input type="hidden" name="S_USER_ID" value="' + grid.dataItem(grid.select()).S_USER_ID + '">')
				.append('<input type="hidden" name="N_MON_ID" value="' + grid.dataItem(grid.select()).N_MON_ID + '">')
				.append('<input type="hidden" name="N_ALM_TYPE" value="' + grid.dataItem(grid.select()).N_ALM_TYPE + '">')
				.append('<input type="hidden" name="N_ALM_CODE" value="' + grid.dataItem(grid.select()).N_ALM_CODE + '">')
				.append('<input type="hidden" name="N_ALM_RATING" value="' + grid.dataItem(grid.select()).N_ALM_RATING + '">')
				.append('<input type="hidden" name="N_ST_TIME" value="' + grid.dataItem(grid.select()).N_ST_TIME + '">')
				.append('<input type="hidden" name="N_ED_TIME" value="' + grid.dataItem(grid.select()).N_ED_TIME + '">')
				.append('<input type="hidden" name="F_SEND_MONDAY" value="' + grid.dataItem(grid.select()).F_SEND_MONDAY + '">')
				.append('<input type="hidden" name="F_SEND_TUESDAY" value="' + grid.dataItem(grid.select()).F_SEND_TUESDAY + '">')
				.append('<input type="hidden" name="F_SEND_WEDNESDAY" value="' + grid.dataItem(grid.select()).F_SEND_WEDNESDAY + '">')
				.append('<input type="hidden" name="F_SEND_THURSDAY" value="' + grid.dataItem(grid.select()).F_SEND_THURSDAY + '">')
				.append('<input type="hidden" name="F_SEND_FRIDAY" value="' + grid.dataItem(grid.select()).F_SEND_FRIDAY + '">')
				.append('<input type="hidden" name="F_SEND_SATURDAY" value="' + grid.dataItem(grid.select()).F_SEND_SATURDAY + '">')
				.append('<input type="hidden" name="F_SEND_SUNDAY" value="' + grid.dataItem(grid.select()).F_SEND_SUNDAY + '">')
				.append('<input type="hidden" name="req_data" value="data;user_alarm.DetailRetrieveAlarmQry:map">')
				.attr({'action' : cst.contextPath() + '/admin/go_prgm.user.user_alarm.update.htm'})
				.submit();

		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}
	}

	function releaseAllCheckbox() {
		$('input[name=DEL_KEY]').length === $('input[name=DEL_KEY]:checked').length
				? $('#all_check').prop('checked', true)
				: $('#all_check').prop('checked', false);
	}
</script>

<script id="checkboxTemplate" type="text/x-kendo-template">
	<input type="checkbox" name="DEL_KEY"
		   value="#= N_MON_ID #;#= N_ALM_TYPE #;#= N_ALM_CODE #;#= N_ALM_RATING #;#= N_ST_TIME #;#= N_ED_TIME #;#= F_SEND_MONDAY #;#= F_SEND_TUESDAY #;#= F_SEND_WEDNESDAY #;#= F_SEND_THURSDAY #;#= F_SEND_FRIDAY #;#= F_SEND_SATURDAY #;#= F_SEND_SUNDAY #;#= S_USER_ID #;#= N_SEND_CODE #" />
</script>