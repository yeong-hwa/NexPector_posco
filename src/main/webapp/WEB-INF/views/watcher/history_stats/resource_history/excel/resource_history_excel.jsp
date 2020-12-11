<%@ page language="java" contentType="application/vnd.ms-excel;charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:useBean id="data" class="java.util.ArrayList" scope="request"/>

<%
    String file_name = "Resoruce_History_Report";
    String ExcelName = new String(file_name.getBytes(), "UTF-8") + ".xls";
    response.setContentType("application/vnd.ms-excel;charset=utf-8");
    response.setHeader("Content-Transfer-Encoding", "binary;");
    response.setHeader("Content-Disposition", "attachment; filename=" + ExcelName);
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
<table width="1000" border="1">
    <tr align="center">
        <td colspan="28"><h1>리소스 이력 조회</h1></td>
    </tr>
</table>

<table border="1">
    <tr>
        <td colspan="28"><h3>검색기간 : ${param.S_ST_DT } ~ ${param.S_ED_DT}</h3></td>
    </tr>
    <tr>
        <td colspan="28"><h3>표시방법 : ${param.REPORT_GUBUN}</h3></td>
    </tr>
    <tr>
        <td colspan="28"><h3>서버그룹 / 서버타입 : ${param.SERVER_GROUP} / ${param.SERVER_TYPE_NAME}</h3></td>
    </tr>
    <tr>
        <td colspan="28"><h3>자원종류 : ${param.RESOURCE_NAME}</h3></td>
    </tr>
    <tr>
        <td colspan="28"><h3>검색조건: ${param.SEARCH_TYPE_NAME} / ${param.SEARCH_KEYWORD}</h3></td>
    </tr>
    
</table>
<br><br>
<table width="900" border="1" cellspacing="0" cellpadding="0">
    <tr align="center" style="background: #6e7275">
        <td width="5%" height="34"><b>날짜</b></td>
        <td width="12.5%" height="34"><b>장비명</b></td>
        <td width="20.5%"><b>비고</b></td>
        <td width="5.5%"><b>자원</b></td>
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
    <tr align="center">
        <td height="54">&nbsp;${m.N_DAY}&nbsp;</td>
        <td>${m.S_BASE_NAME}</td>
        <td>${m.S_MON_NAME}</td>
        <td>${m.S_TYPE_NAME}</td>
        <td>${m.TIME_00}</td>
        <td>${m.TIME_01}</td>
        <td>${m.TIME_02}</td>
        <td>${m.TIME_03}</td>
        <td>${m.TIME_04}</td>
        <td>${m.TIME_05}</td>
        <td>${m.TIME_06}</td>
        <td>${m.TIME_07}</td>
        <td>${m.TIME_08}</td>
        <td>${m.TIME_09}</td>
        <td>${m.TIME_10}</td>
        <td>${m.TIME_11}</td>
        <td>${m.TIME_12}</td>
        <td>${m.TIME_13}</td>
        <td>${m.TIME_14}</td>
        <td>${m.TIME_15}</td>
        <td>${m.TIME_16}</td>
        <td>${m.TIME_17}</td>
        <td>${m.TIME_18}</td>
        <td>${m.TIME_19}</td>
        <td>${m.TIME_20}</td>
        <td>${m.TIME_21}</td>
        <td>${m.TIME_22}</td>
        <td>${m.TIME_23}</td>
    </tr>
    </c:forEach>
</table>