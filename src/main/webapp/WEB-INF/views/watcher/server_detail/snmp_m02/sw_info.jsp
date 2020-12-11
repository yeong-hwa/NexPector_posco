<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/include.jsp" %>

<jsp:useBean id="data" class="java.util.ArrayList" scope="request"/>

	<%@ include file="/WEB-INF/views/include/ListHeadClick.jsp"%>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr align="center">
                      <td width="10%" height="25" background="${img}/table_title.jpg" class="b text11 gray"><thead:thead col="S_NAME" name="장비명" reqcol="${param.order_id}" ascdescstring="${asc_desc_String}" sort="${param.asc_desc}"/></td>
                      <td width="10%" background="${img}/table_title.jpg" class="b text11 gray"><thead:thead col="S_TYPE" name="장비타입" reqcol="${param.order_id}" ascdescstring="${asc_desc_String}" sort="${param.asc_desc}"/></td>
                      <td width="10%" background="${img}/table_title.jpg" class="b text11 gray"><thead:thead col="S_DESC" name="설명" reqcol="${param.order_id}" ascdescstring="${asc_desc_String}" sort="${param.asc_desc}"/></td>
                      <td width="10%" background="${img}/table_title.jpg" class="b text11 gray"><thead:thead col="S_STATUS" name="등록상태" reqcol="${param.order_id}" ascdescstring="${asc_desc_String}" sort="${param.asc_desc}"/></td>
                      <td width="10%" background="${img}/table_title.jpg" class="b text11 gray"><thead:thead col="S_VERSION" name="버전" reqcol="${param.order_id}" ascdescstring="${asc_desc_String}" sort="${param.asc_desc}"/></td>
                    </tr>
                    <c:forEach items="${data}" var="m">
	                    <tr>
	                      <td height="25" align="center" class="line_gray text11">&nbsp;${m.S_NAME}&nbsp;</td>
	                      <td height="25" align="center" class="line_gray text11">&nbsp;${m.S_TYPE}&nbsp;</td>
	                      <td height="25" class="line_gray text11">&nbsp;${m.S_DESC}&nbsp;</td>
	                      <td height="25" align="center" class="line_gray text11">&nbsp;<c:if test="${m.N_STATUS=='2'}"><font color="blue"><b>${m.S_STATUS}</b></font></c:if><c:if test="${m.N_STATUS!='2'}"><font color="red"><b>${m.S_STATUS}</b></font></c:if>&nbsp;</td>
	                      <td height="25" align="center" class="line_gray text11">&nbsp;${m.S_VERSION}&nbsp;</td>
	                    </tr>
                    </c:forEach>
                    <tr>
                      <td colspan="6" bgcolor="c2c3c5"><img src="${img}/dot.png"></td>
                    </tr>
                </table>
                <%@ include file="/WEB-INF/views/include/paging/pageNavigate.jsp"%>