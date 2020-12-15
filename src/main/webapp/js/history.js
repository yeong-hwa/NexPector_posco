// Grid Header
var _txtRight = {style:'text-align:right'},
    _txtLeft = {style:'text-align:left'},
    _txtCenter = {style:'text-align:center'};

var _timeCommonColumns = [
    {field:'TIME_00', title:'0', width:'3%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=$.defaultStr(data.TIME_00, 0)#'},
    {field:'TIME_01', title:'1', width:'3%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=$.defaultStr(data.TIME_01, 0)#'},
    {field:'TIME_02', title:'2', width:'3%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=$.defaultStr(data.TIME_02, 0)#'},
    {field:'TIME_03', title:'3', width:'3%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=$.defaultStr(data.TIME_03, 0)#'},
    {field:'TIME_04', title:'4', width:'3%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=$.defaultStr(data.TIME_04, 0)#'},
    {field:'TIME_05', title:'5', width:'3%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=$.defaultStr(data.TIME_05, 0)#'},
    {field:'TIME_06', title:'6', width:'3%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=$.defaultStr(data.TIME_06, 0)#'},
    {field:'TIME_07', title:'7', width:'3%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=$.defaultStr(data.TIME_07, 0)#'},
    {field:'TIME_08', title:'8', width:'3%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=$.defaultStr(data.TIME_08, 0)#'},
    {field:'TIME_09', title:'9', width:'3%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=$.defaultStr(data.TIME_09, 0)#'},
    {field:'TIME_10', title:'10', width:'3%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=$.defaultStr(data.TIME_10, 0)#'},
    {field:'TIME_11', title:'11', width:'3%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=$.defaultStr(data.TIME_11, 0)#'},
    {field:'TIME_12', title:'12', width:'3%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=$.defaultStr(data.TIME_12, 0)#'},
    {field:'TIME_13', title:'13', width:'3%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=$.defaultStr(data.TIME_13, 0)#'},
    {field:'TIME_14', title:'14', width:'3%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=$.defaultStr(data.TIME_14, 0)#'},
    {field:'TIME_15', title:'15', width:'3%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=$.defaultStr(data.TIME_15, 0)#'},
    {field:'TIME_16', title:'16', width:'3%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=$.defaultStr(data.TIME_16, 0)#'},
    {field:'TIME_17', title:'17', width:'3%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=$.defaultStr(data.TIME_17, 0)#'},
    {field:'TIME_18', title:'18', width:'3%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=$.defaultStr(data.TIME_18, 0)#'},
    {field:'TIME_19', title:'19', width:'3%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=$.defaultStr(data.TIME_19, 0)#'},
    {field:'TIME_20', title:'20', width:'3%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=$.defaultStr(data.TIME_20, 0)#'},
    {field:'TIME_21', title:'21', width:'3%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=$.defaultStr(data.TIME_21, 0)#'},
    {field:'TIME_22', title:'22', width:'3%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=$.defaultStr(data.TIME_22, 0)#'},
    {field:'TIME_23', title:'23', width:'3%', attributes:_txtRight, headerAttributes:_txtCenter, template:'#=$.defaultStr(data.TIME_23, 0)#'}
];

var _resourceColumns = [
	{field:'N_DAY', title:'날짜', width:'8%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_BASE_NAME', title:'장비명', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_TYPE_NAME', title:'자원', width:'5%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_DATA_NAME', title:'구분', width:'5%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_MON_NAME', title:'비고', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter}
];

var _processColumns = [
    {field:'S_BASE_NAME', title:'항목/시각', width:'25%', attributes:_txtCenter, headerAttributes:_txtCenter}
];

var _serviceColumns = [
     {field:'BRANCH_NAME', title:'부서명', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
     {field:'S_TYPE', title:'구분', width:'8%', attributes:_txtCenter, headerAttributes:_txtCenter}
];

var _errorColumns = [
    {field:'D_UPDATE_TIME', title:'발생시각', width:'120px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_MON_NAME', title:'장비명', width:'120px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_MON_IP', title:'장비IP', width:'120px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_ALM_RATING_NAME', title:'장애등급', width:'120px', attributes:_txtCenter, headerAttributes:_txtCenter, /* template:'#=fn_change_alm_rating_background_color(N_ALM_RATING, S_ALM_RATING_NAME)#' */},
    {field:'N_ALM_STATUS_NAME', title:'상태', width:'80px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_USER_ID', title:'처리자ID / 명', width:'100px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_MSG', title:'내용', width:'200px', attributes:_txtLeft, headerAttributes:_txtCenter}
];

var _alarmColumns = [
     {field:'D_SEND_TIME', title:'전송시각', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
     {field:'S_MON_NAME', title:'장비명', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
     {field:'S_ALM_RATING_NAME', title:'장애등급', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#=fn_change_alm_rating_background_color(N_ALM_RATING, S_ALM_RATING_NAME)#'},
     {field:'N_SEND_CODE', title:'상태', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
     {field:'S_USER_ID', title:'수신자ID', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
     {field:'S_USER_NAME', title:'수신자', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
     {field:'S_SEND_VALUE', title:'전송내용', width:'30%', attributes:_txtLeft, headerAttributes:_txtCenter}
];

var _callUseStateColumns = [
    {field:'N_STATE_CODE', title:'상태', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#=getCallStateDescription(N_STATE_CODE)#'},
    {field:'ORG_NM', title:'부서', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'EMP_NM', title:'사용자', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_ADDRESS', title:'내선번호', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_SEND_ADDRESS', title:'대상번호', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_EVENT_TIME', title:'업데이트 시간', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter}
];

var _callDeptUseStateColumns = [
    {field:'GROUP_NAME', title:'부서명', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter}
    ,{field:'WAITING', title:'대기중', width:'7%', attributes:_txtCenter, headerAttributes:_txtCenter}
    ,{field:'CONNECTING', title:'전화연결중', width:'7%', attributes:_txtCenter, headerAttributes:_txtCenter}
    ,{field:'CALLING', title:'통화중', width:'7%', attributes:_txtCenter, headerAttributes:_txtCenter}
    ,{field:'DISCONNECT', title:'연결안됨', width:'7%', attributes:_txtCenter, headerAttributes:_txtCenter}
    ,{field:'IN_CALL', title:'내선', width:'7%', attributes:_txtCenter, headerAttributes:_txtCenter}
    ,{field:'LOCAL_CALL', title:'시내/시외', width:'7%', attributes:_txtCenter, headerAttributes:_txtCenter}
    ,{field:'INTER_CALL', title:'국제', width:'7%', attributes:_txtCenter, headerAttributes:_txtCenter}
    ,{field:'MOB_CALL', title:'핸드폰', width:'7%', attributes:_txtCenter, headerAttributes:_txtCenter}
    ,{field:'ETC_CALL', title:'기타', width:'7%', attributes:_txtCenter, headerAttributes:_txtCenter}
];

var _inCallUseStateColumns = [
    {field:'GROUP_NAME', title:'부서', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'EMP_NAME', title:'사용자', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'LINE_NO', title:'내선번호', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'N_STATE_NAME', title:'상태', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'N_CALL_NAME', title:'분류', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_SEND_ADDRESS', title:'대상번호', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_EVENT_TIME', title:'업데이트 시간', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter}
];

var _dayReportServerColumns = [
    {field:'S_MON_NAME', title:'서버명', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_MON_IP', title:'IP Address', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'CPU', title:'CPU(평균/최대)', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'MEM', title:'Memory(평균/최대)', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'DISK', title:'Disk(평균/최대)', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter}
];

var _dayReportCallColumns = [
	{field:'BRANCH_NAME', title:'부서명', width:'34%', attributes:_txtCenter, headerAttributes:_txtCenter},
	{field:'INBOUND', title:'Inbound', width:'33%', attributes:_txtCenter, headerAttributes:_txtCenter},
	{field:'OUTBOUND', title:'Outbound', width:'33%', attributes:_txtCenter, headerAttributes:_txtCenter}
];

var _iptHistoryColumns = [
    {field:'S_MON_NAME', title:'장비명', width:'13%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_MON_IP', title:'장비IP', width:'13%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'N_DEVICE_NAME', title:'IPT NAME', width:'13%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_MAC_ADDRESS', title:'MAC', width:'13%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_IPADDRESS', title:'IP ADDRESS', width:'13%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'N_TYPE_NM', title:'상태', width:'8%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'D_ACTIVE_TIME', title:'마지막 동작 일시', width:'13%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'D_UPDATE_TIME', title:'변경일시', width:'13%', attributes:_txtCenter, headerAttributes:_txtCenter}
];

var kendoGridColumns = function() {
    return {
        resource : function() {
            return _resourceColumns.concat(_timeCommonColumns);
        },
        process : function() {
            return _processColumns.concat(_timeCommonColumns);
        },
        service : function() {
            return _serviceColumns.concat(_timeCommonColumns);
        },
        error : function() {
            return _errorColumns;
        },
        alarm : function() {
            return _alarmColumns;
        },
        callUseState : function() {
            return _callUseStateColumns;
        },
        callDeptUseState : function() {
            return _callDeptUseStateColumns;
        },
        iptHistory : function() {
            return _iptHistoryColumns;
        },
        inCallUseState : function() {
            return _inCallUseStateColumns;
        },
        dayReportServer : function() {
            return _dayReportServerColumns;
        },
        dayReportCall : function() {
            return _dayReportCallColumns;
        }
    }
}