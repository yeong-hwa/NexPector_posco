<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>

  <!-- 스타일 시트  -->
  <link type="text/css" href="/common/dashdaekyo/css/font.css" type="text/css" rel="stylesheet" />
  <link type="text/css" href="/common/dashdaekyo/css/default.css" type="text/css" rel="stylesheet" />
  <link type="text/css" href="/common/dashdaekyo/css/layout_new.css" type="text/css" rel="stylesheet" />

<link type="text/css" href="/common/dashboard/css/jquery-ui/jquery-ui.min.css" rel="stylesheet"/> <!-- 1.12.1 -->

<!-- Kendo UI CSS -->
<link type="text/css" href="<c:url value="/common/kendo-ui/styles/kendo.common.min.css" />" rel="stylesheet"/>
<link type="text/css" href="<c:url value="/common/kendo-ui/styles/kendo.default.min.css" />" rel="stylesheet"/>
<link type="text/css" href="<c:url value="/common/kendo-ui/styles/kendo.bootstrap.min.css" />" rel="stylesheet"/>
<link type="text/css" href="<c:url value="/common/kendo-ui/styles/kendo.dataviz.bootstrap.min.css" />" rel="stylesheet"/>

  <!-- 스크립트 -->
  <script type="text/javascript" src="/js/jquery-1.11.2.min.js"></script>
  <script type="text/javascript" src="/common/dashdaekyo/js/webwidget_scroller_tab.js"></script>
  <script type="text/javascript" src="/js/jquery.blockUI.js"></script>

<!-- Jquey JS-->
<script type="text/javascript" src="/js/jquery-ui-1.11.4.custom/jquery-ui.min.js"></script>
<script src="/common/dashboard/js/jquery.mCustomScrollbar.concat.min.js"></script>


  <!-- Kendo UI JS -->
  <script type="text/javascript" src="/common/kendo-ui/js/kendo.all.min.js"></script>

<!--   <script type="text/javascript" src="/common/js/common.js"></script>
  <script type="text/javascript" src="/js/common.js"></script>
  <script type="text/javascript" src="/js/function.js"></script>
  <script type="text/javascript" src="/js/global-variables.js"></script>
  <script type="text/javascript" src="/js/jquery-extend.js"></script>
 -->
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="/common/js/common.js"></script>
<script type="text/javascript" src="/js/function.js"></script>
<script type="text/javascript" src="/js/global-variables.js"></script>
<script type="text/javascript" src="/js/jquery-migrate-1.1.1.min.js"></script>
<script type="text/javascript" src="/common/js/jquery.maskedinput.min.js"></script>
<script type="text/javascript" src="/js/jquery-extend.js"></script>

