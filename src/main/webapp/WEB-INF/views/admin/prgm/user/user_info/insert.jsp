<%@ page import="com.nns.common.util.RSACrypt" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>사용자 정보 등록</h2><span>Home &gt; 사용자 관리 &gt; 사용자 정보등록</span></div></div>

<form id="user_insert_form" data-role="validator">
	<input type="hidden" id="s_sms_no_list" name="S_SMS_NO_LIST" value=""/>
	<div style="float: left;margin-bottom: 5px;">
		<a href="#" id="btn_list" class="css_btn_class">목록</a>
	</div>
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
					<td class="filed_A left"><label for="txt_user_id" class="required">사용자ID</label></td>
					<td class="filed_B left"><input type="text" name="S_USER_ID" id="txt_user_id" value="" class="manaint_f" required validationMessage="필수 입력값 입니다."/></td>
					<td class="filed_A left">사용자명</td>
					<td class="filed_B left"><input type="text" name="S_USER_NAME" id="txt_user_name" value="" class="manaint_f" style="width: 200px;" required validationMessage="필수 입력값 입니다."/></td>
				</tr>
				<tr>
					<td class="filed_A left">비밀번호</td>
					<td class="filed_B left" colspan="3">
						<input type="password" name="S_USER_PWD" id="txt_user_pwd" value="" class="manaint_f" pattern="^(?=.*[a-zA-Z])(?=.*[0-9]).{4,20}$" required validationMessage="비밀번호는 형식이 잘못입력되었습니다."/>
					</td>
					<!-- 
					<td class="filed_A left">비밀번호</td>
					<td class="filed_B left"><input type="password" name="S_USER_PWD" id="txt_user_pwd" value="" class="manaint_f" pattern="^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,20}$" required validationMessage="비밀번호는 형식이 잘못입력되었습니다."/></td>
					<td class="filed_A left">Email</td>
					<td class="filed_B left"><input type="email" name="S_USER_EMAIL" id="txt_user_email" value="" class="manaint_f" style="width: 200px;" required validationMessage="필수 입력값 입니다." data-email-msg="Email 포맷이 잘못되었습니다."/></td>
					 -->
				</tr>
				<tr>
					<td class="filed_A left">그룹</td>
					<td class="filed_B left">
						<select name="N_GROUP_CODE" id="sel_group_code">
							<option value="">없음</option>
						</select>
					</td>
					<td class="filed_A left">사용여부</td>
					<td class="filed_B left">
						<select name="F_USE" id="sel_use">
							<option value="Y">사용</option>
							<option value="N">사용안함</option>
						</select>
					</td>
				</tr>
<!-- 				<tr>
					<td class="filed_A left">접근 가능 IP</td>
					<td class="filed_B left">
						<input type="text" name="S_ACCESS_IP" id="txt_access_ip" value="" class="manaint_f" required validationMessage="필수 입력값 입니다."/>
					</td>
					<td class="filed_A left"></td>
					<td class="filed_B left">
					</td>
				</tr> -->
				
				<tr>
					<td class="filed_A left">SMS번호 <span class="btn_pack medium"><a href="#" id="append_sms">추가</a></span></td>
					<td id="sms_no_list" class="filed_B left" colspan="3">
						<%--<div class="div_sms_no">
							성명 <input type="text" name="S_SMS_NAME" value="" class="manaint_f" style="width:80px;"/>&nbsp;
							SMS번호 <input type="text" name="S_SMS_NO" value="" class="manaint_f" style="width:100px;"/>&nbsp;
							<span class="btn_pack medium"><a href="">삭제</a></span>
						</div>--%>
					</td>
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
</form>

<form id="go_list_form" method="get">
	<input type="hidden" name="searchParam" value="${param.searchParam}"/>
</form>

<script src="<c:url value="/common/js/rsa/jsbn.js"/>" type="text/JavaScript"></script>
<script src="<c:url value="/common/js/rsa/rsa.js"/>" type="text/JavaScript"></script>
<script src="<c:url value="/common/js/rsa/prng4.js"/>" type="text/JavaScript"></script>
<script src="<c:url value="/common/js/rsa/rng.js"/>" type="text/JavaScript"></script>

<script type="text/javascript">
	$(document).ready(function() {
		$("#user_insert_form").kendoValidator().data("kendoValidator");

		//cfn_makecombo_opt($('#sel_group_code'), cst.contextPath() + '/admin/lst_common.cmb_user_group.htm');
		cfn_makecombo_opt($('#sel_group_code'), cst.contextPath() + '/admin/lst_cmb_svr_group.htm');

		initEvent();

		// 수정 페이지
		if ('U' === '${param.updateFlag}') {
			// 수정시에는 비밀번호 필수값 체크 제거
			$('#txt_user_pwd').removeAttr('required');
			// 수정시에는 ID 입력 불가로 변경
			var $userIdWrap = $('#txt_user_id').parent();
			$userIdWrap
				.empty()
				.append('<span id="txt_user_id">${param.S_USER_ID}</span>')
				.append('<input type="hidden" name="S_USER_ID" value="${param.S_USER_ID}"/>');

			if("${sessionScope.S_USER_ID}" ===  "SA") {
				$userIdWrap.append('&nbsp;&nbsp;&nbsp;<span class="btn_pack medium"><a href="#" onclick="fn_userUnlock()">계정 잠금 해제</a></span>');
			}				
				
			searchDetailInfo('${param.S_USER_ID}');
		}
	});

	function fn_userUnlock() {
		if( confirm("계정 잠금을 해제하시겠습니까?") ) {
			var url = "<c:url value='/admin/user_unlock.htm'/>";
			$.post(url, {'S_USER_ID' : '${param.S_USER_ID}'})
			.done(function(str) {
				var data = $.parseJSON(str);
				if(Number(data.RSLT) > 0) {
					alert("계정 잠금 해제에 성공 하였습니다.");
					return;
				} else {
					alert("계정 잠금 해제에 실패 하였습니다.");
					return;
				}
			});	
		}
	}

	function searchDetailInfo(userId) {
		if ($('body').data('detail')) {
			detailInfoDataSetting($('body').data('detail'));
		}
		else {
			var url 	= cst.contextPath() + '/admin/user_detail.htm',
				param 	= {'S_USER_ID' : userId};
			$.getJSON(url, $.param(param)).done(detailInfoDataSetting);
		}
	}

	function detailInfoDataSetting(data) {
		$('body').data('detail', data); // form 초기화 시에 다시 불러오기 위해 임시 저장

		$('#txt_user_id').val(data.S_USER_ID);
		$('#txt_user_name').val(data.S_USER_NAME);
		$('#txt_user_pwd').val('');
		$('#txt_user_email').val(data.S_USER_EMAIL);
		$('#sel_group_code').val(data.N_GROUP_CODE);
		$('#sel_use').val(data.F_USE);
		$('#txt_access_ip').val(data.S_ACCESS_IP);

		// SMS 번호
		var $smsNoList = $('#sms_no_list').empty();
		var sms = data.S_SMS_NO2 ? data.S_SMS_NO2.split(',') : [];
		for (var i = 0, length = sms.length; i < length; i++) {
			var s 		= sms[i].split(';'),
				name 	= s[0],
				phone 	= s[1];

			var innerHtml = '';
			innerHtml += ' <div class="div_sms_no"> ';
			innerHtml += ' 	성명 <input type="text" name="S_SMS_NAME" value="' + name + '" class="manaint_f" style="width:80px;"/>&nbsp; ';
			innerHtml += ' 	SMS번호 <input type="tel" name="S_SMS_NO" value="' + phone + '" class="manaint_f" style="width:100px;"/>&nbsp; ';
			innerHtml += ' 	<span class="btn_pack medium"><a href="#" onclick="removeSmsField(event, this)">삭제</a></span> ';
			innerHtml += ' </div> ';

			$smsNoList.append(innerHtml);
		}
	}

	function initEvent() {
		$('#btn_cancel').on('click', function(event) {
			event.preventDefault();
			if ( confirm("작성된 데이터를 초기화 하시겠습니까?") ) {
				clearFormData();
			}
		});

		$('#append_sms').on('click', function(event) {
			event.preventDefault();
			var innerHtml = '';
			innerHtml += ' <div class="div_sms_no"> ';
			innerHtml += ' 	성명 <input type="text" name="S_SMS_NAME" value="" class="manaint_f" style="width:80px;"/>&nbsp; ';
			innerHtml += ' 	SMS번호 <input type="tel" name="S_SMS_NO" value="" class="manaint_f" style="width:100px;"/>&nbsp; ';
			innerHtml += ' 	<span class="btn_pack medium"><a href="#" onclick="removeSmsField(event, this)">삭제</a></span> ';
			innerHtml += ' </div> ';

			$('#sms_no_list').append(innerHtml);
		});

		$('#btn_save').on('click', save);

		$('#btn_remove').on('click', deleteUserInfo);

		$('#btn_list').on('click', goListPage);

		$('input[type=text]').focusout(function() {
			this.value = $.trim(this.value);
		});
	}

	function removeSmsField(event, element) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}
		$(element).parents('.div_sms_no').remove();
	}

	// 저장
	function save(event) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}

		var validator = $("#user_insert_form").data("kendoValidator");
		if ( validator.validate() ) {

			// SMS
			var tmp_sms_no = "";
			$(".div_sms_no").each(function (idx) {
				if (idx != 0) {
					tmp_sms_no += ",";
				}
				tmp_sms_no += $(this).children("input[name='S_SMS_NAME']").val() + ";" + $(this).children("input[name='S_SMS_NO']").val();
			});

			$("#s_sms_no_list").val(tmp_sms_no);

			// 비밀번호 암호화
			var rsa = new RSAKey(),
					$password = $("#txt_user_pwd");

			var url;
			if ('U' === '${param.updateFlag}') {
				// 비밀번호를 변경하지 않을경우 공백이 암호화 되어 넘어가서 공백은 그냥 보냄
				if ($.trim($password.val()) !== '') {
					rsa.setPublic("<%=RSACrypt.getModulusKey()%>", "<%=RSACrypt.getPublicKey()%>");
					$password.val(rsa.encrypt($password.val()));
				}
				url = cst.contextPath() + '/admin/user_update.htm';
				saveData(url);
			} else {
				rsa.setPublic("<%=RSACrypt.getModulusKey()%>", "<%=RSACrypt.getPublicKey()%>");
				$password.val( rsa.encrypt($.trim($password.val())) );

				url = cst.contextPath() + '/admin/user_insert.htm';
				var xhr = checkDuplication();
				xhr.done(function(data) {
					if (data.CNT > 0) {
						alert('중복된 사용자ID 입니다.');
					} else {
						saveData(url);
					}
				});
			}
		}
		else {
			alert("잘못된 형식의 데이터가 존재합니다.");
		}
	}

	function saveData(url) {
		$.post(url, $('#user_insert_form').serialize())
			.done(function(str) {
				var data = $.parseJSON(str);
				if(Number(data.RSLT) > 0) {
					alert('저장되었습니다.');
					goListPage();
					return;
				}
				else if (Number(data.RSLT) === -1000) {
					alert('기존에 사용한 암호는 사용 불가능합니다.');
					$("#txt_user_pwd").focus().val('');
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
			var url = cst.contextPath() + '/admin/user_delete.htm';

			var param = $("#user_insert_form").serialize();
			$.post(url, param, function(str) {
				var data = $.parseJSON(str);
				if (data.RSLT != null && data.RSLT > 0) {
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

	function goListPage(event) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.user.user_info.retrieve.htm').submit();
	}

	function clearFormData() {
		if ('U' === '${param.updateFlag}') {
			searchDetailInfo();
		} else {
			$("form")[0].reset();
		}
		$("#user_insert_form span.k-tooltip-validation").hide(); // kendo validator 문구 초기화
	}

	function checkDuplication() {
		return $.getJSON("<c:url value='map_user_info.dul_chk.htm'/>", $("#user_insert_form").serialize());
	}
</script>