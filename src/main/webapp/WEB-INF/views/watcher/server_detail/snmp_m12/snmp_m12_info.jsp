<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/include.jsp" %>

<jsp:useBean id="data" class="java.util.HashMap" scope="request"/>

				<table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td height="45" colspan="6" class="b gray_sub"><img src="${img2}/icon_result.jpg" align="absmiddle">장비 정보</td>
                    </tr>
                    <tr>
                      <td colspan="4" bgcolor="#a8b4c4"><img src="${img2}/dot.png"></td>
                    </tr>
                    <tr>
                      <td width="15%" height="28" bgcolor="fdf6ec" class="b text11 gray pl13 tbin tbinrg"><img src="${img2}/icon_arrowye.jpg" align="absmiddle">장비명</td>
                      <td width="35%" colspan="3" class="text11 gray pl13 tbin">&nbsp;${data.S_SYS_NAME}</td>
                    </tr>
                    <tr>
                      <td width="15%" height="28" bgcolor="fdf6ec" class="b text11 gray pl13 tbin tbinrg"><img src="${img2}/icon_arrowye.jpg" align="absmiddle">모델명</td>
                      <td width="85%" colspan="3" class="text11 gray pl13 tbin">&nbsp;${data.S_SYS_DESCR}</td>
                    </tr>
                    <tr>
                      <td width="15%" height="28" bgcolor="fdf6ec" class="b text11 gray pl13 tbin tbinrg"><img src="${img2}/icon_arrowye.jpg" align="absmiddle">시스템 가동시간</td>
                      <td width="35%" colspan="3" class="text11 gray pl13 tbin">&nbsp;${data.S_SYS_UPTIME}</td>
                    </tr>
                    <tr>
                      <td width="15%" height="28" bgcolor="fdf6ec" class="b text11 gray pl13 tbin tbinrg"><img src="${img2}/icon_arrowye.jpg" align="absmiddle">인터페이스 수</td>
                      <td width="85%" colspan="3" class="text11 gray pl13 tbin">&nbsp;${data.N_IF_NUMBER}</td>
                    </tr>
                    <tr>
                      <td height="1" colspan="6"></td>
                    </tr>
                  </table>
                  <!-- 장비정보 끝 -->
                  <!-- 서비스정보 시작 -->
                  <!-- <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td height="45" colspan="5" class="b gray_sub"><img src="${img2}/icon_result.jpg" align="absmiddle">서비스 정보</td>
                    </tr>
                    <tr align="center">
                      <td width="40%" height="34" background="${img2}/table_title.jpg" class="b text11 gray">서비스명</td>
                      <td width="15%" background="${img2}/table_title.jpg" class="b text11 gray">운용 정보(개수)</td>
                      <td width="15%" background="${img2}/table_title.jpg" class="b text11 gray">운영상태-연결(개수)</td>
                      <td width="15%" background="${img2}/table_title.jpg" class="b text11 gray">운영상태-기타(개수)</td>
                    </tr>
                    <tr>
                      <td height="21" class="line_gray text11 pl13">Network Interface</td>
                      <td height="21" align="center" class="line_gray text11">&nbsp;${data.N_IF_CNT}</td>
                      <td height="21" align="center" class="line_gray text11">&nbsp;${data.N_OPER_CNT1}</td>
                      <td height="21" align="center" class="line_gray text11">&nbsp;${data.N_OPER_CNT2}</td>
                    </tr>
                    <tr>
                      <td colspan="5" bgcolor="c2c3c5"><img src="${img2}/dot.png"></td>
                    </tr>
                  </table> -->
