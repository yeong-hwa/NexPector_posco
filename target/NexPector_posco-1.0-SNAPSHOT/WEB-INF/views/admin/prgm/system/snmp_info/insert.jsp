<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>SNMP 정보 관리 등록</h2><span>Home &gt; 시스템정보 관리 &gt; SNMP 정보 관리 등록</span></div></div>

<form id="snmp_info_insert_form" name="snmp_info_insert_form" data-role="validator">
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
					<td class="filed_A left">감시장비</td>
					<td class="filed_B left">
						<cmb:combo qryname="svrComboQry2" seltagname="N_MON_ID" firstdata="전체" etc="id=\"N_MON_ID\""/>
						<!-- <input type="text" name="N_GROUP_CODE" id="N_GROUP_CODE" value="" class="manaint_f" maxlength="10" required validationMessage="필수 입력값 입니다."/> -->
					</td>
					
					<td class="filed_A left">SNMP장비</td>
					<td class="filed_B left">
						<cmb:combo qryname="cmb_snmp_man_code" seltagname="N_SNMP_MAN_CODE" firstdata="전체" etc="id=\"N_SNMP_MAN_CODE\""/>
						<!-- <input type="text" name="S_GROUP_NAME" id="S_GROUP_NAME" value="" class="manaint_f" maxlength="30" required validationMessage="필수 입력값 입니다."/> -->
					</td>
				</tr>
				<tr>
					<td class="filed_A left">SNMP IP</td>
					<td class="filed_B left">
						<input type="text" name="S_SNMP_IP" id="S_SNMP_IP" value="" maxlength="100" class="manaint_f"/>
					</td>
					<td class="filed_A left">SNMP Port</td>
					<td class="filed_B left">
						<input type="text" name="N_SNMP_PORT" id="N_SNMP_PORT" value="" maxlength="100" class="manaint_f"/>
					</td>
				</tr>
				<tr>
					<td class="filed_A left">SNMP Community</td>
					<td class="filed_B left">
						<input type="text" name="S_SNMP_COMMUNITY" id="S_SNMP_COMMUNITY" value="" maxlength="100" class="manaint_f"/>
					</td>
					<td class="filed_A left">SNMP Version</td>
					<td class="filed_B left">
						<SELECT name="N_SNMP_VERSION" id="N_SNMP_VERSION">
									<option value="">선택</option>
									<option value="1">v1</option>
									<option value="2">v2</option>
						</SELECT>
						<!-- <input type="text" name="N_SNMP_VERSION" id="N_SNMP_VERSION" value="" maxlength="100" class="manaint_f"/> -->
					</td>
				</tr>
			</table>

			<!-- botton -->
			<div id="botton_align_center1">
				<a href="#" id="btn_save" class="css_btn_class">저장</a>&nbsp;&nbsp;&nbsp;
				<!-- <a href="#" id="btn_cancel" class="css_btn_class">취소</a>&nbsp;&nbsp;&nbsp; -->
				<c:if test="${param.updateFlag == 'U'}">
					<a href="#" id="btn_remove" class="css_btn_class3">삭제</a>
				</c:if>
			</div>
			<!-- botton // -->
		</div>
	</div>
	<!-- manager_contBox1 // -->
	<input type="hidden" name="OLD_N_SNMP_MAN_CODE" value="${param.N_SNMP_MAN_CODE}"/>
	<input type="hidden" name="OLD_S_SNMP_IP" value="${param.S_SNMP_IP}"/>
	<input type="hidden" name="updateFlag" value="${param.updateFlag}"/>
</form>

<form id="go_list_form" method="get">
	<input type="hidden" name="searchParam" value="${param.searchParam}"/>
</form>

<script type="text/javascript">
	$(document).ready(function() {
		$("#snmp_info_insert_form").kendoValidator().data("kendoValidator");
	
		initEvent();
	
		// 수정 페이지
		if ('U' === '${param.updateFlag}') {
			// 수정시에는 ID 입력 불가로 변경
			var $userIdWrap = $('#N_MON_ID').parent();
			$userIdWrap
				.empty()
				.append('<span id="N_MON_ID">${param.N_MON_ID}</span>')
				.append('<input type="hidden" name="N_MON_ID" value="${param.N_MON_ID}"/>');
	
			detailInfoDataSetting('${param.N_MON_ID}', '${param.N_SNMP_MAN_CODE}', '${param.S_SNMP_IP}');
		}
	});

	function detailInfoDataSetting(monId, snmpManCode, snmpIp) {
		var url 	= cst.contextPath() + '/admin/map_snmp_info.detail_info.htm',
			param 	= {'N_MON_ID' : monId, 'N_SNMP_MAN_CODE' : snmpManCode, 'S_SNMP_IP' : snmpIp};
		$.getJSON(url, $.param(param))
			.done(function(data) {
				$('#N_MON_ID').val(data.N_MON_ID);
				$('#N_SNMP_MAN_CODE').val(data.N_SNMP_MAN_CODE);
				$('#S_SNMP_IP').val(data.S_SNMP_IP);
				$('#N_SNMP_PORT').val(data.N_SNMP_PORT);
				$('#S_SNMP_COMMUNITY').val(data.S_SNMP_COMMUNITY);
				$('#N_SNMP_VERSION').val(data.N_SNMP_VERSION);
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
			$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.system.snmp_info.retrieve.htm').submit();
		});
	
		$('input[type=text]').focusout(function() {
			this.value = $.trim(this.value);
		});
	}
	
	// 저장
	function save() {
		
		if (!fn_validation_chk()) {
			return;
		}
		 
		var url = "<c:url value='/admin/snmp_info_insert.htm'/>";
		var param = $("form[name='snmp_info_insert_form']").serialize();
		
		var jqxhr = $.post(url, param);
		jqxhr.done(function(data) {
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
	
	// 벨리데이션 체크
	function fn_validation_chk() {

		if ($('#S_SNMP_IP').val() === '') {
			alert('SNMP IP를 설정해주세요.');
			$('#S_SNMP_IP').focus();
			return false;
		}
		else if ($('#N_SNMP_PORT').val() === '') {
			alert('SNMP Port를 설정해주세요.');
			$('#N_SNMP_PORT').focus();
			return false;
		}
		else if ($('#S_SNMP_COMMUNITY').val() === '') {
			alert('SNMP Community를 설정해주세요.');
			$('#S_SNMP_COMMUNITY').focus();
			return false;
		}
		else if ($('#N_SNMP_VERSION').val() === '') {
			alert('SNMP Version을 설정해주세요.');
			$('#N_SNMP_VERSION').focus();
			return false;
		}		

		return true;
	}
	
	// 삭제
	function del() {
		
		if ( confirm("작성된 데이터를 삭제 하시겠습니까?") ) {
	
			$.post(cst.contextPath() + '/admin/snmp_info_delete.htm', $('#snmp_info_insert_form').serialize())
				.done(function(data) {
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
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.system.snmp_info.retrieve.htm').submit();
	}
	
	/* 
	function clearFormData() {
		if ('U' === '${param.updateFlag}') {
			detailInfoDataSetting('${param.N_MON_ID}', '${param.N_SNMP_MAN_CODE}', '${param.S_SNMP_IP}');
		} else {
			$("form")[0].reset();
		}
		$("#snmp_info_insert_form span.k-tooltip-validation").hide(); // kendo validator 문구 초기화
	}
	 */
</script>


