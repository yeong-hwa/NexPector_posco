<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<c:set var="img3"><c:url value='/common/dashboard/images'/></c:set>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<link href="<c:url value="/common/dashboard/css/interval.css"/>" type="text/css" rel="stylesheet"/>
<link href="<c:url value="/common/dashboard/css/default.css"/>" type="text/css" rel="stylesheet"/>
<link href="<c:url value="/common/dashboard/css/layout.css"/>" type="text/css" rel="stylesheet"/>
<link href="<c:url value="/common/dashboard/css/font.css"/>" type="text/css" rel="stylesheet"/>
<link href="<c:url value="/common/dashboard/css/jquery.mCustomScrollbar.css"/>" type="text/css" rel="stylesheet"/>

<link type="text/css" href="<c:url value="/common/dashboard/css/jquery-ui/jquery-ui.min.css" />" rel="stylesheet"/> <!-- 1.12.1 -->

<!-- Kendo UI CSS -->
<link type="text/css" href="<c:url value="/common/kendo-ui/styles/kendo.common.min.css" />" rel="stylesheet"/>
<link type="text/css" href="<c:url value="/common/kendo-ui/styles/kendo.default.min.css" />" rel="stylesheet"/>
<!-- Jquey JS-->
<script src="<c:url value='/common/js/common.js'/>"></script>
<script src="<c:url value='/common/js/jquery-3.2.1.min.js'/>"></script>
<script src="<c:url value='/common/js/jquery-migrate-3.0.0.min.js' />"></script>
<!-- <script src="<c:url value='/common/dashboard/js/jquery-1.6.min.js' />"></script> -->

<script src="<c:url value="/common/js/global_data.js"/>"></script>
<script src="<c:url value="/js/global-variables.js" />"></script>
<script src="<c:url value="/js/initialize.js" />"></script>

<script src="<c:url value='/js/jquery-extend.js' />"></script>
<script src="<c:url value='/common/dashboard/js/jquery.mCustomScrollbar.concat.min.js' />"></script>
<script src="<c:url value='/common/dashboard/js/jquery-ui.min.js' />"></script> <!-- 1.12.1 -->

<script src="<c:url value="/common/dashboard/js/dashboardInterval.js" />"></script>
<!-- Kendo UI JS -->
<script src="<c:url value="/common/kendo-ui/js/kendo.all.min.js" />"></script>
<script src="<c:url value="/common/kendo-ui/js/kendo.culture.ko-KR.min.js" />"></script>

<%
	String jimg3 = "/common/images/dashboard";
%>

<script type="text/javascript">
	var imgSrc = '${img3}';
	createConstants('${ctx}');
	
    kendo.culture("ko-KR");
	
	String.prototype.string = function(len){var s = '', i = 0; while (i++ < len) { s += this; } return s;};
	String.prototype.zf = function(len){return "0".string(len - this.length) + this;};
	Number.prototype.zf = function(len){return this.toString().zf(len);};
	
	Date.prototype.format = function(format) {
	    if (!this.valueOf()) return " ";
	 
	    var weekName = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
	    var d = this;
	     
	    return format.replace(/(yyyy|yy|MM|dd|E|e|hh|mm|ss|a\/p|A\/P)/gi, function($1) {
	        switch ($1) {
	            case "yyyy": return d.getFullYear();
	            case "yy": return (d.getFullYear() % 1000).zf(2);
	            case "MM": return (d.getMonth() + 1).zf(2);
	            case "dd": return d.getDate().zf(2);
	            case "E": return weekName[d.getDay()];
	            case "e": return weekName[d.getDay()].substring(0, 1);
	            case "HH": return d.getHours().zf(2);
	            case "hh": return ((h = d.getHours() % 12) ? h : 12).zf(2);
	            case "mm": return d.getMinutes().zf(2);
	            case "ss": return d.getSeconds().zf(2);
	            case "a/p": return d.getHours() < 12 ? "오전" : "오후";
	            case "A/P": return d.getHours() < 12 ? "AM" : "PM";
	            default: return $1;
	        }
	    });
	};
	
	function openErrorPopup(param) {
		var dialogWidth = 670;
		// var position = ($(window).width() / 2) - (dialogWidth / 2);
		console.log(param);
		
		$.get('${ctx}' + '/dashboard/go_dashboard_error_popup.htm', param)
		.done(function(html) {
			error_popup = $('#dashboard_error_popup')
			.html(html)
			.dialog({
				resizable		: false,
				width			: dialogWidth,
				// height			: 620,
				modal			: true,
 				
				position		: {
	                 my: 'center',
	                 at: 'center top+250',
	                 of: window,
	                 collision: 'fit'
				}, 
				/*
				position : [($(window).width() / 2) - (dialogWidth / 2), 150],
				open: function() {
					$(this).parent().css({top:50, left:($(window).width() / 2) - (dialogWidth / 2)});
				},*/
				autoReposition	: true,
				open: function(event, ui) { 
				     $(this).parent().children('.ui-dialog-titlebar').hide();
				}
			});
		});
	}
	
	function closePopup() {
		error_popup.dialog( "close" );
	}
</script>
  <!-- 모달팝업 small-->
  <div id="myModal_small" class="popup_wrap_small small" style="display: none">
    <!-- Top -->
    <div class="top">
      <a href="javascript:closeIntervalPopup()" class="close close-reveal-modal" href="#"><img src="${img3}/btn_close.png" alt="닫기"></a>
    </div>
    <!-- //Top -->
    <!-- Content -->
    <div class="content">
      <!-- table -->
      <div class="pop_tbl_wrap_1">
        <table class="errorDetail" cellspacing="0" cellpadding="0" summary="">
          <!-- <caption>Interval 수정</caption> -->
          <colgroup>
            <col width="156px" />
            <col width="" />
          </colgroup>
          <thead>
            <tr class="pop_sm">
              <th colspan="2">Interval 수정</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <th class="pdl10" scope="row">새로고침</th>
              <td class="pdl5"><input id="reload_interval" type="number" min="0" max="6000"></td>
            </tr>
            <!-- <tr>
              <th class="pdl10" scope="row">Page 전환</th>
              <td class="pdl5"><input type="text" name="text" placeholder="30" disabled></td>
            </tr> -->
          </tbody>
        </table>
      </div>
      <!-- //table -->
    </div>
    <!-- //Content -->
    <!-- bottom  -->
    <div class="btn_wrap">
      <a id="btn_user_info_modify" class="btn_default" href="#">변경</a>
    </div>
    <!-- //bottom  -->
  </div>
  <!-- //모달팝업 small-->   