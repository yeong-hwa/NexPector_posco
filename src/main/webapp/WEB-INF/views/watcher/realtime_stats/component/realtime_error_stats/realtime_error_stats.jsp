<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:useBean id="cnt" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="data" class="java.util.ArrayList" scope="request"/>

<head>
<style>
    #tooltip{visibility:visible; position:absolute; top:5px; left:5px; border:solid 1 #777777; background:#ffffff; color:#555555; font-size:9pt;font-family:verdana; padding:7px; overflow:hidden; z-index:99999; display:none; }
</style>

<script language="javascript">

    $(function() {
        conversionCountText($('#allCount'));
        conversionCountText($('#equipmentCount'));

        $("#error_stat_data tr").css("cursor", "hand");

        $("#error_stat_data tr").hover(function () {
            $(this).css("background-color", "#DDDDDD");
        }, function () {
            $(this).css("background-color", "");
        });

        /*$("#error_stat_data tr").on('click', function () {
         var monId = $(this).children("td").children("input[name='N_MON_ID']").val();
         var groupCode = $(this).children("td").children("input[name='N_GROUP_CODE']").val();
         groupCode = groupCode ? groupCode : '';
         $.getJSON('<c:url value="/watcher/map_SvrLstByMonIdPageNum.htm"/>', {'MON_ID' : monId, 'N_GROUP_CODE' : groupCode}, function(data) {
         var pageNum = "";
         if(parseInt(data.NUM % 15) > 0)
         pageNum=parseInt(data.NUM / 15) + 1;
         else
         pageNum=parseInt(data.NUM / 15);

         alert(pageNum);
         var param = {'N_GROUP_CODE' : groupCode, 'N_MON_ID' : monId, pageNum : pageNum};
         goMenu(document.getElementById('mnavi01_02'), param); // main.jsp 에 선언되어있음.
         });
         });*/

        $("select[name='ERR_STATS_N_TYPE_CODE']").change(function () {
            fn_get_error_stats(); // component_screen.jsp 에 선언되어있음.
        });

//        goPage(1);
    });

    function goServerDetail(element, event) {
        if (event) {
            event.preventDefault ? event.preventDefault() : event.returnValue = false;
        }

        var monId = $(element).prevAll("input[name='N_MON_ID']").val();
        var groupCode = $(element).prevAll("input[name='N_GROUP_CODE']").val();
        groupCode = groupCode ? groupCode : '';
        $.getJSON('<c:url value="/watcher/map_SvrLstByMonIdPageNum.htm"/>', {'MON_ID' : monId, 'N_GROUP_CODE' : groupCode}, function(data) {
            var pageNum = "";
            if(parseInt(data.NUM % 15) > 0)
                pageNum=parseInt(data.NUM / 15) + 1;
            else
                pageNum=parseInt(data.NUM / 15);

            var param = {'N_GROUP_CODE' : groupCode, 'N_MON_ID' : monId, pageNum : pageNum, tabStrip : 'error'};
            goMenu(document.getElementById('mnavi01_02'), param); // main.jsp 에 선언되어있음.
        });
    }

    /*function goPage(pageNo) {
        getErrStatData(pageNo);
    }

    function getErrStatData(pageNo) {
        var param   = {
            "currentPageNo" 	: pageNo ? pageNo : 1,
            "N_GROUP_CODE"      : '${param.N_GROUP_CODE}'
        };
        $.getJSON(cst.contextPath() + '/watcher/pagination_realtimeErrorStatsQry2.htm', param)
            .done(function(data) {
                var list 			= data.list,
                    paginationInfo 	= data.paginationInfo;

                if (list.length == void 0){
                    $('#error_stat_data').append('<tr><td colspan="2" class="text_title" style="text-align: center;">No Data</td></tr>');
                }
                else {
                    $(list).each(function(){
                        $('#error_stat_data')
                            .append( $('<tr/>')
                                        .append( $('<td title="' + this.TOOL_S_ALM_MSG + '" />')
                                                    .append('<input type="hidden" name="N_GROUP_CODE" value="' + this.N_GROUP_CODE + '">')
                                                    .append('<input type="hidden" name="N_MON_ID" value="' + this.N_MON_ID + '">')
                                                    .append('<a href="#"><span class="ico_system"></span><strong>[' + this.S_MON_NAME + ']</strong>' + this.S_ALM_MSG + '</a>') )
                                        .append('<td class="last">' + this.D_UPDATE_TIME + '</td>') );
                    });
                }

                var request = $.ajax({
                    url 		: cst.contextPath() + "/watcher/pagination.htm",
                    method 		: 'post',
                    data 		: paginationInfo,
                    dataType 	: 'html'
                });

                request.done(function(data) {
                    $('.paginate_s').html(data);
                });
            });
    }*/

    function conversionCountText($countSpan) {
        var $strongNum1 = $('<strong/>').addClass('num01');
        var $strongNum2 = $('<strong/>').addClass('num02');
        var spanText    = $.trim($countSpan.text());
        var length      = spanText.length;
        var tempStrNum1 = '';
        var tempStrNum2 = '';

        for (var i = 0; i < length; i++) {
            if (spanText.charAt(i) === '0') {
                tempStrNum1 += spanText.charAt(i);
            } else {
                tempStrNum2 += spanText.charAt(i);
            }
        }

        $countSpan.text('');
        $countSpan.append($strongNum1.text(tempStrNum1)).append($strongNum2.text(tempStrNum2));
    }

    function showTipText(text, bg, width) {
        tooltip.innerText = text;
        tooltip.style.background = bg;
        tooltip.style.display = "inline";
        tooltip.style.width = width;
    }

    function showTipHtml(tag, bg, width) {
        tooltip.innerHTML = tag;
        tooltip.style.background = bg;
        tooltip.style.display = "inline";
        tooltip.style.width = width;
    }

    function hideTip() {
        tooltip.style.display = "none";
    }

    function moveTip() {
        tooltip.style.pixelTop = event.y + document.body.scrollTop + 5;
        tooltip.style.pixelLeft = event.x + document.body.scrollLeft;
    }

    //document.onmousemove = moveTip;

    //사용할때는
    //onmouseover="showTipHtml('내용','#ffffff',300);"
    //onmouseout="hideTip();"

    //html태그가 아닌 단순 텍스트만 사용한다면.
    //onmouseover="showTipText('내용','#ffffff',300);" 사용

</script>
</head>

<body>
<!-- stitleBox -->
<div class="stitleBox">
    <div class="st_under">
        <h3>시스템 장애 현황</h3>
        <span>장비타입 :<cmb:combo qryname="cmb_svr_type" firstdata="전체" seltagname="ERR_STATS_N_TYPE_CODE" etc="style=\"width:80;\"" selvalue="${param.ERR_STATS_N_TYPE_CODE}"/></span>
    </div>
</div>
<!-- table_typ1 -->
<table summary="실시간 장애 현황 리스트" class="table_typ1" cellpadding="0" cellspacing="0">
    <caption>실시간 장애 현황 리스트 및 시스템 오류 출력</caption>
    <colgroup>
        <col width="80%" />
        <col width="20%" />
    </colgroup>
    <thead>
    <tr>
        <th colspan="2">
            <span class="text_title">전체</span>
            <span id="allCount">
                <fmt:formatNumber type="number" minIntegerDigits="3" value="${cnt[0].ERR_CNT}"/>
            </span>
            <span class="text_title">장비</span>
            <span id="equipmentCount">
                <fmt:formatNumber type="number" minIntegerDigits="3" value="${cnt[0].ERR_SVR_CNT}"/>
            </span>
        </th>
    </tr>
    </thead>
    <tbody id="error_stat_data">
    <c:choose>
        <c:when test="${empty data}">
            <tr><td colspan="2" class="text_title" style="text-align: center;">No Data</td></tr>
        </c:when>
        <c:otherwise>
            <tr>
                <td colspan="2" style="padding:0px;">
                    <div id="div_error_stat" class="top_list_table" style="height: 200px;">
                        <table cellpadding="0" cellspacing="0">
                            <c:forEach var="m" items="${data}">
                            <tr>
                                <td title="${m.TOOL_S_ALM_MSG}">
                                    <input type="hidden" name="N_GROUP_CODE" value="${m.N_GROUP_CODE}">
                                    <input type="hidden" name="N_MON_ID" value="${m.N_MON_ID}">
                                    <a href="#" onclick="goServerDetail(this, event);"><span class="ico_system"></span><strong>[${m.S_MON_NAME}]</strong>${m.S_ALM_MSG}</a>
                                </td>
                                <td class="last">${m.D_UPDATE_TIME}</td>
                            </tr>
                            </c:forEach>
                        </table>
                    </div>
                </td>
            </tr>
        </c:otherwise>
    </c:choose>
    </tbody>
</table>
<!-- table_typ1 // -->
<!--paginate-->
<%--<div class="paginate_s"></div>--%>
<!--//paginate-->
<div id='tooltip'></div>
<!-- 내용 // -->
</body>