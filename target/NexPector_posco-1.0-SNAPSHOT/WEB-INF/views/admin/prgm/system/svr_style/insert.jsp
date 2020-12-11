<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>서버 스타일 등록</h2><span>Home &gt; 시스템정보 관리 &gt; 서버 스타일 등록</span></div></div>

<form id="svr_style_insert_form" data-role="validator">
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
					<td class="filed_A left">장비종류코드</td>
					<td class="filed_B left">
						<input type="text" name="N_STYLE_CODE" id="N_STYLE_CODE" value="" class="manaint_f" maxlength="10" required validationMessage="필수 입력값 입니다."/>
					</td>
					
					<td class="filed_A left">장비종류명</td>
					<td class="filed_B left">
						<input type="text" name="S_DESC" id="S_DESC" value="" class="manaint_f" maxlength="30" required validationMessage="필수 입력값 입니다."/>
					</td>
				</tr>
			</table>
			<!-- botton -->
			<div id="botton_align_center1">
				<a href="#" id="btn_save" class="css_btn_class">저장</a>&nbsp;&nbsp;&nbsp;
				<a href="#" id="btn_cancel" class="css_btn_class">취소</a>&nbsp;&nbsp;&nbsp;
				<c:if test="${param.updateFlag == 'U'}">
					<a href="#" id="btn_remove" class="css_btn_class3">삭제</a>
				</c:if>
			</div>
			<!-- botton // -->
		</div>
	</div>
	<!-- manager_contBox1 // -->
	<input type="hidden" name="N_STYLE_CODE" id="N_STYLE_CODE" value="${param.N_STYLE_CODE}"/>
	<input type="hidden" name="updateFlag" value="${param.updateFlag}"/>
</form>

<form id="go_list_form" method="get">
	<input type="hidden" name="searchParam" value="${param.searchParam}"/>
</form>

<script type="text/javascript">

	$(document).ready(function() {
		$("#svr_style_insert_form").kendoValidator().data("kendoValidator");
	
		initEvent();
	
		// 수정 페이지
		if ('U' === '${param.updateFlag}') {
			// 수정시에는 ID 입력 불가로 변경
			var $userIdWrap = $('#N_STYLE_CODE').parent();
			$userIdWrap
				.empty()
				.append('<span id="N_STYLE_CODE">${param.N_STYLE_CODE}</span>')
				.append('<input type="hidden" name="N_STYLE_CODE" value="${param.N_STYLE_CODE}"/>');
	
			detailInfoDataSetting('${param.N_STYLE_CODE}');
		}
	});
	
	function detailInfoDataSetting(typeCode) {
		var url 	= cst.contextPath() + '/admin/map_svr_style.detail_info.htm',
			param 	= {'N_STYLE_CODE' : typeCode};
		$.getJSON(url, $.param(param))
			.done(function(data) {
				$('#N_STYLE_CODE').val(data.N_STYLE_CODE);
				$('#S_DESC').val(data.S_DESC);
			});
	}

	function initEvent() {
		$('#btn_cancel').on('click', function(event) {
			event.preventDefault();
			if ( confirm("작성된 데이터를 초기화 하시겠습니까?") ) {
				clearFormData();
			}
		});

		$('#btn_save').on('click', save);

		$('#btn_remove').on('click', del);
		
		$('#btn_list').on('click', function() {
			$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.system.svr_style.retrieve.htm').submit();
		});

		$('input[type=text]').focusout(function() {
			this.value = $.trim(this.value);
		});
	}

	// 저장
	function save() {
		var validator = $("#svr_style_insert_form").data("kendoValidator");
		if ( validator.validate() ) {

			$.post(cst.contextPath() + '/admin/svr_style_insert.htm', $('#svr_style_insert_form').serialize())
				.done(function(str) {
					var data = $.parseJSON(str);
					if(data.RSLT != null && data.RSLT > 0) {
						alert('저장되었습니다.');
						goListPage();
						return;
					}
					else {
						alert("저장 실패 하였습니다.\n" + data.ERRMSG + "");
						return;
					}
				})
		}
		else {
			alert("잘못된 형식의 데이터가 존재합니다.");
		}
	}

	// 삭제
	function del() {
		
		if ( confirm("작성된 데이터를 삭제 하시겠습니까?") ) {

			$.post(cst.contextPath() + '/admin/svr_style_delete.htm', $('#svr_style_insert_form').serialize())
				.done(function(str) {
					var data = $.parseJSON(str);
					if(data.RSLT != null && data.RSLT > 0) {
						alert('삭제되었습니다.');
						goListPage();
						return;
					}
					else {
						alert("삭제 실패 하였습니다.\n" + data.ERRMSG + "");
						return;
					}
				})
		}
	}

	function goListPage() {
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.system.svr_style.retrieve.htm').submit();
	}
	
	function clearFormData() {
		if ('U' === '${param.updateFlag}') {
			detailInfoDataSetting('${param.N_STYLE_CODE}');
		} else {
			$("form")[0].reset();
		}
		$("#svr_style_insert_form span.k-tooltip-validation").hide(); // kendo validator 문구 초기화
	}

</script>