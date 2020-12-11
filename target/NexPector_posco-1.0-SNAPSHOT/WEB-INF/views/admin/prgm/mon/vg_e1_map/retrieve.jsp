<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>VG E1 지점 맵핑</h2><span>Home &gt; 감시장비 관리 &gt; VG E1 지점 맵핑</span></div></div>
<!-- location // -->

<!-- 내용 -->
<!-- 검색영역 -->
<form id="vge1_map_delete_form" name="vge1_map_delete_form" data-role="validator">
<input type="hidden" id="vge1_map_delete_list" name="VGE1_MAP_DELETE_LIST" value=""/>
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
				<input type="file" name="file_uploadpath" id="file_uploadpath" class="file_type1"/>
				<a href="#" id="btn_import" class="css_btn_class3" style="margin-left:5px;">Import</a>&nbsp;&nbsp;
				<a href="#" id="btn_export" class="css_btn_class3" style="margin-left:5px;">Export</a>&nbsp;&nbsp;
				<a href="<c:url value="/admin/go_prgm.mon.vg_e1_map.insert.htm"/>" id="btn_save" class="css_btn_class">등록</a>
				<a href="#" id="btn_remove" class="css_btn_class">삭제</a>			
			</span>
		</div>
	</div>
	<!-- stitle // -->
	<!-- table_typ2-4 -->
	<div id="vge1_map_gird" class="table_typ2-4">
	</div>
</div>
</form>
<!-- manager_contBox1 // -->
<!-- 내용 // -->

<form id="frm"></form>

<form id="go_list_form" method="get">
	<input type="hidden" name="searchParam" value="${param.searchParam}"/>
</form>

<script src="http://cdnjs.cloudflare.com/ajax/libs/jszip/2.4.0/jszip.js"></script>

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
	
	function initSearchData(searchParam) {
		var param = JSON.parse(decodeURIComponent(searchParam));
		$('#N_GROUP_CODE').val(param.N_GROUP_CODE);
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
					url 		: cst.contextPath() + "/admin/kendoPagination_vg_e1_map.select_list.htm",
					data 		: function(data) {
						return {
							/* 
							'N_SNMP_MAN_CODE'   : $.trim($('#N_SNMP_MAN_CODE').val()),
							'N_SNMP_MON_CODE'   : $.trim($('#N_SNMP_MON_CODE').val())
							 */
							'N_GROUP_CODE'  : $.trim($('#N_GROUP_CODE').val()),
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

		grid = $("#vge1_map_gird")
			.kendoGrid($.extend(kendoGridDefaultOpt, {
				toolbar: ["excel"],
	            excel: {
	                fileName: "vg_e1_jum_mapping.xlsx",
	                filterable: true
	            },
				dataSource	: dataSource,
				//change		: selectedRow,
				sortable	: {
					mode 		: 'multiple',
					allowUnsort : true
				},
				dataBound	: girdRowdblclick,
				columns		: [
					{headerTemplate: '<input type="checkbox" id="all_check" value="Y"/>', template: '<input type="checkbox" name="sel_check" value="Y" onchange="checkAll();">', width:'3%', attributes:alignCenter, headerAttributes:{style:'text-align:center;vertical-align:middle'}, sortable : false},
					{field:'N_MON_ID', title:'장비ID', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center;vertical-align:middle'}},
					{field:'S_MON_NAME', title:'장비명', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center;vertical-align:middle'}},
					{field:'S_MON_IP', title:'장비 IP', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center;vertical-align:middle'}},
					{field:'S_GROUP_NAME', title:'그룹명', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center;vertical-align:middle'}},
					{field:'S_DESC', title:'E1 Port', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center;vertical-align:middle'}},
					{field:'JUM_CODE', title:'지점코드', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center;vertical-align:middle'}},
					{field:'GROUP_NAME', title:'지점명', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center;vertical-align:middle'}},
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
		
		$('#btn_import').on('click', excel_import);
		
		$('#btn_export').on('click', excel_export);
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
			'N_GROUP_CODE'		: $('#N_GROUP_CODE').val().trim(),
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
			.attr({'action' : cst.contextPath() + '/admin/go_prgm.mon.vg_e1_map.insert.htm'})
			.submit();

		event.preventDefault();
	}

	// SNMP 장비 선택시 SNMP 상세 코드 값 가져 옴
	function fn_vge1_map_code_change(val, val2)
	{
		$.ajaxSetup({ async:false });
		cfn_makecombo_opt($("#N_SNMP_MON_CODE"), "<c:url value="/admin/lst_common.cmb_vge1_mon_code.htm"/>?N_SNMP_MAN_CODE="+val, function(){
			$("#N_SNMP_MON_CODE").val(val2);
		});
		$.ajaxSetup({ async:true });
	}
	
	// 삭제
	function del()
	{
		if(!confirm("정말 삭제 하시겠습니까?"))
			return;

		var vge1MapGrid = $('#vge1_map_gird').data('kendoGrid');
	    var vge1MapDataItem = vge1MapGrid.dataSource.data();
	    
	    var tmp_vge1_map = "";
	    $("input[name=sel_check]").each(function(index) {
	    	if ($("input[name=sel_check]")[index].checked == true) {
				if (tmp_vge1_map != "") {	
					tmp_vge1_map += ",";
				}
				tmp_vge1_map += vge1MapDataItem[index].N_MON_ID + ";" + 
								vge1MapDataItem[index].N_INDEX ;
	    	}
		});
	    console.log(tmp_vge1_map);
	    $("#vge1_map_delete_list").val(tmp_vge1_map);
	    
		var url = "<c:url value='/admin/vg_e1_map/delete.htm'/>";
		var param = $("form[name='vge1_map_delete_form']").serialize();
		
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
	
	function excel_export() {
		kendo.saveAs({
			  dataURI: workbook.toDataURL(),
			  fileName: "vg_e1_jum_mapping.xlsx"
			});
		/* $('#go_list_form').attr('action', cst.contextPath() + '/admin/kendoPagination_vg_e1_map.excel.htm').submit(); */
	}
	
	function goListPage(event) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.vg_e1_map.retrieve.htm').submit();
	}
	
	var ds = new kendo.data.DataSource({
        type: "odata",
        transport: {
          read: cst.contextPath() + "/admin/go_prgm.mon.vg_e1_map.retrieve.htm",
        },
        schema: {
          model: {
            fields: {
				N_MON_ID: { type: "number" },
				S_MON_NAME: { type: "number" },
				S_MON_IP: { type: "string" },
				S_GROUP_NAME: { type: "date" },
				S_DESC: { type: "string" },
				JUM_CODE: { type: "string" },
				GROUP_NAME: { type: "string" }
            }
          }
        }
      });

      var rows = [{
        cells: [
          { value: "N_MON_ID" },
          { value: "S_MON_NAME" },
          { value: "S_MON_IP" },
          { value: "S_GROUP_NAME" },
          { value: "S_DESC" },
          { value: "JUM_CODE" },
          { value: "GROUP_NAME" }
        ]
      }];

      //using fetch, so we can process the data when the request is successfully completed
      ds.fetch(function(){
        var data = this.data();
        for (var i = 0; i < data.length; i++){
          //push single row for every record
          rows.push({
            cells: [
              { value: data[i].N_MON_ID },
              { value: data[i].S_MON_NAME },
              { value: data[i].S_MON_IP },
              { value: data[i].S_GROUP_NAME },
              { value: data[i].S_DESC },
              { value: data[i].JUM_CODE },
              { value: data[i].GROUP_NAME }
            ]
          })
        }
        var workbook = new kendo.ooxml.Workbook({
          sheets: [
            {
              columns: [
                // Column settings (width)
                { autoWidth: true },
                { autoWidth: true },
                { autoWidth: true },
                { autoWidth: true },
                { autoWidth: true },
                { autoWidth: true },
                { autoWidth: true }
              ],
              // Title of the sheet
              title: "VG E1 Port Mapping",
              // Rows of the sheet
              rows: rows
            }
          ]
        });
        //save the file as Excel file with extension xlsx
        kendo.saveAs({
			  dataURI: workbook.toDataURL(),
			  fileName: "vg_e1_jum_mapping.xlsx"
			});
      });
	
</script>