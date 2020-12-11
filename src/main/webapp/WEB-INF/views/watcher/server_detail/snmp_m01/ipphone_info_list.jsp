<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/include.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>

<jsp:useBean id="data" class="java.util.ArrayList" scope="request"/>

<%
	String[][] head = {
		{"그룹", "10%", "N_GROUP"}
		, {"내선번호", "10%", "S_EXT_NUM"}
		, {"전화기 상태", "15%", "S_VALUE"}
		, {"MAC Address", "15%", "S_MACADDRESS"}
		, {"IP", "10%", "S_IPADDRESS"}
		, {"Description", "50%", "S_NAME"}
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
			                    <tr class="text11 tr_row_list" ${m.N_STAT=="3"?"bgcolor='#FF7777'":"bgcolor=''"}>
			                        <td width="10%" class="line_gray" height="25" align="center">${m.S_GROUP_NAME}&nbsp;</td>
			                        <td width="10%" class="line_gray" height="25" align="center">${m.S_EXT_NUM}&nbsp;</td>
			                        <td width="15%" class="line_gray" align="center">${m.S_VALUE }</td>	<!-- 전화기 상태 2014-12-19 변경 -->
			                        <td width="15%" class="line_gray" align="center">${m.S_MACADDRESS}&nbsp;</td>
			                        <td width="10%" class="line_gray" align="center">${m.S_IPADDRESS}&nbsp;</td>
			                        <td width="50%" class="line_gray" align="center">${m.S_NAME}&nbsp;</td>
			                    </tr>
		                    </c:forEach>
						</c:when>
						<c:otherwise>
							<tr class="text11 tr_row_list" ${m.N_STAT=="3"?"bgcolor='#FF7777'":"bgcolor=''"}>
								<td class="line_gray" height="25" align="center" colspan="6">검색된 데이터가 없음</td>
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
<form name="frm" method="post">
    <input type="hidden" name="nowpage" value="<c:if test='${param.nowpage==null}'>1</c:if>${param.nowpage}">
	<input type="hidden" name="pagecnt" value="${param.pagecnt}">
	<input type="hidden" name="page_totalcnt" value="${page_totalcnt.get(0).CNT}">
	<input type='hidden' name='order_id' value='${param.order_id}'>
	<input type='hidden' name='asc_desc' value='${param.asc_desc}'>
	<input type="hidden" name="N_MON_ID" value="${param.N_MON_ID}">
	<input type="hidden" name="N_GROUP" value="${param.N_GROUP}">
	<input type="hidden" name="S_EXT_NUM" value="${param.S_EXT_NUM}">
	<input type="hidden" name="S_IPADDRESS" value="${param.S_IPADDRESS}">
	<input type="hidden" name="S_MACADDRESS" value="${param.S_MACADDRESS}">
	<input type="hidden" name="S_PHONE_STATUS" value="${param.S_PHONE_STATUS}">
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
