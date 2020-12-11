<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<jsp:useBean id="data" class="java.util.ArrayList" scope="request"/>
<%@ include file="/WEB-INF/views/include/include.jsp" %>

<script>
	$(function() {
		$("#btn_excel").css("cursor", "hand");
		
		$("#btn_excel").click(function() {
			parent.fn_excel();
		});
	});
</script>
<body style="background:transparent;">                 
<%
	String[][] head = {
		{"발생시각", "15%", "D_UPDATE_TIME"}
		, {"장비명", "10%", "S_MON_NAME"}
		, {"장비IP", "10%", "S_MON_IP"}
		, {"장애등급", "8%", "S_ALM_RATING_NAME"}
		, {"상태", "8%", "N_ALM_STATUS_NAME"}
		, {"처리자ID", "10%", "S_USER_ID"}
		, {"처리자", "10%", "S_USER_NAME"}
		, {"내용", "30%", "S_MSG"}
	};
%>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="4"><img src="${img2}/tab_lt.jpg"></td>
                <td align="right" background="${img2}/tab_ce.jpg" class="pl13"><table width="200" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td align="right">
                      	<img id="btn_excel" src="${img2}/btn_excel.jpg" hspace="15"/>
                      </td>
                    </tr>
                  </table></td>
                <td width="4"><img src="${img2}/tab_rt.jpg"></td>
              </tr>
              <tr>
                <td background="${img2}/tab_lc.jpg">&nbsp;</td>
                <td bgcolor="#FFFFFF" style="padding:15px 20px 20px 20px"><!-- 콜 이력 조회 시작 -->
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td height="45" colspan="23"class="b gray_sub"><img src="${img2}/icon_result.jpg" align="absmiddle">장애 이력 조회</td>
                    </tr>
                    <tr align="center">
                    	<td>
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
			                    <tr align="center">
			                    	<% for(int i=0;i<head.length;i++) {%>
			                    		<td width="<%=head[i][1]%>" height="25" background="${img2}/table_title.jpg" class="b text11 gray"><label style="cursor:pointer;" onclick="fn_head_click(this,'<%=head[i][2]%>')"><%=head[i][0]%><%=(request.getParameter("order_id")!=null&&request.getParameter("order_id").equals(head[i][2]))?(request.getParameter("asc_desc")!=null&&(request.getParameter("asc_desc").toString().equals("ASC"))?"▲":"▼"):""%></label></td>
			                    	<%}%>
			                    </tr>
			                    <c:set var="msize" value="${fn:length(data)}"/>
			                    <c:choose>
			                    	<c:when test="${msize > 0}">
			                    			<c:forEach items="${data}" var="m">
							                    <tr align="center">
							                    	  <td height="31" class="line_gray text11">&nbsp;${m.D_UPDATE_TIME}</td>
								                      <td height="31" class="line_gray text11">&nbsp;${m.S_MON_NAME}</td>
								                      <td height="31" class="line_gray text11">&nbsp;${m.S_MON_IP}</td>
								                      <td height="31" class="line_gray text11" style="color:#DDDDDD" bgcolor="${m.N_ALM_RATING=='1'?'#FF2222':(m.N_ALM_RATING=='2'?'#FF8833':'#FF88AA')}">&nbsp;${m.S_ALM_RATING_NAME}</td>
								                      <td height="31" class="line_gray text11">&nbsp;${m.N_ALM_STATUS_NAME}</td>
								                      <td height="31" class="line_gray text11">&nbsp;${m.S_USER_ID}</td>
								                      <td height="31" class="line_gray text11">&nbsp;${m.S_USER_NAME}</td>
								                      <td height="31" class="line_gray text11" align="left">&nbsp;${m.S_MSG}</td>
							                    </tr>
										</c:forEach>
				                    </c:when>
				                    <c:otherwise>
				                    	<tr align="center">
					                    	  <td height="31" class="line_gray text11" colspan="8">검색된 데이터가 없음</td>	
				                    	</tr>
				                    </c:otherwise>
			                    </c:choose>
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
</body>
