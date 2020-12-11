<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<script>

	function fn_server_detail_info()
	{
		frm.N_MON_ID.value = mon_id;
		frm.target = "ifm_sub";
		if(style_code == "2" && snmp_man_code == "2")
		{
			frm.action = "<c:url value='/watcher/go_server_detail.server_detail_info.server_detail_info_snmp_cm.htm?req_data=svr_info;ServerDetailInfoQry:map'/>";
		}
		else if(style_code == "2" && snmp_man_code == "3")
		{
			if(vg_name != null)
			{
				if(vg_name.toUpperCase() == 'VG224')
				{
					frm.action = "<c:url value='/watcher/go_server_detail.server_detail_info.server_detail_info_snmp_vg224.htm?req_data=svr_info;ServerDetailInfoQry:map'/>";
				}
				else if(vg_name.toUpperCase() == 'VG3945')
				{
					frm.action = "<c:url value='/watcher/go_server_detail.server_detail_info.server_detail_info_snmp_vg3945.htm?req_data=svr_info;ServerDetailInfoQry:map|data_cnt;SnmpM03DatacntQry:map'/>";
				}
				else if(vg_name.toUpperCase() == 'NOMODEL')
				{
					frm.action = "<c:url value='/watcher/go_server_detail.server_detail_info.server_detail_info_snmp_vg224.htm?req_data=svr_info;ServerDetailInfoQry:map'/>";
				}
				else
				{
					frm.action = "<c:url value='/watcher/go_server_detail.server_detail_info.server_detail_info_snmp_vg.htm?req_data=svr_info;ServerDetailInfoQry:map|data_cnt;SnmpM03DatacntQry:map'/>";
				}
			}
			else
			{
				frm.action = "<c:url value='/watcher/go_server_detail.server_detail_info.server_detail_info_snmp_vg.htm?req_data=svr_info;ServerDetailInfoQry:map|data_cnt;SnmpM03DatacntQry:map'/>";
			}
		}
		else if(style_code == "2" && snmp_man_code == "4")
		{
			frm.action = "<c:url value='/watcher/go_server_detail.server_detail_info.server_detail_info_snmp_switch.htm?req_data=svr_info;ServerDetailInfoQry:map'/>";
		}
		else if(style_code == "2" && snmp_man_code == "7")
		{
			frm.action = "<c:url value='/watcher/go_server_detail.server_detail_info.server_detail_info_snmp_l4switch.htm?req_data=svr_info;ServerDetailInfoQry:map'/>";
		}
		else if(style_code == "2" && snmp_man_code == "8")
		{
			frm.action = "<c:url value='/watcher/go_server_detail.server_detail_info.server_detail_info_snmp_fw.htm?req_data=svr_info;ServerDetailInfoQry:map|data_cnt;ServerDetailDatacnt_Fw:map'/>";
		}
		else if(style_code == "2" && type_code == "1000" && snmp_man_code == "1")
		{
			frm.action = "<c:url value='/watcher/go_server_detail.server_detail_info.server_detail_info_snmp_avaya_cm_g650.htm?req_data=svr_info;ServerDetailInfoQry:map|data_cnt;ServerDetailDatacnt_AvayaCm:map'/>";
		}
		else if(style_code == "0" && type_code == "3000")
		{
			frm.action = "<c:url value='/watcher/go_server_detail.server_detail_info.server_detail_info_ivr.htm?req_data=svr_info;ServerDetailInfoQry|data_cnt;ServerDetailDatacnt_Agent:map'/>";
		}
		else if(style_code == "2" && type_code == "9001" && snmp_man_code == "9")
		{
			frm.action = "<c:url value='/watcher/go_server_detail.server_detail_info.server_detail_info_snmp_ups.htm?req_data=svr_info;ServerDetailInfoQry|data_cnt;ServerDetailDatacnt_Ups:map'/>";
		}
		else if(style_code == "2" && type_code == "9002" && snmp_man_code == "10")
		{
			frm.action = "<c:url value='/watcher/go_server_detail.server_detail_info.server_detail_info_snmp_temphumi.htm?req_data=svr_info;ServerDetailInfoQry|data_cnt;ServerDetailDatacnt_TempHumidity:map'/>";
		}
		else if(style_code == "2" && snmp_man_code == "11")
		{
			frm.action = "<c:url value='/watcher/go_server_detail.server_detail_info.server_detail_info_snmp_switch11.htm?req_data=svr_info;ServerDetailInfoQry:map'/>";
		}
		else if(style_code == "2" && snmp_man_code == "12")
		{
			frm.action = "<c:url value='/watcher/go_server_detail.server_detail_info.server_detail_info_snmp_switch12.htm?req_data=svr_info;ServerDetailInfoQry:map'/>";
		}
		else if(style_code == "2" && snmp_man_code == "13")
		{
			frm.action = "<c:url value='/watcher/go_server_detail.server_detail_info.server_detail_info_snmp_switch13.htm?req_data=svr_info;ServerDetailInfoQry:map|data_cnt;SnmpM13DatacntQry:map'/>";
		}
		else if(style_code == "2" && snmp_man_code == "14")
		{
			frm.action = "<c:url value='/watcher/go_server_detail.server_detail_info.server_detail_info_snmp_switch14.htm?req_data=svr_info;ServerDetailInfoQry:map|data_cnt;SnmpM14DatacntQry:map'/>";
		}
		else
		{
			if(type_code == "8000")
				frm.action = "<c:url value='/watcher/go_server_detail.server_detail_info.server_detail_info_poe.htm?req_data=svr_info;ServerDetailInfoQry'/>";
			else if(type_code == "4000")
				frm.action = "<c:url value='/watcher/go_server_detail.server_detail_info.server_detail_info_poe.htm?req_data=svr_info;ServerDetailInfoQry'/>";
			else
				frm.action = "<c:url value='/watcher/go_server_detail.server_detail_info.server_detail_info.htm?req_data=svr_info;ServerDetailInfoQry:map|data_cnt;ServerDetailDatacnt_Agent:map'/>";
		}
		frm.submit();
	}

	function fn_map_screen()
	{
		frm.N_GROUP_CODE.value = grp_code;
		frm.S_GROUP_FULL_CODE.value = full_grp_code;
		
		frm.target = "ifm_sub";
		frm.action = "realtime_stats.map.neonex";
		frm.submit();
	}

	var img_url;
	var full_grp_code;
	var grp_code;
	$(function() {
		$("select[name='N_GROUP_CODE']").change(function() {
			grp_code = $(this).val();

			$("select[name='N_TYPE_CODE']").val('');
			$("select[name='S_VG_FILTER_TXT']").val('');
			$("select[name='S_CM_TYPE']").val('');
			$("select[name='B_CON_INFO']").val('');

			fn_save_map_pos();
		});

		$("select[name='N_TYPE_CODE']").change(function() {
			grp_code = $("select[name='N_GROUP_CODE']").val();
			$("select[name='S_VG_FILTER_TXT']").val('');
			$("select[name='S_CM_TYPE']").val('');
			$("select[name='B_CON_INFO']").val('');

			fn_save_map_pos();
		});

		$("select[name='S_CM_TYPE']").change(function(){
			grp_code = $("select[name='N_GROUP_CODE']").val();

			fn_save_map_pos();
		});

		$("select[name='S_VG_FILTER_TXT']").change(function() {
			grp_code = $("select[name='N_GROUP_CODE']").val();

			fn_save_map_pos();
		});

		$("select[name='B_CON_INFO']").change(function() {
			grp_code = $("select[name='N_GROUP_CODE']").val();

			fn_save_map_pos();
		});

		$("#svr_lst li").click(function(){
			$("#svr_lst li").css("font-weight","normal");
			$(this).css("font-weight","bold");

			mon_id = $(this).children("input[name='N_MON_ID']").val();
			style_code = $(this).children("input[name='N_STYLE_CODE']").val();
			snmp_man_code = $(this).children("input[name='N_SNMP_MAN_CODE']").val();
			vg_name = $(this).children("input[name='S_VG_NAME']").val();

			fn_server_detail_info();
		});

		$("select[name='N_GROUP_CODE']").eq(0).change();

		$("#svr_lst li").eq(0).click();
	});
	var grp_code;
	var mon_id;
	var style_code;
	var snmp_man_code;
	var vg_name;
	var type_code;

	function goPage(pageNo) {
		fn_save_map_pos(pageNo);
	}

	function fn_save_map_pos(pageNo)
	{
		var param = {
			"N_GROUP_CODE" : grp_code
			, "S_FIND_STR" : $("#S_FIND_STR").val()
			, "N_TYPE_CODE" : $("select[name='N_TYPE_CODE']").val()
			, "S_VG_FILTER_TXT" : $("select[name='S_VG_FILTER_TXT']").val()
			, "S_CM_TYPE" : $("select[name='S_CM_TYPE']").val()
			, "B_CON_INFO" : $("select[name='B_CON_INFO']").val()
			, "currentPageNo" : pageNo ? pageNo : 1
		};
		$("#svr_lst").html("");
		$.getJSON("<c:url value='/watcher/pagination_SvrLstQry2.htm'/>", param, function(data) {

			var list = data.list,
				paginationInfo = data.paginationInfo;

			if(list.length == void 0){
				$("#total_cnt").text("건수 : 0");
				$("#div_pagenum").text("0/0" );
				return;
			}
			$(list).each(function(){
				$("<li class='bt_off'/>")
				.append([
						 	"<input type='hidden' name='N_MON_ID' value='" + this.N_MON_ID + "'>"
							, "<input type='hidden' name='N_STYLE_CODE' value='" + this.N_STYLE_CODE + "'>"
							, "<input type='hidden' name='N_TYPE_CODE' value='" + this.N_TYPE_CODE + "'>"
							, "<input type='hidden' name='N_SNMP_MAN_CODE' value='" + this.N_SNMP_MAN_CODE + "'>"
							, "<input type='hidden' name='S_VG_NAME' value='" + this.S_VG_NAME + "'>"
							, "<a href='javascript:'>"+this.S_MON_NAME+"</a>"
						]).appendTo("#svr_lst");
			});

			var request = $.ajax({
				url : '<c:url value='/watcher/pagination.htm'/>',
				method : 'post',
				data : paginationInfo,
				dataType : 'html'
			});

			request.done(function(data) {
				$('.paginate_s').html(data);
			});

			$("#svr_lst li").click(function(){
				$("#svr_lst li").attr("class","bt_off");
				$(this).attr("class","bt_on");
								
				mon_id = $(this).children("input[name='N_MON_ID']").val();
				style_code = $(this).children("input[name='N_STYLE_CODE']").val();
				snmp_man_code = $(this).children("input[name='N_SNMP_MAN_CODE']").val();
				vg_name = $(this).children("input[name='S_VG_NAME']").val();
				type_code = $(this).children("input[name='N_TYPE_CODE']").val();

				fn_server_detail_info();
			});
			
			if('${param.N_GROUP_CODE}' == '')
			{
				$("#svr_lst li").eq(0).click();
			}
			else
			{
				$("#svr_lst li").each(function(){
					if($(this).children("input[name='N_MON_ID']").val() == '${param.N_MON_ID}')
						$(this).click();
				});
			}

			$("#svr_lst li").each(function(idx){
				if(idx > tmp_page_row_cnt-1)
				{
					$(this).hide();
				}
			});
			tmp_now_page = 1;
			$("#div_pagenum").text(tmp_now_page + "/" + Math.ceil($("#svr_lst li").length/tmp_page_row_cnt));
			
			$("#total_cnt").text("건수 : " + paginationInfo.totalRecordCount);
		});
	}

	var tmp_now_page = 1;
	var tmp_page_row_cnt = 20;
	var tmp_total_page = 3;

	function fn_svr_next_click()
	{
		if(tmp_now_page >= ($("#svr_lst li").length/tmp_page_row_cnt)) return;

		tmp_now_page++;

		$("#svr_lst li").each(function(idx){
			var tmp_now_row_cnt = idx+1;
			if(tmp_now_row_cnt > ((tmp_now_page-1)*tmp_page_row_cnt) && tmp_now_row_cnt <= (tmp_now_page*tmp_page_row_cnt))
			{
				$(this).show();
			}
			else
			{
				$(this).hide();
				if(tmp_now_page*tmp_page_row_cnt < tmp_now_row_cnt)
				{
					return false;
				}
			}
		});

		$("#div_pagenum").text(tmp_now_page + "/" + Math.ceil($("#svr_lst li").length/tmp_page_row_cnt));
	}

	function fn_svr_prev_click()
	{
		if(tmp_now_page <= 1) return;

		tmp_now_page--;
		$("#svr_lst li").each(function(idx){
			var tmp_now_row_cnt = idx+1;
			if(tmp_now_row_cnt > ((tmp_now_page-1)*tmp_page_row_cnt) && tmp_now_row_cnt <= (tmp_now_page*tmp_page_row_cnt))
			{
				$(this).show();
			}
			else
			{
				$(this).hide();
				if((tmp_now_page+1)*tmp_page_row_cnt < tmp_now_row_cnt)
				{
					return false;
				}
			}
		});

		$("#div_pagenum").text(tmp_now_page + "/" + Math.ceil($("#svr_lst li").length/tmp_page_row_cnt));
	}

	function fn_svr_first_click()
	{
		tmp_now_page = 0;
		$("#svr_lst li").hide();

		fn_svr_next_click();
	}

	function fn_svr_last_click()
	{
		if($("#svr_lst li").length == 0){
			return;
		}
		tmp_now_page = Math.ceil($("#svr_lst li").length/tmp_page_row_cnt)-1;
		$("#svr_lst li").hide();

		fn_svr_next_click();
	}


  	function fn_get_grp_list()
  	{
  		
  		var param = "";

  		param += "GRP_NAME=" + $("input[name='S_FIND_STR_GRP']").val();

  		$.post("<c:url value='/watcher/lst_json_grpLstQry.htm'/>", param, function(data){
  			
  			var tmp_obj = eval('(' + data + ')');
  			var tmp_grp_str = "";

      		tmp_grp_str += "<select name='N_GROUP_CODE' style='width:115;'>"

      		if( $("input[name='S_FIND_STR_GRP']").val() == "")
      		{
      			tmp_grp_str += "<option value=''>전체</option>";
      		}

  			$(tmp_obj).each(function(idx){
  				
  				var val = this.VAL;
  				
  				if(jQuery.type(val) != 'undefined'){
  					tmp_grp_str += "<option value='" + this.CODE  + "'>" + this.VAL  + "</option>";
  				} else {
  					tmp_grp_str += "<option value=' '> 없음 </option>";
  				}
  				
  			});

      		tmp_grp_str += "</select>";

      		$("#div_svr_grp_cmb").html(tmp_grp_str);

      		$("select[name='N_GROUP_CODE']").change(function() {
    			grp_code = $(this).val();

    			fn_save_map_pos();
    		});
      		$("select[name='N_GROUP_CODE']").change();
  		});
  	}

  	$(function() {
  		$(".input_search_grp").keypress(function(event){
  	         if(kendo.keys.ENTER === event.keyCode)
  	        	 $(".btn_search_grp").click();
  	    });
  	});
  	
  	$(function() {
  		$(".input_search_svr").keypress(function(event){
  	         if(kendo.keys.ENTER === event.keyCode)
  	        	 $(".btn_search_svr").click();
  	       });
  	});
  	
	$(function(){
		$("select[name='N_TYPE_CODE']").change(function(){
			//alert($("select[name='N_TYPE_CODE'] option:selected").val());
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
	
	function init()
	{
		if('${param.N_GROUP_CODE}' != '')
		{
			grp_code = '${param.N_GROUP_CODE}';
			//fn_save_map_pos();
		}
	}

</script>
<body onload="init()">
 
<form name="frm" method="post">
	<input type="hidden" name="N_GROUP_CODE" value="-1">
	<input type="hidden" name="N_MON_ID" value="-1">
</form>

<!--Wrapper-->
<div id="wrapper">
	<!--Content-->
	<div id="container">
		<!--왼쪽영역-->
		<div id="left">
			<!--검색박스-->
			<div class="searchbox01">
				<div class="searchbox01_wrap">
					<ul>
						<li class="searchbox01_title">감시그룹 검색</li>
						<li class="searchbox01_left">그룹</li>
						<li class="searchbox01_right">
							<div class="item"><input title="그룹" class="input_search_grp" style="width:125px;" id="S_FIND_STR_GRP" name="S_FIND_STR_GRP" value=""/><a href="#"><img src="${img2}/btn_search02.gif" alt="검색" border="0" style="vertical-align:middle" class="btn_search_grp" onclick="fn_get_grp_list()" /></a></div>
						</li>
						<li class="searchbox01_full">
							<div class="item">
								<cmb:combo qryname="cmb_svr_group" firstdata="전체" seltagname="N_GROUP_CODE" etc="style=\"width:100%;\"" selvalue="${param.N_GROUP_CODE}"/>
							</div>
						</li>
						<li class="searchbox01_left">타입</li>
						<li class="searchbox01_right">
							<div class="item">
								<cmb:combo qryname="cmb_svr_type" firstdata="전체" seltagname="N_TYPE_CODE" etc="style=\"width:100%;\"" selvalue="${param.N_TYPE_CODE}"/>
							</div>
							<div class="item" id="cmb_cm_type" style="display:none;">
								<SELECT name="S_CM_TYPE" style="width:100%;">
									<option value="">선택</option>
									<option value="Call서버">Call서버</option>
									<option value="기타">기타</option>
								</SELECT>
							</div>
						</li>
						<li class="searchbox01_left">장비</li>
						<li class="searchbox01_right">
							<div class="item"><input title="장비" class="input_search_svr" style="width:125px;" id="S_FIND_STR" name="S_FIND_STR" value=""/><a href="#"><img src="${img2}/btn_search02.gif" alt="검색" border="0" style="vertical-align:middle" onclick="fn_save_map_pos()" /></a></div>
						</li>
						<li class="searchbox01_left">연결</li>
						<li class="searchbox01_right">
							<div class="item">
								<select style="width:100%;" name="B_CON_INFO"><option value="">전체</option><option value="Y">연결</option><option value="N">연결안됨</option></select>
							</div>
						</li>
					</ul>
				</div>
			</div>
			<!--//검색박스-->
			<!--검색건수-->
			<div class="lmenu_searchr"><span style="font-weight:bold; color:#06F" id="total_cnt"></span></div>
			<!--//검색건수-->
			<!--왼쪽메뉴-->
			<div class="lmenu">
				<ul id="svr_lst"></ul>
			</div>
			<!--//왼쪽메뉴-->
			<!--paginate_s-->
			<div style="float:left; width:100%;">
				<div class="paginate_s">
				</div>
			</div>
			<!--//paginate_s-->
		</div>
		<!--//왼쪽영역-->
	
		<!--//내용-->
		<div id="wrap_content">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
		      <%-- <td height="100%" valign="top" background="${img2}/bg_center.jpg" style="background-repeat:no-repeat"> --%>
		      <td height="100%" valign="top">
		      	<iframe name="ifm_sub" src="" width="100%" height="780" frameborder="0" scrolling="no"></iframe>
		      </td>
			</tr>
		</table>
		</div>
		<!--//내용-->
	</div>
	<!--//Content-->
</div>
</body>