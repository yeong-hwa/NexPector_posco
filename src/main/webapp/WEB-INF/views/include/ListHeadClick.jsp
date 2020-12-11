<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="thead" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<jsp:useBean id="asc_desc_String" class="java.util.HashMap" scope="request"/>

		<form name="head_frm" method="post" action="${param.url}">
			<%
				asc_desc_String.put("ASC", "▲");
				asc_desc_String.put("DESC", "▼");

				//request.getParameterNames();
				java.util.Enumeration name_list = request.getParameterNames();

				while(name_list.hasMoreElements())
				{
					String name = (String)name_list.nextElement();
					if(name.equals("order_id")||name.equals("asc_desc"))
						continue;
					out.print("<input type=\"hidden\" name=\""+name+"\" value=\""+request.getParameter(name)+"\">\n");
				}
			%>
			<input type="hidden" name="order_id" value="${param.order_id}">
			<input type="hidden" name=asc_desc value="${param.asc_desc}">
		</form>
		<script>
			function fn_head_click(obj, order_id)
			{
				var name = obj.innerText;
				if(name.substring(name.length-1, name.length) == "${asc_desc_String.ASC}") head_frm.asc_desc.value = "DESC";
				else if(name.substring(name.length-1, name.length) == "${asc_desc_String.DESC}") head_frm.asc_desc.value = "ASC";
				else head_frm.asc_desc.value = "ASC";

				head_frm.order_id.value = order_id;
				head_frm.submit();
			}
		</script>