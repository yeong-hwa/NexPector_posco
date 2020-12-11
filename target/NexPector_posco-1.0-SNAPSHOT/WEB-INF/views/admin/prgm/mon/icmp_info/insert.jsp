<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>ICMP 추가 등록</h2><span>Home &gt; 감시장비 관리 &gt; ICMP 추가 등록</span></div></div>

<form id="icmp_info_insert_form" name="dashboard_network_insert_form" data-role="validator">
	<div style="float: left;margin-bottom: 5px;">
		<a href="#" id="btn_list" class="css_btn_class">목록</a>
	</div>
	<div class="manager_contBox1">
	
		<!-- 사용자등록 -->
		<div class="table_typ2-5">
			<!-- stitle -->
			<div class="stitle">
				<div class="st_under"><h4>감시장비 정보</h4></div>
			</div>
			<!-- stitle // -->
			<table summary="" cellpadding="0" cellspacing="0">
				<caption></caption>
				<colgroup>
					<col width="12%" />
					<col width="25%" />
					<col width="12%" />
					<col width="25%" />
					<col width="11%" />
					<col width="25%" />
				</colgroup>
				<tr>
					<td class="filed_A left">장비ID</td>
					<td class="filed_B left" id="nMonId"></td>
					<td class="filed_A left">장비명</td>
					<td class="filed_B left" id="sMonName1"></td>
					<td class="filed_A left">장비IP</td>
					<td class="filed_B left" id="sMonIp"></td>
				</tr>
				<tr>
					<td class="filed_A left">장비그룹</td>
					<td class="filed_B left" id="groupName"></td>
					<td class="filed_A left">장비타입</td>
					<td class="filed_B left" id="typeName"></td>
					<td class="filed_A left">장비종류</td>
					<td class="filed_B left" id="styleName"></td>
				</tr>
			</table>
		</div>
		
	
		<!-- 사용자등록 -->
		<div class="table_typ2-5">
			<!-- stitle -->
			<div class="stitle">
				<div class="st_under"><h4>ICMP 정보</h4></div>
			</div>
			<!-- stitle // -->
			<table summary="" cellpadding="0" cellspacing="0">
				<caption></caption>
				<colgroup>
					<col width="15%" />
					<col width="35%" />
					<col width="15%" />
					<col width="35%" />
				</colgroup>
				<tr>
					<td class="filed_A left">서버 ID</td>
					<td class="filed_B left"><input type="text" name="N_MON_ID" id="N_MON_ID" value="" class="manaint_f" readonly/></td>
					<td class="filed_A left">서버 IP</td>
					<td class="filed_B left">
		            	<c:if test="${param.UPD_FLAG == 'U'}">
		            		<input type="text" name="S_ICMP_IP" id="S_ICMP_IP" value="" maxlength="15" class="manaint_f" readonly/>
		            	</c:if>
		            	<c:if test="${param.UPD_FLAG != 'U'}">
		            		<input type="text" name="S_ICMP_IP" id="S_ICMP_IP" value="" maxlength="15" class="manaint_f"/>
		            	</c:if>
		            	<input type="hidden" name="OLD_S_ICMP_IP" id="OLD_S_ICMP_IP" maxlength="15">
		            	<input type="hidden" name="chk_val" value="">
		            	<font id="msg" color="red"></font>
					</td>
				</tr>
				<tr>
					<td class="filed_A left">명칭</td>
					<td class="filed_B left"><input type="text" name="S_ICMP_NAME" id="S_ICMP_NAME" value="" class="manaint_f"/></td>
					<td class="filed_A left">체크주기(초)</td>
					<td class="filed_B left"><input type="text" name="N_CHECK_TIME" id="N_CHECK_TIME" value="" class="manaint_f"/></td>
				</tr>
				<tr>
					<td class="filed_A left">응답시간(ms)</td>
					<td class="filed_B left"><input type="text" name="N_RES_TIME" id="N_RES_TIME" value="" class="manaint_f"/></td>
					<td class="filed_A left">TimeOut(초)</td>
					<td class="filed_B left"><input type="text" name="N_TIME_OUT" id="N_TIME_OUT" value="" class="manaint_f"/></td>
				</tr>
				<tr>
					<td class="filed_A left">장애인식카운트</td>
					<td class="filed_B left"><input type="text" name="N_ALM_CNT" id="N_ALM_CNT" value="" class="manaint_f"/></td>
					<td class="filed_A left">장애등급</td>
					<td class="filed_B left"><cmb:combo qryname="cmb_alm_rating" seltagname="N_ALM_RAT" firstdata="선택"/></td>
				</tr>
			</table>
			<!-- botton -->
			<div id="botton_align_center1">
				<a href="#" class="css_btn_class" id="btn_save">저장</a>&nbsp;&nbsp;&nbsp;
				<a href="#" class="css_btn_class" id="btn_cancel">취소</a>
				<c:if test="${param.UPD_FLAG == 'U'}">
					<a href="#" class="css_btn_class" id="btn_del">삭제</a>
				</c:if>
			</div>
			<!-- botton // -->
		</div>
	</div>
	<input type="hidden" name="OLD_N_MON_ID" id="OLD_N_MON_ID" value="${param.OLD_N_MON_ID}"/>
</form>

<form id="go_list_form" method="get">
	<input type="hidden" name="searchParam" value="${param.searchParam}"/>
</form>

<script type="text/javascript">
	$(document).ready(function() {
		<c:if test="${param.updateFlag != 'U'}">
			$(".dupl_chk").blur(function(){
				fn_duplication_chk(this);
			});
		</c:if>

		$("#icmp_info_insert_form").kendoValidator().data("kendoValidator");


		$("#nMonId").html("${param.N_MON_ID}");
		$("#sMonName1").html(decodeURIComponent("${param.S_MON_NAME1}"));
		$("#sMonIp").html("${param.S_MON_IP1}");
		$("#groupName").html(decodeURIComponent("${param.GROUP_NAME1}"));
		$("#typeName").html(decodeURIComponent("${param.TYPE_NAME1}"));
		$("#styleName").html("${param.STYLE_NAME1}");
		
		initEvent();
	
		// 수정 페이지
		if ('U' === '${param.updateFlag}') {
			$(".dupl_chk").blur(function(){
				fn_duplication_chk(this);
			});

			searchDetailInfo('${param.N_MON_ID}','${param.S_ICMP_IP}');
		}
	});
	
	function initEvent() {
		$('#btn_cancel').on('click', function(event) {
			event.preventDefault();
			if ( confirm("작성된 데이터를 초기화 하시겠습니까?") ) {
				clearFormData();
			}
		});
	
		$('#btn_save').on('click', save);
		$('#btn_remove').on('click', deleteIcmpInfo);
		$('#btn_list').on('click', goListPage);
		$('input[type=text]').focusout(function() {
			this.value = $.trim(this.value);
		});
	}
	
	// 삭제
	function deleteIcmpInfo(){
		if(!confirm("정말 삭제 하시겠습니까?"))
			return;
		
		var url = "<c:url value='/admin/del_icmp_info.delete_data.htm'/>";
		
		var param = $("form[name='icmp_info_insert_form']").serialize();
		$.post(url, param, function(str){
			var data = $.parseJSON(str);
			if(data.RSLT != null && data.RSLT > 0) {
				alert('삭제되었습니다.');
				goListPage();
				return;
			}
			else {
				alert("삭제 실패 하였습니다.\n" + data.ERRMSG + "");
				goListPage();
				return;
			}
		});
	}
	
	function fn_duplication_chk(obj)
	{
		var param = $("form[name='icmp_info_insert_form']").serialize();
		$.getJSON("<c:url value='map_icmp_info.dul_chk.htm'/>", param, function(data){
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
	
	function goListPage(event) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.icmp_info.retrieve.htm').submit();
	}

	function clearFormData() {
		if ('U' === '${param.updateFlag}') {
			searchDetailInfo('${param.N_MON_ID}','${param.S_ICMP_IP}');
		} else {
			$("form")[0].reset();
		}
		$("#icmp_info_insert_form span.k-tooltip-validation").hide(); // kendo validator 문구 초기화
	}
	
	function searchDetailInfo(nMonId, sIcmpIp) {
		
		$("#N_MON_ID").val("${param.N_MON_ID}");
		$("#S_ICMP_IP").val("${param.S_MON_NAME1}");
		$("#S_ICMP_NAME").val("${param.S_MON_IP1}");
		$("#N_CHECK_TIME").val("${param.GROUP_NAME1}");
		$("#N_RES_TIME").val("${param.TYPE_NAME1}");
		$("#N_TIME_OUT").val("${param.STYLE_NAME1}");
		
		var param 	= {
				'N_MON_ID' : nMonId,
				'S_ICMP_IP' : sIcmpIp
			};

		$.getJSON("<c:url value='/admin/map_icmp_info.detail_info.htm'/>", param, function(data){
			$("#N_MON_ID").val(data.N_MON_ID);
			$("#S_ICMP_IP").val(data.S_ICMP_IP);
			$("#S_ICMP_NAME").val(data.S_ICMP_NAME);
			$("#N_CHECK_TIME").val(data.N_CHECK_TIME);
			$("#N_RES_TIME").val(data.N_RES_TIME);
			$("#N_TIME_OUT").val(data.N_TIME_OUT);
			$("#N_ALM_CNT").val(data.N_ALM_CNT);
			$("select[name='N_ALM_RAT']").val(data.N_ALM_RATING);
		});
	}
	
	/* 저장 */
	function save()
	{
		<c:if test="${param.updateFlag != 'U'}">
			fn_duplication_chk($(".dupl_chk"));
			if($("#msg").text() != "")
			{
				alert("중복되지 않은 ID를 지정하여 주십시오.");
				return;
			}
		</c:if>
		
		// IP 주소 체크 벨리데이션
		if(!verifyIP($('#S_ICMP_IP').val())) return;
		
		// 벨리데이션 체크
		if($('#S_ICMP_NAME').val()=="" || $('#S_ICMP_NAME').val()==null){
			alert("명칭을 입력 하셔야함");
			$('#S_ICMP_NAME').focus();
			return;
		}
		
		if($('#N_CHECK_TIME').val()=="" || $('#N_CHECK_TIME').val()==null){
			alert("체크주기를 입력 하셔야함");
			$('#N_CHECK_TIME').focus();
			return;
		}
		
		if($('#N_RES_TIME').val()=="" || $('#N_RES_TIME').val()==null){
			alert("응담시간을 입력 하셔야함");
			$('#N_RES_TIME').focus();
			return;
		}
		
		if($('#N_TIME_OUT').val()=="" || $('#N_TIME_OUT').val()==null){
			alert("타임아웃 초를 입력 하셔야함");
			$('#N_TIME_OUT').focus();
			return;
		}
		
		if($('#N_ALM_CNT').val()=="" || $('#N_ALM_CNT').val()==null){
			alert("장애인식카운트를 입력 하셔야함");
			$('#N_ALM_CNT').focus();
			return;
		}
		
		if($("select[name=N_ALM_RAT]").val()=="" || $("select[name=N_ALM_RAT]").val()==null){
			alert("징애등급을 선택 하셔야함");
			$('select[name="N_ALM_RAT"]').focus();
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
		
		var tmp_sms_no = "";
		
		$(".div_sms_no").each(function(idx){
			if(idx != 0) tmp_sms_no += ",";
			tmp_sms_no += $(this).children("input[name='S_SMS_NAME']").val() + ";" + $(this).children("input[name='S_SMS_NO']").val();
		});
		
		$("input[name='S_SMS_NO_LIST']").val(tmp_sms_no);
		
		var url = ('${param.updateFlag}' != 'U')?"<c:url value='/admin/ins_icmp_info.insert_data.htm'/>":"<c:url value='/admin/upd_icmp_info.update_data.htm'/>";
		
		var param = $("form[name='icmp_info_insert_form']").serialize();
		
		$.post(url, param, function(str){
			var data = $.parseJSON(str);
			if(data.RSLT != null && data.RSLT > 0) {
				alert('저장되었습니다.');
				goListPage();
				return;
			}
			else {
				alert("저장 실패 하였습니다.\n" + data.ERRMSG + "");
				goListPage();
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
	
</script>