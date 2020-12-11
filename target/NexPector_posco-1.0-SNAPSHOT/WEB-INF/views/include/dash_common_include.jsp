<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<script type="text/javascript">
var c = createConstants('${ctx}');
c.countPerPage(10); // Paging 한페이지 표시 개수
c.pageSize(10); // Paging 하단 부분 몇개 나눌지 여부

kendo.culture("ko-KR");

String.prototype.string = function(len){var s = '', i = 0; while (i++ < len) { s += this; } return s;};
String.prototype.zf = function(len){return "0".string(len - this.length) + this;};
Number.prototype.zf = function(len){return this.toString().zf(len);};

Date.prototype.format = function(format) {
    if(!this.valueOf()) return " ";
 
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

function comma(num) {
    var len, point, str; 
       
    num = num + ""; 
    point = num.length % 3 ;
    len = num.length; 
   
    str = num.substring(0, point); 
    while(point < len) { 
        if(str != "") str += ","; 
        str += num.substring(point, point + 3); 
        point += 3; 
    }
     
    return str;
}

function currentDateTimer() {
	var date = new Date();
	$("#dday").text(date.format("yyyy.MM.dd (e)"));
	$("#dtime").text(date.format("hh:mm"));
	$("#ampm").text(date.format("A/P"));
}

function cmLog(s) {
	console.log(s);
}

var s_intervalInfo = {
	RELOAD: 5000,
	URL: "/dashboard/interval/change.htm"
}

var s_func_interval_reload = null;
var s_defaultInterval = 1000;
var s_reloadIntervalTimerId = null;
var s_tick_interval_count = 0;
var s_tick_page_count = 0;
var s_interval_playing = true;

function onCallback_Interval_Timer() {
	if(s_playing != true) {
		return;
	}
	
	if(s_interval_playing != true) {
		return;
	}
	
	s_tick_interval_count++;
	s_tick_page_count++;

	if(s_tick_page_count * s_defaultInterval >= s_pageInfo.RELOAD) {
		if(s_playing == true) {
			try {
				clearInterval(s_reloadIntervalTimerId);		
				s_reloadIntervalTimerId = null;
				//s_func_page_reload(s_tick_page_count);
				go_page();

			} catch(e) {
				cmLog(e);
			}
			s_tick_page_count = 0;
			return;			
		}
	}	
	
	if(s_tick_interval_count * s_defaultInterval >= s_intervalInfo.RELOAD) {
		if(s_func_interval_reload != null && s_playing == true) {
			try {
				s_func_interval_reload(s_tick_interval_count);
			} catch(e) {
				cmLog(e);
			}
			s_tick_interval_count = 0;
		}
	}
	
	console.log("s_tick_interval_count : " + s_tick_interval_count + "/"+ s_tick_page_count + " page[ " + s_pageInfo.RELOAD + " ], refresh[" + s_intervalInfo.RELOAD + " ]");
}

var s_pageInfo = {
	RELOAD: 15000,
	URL: "/dashboard/interval/change.htm"
}

var s_func_page_reload = null;
var s_defaultPage = 15000;
var s_reloadPageTimerId = null;
var s_page_playing = true;

/* function onCallback_Page_Timer() {
	s_tick_page_count++;
	
	if(s_tick_page_count > s_pageInfo.RELOAD) {
		if(s_func_page_reload != null && s_page_playing == true) {
			try {
				s_func_page_reload(s_tick_page_count);
			} catch(e) {
				cmLog(e);
			}
			s_tick_page_count = 0;
		}
	}
	
	// console.log("s_tick_page_count : " + s_tick_page_count);
} */

function init_time(url, cb_func) {
	s_intervalInfo.URL	= url;
	s_pageInfo.URL	= url;
	
	$('#spopup_close').click(function(e) {
		closePopup_Setting()
	});
	$('#btn_user_info_modify').click(function(e) {
		setModify();
		closePopup_Setting();
	});
	
	s_func_interval_reload = cb_func;
	//s_func_page_reload = go_page();
	
	s_tick_interval_count = 0;
	s_tick_page_count = 0;
	
	// s_reloadIntervalTimerId = setInterval("onCallback_Interval_Timer()", s_defaultInterval);
	// s_reloadPageTimerId = setInterval("onCallback_Page_Timer()", s_defaultPage);
}

function disp_intervalTime(data) {
	s_intervalInfo.RELOAD = data.N_INTERVAL_TIME;
	s_pageInfo.RELOAD = data.N_PAGE_TIME;
}

function openPopup_Setting() {
	console.log("start openPopup_Setting");
	set_refresh_time();	// 새로고침 시간 Setting
	set_page_time();	// Page 전환 시간 Setting
	console.log("after setting openPopup_Setting");
	
	// console.log("openPopup_Setting() refreshTime : " + refreshTime);
	// console.log("openPopup_Setting() change_page : " + change_page);
	// $("#reload_interval").val(refreshTime);
	// $("#change_page").val(pageTime);
	
	$('#myModal_small').dialog({
		  width : 500 // dialog 넓이 지정
		, height : 380 // dialog 높이 지정
		, modal : true // dialog를 modal 창으로 띄울것인지 결정
		, resizeable : false // 사이즈 조절가능 여부
		, open: function(event, ui) { 
			$(this).parent().children('.ui-dialog-titlebar').hide();
		}
	});
}

function get_refresh_time() {
	var sessionUserId = '${sessionScope.S_USER_ID}';
	var sUrl = "/dashboard/get_dash_inter_refresh_time.htm";
	var nIntervalType = 0;
	
	var params = {
		"SESSION_USER_ID" : sessionUserId,
		"S_URL" : "/dashboard/get_dash_inter_refresh_time.htm",
		"N_INTERVAL_TYPE" : nIntervalType
	};
	
	var jqXhr = $.post("/dashboard/get_dash_inter_refresh_time.htm", params);
	
	jqXhr.done(function(str) {
		// console.log("str : " + str);	// {"REFRESH_INFO":{"REFRESH_TIME":30000}}
		var data = JSON.parse(str);
		
		if(parseInt(data.REFRESH_INFO.REFRESH_TIME) > 0) {
			// console.log("data.REFRESH_INFO.REFRESH_TIME) > 0");
			// console.log("data.REFRESH_INFO.REFRESH_TIME : " + data.REFRESH_INFO.REFRESH_TIME);
			refreshTime = parseInt(data.REFRESH_INFO.REFRESH_TIME);
			
			s_intervalInfo.RELOAD = refreshTime;
			// console.log("refreshTime : " + refreshTime);
		} else {
			refreshTime = 0;
		}
		//go_refresh();
	});
}

function set_refresh_time() {
	var sessionUserId = '${sessionScope.S_USER_ID}';
	var sUrl = "/dashboard/get_dash_inter_refresh_time.htm";
	var nIntervalType = 0;
	
	var params = {
		"SESSION_USER_ID" : sessionUserId,
		"S_URL" : "/dashboard/get_dash_inter_refresh_time.htm",
		"N_INTERVAL_TYPE" : nIntervalType
	};
	
	var jqXhr = $.post("/dashboard/get_dash_inter_refresh_time.htm", params);
	
	jqXhr.done(function(str) {
		// console.log("str : " + str);	// {"REFRESH_INFO":{"REFRESH_TIME":30000}}
		var data = JSON.parse(str);
		
		if(parseInt(data.REFRESH_INFO.REFRESH_TIME) > 0) {
			// console.log("data.REFRESH_INFO.REFRESH_TIME) > 0");
			// console.log("data.REFRESH_INFO.REFRESH_TIME : " + data.REFRESH_INFO.REFRESH_TIME);
			refreshTime = parseInt(data.REFRESH_INFO.REFRESH_TIME);
			// console.log("refreshTime : " + refreshTime);
		} else {
			refreshTime = 0;
		}
		
		refreshTime = refreshTime / 1000;
		
		$("#reload_interval").val(refreshTime);
	});
}

function get_page_time() {
	var sessionUserId = '${sessionScope.S_USER_ID}';
	var sUrl = "/dashboard/get_dash_inter_page_time.htm";
	var nIntervalType = 0;
	
	var params = {
		"SESSION_USER_ID" : sessionUserId,
		"S_URL" : "/dashboard/get_dash_inter_page_time.htm",
		"N_INTERVAL_TYPE" : nIntervalType
	};
	
	var jqXhr = $.post("/dashboard/get_dash_inter_page_time.htm", params);
	
	jqXhr.done(function(str) {
		// console.log("str : " + str);	// {"PAGE_INFO":{"PAGE_TIME":30000}}
		var data = JSON.parse(str);
		
		if(parseInt(data.PAGE_INFO.PAGE_TIME) > 0) {
			// console.log("data.PAGE_INFO.PAGE_TIME) > 0");
			// console.log("data.PAGE_INFO.PAGE_TIME : " + data.PAGE_INFO.PAGE_TIME);
			pageTime = parseInt(data.PAGE_INFO.PAGE_TIME);
			
			s_pageInfo.RELOAD = pageTime;			
			// console.log("pageTime : " + pageTime);
		} else {
			pageTime = 0;
		}
		
		//go_page();
	});
}

function set_page_time() {
	var sessionUserId = '${sessionScope.S_USER_ID}';
	var sUrl = "/dashboard/get_dash_inter_page_time.htm";
	var nIntervalType = 0;
	
	var params = {
		"SESSION_USER_ID" : sessionUserId,
		"S_URL" : "/dashboard/get_dash_inter_page_time.htm", 
		"N_INTERVAL_TYPE" : nIntervalType
	};
	
	var jqXhr = $.post("/dashboard/get_dash_inter_page_time.htm", params);
	
	jqXhr.done(function(str) {
		// console.log("str : " + str);	// {"PAGE_INFO":{"PAGE_TIME":30000}}
		var data = JSON.parse(str);
		
		if(parseInt(data.PAGE_INFO.PAGE_TIME) > 0) {
			// console.log("data.PAGE_INFO.PAGE_TIME) > 0");
			// console.log("data.PAGE_INFO.PAGE_TIME : " + data.PAGE_INFO.PAGE_TIME);
			pageTime = parseInt(data.PAGE_INFO.PAGE_TIME);
			// console.log("pageTime : " + pageTime);
		} else {
			pageTime = 0;
		}
		
		pageTime = pageTime / 60000;
		
		$("#change_page").val(pageTime);
	});
}

function closePopup_Setting() {
	$('#myModal_small').dialog("close");
}

function setReloadStart() {
	s_playing = true;
	$('#reload_play').hide();
	$('#reload_stop').show();
		
	s_tick_interval_count = 0;
	s_tick_page_count = 0;
	
	console.log("setReloadStart : " + s_tick_interval_count);
}

function setReloadStop() {
	s_playing = false;
	$('#reload_play').show();
	$('#reload_stop').hide();
	
	console.log("setReloadStop : " + s_tick_interval_count);
}

function chkBtnStatSystem() {
	console.log("chkBtnStatSystem()");
	
	s_interval_playing = true;
	
	if($("#reload_play").is(":visible")) {
		init_time(s_url, disp_dashSystemInfo);
		
		// setTimeout에 설정할 초단위 시간을 DB에서 가져오기
		get_refresh_time();	// 새로고침 시간 구하기
		get_page_time();	// Page 전환 시
		disp_dashSystemInfo();
		
		console.log("if($('#reload_play').style.visibility == 'visible')");
		setReloadStart();
		//s_reloadPageTimerId = setInterval("onCallback_Page_Timer()", s_defaultPage);
	} else if($("#reload_play").is(":hidden")) {
		console.log("if($('#reload_play').style.visibility == 'hidden')");
		setReloadStop();
		//clearInterval(s_reloadPageTimerId);
	}

	s_reloadIntervalTimerId = setInterval("onCallback_Interval_Timer()", s_defaultInterval);
	s_tick_interval_count = 0;	
	/* if($("#reload_play").is(":visible")) {
		s_reloadIntervalTimerId = setInterval("onCallback_Interval_Timer()", s_defaultInterval);
		s_reloadPageTimerId = setInterval("onCallback_Page_Timer()", s_defaultPage);
	} else if($("#reload_play").is(":hidden")) {
		clearInterval(s_reloadIntervalTimerId);
		clearInterval(s_reloadPageTimerId);
	} */
}

function chkBtnStatService() {
	console.log("chkBtnStatService()");
	
	if($("#reload_play").is(":visible")) {
		init_time(s_url, disp_dashServiceInfo);
		
		// setTimeout에 설정할 초단위 시간을 DB에서 가져오기
		get_refresh_time();	// 새로고침 시간 구하기
		get_page_time();	// Page 전환 시
		disp_dashServiceInfo();
		
		console.log("if($('#reload_play').style.visibility == 'visible')");
		setReloadStart();
		
		//s_reloadPageTimerId = setInterval("onCallback_Page_Timer()", s_defaultPage);
	} else if($("#reload_play").is(":hidden")) {
		console.log("if($('#reload_play').style.visibility == 'hidden')");
		setReloadStop();
		
		//clearInterval(s_reloadPageTimerId);
	}
	
	s_reloadIntervalTimerId = setInterval("onCallback_Interval_Timer()", s_defaultInterval);
	s_tick_interval_count = 0;		
	/* if($("#reload_play").is(":visible")) {
		s_reloadIntervalTimerId = setInterval("onCallback_Interval_Timer()", s_defaultInterval);
		s_reloadPageTimerId = setInterval("onCallback_Page_Timer()", s_defaultPage);
	} else if($("#reload_play").is(":hidden")) {
		clearInterval(s_reloadIntervalTimerId);
		clearInterval(s_reloadPageTimerId);
	} */
}

function startInterval() {
	s_interval_playing = true;
}

function stopInterval() {
	s_interval_playing = false;
}

function startPage() {
	s_page_playing = true;
}

function stopPage() {
	s_page_playing = false;
}

function stopReloadInterval() {
	if(s_reloadIntervalTimerId != null) {
		clearInterval(s_reloadIntervalTimerId);
		s_reloadIntervalTimerId = null;
	}
}

function stopReloadPage() {
	if(s_reloadPageTimerId != null) {
		clearInterval(s_reloadPageTimerId);
		s_reloadPageTimerId = null;
	}
}

function setModify() {
	console.log("setModify()");
	
	var reload_interval = $("#reload_interval").val();
	var change_page = $("#change_page").val();
	console.log("reload_interval(sec) : " + reload_interval);
	console.log("change_page(min) : " + change_page);
	
	reload_interval = reload_interval * 1000;
	change_page = change_page * 60000;
	
	console.log("reload_interval * 1000 : " + reload_interval);
	console.log("change_page  * 60000 : " + change_page);
	
	/* if(reload_interval * 1000 < 5 * 1000) {
		alert("5 ~ 600(초) 사이의 값을 넣어주세요");
		return false;
	}
	
	if(change_page * 1000 < 15 * 1000) {
		alert("15 ~ 600(초) 사이의 값을 넣어주세요");
		return false;
	} */
	
	// var info = [s_intervalInfo, s_pageInfo];
	var url = ["/dashboard/set_dash_inter_refresh_time.htm", "/dashboard/set_dash_inter_page_time.htm"];
	var nIntervalTime = [reload_interval, change_page];
	var sessionUserId = ["${sessionScope.S_USER_ID}", "${sessionScope.S_USER_ID}"];
	var sUrl = ["/dashboard/get_dash_inter_refresh_time.htm", "/dashboard/get_dash_inter_page_time.htm"];
	var nIntervalType = [0, 0];
	
	/*
	var param = {
		  "N_INTERVAL_TIME" : nIntervalTime
		, "SESSION_USER_ID" : sessionUserId
		, "S_URL" : sUrl
		, "N_INTERVAL_TYPE" : nIntervalType
	};
	*/
	
	var param = [
	{
		  N_INTERVAL_TIME : nIntervalTime[0]
		, SESSION_USER_ID : sessionUserId[0]
		, S_URL           : sUrl[0]
		, N_INTERVAL_TYPE : nIntervalType[0]
	},
	{
		  N_INTERVAL_TIME : nIntervalTime[1]
		, SESSION_USER_ID : sessionUserId[1]
		, S_URL           : sUrl[1]
		, N_INTERVAL_TYPE : nIntervalType[1]
	}]
	
	//for(var i = 0; i < url.length; i++) {
	$.post(url[0], param[0]).done(function(data) {
		s_intervalInfo.RELOAD = reload_interval;
	});
	
	$.post(url[1], param[1]).done(function(data) {
		s_pageInfo.RELOAD = change_page;
	});
	//}
}
</script>

  <!-- 모달팝업 small-->
  <div id="myModal_small" class="popup_wrap_small small" style="display: none">
    <!-- Top -->
    <div class="top">
      <a href="javascript:closePopup_Setting();" class="close close-reveal-modal"><img src="/common/dashboard/images/btn_close.png" alt="닫기" style="float:right;"></a>
    </div>
    <!-- //Top -->
    <!-- Content -->
    <div class="content">
      <!-- table -->
      <div class="pop_tbl_wrap_1" style="margin-top: 30px;">
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
              <th class="pdl10" scope="row">새로고침(초)</th>
              <td class="pdl5"><input type="number" id="reload_interval" min="5" max="600"></td>
            </tr>
			<tr>
              <th class="pdl10" scope="row">페이지 전환(분)</th>
              <td class="pdl5"><input type="number" id="change_page" min="5" max="600"></td>
            </tr>            
          </tbody>
        </table>
      </div>
      <!-- //table -->
    </div>
    <!-- //Content -->
    <!-- bottom  -->
    <div class="btn_wrap">
      <a id="btn_user_info_modify" class="btn_default" href="javascript:;">변경</a>
    </div>
    <!-- //bottom  -->
  </div>
  <!-- //모달팝업 small-->   
