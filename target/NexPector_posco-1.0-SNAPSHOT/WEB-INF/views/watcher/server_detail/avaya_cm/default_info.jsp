<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- stitle -->
<div class="avaya_stitle1">
  <div class="st_under"><h4>기본 정보</h4></div>
</div>
<!-- stitle // -->
<!-- table_typ2-1 -->
<div class="table_typ2-1">
  <table summary="" cellpadding="0" cellspacing="0">
    <caption></caption>
    <colgroup>
      <col width="15%" />
      <col width="35%" />
      <col width="15%" />
      <col width="35%" />
    </colgroup>
    <tr>
      <td class="filed_A">모델명</td>
      <td class="filed_B">${data.S_MODEL}</td>
      <td class="filed_A">장비명</td>
      <td class="filed_B">${data.S_NAME}</td>
    </tr>
    <tr>
      <td class="filed_A">그룹명</td>
      <td class="filed_B">${data.S_GROUP_NAME}</td>
      <td class="filed_A">CM타입</td>
      <td class="filed_B">${data.S_CM_TYPE}</td>
    </tr>
  </table>
</div>