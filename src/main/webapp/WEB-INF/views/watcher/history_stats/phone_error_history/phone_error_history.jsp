<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript" src="<c:url value="/js/phone_history.js" />"></script>
<script>
	$(function() {
		initialize();
		
		// Event 등록
		$(".input_search").keypress(function(event){
			if(event.keyCode == "13")
				$("#search").click();
		});

		// 검색 버튼
		$("#search").on("click", function(event) {
			event.preventDefault();
			fn_retrieve();
		});

		// 엑셀 저장 버튼
		$("#excel_download_button").on("click", function(event) {
			event.preventDefault();
			fn_excel_download();
		});
		
		// 미표시 삭제 버튼
		$("#btn_del_not_disp").on("click", function(event) {
			event.preventDefault();
			fn_del_not_disp();
		});
		//-- Event 등록
	});

	function initialize() {
		var start = createStartKendoDatepicker("start_date");
		var end = createEndKendoDatepicker("end_date");
		start.max(end.value());
		end.min(start.value());

		// 지역그룹 DropDownList
		var dataSource = new kendo.data.DataSource({
			transport: {
				read: {
					// url: cst.contextPath() + "/watcher/lst_cmb_s_location.htm",
					url: cst.contextPath() + "/watcher/lst_cmb_nMonJijumId.htm",
					dataType: "json"
				}
			}
		});

		createDropDownList("s_location", dataSource, {optionLabel : "전체"});
		//-- 지역그룹 DropDownList

		fn_retrieve();
	}

	function fn_retrieve() {
		var $contentsTr = $("#contents_tr");
		var param = {
			"S_ST_DT" 		: $("#start_date").val().replace(/-/gi, ""),
			"S_ED_DT" 		: $("#end_date").val().replace(/-/gi, ""),
			"S_LOCATION" 	: ($("#s_location").data("kendoDropDownList").value() == "") ? "ALL" : $("#s_location").data("kendoDropDownList").value()
		};
		
		$contentsTr
			.empty()
			.append( $("<td/>").addClass("bgml1") )
			.append( $("<td/>").addClass("bgmc1")
						.append( $("<div/>")
									.addClass("avaya_stitle1")
									.css("float", "none")
									.append( $("<div/>")
												.addClass("st_under")
												.append( $("<h4/>").text("전화기 장애 이력 조회"))))
						.append( $("<div/>").attr("id", "grid") ))
			.append( $("<td/>").addClass("bgmr1") );
		
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: "post",
					dataType	: "json",
					contentType	: "application/json;charset=UTF-8",
					url 		: cst.contextPath() + "/watcher/kendoPagination_statsPhoneErrorHistoryRetrieveQry.htm",
					data 		: param
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
					return response.length > 0 ? response[0].TOTAL_COUNT : 0;
				}
			},
			pageSize		: cst.countPerPage(),
			serverPaging	: true,
			serverSorting	: true
		});

		// var columns = kendoGridColumns();

		$("#grid")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: dataSource,
				dataBound   : function(e) {
					
					gridDataBound(e);
					
					$("#all_check").on("click", function() {
						if(this.checked) {
							$("input[name=S_ALM_PHONE_KEY]").prop("checked", true);
						} else {
							$("input[name=S_ALM_PHONE_KEY]").prop("checked", false);
						}
					});
				},
				sortable	: {
					mode : "multiple",
					allowUnsort : true
				},
				// columns		: columns.error()
				columns		: [
					{headerTemplate: '<input type="checkbox" id="all_check" name="ALL_CHECK" value="Y"/>', width:'5%', attributes:_txtCenter, headerAttributes:_txtCenter, sortable : false, template:kendo.template($('#checkboxTemplate').html())},
				    {field:'D_UPDATE_TIME', title:'발생시각', width:'120px', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_ALM_STATUS_NAME', title:'상태', width:'120px', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_LOCATION', title:'지역', width:'120px', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_NAME', title:'지점명', width:'120px', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_RUNNING', title:'러닝명', width:'80px', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_IP_ADDRESS', title:'IP Address', width:'100px', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_EXT_NUM', title:'전화번호', width:'100px', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'D_SKIP_TIME', title:'미표시기간', width:'200px', attributes:_txtLeft, headerAttributes:_txtCenter}
				]
			}));
	}
	
	function fn_excel_download() {
		var url = cst.contextPath() + "/watcher/go_history_stats.phone_error_history.excel.phone_error_history_excel.htm?req_data=data;statsPhoneErrorHistoryRetrieveExcelQry";

		$("#excel_start_date").val($("#start_date").val().replace(/-/gi, ""));
		$("#excel_end_date").val($("#end_date").val().replace(/-/gi, ""));
		$("#excel_s_location").val($("#s_location").data("kendoDropDownList").value());
		$("#excel_down_form").attr({ method : "post", "action" : url }).submit();
	}
	
	function fn_del_not_disp() {
		var url = "/watcher/phone_error_history/modify_d_skip_time.htm";
		var params = "";
		var jqXhr = "";
		
		$("input[name='S_ALM_PHONE_KEY']:checked").each(function(index, element) {
			// 미표시 기간 삭제 로직(미표시 기간 UPDATE 수행)
			params = $(this).val().split(" ");	// $(this).val() → 시간 + IP
			
			params = {
				"D_SKIP_TIME" : params[0] + " " + params[1],	// 2018-07-27 15:55:09 → 시간
				"S_IP_ADDRESS" : params[2]						// 20.21.8.102 → IP
			};
			
			jqXhr = $.post(url, params);
		});
		
		jqXhr.done(function(str) {
			var data = $.parseJSON(str);
			if(parseInt(data.RSLT) > 0) {
				alert("삭제되었습니다.");
				fn_retrieve();
				return;
			} else {
				alert("삭제에 실패 하였습니다.");
				return;
			}
		});
	}
</script>

<!-- excel download form -->
<form id="excel_down_form" name="excelDownFrm" style="display:none;">
	<input type="hidden" id="excel_start_date" name="S_ST_DT" value=""/>
	<input type="hidden" id="excel_end_date" name="S_ED_DT" value=""/>
	<input type="hidden" id="excel_s_location" name="S_LOCATION" value=""/>
</form>

<script id="cellTemplate" type="text/x-kendo-tmpl">
	<td>
	   <img src="../content/web/Employees/#:data.EmployeeID#.jpg" alt="#: data.EmployeeID #" />
	</td>
</script>

<script id="checkboxTemplate" type="text/x-kendo-template">
	<input type="checkbox" name="S_ALM_PHONE_KEY" value="#= S_ALM_PHONE_KEY #"/>
</script>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>전화기 장애 이력</h2><span>Home &gt; 이력/통계 조회 &gt; 전화기 장애 이력</span></div></div>
<!-- location // -->
<!-- 내용 -->
<!-- 검색영역 -->
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<dd>
					<strong>검색기간</strong>
					<input type="text" id="start_date" name="S_ST_DT" class="input_search" value="" /> ~ <input type="text" name="S_ED_DT" id="end_date" class="input_search" value="" />
				</dd>
				<dd>
					<strong style="display:inline-block; width:60px;">지역</strong>
					<input id="s_location" name="S_LOCATION" class="input_search" style="width: 120px;" />
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
<!-- his_contBox -->
<div class="his_contBox">
	<table cellpadding="0" cellspacing="0">
		<tr>
			<td class="bgtl1"></td>
			<td class="bgtc1">
				<span class="stop_btbox">
					<a href="#" id="btn_del_not_disp"><img src="<c:url value="/images/botton/nomark_del.jpg"/>" alt="미표시삭제" /></a>
					<a href="#" id="excel_download_button"><img src="<c:url value="/images/botton/excel.jpg"/>" alt="엑셀저장" /></a>
				</span>
			</td>
			<td class="bgtr1"></td>
		</tr>
		<tr id="contents_tr">
			<!-- 동적 생성 -->
		</tr>
		<tr>
			<td class="bgbl1"></td>
			<td class="bgbc1"></td>
			<td class="bgbr1"></td>
		</tr>
	</table>
</div>
<!-- his_contBox // -->
<!-- 내용 // -->