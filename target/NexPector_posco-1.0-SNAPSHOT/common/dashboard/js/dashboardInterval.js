/**
 * Created by bskim on 2016-11-23.
 */

var originInterval = {
    RELOAD: 5,
    // PAGE_MOVE: 30,
    URL:''
};
var defaultInterval = 1000;
var reloadTimeout;
// var pageMoveTimeout;

function intervalInit() {
    $('#intervalSet').click(function(e) {
        var elem = $(this);
        originInterval.RELOAD = $('#reload_interval').val();
        // originInterval.PAGE_MOVE = $('#pagemove_interval').val();
        originInterval.URL = $('#interval_url').val();

/*        if ($('#intervalPop').css('display') == 'block') {
            $('#intervalPop').css('display', 'none');
            fn_intervalSetting(originInterval.RELOAD);
            return false;
        }
*/      
        // fn_interval_set_popup_open(elem);
        openIntervalPopup();
        fn_clearIntervalSetting();
    });

    $('#btn_user_info_modify').click(function(e) {
    	setIntervalModifyBtn();
    });

/*    $('#reload_interval').keyup(function(e) {
        if ($('#alm_reload_interval').css('display') == 'block') {
            $('#alm_reload_interval').css('display', 'none');
        }
    });

    $('#pagemove_interval').keyup(function(e) {
        if ($('#alm_pagemove_interval').css('display') == 'block') {
            $('#alm_pagemove_interval').css('display', 'none');
        }
    });*/
}

function setIntervalModifyBtn() {
    var reload_interval = $('#reload_interval').val();
    // pagemove_interval = $('#pagemove_interval').val(),
    var interval_url = $('#interval_url').val();

    if (reload_interval < 5) {
    	alert('5~600(초) 사이의 값을 넣어주세요');
    	return false;
    }
	/*
	       if (pagemove_interval < 30) {
	        $('#alm_pagemove_interval').css('display', 'block');
	        $('#alm_pagemove_interval').text('30~6000(초) 사이의 값을 넣어주세요')
	    }
	*/
	
	originInterval.RELOAD = reload_interval;
	//originInterval.PAGE_MOVE = pagemove_interval;
	originInterval.URL = interval_url;
	
	$.post('/dashboard/interval/change.htm', originInterval)
	.done(function(data) {
        //console.log(data);
        // closeIntervalSetPopup('intervalPop');
		closeIntervalPopup();
	});
}

function openIntervalPopup() {
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

function closeIntervalPopup() {
	$('#myModal_small').dialog( "close" );
	$('#reload_interval').val(originInterval.RELOAD);
    fn_intervalSetting(originInterval.RELOAD);
}

/*//레이어 팝업 닫기
function closeIntervalSetPopup(id){
    var pop = document.getElementById(id);
    pop.style.display = "none";
    fn_intervalSetting(originInterval.RELOAD, originInterval.PAGE_MOVE);
}*/

// interval setting
function setIntervalInfo(RES) {
	// console.log('intervalInfo:', RES.INTERVAL_INFO);
    if (RES.INTERVAL_INFO != null && RES.INTERVAL_INFO.length > 0) {
        var intervalArr = new Array();
        var intervalTime; 
        // var intervalPageMoveTime;
        intervalArr = RES.INTERVAL_INFO;
        for(i=0; i < intervalArr.length; i++){
            if (intervalArr[i].N_INTERVAL_TYPE == 0) {
                intervalTime = intervalArr[i].N_INTERVAL_TIME;
                $('#reload_interval').val(intervalArr[i].N_INTERVAL_TIME)
            }

/*            if (intervalArr[i].N_INTERVAL_TYPE == 1) {
                intervalPageMoveTime = intervalArr[i].N_INTERVAL_TIME;
                $('#pagemove_interval').val(intervalArr[i].N_INTERVAL_TIME);
            }*/
        }
        fn_intervalSetting(intervalTime);
    } else {
        $('#reload_interval').val(originInterval.RELOAD)
        // $('#pagemove_interval').val(originInterval.PAGE_MOVE);
        fn_intervalSetting(originInterval.RELOAD);
    }

}

/*function fn_interval_set_popup_open (elem) {

    var pop = document.getElementById("intervalPop");
    var popWidth = ($('#content_wrap').width()*-1)/2;
    pop.style.display = "block";
    pop.style.marginRight = popWidth+"px";

    //pop.style.left = 1880 - 405 + "px";
    pop.style.top = elem.context.offsetTop + "px";
     pop.style.left = elem.context.offsetLeft - 200 + "px";
}*/

//레이어 팝업 닫기
/*function closeIntervalSetPopup(id){
    var pop = document.getElementById(id);
    pop.style.display = "none";
    fn_intervalSetting(originInterval.RELOAD, originInterval.PAGE_MOVE);
}*/

function fn_intervalSetting(intervalTime, intervalPageMoveTime) {
	//console.log(intervalTime + ' : ' + new Date());
    // reloadTimeout setTimeout 중복 방지
	if( !reloadTimeout ) reloadTimeout = setTimeout("fn_search()", intervalTime * defaultInterval);
    // pageMoveTimeout setTimeout 중복 방지
	// if( !pageMoveTimeout ) pageMoveTimeout = setTimeout("fn_pagemove()", intervalPageMoveTime * defaultInterval);
}

function fn_clearReloadIntervalSetting(){
	if( reloadTimeout ){
		clearTimeout(reloadTimeout);
		reloadTimeout = null;
	}
}

/*function fn_clearPageMoveIntervalSetting(){
	if( pageMoveTimeout ){
		clearTimeout(pageMoveTimeout);
		pageMoveTimeout = null;
	}
}*/

function fn_clearIntervalSetting() {
	fn_clearReloadIntervalSetting();
	// fn_clearPageMoveIntervalSetting();
}