<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript" src="<c:url value="/js/jquery.blockUI.js"/>"></script>
<script type="text/javascript">
    $(document).ready(function() {
        initialize();

        $('.history_leftNv a').on('click', function(event) {
            event.preventDefault();
            var url;
            if (this.id === 'menu_resource_history') {
                url = cst.contextPath() + '/watcher/go_history_stats.resource_history.resource_history.htm';
            } else if (this.id === 'menu_process_history') {
                url = cst.contextPath() + '/watcher/go_history_stats.process_history.process_history.htm';
            } else if (this.id === 'menu_error_history') {
                url = cst.contextPath() + '/watcher/go_history_stats.error_history.error_history.htm';
            } else if (this.id === 'menu_alarm_send_history') {
                url = cst.contextPath() + '/watcher/go_history_stats.alarm_send_history.alarm_send_history.htm';
            } else if (this.id === 'service_call_statistics') {
                url = cst.contextPath() + '/watcher/go_history_stats.cdr_history.cdr_history.htm';
            } else if (this.id === 'phone_call_statistics') {
                url = cst.contextPath() + '/watcher/go_history_stats.cdr_stats.cdr_stats.htm';
            } else if (this.id === 'phone_use_state') {
                url = cst.contextPath() + '/watcher/go_history_stats.phone_use_state.phone_use_state.htm';
            } else if (this.id === 'day_report') {
                url = cst.contextPath() + '/watcher/go_history_stats.day_report.day_report.htm';
            } else {
                return;
            }

            $('.history_leftNv a').each(function() {
                $(this).removeClass('selected');
            });

            $(this).addClass('selected');

            global.clearTimeout(); // setTimeout, setInterval clear

            fn_subMenu(url);
        });
    });

    function initialize() {
        fn_subMenu(cst.contextPath() + '/watcher/go_history_stats.resource_history.resource_history.htm');
    }

    function fn_subMenu(url) {
        $.blockUI(blockUIOption);
        $.get(url).done(function(html) {
            $('#contents').html(html);
        }).always(function() {
            $.unblockUI();
        });
    }
</script>

<!-- left nv -->
<div class="leftNv_Area3">
    <!-- historyNv-->
    <ul class="history_leftNv">
        <li><a id="menu_resource_history" href="#" class="selected">리소스 이력</a></li>
        <li><a id="menu_process_history" href="#">프로세스/서비스 이력</a></li>
        <li><a id="menu_error_history" href="#">장애 이력</a></li>
        <li><a id="menu_alarm_send_history" href="#">외부 알람 발송 내역</a></li>
        <li><a id="service_call_statistics" href="#">부서별 콜 통계</a></li>
        <li><a id="phone_call_statistics" href="#">전화번호별 콜 통계</a></li>
        <li><a id="phone_use_state" href="#">전화기 사용현황</a></li>
        <li><a id="day_report" href="#">일일보고서</a></li>
    </ul>
    <!-- historyNv-- //-->
    <!--paginate_s-->
    <%--<div style="float:left; width:100%;">
        <div class="paginate_s"></div>
    </div>--%>
    <!--//paginate_s-->
</div>
<!-- left nv // -->
<!-- contents box -->
<div class="contentsbox_Area">
    <div id="contents" class="c_start">
    </div>
</div>
<!-- contents box // -->