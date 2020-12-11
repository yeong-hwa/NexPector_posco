<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>IP Phone 관리</h2><span>Home &gt; 감시장비 관리 &gt; IP Phone 관리</span></div></div>
<!-- location // -->

<!-- 내용 -->
<!-- 검색영역 -->
<form name="frm" id="frm" method="post" enctype="multipart/form-data">
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<dd>
					<strong>CM</strong><cmb:combo qryname="cmb_nMonId" seltagname="N_MON_ID" firstdata="전체" etc="class=\"input_search\" id=\"N_MON_ID\""/>
					<strong style="margin-left:30px;">IP</strong><input type="text" name="S_IPADDRESS" id="S_IPADDRESS" value="${param.S_IPADDRESS}" class="int_f"/>
					<strong style="margin-left:30px;">전화기 타입</strong><input type="text" name="S_TYPE" id="S_TYPE" value="${param.S_TYPE}" class="int_f"/>
					<strong style="margin-left:30px;">전화기 그룹</strong><cmb:combo qryname="cmb_svr_group" seltagname="N_GROUP" firstdata="전체" etc="id=\"N_GROUP\""/>
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
				<a href="#" id="btn_import" class="css_btn_class3" style="margin-left:5px;">Import</a>
				<a href="<c:url value="/admin/ipphone_file_export.htm"/>" id="btn_export" class="css_btn_class3" style="margin-left:5px;">Export</a>
				<a href="<c:url value="/admin/go_prgm.mon.ipphone.insert.htm"/>" id="btn_save" class="css_btn_class">등록</a>
			</span>
		</div>
	</div>
	<!-- stitle // -->
	<!-- table_typ2-4 -->
	<div id="ipphone_gird" class="table_typ2-4">
	</div>
</div>
<!-- manager_contBox1 // -->
</form>

<script type="text/javascript" src="<c:url value="/common/js/jquery.form.js"/>"></script>
<script type="text/javascript">
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
					url 		: cst.contextPath() + "/admin/kendoPagination_ipphone.selPhoneList.htm",
					data 		: function(data) {
						return {
							'N_MON_ID'   : $.trim($('#N_MON_ID').val()),
							'S_IPADDRESS'   : $.trim($('#S_IPADDRESS').val()),
							'S_TYPE'   : $.trim($('#S_TYPE').val()),
							'N_GROUP'   : $.trim($('#N_GROUP').val())
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

		$("#ipphone_gird")
			.kendoGrid($.extend(kendoGridDefaultOpt, {
				dataSource	: dataSource,
				change		: selectedRow,
				sortable	: {
					mode 		: 'multiple',
					allowUnsort : true
				},
				columns		: [
					{field:'N_MON_ID', title:'교환기 ID', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_MON_NAME', title:'교환기명', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_NAME', title:'사용자 정보', width:'40%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_EXT_NUM', title:'내선번호', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_IPADDRESS', title:'전화기 IP', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_TYPE', title:'전화기 타입', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'N_GROUP_NAME', title:'전화기 그룹', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}}
				]
			}));
	}
	
	// Event 등록
	function initEvent() {
		$(".input_search").keypress(function(event){
			if(kendo.keys.ENTER === event.keyCode)
				$("#search").click();
		});

		$('#btn_import').on('click', function(event) {
			fn_file_import();
		});
		
		$('#search').on('click', function(event) {
			event.preventDefault();
			$("#ipphone_gird").data('kendoGrid').dataSource.read();
		});
	}

	function fn_file_init() {

		$("#file_uploadpath").val("");
		$("#file_uploadpath").replaceWith( $("#file_uploadpath").clone(true) );

		$("#btn_import").val("Import");

		$("#btn_import").attr("disabled", false);
		$("#btn_export").attr("disabled", false);
		$("#btn_save").attr("disabled", false);

	}
	
	function fn_file_import() {

		$("#btn_import").attr("disabled", true);
		$("#btn_export").attr("disabled", true);
		$("#btn_save").attr("disabled", true);

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

		$("#btn_import").val("Uploading");

		var options = {
		        success: function(jdata) {
		        	var resultCode = jdata.RSLT;

					if (resultCode == 0) {
						alert("전화기 정보가 등록 되었습니다.\n" + jdata.RSLT_MSG);
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
					} else if (resultCode == -1000) {
						alert("데이터가 중복되어 등록할 수 없습니다.\n" + jdata.RSLT_MSG);
					} else {
						alert("오류 코드 : " + jdata.RSLT + ", 오류 메시지 : " + jdata.RSLT_MSG);
					}

					fn_file_init();
					initSearchData('${param.searchParam}');
				},
				url: "<c:url value="/admin/ipphone_file_import.htm"/>",
				type: 'post',
				dataType: 'json'
		};

		$('#frm').ajaxSubmit(options);
	}
	
	// Selected Grid Row
	function selectedRow(event) {

		// 검색 조건과 페이지 번호를 JSON 형태의 String 으로 넘겼다가 다시 받아오기 위함
		var param = {
			'N_MON_ID'	: $('#N_MON_ID').val().trim(),
			'S_IPADDRESS'	: $('#S_IPADDRESS').val().trim(),
			'N_GROUP'	: $('#N_GROUP').val().trim(),
			'currentPageNo'		: $('#ipphone_gird').data('kendoGrid').dataSource.page()
		};
		var paramStr = JSON.stringify(param);

		$('#frm')
			.append('<input type="hidden" name="searchParam" value="' + encodeURIComponent(paramStr) + '">')
			.append('<input type="hidden" name="N_MON_ID" value="' + this.dataItem(this.select()).N_MON_ID + '">')
			.append('<input type="hidden" name="S_IPADDRESS" value="' + this.dataItem(this.select()).S_IPADDRESS + '">')
			.append('<input type="hidden" name="N_GROUP" value="' + this.dataItem(this.select()).N_GROUP + '">')
			.append('<input type="hidden" name="updateFlag" value="U">')
			.attr({'action' : cst.contextPath() + '/admin/go_prgm.mon.ipphone.insert.htm'})
			.submit();

		event.preventDefault();
	}

	function initSearchData(searchParam) {
		var param = JSON.parse(decodeURIComponent(searchParam));
		$('#N_MON_ID').val(param.N_MON_ID);
		$('#S_IPADDRESS').val(param.S_IPADDRESS);
		$('#S_TYPE').val(param.S_TYPE);
		$('#N_GROUP').val(param.N_GROUP);
		$('#ipphone_gird').data('kendoGrid').dataSource.page(param.currentPageNo);
	}
</script>