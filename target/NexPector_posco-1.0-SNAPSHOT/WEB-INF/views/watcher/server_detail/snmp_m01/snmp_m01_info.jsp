<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/include.jsp" %>

<jsp:useBean id="data" class="java.util.HashMap" scope="request"/>
<body style="background-color: transparent;">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td height="45" colspan="6"class="b gray_sub"><img src="${img2}/icon_result.jpg" align="absmiddle">장비 정보</td>
                    </tr>
                    <tr>
                      <td colspan="4" bgcolor="#a8b4c4"><img src="${img2}/dot.png"></td>
                    </tr>
                    <tr>
                      <td width="15%" height="28" bgcolor="fdf6ec" class="b text11 gray pl13 tbin tbinrg"><img src="${img2}/icon_arrowye.jpg" align="absmiddle">모델명</td>
                      <td width="35%" class="text11 gray pl13 tbin">&nbsp;${data.S_MODEL}</td>
                   	  <td width="15%" height="28" bgcolor="fdf6ec" class="b text11 gray pl13 tbin tbinrg"><img src="${img2}/icon_arrowye.jpg" align="absmiddle">장비명</td>
                      <td width="35%" class="text11 gray pl13 tbin">&nbsp;${data.S_NAME}</td>
                    </tr>
                    <tr>
                      <td height="30" colspan="6"></td>
                    </tr>
                  </table>
                  <!-- 장비정보 끝 -->
                  <!-- 서비스정보 시작 -->
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td height="45" colspan="5"class="b gray_sub"><img src="${img2}/icon_result.jpg" align="absmiddle">서비스 정보</td>
                    </tr>
                    <tr align="center">
                      <td width="15%" height="34" background="${img2}/table_title.jpg" class="b text11 gray">타입</td>
                      <td width="15%" background="${img2}/table_title.jpg" class="b text11 gray">등록 수량</td>
                    </tr>
                    <tr>
                      <td height="31" class="line_gray text11 pl13">전화기</td>
                      <td height="31" align="center" class="line_gray text11">&nbsp;${data.N_PHONE_REG}</td>
                    </tr>
                    <tr>
                      <td height="31" class="line_gray text11 pl13">IPSI</td>
                      <td height="31" align="center" class="line_gray text11">&nbsp;${data.N_IPSI_REG}</td>
                    </tr>
                    <tr>
                      <td height="31" class="line_gray text11 pl13">Board</td>
                      <td height="31" align="center" class="line_gray text11">&nbsp;${data.N_BOARD_REG}</td>
                    </tr>
                    <tr>
                      <td colspan="5" bgcolor="c2c3c5"><img src="${img2}/dot.png"></td>
                    </tr>
                  </table>
</body>