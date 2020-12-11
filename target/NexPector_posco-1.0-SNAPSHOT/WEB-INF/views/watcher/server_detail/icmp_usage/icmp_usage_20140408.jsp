<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/include.jsp" %>

<jsp:useBean id="lst" class="java.util.ArrayList" scope="request"/>

<script language="javascript">AC_FL_RunContent = 0;</script>
<script language="javascript"> DetectFlashVer = 0; </script>
<script src="${contextPath}/include/js/AC_RunActiveContent.js" language="javascript"></script>
<script language="JavaScript" type="text/javascript">

</script>
<body style="background-color: transparent;">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td background="${img2}/tab_lc.jpg">&nbsp;</td>
                <td width="100%" class="pt15">
                	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	                    <tr>	                      
	                      <td>&nbsp;&nbsp;
	                      	<c:forEach items="${lst}" var="m" varStatus="vt">
                            	<iframe name="ifm_realtime_chart_${m.S_ICMP_IP}" src="${contextPath}/prgm/server_detail/icmp_usage/real_time_chart_main.jsp?N_MON_ID=${param.N_MON_ID}&S_ICMP_IP=${m.S_ICMP_IP}" width="235" height="211" frameborder="0" scrolling="no" allowtransparency="true"></iframe>
                            	&nbsp;&nbsp;
	                      	</c:forEach>
	                      </td>
	                    </tr>
                  </table>
                  </td>
                <td background="${img2}/tab_rc.jpg">&nbsp;</td>
              </tr>
              <tr>
                <td><img src="${img2}/tab_lb.jpg"></td>
                <td height="4" background="${img2}/tab_ceb.jpg"><img src="${img2}/dot.png"></td>
                <td><img src="${img2}/tab_rb.jpg"></td>
              </tr>
            </table>
</body>