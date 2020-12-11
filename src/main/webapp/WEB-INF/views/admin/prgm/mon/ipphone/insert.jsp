<%@ page import="com.nns.common.util.RSACrypt" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>사용자 정보 등록</h2><span>Home &gt; 사용자 관리 &gt; 사용자 정보등록</span></div></div>

<form id="ip_phone_insert_form" name="ip_phone_insert_form" data-role="validator">
	<div style="float: left;margin-bottom: 5px;">
		<a href="#" id="btn_list" class="css_btn_class">목록</a>
	</div>
	<div class="manager_contBox1">
		<!--//사용자등록 -->
		<div class="table_typ2-5">
			<table summary="" cellpadding="0" cellspacing="0">
				<caption></caption>
				<colgroup>
					<col width="15%" />
					<col width="35%" />
					<col width="15%" />
					<col width="35%" />
				</colgroup>
				<tr>
					<td class="filed_A left">교환기</td>
					<td class="filed_B left">
						<c:choose>
							<c:when test="${param.UPD_FLAG == 'U'}">
								<span id="spanCm" name="spanCm"></span>
								<input type="hidden" name=N_MON_ID id="N_MON_ID">	
							</c:when>
							<c:otherwise>
								<cmb:combo qryname="cmb_nMonId" seltagname="N_MON_ID" firstdata="선택" />
							</c:otherwise>
						</c:choose>
						<input type="hidden" name="chk_val" value="">
						<font id="msg" color="red"></font>
					</td>
					<td class="filed_A left">전화기IP</td>
					<td class="filed_B left">
						<c:choose>
							<c:when test="${param.UPD_FLAG == 'U'}">
								<span id="spanIP" name="spanIP"></span>
								<input type="hidden" name="S_IPADDRESS" id="S_IPADDRESS" class="manaint_f">
							</c:when>
							<c:otherwise>
								<input type="text" name="S_IPADDRESS" id="S_IPADDRESS" class="manaint_f" style="width:150px;" value="" maxlength="15">	
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
					<td class="filed_A left">전화기 그룹</td>
					<td class="filed_B left"><cmb:combo qryname="cmb_svr_group" seltagname="N_GROUP" firstdata="없음"/></td>
					<td class="filed_A left">전화기 내선 정보</td>
					<td class="filed_B left"><input type="text" name="S_EXT_NUM" id="S_EXT_NUM" class="manaint_f" style="width:90%;" value="" maxlength="20"></td>
				</tr>
				<tr>
					<td class="filed_A left">전화기 사용자 정보</td>
					<td class="filed_B left">
						<input type="text" name="S_NAME" id="S_NAME" class="manaint_f" style="width:90%;" value="" maxlength="20">
					</td>
					<td class="filed_A left">전화기 타입</td>
					<td class="filed_B left">
						<input type="text" name="S_TYPE" id="S_TYPE" class="manaint_f" style="width:90%;" value="">
					</td>
				</tr>
				<tr>
					<td class="filed_A left">SNMP Community</td>
					<td class="filed_B left">
						<input type="text" name="S_COMMUNITY" id="S_COMMUNITY" class="manaint_f" style="width:90%;" value="express">
					</td>
					<td class="filed_A left">SNMP Port</td>
					<td class="filed_B left">
						<input type="text" name="N_PORT" id="N_PORT" class="manaint_f" style="width:90%;" value="161">
					</td>
				</tr>
				<tr>
					<td class="filed_A left">SNMP Version</td>
					<td class="filed_B left" colspan="3">
						<input type="text" name="N_SNMP_VER" id="N_SNMP_VER" class="manaint_f" style="width:90%;" value="2">
					</td>
				</tr>
			</table>
			<!-- botton -->
			<div id="botton_align_center1">
				<a href="#" id="btn_save" class="css_btn_class">저장</a>&nbsp;&nbsp;&nbsp;
				<a href="#" id="btn_cancel" class="css_btn_class">취소</a>
				<c:if test="${param.UPD_FLAG == 'U'}">
					<a href="#" id="btn_remove" class="css_btn_class">삭제</a>
				</c:if>
			</div>
			<!-- botton // -->
		</div>
		<!--사용자등록//-->

	</div>
</form>

<form id="go_list_form" method="get">
	<input type="hidden" name="searchParam" value="${param.searchParam}"/>
</form>

<script src="<c:url value="/common/js/rsa/jsbn.js"/>" type="text/JavaScript"></script>
<script src="<c:url value="/common/js/rsa/rsa.js"/>" type="text/JavaScript"></script>
<script src="<c:url value="/common/js/rsa/prng4.js"/>" type="text/JavaScript"></script>
<script src="<c:url value="/common/js/rsa/rng.js"/>" type="text/JavaScript"></script>

<script type="text/javascript">
	<c:if test="${param.UPD_FLAG != 'U'}">
	$(function(){
		$(".dupl_chk").blur(function(){
			fn_duplication_chk(this);
		});
	});
	</c:if>
	
	$(document).ready(function() {
		$("#ip_phone_insert_form").kendoValidator().data("kendoValidator");

		initEvent();

		// 수정 페이지
		if ('U' === '${param.updateFlag}') {
			searchDetailInfo('${param.N_MON_ID}','${param.S_IPADDRESS}','${param.N_GROUP}');
		}
	});

	function searchDetailInfo(monId, ipAddress, nGroup) {

			var param 	= {
					'N_MON_ID' : monId,
					'S_IPADDRESS' : ipAddress,
					'N_GROUP' : nGroup
				};
			
			$.getJSON("<c:url value='/admin/map_ipphone.detail_info.htm'/>", param, function(data){
				$("select[name=N_MON_ID]").val(data.N_MON_ID);
				$("#S_IPADDRESS").val(data.S_IPADDRESS);
				$("select[name=N_GROUP]").val(data.N_GROUP);
				$("#S_EXT_NUM").val(data.S_EXT_NUM);
				$("#S_NAME").val(data.S_NAME);
				$("#S_TYPE").val(data.S_TYPE);
				$("#S_COMMUNITY").val(data.S_COMMUNITY);
				$("#N_PORT").val(data.N_PORT);
				$("#N_SNMP_VER").val(data.N_SNMP_VER);
			});
	}
	
	function initEvent() {
		$('#btn_cancel').on('click', function(event) {
			event.preventDefault();
			if ( confirm("작성된 데이터를 초기화 하시겠습니까?") ) {
				clearFormData();
			}
		});

		$('#btn_save').on('click', save);
		$('#btn_remove').on('click', deleteInfo);
		$('#btn_list').on('click', goListPage);

		$('input[type=text]').focusout(function() {
			this.value = $.trim(this.value);
		});
	}

	function save() {

		// 벨리데이션 체크
		<c:choose>
			<c:when test="${param.UPD_FLAG == 'U'}">
			</c:when>
			<c:otherwise>
				if($("select[name=N_MON_ID]").val()=="" || $("select[name=N_MON_ID]").val()==null){
					alert("CM을 선택 하셔야함");
					$('select[name="N_MON_ID"]').focus();
					return;
				}
				
				if($('#S_IPADDRESS').val()=="" || $('#S_IPADDRESS').val()==null){
					alert("전화기 IP를 입력 하셔야함");
					$('#S_IPADDRESS').focus();
					return;
				}
			</c:otherwise>
		</c:choose>
				
				
		if($("select[name=N_GROUP]").val()=="" || $("select[name=N_GROUP]").val()==null){
			alert("전화기 그룹을 선택 하셔야함");
			$('select[name="N_SNMP_MON_CODE"]').focus();
			return;
		}
		
		if($('#S_NAME').val()=="" || $('#S_NAME').val()==null){
			alert("전화기 사용자 정보를 입력 하셔야함");
			$('#S_NAME').focus();
			return;
		}
		
		if($('#S_TYPE').val()=="" || $('#S_TYPE').val()==null){
			alert("전화기 타입을 입력하셔야함");
			$('#S_TYPE').focus();
			return;
		}
		
		if($('#S_COMMUNITY').val()=="" || $('#S_COMMUNITY').val()==null){
			alert("SNMP Community를 입력 하셔야함");
			$('#S_COMMUNITY').focus();
			return;
		}
		
		if($('#N_PORT').val()=="" || $('#N_PORT').val()==null){
			alert("SNMP Port를 입력 하셔야함");
			$('#N_PORT').focus();
			return;
		}
		
		if($('#N_SNMP_VER').val()=="" || $('#N_SNMP_VER').val()==null){
			alert("SNMP Version를 입력 하셔야함");
			$('#N_SNMP_VER').focus();
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
		
		var url = ('${param.UPD_FLAG}' != 'U')?"<c:url value='/admin/ins_ipphone.insert_data.htm'/>":"<c:url value='/admin/upd_ipphone.update_data.htm'/>";
		
		var param = $("form[name='ip_phone_insert_form']").serialize();
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

	function deleteInfo() {
		if(!confirm("정말 삭제 하시겠습니까?"))
			return;
		
		var url = "<c:url value='/admin/del_ipphone.delete_data.htm'/>";
		
		var param = $("form[name='ip_phone_insert_form']").serialize();
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
	
	function goListPage(event) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.ipphone.retrieve.htm').submit();		
	}
	
	function clearFormData() {
		if ('U' === '${param.updateFlag}') {
			searchDetailInfo();
		} else {
			$("form")[0].reset();
		}
		$("#ip_phone_insert_form span.k-tooltip-validation").hide(); // kendo validator 문구 초기화
	}
	
	// 중복 체크
	function fn_duplication_chk(obj)
	{
		var param = $("form[name='ip_phone_insert_form']").serialize();
		$.getJSON("<c:url value='map_ipphone.dul_chk.htm'/>", param, function(data){
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
	
	// SNMP감시상세 중복 체크
	function fn_duplication_detail_chk()
	{
		var param = $("form[name='ip_phone_insert_form']").serialize();
		$.getJSON("<c:url value='map_ipphone.dul_detail_chk.htm'/>", param, function(data){
			if(data.CNT > 0) {
				document.getElementById("detail_msg").style.visibility = "visible";
			}
			else {
				document.getElementById("detail_msg").style.visibility = "hidden";
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
	
</script>