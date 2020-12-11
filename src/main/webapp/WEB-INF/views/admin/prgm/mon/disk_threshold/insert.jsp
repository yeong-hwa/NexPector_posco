<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>메뉴 정보 등록</h2><span>Home &gt; 시스템정보 관리 &gt; 메뉴 정보 등록</span></div></div>

<form id="menu_insert_form" data-role="validator">
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
					<td class="filed_A left">
						상위메뉴
					</td>
					<td class="filed_B left">
						<select id="P_MENU" name="P_MENU">
							<option value="">없음</option>
						</select>
					</td>
					<td class="filed_A left">메뉴명</td>
					<td class="filed_B left">
						<input type="text" name="S_MENU_NAME" id="S_MENU_NAME" value=""  maxlength="30" class="manaint_f"/>
					</td>
				</tr>
				<tr>
					<td class="filed_A left">메뉴 URL</td>
					<td class="filed_B left">
						<input type="text" name="S_MENU_URL" id="S_MENU_URL" value="" maxlength="100" class="manaint_f"/>
					</td>
					<td class="filed_A left">사용여부</td>
					<td class="filed_B left">
		            	<SELECT name="F_USE" id="F_USE">
		            		<option value="Y">사용</option>
		            		<option value="N">사용안함</option>
		            	</SELECT>
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
	<input type="hidden" name="N_MENU_CODE" id="N_MENU_CODE" value="${param.N_MENU_CODE}"/>
	<input type="hidden" name="updateFlag" value="${param.updateFlag}"/>
</form>

<form id="go_list_form" method="get">
	<input type="hidden" name="searchParam" value="${param.searchParam}"/>
</form>

<script type="text/javascript">
	$(document).ready(function() {

		cfn_makecombo_opt($("#P_MENU"), "<c:url value="/admin/lst_common.cmb_lmenu.htm"/>");

		$("#menu_insert_form").kendoValidator().data("kendoValidator");

		initEvent();

		// 수정 페이지
		if ('U' === '${param.updateFlag}') {
			detailInfoDataSetting('${param.N_MENU_CODE}');
		}
	});


	function detailInfoDataSetting(menuCode) {
		var url 	= cst.contextPath() + '/admin/map_menu_info.detail_info.htm',
			param 	= {'N_MENU_CODE' : menuCode};
		$.getJSON(url, $.param(param))
			.done(function(data) {
				$('#P_MENU').val(data.P_MENU);
				$('#N_MENU_CODE').val(data.N_MENU_CODE);
				$('#S_MENU_NAME').val(data.S_MENU_NAME);
				$('#S_MENU_URL').val(data.S_MENU_URL);
				$('#F_USE').val(data.F_USE);
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
			$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.system.menu_info.retrieve.htm').submit();
		});

		$('input[type=text]').focusout(function() {
			this.value = $.trim(this.value);
		});
	}

	// 저장
	function save() {
		var validator = $("#menu_insert_form").data("kendoValidator");
		if ( validator.validate() ) {

			$.post(cst.contextPath() + '/admin/menu_insert.htm', $('#menu_insert_form').serialize())
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

			$.post(cst.contextPath() + '/admin/menu_delete.htm', $('#menu_insert_form').serialize())
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

	function clearFormData() {
		$("form")[0].reset();
		$("#menu_insert_form span.k-tooltip-validation").hide(); // kendo validator 문구 초기화
	}

	function goListPage() {
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.system.menu_info.retrieve.htm').submit();
	}
	
	function clearFormData() {
		if ('U' === '${param.updateFlag}') {
			detailInfoDataSetting('${param.N_MENU_CODE}');
		} else {
			$("form")[0].reset();
		}
		$("#menu_insert_form span.k-tooltip-validation").hide(); // kendo validator 문구 초기화
	}

</script>