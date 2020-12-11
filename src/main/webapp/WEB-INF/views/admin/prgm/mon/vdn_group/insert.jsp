<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>
<% response.setContentType("text/html"); %>
<!-- location -->
<div class="locationBox"><div class="st_under"><h2>VDN 그룹 관리</h2><span>Home &gt; 감시장비 관리 &gt; VDN 그룹 관리</span></div></div>

<form id="form" name="form" data-role="validator">
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
					<c:if test="${param.updateFlag != 'U'}">
						<td class="filed_A left" style="height: 23px;">VDN 그룹 ID</td>
						<td class="filed_B left">
							<input type="text" name="VDN_ID" id="VDN_ID" class="manaint_f" style="width:150px;" onKeyDown="onlyNumber(event);" placeholder="숫자값만 입력됩니다.">
						</td>
					</c:if>
					<c:if test="${param.updateFlag == 'U'}">
						<td class="filed_A left" style="height: 23px;">VDN 그룹 ID</td>
						<td class="filed_B left">
							<span id="txt_VDN_ID"></span>
							<input type="hidden" name="VDN_ID" id="VDN_ID" class="manaint_f" style="width:150px;" readonly>
						</td>
					</c:if>
					<td class="filed_A left">VDN 그룹 명</td>
					<td class="filed_B left">
						<input type="text" name="VDN_NAME" id="VDN_NAME" class="manaint_f" style="width:150px;">
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
		$("#form").kendoValidator().data("kendoValidator");
		initEvent();

		// 수정 페이지
		if ('U' == '${param.updateFlag}') {
			searchDetailInfo('${param.VDN_ID}');
		}
	});

	function searchDetailInfo(VDN_ID) {
		var param 	= {
				'VDN_ID' : VDN_ID
		};
		$.getJSON("<c:url value='/admin/map_vdn_group.detail_info.htm'/>", param, function(data){
			$("#txt_VDN_ID").text(data.VDN_ID);
			$("#VDN_ID").val(data.VDN_ID);
			$("#VDN_NAME").val(data.VDN_NAME);
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
		if($.trim($("#VDN_ID").val()) == ""){
			alert("VDN 그룹 ID를 입력해 주세요.");
			$("#VDN_ID").focus();
			return;
		}
		return true;
	}
	
	function save() {
		if (fn_validation_chk) {
			var xhr = checkDuplication();
			xhr.done(function(data) {
				if (data.CNT > 0 && 'U' != '${param.updateFlag}') {
					alert('중복된 ID 입니다.');
				} else {
					saveData();
				}
			});
		}
	}
	
	function checkDuplication() {
		return $.getJSON("<c:url value='map_vdn_group.dul_chk.htm'/>", $("#form").serialize());
	}
	
	function saveData(){
		var url = "";
		if("${param.updateFlag}"=="U"){
			url = "<c:url value='/admin/vdn_group/update.htm'/>"; 
		}else{
			url = "<c:url value='/admin/vdn_group/insert.htm'/>";
		}
			
		var param = $("form[name='form']").serialize();
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
		var url = "<c:url value='/admin/vdn_group/delete.htm'/>";
		var param = $("form[name='form']").serialize();
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
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.vdn_group.retrieve.htm').submit();		
	}
	
	function clearFormData() {
		if ('U' === '${param.updateFlag}') {
			searchDetailInfo('${param.VDN_ID}');
		} else {
			$("form")[0].reset();
		}
		$("#form span.k-tooltip-validation").hide(); // kendo validator 문구 초기화
	}
	
</script>