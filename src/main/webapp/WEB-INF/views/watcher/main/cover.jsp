<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="/WEB-INF/views/include/include.jsp" %>
<!-- 드래그용 스크립트 -->
<script src="<c:url value="/common/js/jquery-ui-1.10.3.custom/js/jquery-ui-1.10.3.custom.js"/>"></script>
<script src="<c:url value="/common/js/jquery.corner.js"/>"></script>

<script>
	$(function() {
		$("#error_popup").draggable({
			handle : ".title_bar"
			, cancel : "img"
	});
		
		$(".title_bar").corner("top 5px");
		
		top.fn_chk_alarm_status();
	});
	
	function fn_alarm_history_popup(v_mon_id, v_alm_key)
	{
		top.fn_alarm_history_popup(v_mon_id, v_alm_key);
	}
	
	function fn_setAlarmList(obj)
	{
		try{
			if(obj[0].S_ALM_KEY == null)
			{
				$("#ALARM_CNT").text(0);
				$("#CHECK_DT").text(obj[0].CHECK_DT);
				
				$("#alarm_list").html("");
			}
			else
			{
				$("#ALARM_CNT").text(obj.length);
				$("#CHECK_DT").text(obj[0].CHECK_DT);
				
				var tmp_table_html = '<table id="alarm_list" width="100%" border="0" cellspacing="0" cellpadding="0">';
				for(var i=0;i<obj.length;i++)
				{
					tmp_table_html += '<tr ' + ((i%2 == 0)?"bgcolor='eeeeee'":"") + ' class="line_gray" align="center" onclick="fn_alarm_history_popup(\'' + obj[i].N_MON_ID + '\', \'' + obj[i].S_ALM_KEY + '\')">';
					tmp_table_html += '<td height="29" width="3%"><img src="${img2}/warning_view.gif"></td>';
					tmp_table_html += '<td width="23%">' + obj[i].D_UPDATE_TIME + '</td>';
					tmp_table_html += '<td width="18%">' + obj[i].S_MON_NAME + '</td>';
					tmp_table_html += '<td width="15%">' + obj[i].S_ALM_RATING_NAME + '</td>';
					tmp_table_html += '<td width="5%">' + obj[i].S_ALM_STATUS_NAME + '</td>';
					tmp_table_html += '<td width="36%" align="left">&nbsp;&nbsp;' + obj[i].S_ALM_MSG + '</td>';
					//tmp_table_html += '<td width="3%" align="center" class="blue2 warning_td">' + obj[i].S_ALM_KEY + '</td>';
					tmp_table_html += '</tr>';
				}
				tmp_table_html += '</table>';
				
				$("#alarm_list").html(tmp_table_html);
				
				$(function(){
					$("#alarm_list table tr").hover(function(){
						$(this).attr("bgcolor", "#DDDDDD");
					}, function(){
						$(this).attr("bgcolor", "");
					})
					
					$("#alarm_list table tr").click(function(){
						
					});
				});
			}
			
		}catch(e){
			
		}
	}
	
	var flag = "min";
	var v_x = 40;
	var v_y = 40;
	var before_x = null;
	var before_y = null;
	var title_width = 0;
	function fn_popup_move()
	{
		if(flag == "min")
		{
			/*var tmp_offset = $("#error_popup").offset();
			if(tmp_offset.left != 0 || tmp_offset.top != 0)
			{
				if(before_x == null) before_x = tmp_offset.left;
				if(before_y == null) before_y = tmp_offset.top;
				var tmp_x = tmp_offset.left - v_x;
				var tmp_y = tmp_offset.top - v_y;
				
				if(tmp_x < 0) tmp_x = 0;
				if(tmp_y < 0) tmp_y = 0;
				
				//alert( tmp_x +"-"+ tmp_y);
				
				$("#error_popup").css({left:tmp_x, top:tmp_y});
				
				setTimeout("fn_popup_move()", 10);
			}
			else
			{*/
				$("#error_popup .contents").fadeOut("fast", function(){
					var tmp_offset = $("#error_popup").offset();
					if(before_x == null) before_x = tmp_offset.left;
					if(before_y == null) before_y = tmp_offset.top;
					
					$("#error_popup").css({left:0, top:0});
					
					flag = 'max';
					
					title_width = $(".main_table").width();
					
					$(".main_table").width("180");
					$("#error_popup").draggable({
						cancel : ".title_bar"
					});
					top.fn_min_cover();
				});
			//}
		}
		else if(flag == "max")
		{
			/*var tmp_offset = $("#error_popup").offset();
			if(tmp_offset.left != before_x || tmp_offset.top != before_y)
			{
				var tmp_x = tmp_offset.left + v_x;
				var tmp_y = tmp_offset.top + v_y;
				
				if(tmp_x > before_x) tmp_x = before_x;
				if(tmp_y > before_y) tmp_y = before_y;
								
				$("#error_popup").css({left:tmp_x, top:tmp_y});
				
				setTimeout("fn_popup_move()", 10);
			}
			else
			{*/
				
				$("#error_popup").css({left:before_x, top:before_y});
				$("#error_popup .contents").show();
				flag = 'min';
				before_x = null;
				before_y = null;
				
				$(".main_table").width(title_width);
				$("#error_popup").draggable({
					handle : ".title_bar"
					, cancel : "img"
				});
				top.fn_max_cover();
			//}
		}
	}
</script>
<body style="background-color: transparent;">
			<!-- <span id="test" style="position:absolute;top:150;left:300;display:;">
			<table width="150" height="10" border="1">
				<tr>
					<td height="10" align="right" valign="top"><input type="button" value="_" alt="최소화" onclick="fn_aaa()" style="width:25px;height:25px;"></td>
				</tr>
			</table>
			<table width="150" height="150" border="1" class="contents">
				<tr>
					<td bgcolor="#FF88AA">☆☆☆☆☆ 별이 다섯개!</td>
				</tr>
			</table>
			</span> -->
			
			<script>
				$(function(){
					$(".title_bar tr").hover(function(){
						$(this).attr("bgcolor", "#5588FF");
					}, function(){
						$(this).attr("bgcolor", "#88AAFF");
					});
				});
			</script>
			<span id="error_popup" style="position:absolute;top:150;left:300;display:;">
			
			<table width="810" border="0" cellspacing="0" cellpadding="0" class="main_table">
				<tr>
					<td bgcolor="#88AAFF" class="title_bar">
						<table width="810" height="10" border="0" class="main_table">
							<tr bgcolor="#88AAFF">
								<td height="10" align="right" valign="top">
									<img src="${img2}/min_off.png" width="29px" height="18px" class="btn_min" style="display:none;"><img src="${img2}/close_off.png" width="47px" height="18px" class="btn_close">
									<script>
										$(function(){
											$(".btn_min").hover(function(){
												$(this).attr("src", "${img2}/min_over.png");
												$(this).css("cursor", "pointer");
											}, function(){
												$(this).attr("src", "${img2}/min_off.png");
												$(this).css("cursor", "");
											});
											$(".btn_close").hover(function(){
												$(this).attr("src", "${img2}/close_over.png");
												$(this).css("cursor", "pointer");
											}, function(){
												$(this).attr("src", "${img2}/close_off.png");
												$(this).css("cursor", "");
											});
											
											var tmp_img_min;
											var tmp_img_close;
											$(".btn_min").mousedown(function(){
												//tmp_img_min = $(this).attr("src",
												$(this).attr("src", "${img2}/min_on.png");
											});
											
											$(".btn_close").mousedown(function(){
												$(this).attr("src", "${img2}/close_on.png");
											});
											
											$(".btn_min").click(function(){
												fn_popup_move();
											});
											
											$(".btn_close").click(function(){
												top.fn_close_cover();
											});
										});
									</script>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			    <tr>
			    	<td height="375" valign="top" class="contents">
			    	<table width="810" border="0" cellspacing="0" cellpadding="0">
					    <tr>
					        <td height="116" background="${img2}/warning_top.gif" style="padding:45px 0 0 127px;">
					        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
					                <tr>
					                    <td class="blue2">총 <span id="ALARM_CNT"></span>개의 새로운 장애가 발생하였습니다</td>
					                </tr>
					            </table>
					        </td>
					    </tr>
					    <tr>
					        <td height="250" valign="top" background="${img2}/warning_ce.gif" style="padding:5px 21px 38px 21px">
					        	<!-- 새로운 장애 리스트 -->
					            <table width="100%" border="0" cellspacing="0" cellpadding="0">
					                <tr>
					                    <td height="35" colspan="6"><img src="${img2}/icon_arrowg.jpg"><span class="text11 b">업데이트 시각 :</span> <span id="CHECK_DT"></span></td>
					                </tr>
					                <tr class="b white pt2 text11" align="center">
					                    <td width="3%" height="29" background="${img2}/tel_tit.jpg"></td>
					                    <td width="23%" background="${img2}/tel_tit.jpg">시간</td>
					                    <td width="18%" background="${img2}/tel_tit.jpg">장비명</td>
					                    <td width="15%" background="${img2}/tel_tit.jpg">등급</td>
					                    <td width="5%" background="${img2}/tel_tit.jpg">상태</td>
					                    <td width="36%" background="${img2}/tel_tit.jpg">장비명</td>
					                </tr>
					           </table>
					           <div id="alarm_list" style="height:162;overflow-y:auto;">
			                        
			                   </div>
					            
					        </td>
					    </tr>
					    <tr>
					        <td><img src="${img2}/warning_bt.gif"></td>
					    </tr>
					</table>
					</td>
			    </tr>
			</table>
			</span>
</body>