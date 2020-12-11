<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/include.jsp" %>

<jsp:useBean id="data" class="java.util.ArrayList" scope="request"/>

	<%@ include file="/WEB-INF/views/include/ListHeadClick.jsp"%>
				<table width="130%" border="0" cellspacing="0" cellpadding="0">
                    <tr align="center">
                      <td width="8%" height="25" background="${img}/table_title.jpg" class="b text11 gray"><thead:thead col="S_MAC_ADDR" name="MAC 주소" reqcol="${param.order_id}" ascdescstring="${asc_desc_String}" sort="${param.asc_desc}"/></td>
                      <td width="8%" background="${img}/table_title.jpg" class="b text11 gray"><thead:thead col="S_NAME" name="장비명" reqcol="${param.order_id}" ascdescstring="${asc_desc_String}" sort="${param.asc_desc}"/></td>
                      <td width="8%" background="${img}/table_title.jpg" class="b text11 gray"><thead:thead col="N_SLOT" name="SLOT개수" reqcol="${param.order_id}" ascdescstring="${asc_desc_String}" sort="${param.asc_desc}"/></td>
                      <td width="8%" background="${img}/table_title.jpg" class="b text11 gray"><thead:thead col="S_CONDITION" name="Condition" reqcol="${param.order_id}" ascdescstring="${asc_desc_String}" sort="${param.asc_desc}"/></td>
                      <td width="8%" background="${img}/table_title.jpg" class="b text11 gray"><thead:thead col="S_STATE" name="State" reqcol="${param.order_id}" ascdescstring="${asc_desc_String}" sort="${param.asc_desc}"/></td>
                      <td width="8%" background="${img}/table_title.jpg" class="b text11 gray"><thead:thead col="S_STATUS" name="Status" reqcol="${param.order_id}" ascdescstring="${asc_desc_String}" sort="${param.asc_desc}"/></td>
                      <td width="8%" background="${img}/table_title.jpg" class="b text11 gray"><thead:thead col="N_TRANS_GOOD" name="TRANS_GOOD" reqcol="${param.order_id}" ascdescstring="${asc_desc_String}" sort="${param.asc_desc}"/></td>
                      <td width="8%" background="${img}/table_title.jpg" class="b text11 gray"><thead:thead col="N_TRANS_BAD" name="TRANS_BAD" reqcol="${param.order_id}" ascdescstring="${asc_desc_String}" sort="${param.asc_desc}"/></td>
                      <td width="8%" background="${img}/table_title.jpg" class="b text11 gray"><thead:thead col="N_RECV_GOOD" name="RECV_GOOD" reqcol="${param.order_id}" ascdescstring="${asc_desc_String}" sort="${param.asc_desc}"/></td>
                      <td width="8%" background="${img}/table_title.jpg" class="b text11 gray"><thead:thead col="N_RECV_BAD" name="RECV_BAD" reqcol="${param.order_id}" ascdescstring="${asc_desc_String}" sort="${param.asc_desc}"/></td>
                      <td width="8%" background="${img}/table_title.jpg" class="b text11 gray"><thead:thead col="S_FIRM_VER" name="FIRM_VER" reqcol="${param.order_id}" ascdescstring="${asc_desc_String}" sort="${param.asc_desc}"/></td>
                      <td width="8%" background="${img}/table_title.jpg" class="b text11 gray"><thead:thead col="N_SPEED" name="SPEED" reqcol="${param.order_id}" ascdescstring="${asc_desc_String}" sort="${param.asc_desc}"/></td>
                    </tr>
                    <c:forEach items="${data}" var="m">
	                    <tr>
	                      <td height="25" align="center" class="line_gray text11">&nbsp;${m.S_MAC_ADDR}&nbsp;</td>
	                      <td height="25" align="center" class="line_gray text11">&nbsp;${m.S_NAME}&nbsp;</td>
	                      <td height="25" class="line_gray text11">&nbsp;${m.N_SLOT}&nbsp;</td>
	                      <td height="25" align="center" class="line_gray text11">&nbsp;${m.S_CONDITION}&nbsp;</td>
	                      <td height="25" align="center" class="line_gray text11">&nbsp;${m.S_STATE}&nbsp;</td>
	                      <td height="25" align="center" class="line_gray text11">&nbsp;<c:if test="${m.N_STATUS=='2'}"><font color="blue"><b>${m.S_STATUS}</b></font></c:if><c:if test="${m.N_STATUS!='2'}"><font color="red"><b>${m.S_STATUS}</b></font></c:if>&nbsp;</td>
	                      <td height="25" align="center" class="line_gray text11">&nbsp;${m.N_TRANS_GOOD}&nbsp;</td>
	                      <td height="25" align="center" class="line_gray text11">&nbsp;${m.N_TRANS_BAD}&nbsp;</td>
	                      <td height="25" align="center" class="line_gray text11">&nbsp;${m.N_RECV_GOOD}&nbsp;</td>
	                      <td height="25" align="center" class="line_gray text11">&nbsp;${m.N_RECV_BAD}&nbsp;</td>
	                      <td height="25" align="center" class="line_gray text11">&nbsp;${m.S_FIRM_VER}&nbsp;</td>
	                      <td height="25" align="center" class="line_gray text11">&nbsp;${m.N_SPEED}&nbsp;</td>
	                    </tr>
                    </c:forEach>                    
                    <tr>
                      <td colspan="12" bgcolor="c2c3c5"><img src="${img}/dot.png"></td>
                    </tr>
                </table>
                <%@ include file="/WEB-INF/views/include/paging/pageNavigate.jsp"%>