<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/include.jsp" %>
<%@ taglib prefix="chart" uri="/WEB-INF/views/include/taglib/chart_tag.tld"%>

<%@ taglib prefix="etc" uri="/WEB-INF/views/include/taglib/etc_tag.tld"%>

<jsp:useBean id="data" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="svr_type" class="java.util.ArrayList" scope="request"/>

<!-- 드래그용 스크립트 -->
<script src="${contextPath}/include/jquery-ui-1.10.3.custom/js/jquery-ui-1.10.3.custom.js" type="text/JavaScript"></script>
<link href="${css}/login.css" rel="stylesheet" type="text/css">

<style>
	input[type='button'] {height:32px;width:71px;border:1px solid #dbdbdb;padding-left:5px;cursor:hand;}
	div { line-height:1 }
	
	#box {float:left;width:120px;height:96px;border:1px solid #737989;background:#f2f2f2;}
	.tit {height:27px;background:url('${img2}/box_base.gif') repeat-x left top;text-align:right;padding:4px 3px;}
	.tit_warn {height:27px;background:url('${img2}/box_warn.gif') repeat-x left top;text-align:right;padding:4px 3px;}
	.pic {float:left;width:42px;height:62px;border:1px solid #bbbbbb;background:#fff;margin:-5px 0 0 3px;text-align:center;}
	.box_graph {float:left;width:13px;font-size:11px;font-weight:bold;color:#000;margin:0px 0 0 3px;}
	.graph {float:left;width:50px;height:16px;border:1px solid #bbb;background:#fff;padding:1px;margin:-5px 0 7px 1px;}
	.txt {float:right;text-align:right;color:#000033;font-weight:bold;font-size:11px;margin:-23px 5px 0 0;}
</style>

<script>
var v_left = 0;
var v_top = 0;

var w_size = 330;
var h_size = 110;
var max_w_size = 990-1;

$(function() {
	try{
	$("#area .svr_box").draggable({
		containment: "#map_main"
		, scroll: false
		, stack: ".svr_box"
		, iframeFix: true
	});
	//$("#area div").hide();
	//$("span").text($("span").text()+" -|- "+0+":"+v_left+"-"+v_top);
	$("#area #pos_null").first().css({left: v_left, top: v_top});
	//$("#area div").first().show("slow");

	var chk;	
	for(i=1;i<$("#area #pos_null").last().index()+1;i++)
	{
		chk = true;
		while(chk)
		{
			chk = false;
			for(j=0;j<i;j++)
			{
				var tmp = $("#area #pos_null").eq(j).offset();
				//패스 조건
				if(tmp.left != v_left)
				{
					//if(i==6)$("#area div").eq(3).text($("#area div").eq(3).text()+":"+i+"-"+j);
					continue;
				}
				else if(tmp.left == v_left && tmp.top != v_top)
				{					
					if(tmp.top + $("#area #pos_null").eq(j).height() > v_top)
					{						
						v_left += $("#area #pos_null").eq(j).width();
						if(v_left > max_w_size)
						{							
							v_left = 0;
							v_top += h_size;
						}
						chk = true;
					}
					else
						continue;
				}
				else if(tmp.left == v_left && tmp.top == v_top)
				{					
					if(v_left > max_w_size)
					{
						v_left = 0;
						v_top += h_size;
					}
					v_left += $("#area #pos_null").eq(j).width();
					chk = true;
				}
				
			}
		}
		//if(i==4) $("#sss").text($("span").text()+" | "+i+":"+v_left+"-"+v_top);
		$("#area #pos_null").eq(i).css({left: v_left, top: v_top});
		$("#area #pos_null").eq(i).show("slow");
		if(v_left + w_size > max_w_size)
		{
			v_left = 0;
			v_top += h_size;
		}
	}
	}catch(e){}
	
	setTimeout("fn_get_svr_stats()", 3000);
});

function fn_group_select()
{
	var tmp = parent.parent.img_url;

	if(tmp == "null" || tmp == "")
		tmp = "${img2}/no_image.png";
		
	$("#map_img").attr("src", tmp);
}

$(function(){
	fn_group_select();
});

function fn_save_map_pos()
{
	var param = "";
	
	param += "N_GROUP_CODE=" + parent.parent.grp_code;	
	param += "&DATA=";
	/*for(var i=0;i<$("#area .svr_box").last().index()+1;i++)
	{
		param += parent.parent.grp_code;
		param += "," + $("#area .svr_box input[name='S_GROUP_FULL_CODE']").eq(i).val();
		param += "," + $("#area .svr_box").eq(i).css("left").replace("px","");
		param += "," + $("#area .svr_box").eq(i).css("top").replace("px","");
		param += ";";
	}*/
	
	$("#area .svr_box").each(function(idx){
		param += parent.parent.grp_code;
		param += "," + $(this).children("input[name='N_MON_ID']").val();
		param += "," +  $(this).css("left").replace("px", "");
		param += "," +  $(this).css("top").replace("px", "");
		param += ";";
	});
	
	//alert(param);
	//ajax_reqAction("realtime_stats.reg_svr_stats_pos_save.neonex", param, "fn_result");
	
	$.post("component.reg_svr_stats_pos_save.neonex", param, function(){
		alert('저장 되었습니다.');
	});
}

function fn_result(str)
{
	alert('저장 되었습니다.');
}

$(function() {
	$("#area .svr_box").hover(function(){
		$(this).children(".map_title").css("background","SKYBLUE");
	}, function() {
		$(this).children(".map_title").css("background","#E3E3E3");
	});
});
</script>
<div id="map_main" style="overflow:hidden;height:760">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
		    	<tr>
					<td width="4"><img src="${img2}/tab_lt.jpg"></td>
					<td background="${img2}/tab_ce.jpg">
						<table width="100%" height="100%">
							<tr>
								<td>
									<img src="${img2}/sotitle_map.png">
								</td>
								<td valign="bottom" align="right" style="padding-right:10;padding-top:7;">
									<input type="button" onclick="fn_save_map_pos()" style="background-color:#54606E;width:71;height:32;text-align:center;color:#FFFFFF;vertical-align: top;font-family:굴림;font:bold;font-size:1em" value="저장">
								</td>
							</tr>
						</table>						
					</td>
					<td width="4"><img src="${img2}/tab_rt.jpg"></td>
				</tr>
				<tr>
					<td background="${img2}/tab_lc.jpg">&nbsp;</td>
					<td height="760" bgcolor="#FFFFFF" valign="top"><img id="map_img" src="${img2}/no_image.png" width="100%" height="95%">	</td>
					<td background="${img2}/tab_rc.jpg">&nbsp;</td>
				</tr>
				<tr>
					<td><img src="${img2}/tab_lb.jpg"></td>
					<td height="4" background="${img2}/tab_ceb.jpg"><img src="${img2}/dot.png"></td>
					<td><img src="${img2}/tab_rb.jpg"></td>
				</tr>
			</table>
		</td>
</div>

<script>
	function fn_get_svr_stats()
	{
		$.post("component.map2_ajax.neonex?N_GROUP_CODE=${param.N_GROUP_CODE}", function(data){
			try{			
				var tmp_data = eval('(' + data + ')');

				$(tmp_data).each(function(idx){
					var tmp_id = '#mon_'+this.N_MON_ID;
					if(this.CPU_PER_USE == null) 
					{
						this.CPU_PER_USE = '';
					}
					if(this.MEM_PER_USE == null) 
					{
						this.MEM_PER_USE = '';
					}
					if(this.DISK_PER_USE == null) 
					{
						this.DISK_PER_USE = '';
					}
					$(tmp_id + " .cpu_bar img").width(this.CPU_PER_USE + '%');
					$(tmp_id + " .mem_bar img").width(this.MEM_PER_USE + '%');
					$(tmp_id + " .disk_bar img").width(this.DISK_PER_USE + '%');
					
					$(tmp_id + " .cpu_txt").text(this.CPU_PER_USE + '%');
					$(tmp_id + " .mem_txt").text(this.MEM_PER_USE + '%');
					$(tmp_id + " .disk_txt").text(this.DISK_PER_USE + '%');
				});
			}catch(e){}
			
			setTimeout("fn_get_svr_stats()", 3000);
		});
	}
</script>
	
<!-- 장비현황 -->
	<div id="area">
	<c:forEach items="${data}" var="m">
	      <!-- 정상 MAP 표시 시작 -->
	      	<c:if test="${m.N_POS_LEFT == '0' and m.N_POS_TOP == '0'}">
				<div id="pos_null" style="position:absolute;left:${m.N_POS_LEFT}px;top:${m.N_POS_TOP}px;" class="svr_box">
			</c:if>
			<c:if test="${m.N_POS_LEFT != '0' or m.N_POS_TOP != '0'}">
				<div id="pos_ok" style="position:absolute;left:${m.N_POS_LEFT}px;top:${m.N_POS_TOP}px;" class="svr_box">
			</c:if>
	      		<input type="hidden" name="N_MON_ID" value="${m.N_MON_ID}"/>
		  		<div id="box">
				    <div class="${m.N_ALM_CNT!='0'?'tit_warn':'tit'}"><!-- 장애발생시 class="tit"을 class="tit_warn"으로 수정요합니다. -->    	
				        <table width="100%" height="100%"><tr><td width="80%" align="left"><b><font color="" style="font-size:10px;">${m.S_MON_NAME}</font></b></td><td align="right"><h1></h1></td></tr></table>
				    </div>
				    <div class="pic"><img src="${img2}/server_01.png" alt="" /></div>
				    <div id="mon_${m.N_MON_ID}">
				        <ul>
				            <li> <span class="box_graph">C</span>
				                <dl>
				                    <dt class="graph cpu_bar"><img src="${img2}/graph_warn.gif" width="${m.CPU_PER_USE}%" height="16" alt="" /></dt>
				                    <dd class="txt cpu_txt">${m.CPU_PER_USE}%</dd>
				                </dl>
				            </li>
				            <li> <span class="box_graph">M</span>
				                <dl>
				                    <dt class="graph mem_bar"><img src="${img2}/graph_base.gif" width="${m.MEM_PER_USE}%" height="16" alt="" /></dt>
				                    <dd class="txt mem_txt">${m.MEM_PER_USE}%</dd>
				                </dl>
				            </li>
				            <li> <span class="box_graph">D</span>
				                <dl>
				                    <dt class="graph disk_bar"><img src="${img2}/graph_base.gif" width="${m.DISK_PER_USE}%" height="16" alt="" /></dt>
				                    <dd class="txt disk_txt">${m.DISK_PER_USE}%</dd>
				                </dl>
				            </li>
				            
				        </ul>
				    </div>
				</div>
			</div>
	</c:forEach>
     
    </div>    