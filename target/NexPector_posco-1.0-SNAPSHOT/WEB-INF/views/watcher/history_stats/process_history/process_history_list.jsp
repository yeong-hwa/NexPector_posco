<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<td class="bgml1"></td>
<td class="bgmc1">
    <!-- stitle -->
    <div class="avaya_stitle1">
        <div class="st_under"><h4>프로세스 이력 조회</h4></div>
    </div>
    <!-- stitle // -->
    <!-- table_typ2-4 -->
    <div class="table_typ2-4">
        <table summary="" cellpadding="0" cellspacing="0" style="width:100%;">
            <caption></caption>
            <colgroup>
                <col width="28%"/>
                <col width="3%"/><col width="3%"/><col width="3%"/><col width="3%"/><col width="3%"/><col width="3%"/>
                <col width="3%"/><col width="3%"/><col width="3%"/><col width="3%"/><col width="3%"/><col width="3%"/>
                <col width="3%"/><col width="3%"/><col width="3%"/><col width="3%"/><col width="3%"/><col width="3%"/>
                <col width="3%"/><col width="3%"/><col width="3%"/><col width="3%"/><col width="3%"/><col width="3%"/>
            </colgroup>
            <thead>
            <tr>
                <td class="filed_A">항목/시각</td>
                <td class="filed_A">0</td><td class="filed_A">1</td><td class="filed_A">2</td><td class="filed_A">3</td><td class="filed_A">4</td>
                <td class="filed_A">5</td><td class="filed_A">6</td><td class="filed_A">7</td><td class="filed_A">8</td><td class="filed_A">9</td>
                <td class="filed_A">10</td><td class="filed_A">11</td><td class="filed_A">12</td><td class="filed_A">13</td><td class="filed_A">14</td>
                <td class="filed_A">15</td><td class="filed_A">16</td><td class="filed_A">17</td><td class="filed_A">18</td><td class="filed_A">19</td>
                <td class="filed_A">20</td><td class="filed_A">21</td><td class="filed_A">22</td><td class="filed_A">23</td>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${empty list}">
                    <tr><td colspan="25">No Data</td></tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="data" items="${list}">
                        <tr>
                            <td class="filed_B">${data.S_BASE_NAME}</td>
                            <td class="filed_B">${data.TIME_00 eq null || data.TIME_00 eq '' ? 0 : data.TIME_00}</td>
                            <td class="filed_B">${data.TIME_01 eq null || data.TIME_01 eq '' ? 0 : data.TIME_01}</td>
                            <td class="filed_B">${data.TIME_02 eq null || data.TIME_02 eq '' ? 0 : data.TIME_02}</td>
                            <td class="filed_B">${data.TIME_03 eq null || data.TIME_03 eq '' ? 0 : data.TIME_03}</td>
                            <td class="filed_B">${data.TIME_04 eq null || data.TIME_04 eq '' ? 0 : data.TIME_04}</td>
                            <td class="filed_B">${data.TIME_05 eq null || data.TIME_05 eq '' ? 0 : data.TIME_05}</td>
                            <td class="filed_B">${data.TIME_06 eq null || data.TIME_06 eq '' ? 0 : data.TIME_06}</td>
                            <td class="filed_B">${data.TIME_07 eq null || data.TIME_07 eq '' ? 0 : data.TIME_07}</td>
                            <td class="filed_B">${data.TIME_08 eq null || data.TIME_08 eq '' ? 0 : data.TIME_08}</td>
                            <td class="filed_B">${data.TIME_09 eq null || data.TIME_09 eq '' ? 0 : data.TIME_09}</td>
                            <td class="filed_B">${data.TIME_10 eq null || data.TIME_10 eq '' ? 0 : data.TIME_10}</td>
                            <td class="filed_B">${data.TIME_11 eq null || data.TIME_11 eq '' ? 0 : data.TIME_11}</td>
                            <td class="filed_B">${data.TIME_12 eq null || data.TIME_12 eq '' ? 0 : data.TIME_12}</td>
                            <td class="filed_B">${data.TIME_13 eq null || data.TIME_13 eq '' ? 0 : data.TIME_13}</td>
                            <td class="filed_B">${data.TIME_14 eq null || data.TIME_14 eq '' ? 0 : data.TIME_14}</td>
                            <td class="filed_B">${data.TIME_15 eq null || data.TIME_15 eq '' ? 0 : data.TIME_15}</td>
                            <td class="filed_B">${data.TIME_16 eq null || data.TIME_16 eq '' ? 0 : data.TIME_16}</td>
                            <td class="filed_B">${data.TIME_17 eq null || data.TIME_17 eq '' ? 0 : data.TIME_17}</td>
                            <td class="filed_B">${data.TIME_18 eq null || data.TIME_18 eq '' ? 0 : data.TIME_18}</td>
                            <td class="filed_B">${data.TIME_19 eq null || data.TIME_19 eq '' ? 0 : data.TIME_19}</td>
                            <td class="filed_B">${data.TIME_20 eq null || data.TIME_20 eq '' ? 0 : data.TIME_20}</td>
                            <td class="filed_B">${data.TIME_21 eq null || data.TIME_21 eq '' ? 0 : data.TIME_21}</td>
                            <td class="filed_B">${data.TIME_22 eq null || data.TIME_22 eq '' ? 0 : data.TIME_22}</td>
                            <td class="filed_B">${data.TIME_23 eq null || data.TIME_23 eq '' ? 0 : data.TIME_23}</td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>
    <!-- table_typ2-4 // -->
    <!--paginate-->
    <div class="tap_pageing4"><ui:pagination paginationInfo = "${paginationInfo}" type="image" jsFunction="fn_list"/></div>
    <!--//paginate-->
</td>
<td class="bgmr1"></td>