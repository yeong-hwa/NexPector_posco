<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>::: [POSCO] HELP System 모니터링  :::</title>
</head>

<%@ include file="/WEB-INF/views/include/dashboard_include.jsp" %>

<body>
  <!--Wrapper-->
  <div id="wrapper">
    <!--Header-->
    <div id="header">
      <div class="logo fl">
        <a href='/watcher/realtime_stats/component/center_total.htm?menu=mnavi01_01'><img src="${img3}/logo.png" alt="POSCO" /></a>
      </div>
      <div class="title fl">
				<p class="maintit">HELP 시스템 현황</p>
				<p class="subtit">Nexpector Monitoring System</p>
      </div>
      <div class="antena fl">
        <img src="${img3}/antena01.gif" alt="작동중" />
      </div>
      <!--탭-->
      <div class="tab fl">
        <!--<a href="/dashboard/dashboard_system_info.htm">운영현황</a>-->
        <!--<a class="on" href="/dashboard/dashboard_network_info.htm">네트워크 현황</a>-->
      </div>
      <!--//탭-->
      <div class="date_wrap fr">
        <span id="dday" class="date">2018.01.01(월)</span>
        <span id="dtime" class="time">03:28</span>
        <span id="ampm" class="time_ap">PM</span>
        <span class="setting">
        	<!--<a id="intervalSet" href="#"><img src="${img3}/btn_setting.png" alt="설정" /></a>-->
        </span>
      </div>
    </div>
    <!--//Header-->

    <!--Content-->
	<div id="content_op_wrap">
		<div class="leftWrap fl">	
				  <!-- 목동 IDC -->
		  <div class="mokdong fl">
	 
		  </div>
	      <div class="seoul fl">
        	<div class="error_lamps11" style="display:none;">
         		<a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
       		</div>
        	<div class="error_lamps21" style="display:none;">
          		<a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
       		</div>
        	<div class="error_lamps22" style="display:none;">
          		<a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
       		</div>
        	<div class="error_lamps23" style="display:none;">
          		<a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
       		</div>
        	<div class="error_lamps24" style="display:none;">
          		<a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
       		</div>
        	<div class="error_lamps25" style="display:none;">
          		<a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
       		</div>
        	<div class="error_lamps26" style="display:none;">
          		<a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
       		</div>       		
        	<div class="error_lamps31" style="display:none;">
          		<a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
       		</div>    
        	<div class="error_lamps32" style="display:none;">
          		<a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
       		</div> 
        	<div class="error_lamps33" style="display:none;">
          		<a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
       		</div> 
        	<div class="error_lamps34" style="display:none;">
          		<a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
       		</div> 
        	<div class="error_lamps35" style="display:none;">
          		<a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
       		</div> 
  		       		       		   		       		       		       		       		
     	 </div>	
	      <div class="pohang fl">
        	<div class="error_lampp11" style="display:none;">
         		<a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
       		</div>
        	<div class="error_lampp21" style="display:none;">
         		<a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
       		</div>
        	<div class="error_lampp22" style="display:none;">
         		<a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
       		</div>
        	<div class="error_lampp31" style="display:none;">
         		<a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
       		</div>
        	<div class="error_lampp32" style="display:none;">
         		<a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
       		</div>
     	 </div>	
	      <div class="chungjoo fl">
        	<div class="error_lampch11" style="display:none;">
         		<a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
       		</div>
        	<div class="error_lampch12" style="display:none;">
         		<a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
       		</div>
       		<div class="error_lampch13" style="display:none;">
         		<a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
       		</div>
        	<div class="error_lampch21" style="display:none;">
         		<a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
       		</div>
        	<div class="error_lampch22" style="display:none;">
         		<a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
       		</div>
        	<div class="error_lampch23" style="display:none;">
         		<a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
       		</div>
        	<div class="error_lampch24" style="display:none;">
         		<a href="#"><img src="${img3}/lamp_error.png" alt="장애알림"></a>
       		</div>
     	 </div>	     	      	 
<!--<div id="content_wrap">-->


		  <!-- //본사 -->
		  <!-- 오른쪽 -->
		</div>
		<div class="rightWrap fl">
			<div class="col_lg_1 ">
				<div class="stitwrap mgb21">
					<h1 class="stitle fl">
						<span class="">자원</span> 사용 현황
					</h1>
				</div>
				<div class="graphbox">
					<div class="graph_tit">
						<span class="bullet"></span>CPU 사용률 Top 5
					</div>
					<div id="cpu_chart" >
					</div>
				</div>
				<div class="graphbox mgt30">
					<div class="graph_tit">
						<span class="bullet"></span>Memory 사용률 Top 5
					</div>
					<div id="memory_chart" >
					</div>
				</div>
				<div class="graphbox mgt30">
					<div class="graph_tit">
						<span class="bullet"></span>Disk 사용률 Top 5
					</div>
					<div id="disk_chart" >
					</div>
				</div>
			</div>

		</div>
		<!-- //오른쪽 -->
    </div>
    <!--//Content-->
  </div>
  <!--//Wrapper -->
  <span id="div_alarm_sound" style="display:none;"/>

  <div id="dashboard_error_popup"></div>
  
  <input type="hidden" id="interval_url" name="interval_url" value="/dashboard/dashboard_network_info.htm">
  
  <script>
	var concerto_date;
	var search_date;
	var error_popup;
	var almRatings = new Array();
	
	$(document).ready( function() {
	    fn_init();
        ///intervalInit();

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
		
		// 차트 생성
        createChart("#cpu_chart", null);
        createChart("#memory_chart", null);
        createChart("#disk_chart", null);
		

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
	

	// kendo chart 생성
	function createChart(id, data){
		$(id).kendoChart({
			dataSource: {
				data: data
			},
			// renderAs: "canvas",
			chartArea: {
			    background: "transparent"
			},  
			plotArea: {
		    	background: "transparent"
		   	},
		   	legend: {
				visible: false
			},
			seriesDefaults: {
				type: "bar",
				labels: {
                    visible: true,
                    color: 'white',
                    background: "transparent"
                }
			},
			series: [{
				field : "N_PER_USE",
                colorField: "N_PER_USE_COLOR"
			}],
			valueAxis: {
                max: 103,
                min: 0,
                line: {
					visible: true,
					color: "#5f605b"
				},
				majorGridLines: {
                    visible: true,
                    color: "#5f605b"
                },
                labels: {
                    visible: true,
                    color: 'white',
                    background: "transparent"
                }
			},
			categoryAxis: {
				field: "S_MON_NAME",
				color: "#FFF",
				line: {
					visible: true
					, color: "#FFF"
				},
				majorGridLines: {
                    visible: false
                },
				labels: {
					cursor: 'pointer'
				}
                /* , labels: {
                    font: "NotoS_R, 굴림, Dotum, tahoma, sans-serif"
                    , margin : 0 // { left: -5 }
                	, padding : 0
                } */
 			},
			tooltip: {
				visible: true,
				format: "{0}",
				template: "#= value #%",
				color: 'white'
			},
			seriesClick: function (e) {
				location.href = "/watcher/server_detail/monitoring.htm?menu=mnavi01_02&N_MON_ID=" + e.dataItem.N_MON_ID;
			},
			axisLabelClick: function (e) {
				if (e.dataItem) {
					location.href = "/watcher/server_detail/monitoring.htm?menu=mnavi01_02&N_MON_ID=" + e.dataItem.N_MON_ID;
				}
			}
		}); 
	}	

	var dashtimeout = null;
	// 조회
	function fn_search(){
		// 이전 reload timeout 제거
		//fn_clearReloadIntervalSetting();

		if(dashtimeout != null)
			clearTimeout(dashtimeout);
		
		// 현재 시간 갱신
		currentDateTimer();
		
		$.ajax({
			url:'<c:url value="/dashboard/network_info.htm"/>',
	        type:"post",
	        data:{S_URL : $('#interval_url').val()},
	        dataType : "json",
	        success: function(RES) {
				setNetworkInfo(RES);

                //setIntervalInfo(RES);

                        		// 자원 사용 현황 차트
        		//setUsingChartInfo(RES);
	          },
	          error: function(res,error) {
	          	//alert("에러가 발생했습니다."+error);
	          }
		});
		
		//fn_chk_alarm_status();

		dashtimeout = setTimeout("fn_search()", 10000);


				// 자원 사용 현황 차트
		//setUsingChartInfo(RES);
	}

	function setNetworkInfo(RES) {
		/* diagram class  */
		//setNetworkMapInfo(RES.NETWORK_MAP);
		setNetworkErrorStatus(RES.NETWORK_ERROR_STATUS);

		fn_chk_alarm_status_new(RES.NETWORK_ERROR_STATUS);
		
		// 자원 사용 현황 차트
		setUsingChartInfo(RES);
	}
	
	function fn_chk_alarm_status_new(errorData) {
        if (errorData != null) {
        	if(errorData.length > 0){
    			var errorInfo = errorData[0];
    			console.log("fn_chk_alarm_status : " + errorInfo.CHECK_DT + " : " + search_date);
    			if(errorInfo.CHECK_DT > search_date) {
    				fn_alarm_sound();
    				search_date = errorInfo.CHECK_DT;
    			}
    		}
    	} 
	}
	
	function setUsingChartInfo(data) {
		/* 사용률 Top (CPU) */
        // setDataChart("#using_cpu_chart", RES.DISK_USING_RATIO);
		$("#cpu_chart").data("kendoChart").setDataSource(data.CPU_USING_RATIO);

        /* 사용률 Top (MEMORY) */
        // setDataChart("#using_memory_chart", RES.MEMORY_USING_RATIO);
		$("#memory_chart").data("kendoChart").setDataSource(data.MEMORY_USING_RATIO);
        
        /* 사용률 Top (DISK) */
        // setDataChart("#using_disk_chart", RES.DISK_USING_RATIO);
		$("#disk_chart").data("kendoChart").setDataSource(data.DISK_USING_RATIO);
	}	

	// 장비 정보 세팅
	function setNetworkMapInfo(data) {
		var NetworkMap = data;

		// 가상화 장비 리스트 초기화
		for (var i = 0; i < 30; i++) {
			$('.ser_element' + i + ' ul').empty();
		}

		// console.log('NetworkMap: ', NetworkMap);
		var errorAlmDom = $('.error_lamps11');
		errorAlmDom.attr('id', 'error_map_s11');

		
		
		for (var i = 0; i < NetworkMap.length; i++ ) {
			var server = NetworkMap[i];
			 if (!server.PARENT_MAP_ID) { /* 물리 장비일 경우 */
				var errorAlmDom = $('.error_lamp' + server.MAP_ID);
				errorAlmDom.attr('id', 'error_map_' + server.MAP_ID);
				errorAlmDom.removeAttr('onclick').attr('onclick', "openErrorPopup(" + JSON.stringify({MAP_ID: server.MAP_ID, F_PARENT: server.F_PARENT}) + ")");
			}
			
		}
	}

    // Network error status check
    function setNetworkErrorStatus(errorData) {
    	initLamp();
    	
        if (errorData != null) {
  			setLamp(errorData);
        } 
        
/*		onErrorLamp('s26');
         onErrorLamp('s11');
        onErrorLamp('s21');
        onErrorLamp('s22');
        onErrorLamp('s23');
        onErrorLamp('s24');
        onErrorLamp('s25');
        onErrorLamp('s31');
        onErrorLamp('s32');
        onErrorLamp('s33');
        onErrorLamp('s34');
        onErrorLamp('s35');
        
        onErrorLamp('p11');
        onErrorLamp('p21');
        onErrorLamp('p22');
        onErrorLamp('p31');
        onErrorLamp('p32');
        
        onErrorLamp('ch11');
        onErrorLamp('ch21');
        onErrorLamp('ch22');
        onErrorLamp('ch23');
        onErrorLamp('ch24');  */
        
    }
	
    // 램프 초기화
    function initLamp(data) {
        // 물리장비 장애 램프 초기화
        for (var i = 0; i < 50; i++ ) {
            $(".error_lamps" + i).hide();
            $(".error_lampp" + i).hide();
            $(".error_lampch" + i).hide();
        }
        // 서버 상태 램프 초기화
		/*
        for (var i = 0; i < 50; i++ ) {
            $(".lamp" + i + ' img').attr('src', '/common/dashboard/images/lamp_green.png');
        }
        // 가상 장비 램프 초기화
        $(".squlamp_yw").each(function (inx, element) {
        	$(element).removeClass('squlamp_yw').addClass('squlamp_gn');
        });
        $(".squlamp_og").each(function (inx, element) {
        	$(element).removeClass('squlamp_og').addClass('squlamp_gn');
        });
        $(".squlamp_rd").each(function (inx, element) {
        	$(element).removeClass('squlamp_rd').addClass('squlamp_gn');
        });
		*/
    }
    
    // 장애(느낌표 이미지) 램프  표시
    function onErrorLamp(id) {
    	$('.error_lamp' + id).show();
    }
    
    // 물리서버 status 램프 표시
    function onServerStatusLamp(elem, almRating) {
    	if (almRating == 1) { // 장애
			elem.attr('src', '/common/dashboard/images/lamp_red.png');
		} else if (almRating == 2) { // 경고
			elem.attr('src', '/common/dashboard/images/lamp_orange.png');
		} else if (almRating == 3) { // 주의
			elem.attr('src', '/common/dashboard/images/lamp_yellow.png');
		}
    }
    
	// 장애, 경고, 주의 순으로 알람등급 우선 
	function setServerAlmRating(mapId, comparingRating) {
		if (!almRatings[mapId]) {
			almRatings[mapId] = 0;
		}
		if (comparingRating == 1) { // 장애
			almRatings[mapId] = 1;
		}
		else if (comparingRating == 2) { // 경고
			if (almRatings[mapId] >= 2) {
				almRatings[mapId] = 2;
			}
		}
		else if (comparingRating == 3) { // 주의
			if (almRatings[mapId] >= 3) {
				almRatings[mapId] = 3;
			}
		}
	}
    
	// 에러 알람 표시
    function setLamp(data) {
		// 물리서버 알람등급 초기화
		for (var key in almRatings) {
			almRatings[key] = 0;
		}
		
		for(var i = 0; i < data.length; i++){
			var errorInfo = data[i];
			
			if (!errorInfo.PARENT_MAP_ID) { /* 물리장비일 경우 */
				onErrorLamp(errorInfo.MAP_ID); // 느낌표 장애 표시
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

//	var alarmalerttimer = null;

	// 알람 소리 및 화면 표시
	function fn_chk_alarm_status(){
		return;/*
		if (g_login_dt == null || g_login_dt == "") {
			g_login_dt = cfn_getTimeStamp();
		}

//		if(alarmalerttimer != null)
//			clearTimeout(alarmalerttimer);

		$.ajax({
			//url:'<c:url value="/dashboard/error_alram.htm"/>',
			url:'<c:url value="/watcher/main/error_alram_history.htm"/>',
			type:"post",
			data:{LOGIN_DT : g_login_dt, LAST_ALARM_DT :g_last_dash_alarm_dt},
			dataType : "json",
			success: function(RES) {
				if (RES != null) {
					if(RES[0] != null) {
						if(RES[0].S_ALM_KEY == null){
							if(dashBoardA[i].NEW_ALARM == "1"){
						fn_alarm_sound();
							//fn_error_popup_open(RES.DASHBOARDALM);
							return;
							}
						}
					}
				}

			},
			error: function(res,error) {
				//alert("에러가 발생했습니다."+error);
			}
		});
		*/

//		alarmalerttimer = setTimeout("fn_chk_alarm_status()", 10000);
	}

	// 알림소리
	function fn_alarm_sound() {
		console.log("play sound fn_alarm_sound");
		var audio = new Audio(cst.contextPath() + '/common/wav/error.wav');
		audio.play();
		$('#div_alarm_sound').html('<embed src="' + cst.contextPath() + '/common/wav/error.wav' + '" hidden="true" style="display: none;">');
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