<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="/WEB-INF/views/include/include.jsp" %>

<jsp:useBean id="data" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="cmb_svr_group" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="cmb_svr_type" class="java.util.ArrayList" scope="request"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
</head>
<%
	String action_file = "rating_mgr";
%>

<c:if test="${param.UPD_FLAG == 'Y'}">
	<script>
		$(function(){
			$("form[name='frm'] input[name='S_USER_ID']").attr("readonly", true);
			var param = "${param.UPD_PARAM}";
			$.getJSON("<c:url value='/admin/map_${param.app_nm}.detail_info.htm'/>", param, function(data){
				$("form[name='frm'] input[type='text'], form[name='frm'] input[type='password']").each(function(){
					var tmp_input_name = $(this).attr("name");
					$("form[name='frm'] input[name='"+tmp_input_name+"']").val(eval("data."+tmp_input_name));
				});
			});
		});
	</script>
</c:if>

<script>

	function fn_validation_chk()
	{
		if(!cfn_empty_valchk(frm.N_RAT_CODE, "등급코드") || !cfn_empty_valchk(frm.S_RAT_NAME, "등급명")) {
			return false;
		}

		if(frm.chk_val.value != "1")
		{
			alert("중복되지 않은 코드를 지정 하여주십시오.");
			return false;
		}

		return true;
	}

	function fn_save()
	{
		// 벨리데이션 체크
		if($('#N_RAT_CODE').val()=="" || $('#N_RAT_CODE').val()==null){
			alert("등급코드를 입력 하셔야함");
			$('#N_RAT_CODE').focus();
			return;
		}else if($('#S_RAT_NAME').val()=="" || $('#S_RAT_NAME').val()==null){
			alert("등급명을 입력 하셔야함");
			$('#S_RAT_NAME').focus();
			return;
		}

		var url = "<c:url value="/admin/reg_rating.htm"/>";

		var param = $("form[name='frm']").serialize();
		$.post(url, param, function(str){
			var data = $.parseJSON(str);
			if(data != null && data > 0) {
				alert('저장되었습니다.');
				fn_cancel();
				return;
			}
			else {
				alert("저장 실패 하였습니다.\n" + data.ERRMSG + "");
				fn_cancel();
				return;
			}
		});
	}

	function fn_cancel()
	{
		location.href = "<c:url value="/admin/go_prgm.user.rating.retrieve.htm"/>";
	}

	<c:if test="${param.UPD_FLAG != 'Y'}">
	$(function(){
		$(".dupl_chk").blur(function(){
			fn_duplication_chk(this);
		});
	});
	</c:if>

	function fn_duplication_chk(obj)
	{
		var param = $("form[name='frm']").serialize();
		$.getJSON("<c:url value='map_${param.app_nm}.dul_chk.htm'/>", param, function(data){
			if(data.CNT > 0) {
				$("#msg").remove();
				$("<span/>", {
					'id':"msg"
					, html:"중복된 ID 입니다."
					, style:"color:red;"
				}).appendTo($(obj).parent("td"));
			}
			else {
				$("#msg").remove();
			}
		});
	}

	// 삭제
	function fn_delete() {
		if(!confirm("정말 삭제 하시겠습니까?")) {
			return;
		}
		var url = "<c:url value='/admin/del_${param.app_nm}.delete_data.htm'/>";

		var param = $("form[name='frm']").serialize();
		$.post(url, param, function(str){
			var data = $.parseJSON(str);
			if(data.RSLT != null && data.RSLT > 0) {
				alert('삭제되었습니다.');
				fn_cancel();
				return;
			}
			else {
				alert("삭제 실패 하였습니다.\n" + data.ERRMSG + "");
				fn_cancel();
				return;
			}
		});
	}

</script>
<body>
<form name="frm" method="post">
<%
	//request.getParameterNames();
	java.util.Enumeration en = request.getParameterNames();

	while(en.hasMoreElements())
	{
		String name = (String)en.nextElement();
		if(name.equals("nowpage"))
			out.print("<input type=\"hidden\" name=\""+name+"\" value=\""+request.getParameter(name)+"\">\n");
	}
%>
<!-- contents start -->
<table width="775" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td height="47" background="${img1}/sotitle_bg.jpg" class="b f14"><img src="${img1}/sotitle_icon.jpg" hspace="3" align="absmiddle">
    	등급코드 등록
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
            	등급코드
            </td>
            <td width="80%" class="line_bk_t line_gray text11 b pl10">
                <c:if test="${param.UPD_FLAG == 'Y'}">
            	  <input type="text" name="N_RAT_CODE" id="N_RAT_CODE" class="넌숫자만 chk_val dupl_chk" style="width:150px;" readonly>&nbsp;&nbsp;
                </c:if>
                <c:if test="${param.UPD_FLAG != 'Y'}">
                  <input type="text" name="N_RAT_CODE" id="N_RAT_CODE" class="넌숫자만 chk_val dupl_chk" style="width:150px;" >&nbsp;&nbsp;
                </c:if>
            	<input type="hidden" name="chk_val" value="">
            	<font id="msg" color="red"></font>
            </td>
          </tr>
          <tr>
            <td height="27" class="line_gray table_bg pl10 text11 b">
            	등급명
            </td>
            <td class="line_gray pl10">
            	<input type="text" name="S_RAT_NAME" id="S_RAT_NAME" style="width:150px;" value="">
            </td>
          </tr>
          <tr>
            <td colspan="2" bgcolor="3b3b3b"><img src="${img1}/dot.png"></td>
          </tr>
          <tr>
            <table width="100%">
              <tr>
                <td width="80%" height="60" align="center">
                  <input style="width:70px; height:23px;" onClick="fn_save()" type="button" value="저장"/>
                  &nbsp;
                  <input style="width:70px; height:23px;" onClick="fn_cancel()" type="button" value="취소"/>
                </td>
                <c:if test="${param.UPD_FLAG == 'Y'}">
                <td align="right">
                  <input style="width:70px; height:23px;" onClick="fn_delete()" type="button" value="삭제"/>
                </td>
                </c:if>
              </tr>
            </table>
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
