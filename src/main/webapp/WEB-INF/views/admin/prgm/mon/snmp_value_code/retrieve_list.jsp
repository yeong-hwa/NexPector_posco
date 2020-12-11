<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="/WEB-INF/views/include/include.jsp" %>

<jsp:useBean id="data" class="java.util.ArrayList" scope="request"/>

<script>
	function fn_record_click(val)
	{
		parent.fn_insert(val);
	}
</script>
	<table width="100%" height="500">
		<tr>
	    	<td width="15%" height="47" background="${img1}/sotitle_bg.jpg" class="b f14">
	    		<img src="${img1}/sotitle_icon.jpg" hspace="3" align="absmiddle">SNMP 장비
	    	</td>
	    	<td width="15%" height="47" background="${img1}/sotitle_bg.jpg" class="b f14">
	    		<img src="${img1}/sotitle_icon.jpg" hspace="3" align="absmiddle">SNMP 감시명
	    	</td>
	    	<td width="25%" height="47" background="${img1}/sotitle_bg.jpg" class="b f14">
	    		<img src="${img1}/sotitle_icon.jpg" hspace="3" align="absmiddle">SNMP 감시 코드
	    	</td>
	    	<td width="25%" height="47" background="${img1}/sotitle_bg.jpg" class="b f14">
	    		<img src="${img1}/sotitle_icon.jpg" hspace="3" align="absmiddle">SNMP 감시 상세 코드
	    	</td>
  		</tr>
  		<tr>
  			<td>
  				<table width="100%">
  					<tr>
  						<td height="29" class="table_title text11 b" align="center">장비명</td>
  					</tr>
  				</table>
  				<script>
  					var man_code = "";
  					var mon_code = "";
  					var value_code = "";
  				
  					var tcolor;
  					// SNMP Value  코드 관리 로딩
  					$(function(){
  						$("#div_SNMP_MAN_CODE table tr").css("cursor", "hand");
  						
  						$("#div_SNMP_MAN_CODE table tr").hover(function(){tr_over(this)}, function(){tr_out(this)});
  						
  						$("#div_SNMP_MAN_CODE table tr").click(function(){
  							$("#div_SNMP_MAN_CODE table tr").css("background-color", "#FFFFFF");
  							tcolor = "#FF7777";
  							$(this).css("background-color", tcolor);
  							
  							man_code = $(this).children("td").children("input[name='N_SNMP_MAN_CODE']").val();
  							mon_code = "";
  							value_code = "";
  							
  							fn_snmp_man_click(man_code);
  						});
  					});
  					
  					// 마우스 오버시 실행
  					function tr_over(obj)
  					{
  						tcolor = $(obj).css("background-color");
						$(obj).css("background-color", "#8BE3FA");
  					}
  					
  					// 마우스 아웃시 실행
  					function tr_out(obj)
  					{
  						$(obj).css("background-color", tcolor);
  						tcolor = "";
  					}
  					
  					// SNMP 장비(장비명) 영역 클릭시 실행
  					function fn_snmp_man_click(val)
  					{
  						var param = "";
  						param += "N_SNMP_MAN_CODE="+val;
  						
  						$.post("<c:url value="/admin/lst_RetrieveSnmpMonCodeQry.htm"/>", param, function(str){
  							var data = $.parseJSON(str);
  							
  							var tdsize = $(data).size();
  							
  							if(tdsize>=1){
  								<!-- 검색된 데이타가 있을때 시작 -->
	  							var make_str = "";
	  							
	  							// SNMP 감시코드  html 셋팅
	  							var make_str1 = "";
	  							// SNMP 감시 상세 코드 html 셋팅
	  							var make_str2 = "";
	  							
	  							
	  							$(data).each(function(){
	  								// 하위값이 null 이거나 공백일때
	  								if(this.S_DESC=='' || this.S_DESC==null){
	  									make_str += "<tr><td align=\"center\" class=\"line_gray\">&nbsp; 검색된 데이타가 없음 &nbsp;</td></tr>";
	  									
	  									$("#div_SNMP_MON_CODE").html(make_str);
	  		  	  						
	  		  							$("#div_SNMP_MON_CODE table tr").css("cursor", "hand");
	  		  	  						
	  		  	  						$("#div_SNMP_MON_CODE table tr").hover(function(){tr_over(this)}, function(){tr_out(this)});
	  		  	  						return;
	  								}
	  								else {
	  									make_str += "<tr><td align=\"center\" class=\"line_gray\">&nbsp;" + this.S_DESC + "<input type='hidden' name='N_SNMP_MON_CODE' value='" + this.N_SNMP_MON_CODE + "'></td></tr>";	
	  								}	  								
	  							});
	  							
	  							make_str = "<table width=\"100%\" class=\"row_list\">" + make_str + "</table>";
	  							
	  							$("#div_SNMP_MON_CODE").html(make_str);
	  							$("#div_SNMP_VALUE_CODE").html(make_str1);
	  							$("#div_SNMP_VALUE_TYPE_CODE").html(make_str2);
	  	  						
	  							$("#div_SNMP_MON_CODE table tr").css("cursor", "hand");
	  	  						
	  	  						$("#div_SNMP_MON_CODE table tr").hover(function(){tr_over(this)}, function(){tr_out(this)});
	  	  						
	  	  						$("#div_SNMP_MON_CODE table tr").click(function(){
	  	  							$("#div_SNMP_MON_CODE table tr").css("background-color", "#FFFFFF");
	  	  							tcolor = "#FF7777";
	  	  							$(this).css("background-color", tcolor);
	  	  							
	  	  							mon_code = $(this).children("td").children("input[name='N_SNMP_MON_CODE']").val();
	  	  							
	  	  							// 조회할 값이 null 이거나 공백, undefined 실행여부 파악
		  	  						if(mon_code==null || mon_code=='' || mon_code=='undefined'){
		  								alert("조회할 데이타가 없음");
		  							} else {
		  								fn_snmp_mon_click(man_code, mon_code);	
		  							}
	  	  						});
  							}
  							<!-- 검색된 데이타가 있을때 종료 -->
  							<!-- 검색된 데이타가 없을때 시작 -->
  							else {
  								var array = [{tag: "1"}];
  								var make_str = "";
  								jQuery.each(array, function(idx, value){
  									var tmp_obj = this;
  									make_str += "<tr><td align=\"center\" class=\"line_gray\">&nbsp; 검색된 데이타가 없음 &nbsp;</td></tr>";
  								})
  								
  								$("#div_SNMP_MON_CODE").html(make_str);
  								
								$("#div_SNMP_MON_CODE table tr").css("cursor", "hand");
		  						
		  						$("#div_SNMP_MON_CODE table tr").hover(function(){tr_over(this)}, function(){tr_out(this)});
  							}
  							<!-- 검색된 데이타가 없을때 종료 -->
  						});
  					}
  					
  					// SNMP 감시명(감시명) 영역 클릭시 실행
  					function fn_snmp_mon_click(val1, val2)
  					{
  						var param = "";
  						param += "N_SNMP_MAN_CODE="+val1;
  						param += "&N_SNMP_MON_CODE="+val2;
  						
  						$.post("<c:url value="/admin/lst_RetrieveSnmpValueCodeQry.htm"/>", param, function(str){
							var data = $.parseJSON(str);
							
  							var tdsize = $(data).size();
							
  							if(tdsize>=1){
  								<!-- 검색된 데이타가 있을때 시작 -->
  								var make_str = "";
  								
  								// 감시코드 html 셋팅
  								var make_str1 = "";
  								
  								this.N_SNMP_TYPE_CODE
	  							$(data).each(function(){
	  								if((this.S_DESC=='' || this.S_DESC==null) && (this.N_VALUE_TYPE_CODE=='' || this.N_VALUE_TYPE_CODE==null)){
										make_str += "<tr><td align=\"center\" class=\"line_gray\">&nbsp; 검색된 데이타가 없음</td></tr>";
	  								}
	  								else{
	  									make_str += "<tr><td align=\"center\" class=\"line_gray\">&nbsp;" + this.S_DESC + "<input type='hidden' name='N_SNMP_TYPE_CODE' value='" + this.N_SNMP_TYPE_CODE + "'><input type='hidden' name='N_VALUE_TYPE_CODE' value='" + this.N_VALUE_TYPE_CODE + "'></td></tr>";
	  								}
	  							});
	  							
	  							make_str = "<table width=\"100%\" class=\"row_list\">" + make_str + "</table>";
		  						$("#div_SNMP_VALUE_CODE").html(make_str);
		  						$("#div_SNMP_VALUE_TYPE_CODE").html(make_str1);
		  						
								$("#div_SNMP_VALUE_CODE table tr").css("cursor", "hand");
		  						
		  						$("#div_SNMP_VALUE_CODE table tr").hover(function(){tr_over(this)}, function(){tr_out(this)});
		  						
		  						$("#div_SNMP_VALUE_CODE table tr").click(function(){
		  							$("#div_SNMP_VALUE_CODE table tr").css("background-color", "#FFFFFF");
		  							tcolor = "#FF7777";
		  							$(this).css("background-color", tcolor);
		  							
		  							value_code = $(this).children("td").children("input[name='N_VALUE_TYPE_CODE']").val();
		  							
		  							if(value_code==null || value_code=='' || value_code=='undefined'){
		  								alert("조회할 데이타가 없음");
		  								value_code = "";
		  							} else {
		  								fn_snmp_value_click(man_code, mon_code, value_code);	
		  							}
		  							
		  						});
  							}
  							<!-- 검색된 데이타가 있을때 종료 -->
  							<!-- 검색된 데이타가 없을때 시작 -->
  							else {
  								var array = [{tag: "1"}];
  								var make_str = "";
  								jQuery.each(array, function(idx, value){
  									var tmp_obj = this;
  									make_str += "<tr><td align=\"center\" class=\"line_gray\">&nbsp; 검색된 데이타가 없음 &nbsp;</td></tr>";
  								})
  								
  								$("#div_SNMP_VALUE_CODE").html(make_str);
  								
								$("#div_SNMP_VALUE_CODE table tr").css("cursor", "hand");
		  						
		  						$("#div_SNMP_VALUE_CODE table tr").hover(function(){tr_over(this)}, function(){tr_out(this)});
  							}
  							<!-- 검색된 데이타가 없을때 종료 -->
  						});
  					}
  					
  					// SNMP 감시 코드(감시 코드) 영역 클릭시 실행
  					function fn_snmp_value_click(val1, val2, val3)
  					{
  						var param = "";
  						param += "N_SNMP_MAN_CODE="+val1;
  						param += "&N_SNMP_MON_CODE="+val2;
  						param += "&N_VALUE_TYPE_CODE="+val3;
  						
  						$.post("<c:url value="/admin/lst_RetrieveSnmpValueTypeCodeQry.htm"/>", param, function(str){
							var data = $.parseJSON(str);
							
							var tdsize = $(data).size();
							
  							if(tdsize>=1){
  								<!-- 검색된 데이타가 있을때 시작 -->
	  							var make_str = "";
	  							$(data).each(function(){
	  								if((this.S_OUT_VALUE=='' || this.S_OUT_VALUE==null) && (this.S_IN_VALUE=='' || this.S_IN_VALUE==null)){
	  									make_str += "<tr><td align=\"center\" class=\"line_gray\">&nbsp; 검색된 데이타가 없음</td></tr>";
	  								}
	  								else {
	  									make_str += "<tr><td align=\"center\" class=\"line_gray\">&nbsp;" + this.S_OUT_VALUE + "<input type='hidden' name='S_IN_VALUE' value='" + this.S_IN_VALUE + "'></td></tr>";
	  								}
	  							});
	  							
	  							make_str = "<table width=\"100%\" class=\"row_list\">" + make_str + "</table>";
	  	  						$("#div_SNMP_VALUE_TYPE_CODE").html(make_str);
	  	  						
	  							$("#div_SNMP_VALUE_TYPE_CODE table tr").css("cursor", "hand");
	  	  						
	  	  						$("#div_SNMP_VALUE_TYPE_CODE table tr").hover(function(){tr_over(this)}, function(){tr_out(this)});
	  	  						
	  	  						$("#div_SNMP_VALUE_TYPE_CODE table tr").click(function(){
	  	  							$("#div_SNMP_VALUE_TYPE_CODE table tr").css("background-color", "#FFFFFF");
	  	  							tcolor = "#FF7777";
	  	  							$(this).css("background-color", tcolor);
	  	  						});
  							}
  							<!-- 검색된 데이타가 있을때 종료 -->
  							<!-- 검색된 데이타가 없을때 시작 -->
  							else {
  								var array = [{tag: "1"}];
  								var make_str = "";
  								jQuery.each(array, function(idx, value){
  									var tmp_obj = this;
  									make_str += "<tr><td align=\"center\" class=\"line_gray\">&nbsp; 검색된 데이타가 없음 &nbsp;</td></tr>";
  								})
  								
  								$("#div_SNMP_VALUE_CODE").html(make_str);
  								
								$("#div_SNMP_VALUE_CODE table tr").css("cursor", "hand");
		  						
		  						$("#div_SNMP_VALUE_CODE table tr").hover(function(){tr_over(this)}, function(){tr_out(this)});
  							}
  							<!-- 검색된 데이타가 없을때 종료 -->
  						});
  					}
  				</script>
  				<div id="div_SNMP_MAN_CODE" style="overflow-y:scroll;height:100%">
  				<table width="100%" class="row_list">
  				<c:forEach items="${data}" var="m">
  					<tr><td align="center" class="line_gray">&nbsp;${m.S_DESC}<input type="hidden" name="N_SNMP_MAN_CODE" value="${m.N_SNMP_MAN_CODE}"></td></tr>
  				</c:forEach>
  				</table>
  				</div>
  				<table>
  					<tr>
                		<td colspan="99" bgcolor="3b3b3b"><img src="${img1}/dot.png"></td>
              		</tr>
  				</table>
  			</td>
  			<td>
  				<table width="100%">
  					<tr>
  						<td height="29" class="table_title text11 b" align="center">감시명</td>
  					</tr>
  				</table>
  				<div id="div_SNMP_MON_CODE" style="overflow-y:scroll;height:100%">
  				
  				</div>
  			</td>
  			<td>
  				<table width="100%">
  					<tr>
  						<td height="29" class="table_title text11 b" align="center">감시 코드</td>
  					</tr>
  				</table>
  				<div id="div_SNMP_VALUE_CODE" style="overflow-y:scroll;height:100%">
  					
  				</div>
  			</td>
  			<td>
  				<table width="100%">
  					<tr>
  						<td height="29" class="table_title text11 b" align="center">감시 상세 코드</td>
  					</tr>
  				</table>
  				<div id="div_SNMP_VALUE_TYPE_CODE" style="overflow-y:scroll;height:100%">
  				
  				</div>
  			</td>
  		</tr>
  	</table>
