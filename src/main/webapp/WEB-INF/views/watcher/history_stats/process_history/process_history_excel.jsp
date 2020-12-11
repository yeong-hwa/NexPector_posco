<%@ page language="java" contentType="application/vnd.ms-excel;charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:useBean id="data" class="java.util.ArrayList" scope="request"/>

<%
	String file_name = "Process_History_Report";
	String ExcelName  = new String(file_name.getBytes(),"UTF-8")+".xls";
	response.setContentType("application/vnd.ms-excel;charset=utf-8");
	response.setHeader("Content-Transfer-Encoding", "binary;");
	response.setHeader("Content-Disposition", "attachment; filename="+ExcelName);
	response.setHeader("Pragma", "no-cache");
%>
<meta http-equiv="Content-Type" content="application/vnd.ms-excel;charset=utf-8">
<style>
	.text11 {font-size:11px }
	.gray {color:#6e7275 }
	.b { font-weight:bold }
	.line_gray { border-bottom:1px solid #eeeeee; }
	.pl13 {padding-left:13px }
</style>
<table width="1000" border=1>
	<tr align="center">
		<td colspan="25"><h1>프로세스 이력 조회</h1></td>
	</tr>
</table>

<table border="1">
	<tr>
		<td colspan="25"><h3>검색기간  :  ${param.S_ST_DT }  ~  ${param.S_ED_DT}</h3></td>
	</tr>
	<tr>
		<td colspan="25"><h3>표시방법  :  ${param.REPORT_GUBUN}</h3></td>		
	</tr>
	<tr>
		<td colspan="25"><h3>서버그룹 / 장비타입  : ${param.SERVER_GROUP}  /  ${param.SERVER_TYPE_NAME}</h3></td>
	</tr>
	<tr>
		<td colspan="25"><h3>자원종류  :  ${param.RESOURCE_NAME}</h3></td>
	</tr>
</table>
<br><br>
                  <table width="900" border="1" cellspacing="0" cellpadding="0">
                    <tr align="center" style="background: #6e7275">
                      <td width="12.5%" height="34"><b>항목＼시각</b></td>
                      <td width="3.5%"><b>0</b></td>
                      <td width="3.5%"><b>1</b></td>
                      <td width="3.5%"><b>2</b></td>
                      <td width="3.5%"><b>3</b></td>
                      <td width="3.5%"><b>4</b></td>
                      <td width="3.5%"><b>5</b></td>
                      <td width="3.5%"><b>6</b></td>
                      <td width="3.5%"><b>7</b></td>
                      <td width="3.5%"><b>8</b></td>
                      <td width="3.5%"><b>9</b></td>
                      <td width="3.5%"><b>10</b></td>
                      <td width="3.5%"><b>11</b></td>
                      <td width="3.5%"><b>12</b></td>
                      <td width="3.5%"><b>13</b></td>
                      <td width="3.5%"><b>14</b></td>
                      <td width="3.5%"><b>15</b></td>
                      <td width="3.5%"><b>16</b></td>
                      <td width="3.5%"><b>17</b></td>
                      <td width="3.5%"><b>18</b></td>
                      <td width="3.5%"><b>19</b></td>
                      <td width="3.5%"><b>20</b></td>
                      <td width="3.5%"><b>21</b></td>
                      <td width="3.5%"><b>22</b></td>
                      <td width="3.5%"><b>23</b></td>
                    </tr>
                <c:forEach items="${data}" var="m">
                	<tr  align="center">
                      <td height="31" align="left">${m.S_BASE_NAME}</td>
                      <td height="31">${m.TIME_00}</td>
                      <td height="31">${m.TIME_01}</td>
                      <td height="31">${m.TIME_02}</td>
                      <td height="31">${m.TIME_03}</td>
                      <td height="31">${m.TIME_04}</td>
                      <td height="31">${m.TIME_05}</td>
                      <td height="31">${m.TIME_06}</td>
                      <td height="31">${m.TIME_07}</td>
                      <td height="31">${m.TIME_08}</td>
                      <td height="31">${m.TIME_09}</td>
                      <td height="31">${m.TIME_10}</td>
                      <td height="31">${m.TIME_11}</td>
                      <td height="31">${m.TIME_12}</td>
                      <td height="31">${m.TIME_13}</td>
                      <td height="31">${m.TIME_14}</td>
                      <td height="31">${m.TIME_15}</td>
                      <td height="31">${m.TIME_16}</td>
                      <td height="31">${m.TIME_17}</td>
                      <td height="31">${m.TIME_18}</td>
                      <td height="31">${m.TIME_19}</td>
                      <td height="31">${m.TIME_20}</td>
                      <td height="31">${m.TIME_21}</td>
                      <td height="31">${m.TIME_22}</td>
                      <td height="31">${m.TIME_23}</td>
                    </tr>
                </c:forEach>
                  </table>