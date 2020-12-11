<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>감시장비 프로세스 등록</h2><span>Home &gt; 감시장비 프로세스 관리 &gt; 감시장비 프로세스 등록</span></div></div>

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
								<span id="N_MON_ID"></span>
								<input type="hidden" name="N_MON_ID" value="${param.N_MON_ID}"/>
							</c:when>
							<c:otherwise>
								<input type="text" name="N_MON_ID" id="N_MON_ID" class="dupl_chk" style="width:150px;ime-mode:disabled;"
									   onKeyDown="onlyNumber(event);" onContextMenu="return false;" placeholder="숫자만 입력" size="10" autofocus">
								<span><a href="#" id="btn_mon_list" class="css_btn_class">장비목록</a></span>
								<font id="msg" color="red"></font>
							</c:otherwise>
						</c:choose>
					</td>
					<td class="filed_A left">장비IP</td>
					<td class="filed_B left">
						<span id="txt_mon_ip"></span>
					</td>
				</tr>
				<tr>
					<td class="filed_A left">장비명</td>
					<td class="filed_B left">
						<span id="txt_mon_name"></span>
					</td>
					<td class="filed_A left"></td>
						<input id="daemonList" name="S_DAEMON_LIST" type="hidden" />
					<td class="filed_B left">
					</td>
				</tr>
				<tr id="process_info">
					<td class="filed_A left">프로세스명 <span class="btn_pack medium"><a href="#" id="append_process">추가</a></span></td>
					<td id="process_list" class="filed_B left" colspan="3"></td>
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
	var processCnt = 0;
	
	$(document).ready(function () {
		initEvent();
		
		// 수정 페이지
		if ('U' === '${param.updateFlag}') {
			detailInfoDataSetting('${param.N_MON_ID}');
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
			
			var jqXhr = getJqXhrCheckDuplication($('#N_MON_ID').val());
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
		
		$('#append_process').on('click', function(event) {
			event.preventDefault();
			processCnt += 1;
			
			var innerHtml = '';
			innerHtml += ' <div class="div_process"> ';
			innerHtml += ' 	프로세스 <input type="text" name="S_PROCESS_NAME" value="" class="manaint_f" style="width:200px;"/>&nbsp; ';
			innerHtml += ' 	별칭 <input type="text" name="S_ALIAS" value="" class="manaint_f" style="width:200px;"/>&nbsp; ';
			
			innerHtml += '<input type="radio" name="F_DAEMON' + processCnt + '" value="S" checked>SNMP &nbsp;';
			innerHtml += '<input type="radio" name="F_DAEMON' + processCnt + '" value="A">Agent &nbsp;';
			innerHtml += '<input type="radio" name="F_DAEMON' + processCnt + '" value="C">CLI &nbsp;';
			
			innerHtml += ' 	<span class="btn_pack medium"><a href="#" onclick="removeProcessField(event, this)">삭제</a></span> ';
			innerHtml += ' </div> ';

			$('#process_list').append(innerHtml);
		});
	}
	
	function removeProcessField(event, element) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}
		$(element).parents('.div_process').remove();
	}
	
	function fn_validation_chk() {
		var validFlag = true;
		
		$("input[name='S_PROCESS_NAME']").each(function (index){
			if(validFlag) {
				var s = $(this).val();
				if (!s) {
					validFlag = false;
					alert('프로세스 명을 입력해주세요.');
					$(this).focus();
					return;
				}
			}
		});
		
		$("input[name='S_ALIAS']").each(function (index){
			if(validFlag) {
				var s = $(this).val();
				if (!s) {
					validFlag = false;
					alert('프로세스 별칭을 입력해주세요.');
					$(this).focus();
					return;
				}
			}
		});
		
		return validFlag;
	}

	function save() {
		if (!fn_validation_chk()) {
			return;
		}

		var jqxhr = getJqXhrCheckDuplication($('#N_MON_ID').val());
		jqxhr.done(function (data) {
			if (data.CNT > 0 && 'U' != '${param.updateFlag}') {
				alert('중복된 ID 입니다.');
			} else {
				saveData();
			}
		});
	}

	function saveData() {
		var url = "<c:url value='/admin/process_info/insert.htm'/>";
		
		var tmpDaeMonList = "";
		$("input[type='radio']:checked").each(function (index){
			if (tmpDaeMonList != "") {	
				tmpDaeMonList += ",";
			}
			tmpDaeMonList += $(this).val();
		});		
		
		$('#daemonList').val(tmpDaeMonList);
		
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
		if (!confirm("프로세스 전체를 삭제 하시겠습니까?")) {
			return;
		}
		
		var url 	= "<c:url value='/admin/process_info/delete.htm'/>",
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
	
	function getJqXhrCheckDuplication(nMonId) {
		var url = "<c:url value='map_process_info.duplicationCheck.htm'/>";
		return $.getJSON(url, $.param({'N_MON_ID' : nMonId}));
	}

	function goListPage(event) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.process_info.retrieve.htm').submit();
	}

	function dblclickMonGrid(grid) {
		$('tr').on('dblclick', function() {
			var jqXhr = getJqXhrCheckDuplication(grid.dataItem(grid.select()).N_MON_ID);
			jqXhr.done(function(data) {
				if (Number(data.CNT) > 0) {
					alert('중복된 ID 입니다.');
				} else {
					$('#dialog_popup').dialog("close");
					$('#N_MON_ID').val(grid.dataItem(grid.select()).N_MON_ID);
					$('#txt_mon_ip').text(grid.dataItem(grid.select()).S_MON_IP);
					$('#txt_mon_name').text(grid.dataItem(grid.select()).S_MON_NAME);
				}
			});
		});
	}
	
	function detailInfoDataSetting(nMonId){
		
		var param = {
			'N_MON_ID'	: nMonId
		};
		
		$.getJSON("<c:url value='/admin/map_mon_info.detail_info.htm'/>", param, function(data){
			$("#N_MON_ID").html(data.N_MON_ID);
			$("#txt_mon_ip").html(data.S_MON_IP);
			$("#txt_mon_name").html(data.S_MON_NAME);
		});
		
		$.getJSON("<c:url value='/admin/lst_process_info.select_mon_process.htm'/>", {'N_MON_ID': nMonId}, function(data){
			
			var processList = data;
			var innerHtml = '';
			for(var i=0; i<processList.length; i++) {
				processCnt += 1;
				
				innerHtml += " <div class='div_process'> ";
				innerHtml += " 	프로세스 <input type='text' name='S_PROCESS_NAME' value='" + processList[i].S_MON_NAME + "' class='manaint_f' style='width:200px;'/>&nbsp; ";
				innerHtml += " 	별칭 <input type='text' name='S_ALIAS' value='" + processList[i].S_ALIAS + "' class='manaint_f' style='width:200px;'/>&nbsp; ";
				
				innerHtml += "<input type='radio' name='F_DAEMON" + processCnt + "' value='S'";
				if (processList[i].F_DAEMON == 'S') {
					innerHtml += " checked";
				}
				innerHtml += ">SNMP &nbsp;";
				innerHtml += "<input type='radio' name='F_DAEMON" + processCnt + "' value='A'";
				if (processList[i].F_DAEMON == 'A') {
					innerHtml += " checked";
				}
				innerHtml += ">Agent &nbsp;";
				innerHtml += "<input type='radio' name='F_DAEMON" + processCnt + "' value='C'";
				if (processList[i].F_DAEMON == 'C') {
					innerHtml += " checked";
				}
				innerHtml += ">CLI &nbsp;";
				
				innerHtml += " 	<span class='btn_pack medium'><a href='#' onclick='removeProcessField(event, this)'>삭제</a></span> ";
				innerHtml += " </div> ";
			}
			$("#process_list").append(innerHtml);
		});

	}
	
</script>