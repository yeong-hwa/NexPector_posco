<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="/WEB-INF/views/include/include.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
</head>

<script>
	$(function(){
		if("${RSLT}" == "1")
		{
			alert("저장되었습니다.");
			fn_cancel();
		}
		
		cfn_makecombo_opt($("#N_GROUP_CODE"), "<c:url value="/admin/lst_common.cmb_svr_group.htm"/>");
	});
	function fn_validation_chk()
	{	
		if(!cfn_empty_valchk(frm.S_IMAGE_URL, "이미지 경로")) {
			return false;
		}
		
		return true;
	}

	function fn_save()
	{
		// 벨리데이션 체크
		if($("select[name=N_GROUP_CODE]").val()=="" || $("select[name=N_GROUP_CODE]").val()==null){
			alert("서버그룹코드를 선택 하셔야함");
			$('select[name="N_GROUP_CODE"]').focus();
			return;
		}
		
		if($('#S_IMAGE_NAME').val()=="" || $('#S_IMAGE_NAME').val()==null){
			alert("이미지명을 입력 하셔야함");
			$('#S_IMAGE_NAME').focus();
			return;
		}
		
		if(!fn_validation_chk())
			return;
		
		frm.action="<c:url value="/admin/system_svr_group_img_change.htm"/>";
		frm.submit();
	}
	
	function fn_cancel()
	{
		location.href = "<c:url value="/admin/go_prgm.system.svr_group_img.retrieve.htm"/>";
	}
		
</script>
<body>
<form name="frm" method="post" enctype="multipart/form-data">

<!-- contents start -->
<table width="775" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td height="47" background="${img1}}/sotitle_bg.jpg" class="b f14"><img src="${img1}/sotitle_icon.jpg" hspace="3" align="absmiddle">
    	서버 그룹 이미지 등록
    </td>
  </tr>
  <tr>
    <td height="15"></td>
  </tr>
  <tr>
    <td><!-- 표 start -->
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="20%" height="29"class="table_title text11 b pl10">
            	서버그룹코드
            </td>
            <td width="80%" class="line_bk_t line_gray text11 b pl10">
            	<select id="N_GROUP_CODE" name="N_GROUP_CODE">
            		<option value="-1">전체</option>
            	</select>
            </td>
          </tr>
          <tr>
            <td height="27" class="line_gray table_bg pl10 text11 b">
            	이미지명
            </td>
            <td class="line_gray pl10">
            	<input type="text" name="S_IMAGE_NAME" id="S_IMAGE_NAME" style="width:150px;" maxlength="50" value="">
            </td>
          </tr>
          <tr>
            <td height="27" class="line_gray table_bg pl10 text11 b">
            	이미지 파일 선택
            </td>
            <td class="line_gray pl10">
            	<input type="file" name="S_IMAGE_URL" style="width:250px;" value="">
            </td>
          </tr>          
          <tr>
            <td colspan="2" bgcolor="3b3b3b"><img src="${img1}/dot.png"></td>
          </tr>
          <tr>
            <td height="60" colspan="2" align="center">
            	<input style="width:70px; height:23px;" onClick="fn_save()" type="button" value="저장"/>
              &nbsp;
              	<input style="width:70px; height:23px;" onClick="fn_cancel()" type="button" value="취소"/>
            </td>
          </tr>
        </table>
      <!-- 표 end -->
    </td>
  </tr>
</table>
<!-- contents end -->
	</form>	
</body>
</html>

