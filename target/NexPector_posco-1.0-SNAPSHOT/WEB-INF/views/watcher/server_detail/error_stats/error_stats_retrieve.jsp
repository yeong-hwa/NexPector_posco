<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="java.util.Map"%>
<%@ include file="/WEB-INF/views/include/include.jsp" %>

<jsp:useBean id="data" class="java.util.ArrayList" scope="request"/>
<%
	String[][] head = {
		{"발생시각", "15%", "D_UPDATE_TIME"}
		, {"감시종류", "5%", "S_PROCESS"}
		, {"등급", "5%", "S_ALM_RATING_NAME"}
		, {"상태", "5%", "S_ALM_STATUS_NAME"}
		, {"내용", "30%", "S_ALM_MSG"}
	};
%>
<script>
	$(function() {
		$(".stats_row").css("cursor", "hand");
		
		$(".stats_row").hover(function() {
			tmp_color = $(this).css("background-color");
			$(this).css("background-color", "#EEFFEE");
		}, function() {
			$(this).css("background-color", tmp_color);
			tmp_color = "";
		});
		var tmp_color;
		$(".stats_row").click(function() {
			$(".stats_row").css("background-color", "");
			$(this).css("background-color", "#BBFFEE");
			tmp_color = $(this).css("background-color");
			
			parent.fn_retrieve_error_history($(this).children("td").children("input[name='S_ALM_KEY']").val());
		});
		
		$(".stats_row").eq(0).click();
	});
</script>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr align="center">
                    	<% for(int i=0;i<head.length;i++) {%>
                    		<td width="<%=head[i][1]%>" height="25" background="${img2}/table_title.jpg" class="b text11 gray"><label style="cursor:pointer;" onclick="fn_head_click(this,'<%=head[i][2]%>')"><%=head[i][0]%><%=(request.getParameter("order_id")!=null&&request.getParameter("order_id").equals(head[i][2]))?(request.getParameter("asc_desc")!=null&&(request.getParameter("asc_desc").toString().equals("ASC"))?"▲":"▼"):""%></label></td>
                    	<%}%>
                    	<td width="5%" background="${img2}/table_title.jpg" class="b text11 gray">복구</td>
                    </tr>
                    <%
                    if(data.size() > 0){
                    	for(int j=0;j<data.size();j++)
                    	{
                    %>
                    	<tr class="stats_row">
	                    	<% for(int i=0;i<head.length;i++) {%>
	                    		<td height="25" align="center" class="line_gray text11" title='<%=((Map)data.get(j)).get("TOOL_S_ALM_MSG")%>'>&nbsp;<%=((Map)data.get(j)).get(head[i][2])%>&nbsp;</td>
	                    	<%}%>
	                    	<td height="25" align="center" class="line_gray text11">
	                    		<img src="${img2}/btn_warnview.gif" onclick="parent.fn_alarm_history_popup('<%=((Map)data.get(j)).get("N_MON_ID")%>','<%=((Map)data.get(j)).get("S_ALM_KEY")%>')">
	                    		<input type="hidden" name="S_ALM_KEY" value="<%=((Map)data.get(j)).get("S_ALM_KEY")%>">
	                    	</td>
	                    </tr>
                    <%
                    	}
                    } else {
                    %>
                    	<tr class="stats_row">
	                    	<td height="25" align="center" colspan="7">검색된 데이터가 없음</td>
	                    </tr>
                    <%
                    }
                    %>
                    <tr>
                      <td colspan="17" bgcolor="c2c3c5"><img src="${img2}/dot.png"></td>
                    </tr>
                </table>
                <table width="100%">
	                <tr>
	                	<td>
							<div id="paging"></div>
	                	</td>
	                </tr>
                </table>
<form name="frm" method="post">
<%
    java.util.Enumeration name_list = request.getParameterNames();

	while(name_list.hasMoreElements())
	{
		String name = (String)name_list.nextElement();
		if(name.equals("order_id")||name.equals("asc_desc")||name.equals("nowpage")||name.equals("pagecnt")||name.equals("page_totalcnt"))
			continue;
		out.print("<input type=\"hidden\" name=\""+name+"\" value=\""+request.getParameter(name)+"\">\n");
	}
%>
    <input type="hidden" name="nowpage" value="<c:if test='${param.nowpage==null}'>1</c:if>${param.nowpage}">
	<input type="hidden" name="pagecnt" value="${param.pagecnt}">
	<input type="hidden" name="page_totalcnt" value="${page_totalcnt.CNT}">
	<input type='hidden' name='order_id' value='${param.order_id}'>
	<input type='hidden' name='asc_desc' value='${param.asc_desc}'>
</form>
<script>
	//테이블 소트 기능
	function fn_head_click(obj, col)
	{
		$("input[name='order_id']").val(col);
		$("input[name='asc_desc']").val($("input[name='asc_desc']").val() == "ASC"?"DESC":"ASC");
		
		$("form[name='frm']").submit();
		
		//fn_retrieve();
	}
	$(function(){
		param = $("form[name='frm']").serialize();
		$.post("<c:url value='/pageNavigate.htm'/>", param, function(str){
			$("#paging").html(str);
		});
	});
</script>
