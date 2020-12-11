<%@ page import="com.nns.common.util.RSACrypt" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>
<%
	String action_file = "snmp_alarm_mgr";
%>
<!-- location -->
<div class="locationBox"><div class="st_under"><h2>SNMP임계치 정보 등록</h2><span>Home &gt; 감시장비 관리 &gt; SNMP임계치 정보 등록</span></div></div>

<div style="float: left;margin-bottom: 5px;">
	<a href="#" id="btn_list" class="css_btn_class">목록</a>
</div>
<form id="register_form" name="register_form" method="post">
	<!-- manager_contBox1 -->
	<div class="manager_contBox1">
		<!-- 사용자리스트 -->
		<div class="mana_box2">
			<div class="box_a">
			
				<c:if test="${param.updateFlag == 'U'}">
					<!-- 사용자등록 -->
					<div class="table_typ2-5">
						<!-- stitle -->
						<div class="stitle"><div class="st_under"><h4>서버정보</h4></div></div>
						<!-- stitle // -->
						<table  cellpadding="0" cellspacing="0" class="table_left_s4">
							<caption></caption>
							<colgroup>
								<col width="12%" />
								<col width="25%" />
								<col width="12%" />
								<col width="25%" />
								<col width="11%" />
								<col width="25%" />
							</colgroup>
							<tr>
								<td class="filed_A left">장비ID</td>
								<td class="filed_B left" id="nMonId"></td>
								<td class="filed_A left">장비명</td>
								<td class="filed_B left" id="sMonName"></td>
								<td class="filed_A left">SNMP종류</td>
								<td class="filed_B left" id="sSnmpKind"></td>
							</tr>
						</table>
					</div>
					<!-- stitle -->
					<table><tr><td><br/></td></tr><tr><td><br/></td></tr></table>
					<!-- stitle // -->
				</c:if>
			
				<c:if test="${param.updateFlag != 'U'}">
					<!-- 서버 목록 시작 -->
					<table  cellpadding="0" cellspacing="0" class="table_left_s1">
						<tr>
							<td class="bgtl1"></td>
							<td class="bgtc1">
								<strong>서버목록</strong> 
								<strong style="float:right;">서버명<input type="text" name="S_MON_NAME" id="S_MON_NAME" value="" class="manaint_f" style="margin-left:5px;"/>
								<a href="#" id="search" class="css_btn_class3" style="margin:0 0 0 5px;">검색</a>
								</strong>
							</td>
							<td class="bgtr1"></td>
						</tr>
						<tr>
							<td class="bgml1"></td>
							<td class="bgmc1">
								<div id="server_list_grid" class="table_typ2-7" style="margin: 10px 0px 0px 0px;">
								</div>
							</td>
							<td class="bgmr1"></td>
						</tr>
						<tr>
							<td class="bgbl1"></td>
							<td class="bgbc1"></td>
							<td class="bgbr1"></td>
						</tr>
					</table>
					<!-- 서버 목록 끝/ -->
					<table class="table_left_s1-f">
						<tr><td></td></tr>
					</table>
				</c:if>
				
				<!-- SNMP 감시 코드 시작 -->
				<table  cellpadding="0" cellspacing="0" class="table_left_s2">
					<tr>
						<td class="bgtl1"></td>
						<td class="bgtc1"><strong>SNMP 감시 코드</strong></td>
						<td class="bgtr1"></td>
					</tr>
					<tr>
						<td class="bgml1"></td>
						<td class="bgmc1">
							<div class="table_typ2-7">
								<table summary="" cellpadding="0" cellspacing="0">
									<caption></caption>
									<colgroup>
										<col width="60%" />
										<col width="40%" />
									</colgroup>
									<tr>
										<td class="filed_A left">SNMP 종류</td>
										<td class="filed_B left">
							      			<span id="snmp_name"></span>
							      			<input type="hidden" name="N_SNMP_MAN_CODE" id="N_SNMP_MAN_CODE" value="">
										</td>
									</tr>
									</tr>
										<td class="filed_A left">SNMP 상세 코드</td>
							      		<td class="filed_B left">
							      			<div id="snmp_mon_code_selbox">
							      				<select id="N_SNMP_MON_CODE" name="N_SNMP_MON_CODE">
								            		<option value="">선택</option>
								            	</select>
							      			</div>
							      		</td>
									</tr>
									<tr>
										<td colspan="2">
											<div id="snmp_code_gird" class="table_typ2-4">
											</div>
										</td>
									</tr>
								</table>
							</div>
						</td>
						<td class="bgmr1"></td>
					</tr>
					<tr>
						<td class="bgbl1"></td>
						<td class="bgbc1"></td>
						<td class="bgbr1"></td>
					</tr>
				</table>
				<!-- SNMP 감시 코드 끝/ -->
				<table class="table_left_s1-f">
					<tr><td></td></tr>
				</table>
				
				<!-- 장애 발생 조건 시작 -->
				<table  cellpadding="0" cellspacing="0" class="table_left_s3">
					<tr>
						<td class="bgtl1"></td>
						<td class="bgtc1"><strong>장애 발생 조건</strong></td>
						<td class="bgtr1"></td>
					</tr>
					<tr>
						<td class="bgml1"></td>
						<td class="bgmc1" valign="top">
							<div class="table_typ2-7">
								<table summary="" cellpadding="0" cellspacing="0">
								<caption></caption>
								<colgroup>
									<col width="20%" />
									<col width="80%" />
								</colgroup>
								<tr>
									<td class="filed_A left">장애</br>등급</td>
									<td class="filed_B left">
										<input type="radio"  name="N_ALM_RATING" id="N_ALM_RATING" value="3" style="cursor:hand;" class="chbox" />
										<label for="">Minor</label><input type="radio" name="N_ALM_RATING" id="N_ALM_RATING" value="2" style="cursor:hand;" class="chbox" />
										<label for="">Major</label><input type="radio" name="N_ALM_RATING" id="N_ALM_RATING" value="1" style="cursor:hand;" class="chbox" /><label for="">Critical</label>
									</td>
								</tr>
								<tr>
									<td class="filed_A left">입력값&조건</td>
									<td class="filed_B left">
										<span id="div_s_where1" style="display:none;"></span>
										<span id="div_s_where2">
											<input type="text" name="S_IN_VALUE" id="S_IN_VALUE" class="넌숫자만" maxlength="3" value="" style="width:70px;"> 
									        <select name="S_WHERE" id="S_WHERE">
									        	<option value="">선택</option>
									        	<option value="1">보다 작음(&gt;)</option>
									        	<option value="0">같음(=)</option>
									        	<option value="2">보다 큼(&lt;)</option>
									        	<option value="3">같지 않음(≠)</option>
									        </select>
										</span>
									</td>
								</table>
								<!-- botton -->
								<div id="botton_align_center1"><a href="#" class="css_btn_class" id="btn_save">저장</a>&nbsp;&nbsp;&nbsp;<a href="#" id="btn_cancel" class="css_btn_class">취소</a></div>
								<!-- botton // -->
							</div>
						</td>
						<td class="bgmr1"></td>
					</tr>
					<tr>
						<td class="bgbl1"></td>
						<td class="bgbc1"></td>
						<td class="bgbr1"></td>
					</tr>
				</table>
				<!-- 장애 발생 조건 끝/ -->
			</div>
		</div>
		<!-- 사용자리스트 //-->
	</div>
	<!-- manager_contBox1 // -->
	<!-- 내용 // -->
	<input type="hidden" name="N_MON_ID" id="N_MON_ID" value=""/>
	<input type="hidden" name="N_SNMP_TYPE_CODE" id="N_SNMP_TYPE_CODE" value=""/>
</form>


<form id="go_list_form" method="get">
	<input type="hidden" name="searchParam" value="${param.searchParam}"/>
</form>

<script src="<c:url value="/common/js/rsa/jsbn.js"/>" type="text/JavaScript"></script>
<script src="<c:url value="/common/js/rsa/rsa.js"/>" type="text/JavaScript"></script>
<script src="<c:url value="/common/js/rsa/prng4.js"/>" type="text/JavaScript"></script>
<script src="<c:url value="/common/js/rsa/rng.js"/>" type="text/JavaScript"></script>

<script type="text/javascript">
	$(document).ready(function() {
		$("#register_form").kendoValidator().data("kendoValidator");

		initGrid();
		initEvent();

		// 수정 페이지
		if ('U' === '${param.updateFlag}') {
			
			$("#nMonId").html("${param.N_MON_ID}");
			$("#sMonName").html(decodeURIComponent("${param.S_MON_NAME}"));
			$("#sSnmpKind").html(decodeURIComponent("${param.S_SNMP_MAN_NAME}"));
			detailInfoDataSetting();
		}
	});

	function detailInfoDataSetting(){

		var nMonId = "${param.N_MON_ID}";
		var nSnmpManCode = "${param.N_SNMP_MAN_CODE}";
		var nSnmpMonCode = "${param.N_SNMP_MON_CODE}";
		var nSnmpTypeCode = "${param.N_SNMP_TYPE_CODE}";
		var nAlmRating = "${param.N_ALM_RATING}";

		$("#N_SNMP_MON_CODE").html("<option value=\"\">선택</option>");
		cfn_makecombo_opt($("#N_SNMP_MON_CODE"), "<c:url value="/admin/lst_common.cmb_snmp_mon_code.htm"/>?N_SNMP_MAN_CODE="+nSnmpManCode);
		$("select[name='N_SNMP_MON_CODE']").change(function(){fn_snmp_mon_code_change(nSnmpManCode, $(this).val());});
		
		var param = {
				'N_MON_ID'	: nMonId,
				'N_SNMP_MAN_CODE'	: nSnmpManCode,
				'N_SNMP_MON_CODE'	: nSnmpMonCode,
				'N_SNMP_TYPE_CODE'	: nSnmpTypeCode,
				'N_ALM_RATING'      : nAlmRating
			};

		$.getJSON("<c:url value='/admin/map_snmp_alarm.detail_info.htm'/>", param, function(data){

			$("#N_MON_ID").val(data.N_MON_ID);
			$("#nMonId").html(data.N_MON_ID);
			$("#sMonName").html(data.S_MON_NAME);
			$("#sSnmpKind").html(data.S_SNMP_MAN_NAME);
			$("#snmp_name").html(data.S_SNMP_MAN_NAME);
			$("#N_SNMP_MAN_CODE").val(data.N_SNMP_MAN_CODE);
			$("#N_SNMP_MON_CODE").val(data.N_SNMP_MON_CODE);
			$("#N_SNMP_TYPE_CODE").val(data.N_SNMP_TYPE_CODE);
			$('input:radio[name="N_ALM_RATING"]:input[value="'+data.N_ALM_RATING+'"]').prop("checked", true);
			$("#S_IN_VALUE").val(data.S_IN_VALUE);
			$("#S_WHERE").val(data.S_WHERE);
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
					url 		: cst.contextPath() + "/admin/kendoPagination_common.pagingSvrList.htm",
					data 		: function(data) {
						return {
							'f_N_STYLE_CODE'   : 2,
							'S_MON_NAME'   : $("#S_MON_NAME").val().trim()
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

			pageSize		: 15,
			serverPaging	: false,
			serverSorting	: true
		});

		grid = $("#server_list_grid")
					.kendoGrid($.extend({}, kendoGridDefaultOpt, {
						dataSource	: dataSource,
						change		: selectedGridRow,
						sortable	: {
							mode 		: 'multiple',
							allowUnsort : true
						},
						columns		: [
							{field:'N_MON_ID', title:'장비ID', width:'33%', attributes:alignCenter, headerAttributes:alignCenter},
							{field:'S_MON_NAME', title:'장비명', width:'33%', attributes:alignCenter, headerAttributes:alignCenter},
							{field:'S_SNMP_MAN_NAME', title:'SNMP종류', width:'33%', attributes:alignCenter, headerAttributes:alignCenter}
						]
					})).data('kendoGrid');
	}
	
	// 사용자, 서버 그리드 클릭시 체크박스 처리로직
	function selectedGridRow() {
		
		$("#snmp_name").text(this.dataItem(this.select()).S_SNMP_MAN_NAME);
		var nSnmpManCode = this.dataItem(this.select()).N_SNMP_MAN_CODE
		$("#N_SNMP_MON_CODE").html("<option value=\"\">선택</option>");
		cfn_makecombo_opt($("#N_SNMP_MON_CODE"), "<c:url value="/admin/lst_common.cmb_snmp_mon_code.htm"/>?N_SNMP_MAN_CODE="+nSnmpManCode);
		
		$("select[name='N_SNMP_MON_CODE']").change(function(){fn_snmp_mon_code_change(nSnmpManCode, $(this).val());});
		$("#N_MON_ID").val(this.dataItem(this.select()).N_MON_ID);
		$("#N_SNMP_MAN_CODE").val(this.dataItem(this.select()).N_SNMP_MAN_CODE);
	}

	function fn_snmp_mon_code_change(nSnmpManCode, val){

		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/kendoPagination_common.cmb_snmp_value_code.htm",
					data 		: function(data) {
						return {
							'N_SNMP_MAN_CODE' : nSnmpManCode,
							'N_SNMP_MON_CODE' : val
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

			pageSize		: 15,
			serverPaging	: false,
			serverSorting	: true
		});

		grid = $("#snmp_code_gird")
					.kendoGrid($.extend({}, kendoGridDefaultOpt, {
						dataSource	: dataSource,
						change		: selectedSnmpGridRow,
						sortable	: {
							mode 		: 'multiple',
							allowUnsort : true
						},
						columns		: [
							{field:'VAL', title:'VAL', width:'100%', attributes:alignLeft, headerAttributes:alignCenter}
						]
					})).data('kendoGrid');
	}

	// 사용자, 서버 그리드 클릭시 체크박스 처리로직
	function selectedSnmpGridRow() {
		
		var grid = $("#snmp_code_gird").data("kendoGrid"); 
		$("#N_SNMP_TYPE_CODE").val(grid.dataItem(grid.select()).CODE);
	}

	function initEvent() {
		$('#btn_cancel').on('click', function(event) {
			event.preventDefault();
			if ( confirm("작성된 데이터를 초기화 하시겠습니까?") ) {
				clearFormData();
			}
		});

		$('#search').on('click', function(event) {
			event.preventDefault();
			$("#server_list_grid").data('kendoGrid').dataSource.read();
		});
		
		$('#btn_save').on('click', save);
		$('#btn_list').on('click', goListPage);
		
		$('input[type=text]').focusout(function() {
			this.value = $.trim(this.value);
		});
	}

	function save() {
		if(!fn_validation_chk())
			return;
		
		var url = ('${param.updateFlag}' != 'U')?"<c:url value='/admin/ins_snmp_alarm.insert_data.htm'/>":"<c:url value='/admin/upd_snmp_alarm.update_data.htm'/>";
		var param = $("form[name='register_form']").serialize();

		$.post(url, param, function(str){
			var data = $.parseJSON(str);
			if(data.RSLT != null && data.RSLT > 0) {
				alert('저장되었습니다.');
				goListPage();
				return;
			}
			else {
				alert("저장 실패 하였습니다.\n" + data.ERRMSG + "");
				goListPage();
				return;
			}
		});
	}

	function fn_validation_chk()
	{
		if($("#N_MON_ID").length == 0) 
		{
			alert('선택된 서버가 없습니다.');
			return false;
		}
		

		if($("#N_SNMP_TYPE_CODE").length == 0) 
		{
			alert('SNMP 감시코드가 선택되지 않았습니다.');
			return false;
		}
		
		
		if($("input[name='N_ALM_RATING']:checked").length == 0)
		{
			alert('장애등급이 선택되지 않았습니다.');
			return false;
		}
		
		if($("#div_s_where2").is(":visible"))
		{
			if(!cfn_empty_valchk(register_form.S_IN_VALUE, "입력값") || !cfn_empty_valchk(register_form.S_WHERE, "조건") ) {
				return false;
			}
		}
		if($("#div_s_where1").is(":visible"))
		{
			if($("select[name='S_IN_VALUE'] option:selected").val() == "")
			{
				alert("입력값을 선택하여 주십시오.");
				return false;
			}
		}
		if(!$("#div_s_where1").is(":visible") && !$("#div_s_where2").is(":visible"))
		{
		}
		
		return true;
	}

	function goListPage(event) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.snmp_alarm.retrieve.htm').submit();
	}

	function clearFormData() {
		if ('U' === '${param.updateFlag}') {
			searchDetailInfo();
		} else {
			$("form")[0].reset();
		}
		$("#register_form span.k-tooltip-validation").hide(); // kendo validator 문구 초기화
	}

</script>