<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>시나리오 정보 등록</h2><span>Home &gt; 감시장비 관리 &gt; 시나리오 정보 등록</span></div></div>

<form id="scenario_info_insert_form" name="scenario_info_insert_form" data-role="validator">
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
					<td class="filed_A left" style="height: 23px;">회사구분</td>
					<td class="filed_B left">
						<cmb:combo qryname="common.cmb_company" seltagname="S_COMPANY" selvalue="${param.S_COMPANY}"
								   etc="id=\"S_COMPANY\" class=\"input_search\" style=\"width:100;\""/>
					</td>
					<td class="filed_A left" style="height: 23px;">서버그룹</td>
					<td class="filed_B left">
						<cmb:combo qryname="cmb_svr_group" seltagname="N_GROUP_CODE" selvalue="${param.N_GROUP_CODE}"
						           etc="class=\"input_search\" id=\"N_GROUP_CODE\""/>
					</td>
				</tr>
				<tr>
					<td class="filed_A left">시나리오ID</td>
					<td class="filed_B left">
						<input type="text" name="S_APP_ID" id="S_APP_ID" class="manaint_f" style="width:150px;" value="${data.S_APP_ID}">
						<span><a href="#" id="btn_checkDuplication" class="css_btn_class">중복체크</a></span>
					</td>
					<td class="filed_A left">시나리오 명</td>
					<td class="filed_B left">
						<input type="text" name="S_APP_NAME" id="S_APP_NAME" class="manaint_f" style="width:150px;" value="${data.S_APP_NAME}">
					</td>
				</tr>
				<tr>
					<td class="filed_A left">시나리오 설명</td>
					<td class="filed_B left" colspan="3">
						<input type="text" name="S_APP_DESC" id="S_APP_DESC" class="manaint_f" style="width:150px;" value="${data.S_APP_DESC}">
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
		$("#scenario_info_insert_form").kendoValidator().data("kendoValidator");
		initEvent();
		// 수정 페이지
		if ('U' == '${param.updateFlag}') {
			searchDetailInfo('${param.S_COMPANY}','${param.N_GROUP_CODE}','${param.S_APP_ID}');
			$("#S_SKILL_GROUP").attr("readonly", true);
		}
	});

	function searchDetailInfo(company,groupCode,appId) {

			var param 	= {
					'S_COMPANY' : company,
					'N_GROUP_CODE' : groupCode,
					'S_APP_ID' : appId
				};
			$.getJSON("<c:url value='/admin/map_scenario_info.detail_info.htm'/>", param, function(data){
				$("#S_COMPANY").val(data.S_COMPANY);
				$("#N_GROUP_CODE").val(data.N_GROUP_CODE);
				$("#S_APP_ID").val(data.S_APP_ID);
				$("#S_APP_NAME").val(data.S_APP_NAME);
				$("#S_APP_DESC").val(data.S_APP_DESC);
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
		$('#btn_checkDuplication').on('click', checkDuplication);
		
		$('input[type=text]').focusout(function() {
			this.value = $.trim(this.value);
		});
	}

	function fn_validation_chk()
	{
		if(!cfn_empty_valchk(scenario_info_insert_form.S_APP_ID, "시나리오ID")
				|| !cfn_empty_valchk(scenario_info_insert_form.S_APP_NAME, "시나리오 명")
				|| !cfn_empty_valchk(scenario_info_insert_form.S_APP_DESC, "시나리오 설명")){
			return false;
		}

		return true;
	}
	
	function save() {
		
		if(!fn_validation_chk())
			return;
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
		if( ($("#S_APP_ID").attr("readonly") == null || $("#S_APP_ID").attr("readonly") == null) 
				&& 'U' != '${param.updateFlag}'){
			alert("시나리오ID 중복 체크 해주시기 바랍니다.");
			$("#btn_checkDuplication").focus();
		}else{
			saveData();
		}
		
	}
	
	function checkDuplication() {
		
		if($.trim($("#S_APP_ID").val()) == ""){
			alert("시나리오ID를 입력해 주세요.");
			$("#S_APP_ID").focus();
			return;
		}
		
		var xhr = $.getJSON("<c:url value='map_scenario_info.dul_chk.htm'/>", $("#scenario_info_insert_form").serialize());
		xhr.done(function(data) {
			if (data.CNT > 0 && 'U' != '${param.updateFlag}') {
				alert('중복된 시나리오ID 입니다.');
				$("#S_APP_ID").focus();
			} else {
				$("#S_APP_ID").attr("readonly",true);
				$("#btn_checkDuplication").html("사용가능");
				
			}
		});

		//return $.getJSON("<c:url value='map_scenario_info.dul_chk.htm'/>", $("#scenario_info_insert_form").serialize());
	}
	
	function saveData(){

		var url = "";
		if("${param.updateFlag}"=="U"){
			url = "<c:url value='/admin/upd_scenario_info.update_data.htm'/>"; 
		}else{
			url = "<c:url value='/admin/ins_scenario_info.insert_data.htm'/>";
		}
			
		var param = $("form[name='scenario_info_insert_form']").serialize();
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
	
	function deleteInfo() {
		if(!confirm("정말 삭제 하시겠습니까?"))
			return;
		var url = "<c:url value='/admin/del_scenario_info.delete_data.htm'/>";
		var param = $("form[name='scenario_info_insert_form']").serialize();
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
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.scenario_info.retrieve.htm').submit();		
	}
	
	function clearFormData() {
		if ('U' === '${param.updateFlag}') {
			searchDetailInfo('${param.S_COMPANY}','${param.N_GROUP_CODE}','${param.S_APP_ID}');
		} else {
			$("form")[0].reset();
		}
		$("#scenario_info_insert_form span.k-tooltip-validation").hide(); // kendo validator 문구 초기화
	}
	
</script>