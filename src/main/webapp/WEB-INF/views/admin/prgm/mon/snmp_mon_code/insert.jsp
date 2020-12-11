<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="/WEB-INF/views/include/include.jsp" %>
<%
	//request.setCharacterEncoding("utf-8");
%>
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
		cfn_makecombo_opt($("#N_SNMP_MAN_CODE"), "<c:url value="/admin/lst_common.cmb_snmp_man_code.htm"/>");
	});
</script>
</c:if>
<c:if test="${param.UPD_FLAG == 'Y'}">
	<script>
	<!--
		<%--
			DB 데이터 불러오기
			UPDATE 모드일때 해당 키값의 상세 정보를 가져와 아래 컬럼명에 매칭시켜 배치 한다.
		--%>
		$(function(){
			$("form[name='frm'] input[name='N_SNMP_MON_CODE']").attr("readonly", true);
			var param = "${param.UPD_PARAM}";
			$.getJSON("<c:url value='/admin/map_${param.app_nm}.detail_info.htm'/>", param, function(data){
				$("form[name='frm'] input[type='text'], form[name='frm'] input[type='password']").each(function(){
					var tmp_input_name = $(this).attr("name");
					$("form[name='frm'] input[name='"+tmp_input_name+"']").val(eval("data."+tmp_input_name));
				});
				$("form[name='frm'] select").each(function(){
					var tmp_input_name = $(this).attr("name");
					$("form[name='frm'] select[name='"+tmp_input_name+"']").val(eval("data."+tmp_input_name));
				});

				$("form[name='frm'] input[name='N_SNMP_MAN_CODE']").val(eval("data.N_SNMP_MAN_CODE"));

			});
		});
	-->
	</script>
</c:if>

<script>
<%--
	UPDATE 모드일때 키값부분을 체크 class dupl_chk인것들
--%>
<c:if test="${param.UPD_FLAG != 'Y'}">
	$(function(){
		$(".dupl_chk").blur(function(){
			fn_duplication_chk(this);
		});
	});
</c:if>

	function fn_save()
	{
	<c:if test="${param.UPD_FLAG != 'Y'}">

      	if($("select[name=N_SNMP_MAN_CODE]").val()=="" || $("select[name=N_SNMP_MAN_CODE]").val()==null){
      		alert("SNMP 장비명을 선택하십시오.");
      		$('#N_SNMP_MAN_CODE').focus();
      		return;
      	}

    	if($('#N_SNMP_MON_CODE').val()=="" || $('#N_SNMP_MON_CODE').val()==null){
    		alert("SNMP 감시 상세코드를 입력하십시오.");
    		$('#N_SNMP_MON_CODE').focus();
    		return;
    	}

		fn_duplication_chk($(".dupl_chk"));
		if($("#msg").text() != "")
		{
			alert("중복되지 않은 ID를 지정하여 주십시오.");
			return;
		}

	</c:if>

		if($('#S_DESC').val()=="" || $('#S_DESC').val()==null){
			alert("SNMP 감시 상세코드 설명을 입력하십시오.");
			$('#S_DESC').focus();
			return;
		}

		if($('#N_TIMEM').val()=="" || $('#N_TIMEM').val()==null){
			alert("기본 수집주기를 입력하십시오.");
			$('#N_TIMEM').focus();
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
<!-- contents start -->
<table width="775" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td height="47" background="${img1}/sotitle_bg.jpg" class="b f14"><img src="${img1}/sotitle_icon.jpg" hspace="3" align="absmiddle">
    	SNMP 감시 상세코드 등록
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
            <td width="25%" height="29"class="line_gray table_bg pl10 text11 b">
            	SNMP 장비명
            </td>
            <td width="75%" class="line_gray pl10">
            	<select id="N_SNMP_MAN_CODE" name="N_SNMP_MAN_CODE" style="width:200px;">
            		<option value="">선택</option>
            	</select>
                <input type="hidden" name="chk_val" value="">
            </td>
          </tr>
          </c:if>

          <c:if test="${param.UPD_FLAG == 'Y'}">
          <tr>
            <td width="25%" height="29"class="line_gray table_bg pl10 text11 b">
            	SNMP 장비명
            </td>
            <td width="75%" class="line_gray pl10">
            	<input type="text" id="SNMP_MAN_NAME" name="SNMP_MAN_NAME" style="width:200px;" value="" readonly>
            	<input type="hidden" id="N_SNMP_MAN_CODE" name="N_SNMP_MAN_CODE" value="">
                <input type="hidden" name="chk_val" value="">
            	<font id="msg" color="red"></font>
            </td>
          </tr>
          </c:if>

          <tr>
            <td width="25%" height="29"class="line_gray table_bg pl10 text11 b">
            	SNMP 감시 상세코드
            </td>
            <td width="75%" class="line_gray pl10">
            	<input type="text" name="N_SNMP_MON_CODE" id="N_SNMP_MON_CODE" style="width:200px;" class="넌숫자만 chk_val dupl_chk" maxlength="8" value="">&nbsp;&nbsp;
            </td>
          </tr>
          <tr>
            <td width="25%" height="27" class="line_gray table_bg pl10 text11 b">
            	SNMP 감시 상세코드 설명
            </td>
            <td width="75%" class="line_gray pl10">
            	<input type="text" name="S_DESC" id="S_DESC" style="width:200px;" maxlength="50" value="">&nbsp;&nbsp;
            </td>
          </tr>
          <tr>
            <td width="25%" height="27" class="line_gray table_bg pl10 text11 b">
            	SNMP 기본 수집주기(분)
            </td>
            <td width="75%" class="line_gray pl10">
            	<input type="text" name="N_TIMEM" id="N_TIMEM" style="width:200px;" class="넌숫자만" maxlength="8" value="">&nbsp;&nbsp;
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
