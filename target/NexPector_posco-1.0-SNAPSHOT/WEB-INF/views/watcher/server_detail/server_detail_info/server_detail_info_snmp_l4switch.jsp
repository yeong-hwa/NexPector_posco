<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<form name="frm" method="post">
	<input type="hidden" name="N_MON_ID" value="${param.N_MON_ID}">
	<input type="hidden" name="S_CPU_KEY" value="${svr_info.S_CPU_KEY}">
	<input type="hidden" name="S_MEM_KEY" value="${svr_info.S_MEM_KEY}">
	<input type="hidden" name="S_DISK_KEY" value="${svr_info.S_DISK_KEY}">
</form>
<script type="text/javascript" src="<c:url value="/common/kendo-ui/js/kendo.all.min.js" />"></script>
<script type="text/javascript">
	function fn_server_link(type, url) {
		if (url == null) {
			alert("url is null");
			return;
		}
	
		if (url == "") {
			alert("url is Empty");
			return;
		}
	
	 	if(type == 0)
		{
	 		open (url,"NMS","width=550, height=500");
		}
	 	else if(type == 1)
		{
	  		NEOLinkCtrl.RemoteWindow(url);
		}
		else if(type == 2)
		{
	 		NEOLinkCtrl.RemotePutty(url);
		}
	
	}

        	$(function() {
        		fn_get_server_info();
        	});

          	function fn_get_server_info()
	    	{
	      		var param = "N_MON_ID=${param.N_MON_ID}&S_CPU_KEY=${svr_info.S_CPU_KEY}&S_MEM_KEY=${svr_info.S_MEM_KEY}&S_DISK_KEY=${svr_info.S_DISK_KEY}";
          		$.post("<c:url value='/watcher/server_detail/p_s_info.htm'/>", param, function(data){
          			var obj = eval("("+data+")");
					//console.log("data :: "+data);
					//console.log("obj :: "+obj);
					//console.log("obj.p_s_info :: "+obj.p_s_info.MAJOR_ERR_CNT);
					//console.log("obj.cpu_info :: "+obj.cpu_info);

          			try{
	          			var p_s_info = obj.p_s_info;
		    			var cri_cnt = 0;
	              		var maj_cnt = 0;
	              		var min_cnt = 0;
	              		cri_cnt = p_s_info.CRITICAL_ERR_CNT==null?0:p_s_info.CRITICAL_ERR_CNT;
	              		maj_cnt = p_s_info.MAJOR_ERR_CNT==null?0:p_s_info.MAJOR_ERR_CNT;
	              		min_cnt = p_s_info.MINOR_ERR_CNT==null?0:p_s_info.MINOR_ERR_CNT;

	              		if(cri_cnt > maj_cnt)
	              		{
	              			if(cri_cnt > min_cnt)
	              			{
	              				maj_cnt = 30 * (maj_cnt / cri_cnt);
	              				min_cnt = 30 * (min_cnt / cri_cnt);
	              				cri_cnt = 30;
	              			}
	              			else if(cri_cnt < min_cnt)
	              			{
	              				maj_cnt = 30 * (maj_cnt / min_cnt);
	              				cri_cnt = 30 * (cri_cnt / min_cnt);
	              				min_cnt = 30;
	              			}
	              			else
	              			{
	              				maj_cnt = maj_cnt==0?0:30*(maj_cnt/cri_cnt);
	              				cri_cnt = cri_cnt==0?0:30;
	              				min_cnt = min_cnt==0?0:30;
	              			}
	              		}
	              		else if(cri_cnt < maj_cnt)
	              		{
	              			if(maj_cnt > min_cnt)
	              			{
	              				cri_cnt = 30 * (cri_cnt / maj_cnt);
	              				min_cnt = 30 * (min_cnt / maj_cnt);
	              				maj_cnt = 30;
	              			}
	              			else if(maj_cnt < min_cnt)
	              			{
	              				maj_cnt = 30 * (maj_cnt / min_cnt);
	              				cri_cnt = 30 * (cri_cnt / min_cnt);
	              				min_cnt = 30;
	              			}
	              			else
	              			{
	              				cri_cnt = cri_cnt==0?0:30*(cri_cnt/maj_cnt);
	              				maj_cnt = maj_cnt==0?0:30;
	              				min_cnt = min_cnt==0?0:30;
	              			}
	              		}
	              		else
	              		{
	              			min_cnt = min_cnt==0?0:30*(min_cnt/cri_cnt);
	              			cri_cnt = cri_cnt==0?0:30;
	          				maj_cnt = maj_cnt==0?0:30;
	              		}

	              		$("#t_error_cnt_critcal").text(p_s_info.CRITICAL_ERR_CNT);
		    			$("#t_error_cnt_major").text(p_s_info.MAJOR_ERR_CNT);
		    			$("#t_error_cnt_minor").text(p_s_info.MINOR_ERR_CNT);
		    			$("#t_error_cnt_critcal_h").css("height", cri_cnt);
		    			$("#t_error_cnt_major_h").css("height", maj_cnt);
		    			$("#t_error_cnt_minor_h").css("height", min_cnt);
          			}catch(e){
          				console.log(e);
          			}
          			
          			function fn_resource_bar(val)
	    			{
	    				return val<50?(val*2):(val*2-(Math.floor((val-50)/10)*3));
	    			}
 
          			try{
		    			var cpu_info = obj.cpu_info;
		    			//$("#t_cpu_per").attr("width", fn_resource_bar(cpu_info.N_PER_USE));
		    			$("#t_cpu_per").attr("width", "100%");
		    			$("#t_cpu_usage").text((cpu_info.N_NOW_USE==null?"":cpu_info.N_NOW_USE) + "%");
          			}catch(e){}

          			try{
		    			var mem_info = obj.mem_info;
		    			$("#t_mem_per").attr("width", fn_resource_bar(mem_info.N_PER_USE));
						$("#t_mem_usage").text(mem_info.N_PER_USE==null?"":mem_info.N_PER_USE + "%");
          			}catch(e){}

          			try{
		    			var disk_info = obj.disk_info;
		    			$("#t_disk_per").attr("width", fn_resource_bar(disk_info.N_PER_USE));
						$("#t_disk_usage").text(disk_info.N_PER_USE==null?"":disk_info.N_PER_USE + "%");
          			}catch(e){}

	    			//window.setTimeout("fn_get_server_info()", 15000);
	    		});
	    	}
          	
            function onChange() {
                kendoConsole.log("Change :: " + kendo.toString(this.value(), 'd'));
            }

            function onNavigate() {
                kendoConsole.log("Navigate");
            }

            $("#calendar").kendoCalendar({
                change: onChange,
                navigate: onNavigate
            });
            
     	 $(function(){
/*       		var offset = $("#t_cpu_usage").offset();
     		console.log("offset :: "+offset.left);
     		console.log("offset :: "+offset.top);
			var top_px = navigator.userAgent.toLowerCase().indexOf("msie") != -1?12:1;

    		$("#t_cpu_usage").css({
    			left : offset.left+65
    			, top : offset.top-top_px
    			, position: "absolute"
    		});

    		offset = $("#t_mem_usage").offset();
    		$("#t_mem_usage").css({
    			left : offset.left+65
    			, top : offset.top-top_px
    			, position: "absolute"
    		});

    		offset = $("#t_disk_usage").offset();
    		offset = $("#t_disk_usage").offset();
    		$("#t_disk_usage").css({
    			left : offset.left+65
    			, top : offset.top-top_px
    			, position: "absolute"
    		}); */
     	});

 </script>
 
<!--pagenavi-->

<%-- 	<div class="stitle"><h3>감시장비별 상세조회</h3></div>
	<div class="pnavi"><img src="${img2}/dot_pnavi01.gif" alt="dot" class="dot01" />Home &gt; 감시장비별 상세조회 &gt; ${svr_info.S_MON_NAME}</div> --%>
	<div class="locationBox"><div class="st_under"><h2>감시장비별 상세조회</h2><span>Home &gt; 감시장비별 상세조회 &gt;  ${svr_info.S_MON_NAME}</span></div></div>

<!--//pagenavi-->


		<!-- 감시장비별페이지 상단 -->
		<div class="avaya_top_contentsBox">
			<div class="atcB_bottom">
				<ul class="atcBt_type1">
					<li class="left_bg">
						<dl>
							<dd><span>장비명</span>${svr_info.S_MON_NAME}&nbsp;&nbsp;-&nbsp;&nbsp;[${svr_info.N_MON_ID}]</dd>
							<dd><span>IP주소</span>${svr_info.S_MON_IP}</dd>
							<dd><span>연결상태</span><strong><c:if test="${svr_info.B_CON_INFO == '연결'}"><b style="color:blue;">${svr_info.B_CON_INFO}</c:if><c:if test="${svr_info.B_CON_INFO == '연결안됨'}"><b style="color:red;">${svr_info.B_CON_INFO}</c:if></strong></dd>
						</dl>
					</li>
					<li class="right_bg"></li>
				</ul>
				<ul class="atcBt_type2">
					<li class="left_bg">
						<dl class="sbox3">
							<dt>장애</dt>
							<dd class="grap_bg2">
								<span class="tc1" id="t_error_cnt_critcal">0</span>
								<span class="tc2" id="t_error_cnt_major">0</span>
								<span class="tc3" id="t_error_cnt_minor">0</span>
								<span class="tc1_grp" id="t_error_cnt_critcal_h"></span>
								<span class="tc2_grp" id="t_error_cnt_major_h"></span>
								<span class="tc3_grp" id="t_error_cnt_minor_h"></span>
							</dd>
							<dd style="padding-top:5px;">
								<span class="tc21-1">Orl</span><span class="tc22-1">Maj</span><span class="tc23-1">Min</span>
							</dd>
						</dl>
					</li>
					<li class="right_bg"></li>
				</ul>
				
				
				<ul class="atcBt_type3">
					<li class="left_bg">
						<dl>
							<dd><span>CPU</span><span class="resource_bg"><img src="/common/images/watcher/g_wblue.jpg" width="0%" height="20" id="t_cpu_per"></span><span id="t_cpu_usage"></span></dd>
							<dd><span>MEM</span><span class="resource_bg"><img src="/common/images/watcher/g_wblue.jpg" width="0%" height="20" id="t_mem_per"></span><span id="t_mem_usage"></span></dd>
							<dd style="display:none;"><span>DISK</span><span class="resource_bg"><img src="/common/images/watcher/g_wblue.jpg" width="0%" height="20" id="t_disk_per"></span><span id="t_disk_usage"></span></dd>
						</dl>
					</li>
					<li class="right_bg"></li>
				</ul>
			</div>
		</div>
		<!-- 감시장비별페이지 상단 // -->
		
							
							<div id="tapBox1">
								<!-- tap -->
								<div class="tap_line">
									<ul>
									<li><a href="#" onclick="avaya_tab1()" style="cursor:pointer;" class="onted">자원정보</a></li>
									<li><a href="#" onclick="avaya_tab2()" style="cursor:pointer;">Interface</a></li>
									<li><a href="#" onclick="avaya_tab3()" style="cursor:pointer;">Traffic</a></li>
									<li><a href="#" onclick="avaya_tab4()" style="cursor:pointer;">장애</a></li>
									</ul>
								</div>
								<!-- tap // -->
								<!-- stitle -->
								<div class="avaya_stitle1">
									<div class="st_under"><h4>자원 정보</h4></div>
								</div>
								<!-- stitle // -->
								<!-- table_typ2-1 -->
								<div class="cal_grpBox">

									<div class="cal_b">
										<!--달력-->
										<div class="calendar">
											<!-- part -->
											<div class="calendar_period">
												<a href="#"><img src="./images/botton/btn_cal_prevyear.gif" width="17" height="13" alt="이전해"></a>
												<a href="#"><img src="./images/botton/btn_cal_prevmonth.gif" width="12" height="13" alt="이전달"></a>
												<strong>2015. 03</strong>
												<a href="#"><img src="./images/botton/btn_cal_nextmonth.gif" width="12" height="13" alt="다음달"></a>
												<a href="#"><img src="./images/botton/btn_cal_nextyear.gif" width="17" height="13" alt="다음해"></a>
											</div>
											
											<table cellspacing="0" border="1">
											<caption>달력</caption>
											<thead>
											<tr>
											<th scope="col">일</th>
											<th scope="col">월</th>
											<th scope="col">화</th>
											<th scope="col">수</th>
											<th scope="col">목</th>
											<th scope="col">금</th>
											<th scope="col">토</th>
											</tr>
											</thead>
										
											<tbody>	
											<tr>
											<td class="sun">&nbsp;</td>
											<td>&nbsp;</td>
											<td class="selected today"><a href="#">1</a></td>
											<td class="selected"><a href="#">2</a></td>
											<td class="selected"><a href="#">3</a></td>
											<td class="selected"><a href="#">4</a></td>
											<td class="sat selected"><a href="#">5</a></td>
											</tr>
											<tr>
											<td class="sun selected"><a href="#">6</a></td>
											<td class="selectable"><a href="#">7</a></td>
											<td><a href="#">8</a></td>
											<td><a href="#">9</a></td>
											<td><a href="#">10</a></td>
											<td><a href="#">11</a></td>
											<td class="sat"><a href="#">12</a></td>
											</tr>
											
											<tr>
											<td class="sun"><a href="#">13</a></td>
											<td><a href="#">14</a></td>
											<td><a href="#">15</a></td>
											<td><a href="#">16</a></td>
											<td><a href="#">17</a></td>
											<td><a href="#">18</a></td>
											<td class="sat"><a href="#">19</a></td>
											</tr>
											
											<tr>
											<td class="sun"><a href="#">20</a></td>
											<td><a href="#">21</a></td>
											<td><a href="#">22</a></td>
											<td><a href="#">23</a></td>
											<td><a href="#">24</a></td>
											<td><a href="#">25</a></td>
											<td class="sat"><a href="#">26</a></td>
											</tr>
											
											<tr>
											<td class="sun"><a href="#">27</a></td>
											<td><a href="#">28</a></td>
											<td><a href="#">29</a></td>
											<td><a href="#">30</a></td>
											<td><a href="#">31</a></td>
											<td>&nbsp;</td>
											<td class="sat">&nbsp;</td>
											</tr>					
											</tbody>
											</table>
											<!-- //part -->
												
										</div>
										<!-- //달력-->
									</div>
									<div class="grp_b">그래프</div>
								</div>
							</div>





<table width="998" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="17" colspan="3"></td>
	</tr>
	<tr>
		<td colspan="3">
			<script>
				$(function(){
					$("#tab_menu .b").css("cursor", "hand");
					$("#tab_menu .b").click(function() {
						$("#tab_menu .b").attr({
							"background" : "/common/images/watcher/tab_off2.png"
							, "class" : "b pt2"
						});
						$(this).attr({
							"background" : "/common/images/watcher/tab_on2.png"
							, "class" : "b white pt2"
						});
						
						frm_tab.target = "ifm_svr_detail";
						
						if($(this).children("input[name='tab_url']").val() == 'server_detail.env_volt_info.neonex') frm_tab.pagecnt.value = '4';
						else if($(this).children("input[name='tab_url']").val() == 'server_detail.env_fan_info.neonex') frm_tab.pagecnt.value = '8';
						else if($(this).children("input[name='tab_url']").val() == 'server_detail.env_power_info.neonex') frm_tab.pagecnt.value = '4';
						else if($(this).children("input[name='tab_url']").val() == 'server_detail.env_temp_info.neonex') frm_tab.pagecnt.value = '4';
						else frm_tab.pagecnt.value = '10';
						
						frm_tab.action = $(this).children("input[name='tab_url']").val();
						frm_tab.submit();
					});
					
					$("#tab_menu .b").eq(0).click();
				});
			</script>
			<!-- SUB TAB 시작 -->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="4" valign="top" background="/common/images/watcher/tab_ce.jpg"><img height="85" src="/common/images/watcher/tab_lt.jpg"></td>
					<td align="center" background="/common/images/watcher/tab_ce.jpg" style="padding:10px 0 10px 0">
						<table border="0" cellspacing="0" cellpadding="0" id="tab_menu">
							<tr align="center">
								<td width="106" valign="top" background="${img2}/tab_off2.png" class="b pt2">자원정보<input type="hidden" name="tab_url" value="<c:url value='/watcher/go_server_detail.resource_usage.resource_usage.htm?req_data=lst;ResourceLstQry'/>"></td>
								<td width="106" valign="top" background="${img2}/tab_off2.png" class="b pt2">Interface<input type="hidden" name="tab_url" value="<c:url value='/watcher/go_server_detail.snmp_m07.if_info.htm?req_data=data;M07IfInfoLstQry|page_totalcnt;M07IfInfoLstCntQry'/>"></td>
								<td width="106" valign="top" background="${img2}/tab_off2.png" class="b pt2">Traffic<input type="hidden" name="tab_url" value="<c:url value='/watcher/go_server_detail.snmp_m07.traffic_usage.htm?req_data=lst;qry_combo_m07_if'/>"></td>
								<td width="106" valign="top" background="${img2}/tab_off2.png" class="b pt2">장애<input type="hidden" name="tab_url" value="<c:url value='/watcher/go_server_detail.error_stats.error_stats_main.htm'/>"></td>
								<td width="106" valign="top">&nbsp;</td>
								<td width="106" valign="top">&nbsp;</td>
								<td width="106" valign="top">&nbsp;</td>
								<td width="106" valign="top">&nbsp;</td>
								<td width="106" valign="top">&nbsp;</td>
							</tr>
							<tr align="center">
								<td height="33" valign="top">&nbsp;</td>
								<td valign="top">&nbsp;</td>
								<td valign="top">&nbsp;</td>
								<td valign="top">&nbsp;</td>
								<td valign="top">&nbsp;</td>
								<td valign="top">&nbsp;</td>
								<td valign="top">&nbsp;</td>
								<td valign="top">&nbsp;</td>
								<td valign="top">&nbsp;</td>
							</tr>
						</table>
					</td>
					<td width="4" valign="top" background="/common/images/watcher/tab_ce.jpg"><img height="85" src="/common/images/watcher/tab_rt.jpg"></td>
				</tr>
				<tr>
					<td colspan="3">
						<form name="frm_tab" method="post">
							<input type="hidden" name="N_MON_ID" value="${param.N_MON_ID}">
							<input type="hidden" name="nowpage" value="<c:if test='${param.nowpage==null}'>1</c:if>${param.nowpage}">
							<input type="hidden" name="pagecnt" value="10">
						</form>
						<iframe name="ifm_svr_detail" src="" width="100%" height="430" frameborder="0" scrolling="yes"></iframe>
					</td>
				</tr>
			</table>
			<!-- SUB TAB 끝 -->
		</td>
	</tr>
</table>
<%-- <object id="NEOLinkCtrl" style="LEFT: 0px; VISIBILITY: visible; TOP: 0px; Width:0px; Height:0px; "  codebase="${cab}/NeoLinkCtrl.cab#version=1,0,0,1" classid="clsid:2C7FAF28-06A4-423A-A4CB-F2853E8046CA" VIEWASTEXT></object> --%>