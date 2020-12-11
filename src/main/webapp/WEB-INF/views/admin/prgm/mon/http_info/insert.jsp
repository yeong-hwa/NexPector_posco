<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>HTTP 정보 등록</h2><span>Home &gt; HTTP 정보 관리 &gt; HTTP 정보 등록</span></div></div>

<form id="form" name="form" data-role="validator">
	<div class="manager_contBox1">
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
								<span id="txt_mon_id"></span>
								<input type="hidden" id="MON_ID" name="MON_ID" value="${param.MON_ID}"/>
							</c:when>
							<c:otherwise>
								<input type="text" id="MON_ID" name="MON_ID" class="dupl_chk" style="width:150px;ime-mode:disabled;"
									   onKeyDown="onlyNumber(event);" onContextMenu="return false;" placeholder="숫자만 입력" size="10" autofocus">
								<span><a href="#" id="btn_mon_list" class="css_btn_class">장비목록</a></span>
								<font id="msg" color="red"></font>
							</c:otherwise>
						</c:choose>
					</td>
					<td class="filed_A left">장비명</td>
					<td class="filed_B left">
						<span id="txt_mon_name"></span>
					</td>
				</tr>
				<tr>
					<td class="filed_A left">URL ALIAS</td>
					<td class="filed_B left">
						<c:choose>
							<c:when test="${param.updateFlag eq 'U'}">
								<span id="txt_url_alias"></span>
								<input type="hidden" id="URL_ALIAS" name="URL_ALIAS" value="${param.URL_ALIAS}"/>
							</c:when>
							<c:otherwise>
								<input type="text" id="URL_ALIAS" name="URL_ALIAS" />
							</c:otherwise>
						</c:choose>
					</td>
					<td class="filed_A left">Parser 명</td>
					<td class="filed_B left">
						<c:choose>
							<c:when test="${param.updateFlag eq 'U'}">
								<span id="txt_parser_name"></span>
								<input type="hidden" id="PARSER_NAME" name="PARSER_NAME" value="${param.PARSER_NAME}"/>
							</c:when>
							<c:otherwise>
								<input type="text" id="PARSER_NAME" name="PARSER_NAME" />
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
					<td class="filed_A left">URL</td>
					<td class="filed_B left">
						<input type="text" id="URL" name="URL" style="width:500px;"/>
					</td>
					<td class="filed_A left"></td>
					<td class="filed_B left">
					</td>
				</tr>
				
				<tr>
					<td class="filed_A left">서버 IP</td>
					<td class="filed_B left">
						<input type="text" id="SERVER_IP" name="SERVER_IP" />
					</td>
					<td class="filed_A left">서버 포트</td>
					<td class="filed_B left">
						<input type="number" id="SERVER_PORT" name="SERVER_PORT" onKeyDown="onlyNumber(event);"/>
					</td>					
				</tr>
				<tr>
					<td class="filed_A left">프로토콜 타입</td>
					<td class="filed_B left">
						<select id="PROTOCOL_TYPE" name="PROTOCOL_TYPE">
							<option value="0">HTTP</option>
							<option value="1">HTTPS</option>
						</select>
					</td>
					<td class="filed_A left">인코딩 타입</td>
					<td class="filed_B left">
						<select id="ENCODE_TYPE" name="ENCODE_TYPE">
							<option value="UTF-8">UTF-8</option>
							<option value="EUC-KR">EUC-KR</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="filed_A left">수집주기(초)</td>
					<td class="filed_B left">
						<input type="number" id="COLLECT_PERIOD" name="COLLECT_PERIOD" onKeyDown="onlyNumber(event);"/>
					</td>
					<td class="filed_A left">비고</td>
					<td class="filed_B left">
						<input type="text" id="DESC" name="DESC" style="width:500px;"/>
					</td>
				</tr>
				<tr>
					<td class="filed_A left">알람타입</td>
					<td class="filed_B left">
						<select id="ALM_TYPE" name="ALM_TYPE" style="width:200px;">
							<option value="">선택</option>
						</select>
					</td>
					<td class="filed_A left">알람코드</td>
					<td class="filed_B left">
						<select id="ALM_CODE" name="ALM_CODE" style="width:200px;">
							<option value="">선택</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="filed_A left">연결체크</td>
					<td class="filed_B left">
						<select id="CONN_CHECK" name="CONN_CHECK">
							<option value="Y">사용</option>
							<option value="N">사용안함</option>
						</select>
					</td>
					<td class="filed_A left">사용여부</td>
					<td class="filed_B left">
						<select id="ENABLE" name="ENABLE">
							<option value="Y">사용</option>
							<option value="N">사용안함</option>
						</select>
					</td>
				</tr>
			</td>
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
		
		makeCombo($("#ALM_TYPE"), "<c:url value='/admin/lst_common.cmb_alm_type.htm'/>");
		
		// 수정 페이지
		if ('U' === '${param.updateFlag}') {
			makeCombo($("#ALM_CODE"), "<c:url value='/admin/lst_common.cmb_alm_code.htm'/>", {ALM_TYPE : '${param.ALM_TYPE}'}, function () {
				detailInfoDataSetting('${param.MON_ID}', '${param.PARSER_NAME}', '${param.URL_ALIAS}');
			});
		}
	});

	function makeCombo(obj, url, param, fn_callback) {
		var jqXhr = $.post(url, param);
		jqXhr.done(function (str) {
			var data = JSON.parse(str);
			
			$(obj).empty();
			$(obj).append("<option value=''>선택</option>");
			
			for (var i = 0; i < data.length; i++) {
				$(obj).append("<option value=" + data[i].CODE + ">" + data[i].VAL + "</option>");
			}
			
			fn_callback && fn_callback();
		});
	}
	
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

		$("#ALM_TYPE").on('change', function() {
			makeCombo($('#ALM_CODE'), "<c:url value='/admin/lst_common.cmb_alm_code.htm'/>", { ALM_TYPE : $(this).val() });
		});
		
	}
	
	function fn_validation_chk() {
		var validFlag = true;
		
		if(!$("#MON_ID").val().trim()) {
			alert('장비 ID를 선택해주세요.');
			validFlag = false;
			$("#MON_ID").focus();
		}
		
		if(!$("#PARSER_NAME").val().trim()) {
			alert('Parser 명을 입력해주세요.');
			validFlag = false;
			$("#PARSER_NAME").focus();
		}
		
		if(!$("#SERVER_PORT").val().trim()) {
			alert('서버 포트를 입력해주세요.');
			validFlag = false;
			$("#SERVER PORT").focus();
		}
		
		return validFlag;
	}

	function save() {
		if (!fn_validation_chk()) {
			return;
		}
		
		var jqxhr = getJqXhrCheckDuplication($('#MON_ID').val(), $('#PARSER_NAME').val());
		jqxhr.done(function (data) {
			
			if (data.length > 0 && 'U' != '${param.updateFlag}') {
				alert('중복된 ID 입니다.');
			} else {
				saveData();
			}
		});
	}

	function saveData() {
		
		var url = ('${param.updateFlag}' != 'U') ? "<c:url value='/admin/http_info/insert.htm'/>" : "<c:url value='/admin/http_info/update.htm'/>";
		
		// $('#URL_ALIAS').val($.trim($('#SERVER_IP').val() +':' + $('#SERVER_PORT').val()));
		
		var param = $("form[name='form']").serialize();
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

	function deleteInfo() {
		if (!confirm("삭제 하시겠습니까?")) {
			return;
		}
		
		var url 	= "<c:url value='/admin/http_info/delete.htm'/>",
			param 	= $("form[name='form']").serialize();

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
	
	function getJqXhrCheckDuplication(monId, parserName) {
		var url = "<c:url value='/admin/lst_http_info.detail_data.htm'/>";
		return $.getJSON(url, $.param({'MON_ID' : monId, 'PARSER_NAME' : parserName}));
	}
	
	function dblclickMonGrid(grid) {
		$('tr').on('dblclick', function() {
			$('#dialog_popup').dialog("close");
			$('#MON_ID').val(grid.dataItem(grid.select()).N_MON_ID);
			$('#txt_mon_name').html(grid.dataItem(grid.select()).S_MON_NAME);
			// $('#txt_mon_ip').html(grid.dataItem(grid.select()).SERVER_IP);
			$('#SERVER_IP').val(grid.dataItem(grid.select()).SERVER_IP);
		});
	}
	
	function goListPage(event) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.http_info.retrieve.htm').submit();
	}

	function detailInfoDataSetting(monId, parserName, urlAlias){
		
		var param = {
			'MON_ID'	: monId
			, 'PARSER_NAME'	: parserName
			, 'URL_ALIAS'	: urlAlias
		};
		
		$.getJSON("<c:url value='/admin/map_http_info.detail_data.htm'/>", param, function(data){
			console.log(data);
			
			$("#txt_mon_id").html(data.MON_ID);
			$("#txt_mon_name").html(data.S_MON_NAME);
			$("#txt_parser_name").html(data.PARSER_NAME);
			$("#txt_url_alias").html(data.URL_ALIAS);
			
			$("#PARSER_NAME").val(data.PARSER_NAME);
			$("#URL_ALIAS").val(data.URL_ALIAS);
			$("#URL").val(data.URL);
			$("#SERVER_IP").val(data.SERVER_IP);
			$("#SERVER_PORT").val(data.SERVER_PORT);
			$("#COLLECT_PERIOD").val(data.COLLECT_PERIOD);
			$("#PROTOCOL_TYPE").val(data.PROTOCOL_TYPE);
			$("#ENCODE_TYPE").val(data.ENCODE_TYPE);
			$("#DESC").val(data.DESC);
			$("#ALM_TYPE").val(data.ALM_TYPE);
			$("#ALM_CODE").val(data.ALM_CODE);
			$("#CONN_CHECK").val(data.CONN_CHECK);
			$('#ENABLE').val(data.ENABLE);
			
		});
	}
	
</script>