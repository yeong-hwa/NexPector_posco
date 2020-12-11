<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>감시장비 정보 관리</h2><span>Home &gt; 감시장비 관리 &gt; 감시장비 정보 관리</span></div></div>
<!-- location // -->

<!-- 내용 -->
<!-- 검색영역 -->
<form id="mon_info_delete_form" name="mon_info_delete_form" data-role="validator" enctype="multipart/form-data">
<input type="hidden" id="mon_info_delete_list" name="MON_INFO_DELETE_LIST" value=""/>
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<dd>
					<strong>장비그룹</strong><cmb:combo qryname="cmb_svr_group" seltagname="N_GROUP_CODE" firstdata="전체" etc="id=\"N_GROUP_CODE\""/>
					<strong style="margin-left:30px;">장비타입</strong><cmb:combo qryname="cmb_svr_type" seltagname="N_TYPE_CODE" firstdata="전체" etc="id=\"N_TYPE_CODE\""/>
					<%-- 
					<strong style="margin-left:30px;">장비명</strong><input type="text" name="S_MON_NAME" id="S_MON_NAME" value="${param.S_MON_NAME}" class="int_f input_search"/>
					<strong style="margin-left:30px;">장비IP</strong><input type="text" name="S_MON_IP" id="S_MON_IP" value="${param.S_MON_IP}" class="int_f input_search"/>
					 --%>
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
				<!-- <input type="file" name="file_uploadpath" id="file_uploadpath" class="file_type1"/>
				<a href="#" id="btn_import" class="css_btn_class3" style="margin-left:5px;">Import</a>&nbsp;&nbsp;  -->
				<a href="#" id="btn_save" class="css_btn_class">등록</a>
				<a href="#" id="btn_remove" class="css_btn_class">삭제</a>
			</span>
		</div>
	</div>
	<!-- stitle // -->
	<!-- table_typ2-4 -->
	<div id="mon_info_gird" class="table_typ2-4">
	</div>
</div>
</form>
<!-- manager_contBox1 // -->
<!-- 내용 // -->

<form id="frm"></form>

<form id="go_list_form" method="get">
	<input type="hidden" name="searchParam" value="${param.searchParam}"/>
</form>

<script type="text/javascript" src="<c:url value="/common/js/jquery.form.js"/>"></script>
<script type="text/javascript">

	var grid;

	$(document).ready(function() {
		initGrid();
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
	function initGrid() {
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/kendoPagination_mon_info.select_list.htm",
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
					
					if($('#mon_info_gird').data('kendoGrid').dataSource.page() != 1 && ($('#mon_info_gird').data('kendoGrid').dataSource.page()-1) * $('#mon_info_gird').data('kendoGrid').dataSource.pageSize() > totalCount){

						$('#mon_info_gird').data('kendoGrid').dataSource.page(1);
					}
					return totalCount;
				}
			},
			pageSize		: cst.countPerPage(),
			serverPaging	: true,
			serverSorting	: true
		});

		grid = $("#mon_info_gird")
			.kendoGrid($.extend(kendoGridDefaultOpt, {
				dataSource	: dataSource,
				//change		: selectedRow,
				sortable	: {
					mode 		: 'multiple',
					allowUnsort : true
				},
				dataBound	: gridRowdblclick,
				columns		: [
					{headerTemplate: '<input type="checkbox" id="all_check" value="Y"/>', template: '<input type="checkbox" name="sel_check" value="Y" onchange="checkAll();">', width:'5%', attributes:alignCenter, headerAttributes:alignCenter, sortable : false},				       		   
					{field:'N_MON_ID', title:'장비ID', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_MON_NAME', title:'장비명', width:'20%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_HOST', title:'호스트명', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_DESC', title:'설명', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_MON_IP', title:'장비IP', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'TYPE_NAME', title:'장비타입', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'GROUP_NAME', title:'장비그룹', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'STYLE_NAME', title:'장비감시타입', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}}
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
		
		$('#btn_save').on('click', function(event) {
			event.preventDefault();
			fn_add_mon();
		});
				
		
		$('#all_check').on('change', function() {
			if (this.checked) {
				$('input[name=sel_check]').prop('checked', true);
			} else {
				$('input[name=sel_check]').prop('checked', false);
			}
		});
		
		$('#btn_remove').on('click', del);
		
		$('#btn_import').on('click', excel_import);
	}
	
	//Grid dblclick Event
	function gridRowdblclick(e) {
		
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
			'N_GROUP_CODE'	: $('#N_GROUP_CODE').val(),
			'N_TYPE_CODE'	: $('#N_TYPE_CODE').val(),
			'SEARCH_TYPE'   : $.trim($('#SEARCH_TYPE').val()),
			'SEARCH_KEYWORD': $.trim($('#SEARCH_KEYWORD').val()),
			'currentPageNo'	: grid.dataSource.page()
		};
		var paramStr = JSON.stringify(param);

		$('#frm')
			.append('<input type="hidden" name="searchParam" value="' + encodeURIComponent(paramStr) + '">')
			.append('<input type="hidden" name="N_MON_ID" value="' + grid.dataItem(grid.select()).N_MON_ID + '">')
			.append('<input type="hidden" name="N_SNMP_MAN_CODE" value="' + grid.dataItem(grid.select()).N_SNMP_MAN_CODE + '">')
			.append('<input type="hidden" name="S_SNMP_IP" value="' + grid.dataItem(grid.select()).S_SNMP_IP + '">')
			.append('<input type="hidden" name="updateFlag" value="U">')
			.attr({'action' : cst.contextPath() + '/admin/go_prgm.mon.mon_info.insert.htm'})
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
	

	function fn_add_mon() {
		var chk = true;
		
		var param = { 
				'TYPE' : 0
		};
		
		$.getJSON('/watcher/server_detail/svrLicenseCheck.htm', param)
		.done(function(data) {
			console.log(data.lic_info);
			
			if(data.lic_info && data.lic_info.length > 1 ) {
				var svrCnt = data.lic_info[0].COUNT;
				var licCnt = data.lic_info[1].COUNT;
				
				console.log(svrCnt + ", " + licCnt);
				
				if(svrCnt >= licCnt) {
					alert("라이센스 보다 많은 장비를 등록할 수 없습니다.");
					return;
				}
				else
					location.href = "/admin/go_prgm.mon.mon_info.insert.htm";
			}
		});
		
		
	}
	
	// 삭제
	function del()
	{
		if(!fn_validation_chk())
			return;
		
		if(!confirm("정말 삭제 하시겠습니까?"))
			return;

		var monInfoGrid = $('#mon_info_gird').data('kendoGrid');
	    var monInfoDataItem = monInfoGrid.dataSource.data();
	    
	    var tmp_mon_info = "";
	    $("input[name=sel_check]").each(function(index) {
	    	if ($("input[name=sel_check]")[index].checked == true) {
				if (tmp_mon_info != "") {	
					tmp_mon_info += ",";
				}
				tmp_mon_info += monInfoDataItem[index].N_MON_ID + ";" + 
								monInfoDataItem[index].S_MON_IP
	    	}
		});
	    $("#mon_info_delete_list").val(tmp_mon_info);
	    
	    $.blockUI(blockUIOption);
	    var url = "<c:url value='/admin/delete_mon_info.htm'/>";
		var param = $("form[name='mon_info_delete_form']").serialize();
		
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
		})
		.always(function() {
			$.unblockUI();
		});	
	}
	
	function goListPage() {
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.mon_info.retrieve.htm').submit();
	}
	
	function excel_import() {
		var file = $("#file_uploadpath").val();
		if (file == null || file == "") {
			alert("Excel 파일이 없습니다. \n파일을 선택해 주십시오.");
			return;
		}
		
		var nameSize = file.length;
		var chk = false;
		var excelForm_xls = file.substring((nameSize -4), nameSize);
		var excelForm_xlsx = file.substring((nameSize -5), nameSize);
		
		if(excelForm_xls.toLowerCase() == ".xls" || excelForm_xlsx.toLowerCase() == ".xlsx") {
			chk = true;
		} 
		
		if (!chk) {
			alert("지원하는 파일 형식이 아닙니다. \n*.xls, *.xlsx 형식을 지원합니다.");
			$("#file_uploadpath").val("");
			return;
		}
		
		$("#btn_import").text("Uploading");
		
		var options = {
		        success: function(data) {
		        	$("#btn_import").text("Import");
		        	
					if(data.RSLT != null && data.RSLT > 0) {
						alert('excel Import 성공 하였습니다.');
						goListPage();
						return;
					}
					else {
						alert("excel Import 실패 하였습니다.\n" + data.ERRMSG + "");
						goListPage();
						return;
					}
				},
				url: "<c:url value='/admin/excel_mon_info.htm'/>",
				type: 'post',
				dataType: 'json'
		};

		$('#mon_info_delete_form').ajaxSubmit(options);
	}
</script>