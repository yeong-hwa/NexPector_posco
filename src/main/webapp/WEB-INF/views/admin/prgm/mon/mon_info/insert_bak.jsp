<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="/WEB-INF/views/include/include.jsp" %>
<%
	//request.setCharacterEncoding("utf-8");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<title>Insert title here</title>
</head>
<script>
	$(function(){
		cfn_makecombo_opt($("#N_GROUP_CODE"), "<c:url value="/admin/lst_common.cmb_svr_group.htm"/>");
		cfn_makecombo_opt($("#N_TYPE_CODE"), "<c:url value="/admin/lst_common.cmb_svr_type.htm"/>");
	});
</script>
<c:if test="${param.UPD_FLAG == 'Y'}">
	<script>
		$(function(){
			$("form[name='frm'] input[name='N_MON_ID']").attr("readonly", true);
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

				// 상세 페이지 검색후  감시종류 selected
				if(data.N_TYPE_CODE==1000){
					$("select[name='S_CM_TYPE']").val("");
					$("#cmb_cm_type").show();
					$("select[name='S_CM_TYPE']").val(data.S_CM_TYPE);
				}

				// 상세 페이지 검색후 감시타입 selected
				if(data.N_STYLE_CODE==1 || data.N_STYLE_CODE==2){
					fn_svr_style_change(data.N_STYLE_CODE);
				}

			});
		});
	</script>
</c:if>

<script>
<c:if test="${param.UPD_FLAG != 'Y'}">
	$(function(){
		$(".dupl_chk").blur(function(){
			fn_duplication_chk(this);
		});
	});
</c:if>

	function fn_save()
	{
		var gsel = $("#select[name=N_GROUP_CODE]").val();

		// 벨리데이션 체크
		if($('#N_MON_ID').val()=="" || $('#N_MON_ID').val()==null){
			alert("장비 ID를 입력 하셔야함");
			$('#N_MON_ID').focus();
			return;
		}
		if($('#S_MON_NAME').val()=="" || $('#S_MON_NAME').val()==null){
			alert("장비명을 입력 하셔야함");
			$('#S_MON_NAME').focus();
			return;
		}

		if($('#S_MON_IP').val()=="" || $('#S_MON_IP').val()==null){
			alert("장비IP를 입력 하셔야함");
			$('#S_MON_IP').focus();
			return;
		}
		// IP 주소 체크 벨리데이션
		if(!verifyIP($('#S_MON_IP').val())) return;

		if($("select[name=N_GROUP_CODE]").val()=="" || $("select[name=N_GROUP_CODE]").val()==null){
			alert("그룹명을 선택 하셔야함");
			$('#N_GROUP_CODE').focus();
			return;
		}

		if($("select[name=N_TYPE_CODE]").val()=="" || $("select[name=N_TYPE_CODE]").val()==null){
			alert("감시종류를 선택 하셔야함");
			$('#N_TYPE_CODE').focus();
			return;
		}

		if($("select[name=N_TYPE_CODE]").val()=="1000"){
			if($("select[name=S_CM_TYPE]").val()=="" || $("select[name=S_CM_TYPE]").val()==null ){
				alert("감시종류 기타를 선택 하셔야함");
				$('#S_CM_TYPE').focus();
				return;
			}
		}

		if($("select[name=N_STYLE_CODE]").val()=="" || $("select[name=N_STYLE_CODE]").val()==null){
			alert("감시타입 선택 하셔야함");
			$('#N_STYLE_CODE').focus();
			return;
		}

		// ICMP 일경우
		if($("select[name=N_STYLE_CODE]").val()=="1"){
			//S_ICMP_NAME
			if($('#S_ICMP_NAME').val()=="" || $('#S_ICMP_NAME').val()==null){
				alert("ICMP 명칭을 입력 하셔야함");
				$('#S_ICMP_NAME').focus();
				return;
			}

			if($('#N_CHECK_TIME').val()=="" || $('#N_CHECK_TIME').val()==null){
				alert("체크주기(초)를 입력 하셔야함");
				$('#N_CHECK_TIME').focus();
				return;
			}

			if($('#N_RES_TIME').val()=="" || $('#N_RES_TIME').val()==null){
				alert("응답시간(ms)을 입력 하셔야함");
				$('#N_RES_TIME').focus();
				return;
			}

			if($('#N_TIME_OUT').val()=="" || $('#N_TIME_OUT').val()==null){
				alert("TimeOut(초)을 입력 하셔야함");
				$('#N_TIME_OUT').focus();
				return;
			}

			if($('#N_ALM_CNT').val()=="" || $('#N_ALM_CNT').val()==null){
				alert("장애인식카운트를 입력 하셔야함");
				$('#N_ALM_CNT').focus();
				return;
			}

			if($("select[name=N_ALM_RAT]").val()=="" || $("select[name=N_ALM_RAT]").val()==null){
				alert("장애등급을 선택 하셔야함");
				$('#N_ALM_RAT').focus();
				return;
			}
		}

		// SNMP일 경우
		if($("select[name=N_STYLE_CODE]").val()=="2"){

			if($("select[name=N_SNMP_MAN_CODE]").val()=="" || $("select[name=N_SNMP_MAN_CODE]").val()==null){
				alert("SNMP 장비를 선택 하셔야함");
				$('#N_SNMP_MAN_CODE').focus();
				return;
			}

			if($('#N_SNMP_PORT').val()=="" || $('#N_SNMP_PORT').val()==null){
				alert("SNMP Port를 입력 하셔야함");
				$('#N_SNMP_PORT').focus();
				return;
			}

			if($('#S_SNMP_COMMUNITY').val()=="" || $('#S_SNMP_COMMUNITY').val()==null){
				alert("SNMP Community를 입력 하셔야함");
				$('#S_SNMP_COMMUNITY').focus();
				return;
			}

			if($('#N_SNMP_VERSION').val()=="" || $('#N_SNMP_VERSION').val()==null){
				alert("N_SNMP_VERSION을 입력 하셔야함");
				$('#N_SNMP_VERSION').focus();
				return;
			}
		}

		<c:if test="${param.UPD_FLAG != 'Y'}">
			fn_duplication_chk($(".dupl_chk"));
			if($("#msg").text() != "")
			{
				alert("중복되지 않은 ID를 지정하여 주십시오.");
				return;
			}
		</c:if>

		var chk_flag = true;
		$(".chk_val").each(function(idx){
			if($(this).val() == "" || $(this).val() == null) {
				alert($(this).parent("td").parent("tr").children(".title_nm").text().trim() + " 이/가 입력되지 않았습니다.");
				chk_flag = false;
				return false;
			}
		});
		if(!chk_flag) return;

		var tmp_sms_no = "";

		$(".div_sms_no").each(function(idx){
			if(idx != 0) tmp_sms_no += ",";
			tmp_sms_no += $(this).children("input[name='S_SMS_NAME']").val() + ";" + $(this).children("input[name='S_SMS_NO']").val();
		});

		$("input[name='S_SMS_NO_LIST']").val(tmp_sms_no);


		var url = ('${param.UPD_FLAG}' != 'Y')?"<c:url value='/admin/insert_mon_info.htm'/>":"<c:url value='/admin/update_mon_info.htm'/>";

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

	function fn_svr_style_change(val)
	{
		if(val == "2")
		{
			$("#snmp_info").show("fast");
			$("#icmp_info").hide("fast");
		}
		else if(val == "1")
		{
			$("#icmp_info").show("fast");
			$("#snmp_info").hide("fast");
		}
		else
		{
			$("#snmp_info").hide("fast");
			$("#icmp_info").hide("fast");
		}
	}

	// IP주소 벨리데이션 체크
	function verifyIP(IPvalue) {
		var errorString = "";
		var theName = "IPaddress";

		var ipPattern = /^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/;
		var ipArray = IPvalue.match(ipPattern);

		if (ipArray == null)
			errorString = "IP 주소를 입력 하셔야함";
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
			$('#S_MON_IP').focus();
			return false;
		}
	}

	// 삭제
	function fn_delete()
	{
		if(!confirm("정말 삭제 하시겠습니까?"))
			return;

		var url = "<c:url value='/admin/delete_mon_info.htm'/>";

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
    	감시장비 등록
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
            	장비ID
            </td>
            <td width="80%" class="line_bk_t line_gray text11 b pl10">
            	<input type="text" name="N_MON_ID" id="N_MON_ID" class="넌숫자만 chk_val dupl_chk" style="width:150px;" maxlength="10">&nbsp;&nbsp;
            	<input type="hidden" name="chk_val" value="">
            	<font id="msg" color="red"></font>
            </td>
          </tr>

          <tr>
            <td height="27" class="line_gray table_bg pl10 text11 b">
            	장비명
            </td>
            <td class="line_gray pl10">
            	<input type="text" name="S_MON_NAME" id="S_MON_NAME" style="width:150px;" value="">
            </td>
          </tr>

          <tr>
            <td height="27" class="line_gray table_bg pl10 text11 b">
            	장비IP
            </td>
            <td class="line_gray pl10">
            	<input type="text" name="S_MON_IP" id="S_MON_IP" style="width:150px;" value=""maxlength="15">
            </td>
          </tr>
          <tr>
            <td height="27" class="line_gray table_bg pl10 text11 b">
            	그룹명
            </td>
            <td class="line_gray pl10">
            	<select id="N_GROUP_CODE" name="N_GROUP_CODE">
            		<option value="">선택</option>
            	</select>
           </td>
          </tr>
          <tr>
            <td height="27" class="line_gray table_bg pl10 text11 b">
            	감시종류
            </td>
            <td class="line_gray pl10">
            	<select id="N_TYPE_CODE" name="N_TYPE_CODE">
            		<option value="">선택</option>
            	</select>
            	<script>
            		$(function(){
            			$("select[name='N_TYPE_CODE']").change(function(){
            				if($("select[name='N_TYPE_CODE'] option:selected").val() == '1000')
            				{
            					$("select[name='S_CM_TYPE']").val("");
            					$("#cmb_cm_type").show();
            				}
            				else
            				{
            					$("select[name='S_CM_TYPE']").val("");
            					$("#cmb_cm_type").hide();
            				}
            			});

            		});
            	</script>
            	<span id="cmb_cm_type" style="display:none;">
            		<SELECT name="S_CM_TYPE" id="S_CM_TYPE">
            			<option value="">선택</option>
            			<option value="Call서버">Call서버</option>
            			<option value="기타">기타</option>
            		</SELECT>
            	</span>
            </td>
          </tr>
          <tr>
            <td height="27" class="line_gray table_bg pl10 text11 b">
            	감시타입
            </td>
            <td class="line_gray pl10">
				<cmb:combo qryname="cmb_svr_style" seltagname="N_STYLE_CODE" firstdata="선택" etc="onchange=\"fn_svr_style_change(this.value);\""/>
            </td>
          </tr>
          <tr>
            <td colspan="2" bgcolor="3b3b3b"><img src="${img1}/dot.png"></td>
          </tr>
        </table>
      <div id="snmp_info" style="display: none;">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="20%" height="29"class="line_gray table_bg pl10 text11 b">
            	SNMP장비
            </td>
            <td width="80%" class="line_gray pl10">
            	<cmb:combo qryname="cmb_snmp_man_code" seltagname="N_SNMP_MAN_CODE" firstdata="선택"/>
            </td>
          </tr>
          <tr>
            <td height="27" class="line_gray table_bg pl10 text11 b">
            	SNMP Port
            </td>
            <td class="line_gray pl10">
            	<input type="text" name="N_SNMP_PORT" id="N_SNMP_PORT" class="넌숫자만" style="width:150px;" value="">
            </td>
          </tr>
          <tr>
            <td height="27" class="line_gray table_bg pl10 text11 b">
            	SNMP Community
            </td>
            <td class="line_gray pl10">
            	<input type="text" name="S_SNMP_COMMUNITY" id="S_SNMP_COMMUNITY" style="width:150px;" value="">
            </td>
          </tr>
          <tr>
            <td height="27" class="line_gray table_bg pl10 text11 b">
            	SNMP Version
            </td>
            <td class="line_gray pl10">
            	<input type="text" name="N_SNMP_VERSION" id="N_SNMP_VERSION" class="넌숫자만" style="width:150px;" value="">
            </td>
          </tr>
          <tr>
            <td colspan="2" bgcolor="3b3b3b"><img src="${img1}/dot.png"></td>
          </tr>
        </table>
      </div>
      <div id="icmp_info" style="display: none;">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="20%" height="29"class="line_gray table_bg pl10 text11 b">
            	ICMP 명칭
            </td>
            <td width="80%" class="line_gray pl10">
            	<input type="text" name="S_ICMP_NAME" id="S_ICMP_NAME" style="width:150px;" value="">
            </td>
          </tr>
          <tr>
            <td height="27" class="line_gray table_bg pl10 text11 b">
            	체크주기(초)
            </td>
            <td class="line_gray pl10">
            	<input type="text" name="N_CHECK_TIME" id="N_CHECK_TIME" class="넌숫자만" style="width:150px;" value="">
            </td>
          </tr>
          <tr>
            <td height="27" class="line_gray table_bg pl10 text11 b">
            	응답시간(ms)
            </td>
            <td class="line_gray pl10">
            	<input type="text" name="N_RES_TIME" id="N_RES_TIME" class="넌숫자만" style="width:150px;" value="">
            </td>
          </tr>
          <tr>
            <td height="27" class="line_gray table_bg pl10 text11 b">
            	TimeOut(초)
            </td>
            <td class="line_gray pl10">
            	<input type="text" name="N_TIME_OUT" id="N_TIME_OUT" class="넌숫자만" style="width:150px;" value="">
            </td>
          </tr>
          <tr>
            <td height="27" class="line_gray table_bg pl10 text11 b">
            	장애인식카운트
            </td>
            <td class="line_gray pl10">
            	<input type="text" name="N_ALM_CNT" id="N_ALM_CNT" class="넌숫자만" style="width:150px;" value="">
            </td>
          </tr>
          <tr>
            <td height="27" class="line_gray table_bg pl10 text11 b">
            	장애등급
            </td>
            <td class="line_gray pl10">
            	<cmb:combo qryname="cmb_alm_rating" seltagname="N_ALM_RAT"/>
            </td>
          </tr>
          <tr>
            <td colspan="2" bgcolor="3b3b3b"><img src="${img1}/dot.png"></td>
          </tr>
        </table>
      </div>
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
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
