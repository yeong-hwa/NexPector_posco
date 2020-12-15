<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript">
    $(document).ready(function() {

        $('.history_leftNv a').on('click', function(event) {
            event.preventDefault();
            var url;
            if (this.id === 'menu_resource_history') {
                url = cst.contextPath() + '/watcher/go_history_stats.resource_history.resource_history.htm?menu=mnavi01_03&subMenu=3100';
            } else if (this.id === 'menu_process_history') {
                url = cst.contextPath() + '/watcher/go_history_stats.process_history.process_history.htm?menu=mnavi01_03&subMenu=3200';
            } else if (this.id === 'menu_error_history') {
                url = cst.contextPath() + '/watcher/go_history_stats.error_history.error_history.htm?menu=mnavi01_03&subMenu=3300';
            } else if (this.id === 'menu_alarm_send_history') {
                url = cst.contextPath() + '/watcher/go_history_stats.alarm_send_history.alarm_send_history.htm?menu=mnavi01_03&subMenu=3400';
            } else if (this.id === 'service_call_statistics') {
                url = cst.contextPath() + '/watcher/go_history_stats.cdr_history.cdr_history.htm?menu=mnavi01_03&subMenu=3500';
            } else if (this.id === 'phone_call_statistics') {
                url = cst.contextPath() + '/watcher/go_history_stats.cdr_stats.cdr_stats.htm?menu=mnavi01_03&subMenu=3600';
            /*} else if (this.id === 'phone_use_state') {
                url = cst.contextPath() + '/watcher/go_history_stats.phone_use_state.phone_use_state.htm?menu=mnavi01_03&subMenu=3700';*/
            } else if (this.id === 'day_report') {
                url = cst.contextPath() + '/watcher/go_history_stats.day_report.day_report.htm?menu=mnavi01_03&subMenu=3800';
            } else if (this.id === 'phone_etc_statistics') {
                url = cst.contextPath() + '/watcher/go_history_stats.phone_etc_statistics.phone_etc_statistics.htm?menu=mnavi01_03&subMenu=3900';
            } else if (this.id === 'dept_increase_history') {
                url = cst.contextPath() + '/watcher/go_history_stats.dept_increase_history.dept_increase_history.htm?menu=mnavi01_03&subMenu=4000';
            /*} else if (this.id === 'login_status') {
                url = cst.contextPath() + '/watcher/go_history_stats.login_status.htm?menu=mnavi01_03&subMenu=4100';
            } else if (this.id === 'login_set_history') {
                url = cst.contextPath() + '/watcher/go_history_stats.login_set_history.htm?menu=mnavi01_03&subMenu=4200';*/
            } else if (this.id === 'ipt_history') {
                url = cst.contextPath() + '/watcher/go_history_stats.ipt_history.ipt_history.htm?menu=mnavi01_03&subMenu=4300';
            } else if (this.id === 'phone_dept_use_state') {
                url = cst.contextPath() + '/watcher/go_history_stats.phone_use_state.phone_use_state.htm?menu=mnavi01_03&subMenu=4400';
            } else if (this.id === 'in_call_use_state') {
                url = cst.contextPath() + '/watcher/go_history_stats.phone_use_state.in_call_use_state.htm?menu=mnavi01_03&subMenu=4500';
            } else if (this.id === 'jum_e1_chanel_state') {
                url = cst.contextPath() + '/watcher/go_history_stats.jum_e1_chanel_stats.jum_e1_chanel_stats.htm?menu=mnavi01_03&subMenu=4600';
            } else if (this.id === 'menu_call_history') {
            	url = cst.contextPath() + '/watcher/go_history_stats.call_history.call_history.htm?menu=mnavi01_03&subMenu=4700';
            } else if (this.id === 'rec_variation_history') {
            	url = cst.contextPath() + '/watcher/go_history_stats.rec_variation_history.rec_variation_history.htm?menu=mnavi01_03&subMenu=4800';
            } else if (this.id === 'menu_phone_error_history') {
                url = cst.contextPath() + '/watcher/go_history_stats.phone_error_history.phone_error_history.htm?menu=mnavi01_03&subMenu=4900';
            } else if (this.id === 'menu_vg_e1_peak_history') {
                url = cst.contextPath() + '/watcher/go_history_stats.vg_e1_peak_history.vg_e1_peak_history.htm?menu=mnavi01_03&subMenu=5000';
            } else if (this.id === 'menu_vg_e1_peak_history_group') {
                url = cst.contextPath() + '/watcher/go_history_stats.vg_e1_peak_history.vg_e1_peak_group_history.htm?menu=mnavi01_03&subMenu=5100';
            }
           	else {
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

    function fn_subMenu(url) {
        $.blockUI(blockUIOption);
        location.href = url;
    }
</script>

<ul class="history_leftNv">
    <li><a id="menu_resource_history" href="#" <c:if test="${param.subMenu eq null or param.subMenu eq '3100'}">class="selected"</c:if>>리소스 이력</a></li>
    <%-- <li><a id="menu_process_history" href="#" <c:if test="${param.subMenu eq '3200'}">class="selected"</c:if>>프로세스/서비스 이력</a></li> --%>
    <li><a id="menu_error_history" href="#" <c:if test="${param.subMenu eq '3300'}">class="selected"</c:if>>장애 이력</a></li>
    <%--<li><a id="service_call_statistics" href="#" <c:if test="${param.subMenu eq '3500'}">class="selected"</c:if>>부서별 콜 통계</a></li> --%>
    <%--<li><a id="phone_call_statistics" href="#" <c:if test="${param.subMenu eq '3600'}">class="selected"</c:if>>내선별 콜 통계</a></li> --%>
    <%--<li><a id="phone_use_state" href="#" <c:if test="${param.subMenu eq '3700'}">class="selected"</c:if>>전화기 사용현황</a></li>--%>
    <%--<li><a id="day_report" href="#" <c:if test="${param.subMenu eq '3800'}">class="selected"</c:if>>일일보고서</a></li> --%>
    <%--<li><a id="phone_etc_statistics" href="#" <c:if test="${param.subMenu eq '3900'}">class="selected"</c:if>>내선별 기타 콜 통계</a></li> --%>
    <%--<li><a id="dept_increase_history" href="#" <c:if test="${param.subMenu eq '4000'}">class="selected"</c:if>>부서별 콜 증감추이 통계</a></li> --%>
    <%--<li><a id="login_status" href="#" <c:if test="${param.subMenu eq '4100'}">class="selected"</c:if>>로그인 현황정보</a></li> --%>
    <%--<li><a id="login_set_history" href="#" <c:if test="${param.subMenu eq '4200'}">class="selected"</c:if>>로그인 / 설정 이력</a></li>--%>
    <%--<li><a id="ipt_history" href="#" <c:if test="${param.subMenu eq '4300'}">class="selected"</c:if>>철거된 IPT 이력</a></li> --%>
    <%--<li><a id="phone_dept_use_state" href="#" <c:if test="${param.subMenu eq '4400'}">class="selected"</c:if>>콜현황(부서별)</a></li> --%>
    <%--<li><a id="in_call_use_state" href="#" <c:if test="${param.subMenu eq '4500'}">class="selected"</c:if>>콜현황(내선별)</a></li> --%>
    <%--<li><a id="jum_e1_chanel_state" href="#" <c:if test="${param.subMenu eq '4600'}">class="selected"</c:if>>센터별 E1 채널 현황</a></li> --%>
    <%--<li><a id="menu_call_history" href="#" <c:if test="${param.subMenu eq '4700'}">class="selected"</c:if>>콜 이력</a></li>--%>
    <%--<li><a id="rec_variation_history" href="#" <c:if test="${param.subMenu eq '4800'}">class="selected"</c:if>>녹취현황 이력</a></li> --%>
    <%--<li><a id="menu_phone_error_history" href="#" <c:if test="${param.subMenu eq '4900'}">class="selected"</c:if>>전화기 장애 이력</a></li>--%>
    <li><a id="menu_vg_e1_peak_history" href="#" <c:if test="${param.subMenu eq '5000'}">class="selected"</c:if>>VG E1 Peak 이력</a></li>
	<li><a id="menu_vg_e1_peak_history_group" href="#" <c:if test="${param.subMenu eq '5100'}">class="selected"</c:if>>VG E1 Peak 그룹이력</a></li>
</ul>