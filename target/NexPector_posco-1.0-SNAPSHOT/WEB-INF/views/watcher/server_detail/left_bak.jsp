<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<script type="text/javascript" src="<c:url value="/js/jquery-extend.js" />"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.blockUI.js"/>"></script>
<script type="text/javascript">

	$(document).ready(function() {

		$(".svr_search").keypress(function(event){
			if(kendo.keys.ENTER === event.keyCode)
				fn_save_map_pos();
		});

		$("select[name='N_GROUP_CODE'], select[name='N_TYPE_CODE'], select[name='S_CM_TYPE'], select[name='B_CON_INFO']").change(function() {
			fn_save_map_pos();
		});

		fn_save_map_pos('${param.pageNum}');
	});

	function fn_save_map_pos(pageNo) {
		var param = {
				"N_GROUP_CODE" 		: $("select[name='N_GROUP_CODE']").val()
				, "S_FIND_STR" 		: $("#S_FIND_STR").val()
				, "N_TYPE_CODE" 	: $("select[name='N_TYPE_CODE']").val()
				, "S_CM_TYPE" 		: $("select[name='S_CM_TYPE']").val()
				, "B_CON_INFO" 		: $("select[name='B_CON_INFO']").val()
				, "currentPageNo" 	: pageNo ? pageNo : 1
				, "pageSize"		: 15
			};

		$(".avaya_leftNv").empty();
		$.post(cst.contextPath() + '/watcher/pagination_SvrLstQry2.htm', param, function(data) {
			var list 			= data.list,
				paginationInfo 	= data.paginationInfo;

			if(list.length == void 0){
				$("#total_cnt").text("건수 : 0");
				return;
			}

			$(list).each(function() {
				var css = "";
				if (parseInt('${N_MON_ID}') === this.N_MON_ID) {
					css = 'class="selected"';
				}
				$("<li/>")
					.append([
						"<input type='hidden' name='N_MON_ID' value='" + this.N_MON_ID + "'>"
						, "<input type='hidden' name='N_STYLE_CODE' value='" + this.N_STYLE_CODE + "'>"
						, "<input type='hidden' name='N_TYPE_CODE' value='" + this.N_TYPE_CODE + "'>"
						, "<input type='hidden' name='N_SNMP_MAN_CODE' value='" + this.N_SNMP_MAN_CODE + "'>"
						, "<input type='hidden' name='S_VG_NAME' value='" + this.S_VG_NAME + "'>"
						, "<a href='#' " + css + ">" + this.S_MON_NAME + "</a>"
					]).appendTo(".avaya_leftNv");
			});

			var request = $.ajax({
				url 		: cst.contextPath() + "/watcher/pagination.htm",
				method 		: 'post',
				data 		: paginationInfo,
				dataType 	: 'html'
			});

			request.done(function(data) {
				$('.paginate_s').html(data);
			});

			$(".avaya_leftNv li").click(function(event) {
				event.preventDefault();
				goLeftMenu(this, null, pageNo);
			});

			$("#total_cnt").text("건수 : " + paginationInfo.totalRecordCount);

		}, 'json');
	}

	function goLeftMenu(obj, tabStrip, pageNo) {
		var mon_id 			= $(obj).children("input[name='N_MON_ID']").val();
		var style_code 		= $(obj).children("input[name='N_STYLE_CODE']").val();
		var snmp_man_code 	= $(obj).children("input[name='N_SNMP_MAN_CODE']").val();
		var vg_name 		= $(obj).children("input[name='S_VG_NAME']").val();
		var type_code 		= $(obj).children("input[name='N_TYPE_CODE']").val();
		fn_server_detail_info(style_code, snmp_man_code, vg_name, type_code, mon_id, tabStrip, pageNo);
	}

	function goPage(pageNo) {
		fn_save_map_pos(pageNo);
	}

	function fn_get_grp_list() {
		$.post(cst.contextPath() + '/watcher/lst_json_grpLstQry.htm', param, function(data) {
			var tmp_obj = eval('(' + data + ')');
			var tmp_grp_str = "<select name='N_GROUP_CODE' style='width:145px;'>";

			tmp_grp_str += "<option value=''>전체</option>";
			$(tmp_obj).each(function(idx) {
				if(jQuery.type(this.VAL) != 'undefined'){
					tmp_grp_str += "<option value='" + this.CODE  + "'>" + this.VAL  + "</option>";
				} else {
					tmp_grp_str += "<option value=' '> 없음 </option>";
				}
			});
			tmp_grp_str += "</select>";

			$("#div_svr_grp_cmb").html(tmp_grp_str);

			$("select[name='N_GROUP_CODE']").change(function() {
				fn_save_map_pos();
			});

			$("select[name='N_GROUP_CODE']").change();
		});
	}

	function fn_server_detail_info(style_code, snmp_man_code, vg_name, type_code, mon_id, tabStrip, pageNo) {

		var url 		= cst.contextPath() + "/watcher/server_detail/monitoring.htm",
			param 		= {
				"N_MON_ID" 		: mon_id,
				"N_GROUP_CODE"	: $('select[name=N_GROUP_CODE]').val(),
				"N_TYPE_CODE"	: $('select[name=N_TYPE_CODE]').val(),
				"S_FIND_STR"	: $('#S_FIND_STR').val(),
				"B_CON_INFO"	: $('select[name=B_CON_INFO]').val(),
				"style_code" 	: $.defaultStr(style_code, 0),
				"snmp_man_code" : $.defaultStr(snmp_man_code, 0),
				"vg_name" 		: $.defaultStr(vg_name),
				"type_code" 	: $.defaultStr(type_code, 0),
				"tabStrip"		: tabStrip ? tabStrip : '',
				"menu"			: 'mnavi01_02',
				"pageNum"		: pageNo ? pageNo : 1,
				"menulink"		: 'S'
			};

		//		$('#c_start').load(url, ($('#frm').serialize() + '&' + $.param(param)));


		$.blockUI(blockUIOption);
		location.href = url + '?' + $('#frm').serialize() + '&' + $.param(param);

		/*$.blockUI(blockUIOption);
		$.get(url, $('#frm').serialize() + '&' + $.param(param))
			.done(function(html) {
				$('#c_start').html(html);
			})
			.fail(function(jqXHR) {
				console.log(jqXHR.status);
			})
			.always(function() {
				$.unblockUI();
			});*/
	}
</script>

<form name="frm" method="post">
	<input type="hidden" name="N_GROUP_CODE" value="-1">
	<input type="hidden" name="N_MON_ID" value="-1">
</form>

<!-- left_top -->
<dl class="avaya_leftBox">
	<dt>감시그룹 검색</dt>
	<dd style="padding-top:15px;">
		<div class="search_area">
			<span class="filed_1">그룹</span>
			<cmb:combo qryname="cmb_svr_group" firstdata="전체" firstval="-1" seltagname="N_GROUP_CODE" etc="style=\"width:145px\"" selvalue="${param.N_GROUP_CODE}" />
		</div>
		<div class="search_area">
			<span class="filed_2">타입</span>
			<span class="filed_2c">
				<cmb:combo qryname="cmb_svr_type" firstdata="전체" seltagname="N_TYPE_CODE" etc="style=\"width:145px;\"" selvalue="${param.N_TYPE_CODE}"/>
			</span>
		</div>
		<div class="item" id="cmb_cm_type" style="display:none;">
			<SELECT name="S_CM_TYPE" style="width:145px;">
				<option value="">선택</option>
				<option value="Call서버">Call서버</option>
				<option value="기타">기타</option>
			</SELECT>
		</div>
	</dd>
	<dd style="padding-top:15px;">
		<div class="search_area">
			<span class="filed_1">장비</span>
			<span class="filed_1c">
			<input title="장비" class="input_search_svr svr_search" id="S_FIND_STR" name="S_FIND_STR" value="${param.S_FIND_STR}"><a href="#"><img src="/images/botton/btn_search02.gif" alt="검색" onclick="fn_save_map_pos()" /></a></span>
		</div>
		<div class="search_area">
			<span class="filed_2">연결</span>
			<span class="filed_2c">
				<select style="width:145px;" name="B_CON_INFO">
					<option value="">전체</option>
					<option value="Y" <c:if test="${param.B_CON_INFO eq 'Y'}">selected</c:if>>연결</option>
					<option value="N" <c:if test="${param.B_CON_INFO eq 'N'}">selected</c:if>>연결안됨</option>
				</select>
			</span>
		</div>
	</dd>
</dl>
<!-- left_top // -->
<!--검색건수-->
<div class="total_nm"><span style="font-weight:bold; color:#06F" id="total_cnt"></span></div>
<!--//검색건수-->
<!--왼쪽메뉴-->
<ul class="avaya_leftNv"></ul>
<!--//왼쪽메뉴-->
<!--paginate_s-->
<div style="float:left; width:100%;">
	<div class="paginate_s"></div>
</div>
<!--//paginate_s-->