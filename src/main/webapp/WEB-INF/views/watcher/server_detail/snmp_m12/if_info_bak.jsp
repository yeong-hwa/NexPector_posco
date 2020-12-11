<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/include.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>

<%
	String[][] head = {
		{"interface명", "22%", "S_IF_DESCR"}
		, {"IfType", "5%", "S_TYPE_NAME"}
		, {"MTU", "3%", "N_IF_MTU"}
		, {"BPS", "5%", "N_IF_SPEED"}
		, {"물리 주소", "5%", "S_IF_PHYS_ADDRESS"}
		, {"ADMIN 상태", "5%", "S_ADMIN_STATUS"}
		, {"운영 상태", "7%", "S_OPER_STATUS"}
	};
%>
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
			                    <tr>
				                    <td height="25" align="center" class="line_gray text11">&nbsp;${m.S_IF_DESCR}&nbsp;</td>
									<td height="25" align="center" class="line_gray text11">&nbsp;${m.S_TYPE_NAME}&nbsp;</td>
				                    <td height="25" align="center" class="line_gray text11">&nbsp;${m.N_IF_MTU}&nbsp;</td>
				                    <td height="25" align="center" class="line_gray text11">&nbsp;${m.N_IF_SPEED}&nbsp;</td>
				                    <td height="25" align="center" class="line_gray text11">&nbsp;${m.S_IF_PHYS_ADDRESS}&nbsp;</td>
				                    <td height="25" align="center" class="line_gray text11">&nbsp;<c:if test="${m.N_IF_ADMIN_STATUS=='1'}"><font color="blue"><b>${m.S_ADMIN_STATUS}</b></font></c:if><c:if test="${m.N_IF_ADMIN_STATUS!='1'}"><font color="red"><b>${m.S_ADMIN_STATUS}</b></font></c:if>&nbsp;</td>
				                    <td height="25" align="center" class="line_gray text11">&nbsp;<c:if test="${m.N_IF_OPER_STATUS=='1'}"><font color="blue"><b>${m.S_OPER_STATUS}</b></font></c:if><c:if test="${m.N_IF_OPER_STATUS!='1'}"><font color="red"><b>${m.S_OPER_STATUS}</b></font></c:if>&nbsp;</td>
			                    </tr>
		                    </c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td height="25" align="center" class="line_gray text11" colspan="6">검색된 데이터가 없음</td>
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
	<input type="hidden" name="page_totalcnt" value="${page_totalcnt.get(0).CNT}">
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