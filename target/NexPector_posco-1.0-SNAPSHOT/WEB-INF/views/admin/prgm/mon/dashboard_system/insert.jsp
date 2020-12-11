<%@ page import="com.nns.common.util.RSACrypt" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>대시보드 시스템 현황 변경</h2><span>Home &gt; 감시장비 관리 &gt; 대시보드 시스템 현황 변경</span></div></div>

<form id="dashboard_system_insert_form" name="dashboard_system_insert_form" data-role="validator">
<input type="hidden" name="S_DESC" id="S_DESC" value="">
	<div style="float: left;margin-bottom: 5px;">
		<a href="#" id="btn_list" class="css_btn_class">목록</a>
	</div>
	<div class="manager_contBox1">
	<!--//사용자등록 -->
		<div class="table_typ2-5">
			<table summary="" cellpadding="0" cellspacing="0">
			<caption></caption>
			<colgroup>
				<col width="20%" />
				<col width="80%" />
			</colgroup>
			<tr>
				<td class="filed_A left">장비그룹코드</td>
				<td class="filed_B left"><input type="text" name="N_GROUP_CODE" id="N_GROUP_CODE" value="" class="manaint_f" style="width:90%;" readonly/></td>
			</tr>
			<tr>
				<td class="filed_A left">콜센터명</td>
				<td class="filed_B left"><input type="text" name="S_CENTER_NAME" id="S_CENTER_NAME" value="" class="manaint_f" style="width:90%;" maxlength="20"/></td>
			</tr>
			<tr>
				<td class="filed_A left">전화기 대수</td>
				<td class="filed_B left"><input type="text" name="N_CENTER_CNT" id="N_CENTER_CNT" value="" class="manaint_f" style="width:90%;" maxlength="3"/></td>
			</tr>
			</table>
			<!-- botton -->
			<div id="botton_align_center1"><a href="#" class="css_btn_class" id="btn_save">저장</a>&nbsp;&nbsp;&nbsp;<a href="#" class="css_btn_class" id="btn_cancel">취소</a></div>
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
	
	$(document).ready(function() {

		$("#dashboard_system_insert_form").kendoValidator().data("kendoValidator");
		initEvent();
		$(".dupl_chk").blur(function(){
			fn_duplication_chk(this);
		});

		searchDetailInfo('${param.N_GROUP_CODE}');

	});
	
	function initEvent() {
		$('#btn_cancel').on('click', function(event) {
			event.preventDefault();
			if ( confirm("작성된 데이터를 초기화 하시겠습니까?") ) {
				clearFormData();
			}
		});
	
		$('#btn_save').on('click', save);
		$('#btn_list').on('click', goListPage);
		$('input[type=text]').focusout(function() {
			this.value = $.trim(this.value);
		});
	}

	function save()
	{
		if($('#S_CENTER_NAME').val() == "" || $('#S_CENTER_NAME').val() == null){
			alert("콜센터명을 입력하십시오.");
			$('#S_CENTER_NAME').focus();
			return;
		}
		if($('#N_CENTER_CNT').val() == "" || $('#N_CENTER_CNT').val() == null){
			alert("전화기 대수를 입력하십시오.");
			$('#N_CENTER_CNT').focus();
			return;
		}

		var url = ('${param.updateFlag}' != 'U')?"<c:url value='/admin/ins_dashboard_system.insert_data.htm'/>":"<c:url value='/admin/upd_dashboard_system.update_data.htm'/>";

		var param = $("form[name='dashboard_system_insert_form']").serialize();
console.log("param :: "+param);
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
	
	function goListPage(event) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.dashboard_system.retrieve.htm').submit();
	}
	
	function clearFormData() {
		if ('U' === '${param.updateFlag}') {
			searchDetailInfo('${param.N_GROUP_CODE}');
		} else {
			$("form")[0].reset();
		}
		$("#dashboard_system_insert_form span.k-tooltip-validation").hide(); // kendo validator 문구 초기화
	}
	
	function searchDetailInfo(nGroupCode) {
		
		var param 	= {
				'N_GROUP_CODE' : nGroupCode
			};
		
		$.getJSON("<c:url value='/admin/map_dashboard_system.detail_info.htm'/>", param, function(data){
			$("#N_GROUP_CODE").val(data.N_GROUP_CODE);
			$("#N_CENTER_CNT").val(data.N_CENTER_CNT);
			$("#S_CENTER_NAME").val(data.S_CENTER_NAME);
			$("#S_DESC").val(data.S_DESC);
		});
	}

	function fn_duplication_chk(obj)
	{
		var param = $("form[name='dashboard_system_insert_form']").serialize();
		$.getJSON("<c:url value='map_dashboard_system.dul_chk.htm'/>", param, function(data){
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
