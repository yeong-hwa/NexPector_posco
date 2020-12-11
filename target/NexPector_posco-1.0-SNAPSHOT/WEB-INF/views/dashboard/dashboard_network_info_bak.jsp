<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/dashboard_include.jsp" %>
<html>

<head>
  <meta charset="utf-8">
  <title>::: [유안타증권] IPT/IPCC 모니터링 시스템 :::</title>
</head>

<body>
  <!--Wrapper-->
  <div id="wrapper">
    <!--Header-->
    <div id="header">
      <div class="logo fl">
        <a href='/watcher/realtime_stats/component/center_total.htm?menu=mnavi01_01'><img src="${img3}/logo.png" alt="유안타증권" /></a>
      </div>
      <div class="title fl">
        <p class="maintit">IPT/IPCC 시스템 현황</p>
        <p class="subtit">IPT/IPCC Monitoring System</p>
      </div>
      <div class="antena fl">
        <img src="${img3}/antena01.gif" alt="작동중" />
      </div>
      <!--탭-->
      <div class="tab fl">
        <a href="/dashboard/dashboard_system_info.htm">운영현황</a>
        <a class="on" href="/dashboard/dashboard_network_info.htm">네트워크 현황</a>
      </div>
      <!--//탭-->
      <div class="date_wrap fr">
        <span id="dday" class="date">2018.01.01(월)</span>
        <span id="dtime" class="time">03:28</span>
        <span id="ampm" class="time_ap">PM</span>
        <span class="setting">
        	<a id="intervalSet" href="#"><img src="${img3}/btn_setting.png" alt="설정" /></a>
        </span>
      </div>
    </div>
    <!--//Header-->

    <!--Content-->
    <div id="content_wrap">
      <!-- 목동 IDC -->
      <div class="mokdong fl">
        <div class="server1">
          <div class="lamp1 fl">
            <img src="${img3}/lamp_green.png" alt="정상">         
          </div>
          <div class="error_lamp1 fl" style="display:none;">
            <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
          </div>
          <div class="ser_element1">
            <ul>
            </ul>
          </div>
        </div>
        <div class="server2">
          <div class="lamp2 fl">
            <img src="${img3}/lamp_green.png" alt="정상">
          </div>
          <div class="error_lamp2 fl" style="display:none;">
            <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
          </div>

          <div class="ser_element2">
            <ul>
            </ul>
          </div>
        </div>
        <div class="server3">
          <div class="lamp3 fl">
            <img src="${img3}/lamp_green.png" alt="정상">
          </div>
          <div class="error_lamp3 fl" style="display:none;">
            <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
          </div>

          <div class="ser_element3">
            <ul>
            </ul>
          </div>
        </div>
        <div class="server4">
          <div class="lamp4 fl">
            <!-- <img src="${img3}/lamp_green.png" alt="정상">-->
            <img src="${img3}/lamp_red.png" alt="장애">
            <!-- <img src="${img3}/lamp_orange.png" alt="경고">
         <img src="${img3}/lamp_yellow.png" alt="주의">-->
          </div>
          <div class="error_lamp4 fl" style="display:none;">
            <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
          </div>
          <div class="ser_element4">
            <ul>
            </ul>
          </div>
        </div>
        <div class="server5">
          <div class="lamp5 fl">
            <img src="${img3}/lamp_green.png" alt="정상">
            <!--
         <img src="${img3}/lamp_red.png" alt="장애">
         <img src="${img3}/lamp_orange.png" alt="경고">
         <img src="${img3}/lamp_yellow.png" alt="주의">
-->
          </div>
          <div class="error_lamp5 fl" style="display:none;">
            <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
          </div>

          <div class="ser_element5">
            <ul>
            </ul>
          </div>
        </div>
        <div class="server6">
          <div class="lamp6 fl">
            <!-- <img src="${img3}/lamp_green.png" alt="정상">-->
            <img src="${img3}/lamp_red.png" alt="장애">
            <!-- <img src="${img3}/lamp_orange.png" alt="경고">
         <img src="${img3}/lamp_yellow.png" alt="주의">-->
          </div>
          <div class="error_lamp6 fl" style="display:none;">
            <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
          </div>
          <div class="ser_element6">
            <ul>
            </ul>
          </div>
        </div>
        <div class="server7">
          <div class="lamp7 fl">
            <!-- <img src="${img3}/lamp_green.png" alt="정상">-->
            <img src="${img3}/lamp_red.png" alt="장애">
            <!-- <img src="${img3}/lamp_orange.png" alt="경고">
         <img src="${img3}/lamp_yellow.png" alt="주의">-->
          </div>
          <div class="error_lamp7 fl" style="display:none;">
            <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
          </div>
          <div class="ser_element7">
            <ul>
            </ul>
          </div>
        </div>
        <div class="error_lamp8" style="display:none;">
          <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
        </div>
        <div class="error_lamp9" style="display:none;">
          <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
        </div>
        <div class="error_lamp10" style="display:none;">
          <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
        </div>
        <div class="error_lamp11" style="display:none;">
          <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
        </div>
        <div class="error_lamp12" style="display:none;">
          <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
        </div>
        <div class="error_lamp13" style="display:none;">
          <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
        </div>
        <div class="error_lamp14" style="display:none;">
          <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
        </div>
        <div class="error_lamp15" style="display:none;">
          <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
        </div>
        <div class="error_lamp16" style="display:none;">
          <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
        </div>
        <div class="error_lamp17" style="display:none;">
          <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
        </div>
        <div class="error_lamp18" style="display:none;">
          <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
        </div>
        <div class="error_lamp19" style="display:none;">
          <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
        </div>
        <div class="error_lamp20" style="display:none;">
          <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
        </div>
        <div class="error_lamp21" style="display:none;">
          <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
        </div>
        <div class="error_lamp22" style="display:none;">
          <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
        </div>
      </div>
      <!-- //목동 IDC -->
      <!-- 분당 IDC -->
      <div class="bundang fr">
        <div class="server25">
          <div class="lamp25 fl">
            <img src="${img3}/lamp_green.png" alt="정상">
            <!-- <img src="${img3}/lamp_red.png" alt="장애">
              <img src="${img3}/lamp_orange.png" alt="경고">
              <img src="${img3}/lamp_yellow.png" alt="주의">  -->
          </div>
          <div class="error_lamp25 fl" style="display:none;">
            <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
          </div>
          <div class="ser_element25">
            <ul>
            </ul>
          </div>
        </div>
        <div class="server26">
          <div class="lamp26 fl">
            <!--  <img src="${img3}/lamp_green.png" alt="정상">         
              <img src="${img3}/lamp_red.png" alt="장애">
              <img src="${img3}/lamp_orange.png" alt="경고">-->
            <img src="${img3}/lamp_yellow.png" alt="주의">
          </div>
          <div class="error_lamp26 fl" style="display:none;">
            <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
          </div>
          <div class="ser_element26">
            <ul>
            </ul>
          </div>
        </div>
        <div class="server27">
          <div class="lamp27 fl">
            <!--  <img src="${img3}/lamp_green.png" alt="정상">         
              <img src="${img3}/lamp_red.png" alt="장애">
              <img src="${img3}/lamp_orange.png" alt="경고">-->
            <img src="${img3}/lamp_yellow.png" alt="주의">
          </div>
          <div class="error_lamp27 fl" style="display:none;">
            <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
          </div>
          <div class="ser_element27">
            <ul>
            </ul>
          </div>
        </div>
        <div class="error_lamp28" style="display:none;">
          <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
        </div>
        <div class="error_lamp29" style="display:none;">
          <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
        </div>
        <div class="error_lamp30" style="display:none;">
          <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
        </div>
        <div class="error_lamp31" style="display:none;">
          <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
        </div>
        <div class="error_lamp32" style="display:none;">
          <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
        </div>
        <div class="error_lamp33" style="display:none;">
          <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
        </div>
        <div class="error_lamp34" style="display:none;">
          <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
        </div>
      </div>
      <!-- //분당 IDC -->
      <!-- 본사 -->
      <div class="headoffice fl">
        <div class="error_lamp40" style="display:none;">
          <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
        </div>
        <div class="error_lamp41" style="display:none;">
          <a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
        </div>
      </div>
      <!-- //본사 -->
    </div>
    <!--//Content-->
  </div>
  <!--//Wrapper -->

  <div id="dashboard_error_popup"></div>
  
  <input type="hidden" id="interval_url" name="interval_url" value="/dashboard/dashboard_network_info.htm">
  
  <script>
	var concerto_date;
	var search_date;
	var error_popup;
	
	$(document).ready( function() {
	    fn_init();
        intervalInit();

	    // 스크롤 색상 변경
		$("#content-7").mCustomScrollbar({
			scrollButtons:{enable:true},
			theme:"3d-thick"
		});
		$("#content-7_2").mCustomScrollbar({
			scrollButtons:{enable:true},
			theme:"3d-thick"
		});
	});
	
	function fn_init() {
		// 조회
		fn_search();

		// 현재 날짜, 시간
		currentDateTimer();
		
		// 조회용 날짜 시간 셋팅
		if(concerto_date==null || concerto_date==""){
			concerto_date = new Date();

			var year = concerto_date.getFullYear();
			var mon = (concerto_date.getMonth()+1)>9 ? ''+(concerto_date.getMonth()+1) : '0'+(concerto_date.getMonth()+1);
			var day = concerto_date.getDate()>9 ? ''+concerto_date.getDate() : '0'+concerto_date.getDate();
			var hours = concerto_date.getHours();
			var min = concerto_date.getMinutes();
			var sec = concerto_date.getSeconds();

			if (hours < 10){
				hours = "0" + hours;
			}

			if (min < 10){
				min = "0" + min;
			}

			if(sec < 10){
				sec = "0" + sec;
			}
			concerto_date = year+mon+day+hours+min+sec;
		}

		if(search_date==null || search_date==""){
			search_date = concerto_date;
		}
		$("#LOGIN_DT").val(concerto_date);
		$("#LAST_ALARM_DT").val(search_date);
		
	}

	// 조회
	function fn_search(){
		// 이전 reload timeout 제거
		fn_clearReloadIntervalSetting();
		
		// 현재 시간 갱신
		currentDateTimer();
		
		$.ajax({
			url:'<c:url value="/dashboard/network_info.htm"/>',
	        type:"post",
	        data:{S_URL : $('#interval_url').val()},
	        dataType : "json",
	        success: function(RES) {
				setNetworkInfo(RES);

                // setIntervalInfo(RES);
	          },
	          error: function(res,error) {
	          	//alert("에러가 발생했습니다."+error);
	          }
		});
	}

	function setNetworkInfo(RES) {
		/* diagram class  */
		setNetworkMapInfo(RES.NETWORK_MAP);

		setNetworkErrorStatus(RES.NETWORK_ERROR_STATUS);
    }

	// 장비 정보 세팅
	function setNetworkMapInfo(data) {
		var NetworkMap = data;

		// 가상화 장비 리스트 초기화
		for (var i = 0; i < 30; i++) {
			$('.ser_element' + i + ' ul').empty();
		}

		console.log('NetworkMap: ', NetworkMap);
		
		for (var i = 0; i < NetworkMap.length; i++ ) {
			var server = NetworkMap[i];
			if (server.F_PARENT && server.F_PARENT == 'Y') { // 물리 장비일 경우 
				var serverDom = $('.server' + server.MAP_ID);
				serverDom.attr('id', 'mon_' + server.MON_ID);
				serverDom.attr('map_id', '' + server.MAP_ID);
				serverDom.attr('f_parent', server.F_PARENT);
				
				var errorAlmDom = $('.error_lamp' + server.MAP_ID);
				errorAlmDom.attr('id', 'error_mon_' + server.MON_ID);
				
				var monId = NetworkMap[i].MON_ID;
				// console.log('clicked monId: ', monId);
				// errorAlmDom.off('click').on('click', function() {openErrorPopup({MON_ID: monId})}); // 에러있음
				errorAlmDom.removeAttr('onclick').attr('onclick', "openErrorPopup(" + JSON.stringify({MON_ID: server.MON_ID, F_PARENT: server.F_PARENT}) + ")");
			}
			else { // 가상화 장비일 경우
				var serverUlDom = $('.server' + server.PARENT_MAP_ID +  ' .ser_element' + server.PARENT_MAP_ID + ' ul');
			
				var html = "";
				html += "<li>";
				html += "	<span id='mon_";
				html += 		server.MON_ID;
				html += "' parent_map_id='";
				html += 		server.PARENT_MAP_ID;
				html += "' class='squlamp_gn'>";
				html += "	</span>";
				html += 		server.MON_NAME;
				html += "</li>";
				
				serverUlDom.append(html);
			}
		}
	}
	
    // Network error status check
    function setNetworkErrorStatus(errorData) {
    	initLamp();
    	
        if (errorData != null) {
  			setLamp(errorData);
        } 
    }
	
    // 램프 초기화
    function initLamp(data) {
        // 물리장비 장애 램프 초기화
        for (var i = 0; i < 50; i++ ) {
            $(".error_lamp" + i).hide();
        }
        // 서버 상태 램프 초기화
        for (var i = 0; i < 50; i++ ) {
            $(".lamp" + i + ' img').attr('src', '/common/dashboard/images/lamp_green.png');
        }
        // 램프 상태 저장 값 초기화
        for (var i = 0; i < 50; i++ ) {
	        $(".server" + i).attr('alm_rating', 0);
        }
        
        // 가상 장비 램프 초기화
        $(".squlamp_yw").each(function (inx, element) {
        	$(element).removeClass('squlamp_yw').addClass('squlamp_gn');
        });
        $(".squlamp_rd").each(function (inx, element) {
        	$(element).removeClass('squlamp_rd').addClass('squlamp_gn');
        });
        $(".squlamp_rd").each(function (inx, element) {
        	$(element).removeClass('squlamp_rd').addClass('squlamp_gn');
        });
    }
    
	// 에러 알람 표시
    function setLamp(data) {
		for(var i = 0; i < data.length; i++){
        	if (data[i] != null) {
        		var elem = $('#mon_' + data[i].N_MON_ID);
				
        		var parentMapId = elem.attr('parent_map_id');

				if(!parentMapId) { // 물리 장비일 경우
					$('.error_lamp' + elem.attr('map_id')).show();
				}
				else { // 가상화 장비일 경우
					elem.removeClass('squlamp_gn').removeClass('squlamp_rd').removeClass('squlamp_yw');
					
					var selector = '.server' + parentMapId;
					$('.error_lamp' + parentMapId).show();
					
					var parentMapElem = $(selector);
					var parentMapImgElem = $(selector + ' > div > img');

					var almRating = data[i].N_ALM_RATING;
					
 					if (almRating == 1) { // 장애
						elem.addClass('squlamp_rd'); // 가상화장비 램프 변경
						
						parentMapElem.attr('alm_rating', almRating); // 물리 장비 램프상태 저장
						parentMapImgElem.attr('src', '/common/dashboard/images/lamp_red.png');
					} else if (almRating == 2) { // 경고
						elem.addClass('squlamp_yw'); // 가상화장비 램프 변경
						
						var status = parentMapElem.attr('alm_rating');
						if (status == 0 || status == 3) { // 장애가 여러개 일시 장애 우선.
							parentMapElem.attr('alm_rating', almStatus); // 물리 장비 램프상태 저장
							parentMapImgElem.attr('src', '/common/dashboard/images/lamp_orange.png');
						}
						
					} else if (almRating == 3) { // 주의
						elem.addClass('squlamp_yw'); // 가상화장비 램프 변경
						
						var status = parentMapElem.attr('alm_rating');
						if (status == 0) { // 장애가 여러개 일시 장애 우선.
							parentMapElem.attr('alm_rating', almStatus); // 물리 장비 램프상태 저장
							parentMapImgElem.attr('src', '/common/dashboard/images/lamp_yellow.png');
						}
					}
				}
        	}
        }
    }
    
    // 텍스트 적용 function
	function fn_empty(value) {
		if(value == "0"){
			return value;
		}

		if(value == null || value == "") {
			return "&nbsp;";
		}
	    return value;
	}

	// 페이지 롤링 -->> 시스템 현황 이동
	function fn_pagemove(){
	//	fn_clearIntervalSetting(); // 모든 timeout 제거
	// 	location.replace('/dashboard/dashboard_system_info.htm');
	}

	// 알람 소리 및 화면 표시
	function fn_chk_alarm_status(){
		$.ajax({
			url:'<c:url value="/dashboard/error_alram.htm"/>',
			type:"post",
			data:{LOGIN_DT : $("#LOGIN_DT").val(), LAST_ALARM_DT :$("#LAST_ALARM_DT").val()},
			dataType : "json",
			success: function(RES) {
				if (RES.DASHBOARDALM != null) {
					var dashBoardA = new Array();
					dashBoardA = RES.DASHBOARDALM;
					for(i=0; i < dashBoardA.length; i++){
						if(dashBoardA[i].NEW_ALARM == "1"){
							fn_alarm_sound();
							//fn_error_popup_open(RES.DASHBOARDALM);
							return;
						}
					}
				}

			},
			error: function(res,error) {
				//alert("에러가 발생했습니다."+error);
			}
		});
		setTimeout("fn_chk_alarm_status()", 10000);
	}

	// 알림소리
	function fn_alarm_sound() {
		var tmp_embed_tag = '<embed src="<c:url value="/common/wav/error.wav"/>" hidden="true" style="display: none;">';
		document.all.div_alarm_sound.innerHTML = tmp_embed_tag;
	}

	// 알림 팝업
	function fn_error_popup_open(obj) {
		var errorListA = new Array();

		errorListA = obj;

		var tmp_table_html = '<table id="alarm_list" width="100%" border="0" cellspacing="0" cellpadding="0">';
		for(var i=0;i<errorListA.length;i++)
		{
			tmp_table_html += '<tr ' + ((i%2 == 0)?"bgcolor='eeeeee'":"") + ' class="line_gray" align="center" onclick="fn_alarm_history_popup(\'' + errorListA[i].N_MON_ID + '\', \'' + errorListA[i].S_ALM_KEY + '\')">';
			tmp_table_html += '<td height="29" width="3%"><img src="${img3}/warning_view.gif"></td>';
			tmp_table_html += '<td width="23%">' + errorListA[i].D_UPDATE_TIME + '</td>';
			tmp_table_html += '<td width="18%">' + errorListA[i].S_MON_NAME + '</td>';
			tmp_table_html += '<td width="15%">' + errorListA[i].S_ALM_RATING_NAME + '</td>';
			tmp_table_html += '<td width="5%">' + errorListA[i].S_ALM_STATUS_NAME + '</td>';
			tmp_table_html += '<td width="36%" align="left">&nbsp;&nbsp;' + errorListA[i].S_ALM_MSG + '</td>';
			tmp_table_html += '</tr>';
		}
		tmp_table_html += '</table>';

		$("#alarm_list").html(tmp_table_html);

		var pop = document.getElementById("layerPop");
		pop.style.display = "block";
		pop.style.top = "200" + "px";
		pop.style.left = "500" + "px";

		//setTimeout("closeLayer()", 10000);
	}

	//레이어 팝업 닫기
	function closeLayer() {
		var pop = document.getElementById("layerPop");
		pop.style.display = "none";
	}

	// 팝업 최저 크기
	function fn_min_cover() {
		$("#ifm_cover").width("200");
		$("#ifm_cover").height("35");
	}

	// 팝업 최대 크기
	function fn_max_cover() {
		$("#ifm_cover").width("100%");
		$("#ifm_cover").height("920");
	}
	 
	function comma(num) {
	    var len, point, str; 
	       
	    num = num + ""; 
	    point = num.length % 3 ;
	    len = num.length; 
	   
	    str = num.substring(0, point); 
	    while (point < len) { 
	        if (str != "") str += ","; 
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
	};
	
	</script>
</body>

</html>