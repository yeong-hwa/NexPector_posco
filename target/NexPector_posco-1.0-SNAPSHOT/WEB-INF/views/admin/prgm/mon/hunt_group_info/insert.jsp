<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>HUNT 그룹 정보 등록</h2><span>Home &gt; 감시장비 관리 &gt; HUNT 그룹 정보 등록</span></div></div>

<form id="hunt_group_info_insert_form" name="hunt_group_info_insert_form" data-role="validator">
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
					<td class="filed_A left" style="height: 23px;">대상장비ID</td>
					<td class="filed_B left" colspan="3">
						<c:choose>
							<c:when test="${param.updateFlag eq 'U'}">
								<span>${param.S_SKILL_GROUP}</span>
								<input type="hidden" name="S_SKILL_GROUP" value="${param.S_SKILL_GROUP}">
							</c:when>
							<c:otherwise>
								<input type="text" name="S_SKILL_GROUP" id="S_SKILL_GROUP" class="manaint_f" style="width:150px;ime-mode:disabled;" autofocus value="${param.S_SKILL_GROUP}">
								<span><a href="#" id="btn_checkDuplication" class="css_btn_class">중복체크</a></span>
							</c:otherwise>
						</c:choose>
					</td>
				</tr>

				<tr>
					<td class="filed_A left" style="height: 23px;">회사구분</td>
					<td class="filed_B left">
						<cmb:combo qryname="common.cmb_company" seltagname="S_COMPANY" selvalue="${param.S_COMPANY}"
								   etc="id=\"S_COMPANY\" class=\"input_search\" style=\"width:100;\""/>
					</td>
					<td class="filed_A left" style="height: 23px;">센터구분</td>
					<td class="filed_B left">
						<cmb:combo qryname="common.cmb_code" seltagname="S_CENTER" selvalue="${param.S_CENTER}"
								   etc="id=\"S_CENTER\" class=\"input_search\" style=\"width:100;\"" param="S_GROUP_CODE=CENTER"/>
					</td>
				</tr>
				<tr>
					<td class="filed_A left">팀</td>
					<td class="filed_B left">
						<input type="text" name="S_TEAM" id="S_TEAM" class="manaint_f" style="width:150px;" value="${data.S_TEAM}">
					</td>
					<td class="filed_A left">CME 그룹</td>
					<td class="filed_B left">
						<input type="text" name="S_CME_GROUP" id="S_CME_GROUP" class="manaint_f" style="width:150px;" value="${data.S_CME_GROUP}">
					</td>

				</tr>
				<tr>
					<td class="filed_A left">상세 설명</td>
					<td class="filed_B left" colspan="3">
						<input type="text" name="S_DESC" id="S_DESC" class="manaint_f" style="width:150px;" value="${data.S_DESC}">
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
		$("#hunt_group_info_insert_form").kendoValidator().data("kendoValidator");
		initEvent();
		// 수정 페이지
		if ('U' == '${param.updateFlag}') {
			searchDetailInfo('${param.S_SKILL_GROUP}','${param.S_COMPANY}','${param.S_CENTER}');
			$("#S_SKILL_GROUP").attr("readonly", true);
		}
	});

	function searchDetailInfo(skillGroup,company,center) {

			var param 	= {
					'S_SKILL_GROUP' : skillGroup,
					'S_COMPANY' : company,
					'S_CENTER' : center
				};
			$.getJSON("<c:url value='/admin/map_hunt_group_info.detail_info.htm'/>", param, function(data){
				$("#S_SKILL_GROUP").val(data.S_SKILL_GROUP);
				$("#S_COMPANY").val(data.S_COMPANY);
				$("#S_CENTER").val(data.S_CENTER);
				$("#S_TEAM").val(data.S_TEAM);
				$("#S_CME_GROUP").val(data.S_CME_GROUP);
				$("#S_DESC").val(data.S_DESC);
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
		if(!cfn_empty_valchk(hunt_group_info_insert_form.S_SKILL_GROUP, "대상장비ID")
				|| !cfn_empty_valchk(hunt_group_info_insert_form.S_TEAM, "팀")
				|| !cfn_empty_valchk(hunt_group_info_insert_form.S_CME_GROUP, "CME 그룹")
				|| !cfn_empty_valchk(hunt_group_info_insert_form.S_DESC, "상세 설명")){
			return false;
		}

		return true;
	}
	
	function save() {
		
		if(!fn_validation_chk())
			return;
		
		if( ($("#S_SKILL_GROUP").attr("readonly") == null || $("#S_SKILL_GROUP").attr("readonly") == null) 
				&& 'U' != '${param.updateFlag}'){
			alert("대상장비ID 중복 체크 해주시기 바랍니다.");
			$("#btn_checkDuplication").focus();
		}else{
			saveData();
		}
			
/* 		var xhr = checkDuplication();
		xhr.done(function(data) {
			if (data.CNT > 0 && 'U' != '${param.updateFlag}') {
				alert('중복된 대상장비ID 입니다.');
			} else {
				saveData();
			}
		}); */

	}
	
	function checkDuplication() {
		
		if($.trim($("#S_SKILL_GROUP").val()) == ""){
			alert("대상장비ID를 입력해 주세요.");
			$("#S_SKILL_GROUP").focus();
			return;
		}
		
		var xhr = $.getJSON("<c:url value='map_hunt_group_info.dul_chk.htm'/>", $("#hunt_group_info_insert_form").serialize());
		xhr.done(function(data) {
			if (data.CNT > 0 && 'U' != '${param.updateFlag}') {
				alert('중복된 대상장비ID 입니다.');
				$("#S_SKILL_GROUP").focus();
			} else {
				$("#S_SKILL_GROUP").attr("readonly",true);
				$("#btn_checkDuplication").html("사용가능");
				
			}
		});

		//return $.getJSON("<c:url value='map_hunt_group_info.dul_chk.htm'/>", $("#hunt_group_info_insert_form").serialize());
	}
	
	function saveData(){

		var url = "";
		if("${param.updateFlag}"=="U"){
			url = "<c:url value='/admin/upd_hunt_group_info.update_data.htm'/>"; 
		}else{
			url = "<c:url value='/admin/ins_hunt_group_info.insert_data.htm'/>";
		}
			
		var param = $("form[name='hunt_group_info_insert_form']").serialize();
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
		var url = "<c:url value='/admin/del_hunt_group_info.delete_data.htm'/>";
		var param = $("form[name='hunt_group_info_insert_form']").serialize();
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
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.hunt_group_info.retrieve.htm').submit();		
	}
	
	function clearFormData() {
		if ('U' === '${param.updateFlag}') {
			searchDetailInfo('${param.S_SKILL_GROUP}','${param.S_COMPANY}','${param.S_CENTER}');
		} else {
			$("form")[0].reset();
		}
		$("#hunt_group_info_insert_form span.k-tooltip-validation").hide(); // kendo validator 문구 초기화
	}
	
</script>