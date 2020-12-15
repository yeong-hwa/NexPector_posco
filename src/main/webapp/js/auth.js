// Auth javascript

var rsaModulusKey = '';
var rsaPublicKey = '';

function setRsaModulusKey(str) {
    rsaModulusKey = str;
}

function setRsaPublicKey(str) {
    rsaPublicKey = str;
}

$(document).ready(function() {
    $('.change_password_input_search').keypress(function(event){
        if(event.keyCode == '13')
            $("#btn_user_info_modify").click();
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
        rsa.setPublic(rsaModulusKey, rsaPublicKey);
        rsaEncryptPassword(rsa, [$userPassword, $newUserPassword, $newUserPasswordConfirm]);

        var url 	= cst.contextPath() + '/admin/password/change.htm',
            param 	= {
                'S_USER_ID' 		: $('#user_id').val(),
                'S_USER_PWD' 		: $userPassword.val(),
                'S_USER_PWD_NEW' 	: $newUserPassword.val()
            };
        $.post(url, param)
            .done(function(data) {
                var resultCode = parseInt(data.RSLT);
                if (resultCode === 1) {
                    if ($('#login_user_password').length > 0) {
                        alert('비밀번호가 변경되었습니다. \n변경된 비밀번호로 다시 로그인 해주세요.');
                        $('#login_user_password').focus();
                    }
                    else {
                        alert('비밀번호가 변경되었습니다. \n변경된 비밀번호로 다시 로그인 해주세요.');
                        location.href = cst.contextPath() + '/watcher/logout.htm';
                    }
                    $('#signup,#lean_overlay').fadeOut();
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
            });
    });
});

function rsaEncryptPassword(rsa, $obj) {
    if ($.isArray($obj)) {
        var length = $obj.length;
        for (var i = 0; i < length; i++) {
            var obj = $obj[i];
            obj.val(rsa.encrypt(obj.val()));
        }
    }
    else {
        $obj.val(rsa.encrypt($obj.val()));
    }
}

// 비밀번호 유효성 확인
function isValidFormPassword(pw) {
    var check = /^(?=.*[a-zA-Z])(?=.*[0-9]).{6,20}$/;

    if (pw.length < 6 || pw.length > 20) {
        alert("비밀번호는 6 ~ 20 자리로 입력해주세요.");
        return false;
    }

    if (!check.test(pw))     {
        alert("비밀번호는 문자, 숫자의 조합으로 입력해주세요.");
        return false;
    }

    return true;
}