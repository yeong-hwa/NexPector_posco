<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="/WEB-INF/views/include/include.jsp" %>

<jsp:useBean id="data" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="cmb_equip_grp" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="cmb_equip_typ" class="java.util.ArrayList" scope="request"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Voice Analog 정보 Excel 등록</title>
</head>

<script>
$(function(){
	<c:if test="${RSLT != ''}">
	 	if("${RSLT}" == "-1001")
	 	{
	 		alert("엑셀 파일 형식이 아닙니다.(xls 또는 xlsx)");
	 	}
	 	else if("${RSLT}" > 0)
	 	{
	 		alert("${RSLT}건 등록 되었습니다.");
	 	}
	</c:if>
});
	function fn_upload()
	{
		//frm.target = "ifm_list";
		frm.action="<c:url value='/watcher/server_detail/vaif_reg_excel.htm'/>";
		frm.submit();
		
		//var param = $("form").serialize();
		
		/*$.post("server_detail.read_excel.neonex", param, function(data){
			alert(data);
		});*/
		
		/*alert($("#file_nm").attr('files'));
		$.ajax({
			url : "server_detail.read_excel.neonex"
			, type : "POST"
			, contentType: "multipart/form-data"
			, processData: false
			, cache: false
			, data : $("#file_nm").attr('files')
			, success : function(data){
				alert(data);
			}
		});*/
	}
	
	function init()
	{
		window.focus();
	}

</script>
<body onload="init()">
<form name="frm" method="post" enctype="multipart/form-data">
<input type="hidden" name="N_MON_ID" value="${param.N_MON_ID}">
<table width="775" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td height="47" background="${img2}/sotitle_bg.jpg" class="b f14"><img src="${img2}/sotitle_icon.jpg" hspace="3" align="absmiddle">
    	Voice Analog 정보 Excel 등록
    </td>
  </tr>
  <tr>
    <td height="15"></td>
  </tr>
  <tr>
  	<td>
		<table width="100%" height="100%">
			<tr>
				<td width="100%">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>					
							<td height="29" width="20%" class="b gray pl10"><img src="${img2}/icon_arrow.png" align="absmiddle">엑셀파일</td>
							<td>
		
									<input id="file_nm" type="file" style="width:350px;height:23px;" name="f_excel">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							</td>
							<td>
								<input type="button"  name="f_excel1" style="width:90px;height:23px;" value="엑셀등록" onclick="fn_upload()">
			
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td align="center">
					<font color="red"><b>엑셀2003 버전 xls 파일을 지원하며 양식은 아래 표와 같이 [장비ID/명칭/전화번호/${param.vg_kind=='VG224'?'사용자':'지점명'}]의 형식을 지원 합니다.</b></font>
					<table border="1" width="550">
						<tr bgcolor="#55CC66" align="center">
							<td>장비ID</td>
							<td>명칭</td>
							<td>전화번호</td>
							<td>${param.vg_kind=='VG224'?'사용자':'지점명'}</td>
						</tr>
						<tr>
							<td>10</td>
							<td>E1 0/0/0</td>
							<td>010-1234-5678</td>
							<td>테스트</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>

	</td>
</tr>
</table>
</form>
</body>
</html>
