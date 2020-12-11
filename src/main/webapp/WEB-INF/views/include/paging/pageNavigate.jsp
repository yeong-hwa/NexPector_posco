<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="<c:url value="/common/css/default.css"/> rel="stylesheet" type="text/css">
<c:set var="img"><c:url value='/common/images/paging'/></c:set>
<!-- 페이지  -->
<%-- 		<jsp:useBean id="page_totalcnt" class="java.lang.String" scope="request"/>		 --%>
		<form name="page_frm" method="post" action="">
			<%
				java.util.Enumeration en = request.getParameterNames();
				
				while(en.hasMoreElements())
				{
					String name = (String)en.nextElement();
					if(name.equals("pageno")||name.equals("pagecnt")||name.equals("url")||name.equals("nowpage")||name.equals("page_totalcnt")||name.equals("max_pageNo"))
						continue;
					out.print("<input type=\"hidden\" name=\""+name+"\" value=\""+request.getParameter(name)+"\">\n");
				}
			%>
			<input type="hidden" name="pagecnt" value="${param.pagecnt}">
			<input type="hidden" name="url" value="${param.url}">
			<input type="hidden" name="nowpage" value="${param.nowpage}">
<%-- 			<input type="hidden" name="totalPageno" value="${param.page_totalcnt/param.pagecnt}"> --%>
			<input type="hidden" name="max_pageNo" value="${param.max_pageNo}">
			<input type="hidden" name="page_totalcnt" value="${param.page_totalcnt}">
		</form>
		<script>
			if('${param.url}' == '')
			{
				var str = "url"+window.location;
				var url = str.split('<%=request.getContextPath()%>/');
				
				if(url.length == 2)
				{
					$("input[name='url']").val(url[1]);
// 					page_frm.url.value = url[1];
				}
			}

			function goPage(pageno)
			{
				var nurl = location.pathname;
				$("input[name='nowpage']").val(pageno);
				
				if(nurl.indexOf("watcher") >= 0)
				{
					page_frm.nowpage.value=pageno;
					document.page_frm.submit();
				}else{
					fn_retrieve(pageno);
				}
			}
		</script>
	 
		<%
			//현재 페이지번호
			int nowPage = 1;
			//총 페이지 번호
			int totalPageno = 1;
			//최대 표시 페이지 번호 개수
			int max_pageNo = 10;
try{
				nowPage = (request.getParameter("nowpage")!=null && !request.getParameter("nowpage").equals(""))?Integer.parseInt(request.getParameter("nowpage")):1;			
				max_pageNo = (request.getParameter("max_pageNo")!=null && !request.getParameter("max_pageNo").equals(""))?Integer.parseInt(request.getParameter("max_pageNo")):10;			
				totalPageno = (request.getParameter("page_totalcnt")!=null && !request.getParameter("page_totalcnt").equals(""))?(Integer.parseInt(request.getParameter("page_totalcnt"))/Integer.parseInt(request.getParameter("pagecnt")))+1:1;
				if(Integer.parseInt(request.getParameter("page_totalcnt"))%Integer.parseInt(request.getParameter("pagecnt")) == 0)
					totalPageno -= 1;
}catch(Exception e){
	System.out.println("nowpage = " + request.getParameter("nowpage"));
	System.out.println("max_pageNo = " + request.getParameter("max_pageNo"));
	System.out.println("page_totalcnt = " + request.getParameter("page_totalcnt"));
	System.out.println("pagecnt = " + request.getParameter("pagecnt"));
	e.printStackTrace();
}
			//현재 페이지 번호로 표시할 페이지 범위 계산
			int tmp = (((nowPage-1)/max_pageNo)+1);			
		%>
				
		<c:set var="nowPage" value="<%=nowPage%>"/>
		<c:set var="totalPageno" value="<%=totalPageno%>"/>
		<c:set var="max_pageNo" value="<%=max_pageNo%>"/>
		<c:set var="tmp" value="<%=tmp%>"/>
		
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr valign="middle">
				<td align="center">
					<!-- 맨앞 페이지 -->
					<c:choose>
						<c:when test="${nowPage <= 1}">
							<img src="${img}/btn_pre02.jpg" align="absmiddle">
						</c:when>
						<c:otherwise>
							<a style="cursor:hand;" href="javascript:goPage('1')"><img src="${img}/btn_pre02.jpg" align="absmiddle"></a>
						</c:otherwise>
					</c:choose>
					<!-- 이전 시작 페이지 -->
					<c:choose>
						<c:when test="${nowPage <= max_pageNo}">
							<img src="${img}/btn_pre.jpg" hspace="8" align="absmiddle">
						</c:when>
						<c:otherwise>
							<a style="cursor:hand;" href="javascript:goPage('${((tmp-1)*max_pageNo)}')"><img src="${img}/btn_pre.jpg" hspace="8" align="absmiddle"></a>
						</c:otherwise>
					</c:choose>
					<!-- 페이지 번호 -->
					<font color='#CDCDCD'>ㅣ</font>
					<c:forEach var="pageNo" begin="${((tmp-1)*max_pageNo)+1}" end="${tmp*max_pageNo}">
						<c:choose>
							<c:when test="${totalPageno < pageNo}">
								
							</c:when>
							<c:when test="${nowPage == pageNo}">
								<span class="red b"><b>${pageNo}</b></span>
								<font color='#CDCDCD'>ㅣ</font>
							</c:when>
							<c:otherwise>
								<a href="javascript:goPage('${pageNo}')"><b>${pageNo}</b></a>
								<font color='#CDCDCD'>ㅣ</font>
							</c:otherwise>
						</c:choose>
					</c:forEach>					
					<!-- 다음 시작 페이지 -->
					<c:choose>
						<c:when test="${totalPageno <= tmp*max_pageNo}">
							<img src="${img}/btn_next.jpg" hspace="8" align="absmiddle">
						</c:when>
						<c:otherwise>
							<a style="cursor:hand;" href="javascript:goPage('${tmp*max_pageNo+1}')"><img src="${img}/btn_next.jpg" hspace="8" align="absmiddle"></a>							
						</c:otherwise>
					</c:choose>		
					<!-- 맨뒤 페이지 -->
					<c:choose>
						<c:when test="${nowPage == totalPageno or totalPageno < 1}">
							<img src="${img}/btn_next02.jpg" align="absmiddle" >
						</c:when>
						<c:otherwise>							
							<a style="cursor:hand;" href="javascript:goPage('${totalPageno}')"><img src="${img}/btn_next02.jpg" align="absmiddle" ></a>
						</c:otherwise>
					</c:choose>					
				</td>
				<td width="180">&nbsp;&nbsp;<font color="blue"><b>건수 : ${param.page_totalcnt}</b></font></td>
			</tr>
		</table>