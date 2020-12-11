<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>대시보드 네트워크 장비 등록</h2><span>Home &gt; 감시장비 관리 &gt; 대시보드 네트워크 장비 등록</span></div></div>

<form id="dashboard_network_insert_form" name="dashboard_network_insert_form" data-role="validator">
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
					<td class="filed_A left">노드ID</td>
					<td class="filed_B left"><input type="text" name="N_NE_ID" id="N_NE_ID" value="" class="manaint_f" style="width:90%;" readonly/></td>
					<td class="filed_A left">서브ID</td>
					<td class="filed_B left"><input type="text" name="N_NE_SUB_ID" id="N_NE_SUB_ID" value="" class="manaint_f" style="width:90%;" readonly/></td>
				</tr>
				<tr>
					<td class="filed_A left">노드명</td>
					<td class="filed_B left"><input type="text" name="S_NE_NAME" id="S_NE_NAME" value="" maxlength="25" class="manaint_f" style="width:90%;"/></td>
					<td class="filed_A left">노드설명</td>
					<td class="filed_B left"><input type="text" name="S_DESC" id="S_DESC" value="" class="manaint_f" style="width:90%;" maxlength="50"/></td>
				</tr>
				<tr>
					<td class="filed_A left">감시장비 이름/ID</td>
					<td class="filed_B left" colspan="3"><select id="N_MON_ID" name="N_MON_ID"><option value="">없음</option></select></td>
				</tr>
			</table>
			<!-- botton -->
			<div id="botton_align_center1"><a href="#" class="css_btn_class" id="btn_save">저장</a>&nbsp;&nbsp;&nbsp;<a href="#" class="css_btn_class" id="btn_cancel">취소</a></div>
			<!-- botton // -->
		</div>
		<!--사용자등록//-->
	</div>
<input type="hidden" id="S_NE_MODEL" name="S_NE_MODEL" value="">
<input type="hidden" id="S_NE_MANUFACTURER" name="S_NE_MANUFACTURER" value="">
<input type="hidden" id="N_NE_TYPE" name="N_NE_TYPE" value="">
</form>

<form id="go_list_form" method="get">
	<input type="hidden" name="searchParam" value="${param.searchParam}"/>
</form>

<script src="<c:url value="/common/js/rsa/jsbn.js"/>" type="text/JavaScript"></script>
<script src="<c:url value="/common/js/rsa/rsa.js"/>" type="text/JavaScript"></script>
<script src="<c:url value="/common/js/rsa/prng4.js"/>" type="text/JavaScript"></script>
<script src="<c:url value="/common/js/rsa/rng.js"/>" type="text/JavaScript"></script>

<script type="text/javascript">
	$(document).ready(function() {
		$("#dashboard_network_insert_form").kendoValidator().data("kendoValidator");
	
		cfn_makecombo_opt($("#N_MON_ID"), "<c:url value="/admin/lst_common.cmb_mon_info.htm"/>");
	
		initEvent();
	
		// 수정 페이지
		if ('U' === '${param.updateFlag}') {
			$(".dupl_chk").blur(function(){
				fn_duplication_chk(this);
			});

			searchDetailInfo('${param.N_NE_ID}','${param.N_NE_SUB_ID}');
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
		$('#btn_remove').on('click', deleteDashboardNetwork);
		$('#btn_list').on('click', goListPage);
		$('input[type=text]').focusout(function() {
			this.value = $.trim(this.value);
		});
	}
	
	function searchDetailInfo(neId, neSubId) {
		
		var param 	= {
				'N_NE_ID' : neId,
				'N_NE_SUB_ID' : neSubId
			};
		
		$.getJSON("<c:url value='/admin/map_dashboard_network.detail_info.htm'/>", param, function(data){
			$("#N_NE_ID").val(data.N_NE_ID);
			$("#N_NE_SUB_ID").val(data.N_NE_SUB_ID);
			$("#S_NE_NAME").val(data.S_NE_NAME);
			$("#S_DESC").val(data.S_DESC);
			$("#N_MON_ID").val(data.N_MON_ID);
			
		});
	}
	
	// 삭제
	function deleteDashboardNetwork()
	{
		if(!confirm("정말 삭제 하시겠습니까?"))
			return;
	
		var url = "<c:url value='/admin/del_dashboard_network.delete_data.htm'/>";
	
		var param = $("form[name='dashboard_network_insert_form']").serialize();
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
	
	// 저장
	function save() {
		if($('#S_NE_NAME').val()=="" || $('#S_NE_NAME').val()==null){
			alert("노드명을 입력하십시오.");
			$('#S_NE_NAME').focus();
			return;
		}
	
		var url = "<c:url value='/admin/dashboard_network_mgt/update.htm'/>";
		var param = $("form[name='dashboard_network_insert_form']").serialize();

		$.post(url, param, function(str){
			var data = $.parseJSON(str);
	
			if(data.RSLT != null && data.RSLT > 0) {
				alert('저장되었습니다.');
				goListPage();
				return;
			}
			else if (data.RSLT != null && data.RSLT == -999) {
				alert('다른 노드와 맵핑된 감시장비 입니다.');
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
	
	function goListPage(event) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.dashboard_network.retrieve.htm').submit();
	}
	
	function clearFormData() {
		if ('U' === '${param.updateFlag}') {
			searchDetailInfo('${param.N_NE_ID}','${param.N_NE_SUB_ID}');
		} else {
			$("form")[0].reset();
		}
		$("#dashboard_network_insert_form span.k-tooltip-validation").hide(); // kendo validator 문구 초기화
	}
	
	
	function fn_duplication_chk(obj)
	{
		var param = $("form[name='dashboard_network_insert_form']").serialize();
		$.getJSON("<c:url value='map_dashboard_network.dul_chk.htm'/>", param, function(data){
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
</script>