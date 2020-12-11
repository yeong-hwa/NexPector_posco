<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="/WEB-INF/views/include/include.jsp" %>

<script>
	$(function(){
		
	});
	
	function init(){
		window.focus();
		$("input[name='agt_id']").focus();
	}
	function fn_save()
	{
		if($("input[name='change_pwd']").val() != $("input[name='change_pwd_chk']").val())
		{
			alert("변경할 비밀번호가 일치 하지 않습니다.");
			return;
		}
		
		if(!cfn_empty_valchk(frm.agt_id,"사용자 ID") || !cfn_empty_valchk(frm.agt_pwd,"사용자 비밀번호") || !cfn_empty_valchk(frm.change_pwd,"변경할 비밀번호"))
			return;		
		
		var param = "";
		
		param += "S_USER_ID="+frm.agt_id.value+"&S_USER_PWD="+frm.agt_pwd.value+"&change_pwd="+frm.change_pwd.value;
		
		$.post("./change_password.htm", param, fn_result);
	}
	
	function fn_result(str)
	{
		if(str == "SUCC")
		{
			alert("비밀번호가 변경 되었습니다.");
			window.close();
		}
		else
		{
			if(str == "FAIL")
				alert("비밀번호 변경이 실패하였습니다.");
			else
				alert(str);
		}
	}
	
	function fn_cancel()
	{
		window.close();
	}
</script>
<body onload="init()">
<form method="post" name="frm">
	<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr> 
		  <td height="24" colspan="2" class="mt3_1"><img src="../images/title_img_s.gif" width="6" height="12"> 
			비밀번호 변경</td>
		</tr>
		<tr> 
		  <td height="2" colspan="2" bgcolor="#C8C8C8"></td>
		</tr>
		<tr> 
		  <td width="180" bgcolor="#EFEFEF" class="mt6">변경할 사용자 ID</td>
		  <td width="220" class="mt7">
			<input type="text" name="agt_id" style="width:130px;" maxlength="20" value="${param.agt_id}"> 
		  </td>
		</tr>
		<tr> 
		  <td height="1" colspan="2" bgcolor="#C8C8C8"></td>
		</tr>
		<tr> 
		  <td width="180" bgcolor="#EFEFEF" class="mt6">현재 비밀번호</td>
		  <td width="220" class="mt7">
			<input type="password" name="agt_pwd" style="width:130px;" maxlength="20" value="${param.agt_pwd}"> 
		  </td>
		</tr>
		<tr> 
		  <td height="1" colspan="2" bgcolor="#C8C8C8"></td>
		</tr>
		<tr> 
		  <td bgcolor="#EFEFEF" class="mt6">변경할 비밀번호</td>
		  <td width="220" class="mt7">
			<input type="password" name="change_pwd" style="width:130px;" maxlength="20">
		  </td>
		</tr>
		<tr> 
		  <td bgcolor="#EFEFEF" class="mt6">변경할 비밀번호 확인</td>
		  <td width="220" class="mt7">
			<input type="password" name="change_pwd_chk" style="width:130px;" maxlength="20">
		  </td>
		</tr>
		<tr> 
		  <td height="1" colspan="2" bgcolor="#C8C8C8"></td>
		</tr>
		<tr>
			<td align="center" colspan="2">
				<input type="button" value="저장" onclick="fn_save()">
				<input type="button" value="취소" onclick="fn_cancel()">
			</td>
		</tr>
	  </table>
</form>
</body>