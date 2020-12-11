<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>사용자 그룹 정보 등록</h2><span>Home &gt; 사용자 관리 &gt; 사용자 그룹 정보 등록</span></div></div>
<!-- location // -->

<form id="user_group_insert_form" data-role="validator">
<div style="float: left;margin-bottom: 5px;">
	<a href="#" id="btn_list" class="css_btn_class">목록</a>
</div>
<!-- manager_contBox1 -->
<div class="manager_contBox1">
	<!-- 사용자등록 -->
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
				<td class="filed_A left">사용자그룹코드</td>
				<td class="filed_B left"><input type="text" name="N_GROUP_CODE" id="txt_group_code" value="" class="manaint_f" required validationMessage="필수 입력값 입니다."/></td>
				<td class="filed_A left">사용자그룹명</td>
				<td class="filed_B left"><input type="text" name="S_GROUP_NAME" id="txt_group_name" value="" class="manaint_f" required validationMessage="필수 입력값 입니다."/></td>
			</tr>
			<tr>
				<td class="filed_A left">상위그룹</td>
				<td class="filed_B left"><select name="N_UP_CODE" id="sel_up_code"><option value="">선택</option></select></td>
				<td class="filed_A left">사용여부</td>
				<td class="filed_B left"><select name="F_USE" id="sel_use"><option value="Y">사용</option><option value="N">사용안함</option></select></td>
			</tr>
		</table>
		<!-- botton -->
		<div id="botton_align_center1">
			<a href="#" id="btn_save" class="css_btn_class">저장</a>&nbsp;&nbsp;&nbsp;
			<a href="#" id="btn_cancel" class="css_btn_class">취소</a>&nbsp;&nbsp;&nbsp;
			<c:if test="${param.updateFlag eq 'U'}">
			<a href="#" id="btn_remove" class="css_btn_class3">삭제</a>
			</c:if>
		</div>
		<!-- botton // -->
	</div>
</div>
<!-- manager_contBox1 // -->
</form>

<form id="go_list_form" method="get">
	<input type="hidden" name="searchParam" value="${param.searchParam}"/>
</form>

<script type="text/javascript">
	$(document).ready(function() {
		$("#user_group_insert_form").kendoValidator().data("kendoValidator");

		cfn_makecombo_opt($('#sel_up_code'), cst.contextPath() + '/admin/lst_common.cmb_user_group.htm');

		initEvent();

		// 수정 페이지
		if ('U' === '${param.updateFlag}') {
			// 수정시에는 ID 입력 불가로 변경
			var $userIdWrap = $('#txt_group_code').parent();
			$userIdWrap
				.empty()
				.append('<span id="txt_group_code">${param.N_GROUP_CODE}</span>')
				.append('<input type="hidden" name="N_GROUP_CODE" value="${param.N_GROUP_CODE}"/>');

			searchDetailInfo('${param.N_GROUP_CODE}');
		}
	});

	function searchDetailInfo(groupCode) {
		if ($('body').data('detail')) {
			detailInfoDataSetting($('body').data('detail'));
		}
		else {
			var url 	= cst.contextPath() + '/admin/map_user_group.detail_info.htm',
				param 	= {'N_GROUP_CODE' : groupCode};
			$.getJSON(url, $.param(param)).done(detailInfoDataSetting);
		}
	}

	function detailInfoDataSetting(data) {
		$('body').data('detail', data); // form 초기화 시에 다시 불러오기 위해 임시 저장

		$('#txt_group_code').val(data.N_GROUP_CODE);
		$('#txt_group_name').val(data.S_GROUP_NAME);
		$('#sel_up_code').val(data.N_UP_CODE);
		$('#sel_use').val(data.F_USE);
	}

	function initEvent() {
		$('#btn_cancel').on('click', function(event) {
			event.preventDefault();
			if ( confirm("작성된 데이터를 초기화 하시겠습니까?") ) {
				clearFormData();
			}
		});

		$('#btn_save').on('click', save);

		$('#btn_remove').on('click', deleteUserInfo);

		$('#btn_list').on('click', function(event) {
			event.preventDefault();
			goListPage();
		});

		$('input[type=text]').focusout(function() {
			this.value = $.trim(this.value);
		});
	}

	// 저장
	function save(event) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}

		var validator = $("#user_group_insert_form").data("kendoValidator");
		if ( validator.validate() ) {
			var url;
			if ('U' === '${param.updateFlag}') {
				url = cst.contextPath() + '/admin/upd_user_group.update_data.htm';
				saveData(url);
			} else {
				url = cst.contextPath() + '/admin/ins_user_group.insert_data.htm';
				var xhr = checkDuplication();
				xhr.done(function(data) {
					if (data.CNT > 0) {
						alert('중복된 사용자 그룹코드 입니다.');
					} else {
						saveData(url);
					}
				})
			}
		}
		else {
			alert("잘못된 형식의 데이터가 존재합니다.");
		}
	}

	function saveData(url) {
		$.post(url, $('#user_group_insert_form').serialize())
			.done(function(str) {
				var data = $.parseJSON(str);
				if(data.RSLT != null && data.RSLT > 0) {
					alert('저장되었습니다.');
					goListPage();
					return;
				}
				else {
					alert("저장 실패 하였습니다.\n관리자에게 문의해주세요.");
					return;
				}
			});
	}

	// 삭제
	function deleteUserInfo(event) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}

		if( confirm("정말 삭제 하시겠습니까?") ) {
			var url = cst.contextPath() + '/admin/del_user_group.delete_data.htm';

			var param = $("#user_group_insert_form").serialize();
			$.post(url, param, function(str) {
				var data = $.parseJSON(str);
				if (Number(data.RSLT) > 0) {
					alert('삭제되었습니다.');
					goListPage();
					return;
				}
				else {
					alert("삭제 실패 하였습니다.\n관리자에게 문의해주세요.");
					return;
				}
			});
		}
	}

	function goListPage() {
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.user.user_group.retrieve.htm').submit();
	}

	function clearFormData() {
		if ('U' === '${param.updateFlag}') {
			searchDetailInfo();
		} else {
			$("form")[0].reset();
		}
		$("#user_group_insert_form span.k-tooltip-validation").hide(); // kendo validator 문구 초기화
	}

	function checkDuplication() {
		return $.getJSON(cst.contextPath() + 'map_user_group.dul_chk.htm', $("#user_group_insert_form").serialize());
	}
</script>