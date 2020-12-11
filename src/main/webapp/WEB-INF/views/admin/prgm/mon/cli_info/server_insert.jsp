<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>CLI Server 정보 등록</h2><span>Home &gt; 감시장비 관리 &gt; CLI Server 정보 등록</span></div></div>

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
						<c:choose>
							<c:when test="${param.updateFlag eq 'U'}">
								<span id="MON_ID"></span>
								<input type="hidden" name="MON_ID" value="${param.MON_ID}"/>
							</c:when>
							<c:otherwise>
								<input type="text" name="MON_ID" id="MON_ID" class="dupl_chk" style="width:150px;ime-mode:disabled;"
									   onKeyDown="onlyNumber(event);" onContextMenu="return false;" placeholder="숫자만 입력" size="10" autofocus value="${data.MON_ID}">
								<span><a href="#" id="btn_mon_list" class="css_btn_class">장비목록</a></span>
								<font id="msg" color="red"></font>
							</c:otherwise>
						</c:choose>
					</td>
					<td class="filed_A left">장비IP</td>
					<td class="filed_B left">
						<input type="text" name="SVR_IP" id="SVR_IP" style="width:150px;ime-mode:disabled;"
							   onKeyDown="onlyNumber(event);" onContextMenu="return false;" placeholder="127.0.0.1" value="${data.SVR_IP}">
					</td>
				</tr>
				<tr>
					<td class="filed_A left">Port</td>
					<td class="filed_B left">
						<input type="text" name="SVR_PORT" id="SVR_PORT" style="width:150px;ime-mode:disabled;"
							   onKeyDown="onlyNumber(event);" onContextMenu="return false;" placeholder="8080" size="6" value="${data.SVR_PORT}">
					</td>
					<td class="filed_A left">구분</td>
					<td class="filed_B left">
				        <select name="TERMINAL" id="TERMINAL">
				        	<option value="TELNET" <c:if test="${data.TERMINAL eq 'TELNET'}">selected="selected" </c:if>>Telnet</option>
				        	<option value="SSH" <c:if test="${data.TERMINAL eq 'SSH'}">selected="selected" </c:if>>SSH</option>
				        </select>
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

<script type="text/javascript">

	$(document).ready(function () {
		initEvent();
		
		// 수정 페이지
		if ('U' === '${param.updateFlag}') {
			detailInfoDataSetting('${param.MON_ID}');
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

		$('#btn_mon_list').on('click', function(event) {
			var dialogWidth = 600;
			var jqxhr = $.post('<c:url value="/admin/go_prgm.common.mon_list.htm"/>');

			jqxhr.done(function(html) {
				$('#dialog_popup')
					.html(html)
					.dialog({
						title			: '감시장비 목록',
						resizable		: false,
						width			: dialogWidth,
						modal			: true,
						position		: [($(window).width() / 2) - (dialogWidth / 2), 150],
						autoReposition	: true,
						open			: function() {
							$(this).parent().css({top:50, left:($(window).width() / 2) - (dialogWidth / 2)});
						},
						buttons			: {
							"취소": function() {
								$(this).dialog("close");
							}
						}
					});
			});

			event.preventDefault();
		});

		$(".dupl_chk").blur(function() {
			
			var element = this;
			
			var jqXhr = getJqXhrCheckDuplication($('#MON_ID').val());
			jqXhr.done(function(data) {
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

		if (!cfn_empty_valchk(cli_info_insert_form.SVR_IP, "장비IP")) {
			return false;
		} else {
			if (!ipChk($("#SVR_IP").val())) {
				alert("유효한 IP Address 를 입력하셔야합니다.");
				$('#SVR_IP').focus();
				return false;
			}
		}

		if (!cfn_empty_valchk(cli_info_insert_form.MON_ID, "장비ID")
				|| !cfn_empty_valchk(cli_info_insert_form.SVR_PORT, "PORT 번호")) {
			return false;
		}

		return true;
	}

	function save() {
		if (!fn_validation_chk()) {
			return;
		}

		var jqxhr = getJqXhrCheckDuplication($('#MON_ID').val());
		jqxhr.done(function (data) {
			if (data.CNT > 0 && 'U' != '${param.updateFlag}') {
				alert('중복된 ID 입니다.');
			} else {
				saveData();
			}
		});
	}

	function saveData() {
		var url = "<c:url value='/admin/cli_server_info_insert.htm'/>";
		var param = $("form[name='cli_info_insert_form']").serialize();

		var jqXhr = $.post(url, param);
		jqXhr.done(function (data) {
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

	function getJqXhrCheckDuplication(monId) {
		var url = "<c:url value='map_cli_info.dul_server_chk.htm'/>";
		return $.getJSON(url, $.param({'MON_ID' : monId}));
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

	function dblclickMonGrid(grid) {

		$('tr').on('dblclick', function() {
			var jqXhr = getJqXhrCheckDuplication(grid.dataItem(grid.select()).N_MON_ID);
			jqXhr.done(function(data) {
				if (Number(data.CNT) > 0) {
					alert('중복된 ID 입니다.');
				} else {
					$('#dialog_popup').dialog("close");
					$('#MON_ID').val(grid.dataItem(grid.select()).N_MON_ID);
					$('#SVR_IP').val(grid.dataItem(grid.select()).S_MON_IP);
					$('#SVR_PORT').focus();
				}
			});
		});
	}
	
	function detailInfoDataSetting(mon_id){
		
		var param = {
				'MON_ID'	: mon_id
			};
		
		$.getJSON("<c:url value='/admin/map_cli_info.server_detail_info.htm'/>", param, function(data){
		
			$("#MON_ID").html(data.MON_ID);
			$("#SVR_IP").val(data.SVR_IP);
			$("#SVR_PORT").val(data.SVR_PORT);
			$("#TERMINAL").val(data.TERMINAL);
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