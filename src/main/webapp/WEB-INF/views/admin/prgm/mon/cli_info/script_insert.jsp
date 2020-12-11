<%@ page import="com.nns.common.util.RSACrypt" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>CLI Script 정보 등록</h2><span>Home &gt; 감시장비 관리 &gt; CLI Script 정보 등록</span></div></div>

<form id="cli_info_insert_form" name="cli_info_insert_form" data-role="validator">
	<div class="manager_contBox1">
		<!--//사용자등록 -->
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
					<td class="filed_A left">장비ID</td>
					<td class="filed_B left">
						<span>${param.MON_ID}&nbsp;-&nbsp;${param.SVR_IP}</span>
						<input type="hidden" id="MON_ID" name="MON_ID" value="${param.MON_ID}"/>
					</td>
					<td class="filed_A left">Script ID</td>
					<td class="filed_B left">
					<c:choose>
						<c:when test="${param.updateFlag eq 'U'}">
							<span id="SCRIPT_ID">${param.SCRIPT_ID}</span>
							<input type="hidden" name="SCRIPT_ID" value="${param.SCRIPT_ID}">
						</c:when>
						<c:otherwise>
							<input type="text" name="SCRIPT_ID" id="SCRIPT_ID" class="dupl_chk" style="width:150px;" value=""><font id="msg" color="red"></font>
						</c:otherwise>
					</c:choose>
					</td>
				</tr>
				<tr>
					<td class="filed_A left">Path</td>
					<td class="filed_B left" colspan="3"><input type="text" name="PATH" id="PATH" class="manaint_f" style="width:100%;" value="${data.PATH}"></td>
				</tr>
				<tr>
					<td class="filed_A left">User ID</td>
					<td class="filed_B left"><input type="text" name="USER_ID" id="USER_ID" class="manaint_f" style="width:150px;" value="${data.USER_ID}"></td>
					<td class="filed_A left">User Passwd</td>
					<td class="filed_B left"><input type="password" name="USER_PW" id="USER_PW" class="manaint_f" style="width:150px;"></td>
				</tr>
				
				<tr>
					<td class="filed_A left">Timeout</td>
					<td class="filed_B left">
						<input type="text" name="TIMEOUT" id="TIMEOUT" class="manaint_f" style="width:150px;ime-mode:disabled;"
							   onKeyDown="onlyNumber(event);" onContextMenu="return false;" size="2" placeholder="숫자만 입력" value="${data.TIMEOUT}">
					</td>
					<td class="filed_A left">Interval</td>
					<td class="filed_B left">
						<input type="text" name="INTERVAL_VAL" id="INTERVAL_VAL" class="manaint_f" style="width:150px;ime-mode:disabled;"
							   onKeyDown="onlyNumber(event);" onContextMenu="return false;" size="6" placeholder="숫자만 입력" value="${data.INTERVAL_VAL}">
					</td>
				</tr>
				<tr>
					<td class="filed_A left">Retry Cnt</td>
					<td class="filed_B left">
						<input type="text" name="RETRY_CNT" id="RETRY_CNT" class="manaint_f" style="width:150px;ime-mode:disabled;"
							   onKeyDown="onlyNumber(event);" onContextMenu="return false;" size="2" placeholder="숫자만 입력" value="${data.RETRY_CNT}">
					</td>
					<td class="filed_A left">결과 Table명</td>
					<td class="filed_B left">
						<input type="text" name="RES_TABLE_NAME" id="RES_TABLE_NAME" class="manaint_f" style="width:150px;" value="${data.RES_TABLE_NAME}">
					</td>
				</tr>
				<tr>
					<td class="filed_A left">결과 Class명</td>
					<td class="filed_B left">
						<input type="text" name="PARSE_IMPL_CLASS" id="PARSE_IMPL_CLASS" class="manaint_f" style="width:100%;" value="${data.PARSE_IMPL_CLASS}">
					</td>
					<td class="filed_A left">사용 여부</td>
					<td class="filed_B left">
						<cmb:combo qryname="common.cmb_code" seltagname="USE_YN" selvalue="${data.USE_YN}" etc="id=\"USE_YN\" class=\"input_search\" style=\"width:100;\"" param="S_GROUP_CODE=USE_YN"/>
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

<div id="dialog_popup"></div>

<%-- 비밀번호 암호화 필요시 주석제거
<script src="<c:url value="/common/js/rsa/jsbn.js"/>" type="text/JavaScript"></script>
<script src="<c:url value="/common/js/rsa/rsa.js"/>" type="text/JavaScript"></script>
<script src="<c:url value="/common/js/rsa/prng4.js"/>" type="text/JavaScript"></script>
<script src="<c:url value="/common/js/rsa/rng.js"/>" type="text/JavaScript"></script>
--%>

<script type="text/javascript">

	$(document).ready(function () {
		initEvent();
		
		// 수정 페이지
		if ('U' === '${param.updateFlag}') {
			detailInfoDataSetting('${param.MON_ID}', '${param.SVR_IP}', '${param.SCRIPT_ID}');
		}
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

		$(".dupl_chk").blur(function() {
			
			var element = this;
			
			var jqxhr = getjqXhrCheckDuplication($('#MON_ID').val(), $('#SCRIPT_ID').val());
			jqxhr.done(function(data) {
				if(Number(data.CNT) > 0) {
					$("#msg").remove();
					$("<span/>", {
						'id':"msg"
						, html:"중복된 ID 입니다."
						, style:"color:red;"
					}).appendTo($(element).parent("td"));
				}
				else {
					$("#msg").remove();
				}
			});
		});
	}

	function fn_validation_chk() {
		return cfn_empty_valchk(cli_info_insert_form.SCRIPT_ID, "Script ID")
				&& cfn_empty_valchk(cli_info_insert_form.TIMEOUT, "Timeout")
				&& cfn_empty_valchk(cli_info_insert_form.INTERVAL_VAL, "Interval")
				&& cfn_empty_valchk(cli_info_insert_form.RETRY_CNT, "Retry Cnt");
		
				/* || !cfn_empty_valchk(cli_info_insert_form.PATH, "PATH")
				|| !cfn_empty_valchk(cli_info_insert_form.USER_ID, "User ID")
				|| !cfn_empty_valchk(cli_info_insert_form.USER_PW, "User Passwd")
				|| !cfn_empty_valchk(cli_info_insert_form.RES_TABLE_NAME, "결과 Table명")
				|| !cfn_empty_valchk(cli_info_insert_form.PARSE_IMPL_CLASS, "결과 Class명"); */
	}

	function save() {
		if (!fn_validation_chk()) {
			return;
		}

		if ($('#msg').length > 0) {
			alert('중복된 ID 입니다.');
		} else {
			saveData();
		}
	}

	function saveData() {
		var url = "<c:url value='/admin/cli_script_info_insert.htm'/>";
		var param = $("form[name='cli_info_insert_form']").serialize();

		var jqxhr = $.post(url, param);
		jqxhr.done(function (data) {
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

	function getjqXhrCheckDuplication(monId, scriptId) {
		var url = "<c:url value='map_cli_info.dul_script_chk.htm'/>";
		return $.getJSON(url, $.param({'MON_ID' : monId, 'SCRIPT_ID' : scriptId}));
	}

	function deleteInfo() {

		if (!confirm("정말 삭제 하시겠습니까?")) {
			return;
		}
		var url 	= "<c:url value='/admin/cli_info_delete.htm'/>",
			param 	= $("form[name='cli_info_insert_form']").serialize();

		var jqXhr = $.post(url, param);
		jqXhr.done(function (data) {
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
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.cli_info.retrieve.htm').submit();
	}

	function detailInfoDataSetting(mon_id, svr_ip, script_id){
		
		var param = {
				'MON_ID'	: mon_id,
				'SVR_IP'	: svr_ip,
				'SCRIPT_ID'	: script_id
			};
		
		$.getJSON("<c:url value='/admin/map_cli_info.script_detail_info.htm'/>", param, function(data){
			$("#SCRIPT_ID").html(data.SCRIPT_ID);
			$("#PATH").val(data.PATH);
			$("#USER_ID").val(data.USER_ID);
			$("#TIMEOUT").val(data.TIMEOUT);
			$("#INTERVAL_VAL").val(data.INTERVAL_VAL);
			$("#RETRY_CNT").val(data.RETRY_CNT);
			$("#RES_TABLE_NAME").val(data.RES_TABLE_NAME);
			$("#PARSE_IMPL_CLASS").val(data.PARSE_IMPL_CLASS);
			$("#USE_YN").val(data.USE_YN);
		});
	}
	
	// Deprecated 폼 초기화 요건이 생기면 주석 제거
	/*function clearFormData() {
		if ('U' === '${param.updateFlag}') {
			searchDetailInfo();
		} else {
			$("form")[0].reset();
		}
		$("#cli_info_insert_form span.k-tooltip-validation").hide(); // kendo validator 문구 초기화
	}*/
	
</script>