<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>Trunk 이름 정보 등록</h2><span>Home &gt; 감시장비 관리 &gt; Trunk 이름 정보 등록</span></div></div>

<form id="trunk_name_insert_form" name="trunk_name_insert_form" data-role="validator">
	<input type="hidden" id="trunk_name_insert_list" name="TRUNK_NAME_INSERT_LIST" value=""/>
	<div class="manager_contBox1">
		<!-- Trunk 이름 정보 등록 시작-->
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
					<td class="filed_A left">장비 ID</td>
					<td class="filed_B left" colspan="3">
						<input type="text" name="N_MON_ID" id="N_MON_ID" class="dupl_chk" style="width:150px;ime-mode:disabled;"
							    onContextMenu="return false;" placeholder="숫자만 입력" size="10" autofocus>
						<span><a href="#" id="btn_mon_list" class="css_btn_class">장비목록</a></span>
						<font id="msg" color="red"></font>
					</td>
				</tr>
				<tr>
					<td class="filed_A left">TRUNK 정보 
						<span class="btn_pack medium"><a href="#" id="append_trunk">추가</a></span>
					</td>
					<td id="trunk_no_list" class="filed_B left" colspan="3">
						<div class="div_trunk_no">
							Trunk Number: <input type="text" name="N_TRUNK_NUMBER" value="" class="manaint_f" style="width:100px;"/>&nbsp;
							Trunk Name: <input type="text" name="S_TRUNK_NAME" value="" class="manaint_f" style="width:80px;"/>&nbsp;
							<span class="btn_pack medium"><a href="#" onclick="removeTrunkField(event, this)">삭제</a></span>
						</div>
					</td>
				</tr>
			</table>
			<!-- botton -->
			<div id="botton_align_center1">
				<a href="#" id="btn_save" class="css_btn_class">저장</a>&nbsp;&nbsp;&nbsp;
				<a href="#" id="btn_cancel" class="css_btn_class">취소</a>
			</div>
			<!-- botton // -->
		</div>
		<!-- Trunk 이름 정보 등록 종료-->

	</div>
</form>

<form id="go_list_form" method="get">
	<input type="hidden" name="searchParam" value="${param.searchParam}"/>
</form>

<div id="dialog_popup"></div>

<script type="text/javascript">

	$(document).ready(function () {
		initEvent();
	});

	function initEvent() {
		$('#btn_cancel').on('click', function (event) {
			event.preventDefault();
			if (confirm("목록으로 이동하시겠습니까?")) {
				goListPage();
			}
		});
		
		$('#btn_save').on('click', save);

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

		$('#append_trunk').on('click', function(event) {
			event.preventDefault();
			var innerHtml = '';
			innerHtml += ' <div class="div_trunk_no"> ';
			innerHtml += ' 	Trunk Number: <input type="text" name="N_TRUNK_NUMBER" value="" class="manaint_f" style="width:100px;"/>&nbsp; ';
			innerHtml += ' 	Trunk Name: <input type="text" name="S_TRUNK_NAME" value="" class="manaint_f" style="width:80px;"/>&nbsp; ';
			innerHtml += ' 	<span class="btn_pack medium"><a href="#" onclick="removeTrunkField(event, this)">삭제</a></span> ';
			innerHtml += ' </div> ';

			$('#trunk_no_list').append(innerHtml);
		});
	}

	function removeTrunkField(event, element) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}
		$(element).parents('.div_trunk_no').remove();
	}
	
	function fn_validation_chk() {
		var monId = $('#N_MON_ID').val();
		if (monId.length < 1 || !($.isNumeric(monId))) {
			alert("장비 ID를 다시 입력해주세요.");
			return false;
		};
		
		$('input[name="N_TRUNK_NUMBER"]').each(function(index) {
			if ($.isNumeric(this.value) == false) {
				alert("TRUNK_NUMBER는 숫자만 입력해주세요.");
				return false;
			}  
		});
		return true;
	}

	function save() {
		// data check
		if (!fn_validation_chk()) {
			return;
		} 
		
		var param = $("form[name='trunk_name_insert_form']").serialize();
		// duplication check
		var checkUrl = "<c:url value='/admin/trunk_name/duplicationCheck.htm'/>";
		var checkPost = $.post(checkUrl, param, function(str) {
			var data = $.parseJSON(str);
			console.log(data);
			if (Number(data.CNT) > 0) {
				alert('중복된 값이 존재합니다. [Trunk Number:' + data.N_TRUNK_NUMBER + ']');
				return false;
			}
			
			var insertUrl = "<c:url value='/admin/trunk_name/insert.htm'/>";
			
			var jqXhr = $.post(insertUrl, param);
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
		});
	}

	function goListPage(event) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.trunk_name.retrieve.htm').submit();
	}

	function dblclickMonGrid(grid) {

		$('tr').on('dblclick', function() {
			$('#N_MON_ID').val(grid.dataItem(grid.select()).N_MON_ID);
			$('#dialog_popup').dialog("close");
			$('#N_TRUNK_NUMBER').focus();
		});
	}
	
</script>