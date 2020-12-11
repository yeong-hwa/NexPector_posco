<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>
<% response.setContentType("text/html"); %>
<!-- location -->
<div class="locationBox"><div class="st_under"><h2>DB 정보 등록</h2><span>Home &gt; 감시장비 관리 &gt; DB 정보 등록</span></div></div>

<form id="db_info_insert_form" name="db_info_insert_form" data-role="validator">
	<div class="manager_contBox1">
		<!--//HUNT 그룹 정보등록 -->
		<div class="table_typ2-5">
			<table summary="" cellpadding="0" cellspacing="0">
				<caption></caption>
				<colgroup>
					<col width="15%" />
					<col width="35%" />
					<col width="15%" />
					<col width="35%" />
				</colgroup>

				<tr>
					<td class="filed_A left" style="height: 23px;">DB 명</td>
					<td class="filed_B left">
						<input type="text" name="S_NAME" id="S_NAME" class="manaint_f" style="width:150px;">
					</td>
					<c:if test="${param.updateFlag == 'U'}">
						<td class="filed_A left" style="height: 23px;">DB ID</td>
						<td class="filed_B left">
							<input type="text" name="N_DB_ID" id="N_DB_ID" class="manaint_f" style="width:150px;" readonly>
						</td>
					</c:if>
				</tr>
				<tr>
					<td class="filed_A left">SID</td>
					<td class="filed_B left">
						<input type="text" name="S_DBNAME" id="S_DBNAME" class="manaint_f" style="width:150px;">
					</td>
					<td class="filed_A left">TYPE</td>
					<td class="filed_B left">
						<select name="N_TYPE" id="N_TYPE">
	                		<option value="0">Oracle</option>
	                		<option value="1">MS SQL</option>
	                		<option value="2">Sybase</option>
	                		<option value="3">Tibero</option>
	                	</select>
					</td>
				</tr>
				<tr>
					<td class="filed_A left">User</td>
					<td class="filed_B left">
						<input type="text" name="S_USER" id="S_USER" class="manaint_f" style="width:150px;">
					</td>
					<td class="filed_A left">Password</td>
					<td class="filed_B left">
						<input type="password" name="S_PWD" id="S_PWD" class="manaint_f" style="width:150px;">
					</td>
				</tr>
				<tr>
					<td class="filed_A left">장비 ID</td>
					<td class="filed_B left">
						<input type="text" name="N_MON_ID" id="N_MON_ID" class="manaint_f" style="width:150px;">
					</td>
					<td class="filed_A left">IP</td>
					<td class="filed_B left">
						<input type="text" name="S_IPADDRESS" id="S_IPADDRESS" class="manaint_f" style="width:150px;">
					</td>
				</tr>
				<tr>
					<td class="filed_A left">Port</td>
					<td class="filed_B left">
						<input type="text" name="N_PORT" id="N_PORT" class="manaint_f" style="width:150px;">
					</td>
					<td class="filed_A left">TableSpace(임계치)</td>
					<td class="filed_B left">
						<input type="text" name="N_USE_LIMIT" id="N_USE_LIMIT" class="manaint_f" style="width:150px;">
					</td>
				</tr>
				<tr>
					<td class="filed_A left">동시접속세션(임계치)</td>
					<td class="filed_B left">
						<input type="text" name="N_CON_LIMIT" id="N_CON_LIMIT" class="manaint_f" style="width:150px;">
					</td>
					<td class="filed_A left">감시주기(ms)</td>
					<td class="filed_B left">
						<input type="text" name="N_INTERVAL" id="N_INTERVAL" class="manaint_f" style="width:150px;">
					</td>
				</tr>
			</table>
			<!-- botton -->
			<div id="botton_align_center1">
				<a href="#" id="btn_save" class="css_btn_class">저장</a>&nbsp;&nbsp;&nbsp;
				<a href="#" id="btn_cancel" class="css_btn_class">취소</a>
				<c:if test="${param.updateFlag == 'U'}">
					&nbsp;&nbsp;&nbsp;<a href="#" id="btn_remove" class="css_btn_class3">삭제</a>
				</c:if>
			</div>
			<!-- botton // -->
		</div>
		<!--사용자등록//-->

	</div>
	<input type="hidden" name="updateFlag" value="${param.updateFlag}">
</form>

<form id="go_list_form" method="get">
	<input type="hidden" name="searchParam" value="${param.searchParam}"/>
</form>

<script type="text/javascript">
	$(document).ready(function() {
		$("#db_info_insert_form").kendoValidator().data("kendoValidator");
		initEvent();

		// 수정 페이지
		if ('U' == '${param.updateFlag}') {
			// $('#N_TYPE').val('${param.N_TYPE}');
			searchDetailInfo('${param.N_DB_ID}');
			$("#N_DB_ID").attr("readonly", true);
		}
	});

	function searchDetailInfo(N_DB_ID) {
			var param 	= {
					'N_DB_ID' : N_DB_ID
			};
			$.getJSON("<c:url value='/admin/map_db_info.detail_info.htm'/>", param, function(data){
				$("#N_DB_ID").val(data.N_DB_ID);
				$("#S_NAME").val(data.S_NAME);
				$("#S_DBNAME").val(data.S_DBNAME);
				$("#N_TYPE").val(data.N_TYPE);
				$("#S_USER").val(data.S_USER);
				$("#N_MON_ID").val(data.N_MON_ID);
				$("#S_IPADDRESS").val(data.S_IPADDRESS);
				$("#N_PORT").val(data.N_PORT);
				$("#N_USE_LIMIT").val(data.N_USE_LIMIT);
				$("#N_CON_LIMIT").val(data.N_CON_LIMIT);
				$("#N_INTERVAL").val(data.N_INTERVAL);
			});
	}
	
	function initEvent() {
		$('#btn_cancel').on('click', function(event) {
			event.preventDefault();
			if ( confirm("목록으로 이동하시겠습니까?") ) {
				goListPage();
			}
		});

		$('#btn_save').on('click', save);
		$('#btn_remove').on('click', deleteInfo);
		
		$('input[type=text]').focusout(function() {
			this.value = $.trim(this.value);
		});
	}

	function fn_validation_chk()
	{
		if(!cfn_empty_valchk(db_info_insert_form.S_APP_ID, "시나리오ID")
				|| !cfn_empty_valchk(db_info_insert_form.S_APP_NAME, "시나리오 명")
				|| !cfn_empty_valchk(db_info_insert_form.S_APP_DESC, "시나리오 설명")){
			return false;
		}

		return true;
	}
	
	function save() {
		
		// if(!fn_validation_chk()) return;
/* 		
		var xhr = checkDuplication();
		xhr.done(function(data) {
			if (data.CNT > 0 && 'U' != '${param.updateFlag}') {
				alert('중복된 ID 입니다.');
			} else {
				saveData();
			}
		});
 */
 
 /*
		if( ($("#S_APP_ID").attr("readonly") == null || $("#S_APP_ID").attr("readonly") == null) 
				&& 'U' != '${param.updateFlag}'){
			alert("시나리오ID 중복 체크 해주시기 바랍니다.");
			$("#btn_checkDuplication").focus();
		}else{
		}
 */
		saveData();
		
	}
	
	function checkDuplication() {
		
		if($.trim($("#S_APP_ID").val()) == ""){
			alert("시나리오ID를 입력해 주세요.");
			$("#S_APP_ID").focus();
			return;
		}
		
		var xhr = $.getJSON("<c:url value='map_scenario_info.dul_chk.htm'/>", $("#db_info_insert_form").serialize());
		xhr.done(function(data) {
			if (data.CNT > 0 && 'U' != '${param.updateFlag}') {
				alert('중복된 시나리오ID 입니다.');
				$("#S_APP_ID").focus();
			} else {
				$("#S_APP_ID").attr("readonly",true);
				$("#btn_checkDuplication").html("사용가능");
				
			}
		});

		//return $.getJSON("<c:url value='map_scenario_info.dul_chk.htm'/>", $("#db_info_insert_form").serialize());
	}
	
	function saveData(){

		var url = "";
		if("${param.updateFlag}"=="U"){
			url = "<c:url value='/admin/db_info/update.htm'/>"; 
		}else{
			url = "<c:url value='/admin/db_info/insert.htm'/>";
		}
			
		var param = $("form[name='db_info_insert_form']").serialize();
		$.post(url, param, function(data){
			var result = Number(data.RSLT);
			
			if(result != null && result > 0) {
				alert('저장되었습니다.');
				goListPage();
				return;
			}
			else {
				alert("저장 실패 하였습니다.");
				goListPage();
				return;
			}
		});
	}
	
	function deleteInfo() {
		if(!confirm("정말 삭제 하시겠습니까?"))
			return;
		var url = "<c:url value='/admin/db_info/delete.htm'/>";
		var param = $("form[name='db_info_insert_form']").serialize();
		$.post(url, param, function(data){
			var result = Number(data.RSLT);
			
			if(result != null && result > 0) {
				alert('삭제되었습니다.');
				goListPage();
				return;
			}
			else {
				alert("삭제 실패 하였습니다.");
				goListPage();
				return;
			}
		});
	}
	
	function goListPage(event) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.db_info.retrieve.htm').submit();		
	}
	
	function clearFormData() {
		if ('U' === '${param.updateFlag}') {
			searchDetailInfo('${param.N_DB_ID}');
		} else {
			$("form")[0].reset();
		}
		$("#db_info_insert_form span.k-tooltip-validation").hide(); // kendo validator 문구 초기화
	}
	
</script>