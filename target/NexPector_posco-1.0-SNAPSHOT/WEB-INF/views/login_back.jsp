<%@ page import="com.nns.common.util.RSACrypt" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<%
	session.invalidate();
%>

<!-- BEGIN: Main -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<Html>
<Head>
	<title>::: NexPecter Manager :::</title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">

	<link rel="stylesheet" href="<c:url value='/common/login/css/default.css' />"/>
	<link rel="stylesheet" href="<c:url value='/common/login/css/font.css' />"/>
	<link rel="stylesheet" href="<c:url value='/common/login/css/layout.css' />"/>
	<link rel="stylesheet" href="<c:url value="/css/sign.css" />" />
	
	<script type="text/javascript" src="<c:url value="/js/global-variables.js" />"></script>
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
		var contextPath = '${ctx}';
		createConstants('${ctx}');
		
		setRsaModulusKey("<%=RSACrypt.getModulusKey()%>");
		setRsaPublicKey("<%=RSACrypt.getPublicKey()%>");

		$(document).ready(function() {
			var userInputId = getCookie("userInputId");
		    $("input[name='S_USER_ID']").val(userInputId); 
		     
		    if($("input[name='S_USER_ID']").val() != ""){ // 그 전에 ID를 저장해서 처음 페이지 로딩 시, 입력 칸에 저장된 ID가 표시된 상태라면,
		        $("#idSaveCheck").attr("checked", true); // ID 저장하기를 체크 상태로 두기.
		    }
			
			$('a[rel*=leanModal]').leanModal({ top : 200, closeButton: ".modal_close" });

			$('#login_user_id').focus();

			check_login_result();

			$(".input_search").keypress(function(event){
				if($.ui.keyCode.ENTER === event.keyCode)
					$(".btn_search").click();
			});

			$(".btn_search").click(function(){
		        if($("#idSaveCheck").is(":checked")){ // ID 저장하기 체크했을 때,
		            var userInputId = $("input[name='S_USER_ID']").val();
		            setCookie("userInputId", userInputId, 7); // 7일 동안 쿠키 보관
		        }else{ // ID 저장하기 체크 해제 시,
		        	deleteCookie("userInputId");
		        }

		        js_login();
				
			});
		});

		function js_login() {
			var val_chk = true;
			$(".input_search").each(function(){
				if(this.value == "") {
					val_chk = false;
					return;
				}
			});

			if(!val_chk) {
				alert("아이디 또는 비밀번호가 입력되지 않았습니다.");
				return;
			}

			var rsa = new RSAKey();
			rsa.setPublic("<%=RSACrypt.getModulusKey()%>", "<%=RSACrypt.getPublicKey()%>");

			$("input[name='S_USER_PWD']").val(rsa.encrypt($("input[name='S_USER_PWD']").val()));

			$('#frm').attr('action', contextPath + '/watcher/main.htm').submit();
		}

		function check_login_result() {
			var loginResult = '${LOGIN_RESULT}';
			if (loginResult) {
				var code = parseInt(loginResult);
				var FAIL			= -1,
					NOT_ID 			= 101,
					ID_ROCK 		= 102,
					PERIOD_EXCESS	= 103,
					LONGTIME_LOGIN	= 105;
					NOT_ALLOWED_IP	= 106;
				switch (code) {
					case FAIL :
						alert('로그인에 실패하였습니다.');
						$("input[name='S_USER_ID']").val('${S_USER_ID}');
						break;
					case NOT_ID :
						alert('아이디/비밀번호를 확인해주세요.');
						$("input[name='S_USER_ID']").val('${S_USER_ID}');
						$('#login_user_password').focus();
						break;
					case ID_ROCK :
						alert('계정이 잠긴 상태 입니다.\n담당자에게 문의 하여 주십시오.');
						$("input[name='S_USER_ID']").val('${S_USER_ID}');
						break;
					case PERIOD_EXCESS :
						alert('비밀번호 사용 기간이 초과 되었습니다.\n비밀번호를 변경하여 주십시오.');
						$("input[name='S_USER_ID']").val('${S_USER_ID}');
						$('#user_id').val('${S_USER_ID}');
						$('#user_name').val('${S_USER_NAME}');
						$('#go').click();
						$('#user_password').focus();
						break;
					case LONGTIME_LOGIN :
						alert('한 달 이상 로그인되지 않아 계정이 잠겼습니다.\n비밀번호를 변경하여 주십시오.');
						$("input[name='S_USER_ID']").val('${S_USER_ID}');
						$('#user_id').val('${S_USER_ID}');
						$('#user_name').val('${S_USER_NAME}');
						$('#go').click();
						$('#user_password').focus();
						break;
					case NOT_ALLOWED_IP :
						alert('계정에 허용된 IP주소가 아닙니다.');
						break;
					default :
						break;
				}
			}
		}
		
		function setCookie(cookieName, value, exdays){
			deleteCookie(cookieName);
		    var exdate = new Date();
		    exdate.setDate(exdate.getDate() + exdays);
		    var cookieValue = escape(value) + ((exdays==null) ? "" : "; expires=" + exdate.toGMTString() + "; path=/;");
		    document.cookie = cookieName + "=" + cookieValue;
		}
		 
		function deleteCookie(cookieName){
		    var expireDate = new Date();
		    expireDate.setDate(expireDate.getDate() - 1);
		    document.cookie = cookieName + "= " + "; expires=" + expireDate.toGMTString();
		}
		 
		function getCookie(cookieName) {
		    cookieName = cookieName + '=';
		    var cookieData = document.cookie;
		    var start = cookieData.indexOf(cookieName);
		    var cookieValue = '';
		    if(start != -1){
		        start += cookieName.length;
		        var end = cookieData.indexOf(';', start);
		        if(end == -1)end = cookieData.length;
		        cookieValue = cookieData.substring(start, end);
		    }
		    return unescape(cookieValue);
		}
		
	</script>
</head>
<body>
<form id="frm" name="frm" method="post">
	<div class="login-container">
		<div class="login_wrapper">
			<div class="wrap_login">
				<div class="login_logo">
	            	<img src="<c:url value='/common/images/watcher/login_top.png'/>" alt="" />
	        	</div>
	        	<div class="login_form">
	            	<div class="item">
						아이디<input id="login_user_id" name="S_USER_ID" class="i_text input_search" title="레이블 텍스트" type="text" style="width:145px; height:24px; margin-left:17px;" />
	                </div>
		            <div class="item" style="margin-top:5px;">
						비밀번호<input id="login_user_password" name="S_USER_PWD" class="i_text input_search" title="레이블 텍스트" type="password" style="width:145px; height:24px;margin-left:5px;" />
		            </div>
		            <div class="item" style="margin-top:12px; padding-left:57px;">
						<input id="idSaveCheck" class="i_check" type="checkbox" />
						<label for="a1">아이디 저장</label>
					</div>
				</div> 
				<div class="login_form_btn01">
					<a href="#"><img src="<c:url value='/common/images/watcher/btn_login.jpg'/>" class="btn_search" alt="로그인" /></a>
				</div>
				<div class="login_txt2">
					<img src="<c:url value='/common/images/watcher/login_icon02.png'/>" alt="." style="vertical-align:middle;" /> 계정 정보를 잊으신 경우에는 관리자에게 문의하여 주십시오.
				</div>
			</div>
	       
	       <!--footer-->  
	        <div class="login_footer">
	        	Copyright(c) <strong>POSCO</strong> All right Reserved.
	        </div>
	    </div>       
	</div>
</form>

<a id="go" rel="leanModal" name="signup" href="#signup">
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
			<%--<div class="txt-fld">
				<label for="user_name">사용자 명</label>
				<input id="user_name" type="text" value="" disabled>
			</div>--%>
			<div class="txt-fld">
				<label for="user_password">기존 비밀번호</label>
				<input id="user_password" name="S_USER_PWD" type="password" class="change_password_input_search">
			</div>
			<div class="txt-fld">
				<label for="new_user_password">신규 비밀번호</label>
				<input id="new_user_password" name="S_USER_PWD_NEW" type="password" class="change_password_input_search">
			</div>
			<div class="txt-fld">
				<label for="new_user_password_confirm">신규 비밀번호 확인</label>
				<input id="new_user_password_confirm" type="password" class="change_password_input_search">
			</div>
			<div class="btn-fld">
				<button id="btn_user_info_modify" type="button">변경</button>
			</div>
		</form>
	</div>
</div>
</a>
</body>
</html>

