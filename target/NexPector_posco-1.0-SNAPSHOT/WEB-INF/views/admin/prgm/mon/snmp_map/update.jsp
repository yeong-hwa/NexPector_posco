<%@ page import="com.nns.common.util.RSACrypt" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>SNMP MAP 코드 정보등록</h2><span>Home &gt; 감시장비 관리 &gt; SNMP MAP 코드 정보등록</span></div></div>

<form id="snmp_map_update_form" name="snmp_map_update_form" data-role="validator">
<input type="hidden" id="snmp_map_delete_list" name="SNMP_MAP_DELETE_LIST" value=""/>
	<div style="float: left;margin-bottom: 5px;">
		<a href="#" id="btn_list" class="css_btn_class">목록</a>
	</div>
	<div class="manager_contBox1">
		<!-- 사용자등록 -->
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
				<td class="filed_A left">감시장비</td>
				<td class="filed_B left">
	            	<span id="S_MON_NAME"></span>
	            	<input type="hidden" name="N_MON_ID" id="N_MON_ID" value=""/>
				</td>
				<td class="filed_A left">SNMP 장비</td>
				<td class="filed_B left">
	            	<span id="N_SNMP_MAN_NAME"></span>
	            	<input type="hidden" name="N_SNMP_MAN_CODE" id="N_SNMP_MAN_CODE" value=""/>
				</td>
			</tr>
			<tr>
				<td class="filed_A left">SNMP감시상세 </td>
				<td class="filed_B left">
	            	<span id="snmp_mon_code_selbox">
	            		<span id="N_SNMP_MON_NAME"></span>
	            		<input type="hidden" name="N_SNMP_MON_CODE" id="N_SNMP_MON_CODE" value=""/>
	            	</span>
				</td>
				<td class="filed_A left">SNMP 기본 수집 주기(분)</td>
				<td class="filed_B left"><input type="text" name="N_TIMEM" id="N_TIMEM" class="넌숫자만" style="width:150px;" value=""></td>
			</tr>
			<tr id="process_info" style="display: none;">
				<td class="filed_A left">프로세스명 <span class="btn_pack medium"><a href="#" id="append_process">추가</a></span></td>
				<td id="process_list" class="filed_B left" colspan="3"></td>
			</tr>			
		</table>
		<!-- botton -->
		<div id="botton_align_center1">
			<a href="#" id="btn_save" class="css_btn_class">저장</a>&nbsp;&nbsp;&nbsp;
			<a href="#" id="btn_cancel" class="css_btn_class">취소</a>&nbsp;&nbsp;&nbsp;
			<a href="#" id="btn_remove" class="css_btn_class3">삭제</a>
		</div>
		<!-- botton // -->
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
	$("#snmp_map_update_form").kendoValidator().data("kendoValidator");

	initEvent();
	fn_process_info_show_hide();
	detailInfoDataSetting('${param.N_MON_ID}','${param.N_SNMP_MAN_CODE}','${param.N_SNMP_MON_CODE}');
	
	if('${param.N_SNMP_MAN_CODE}' === "12" && '${param.N_SNMP_MON_CODE}' === "5") {
		processDataSetting('${param.N_MON_ID}');	
	}
});

// process_info_show_hide
function fn_process_info_show_hide()
{
	if('${param.N_SNMP_MAN_CODE}' === "12" && '${param.N_SNMP_MON_CODE}' === "5") {
		$("#process_info").show();
	} else {
		$("#process_info").hide();
	}
}

function initEvent() {
	$('#btn_cancel').on('click', function(event) {
		event.preventDefault();
		if ( confirm("작성된 데이터를 초기화 하시겠습니까?") ) {
			clearFormData();
		}
	});

	$('#btn_save').on('click', update);

	$('#btn_remove').on('click', del);
	
	$('#btn_list').on('click', function() {
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.snmp_map.retrieve.htm').submit();
	});
	
	$('input[type=text]').focusout(function() {
		this.value = $.trim(this.value);
	});
	
	$('#append_process').on('click', function(event) {
		event.preventDefault();
		var innerHtml = '';
		innerHtml += ' <div class="div_process"> ';
		innerHtml += ' 	맵키 <input type="text" name="S_MAP_KEY" value="" class="manaint_f" style="width:200px;"/>&nbsp; ';
		innerHtml += ' 	프로세스 <input type="text" name="S_PROCESS_NAME" value="" class="manaint_f" style="width:200px;"/>&nbsp; ';
		innerHtml += ' 	별칭 <input type="text" name="S_ALIAS" value="" class="manaint_f" style="width:200px;"/>&nbsp; ';
		innerHtml += ' 	<span class="btn_pack medium"><a href="#" onclick="removeProcessField(event, this)">삭제</a></span> ';
		innerHtml += ' </div> ';

		$('#process_list').append(innerHtml);
	});
}

function removeProcessField(event, element) {
	if (event) {
		event.preventDefault ? event.preventDefault() : event.returnValue = false;
	}
	$(element).parents('.div_process').remove();
}

function clearFormData() {

	detailInfoDataSetting('${param.N_MON_ID}','${param.N_SNMP_MAN_CODE}','${param.N_SNMP_MON_CODE}');

	$("#snmp_map_update_form span.k-tooltip-validation").hide(); // kendo validator 문구 초기화
}

function detailInfoDataSetting(mon_id, snmp_man_code, snmp_mon_code){
	
	var param = {
			'N_MON_ID'	: mon_id,
			'N_SNMP_MAN_CODE'	: snmp_man_code,
			'N_SNMP_MON_CODE'	: snmp_mon_code
		};
	
	$.getJSON("<c:url value='/admin/map_snmp_map.detail_info.htm'/>", param, function(data){
	
		$("#N_MON_ID").val(data.N_MON_ID);
		$("#N_SNMP_MAN_CODE").val(data.N_SNMP_MAN_CODE);
		$("#N_SNMP_MON_CODE").val(data.N_SNMP_MON_CODE);
		$("#N_TIMEM").val(data.N_TIMEM);

		$("#S_MON_NAME").html(data.S_MON_NAME);
		$("#N_SNMP_MAN_NAME").html(data.N_SNMP_MAN_NAME);
		$("#N_SNMP_MON_NAME").html(data.N_SNMP_MON_NAME);
	});

}

function processDataSetting(mon_id){
	
	$.getJSON("<c:url value='/admin/lst_snmp_map.select_process_mon_map.htm'/>", {'N_MON_ID': mon_id}, function(data){
	
		var processList = data;
		var innerHtml = '';
		for(var i=0; i<processList.length; i++) {
			innerHtml += ' <div class="div_process"> ';
			innerHtml += ' 	맵키 <input type="text" name="S_MAP_KEY" value="' + processList[i].S_MAP_KEY +  '" class="manaint_f" style="width:200px;"/>&nbsp; ';
			innerHtml += ' 	프로세스 <input type="text" name="S_PROCESS_NAME" value="' + processList[i].S_MON_NAME + '" class="manaint_f" style="width:200px;"/>&nbsp; ';
			innerHtml += ' 	별칭 <input type="text" name="S_ALIAS" value="' + $.defaultStr(processList[i].S_ALIAS, null) + '" class="manaint_f" style="width:200px;"/>&nbsp; ';
			innerHtml += ' 	<span class="btn_pack medium"><a href="#" onclick="removeProcessField(event, this)">삭제</a></span> ';
			innerHtml += ' </div> ';
		}
		$('#process_list').append(innerHtml);
	});

}

// 삭제
function del()
{
	if(!confirm("정말 삭제 하시겠습니까?"))
		return;
	
    var tmp_delete_snmp_map = $("#N_MON_ID").val() + ";"
                     + $("#N_SNMP_MAN_CODE").val() + ";"
                     + $("#N_SNMP_MON_CODE").val();
    $("#snmp_map_delete_list").val(tmp_delete_snmp_map);
    
	var url = "<c:url value='/admin/snmp_map/delete.htm'/>";
	var param = $("form[name='snmp_map_update_form']").serialize();
	
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

function update()
{
	if($('#N_TIMEM').val()=="" || $('#N_TIMEM').val()==null){
		alert("SNMP 기본수집 주기를 입력 하셔야함");
		$('#N_TIMEM').focus();
		return;
	}
	
	//var url = "<c:url value='/admin/upd_snmp_map.update_data.htm'/>";
	var url = "<c:url value='/admin/snmp_map/update.htm'/>";
	
	var param = $("form[name='snmp_map_update_form']").serialize();
	$.post(url, param, function(str){
		var data = $.parseJSON(str);
		if(data.RSLT != null && data.RSLT > 0) {
			alert('저장되었습니다.');
			goListPage();
			return;
		}
		else {
			alert("저장 실패 하였습니다.\n" + data.ERRMSG + "");
			fn_cancel();
			return;
		}
	});
}

function goListPage(event) {
	if (event) {
		event.preventDefault ? event.preventDefault() : event.returnValue = false;
	}
	$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.snmp_map.retrieve.htm').submit();
}
</script>
