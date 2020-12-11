<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>전국 전화기 관리</h2><span>Home &gt; 감시장비 관리 &gt; 전국 전화기 관리</span></div></div>
<!-- location // -->

<!-- 내용 -->
<!-- 검색영역 -->
<form name="frm" id="frm" method="post" enctype="multipart/form-data">
<input type="hidden" id="jijum_delete_list" name="JIJUM_DELETE_LIST" value=""/>
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<dd>
					<strong style="margin-left:30px;">전화번호</strong><input type="text" name="S_EXT_NUM" id="S_EXT_NUM" value="${param.S_EXT_NUM}" class="int_f"/>
					<strong style="margin-left:30px;">IP Address</strong><input type="text" name="S_IP_ADDRESS" id="S_IP_ADDRESS" value="${param.S_IP_ADDRESS}" class="int_f"/>
					<strong style="margin-left:30px;">사업국명</strong><input type="text" name="S_NAME" id="S_NAME" value="${param.S_NAME}" class="int_f"/>
					<strong style="margin-left:30px;">러닝명</strong><input type="text" name="S_RUNNING" id="S_RUNNING" value="${param.S_RUNNING}" class="int_f"/>
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
				<input type="file" name="file_uploadpath" id="file_uploadpath" class="file_type1"/>
				<a href="#" id="btn_import" class="css_btn_class3" style="margin-left:5px;" disabled>Import</a>
				<a href="javascript:exportJijumData();" id="btn_export" class="css_btn_class3" style="margin-left:5px;">Export</a>
				<a href="javascript:;" id="btn_remove" class="css_btn_class" style="margin-left:5px;">삭제</a>
				<a href="<c:url value="/admin/go_prgm.mon.jijum.insert.htm"/>" id="btn_save" class="css_btn_class" style="margin-left:5px;">등록</a>
			</span>
		</div>
	</div>
	<!-- stitle // -->
	<!-- table_typ2-4 -->
	<div id="jijum_gird" class="table_typ2-4">
	</div>
</div>
<!-- manager_contBox1 // -->
</form>
<form name="uform" id="uform" method="post"></form>

<script type="text/javascript" src="<c:url value="/common/js/jquery.form.js"/>"></script>
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
	
	// 사용자 목록 Grid
	function InitGrid() {
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/kendoPagination_jijum.selList.htm",
					data 		: function(data) {
						return {
							'S_GROUP_NAME'   : $.trim($('#S_GROUP_NAME').val()),
							'S_NAME'   : $.trim($('#S_NAME').val()),
							'S_IP_ADDRESS'   : $.trim($('#S_IP_ADDRESS').val()),
							'S_EXT_NUM'   : $.trim($('#S_EXT_NUM').val()),
							'S_RUNNING'   : $.trim($('#S_RUNNING').val()),
							'D_INS_DATE'   : $.trim($('#D_INS_DATE').val())
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

		$("#jijum_gird")
			.kendoGrid($.extend(kendoGridDefaultOpt, {
				dataSource	: dataSource,
				change		: selectedRow,
				sortable	: {
					mode 		: 'multiple',
					allowUnsort : true
				},
				columns		: [
					{headerTemplate: '<input type="checkbox" id="all_check" value="Y"/>', template: '<input type="checkbox" name="sel_check" value="Y" onchange="checkAll();">', width:'3%', attributes:alignCenter, headerAttributes:alignCenter, sortable : false},
					{field:'S_GROUP_NAME', title:'본부', width:'8%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_NAME', title:'사업국', width:'8%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_RUNNING', title:'러닝', width:'8%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_GUBUN', title:'구분', width:'8%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_IP_ADDRESS', title:'IP', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_EXT_NUM', title:'전화번호', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_ADDRESS', title:'주소', width:'*%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'D_INS_DATE', title:'등록일시', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				]
			}));
	}
	
	// Event 등록
	function initEvent() {
		$('#btn_import').on('click', function(event) {
			fn_file_import();
		});
		
		$('#search').on('click', function(event) {
			
			event.preventDefault();
			$("#jijum_gird").data('kendoGrid').dataSource.read();
			$('#jijum_gird').data('kendoGrid').dataSource.page(1);
		});
		
		$('#all_check').on('change', function() {
			if (this.checked) {
				$('input[name=sel_check]').prop('checked', true);
			} else {
				$('input[name=sel_check]').prop('checked', false);
			}
		});
		
		$(".input_search").keypress(function(event){
			if(kendo.keys.ENTER === event.keyCode)
				$("#search").click();
		});
		
		$('#btn_remove').on('click', fn_multi_delete);
	}
	

	function fn_file_init() {

		$("#file_uploadpath").val("");
		$("#file_uploadpath").replaceWith( $("#file_uploadpath").clone(true) );

		$("#btn_import").text("Import");

		$('#btn_import').unbind('click', false);
		$('#btn_export').unbind('click', false);
		$('#btn_remove').unbind('click', false);
		$('#btn_save').unbind('click', false);
	}
	
	function fn_file_import() {
		$('#btn_import').bind('click', false);
		$('#btn_export').bind('click', false);
		$('#btn_remove').bind('click', false);
		$('#btn_save').bind('click', false);
		
		var file = $("#file_uploadpath").val();
		if (file == null || file == "") {
			alert("Excel 파일이 없습니다. \n파일을 선택해 주십시오.");
			fn_file_init();
			return;
		}

		var nameSize = file.length;
		var chk = false;
		if (nameSize > 4) {
			var temp = file.substring((nameSize -4), nameSize);
			if (temp.toLowerCase() != ".xls") {
				chk = true;
			}
		} else {
			chk = true;
		}

		if (chk) {
			alert("지원하는 파일 형식이 아닙니다. \n*.xls 형식을 지원합니다.");
			fn_file_init();
			return;
		}

		$("#btn_import").text("Uploading");

		var options = {
		        success: function(jdata) {
		        	var resultCode = jdata.RSLT;

					if (resultCode == 0) {
						alert("지점전화기 정보가 등록 되었습니다.\n" + jdata.RSLT_MSG);
					} else if (resultCode == -1) {
						alert("정상적인 파일이 아닙니다.");
					} else if (resultCode == -10) {
						alert("엑셀 서식이 맞지 않습니다.");
					} else if (resultCode == -20) {
						alert("등록할 수 없는 교환기ID 입니다.\n" + jdata.RSLT_MSG);
					} else if (resultCode == -21) {
						alert("전화기IP 형식이 맞지 않습니다.\n" + jdata.RSLT_MSG);
					} else if (resultCode == -22) {
						alert("내선번호 입력값을 확인하십시오.\n" + jdata.RSLT_MSG);
					} else if (resultCode == -23) {
						alert("사용자 정보 입력값을 확인하십시오.\n" + jdata.RSLT_MSG);
					} else if (resultCode == -24) {
						alert("SNMP Community 입력값을 확인하십시오.\n" + jdata.RSLT_MSG);
					} else if (resultCode == -25) {
						alert("SNMP Version 입력값을 확인하십시오.\n" + jdata.RSLT_MSG);
					} else if (resultCode == -26) {
						alert("SNMP Port 입력값을 확인하십시오.\n" + jdata.RSLT_MSG);
					} else if (resultCode == -27) {
						alert("사용자 정보 입력값을 확인하십시오.\n" + jdata.RSLT_MSG);
					} else if (resultCode == -28) {
						alert("등록할 수 없는 전화기 그룹 코드 입니다.\n" + jdata.RSLT_MSG);
					} else if (resultCode == -900) {
						alert("등록할 수 없는 지역구분입니다.\n"			+ jdata.RSLT_MSG);
					} else if (resultCode == -1000) {
						alert("데이터가 중복되어 등록할 수 없습니다.\n" + jdata.RSLT_MSG);
					} else {
						alert("오류 코드 : " + jdata.RSLT + ", 오류 메시지 : " + jdata.RSLT_MSG);
					}

					fn_file_init();
					initSearchData('${param.searchParam}');
				},
				url: "<c:url value="/admin/jijum_file_import.htm"/>",
				type: 'post',
				dataType: 'json'
		};

		$('#frm').ajaxSubmit(options);
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
			'S_GUBUN'		: $('#S_GUBUN').val(),
			'S_NAME'		: $('#S_NAME').val(),
			'S_RUNNING'		: $('#S_RUNNING').val(),
			'currentPageNo'	: $('#jijum_gird').data('kendoGrid').dataSource.page()
		};
		var paramStr = JSON.stringify(param);
		$('#uform')
			.append('<input type="hidden" name="searchParam" value="' + encodeURIComponent(paramStr) + '">')
			.append('<input type="hidden" name="KEY_IP_ADDRESS" value="' + this.dataItem(this.select()).S_IP_ADDRESS + '">')
			.append('<input type="hidden" name="KEY_EXT_NUM" value="' + this.dataItem(this.select()).S_EXT_NUM + '">')
			.append('<input type="hidden" name="UPD_FLAG" value="U">')
			.attr({'action' : cst.contextPath() + '/admin/go_prgm.mon.jijum.insert.htm'})
			.submit();

		event.preventDefault();
	}

	function initSearchData(searchParam) {
		var param = JSON.parse(decodeURIComponent(searchParam));
		$('#N_MON_ID').val(param.N_MON_ID);
		$('#S_IP_ADDRESS').val(param.S_IP_ADDRESS);
		$('#S_TYPE').val(param.S_TYPE);
		$('#N_GROUP').val(param.N_GROUP);
		$('#jijum_gird').data('kendoGrid').dataSource.page(param.currentPageNo);
	}
	
	function exportJijumData() {
		var ext_num		= $('#S_EXT_NUM').val();
		var ip_address	= $('#S_IP_ADDRESS').val();
		var name		= $('#S_NAME').val();
		
		location.href	= '/admin/jijum_file_export.htm?S_EXT_NUM=' + ext_num + '&S_IP_ADDRESS=' + ip_address + '&S_NAME=' + name;
	}
	
	// 선택 삭제
	function fn_multi_delete() {
		var jijumMapGrid		= $('#jijum_gird').data('kendoGrid');
	    var jijumMapDataItem 	= jijumMapGrid.dataSource.data();
	    
	    var tmp_jijum = "";
	    var	sel_count = 0;

	    $("input[name=sel_check]").each(function(index) {
	    	if ($("input[name=sel_check]")[index].checked == true) {
				if (tmp_jijum != "") {	
					tmp_jijum += ",";
				}
				tmp_jijum += jijumMapDataItem[index].S_IP_ADDRESS;
				sel_count ++;
	    	}
		});
	    $("#jijum_delete_list").val(tmp_jijum);
	    if (sel_count <= 0) {
	    	alert("삭제할 항목을 선택하십시오.");
	    	return;
	    }
		if(!confirm("정말 삭제 하시겠습니까?"))
			return;
	    
		var url = "<c:url value='/admin/jijum_map/delete.htm'/>";
		var param = $("form[name='frm']").serialize();
		
		$.post(url, param, function(str){
			var data = $.parseJSON(str);
			if(data.RSLT != null && data.RSLT > 0) {
				alert('삭제되었습니다.');
				location.href = '/admin/go_prgm.mon.jijum.retrieve.htm?' + '${pageContext.request.queryString}';
				return;
			}
			else {
				alert("삭제 실패 하였습니다.\n" + data.ERRMSG + "");
				location.href = '/admin/go_prgm.mon.jijum.retrieve.htm?' + '${pageContext.request.queryString}';
				return;
			}
		});
	}
	
</script>