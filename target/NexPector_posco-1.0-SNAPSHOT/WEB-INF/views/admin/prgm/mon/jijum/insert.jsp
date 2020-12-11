<%@ page import="com.nns.common.util.RSACrypt" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<c:set value="등록" var="pg_title"/>
<c:if test="${param.UPD_FLAG == 'U'}">
	<c:set value="수정" var="pg_title"/>
</c:if>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>지점 전화기 <c:out value="${pg_title }"></c:out></h2><span>Home &gt; 감시장비 관리 &gt; 지점전화기 <c:out value="${pg_title }"></c:out></span></div></div>


<form id="jijum_insert_form" name="jijum_insert_form" data-role="validator">
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
					<td class="filed_A left">본부</td>
					<td class="filed_B left">
						<c:choose>
							<c:when test="${param.UPD_FLAG == 'U'}">
								<span id="span_GROUP_NAME" name="span_GROUP_NAME"></span>
								<input type="hidden" name=N_GROUP_CODE id="N_GROUP_CODE">
								<input type="hidden" name=S_GROUP_NAME id="S_GROUP_NAME">
							</c:when>
							<c:otherwise>
								<cmb:combo qryname="cmb_nMonJijumId" seltagname="N_GROUP_CODE" firstdata="선택" />
							</c:otherwise>
						</c:choose>
						<input type="hidden" name="chk_val" value="">
						<font id="msg" color="red"></font>
					</td>
					<td class="filed_A left">사업국</td>
					<td class="filed_B left">
							<input type="text" name="S_NAME" id="S_NAME" class="manaint_f" style="width:150px;" value="" maxlength="30">
<%-- 						<c:choose>
							<c:when test="${param.UPD_FLAG == 'U'}">
								<span id="span_Name" name="span_Name"></span>
								<input type="hidden" name="S_NAME" id="S_NAME" class="manaint_f">
							</c:when>
							<c:otherwise>
								<input type="text" name="S_NAME" id="S_NAME" class="manaint_f" style="width:150px;" value="" maxlength="30">	
							</c:otherwise>
						</c:choose> --%>
					</td>
				</tr>
				<tr>
					<td class="filed_A left">러닝</td>
					<td class="filed_B left">
						<input type="text" name="S_RUNNING" id="S_RUNNING" class="manaint_f" style="width:50%;" value="" maxlength="30">
					</td>
					<td class="filed_A left">구분</td>
					<td class="filed_B left">
						<input type="text" name="S_GUBUN" id="S_GUBUN" class="manaint_f" style="width:50%;" value="" maxlength="6">
					</td>
				</tr>
				<tr>
					<td class="filed_A left">IP Address</td>
					<td class="filed_B left"><input type="text" name="S_IP_ADDRESS" id="S_IP_ADDRESS" class="manaint_f" style="width:50%;" value="" maxlength="20"></td>
					<td class="filed_A left">전화번호</td>
					<td class="filed_B left"><input type="text" name="S_EXT_NUM" id="S_EXT_NUM" class="manaint_f" style="width:50%;" value="" maxlength="30"></td>
				</tr>
				<tr>
					<td class="filed_A left">주소</td>
					<td class="filed_B left">
						<input type="text" name="S_ADDRESS" id="S_ADDRESS" class="manaint_f" style="width:90%;" value="" maxlength="340">
					</td>
					<td class="filed_A left">비고</td>
					<td class="filed_B left"><input type="text" name="S_BIGO" id="S_BIGO" class="manaint_f" style="width:90%;" value="" maxlength="100">
					</td>
				</tr>
			</table>
			<!-- botton -->
			<div id="botton_align_center1">
				<a href="#" id="btn_save" class="css_btn_class">저장</a>&nbsp;&nbsp;&nbsp;
				<a href="#" id="btn_cancel" class="css_btn_class">취소</a>&nbsp;&nbsp;&nbsp;
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
		$("#jijum_insert_form").kendoValidator().data("kendoValidator");

		initEvent();

		// 수정 페이지
		if ('U' === '${param.UPD_FLAG}') {
			searchDetailInfo();
		}
	});

	function searchDetailInfo() {
			var param 	= {
				'S_IP_ADDRESS' : '${param.KEY_IP_ADDRESS}',
				'S_EXT_NUM' : '${param.KEY_EXT_NUM}'
			};

			$.getJSON("<c:url value='/admin/map_jijum.detail_info.htm'/>", param, function(data){
				//$("select[name=N_GROUP_CODE]").val(data.N_GROUP_CODE);
				$("#S_NAME").val(data.S_NAME);
				$("#S_EXT_NUM").val(data.S_EXT_NUM);
				$("#S_IP_ADDRESS").val(data.S_IP_ADDRESS);
				$("#S_ADDRESS").val(data.S_ADDRESS);
				$("#S_GUBUN").val(data.S_GUBUN);
				$("#S_RUNNING").val(data.S_RUNNING);
				$("#S_BIGO").val(data.S_BIGO);
				
				$("#N_GROUP_CODE").val(data.N_GROUP_CODE);
				$("#S_GROUP_NAME").val(data.S_GROUP_NAME);
				$("#span_GROUP_NAME").html(data.S_GROUP_NAME);
				$("#span_Name").html(data.S_NAME);
			});
			
			//$("#S_IP_ADDRESS").attr("readonly", true); 
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
		var old_ipaddress = "${param.KEY_IP_ADDRESS}";
		
		var paramold 	= {
				'S_IP_ADDRESS' : '${param.KEY_IP_ADDRESS}',
				'S_EXT_NUM' : '${param.KEY_EXT_NUM}'
			};
		// 벨리데이션 체크
		<c:choose>
			<c:when test="${param.UPD_FLAG == 'U'}">
			</c:when>
			<c:otherwise>
				if($("select[name=N_GROUP_CODE]").val()=="" || $("select[name=N_GROUP_CODE]").val()==null){
					alert("지역구분을 선택 하셔야함");
					$('select[name="N_GROUP_CODE"]').focus();
					return;
				}
				
				if($('#S_IP_ADDRESS').val()=="" || $('#S_IP_ADDRESS').val()==null){
					alert("전화기 IP를 입력 하셔야합니다");
					$('#S_IP_ADDRESS').focus();
					return;
				}
				
/* 				if('${param.KEY_IP_ADDRESS}' != '' && '${param.KEY_IP_ADDRESS}' != $('#S_IP_ADDRESS').val()) {
					alert("기존 IP 정보  전체가 삭제 됩니다.");
					if(!confirm("정말 삭제 하시겠습니까?"))
						return;
					
				} */
			</c:otherwise>
		</c:choose>
				
		if($('#S_NAME').val()=="" || $('#S_NAME').val()==null){
			alert("지점명을 입력 하셔야합니다.");
			$('#S_NAME').focus();
			return;
		}
		
		if($('#S_EXT_NUM').val()=="" || $('#S_EXT_NUM').val()==null){
			alert("전화번호를 입력 하셔야합니다.");
			$('#S_EXT_NUM').focus();
			return;
		}
		
		if($('#S_IP_ADDRESS').val()=="" || $('#S_IP_ADDRESS').val()==null){
			alert("IPAddress를 입력 하셔야합니다.");
			$('#S_IP_ADDRESS').focus();
			return;
		}
		
		if($('#S_ADDRESS').val()=="" || $('#S_ADDRESS').val()==null){
			alert("주소를 입력 하셔야합니다.");
			$('#S_ADDRESS').focus();
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
		
		var url = ('${param.UPD_FLAG}' != 'U')?"<c:url value='/admin/ins_jijum.insert_data.htm'/>":"<c:url value='/admin/ins_jijum.update_data.htm'/>";
		
		if(old_ipaddress != $('#S_IP_ADDRESS').val() && ${param.UPD_FLAG == 'U'}) {
			url = 	"<c:url value='/admin/ins_jijum.insert_data.htm'/>";		
		}
		
		var param = $("form[name='jijum_insert_form']").serialize();

		
		
		$.post(url, param, function(str){
			var data = $.parseJSON(str);
			if(data.RSLT != null && data.RSLT > 0) {
				
				if(old_ipaddress != $('#S_IP_ADDRESS').val() && ${param.UPD_FLAG == 'U'}) {

					$.getJSON("<c:url value='/admin/del_jijum.delete_data.htm'/>", paramold, function(dataalm){
					});
					
					$.getJSON("<c:url value='/admin/del_jijum.delete_data_result.htm'/>", paramold, function(dataalm){
					});
										
					$.getJSON("<c:url value='/admin/ins_dash_system.del_alm_phone.htm'/>", paramold, function(dataalm){
					});
					
					$.getJSON("<c:url value='/admin/ins_dash_system.del_alm_histroy_phone.htm'/>", paramold, function(dataalmhistory){
					});	
				}
				
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
		
		var url = "<c:url value='/admin/del_jijum.delete_data.htm'/>";


		
		var param = $("form[name='jijum_insert_form']").serialize();
		$.post(url, param, function(str){
			var data = $.parseJSON(str);
			if(data.RSLT != null && data.RSLT > 0) {
				$.getJSON("<c:url value='/admin/ins_dash_system.del_alm_phone.htm'/>", param, function(dataalm){
				});
				
				$.getJSON("<c:url value='/admin/ins_dash_system.del_alm_histroy_phone.htm'/>", param, function(dataalmhistory){
				});				
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
	
	function deleteOldInfo() {
/* 		var url = "<c:url value='/admin/del_jijum.delete_data.htm'/>";
		
		var param = $("form[name='jijum_insert_form']").serialize();
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
		}); */
	}
	
	function goListPage(event) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.jijum.retrieve.htm').submit();		
	}
	
	function clearFormData() {
		if ('U' === '${param.UPD_FLAG}') {
			searchDetailInfo();
		} else {
			$("form")[0].reset();
		}
		$("#jijum_insert_form span.k-tooltip-validation").hide(); // kendo validator 문구 초기화
	}
	
	// 중복 체크
	function fn_duplication_chk(obj)
	{
		var param = $("form[name='jijum_insert_form']").serialize();
		$.getJSON("<c:url value='map_jijum.dul_chk.htm'/>", param, function(data){
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
		var param = $("form[name='jijum_insert_form']").serialize();
		$.getJSON("<c:url value='map_jijum.dul_detail_chk.htm'/>", param, function(data){
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