<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>
<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript" src="<c:url value="/js/history.js" />"></script>
<script type="text/javascript">

	var listTableTempHtml = '';

	var g_phone_state = [
		{ VAL: '등록됨', 	CODE: 'Registered'},
		{ VAL: '미등록됨', 	CODE: 'UnRegistered'}
	];
	
	// Document Ready
	$(function() {
		initialize();

		// Event 등록
		// 검색 버튼
		$('#search').on('click', function(event) {
			event.preventDefault();
			fn_search();
		});

		// 엑셀 저장 버튼
		$('#excel_download_button').on('click', function(event) {
			event.preventDefault();
			fn_excel_download();
		});
		//-- Event 등록
		
		var numValidCheck = {
		    keyDown : function (e) {
		        var key;
		        if(window.event)
		            key = window.event.keyCode; //IE
		        else
		            key = e.which; //firefox
		        var event;
		        if (key == 0 || key == 8 || key == 46 || key == 9){
		            event = e || window.event;
		            if (typeof event.stopPropagation != "undefined") {
		                event.stopPropagation();
		            } else {
		                event.cancelBubble = true;
		            }   
		            return;
		        }
		        if (key < 48 || (key > 57 && key < 96) || key > 105 || e.shiftKey) {
		            e.preventDefault ? e.preventDefault() : e.returnValue = false;
		        }
		    },        
		    keyUp : function (e) {
		        var key;
		        if(window.event)
		            key = window.event.keyCode; //IE
		        else
		            key = e.which; //firefox
		        var event;
		        event = e || window.event;        
		        if ( key == 8 || key == 46 || key == 37 || key == 39 ) 
		            return;
		        else
		            event.target.value = event.target.value.replace(/[^0-9]/g, "");
		    },
		    focusOut : function (ele) {
		        ele.val(ele.val().replace(/[^0-9]/g, ""));
		    }
		};

		$('input:text[onlyNumber]').css("ime-mode", "disabled").keydown( function(e) {
			numValidCheck.keyDown(e);
		}).keyup( function(e){
			numValidCheck.keyUp(e);
		}).focusout( function(e){        
			numValidCheck.focusOut($(this));
		});
		
	});

	// 초기화
	function initialize() {
		// 전화기 상태 DropDownList
		var dataSource1 = new kendo.data.DataSource({ 
			data : g_phone_state
		});
		createDropDownList('phone_state', dataSource1);	

		fn_search();
	}

	// 검색
	function fn_search() {
		var param = {
				'search_phone' : $('#search_phone').val(),
				'ip_address' 	: $('#ip_address').val(), 
				'phone_state' 	: $('#phone_state').data('kendoDropDownList').value(),
				'excelYn' : 'no'
		}
		$('#contents_tr').empty();
		var $contentsServerTr = $('#contents_tr');
		
		$contentsServerTr
		.empty()
		.append( $('<td/>').addClass('bgml1') )
		.append( $('<td/>').addClass('bgmc1')
					.append( $('<div/>')
								.addClass('avaya_stitle1')
								.css('float', 'none')
								.append( $('<div/>')
											//.addClass('st_under')
											.append( $('<span/>').attr('id','totalCount').text('건수'))
											))
					.append( $('<div/>').attr('id', 'serverGrid') ))
		.append( $('<td/>').addClass('bgmr1') );
		
	
		
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/watcher/kendoPagination_IpphoneStatusListQry.htm",
					data 		: param
				},
				parameterMap: function (data, opperation) {
					console.log(data, opperation);
					return JSON.stringify(data);
				}
			},
			schema : {
				data	: function(data) {
					if(data!=null && data.length >0){
						$("#totalCount").text("건수 : "+data[0].TOTAL_COUNT);
					}
					
					return data;
				},
				total 	: function(response) {
					return response.length > 0 ? response[0].TOTAL_COUNT : 0;
				}
			},
			pageSize		: cst.countPerPage(),
			serverPaging	: true,
			serverSorting	: true
		});

		var columns = kendoGridColumns();

		$("#serverGrid")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: dataSource,
				columns		: columns.ipPhoneStatus()
			}));
		
	}
	
	function fn_dynamic_html_pagination(flag) {
		if (flag === 'append') {
			$('#contents_td').append(
					' <div class="tap_pageing4" id="pagenation"> ' +
					' 	<a class="direction prev" href="#"> ' +
					'		<span> </span> <span> </span>' +
					'	</a> ' +
					'	<a class="direction prev" href="#"> ' +
					'		<span> </span>' +
					'	</a> ' +
					'	<span style="line-height:21px;">Page 1 of 2</span> ' +
					'	<a class="direction next" href="#">' +
					'		<span> </span> ' +
					'	</a> ' +
					'	<a class="direction next" href="#">' +
					'		<span> </span> <span> </span> ' +
					'	</a> ' +
					' </div> ')
		} else if (flag === 'remove') {
			$('#pagination').remove();
		} else {
			return;
		}
	}

	// 엑셀 Download
	function fn_excel_download() {
		var url = cst.contextPath() + '/watcher/go_history_stats.ipphone_status.excel.ipphone_status_excel.htm';
		var req_data="resultList;IpphoneStatusListQry"; 
		$("#excel_req_data").val(req_data);
		$('#excel_search_phone').val($("#search_phone").val());
		$('#excel_ip_address').val($("#ip_address").val());
		$("#excel_phone_state").val($('#phone_state').data('kendoDropDownList').value());
		
		$('#excel_down_form').attr({ method : 'post', 'action' : url }).submit();
	}

</script>

<!-- excel download form -->
<form id="excel_down_form" name="excelDownFrm">
	<input type="hidden" id="excel_req_data" name="req_data" value=""/>
	<input type="hidden" id="excel_search_phone" name="search_phone" value=""/>
	<input type="hidden" id="excel_ip_address" name="ip_address" value=""/>
	<input type="hidden" id="excel_phone_state" name="phone_state">
</form>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>IP-Phone 현황</h2><span>Home &gt; 이력/통계 조회 &gt; IP-Phone 현황</span></div></div>

<!-- 내용 -->
<!-- 검색영역 -->
<form id="frm" name="frm">
<input type="hidden" value="no" name="excelYn">
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<dd>
					<strong>전화번호</strong>
					<input type="text" name="search_phone" autocomplete="off" id="search_phone" class="int_f input_search" value="" onlyNumber/>
				</dd>
			</dl>
			<dl>
				<dd>
					<strong>IP Address</strong>
					<input type="text" name="ip_address" id="ip_address" class="int_f input_search" value="" />
				</dd>
			</dl>
			<dl>
				<dd>
					<strong>전화기상태</strong>
					<input id="phone_state" name="phone_state" class="input_search" style="width: 120px" />
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
</form>
<!-- his_contBox -->
<div class="his_contBox">
	<table cellpadding="0" cellspacing="0">
		<tr>
			<td class="bgtl1"></td>
			<td class="bgtc1">
				<span class="stop_btbox">
					<a href="#"><img id="excel_download_button" src="<c:url value="/images/botton/excel.jpg"/>" alt="엑셀저장" /></a>
				</span>
			</td>
			<td class="bgtr1"></td>
		</tr>
		<tr id="contents_tr">
			
		</tr>
	
		<tr>
			<td class="bgbl1"></td>
			<td class="bgbc1"></td>
		</tr>
	</table>

</div>