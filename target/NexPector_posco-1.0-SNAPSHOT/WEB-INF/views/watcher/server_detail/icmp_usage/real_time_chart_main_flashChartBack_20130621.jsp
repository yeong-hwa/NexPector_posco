<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/include.jsp" %>

<script language="javascript">AC_FL_RunContent = 0;</script>
<script language="javascript"> DetectFlashVer = 0; </script>
<script src="${contextPath}/include/js/AC_RunActiveContent.js" language="javascript"></script>
<script language="JavaScript" type="text/javascript">
</script>

<body style="background-color: transparent;">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                          <tr>
		                            <td height="40" class="b"><img src="${img}/icon_result.jpg" align="absmiddle">IP : ${param.S_ICMP_IP}</td>		                            
		                          </tr>
		                          <tr>
		                            <td height="170" class="line_gray">
		                            	<chart:chart height="155" bgcolor="#FFFFFF" width="230" xmlpath="/watcher/server_detail.realtime_icmp.neonex?N_MON_ID=${param.N_MON_ID}%26S_ICMP_IP=${param.S_ICMP_IP}"/>		                            	
		                            </td>
		                          </tr>
		                          <tr>
		                            <td height="1" bgcolor="eeeeee"><img src="${img}/dot.png"></td>
		                          </tr>
		                        </table>

</body>