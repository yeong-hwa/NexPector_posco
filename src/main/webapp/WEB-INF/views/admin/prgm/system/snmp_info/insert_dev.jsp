<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="/WEB-INF/views/include/include.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
</head>

<c:if test="${param.UPD_FLAG == 'Y'}">
<script>
	$(function(){
		var param = "${param.UPD_PARAM}";
		$.getJSON("<c:url value='/admin/map_${param.app_nm}.detail_info.htm'/>", param, function(data){
			$("form[name='frm'] input[type='text'], form[name='frm'] input[type='password']").each(function(){
				var tmp_input_name = $(this).attr("name");
				$("form[name='frm'] input[name='"+tmp_input_name+"']").val(eval("data."+tmp_input_name));
			});
			$("form[name='frm'] select[name='N_MON_ID']").val(data.N_MON_ID);
			$("form[name='frm'] select[name='N_SNMP_MAN_CODE']").val(data.N_SNMP_MAN_CODE);
			$("form[name='frm'] input[type='hidden']").each(function(){
				var tmp_input_name = $(this).attr("name");
				$("form[name='frm'] input[name='"+tmp_input_name+"']").val(eval("data."+tmp_input_name.replace("OLD_", "")));
			});
		});
	});
</script>
</c:if>

<script>
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
		fn_duplication_chk($(".dupl_chk"));
		if($("#msg").text() != "")
		{
			alert("중복되지 않은 ID를 지정하여 주십시오.");
		}
	</c:if>
	
	// IP 주소 체크 벨리데이션
	if(!verifyIP($('#S_SNMP_IP').val())) return;
	
	// 벨리데이션 체크
	if($("select[name=N_MON_ID]").val()=="" || $("select[name=N_MON_ID]").val()==null){
		alert("감시장비를 선택 하셔야함");
		$('select[name="N_MON_ID"]').focus();
		return;
	}
	
	if($("select[name=N_SNMP_MAN_CODE]").val()=="" || $("select[name=N_SNMP_MAN_CODE]").val()==null){
		alert("SNMP장비를 선택 하셔야함");
		$('select[name="N_SNMP_MAN_CODE"]').focus();
		return;
	}
	
	if($('#S_SNMP_IP').val()=="" || $('#S_SNMP_IP').val()==null){
		alert("SNMP IP를 입력 하셔야함");
		$('#S_SNMP_IP').focus();
		return;
	}
	
	if($('#N_SNMP_PORT').val()=="" || $('#N_SNMP_PORT').val()==null){
		alert("SNMP Port를 입력 하셔야함");
		$('#N_SNMP_PORT').focus();
		return;
	}
	
	if($('#S_SNMP_COMMUNITY').val()=="" || $('#S_SNMP_COMMUNITY').val()==null){
		alert("SNMP_COMMUNITY를 입력 하셔야함");
		$('#S_SNMP_COMMUNITY').focus();
		return;
	}
	
	if($('#N_SNMP_VERSION').val()=="" || $('#N_SNMP_VERSION').val()==null){
		alert("SNMP_VERSION를 입력 하셔야함");
		$('#N_SNMP_VERSION').focus();
		return;
	}
	
	
		var chk_flag = true;
		$(".chk_val").each(function(idx){
			if($(this).val() == "" || $(this).val() == null) {
				alert($(this).parent("td").parent("tr").children(".title_nm").text().trim() + " 이/가 입력되지 않았습니다.");
				chk_flag = false;
				return false;
			}
		});
		if(!chk_flag) return;
		
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
	
	// IP주소 벨리데이션 체크
	function verifyIP(IPvalue) {
		var errorString = "";
		var theName = "IPaddress";

		var ipPattern = /^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/;
		var ipArray = IPvalue.match(ipPattern);
		
		if (ipArray == null)
			errorString = "IP주소를 입력 하셔야함";
		else {
			for (i = 0; i < 5; i++) {
				thisSegment = ipArray[i];
				if (thisSegment > 255) {
					errorString = "유효한 IP 주소가 아닙니다";
					i = 4;
				}
			}
		}
		
		if (errorString == "") {
			return true;
		}
		else {
			alert(errorString);
			$('#S_ICMP_IP').focus();
			return false;
		}
	}
	
	function fn_cancel()
	{
		frm_page.action="${param.app_url}.retrieve.htm";
		frm_page.submit();
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

<!-- 저장 정보 페이지 시작 -->
<form name="frm" method="post">
<input type="hidden" name="OLD_N_MON_ID" value="${param.OLD_N_MON_ID}">
<input type="hidden" name="OLD_N_SNMP_MAN_CODE" value="${param.OLD_N_SNMP_MAN_CODE}">
<input type="hidden" name="OLD_S_SNMP_IP" value="${param.OLD_S_SNMP_IP}">
<table width="775" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td height="47" background="${img1}/sotitle_bg.jpg" class="b f14"><img src="${img1}/sotitle_icon.jpg" hspace="3" align="absmiddle">
    	SNMP 정보 관리 등록
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
            	감시장비
            </td>
            <td width="80%" class="line_bk_t line_gray text11 b pl10">
            	<cmb:combo qryname="svrComboQry2" seltagname="N_MON_ID" firstdata="선택" etc="class=\"dupl_chk\""/>
            	<input type="hidden" name="chk_val" value="">
            	<font id="msg" color="red"></font>
            	<input type="hidden" name="OLD_N_MON_ID" value=""/>
            </td>
          </tr>
          <tr>
            <td width="20%" height="29"class="line_gray table_bg pl10 text11 b">
            	SNMP장비
            </td>
            <td width="80%" class="line_gray pl10">
            	<cmb:combo qryname="cmb_snmp_man_code" seltagname="N_SNMP_MAN_CODE" firstdata="전체" etc="class=\"input_search\" style=\"width:80;\""/>
            </td>
          </tr>
          <tr>
            <td height="27" class="line_gray table_bg pl10 text11 b">
            	SNMP IP
            </td>
            <td class="line_gray pl10">
            	<input type="text" name="S_SNMP_IP" ID="S_SNMP_IP" class="넌한글안돼" style="width:150px;" value="" onchange="frm.chk_val.value='';fn_data_change();">
            </td>
          </tr>
          <tr>
            <td height="27" class="line_gray table_bg pl10 text11 b">
            	SNMP Port
            </td>
            <td class="line_gray pl10">
            	<input type="text" name="N_SNMP_PORT" ID="N_SNMP_PORT" class="넌숫자만" style="width:150px;" value="">
            </td>
          </tr>
          <tr>
            <td height="27" class="line_gray table_bg pl10 text11 b">
            	SNMP Community
            </td>
            <td class="line_gray pl10">
            	<input type="text" name="S_SNMP_COMMUNITY" ID="S_SNMP_COMMUNITY" style="width:150px;" value="">
            </td>
          </tr>
          <tr>
            <td height="27" class="line_gray table_bg pl10 text11 b">
            	SNMP Version
            </td>
            <td class="line_gray pl10">
            	<input type="text" name="N_SNMP_VERSION" ID="N_SNMP_VERSION" class="넌숫자만" style="width:150px;" value="">
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
