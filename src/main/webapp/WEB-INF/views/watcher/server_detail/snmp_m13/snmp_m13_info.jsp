<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/include.jsp" %>

<jsp:useBean id="data" class="java.util.HashMap" scope="request"/>
<body style="background-color: transparent;">
  <!-- 기본 정보 시작 -->
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	  <td height="45" colspan="2" class="b gray_sub"><img src="${img2}/icon_result.jpg" align="absmiddle">기본 정보</td>
	</tr>
	<tr>
	  <td colspan="2" bgcolor="#a8b4c4"><img src="${img2}/dot.png"></td>
	</tr>
	<tr>
	  <td width="15%" height="28" bgcolor="fdf6ec" class="b text11 gray pl13 tbin tbinrg"><img src="${img2}/icon_arrowye.jpg" align="absmiddle">도메인 이름</td>
	  <td width="85%" class="text11 gray pl13 tbin">&nbsp;${data.S_NAME}</td>
	</tr>
	<tr>
	  <td width="15%" height="28" bgcolor="fdf6ec" class="b text11 gray pl13 tbin tbinrg"><img src="${img2}/icon_arrowye.jpg" align="absmiddle">설명</td>
	  <td width="85%" class="text11 gray pl13 tbin">&nbsp;${data.S_DESCRIPTION}</td>
	</tr>
	<tr>
	  <td width="15%" height="28" bgcolor="fdf6ec" class="b text11 gray pl13 tbin tbinrg"><img src="${img2}/icon_arrowye.jpg" align="absmiddle">버전</td>
	  <td width="85%" class="text11 gray pl13 tbin">&nbsp;${data.S_VERSION}</td>
	</tr>
	<tr>
	  <td height="30" colspan="2"></td>
	</tr>
  </table>
  <!-- 장비정보 끝 -->
</body>