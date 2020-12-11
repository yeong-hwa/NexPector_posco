<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="/WEB-INF/views/include/include.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
</head>

<c:if test="${param.UPD_FLAG != 'Y'}">
<script>
  $(function(){
    cfn_makecombo_opt($("#N_MON_ID"), "<c:url value="/admin/lst_common.svrComboQry2.htm"/>");
  });
</script>
</c:if>

<c:if test="${param.UPD_FLAG == 'Y'}">
<script>

	$(function(){
		// var param = "${param.UPD_PARAM}";
		var param = $("form[name='frm']").serialize();
		$.getJSON("<c:url value='/admin/map_${param.app_nm}.detail_info.htm'/>", param, function(data){
			$("form[name='frm'] input[type='text'], form[name='frm'] input[type='password']").each(function(){
				var tmp_input_name = $(this).attr("name");
				$("form[name='frm'] input[name='"+tmp_input_name+"']").val(eval("data."+tmp_input_name));
			});
			$("form[name='frm'] input[name='N_MON_ID']").val(data.N_MON_ID);

		});
	});
</script>
</c:if>

<script>

$(function(){
	$(".dupl_chk").blur(function(){

		<c:if test="${param.UPD_FLAG != 'Y'}">
    	if($("select[name=N_MON_ID]").val()=="" || $("select[name=N_MON_ID]").val()==null){
    		return;
    	}
    	</c:if>

    	if($('#S_USER_NAME').val()=="" || $('#S_USER_NAME').val()==null){
    		return;
    	}

    	if($('#S_USER_PHONE').val()=="" || $('#S_USER_PHONE').val()==null){
    		return;
    	}

		fn_duplication_chk(this);
	});
});

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

	function fn_save()
	{

    	<c:if test="${param.UPD_FLAG != 'Y'}">

        	if($("select[name=N_MON_ID]").val()=="" || $("select[name=N_MON_ID]").val()==null){
        		alert("감시장비를 선택하십시오.");
        		$('#N_MON_ID').focus();
        		return;
        	}

    	</c:if>


    	if($('#S_USER_NAME').val()=="" || $('#S_USER_NAME').val()==null){
    		alert("담당자 명을 입력하십시오.");
    		$('#S_USER_NAME').focus();
    		return;
    	}

    	if($('#S_USER_PHONE').val()=="" || $('#S_USER_PHONE').val()==null){
    		alert("담당자 연락처를 입력하십시오.");
    		$('#S_USER_PHONE').focus();
    		return;
    	}

		if($("#msg").text() != "")
		{
			alert("중복되지 않은 ID를 지정하여 주십시오.");
			return;
		}

	var url = ('${param.UPD_FLAG}' != 'Y')?"<c:url value='/admin/ins_${param.app_nm}.insert_data.htm'/>":"<c:url value='/admin/upd_${param.app_nm}.update_data.htm'/>";

	var param = $("form[name='frm']").serialize();
	$.post(url, param, function(str){
		var data = $.parseJSON(str);
		if(data.RSLT != null && data.RSLT > 0) {
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
		frm_page.action="${param.app_url}.retrieve.htm";
		frm_page.submit();
	}

	// 삭제
	function fn_delete()
	{
		if(!confirm("정말 삭제 하시겠습니까?"))
			return;

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

<!-- 이전페이지 정보 저장 -->
<form name="frm_page" method="post">
<input type="hidden" name="nowpage" value="${param.nowpage}">
<%
	java.util.Enumeration en = request.getParameterNames();

	while(en.hasMoreElements())
	{
		String name = (String)en.nextElement();
		if(name.equals("pageno")||name.equals("pagecnt")||name.equals("url")||name.equals("nowpage")||name.equals("page_totalcnt")||name.equals("max_pageNo"))
			continue;
		out.print("<input type=\"hidden\" name=\""+name+"\" value=\""+request.getParameter(name)+"\">\n");
	}
%>
</form>

<form name="frm" method="post">
<input type="hidden" name="OLD_N_MON_ID" value="${param.N_MON_ID}">
<input type="hidden" name="OLD_S_USER_NAME" value="${param.S_USER_NAME}">
<input type="hidden" name="OLD_S_USER_PHONE" value="${param.S_USER_PHONE}">

<!-- contents start -->
<table width="775" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td height="47" background="${img1}/sotitle_bg.jpg" class="b f14"><img src="${img1}/sotitle_icon.jpg" hspace="3" align="absmiddle">
    	VoiceGateway 담당자 등록
    </td>
  </tr>
  <tr>
    <td height="15"></td>
  </tr>
  <tr>
    <td><!-- 표 start -->
        <table width="100%" border="0" cellspacing="0" cellpadding="0">

         <c:if test="${param.UPD_FLAG != 'Y'}">
          <tr>
            <td width="25%" height="29" class="line_gray table_bg pl10 text11 b">
              감시장비
            </td>
            <td width="75%" class="line_gray pl10">
              <select id="N_MON_ID" name="N_MON_ID" style="width:200px;" class="dupl_chk">
                <option value="">선택</option>
              </select>&nbsp;&nbsp;
            </td>
          </tr>
          </c:if>

          <c:if test="${param.UPD_FLAG == 'Y'}">
          <tr>
            <td width="25%" height="29" class="line_gray table_bg pl10 text11 b">
              감시장비
            </td>
            <td width="75%" class="line_gray pl10">
              <input type="text" id="S_MON_NAME" name="S_MON_NAME" style="width:200px;" readonly>
              <input type="hidden" id="N_MON_ID" name="N_MON_ID" >
            </td>
          </tr>
          </c:if>

          <tr>
            <td width="25%" height="27"class="line_gray table_bg pl10 text11 b">
            	담당자 명
            </td>
            <td width="75%" class="line_gray pl10">
            	<input type="text" name="S_USER_NAME" id="S_USER_NAME" style="width:200px;" value="" class="dupl_chk" >&nbsp;&nbsp;
            </td>
          </tr>
          <tr>
            <td width="25%" height="27" class="line_gray table_bg pl10 text11 b">
            	담당자 연락처
            </td>
            <td width="75%" class="line_gray pl10">
            	<input type="text" name="S_USER_PHONE" id="S_USER_PHONE" style="width:200px;" value="" class="dupl_chk" >&nbsp;&nbsp;
            </td>
          </tr>
          <tr>
            <td colspan="2" bgcolor="3b3b3b"><img src="${img1}/dot.png"></td>
          </tr>
          <tr>
            <td height="60" colspan="2" align="center">

              <table width="100%">
                <tr>
                    <td width="80%" align="center">
                      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
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
