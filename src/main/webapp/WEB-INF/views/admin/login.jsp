<%@ page import="com.nns.common.util.RSACrypt" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<%
//	session.invalidate();
%>

<!-- BEGIN: Main -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<Html>
<Head>
<title>::: NexPecter Manager :::</title>
<meta http-equiv="Content-Type" content="text/html; charset=uft-8">

<link rel="stylesheet" href="<c:url value="/css/sign.css" />" />

<script src="<c:url value="/js/jquery-1.11.2.min.js"/>" type="text/javascript"></script>
<script src="<c:url value="/js/jquery.blockUI.js"/>" type="text/javascript"></script>
<script src="<c:url value="/js/jquery-ui-1.11.4.custom/jquery-ui.min.js"/>" type="text/javascript"></script>
<script src="<c:url value="/common/js/rsa/jsbn.js"/>" type="text/JavaScript"></script>
<script src="<c:url value="/common/js/rsa/rsa.js"/>" type="text/JavaScript"></script>
<script src="<c:url value="/common/js/rsa/prng4.js"/>" type="text/JavaScript"></script>
<script src="<c:url value="/common/js/rsa/rng.js"/>" type="text/JavaScript"></script>
<script src="<c:url value="/js/jquery.leanModal.min.js"/>" type="text/JavaScript"></script>
<script src="<c:url value="/js/auth.js"/>" type="text/JavaScript"></script>
<script>

	$(function(){

		var contextPath = '${ctx}';

		$('a[rel*=leanModal]').leanModal({ top : 200, closeButton: ".modal_close" });

		$('#login_user_id').focus();
		<c:if test="${result == 'fail'}">
			<c:choose>
				<c:when test="${code ne null && code eq '1000'}">
					$("input[name='S_USER_ID']").val('${S_USER_ID}');
					$('#user_id').val('${S_USER_ID}');
					$('#user_name').val('${S_USER_NAME}');
					$('#go').click();
					$('#user_password').focus();
				</c:when>
				<c:otherwise>
					$("input[name='S_USER_ID']").val('${S_USER_ID}');
					alert("로그인에 실패 하였습니다.");
				</c:otherwise>
			</c:choose>
		</c:if>

		$(".input_search").keypress(function(event){
         if($.ui.keyCode.ENTER === event.keyCode)
        	 $(".btn_search").click();
       });

		$(".btn_search").click(function(){
			js_login();
		});

		$('#btn_user_info_modify').click(function() {
			var $userPassword 			= $('#user_password'),
				$newUserPassword 		= $('#new_user_password'),
				$newUserPasswordConfirm = $('#new_user_password_confirm');

			if ($userPassword.val() === '') {
				alert('기존 비밀번호를 입력해주세요.');
				return;
			}
			else if ($newUserPassword.val() === '') {
				alert('신규 비밀번호를 입력해주세요.');
				$newUserPassword.focus();
				return;
			}
			else if ($newUserPasswordConfirm.val() === '') {
				alert('신규 비밀번호 확인을 입력해주세요.');
				$newUserPasswordConfirm.focus();
				return;
			}

			if (!isValidFormPassword($newUserPassword.val())) {
				return;
			}

			if ($newUserPassword.val() != $newUserPasswordConfirm.val()) {
				alert('신규 비밀번호가 잘못입력되었습니다.');
				$newUserPasswordConfirm.focus().val('');
				return;
			}

			var rsa = new RSAKey();
			rsa.setPublic("<%=RSACrypt.getModulusKey()%>", "<%=RSACrypt.getPublicKey()%>");
			rsaEncryptPassword(rsa, [$userPassword, $newUserPassword, $newUserPasswordConfirm]);

			var url 	= contextPath + '/admin/password/change.htm',
				param 	= {
					'S_USER_ID' 		: $('#user_id').val(),
					'S_USER_PWD' 		: $userPassword.val(),
					'S_USER_PWD_NEW' 	: $newUserPassword.val()
				};
			$.post(url, param)
				.done(function(data) {
					var resultCode = parseInt(data.RSLT);
					if (resultCode === 1) {
						alert('비밀번호가 변경되었습니다. \n변경된 비밀번호로 다시 로그인 해주세요.');
						$('#signup,#lean_overlay').fadeOut();
						$('#login_user_password').focus();
					}
					else if (resultCode === 0) {
						alert('기존 비밀번호가 잘못 입력되었습니다.');
						$userPassword.focus();
					}
					else if (resultCode === -1000) {
						alert('이전 비밀번호는 사용 할 수 없습니다.');
						$userPassword.focus();
					}
					else {
						alert('비밀번호 변경에 실패하였습니다. \n관리자에게 문의해주세요.');
						$userPassword.focus();
					}

					$userPassword.val('');
					$newUserPassword.val('');
					$newUserPasswordConfirm.val('');
				})
		})
	});

	function js_login() {
		var val_chk = true;
		$(".input_search").each(function(){
			if($(this).val() == "")
			{
				val_chk = false;
				return;
			}
		});

		if(!val_chk)
		{
			alert("아이디 또는 비밀번호가 입력되지 않았습니다.");
			return;
		}

		var rsa = new RSAKey();
		rsa.setPublic("<%=RSACrypt.getModulusKey()%>", "<%=RSACrypt.getPublicKey()%>");

		$("input[name='S_USER_PWD']").val(rsa.encrypt($("input[name='S_USER_PWD']").val()));

		frm.action = "<c:url value="main.htm"/>";
		frm.submit();
	}
</script>

</head>
<body>
<form name="frm" method="post">
<table width="100%" height="100%" >
  <tr>
    <td align="center" ><table width="100%" >
        <tr>
          <td height="624" bgcolor="132c4b"><table width="759" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr>
                <td colspan="2"><img src="<c:url value="/common/images/admin/login_top.png"/>"></td>
              </tr>
              <tr>
                <td><img src="<c:url value="/common/images/admin/login_lf.png"/>"></td>
                <td width="405" valign="top" background="<c:url value="/common/images/admin/login_rg.png"/>" style="padding:49px 0 0 92px">
                <!-- 로그인 정보 영역 start-->
                <table width="228" >
                    <tr>
                      <td>
                      	<input type="text" id="login_user_id" name="S_USER_ID" id="textfield" class="input_search" style="width:145px;height:27px;padding-top:5px;ime-mode:inactive;" value="">
                      </td>
                      <td rowspan="2" align="right"><img src="<c:url value="/common/images/admin/btn_login.jpg"/>" style="cursor:pointer;" width="76" height="59" class="btn_search"></td>
                    </tr>
                    <tr>
                      <td>
                      	<input id="login_user_password" name="S_USER_PWD" class="input_search" type="password" id="textfield2" style="width:145px;height:27px;padding-top:5px" value="">
                      </td>
                    </tr>
                  </table>
                  <!-- 로그인 정보 영역 end-->
                  </td>
              </tr>
              <tr>
                <td colspan="2"><img src="<c:url value="/common/images/admin/login_bt.png"/>"></td>
              </tr>
            </table></td>
        </tr>
      </table></td>
  </tr>
</table>
</form>

<a id="go" rel="leanModal" name="signup" href="#signup"></a>
<div id="signup" style="display:none;">
	<div id="signup-ct">
		<div id="signup-header">
			<h2>비밀번호 기간(3개월)이 만료되었습니다. </br>비밀번호를 변경해주세요.</h2>
			<a class="modal_close" href="#"></a>
		</div>

		<form id="frm_user_info_modify" name="frm_user_info_modify">

			<div class="txt-fld">
				<label for="user_id">사용자 ID</label>
				<input id="user_id" type="text" value="" disabled>
			</div>
			<div class="txt-fld">
				<label for="user_name">사용자 명</label>
				<input id="user_name" type="text" value="" disabled>
			</div>
			<div class="txt-fld">
				<label for="user_password">기존 비밀번호</label>
				<input id="user_password" name="S_USER_PWD" type="password">
			</div>
			<div class="txt-fld">
				<label for="new_user_password">신규 비밀번호</label>
				<input id="new_user_password" name="S_USER_PWD_NEW" type="password">
			</div>
			<div class="txt-fld">
				<label for="new_user_password_confirm">신규 비밀번호 확인</label>
				<input id="new_user_password_confirm" type="password">
			</div>
			<div class="btn-fld">
				<button id="btn_user_info_modify" type="button">변경</button>
			</div>
		</form>
	</div>
</div>

</body>
</html>

