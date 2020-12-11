<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/include.jsp" %>

<jsp:useBean id="data" class="java.util.ArrayList" scope="request"/>
<table border="0" width="0" height="12" style="line-height:0;"><tr><td>&nbsp;</td></tr></table>
<script>
	function fn_retrieve()
	{
		var ifm_url_str = window.location + " ";

		frm.action = ifm_url_str;
		frm.submit();
	}
</script>
<body style="background-color: transparent;">
<form name="frm" method="post">
	<input type="hidden" name="N_MON_ID" value="${param.N_MON_ID}">
	<input type="hidden" name="nowpage" value="<c:if test='${param.nowpage==null}'>1</c:if>${param.nowpage}">
	<input type="hidden" name="pagecnt" value="10">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9"><img src="${img2}/search_box_lt.png"></td>
                <td background="${img2}/search_box_tt.jpg"><img src="${img2}/dot.png"></td>
                <td width="9"><img src="${img2}/search_box_rt.png"></td>
              </tr>
              <tr>
                <td background="${img2}/search_box_lc.jpg">&nbsp;</td>
                <td bgcolor="eeeeee"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="10%" class="text11 b">명칭</td>
                      <td id="abc" width="25%">
                        <input type="text" name="S_NAME" size="12" value="${param.S_NAME}">
                      </td>
                      <td class="text11 b">IP주소</td>
                      <td>
                      	<input type="text" name="S_NAME" size="12" value="${param.S_NAME}">
                      </td>
                      <td width="2" rowspan="2" background="${img2}/search_line.jpg"><img src="${img2}/dot.png"></td>
                      <td width="15%" rowspan="2" align="center"><img src="${img2}/btn/btn_search.jpg" onclick="fn_retrieve()" style="cursor:hand;"></td>
                    </tr>
                    <tr>
                      <td width="12%" class="text11 b"></td>
                      <td colspan="2">
                      	
                      </td>
                    </tr>
                  </table></td>
                <td background="${img2}/search_box_rc.jpg">&nbsp;</td>
              </tr>
              <tr>
                <td><img src="${img2}/search_box_lb.png"></td>
                <td background="${img2}/search_box_bc.png"><img src="${img2}/dot.png"></td>
                <td><img src="${img2}/search_box_rb.png"></td>
              </tr>
            </table>
 </form>
 <table border="0" width="0" height="5" style="line-height:0;"><tr><td>&nbsp;</td></tr></table>
	<%@ include file="/WEB-INF/views/include/ListHeadClick.jsp"%>
				<table width="200%" border="0" cellspacing="0" cellpadding="0">
                    <tr align="center">
                      <td width="10%" height="25" background="${img2}/table_title.jpg" class="b text11 gray"><thead:thead col="N_INDEX" name="번호" reqcol="${param.order_id}" ascdescstring="${asc_desc_String}" sort="${param.asc_desc}"/></td>
                      <td width="5%" background="${img2}/table_title.jpg" class="b text11 gray"><thead:thead col="S_NAME" name="명칭" reqcol="${param.order_id}" ascdescstring="${asc_desc_String}" sort="${param.asc_desc}"/></td>
                      <td width="5%" background="${img2}/table_title.jpg" class="b text11 gray"><thead:thead col="S_TYPE" name="타입" reqcol="${param.order_id}" ascdescstring="${asc_desc_String}" sort="${param.asc_desc}"/></td>
                      <td width="5%" background="${img2}/table_title.jpg" class="b text11 gray"><thead:thead col="S_INET_ADDR" name="IP주소" reqcol="${param.order_id}" ascdescstring="${asc_desc_String}" sort="${param.asc_desc}"/></td>
                      <td width="5%" background="${img2}/table_title.jpg" class="b text11 gray"><thead:thead col="S_STATUS" name="등록상태" reqcol="${param.order_id}" ascdescstring="${asc_desc_String}" sort="${param.asc_desc}"/></td>
                      <td width="3%" background="${img2}/table_title.jpg" class="b text11 gray"><thead:thead col="S_STATUS_REASON" name="현재상태" reqcol="${param.order_id}" ascdescstring="${asc_desc_String}" sort="${param.asc_desc}"/></td>
                      <td width="15%" background="${img2}/table_title.jpg" class="b text11 gray"><thead:thead col="S_DESC" name="설명" reqcol="${param.order_id}" ascdescstring="${asc_desc_String}" sort="${param.asc_desc}"/></td>
                    </tr>
                    <c:forEach items="${data}" var="m">
	                    <tr>
	                      <td height="25" align="center" class="line_gray text11">&nbsp;${m.NUM}&nbsp;</td>
	                      <td height="25" align="center" class="line_gray text11">&nbsp;${m.S_NAME}&nbsp;</td>
	                      <td height="25" align="center" class="line_gray text11">&nbsp;${m.S_TYPE}&nbsp;</td>
	                      <td height="25" align="center" class="line_gray text11">&nbsp;${m.S_INET_ADDR}&nbsp;</td>
	                      <td height="25" align="center" class="line_gray text11">&nbsp;<c:if test="${m.N_STATUS=='2'}"><font color="blue"><b>${m.S_STATUS}</b></font></c:if><c:if test="${m.N_STATUS!='2'}"><font color="red"><b>${m.S_STATUS}</b></font></c:if>&nbsp;</td>
	                      <td height="25" align="center" class="line_gray text11">&nbsp;<c:if test="${m.N_STATUS_REASON=='0'}"><font color="blue"><b>${m.S_STATUS_REASON}</b></font></c:if><c:if test="${m.N_STATUS_REASON!='0'}"><font color="red"><b>${m.S_STATUS_REASON}</b></font></c:if>&nbsp;</td>
	                      <td height="25" class="line_gray text11">&nbsp;${m.S_DESC}&nbsp;</td>
	                    </tr>
                    </c:forEach>                    
                    <tr>
                      <td colspan="7" bgcolor="c2c3c5"><img src="${img2}/dot.png"></td>
                    </tr>
                </table>
                <%@ include file="/WEB-INF/views/include/paging/pageNavigate.jsp"%>