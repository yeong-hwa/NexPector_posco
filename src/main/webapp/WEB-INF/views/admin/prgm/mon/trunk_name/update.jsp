<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>Trunk 이름 정보 등록</h2><span>Home &gt; 감시장비 관리 &gt; Trunk 이름 정보 등록</span></div></div>

<form id="trunk_name_update_form" name="trunk_name_update_form" data-role="validator" method="post">
	<input type="hidden" id="trunk_name_delete_list" name="TRUNK_NAME_DELETE_LIST" value=""/>
	<div class="manager_contBox1">
		<!-- Trunk 이름 정보 등록 시작-->
		<div class="table_typ2-5">
			<table summary="" cellpadding="0" cellspacing="0">
				<caption></caption>
				<colgroup>
					<col width="33%" />
					<col width="33%" />
					<col width="33%" />
					<col width="33%" />
				</colgroup>
				<tr>
					<td class="filed_A left">장비 ID</td>
					<td class="filed_B left" colspan="3">
						<span id="N_MON_ID">${param.N_MON_ID}</span>
						<input type="hidden" name="N_MON_ID" value="${param.N_MON_ID}"/>
					</td>
				</tr>
				<tr>
					<td class="filed_A left">TRUNK NUMBER</td>
					<td id="trunk_no_list" class="filed_B left">
						<div class="div_trunk_no">
							<span id="N_TRUNK_NUMBER" style="width:80px;">${param.N_TRUNK_NUMBER}</span>&nbsp;
							<input type="hidden" name="N_TRUNK_NUMBER" value="${param.N_TRUNK_NUMBER}"/>
						</div>
					</td>
					<td class="filed_A left">TRUNK NAME</td>
					<td class="filed_B left">
						<div class="div_trunk_name">
							<input type="text" name="S_TRUNK_NAME" value="${param.S_TRUNK_NAME}" class="manaint_f" style="width:200px;"/>&nbsp;
							<input type="hidden" name="S_TRUNK_NAME" value="${param.S_TRUNK_NAME}"/>
						</div>
					</td>
				</tr>
			</table>
			<!-- botton -->
			<div id="botton_align_center1">
				<a href="#" id="btn_save" class="css_btn_class">저장</a>&nbsp;&nbsp;&nbsp;
				<a href="#" id="btn_cancel" class="css_btn_class">취소</a>
					&nbsp;&nbsp;&nbsp;<a href="#" id="btn_remove" class="css_btn_class3">삭제</a>
			</div>
			<!-- botton // -->
		</div>
		<!-- Trunk 이름 정보 등록 종료-->

	</div>
	<input type="hidden" name="updateFlag" value="${param.updateFlag}">
</form>

<form id="go_list_form" method="get">
	<input type="hidden" name="searchParam" value="${param.searchParam}"/>
</form>

<div id="dialog_popup"></div>

<script type="text/javascript">

	$(document).ready(function () {
		initEvent();
		
		// 수정 페이지 data setting
		detailInfoDataSetting('${param}');
	});

	function initEvent() {
		$('#btn_cancel').on('click', function (event) {
			event.preventDefault();
			if (confirm("목록으로 이동하시겠습니까?")) {
				goListPage();
//				clearFormData();
			}
		});

		$('#btn_save').on('click', save);
		$('#btn_remove').on('click', deleteInfo);
//		$('#btn_list').on('click', goListPage);

		$('input[type=text]').focusout(function () {
			this.value = $.trim(this.value);
		});

	}

	function removeTrunkField(event, element) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}
		$(element).parents('.div_trunk_no').remove();
	}
	
	function fn_validation_chk() {
		return true;
	}

	function save() {
		var updateFlag = '${param.updateFlag}';
		
/* 		if (!fn_validation_chk()) {
			return;
		} */
		
/* 		var jqxhr = getJqXhrCheckDuplication($('#MON_ID').val());
		jqxhr.done(function (data) {
			if (data.CNT > 0 && 'U' != updateFlag) {
				alert('중복된 ID 입니다.');
			} else {
			}
		}); */
		saveData();
	}

	function saveData() {
		var url = "<c:url value='/admin/trunk_name/update.htm'/>";
		var param = $("form[name='trunk_name_update_form']").serialize();

		var jqXhr = $.post(url, param);
		
		jqXhr.done(function (str) {
			var data = $.parseJSON(str);
			if (Number(data.RSLT) > 0) {
				alert('저장되었습니다.');
				goListPage();
				return;
			}
			else {
				alert("저장 실패 하였습니다.");
				return;
			}
		});
	}

	function deleteInfo() {

		if (!confirm("정말 삭제 하시겠습니까?")) {
			return;
		}
		var deleteTrunk = '';
		deleteTrunk += '${param.S_TRUNK_NAME}';
		deleteTrunk += '::' + '${param.N_TRUNK_NUMBER}';
		deleteTrunk += '::' + '${param.N_MON_ID}';
		
		$("#trunk_name_delete_list").val(deleteTrunk);
		
		var url 	= "<c:url value='/admin/trunk_name/delete.htm'/>",
			param 	= $("form[name='trunk_name_update_form']").serialize();

		var jqXhr = $.post(url, param);
		jqXhr.done(function (str) {
			var data = $.parseJSON(str);
			
			if (Number(data.RSLT) > 0) {
				alert('삭제되었습니다.');
				goListPage();
				return;
			} else {
				alert("삭제 실패 하였습니다.");
				return;
			}
		});
	}

	function goListPage(event) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.trunk_name.retrieve.htm').submit();
	}

	
	function detailInfoDataSetting(param){
		/* var param = {
				'MON_ID'	: mon_id
		}; */
/* 		$("#N_MON_ID").html(param.N_MON_ID);
		$("#N_TRUNK_NUMBER").val(param.N_TRUNK_NUMBER);
		$("#S_TRUNK_NAME").val(param.S_TRUNK_NAME); */
/* 		$.getJSON("<c:url value='/admin/map_cli_info.server_detail_info.htm'/>", param, function(data){
		
			$("#MON_ID").val(data.MON_ID);
			$("#SVR_IP").val(data.SVR_IP);
			$("#SVR_PORT").val(data.SVR_PORT);
			$("#TERMINAL").val(data.TERMINAL);
		}); */
	}
	
</script>