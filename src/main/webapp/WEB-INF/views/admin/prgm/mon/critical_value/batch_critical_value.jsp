<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="/WEB-INF/views/include/include.jsp" %>

<jsp:useBean id="data" class="java.util.ArrayList" scope="request"/>
<%
	String action_file = "equipment_critical_value_mgr";
%>
<script src="<c:url value="/common/js/stupidtable.js"/>"></script>
<script>
	function fn_validation_chk()
	{
		for(i=0;i<6;i++)
		{
			if(i<4)
			{
				if(!cfn_empty_valchk(eval("frm.cpu_key_"+i), "임계치 값") || !cfn_empty_valchk(eval("frm.mem_key_"+i), "임계치 값") || !cfn_empty_valchk(eval("frm.disk_key_"+i), "임계치 값")) {
					return false;
				}
			}
			if(!cfn_empty_valchk(eval("frm.process_key_"+i), "임계치 값") || !cfn_empty_valchk(eval("frm.service_key_"+i), "임계치 값")) {
				return false;
			}
		}
		
		return true;
	}
	function fn_save()
	{
		if(!fn_validation_chk())
			return;
		
// 		frm.target = "";
// 		frm.action="<c:url value="/admin/reg_critical_value.htm"/>";
// 		frm.submit();
		var svr_id = "";
		$("input[name='N_MON_ID']:checked").each(function(){
			svr_id += $(this).val() + ";";
		});
		
		$("input[name='SVR_ID']").val(svr_id);

		for(var i=0;i<$("input[name='N_MON_ID']:checked").length;i++)
		{
			svr_id += $("input[name='N_MON_ID']:checked").eq(i).val() + ";";
		}


		var param = $("form[name='frm']").serialize();
		$.post("<c:url value="/admin/reg_critical_value.htm"/>", param, function(str){
			var data = $.parseJSON(str);
			
			alert(data.RSLT);
		});
	}
	
	function fn_cancel()
	{
		frm.target = "";
		frm.action="<%=action_file%>.init.neonex";
		frm.submit();
	}
	
	<!-- 수정 -->
	function fn_update(name, val)
	{
		parent.fn_update(name, val);
	}
	
	function init()
	{
		
	}
	
	function fn_row_click(obj, row)
	{
		if(obj.length > 1)
		{
			if(obj[row].checked)
			{
				obj[row].checked = false;				
			}
			else
			{
				obj[row].checked = true;				
			}			
		}
		else
		{
			if(obj.checked)
			{
				obj.checked = false;				
			}
			else
			{
				obj.checked = true;				
			}
		}
	}
	
	function fn_allchk(obj, val)
	{
		try{
			if(obj.length > 1)
			{
				for(i=0;i<obj.length;i++)
				{
					obj[i].checked = val;
				}
			}
			else
			{
				obj.checked = val;
			}
		}catch(e){}
		
	}
			
</script>
<body onload="init()">
<form name="frm" method="post">
<input type="hidden" name="SVR_ID" value="">
<%
	//request.getParameterNames();
	java.util.Enumeration en = request.getParameterNames();
			
	while(en.hasMoreElements())
	{
		String name = (String)en.nextElement();
		if(name.equals("nowpage"))
			out.print("<input type=\"hidden\" name=\""+name+"\" value=\""+request.getParameter(name)+"\">\n");
	}
%>
<script>
$(function(){
	$("select[name='N_TYPE_CODE']").change(function(){
		cfn_get_jdata("<c:url value="/admin/lst_common.svrlist.htm"/>?N_TYPE_CODE="+$(this).val(), "fn_svr_list");
		
		var tmp_alm_type;
		
		if($(this).val() == "1000")
		{
			tmp_alm_type = "14002";
		}
		else if($(this).val() == "2000")
		{
			tmp_alm_type = "14003";
		}
		else if($(this).val() == "3000")
		{
			tmp_alm_type = "10001";
		}
		
		cfn_get_jdata("<c:url value="/admin/lst_common.almcode.htm"/>?N_ALM_TYPE="+tmp_alm_type, "fn_alm_code");
	});
});

var tmp_xxxx;

function fn_svr_list(data)
{
	tmp_xxxx = data;
	setTimeout("fn_loding_svr_list()", 10);
}

var max_cnt = 100;
var now_cnt = 0;
function fn_loding_svr_list(){
	max_cnt = tmp_xxxx.length;
	
	var str = "";
	
	if(now_cnt == 0)
	{
		$("#div_svr_list .data_body tbody").html("");
		$("body").append("<div id='loading_bar' style='width:220px;height:20px;background-image:url(<c:url value="/common/images/loading/loading_bar.gif"/>);'>&nbsp;&nbsp;&nbsp;&nbsp;<font color='black'><b>서버 목록을 불러오는 중 입니다.</b></font></div>");//right side
		var div_left = parseInt($("body").css("width")) / 2.5;
		var div_top = parseInt($("body").css("height")) / 3;
		$('#loading_bar').css({position: "absolute", left: div_left+"px", top: div_top+"px"});
		$('#loading_bar').show();
	}
	
	var tmp_cnt = now_cnt + 200; 
	if(tmp_cnt > tmp_xxxx.length) tmp_cnt = tmp_xxxx.length;
	
	while(now_cnt < tmp_cnt)
	{
		str += '<tr bgcolor="#FFFFFF" align="center" id="t_row" style="cursor:hand;display:none;" class="tbody_tr cls_svt_lst">';
		str += '<td width="8%" class="line_gray">&nbsp;';
		str += '<input type="checkbox" id="chk_svr_id" name="N_MON_ID" style="cursor:hand;" value="' + tmp_xxxx[now_cnt].N_MON_ID + '">&nbsp;';
		str += '<input type="hidden" name="N_TYPE_CODE" class="type_code" value="' + this.N_TYPE_CODE + '">';
		str += '</td>';
		str += '<td width="15%" class="line_gray">&nbsp;' + tmp_xxxx[now_cnt].N_MON_ID + '&nbsp;</td>';
		str += '<td width="35%" class="line_gray">&nbsp;' + tmp_xxxx[now_cnt].S_MON_NAME + '&nbsp;</td>';
		str += '<td width="45%" class="line_gray">&nbsp;' + tmp_xxxx[now_cnt].S_MON_IP + '&nbsp;</td>';						
		str += '</tr>';
		
		now_cnt++;
	}
	
	$("#div_svr_list .data_body tbody").append(str);

	if(max_cnt > now_cnt)
	{
		setTimeout("fn_loding_svr_list()", 10);
	}
	else
	{
		now_cnt = 0;
		
		$(".cls_svt_lst input:checkbox").click(function(){
			if($(this).is(":checked"))
				$(this).attr("checked", false);
			else
				$(this).attr("checked", true);
		});
		$(".cls_svt_lst").click(function(){
   			if($(this).children("td").children("input:checkbox").is(":checked"))
   			{
   				$(this).children("td").children("input:checkbox").attr("checked", false);
   				$(this).css("background-color", "#FFFFFF");
   			}
   			else
   			{
   				$(this).children("td").children("input:checkbox").attr("checked", true);
   				$(this).css("background-color", "#FFCFB4");
   			}
   		});
   		
		$('#loading_bar').remove();
		fn_svr_first_click();
		$("#div_pagenum").text(tmp_now_page + "/" + Math.ceil($(".cls_svt_lst").length/tmp_page_row_cnt));
	}
}
//스크립트 페이징 관련
	var tmp_now_page = 1;
var tmp_page_row_cnt = 21;
var tmp_total_page = 3;

function fn_svr_next_click()
{
	if(tmp_now_page >= ($(".cls_svt_lst").length/tmp_page_row_cnt)) return;
	
	tmp_now_page++;
	
	$(".cls_svt_lst").each(function(idx){
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
	
	$("#div_pagenum").text(tmp_now_page + "/" + Math.ceil($(".cls_svt_lst").length/tmp_page_row_cnt));
}

function fn_svr_prev_click()
{
	if(tmp_now_page <= 1) return;
	
	tmp_now_page--;
	$(".cls_svt_lst").each(function(idx){
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
	
	$("#div_pagenum").text(tmp_now_page + "/" + Math.ceil($(".cls_svt_lst").length/tmp_page_row_cnt));
}

function fn_svr_first_click()
{
	tmp_now_page = 0;
	$(".cls_svt_lst").hide();
	
	fn_svr_next_click();
}

function fn_svr_last_click()
{
	tmp_now_page = Math.ceil($(".cls_svt_lst").length/tmp_page_row_cnt)-1;
	$(".cls_svt_lst").hide();
	
	fn_svr_next_click();
}
</script>
<table width="100%" height="">
	<tr>
		<td width="40%">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td height="29" colspan="5" class="b gray pl10"><img src="${img1}/icon_arrow.png" align="absmiddle">서버리스트<span id="xzxz"></span>
									<cmb:combo qryname="cmb_svr_type" seltagname="N_TYPE_CODE" firstdata="선택" etc="class=\"input_search\" style=\"width:100;\""/>
									<!--<cmb:combo qryname="cmb_snmp_man_code" seltagname="N_SNMP_MAN_CODE" firstdata="선택" etc="class=\"input_search\" style=\"width:100;\""/>-->
									<script>
										function cfn_get_jdata(url, func_name)
										{
											$.post(url, function(data){
												var tmp_obj = null;
												try{
													tmp_obj = eval('(' + data +')');
													eval(func_name)(tmp_obj);
												}catch(e){}
												finally{
													tmp_obj = null;
												}
											});
										}
									
										$(function(){
											$("select[name='N_TYPE_CODE']").change(function(){
												cfn_get_jdata("<c:url value="/admin/lst_common.svrlist.htm"/>?N_TYPE_CODE="+$(this).val(), "fn_svr_list");
												
												var tmp_alm_type;
												
												if($(this).val() == "1000")
												{
													tmp_alm_type = "14002";
												}
												else if($(this).val() == "2000")
												{
													tmp_alm_type = "14003";
												}
												else if($(this).val() == "3000")
												{
													tmp_alm_type = "10001";
												}
												
												cfn_get_jdata("<c:url value="/admin/lst_common.almcode.htm"/>?N_ALM_TYPE="+tmp_alm_type, "fn_alm_code");
											});
										});
										
										var tmp_xxxx;
										
										function fn_svr_list(data)
										{
											tmp_xxxx = data;
											setTimeout("fn_loding_svr_list()", 10);
										}
										
										var max_cnt = 100;
										var now_cnt = 0;
										function fn_loding_svr_list(){
											max_cnt = tmp_xxxx.length;
											
											var str = "";
											
											if(now_cnt == 0)
											{
												$("#div_svr_list .data_body tbody").html("");
												$("body").append("<div id='loading_bar' style='width:220px;height:20px;background-image:url(<c:url value="/common/images/loading/loading_bar.gif"/>);'>&nbsp;&nbsp;&nbsp;&nbsp;<font color='black'><b>서버 목록을 불러오는 중 입니다.</b></font></div>");//right side
												var div_left = parseInt($("body").css("width")) / 2.5;
												var div_top = parseInt($("body").css("height")) / 3;
												$('#loading_bar').css({position: "absolute", left: div_left+"px", top: div_top+"px"});
												$('#loading_bar').show();
											}
											
											var tmp_cnt = now_cnt + 200; 
											if(tmp_cnt > tmp_xxxx.length) tmp_cnt = tmp_xxxx.length;
											
											while(now_cnt < tmp_cnt)
											{
												str += '<tr bgcolor="#FFFFFF" align="center" id="t_row" style="cursor:hand;display:none;" class="tbody_tr cls_svt_lst">';
												str += '<td width="8%" class="line_gray">&nbsp;';
												str += '<input type="checkbox" id="chk_svr_id" name="N_MON_ID" style="cursor:hand;" value="' + tmp_xxxx[now_cnt].N_MON_ID + '">&nbsp;';
												str += '<input type="hidden" name="N_TYPE_CODE" class="type_code" value="' + this.N_TYPE_CODE + '">';
												str += '</td>';
												str += '<td width="15%" class="line_gray">&nbsp;' + tmp_xxxx[now_cnt].N_MON_ID + '&nbsp;</td>';
												str += '<td width="35%" class="line_gray">&nbsp;' + tmp_xxxx[now_cnt].S_MON_NAME + '&nbsp;</td>';
												str += '<td width="45%" class="line_gray">&nbsp;' + tmp_xxxx[now_cnt].S_MON_IP + '&nbsp;</td>';						
												str += '</tr>';
												
												now_cnt++;
											}
											
											$("#div_svr_list .data_body tbody").append(str);

											if(max_cnt > now_cnt)
											{
												setTimeout("fn_loding_svr_list()", 10);
											}
											else
											{
												now_cnt = 0;
												
												$(".cls_svt_lst input:checkbox").click(function(){
													if($(this).is(":checked"))
														$(this).attr("checked", false);
													else
														$(this).attr("checked", true);
												});
												$(".cls_svt_lst").click(function(){
										   			if($(this).children("td").children("input:checkbox").is(":checked"))
										   			{
										   				$(this).children("td").children("input:checkbox").attr("checked", false);
										   				$(this).css("background-color", "#FFFFFF");
										   			}
										   			else
										   			{
										   				$(this).children("td").children("input:checkbox").attr("checked", true);
										   				$(this).css("background-color", "#FFCFB4");
										   			}
										   		});
										   		
												$('#loading_bar').remove();
												fn_svr_first_click();
												$("#div_pagenum").text(tmp_now_page + "/" + Math.ceil($(".cls_svt_lst").length/tmp_page_row_cnt));
											}
										}
											
										function fn_alm_code(data)
										{
											var str = "";
											str = "<table>";
											$(data).each(function(){
												str += '<tr bgcolor="#FFFFFF" align="center" style="cursor:hand;">';
												str += '<td width="8%" class="line_gray">&nbsp;';
												str += '<input type="checkbox" id="chk_svr_id" name="N_ALM_CODE" style="cursor:hand;" value="' + this.N_ALM_TYPE + '-' + this.N_ALM_CODE + '">&nbsp;';
												str += '<input type="hidden" name="N_ALM_TYPE" value="' + this.N_ALM_TYPE + '">';
												str += '</td>';
												str += '<td class="line_gray" align="left">&nbsp;' + this.S_ALM_MSG + '&nbsp;</td>';
												str += '</tr>';
											});
											str += "</table>";
											$("#div_alm_code").html(str);
											
											$("#div_alm_code table tr input:checkbox").click(function(){
												if($(this).is(":checked"))
													$(this).attr("checked", false);
												else
													$(this).attr("checked", true);
											});
											$("#div_alm_code table tr").click(function(){
									   			if($(this).children("td").children("input:checkbox").is(":checked"))
									   			{
									   				$(this).children("td").children("input:checkbox").attr("checked", false);
									   				$(this).css("background-color", "#FFFFFF");
									   			}
									   			else
									   			{
									   				$(this).children("td").children("input:checkbox").attr("checked", true);
									   				$(this).css("background-color", "#FFCFB4");
									   			}
									   		});
										}
										
										$(function(){
											$("select[name='N_SNMP_MAN_CODE']").change(function(){
												$(".cls_svt_lst").each(function(idx){
													//if(idx >= 10) return false;
													//alert($.trim($(this).children(".type_code").val()) + " - " + $(this).children("td").children(".type_code").val());
													if($.trim($(this).children("td").children(".type_code").val()) == '1000')
													{
														//alert("지워!");
														$(this).remove();
													}
												});
											});
										});
									</script>
								</td>
							</tr>
							<script>
								$(function(){
							          $("#t_head").stupidtable();
							      });	
							</script>							
						</table>
					</td>
				</tr>
			</table>
			<!-- 표 start -->
					  <table id="t_head" width="100%" border="0" cellspacing="0" cellpadding="0">
					  	<thead>
			              <tr align="center">
			                <th width="8%" height="29"class="type-string table_title text11 b"><input type="checkbox" name="all_chk_svr" style="cursor:hand;"></th>
			                <th width="15%" class="type-string table_title text11 b" style="cursor:hand;">서버ID</th>
			                <th width="35%" class="type-string table_title text11 b" style="cursor:hand;">서버명</th>
			                <th width="45%" class="type-string table_title text11 b" style="cursor:hand;">서버IP</th>
			              </tr>
			             </thead>
			          </table>
					  <div id="div_svr_list" style="overflow-y:scroll;height:550">
			          <table class="data_body" id="t_body" width="100%" border="0" cellspacing="0" cellpadding="0">
			          	<tbody>
						</tbody>
			         </table>
			         <table width="100%" border="0" cellspacing="0" cellpadding="0">
		            	<tr>
		                <td colspan="7" bgcolor="3b3b3b"><img src="${img1}/dot.png"></td>
		              </tr>
		             </table>
		             <table align="center">
		             	<tr>
		             		<td>
		             	<img src="${img1}/btn_pre02.jpg" align="absmiddle" style="cursor:hand;" onclick="fn_svr_first_click()">
			          	<img src="${img1}/btn_pre.jpg" align="absmiddle" style="cursor:hand;" onclick="fn_svr_prev_click()">
			          	&nbsp;<span id="div_pagenum"></span>&nbsp;
			          	<img src="${img1}/btn_next.jpg" align="absmiddle" style="cursor:hand;" onclick="fn_svr_next_click()">
			          	<img src="${img1}/btn_next02.jpg" align="absmiddle" style="cursor:hand;" onclick="fn_svr_last_click()">
			          		</td>
			          	</tr>
		             </table>
			           </div>   
        </td>
       	<td valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
            	<tr align="center">
            		<td>
            			<!-- 임계치설정 start -->
					      <table width="100%" border="0" cellspacing="0" cellpadding="0">
					        <tr>
					          <td height="29" colspan="5" class="b gray pl10"><img src="${img1}/icon_arrow.png" align="absmiddle">임계치 정보</td>
					        </tr>
					        <tr align="center">
					          <td width="20%" rowspan="2" height="29"class="table_title text11 b">대상</td>
					          <td width="20%" colspan="4" class="table_title text11 b">사용률</td>
					          <td width="20%" colspan="2"class="table_title text11 b">장애 중단</td>
					        </tr>
					        <tr align="center">          
					          <td width="15%" class="table_bg text11 b">Minor</td>
					          <td width="15%" class="table_bg text11 b">Major</td>
					          <td width="15%" class="table_bg text11 b">Critical</td>
					          <td width="15%" class="table_bg text11 b">유지시간(분)</td>
					          <td width="15%" class="table_bg text11 b">등급</td>
					          <td width="15%" class="table_bg text11 b">유지시간(분)</td>
					        </tr>
					        <tr align="center">
					          <td height="27" class="line_gray table_bg pl10 text11 b">CPU</td>
					          <td class="line_gray">&nbsp;<input type="text" name="cpu_key_0" maxlength="3" value="70" style="width:50px;height:20px"></td>
					          <td class="line_gray">&nbsp;<input type="text" name="cpu_key_1" maxlength="3" value="80" style="width:50px;height:20px"></td>
					          <td class="line_gray">&nbsp;<input type="text" name="cpu_key_2" maxlength="3" value="90" style="width:50px;height:20px"></td>
					          <td class="line_gray">&nbsp;<input type="text" name="cpu_key_3" maxlength="3" value="1" style="width:50px;height:20px"></td>
					          <td class="line_gray">&nbsp;</td>
					          <td class="line_gray">&nbsp;</td>
					        </tr>
					        <tr align="center">
					          <td height="27" class="line_gray table_bg pl10 text11 b">Memory</td>
					          <td class="line_gray">&nbsp;<input type="text" name="mem_key_0" maxlength="3" value="70" style="width:50px;height:20px"></td>
					          <td class="line_gray">&nbsp;<input type="text" name="mem_key_1" maxlength="3" value="80" style="width:50px;height:20px"></td>
					          <td class="line_gray">&nbsp;<input type="text" name="mem_key_2" maxlength="3" value="90" style="width:50px;height:20px"></td>
					          <td class="line_gray">&nbsp;<input type="text" name="mem_key_3" maxlength="3" value="1" style="width:50px;height:20px"></td>
					          <td class="line_gray">&nbsp;</td>
					          <td class="line_gray">&nbsp;</td>
					        </tr>
					        <tr align="center">
					          <td height="27" class="line_gray table_bg pl10 text11 b">디스크</td>
					          <td class="line_gray">&nbsp;<input type="text" name="disk_key_0" maxlength="3" value="70" style="width:50px;height:20px"></td>
					          <td class="line_gray">&nbsp;<input type="text" name="disk_key_1" maxlength="3" value="80" style="width:50px;height:20px"></td>
					          <td class="line_gray">&nbsp;<input type="text" name="disk_key_2" maxlength="3" value="90" style="width:50px;height:20px"></td>
					          <td class="line_gray">&nbsp;<input type="text" name="disk_key_3" maxlength="3" value="1" style="width:50px;height:20px"></td>
					          <td class="line_gray">&nbsp;</td>
					          <td class="line_gray">&nbsp;</td>
					        </tr>
					        <tr align="center">
					          <td height="27" class="line_gray table_bg pl10 text11 b">프로세서</td>
					          <td class="line_gray">&nbsp;<input type="text" name="process_key_0" maxlength="3" value="70" style="width:50px;height:20px"></td>
					          <td class="line_gray">&nbsp;<input type="text" name="process_key_1" maxlength="3" value="80" style="width:50px;height:20px"></td>
					          <td class="line_gray">&nbsp;<input type="text" name="process_key_2" maxlength="3" value="90" style="width:50px;height:20px"></td>
					          <td class="line_gray">&nbsp;<input type="text" name="process_key_3" maxlength="3" value="1" style="width:50px;height:20px"></td>
					          <td class="line_gray">&nbsp;
					          	<select name="process_key_4">
				          			<option value="">선택</option>
				          			<option value="0">Normal</option>
				          			<option value="1">Minor</option>
				          			<option value="2">Major</option>
				          			<option value="3">Critical</option>
				          		</select>
					          </td>
					          <td class="line_gray">&nbsp;<input type="text" name="process_key_5" maxlength="3" value="1" style="width:50px;height:20px"></td>
					        </tr>
					        <tr align="center">
					          <td height="27" class="line_gray table_bg pl10 text11 b">서비스</td>
					          <td class="line_gray">&nbsp;<input type="text" name="service_key_0" maxlength="3" value="70" style="width:50px;height:20px"></td>
					          <td class="line_gray">&nbsp;<input type="text" name="service_key_1" maxlength="3" value="80" style="width:50px;height:20px"></td>
					          <td class="line_gray">&nbsp;<input type="text" name="service_key_2" maxlength="3" value="90" style="width:50px;height:20px"></td>
					          <td class="line_gray">&nbsp;<input type="text" name="service_key_3" maxlength="3" value="1" style="width:50px;height:20px"></td>
					          <td class="line_gray">&nbsp;
					          	<select name="service_key_4">
				          			<option value="">선택</option>
				          			<option value="0">Normal</option>
				          			<option value="1">Minor</option>
				          			<option value="2">Major</option>
				          			<option value="3">Critical</option>
				          		</select>
					          </td>
					          <td class="line_gray">&nbsp;<input type="text" name="service_key_5" maxlength="3" value="1" style="width:50px;height:20px"></td>
					        </tr>
					        <tr>
					          <td colspan="99" bgcolor="3b3b3b"><img src="${img1}/dot.png"></td>
					        </tr>
					        <tr>
					          <td height="60" colspan="99" align="center"><input style="width:70px; height:23px;" onClick="fn_save()" type="button" value="저장"/>
					            &nbsp;
					            <input style="width:70px; height:23px;" onClick="fn_cancel()" type="button" value="취소"/></td>
					        </tr>
					      </table>
					      <!-- 임계치설정 end -->            			 
            		</td>
            	</tr>
            </table>
        </td>
     </tr>
</table>
</form>
            <!-- 표 end -->		
</body>