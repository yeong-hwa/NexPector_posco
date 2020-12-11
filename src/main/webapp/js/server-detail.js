// Grid Header
var _txtRight = {style:'text-align:right'},
    _txtLeft = {style:'text-align:left'},
    _txtCenter = {style:'text-align:center'};

var _errorStatsColumns = [
    {field:'D_UPDATE_TIME', title:'발생시각', width:'12%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_PROCESS', title:'감시종류', width:'12%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_ALM_RATING_NAME', title:'등급', width:'12%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_ALM_STATUS_NAME', title:'상태', width:'12%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_ALM_MSG', title:'내용', width:'26%', attributes:_txtLeft, headerAttributes:_txtCenter},
    {field:'DTL_S_MSG', title:'상세내용', width:'18%', attributes:_txtLeft, headerAttributes:_txtCenter},
    {field:'', title:'복구', width:'8%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#= fn_create_alarm_history_popup_btn(S_ALM_KEY) #'}
];

var _errorHistoryColumns = [
    {field:'D_UPDATE_TIME', title:'발생시각', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_ALM_RATING_NAME', title:'등급', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_ALM_STATUS_NAME', title:'상태', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_USER_NAME', title:'처리자', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_MSG', title:'내용', width:'40%', attributes:_txtLeft, headerAttributes:_txtCenter},
];

var _phoneInfoColumns = [
    {field:'S_EXTENSION', title:'내선번호', width:'25%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_TYPE', title:'종류', width:'25%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_NAME', title:'이름', width:'25%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_PORT', title:'포트', width:'25%', attributes:_txtCenter, headerAttributes:_txtCenter}
];

var _ipPhoneInfoColumns = [
    {field:'N_GROUP', title:'그룹', width:'25%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_EXT_NUM', title:'내선번호', width:'25%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_VALUE', title:'전화기 상태', width:'25%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#= changeTextColor(N_STAT, S_VALUE) #'},
    {field:'S_MACADDRESS', title:'MAC Address', width:'25%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_IPADDRESS', title:'IP', width:'25%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_NAME', title:'Description', width:'25%', attributes:_txtCenter, headerAttributes:_txtCenter, sortable: false},
];

var _ipsiInfoColumns = [
    {field:'S_PORT', title:'Port', width:'5%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_PRILOCATION', title:'Location', width:'5%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_PRIHOST', title:'Host', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_PRIDHCPID', title:'DHCP', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_PRISRVSTATE', title:'SrvState', width:'5%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_PRICNTLSTATE', title:'CntlState', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_PRIHEALTH', title:'Health', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_SECLOCATION', title:'SubLocation', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_SECHOST', title:'SubHost', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_SECDHCPID', title:'SubDHCP', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_SECSRVSTATE', title:'SubSrvState', width:'5%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_SECCNTLSTATE', title:'SubCntlState', width:'5%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_SECHEALTH', title:'SubHealth', width:'5%', attributes:_txtCenter, headerAttributes:_txtCenter},
];

var _trunkInfoColumns = [
    {field:'S_NUM', title:'국선번호', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_TYPE', title:'국선타입', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_NAME', title:'국선명', width:'25%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_DIRECTION', title:'Direction', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_SIZE', title:'Size', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_TAC', title:'TAC', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter}
];

var _alarmInfoColumns = [
    {field:'S_PORT', title:'Port', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_INDEX', title:'Index', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_TNAME', title:'Name', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_BRD', title:'Board', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_ANAME', title:'Code', width:'5%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_TYPE', title:'Type', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_STATE', title:'State', width:'5%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_CREATED', title:'Created Date', width:'13%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_RESOLVED', title:'Resolved Date', width:'12%', attributes:_txtCenter, headerAttributes:_txtCenter}
];

var _restartInfoColumns = [
    {field:'S_DATE', title:'Date', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_LEVEL', title:'Level', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_DEMAND', title:'Demanded', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_ESCAL', title:'Escalated', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_CAUSE', title:'Cause', width:'30%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_INDEX', title:'Index', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter}
];

var _huntInfoColumns = [
    {field:'S_NUM', title:'Number', width:'25%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_NAME', title:'Name', width:'25%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_EXT', title:'Extension', width:'25%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_TYPE', title:'Type', width:'25%', attributes:_txtCenter, headerAttributes:_txtCenter}
];

var _ifInfoColumns = [
    {field:'S_DESC', title:'interface명', width:'25%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'N_MUT', title:'MTU 크기', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'N_SPEED', title:'BPS', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_PHYTS_ADDR', title:'물리 주소', width:'25%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_ADMIN_STATUS', title:'ADMIN 상태', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#= fn_change_text_color(N_ADMIN_STATUS, S_ADMIN_STATUS) #'},
    {field:'S_OPER_STATUS', title:'운영 상태', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#= fn_change_text_color(N_OPER_STATUS, S_OPER_STATUS) #'}
];

var _trapInfo = [
    {field:'START_DATE', title:'시작시각', width:'150px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'END_DATE', title:'종료시각', width:'150px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'DURATION_TIME', title:'유지시간', width:'80px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'FW_NAME', title:'방화벽', width:'80px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'FW_RULE_ID', title:'FW규칙', width:'80px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'NAT_RULE_ID', title:'NAT규칙', width:'100px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'SOURCE_IP', title:'출발IP', width:'150px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'SOURCE_PORT', title:'출발Port', width:'80px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'DESTINATION_IP', title:'도착IP', width:'150px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'DESTINATION_PORT', title:'도착Port', width:'80px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'SERVICE_PROTOCOL', title:'프로토콜', width:'80px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'NET_ZONE', title:'Net영역', width:'80px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'PACKET_COUNT', title:'패킷수', width:'60px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'BYTE_COUNT', title:'바이트수', width:'80px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'CAUSE', title:'발생이유', width:'200px', attributes:_txtLeft, headerAttributes:_txtCenter},
    {field:'REGI_DATE', title:'입력시각', width:'150px', attributes:_txtCenter, headerAttributes:_txtCenter}
];

var _ivrChannelInfo = [
    {field:'CH_NO_NAME', title:'채널', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'STATUS_NAME', title:'상태', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'EXT', title:'내선번호', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'ACD', title:'그룹', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'CALL_COUNT', title:'콜수', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'START_TIME', title:'시작시각', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'STOP_TIME', title:'종료시각', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter}
];

var _recChannelInfo = [
    {field:'CH_NO_NAME', title:'채널', width:'5%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#= fn_status_icon(STATUS, CH_NO_NAME) #'},
    {field:'STATUS_NAME', title:'상태', width:'5%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'EXT', title:'내선번호', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'ACD', title:'그룹', width:'5%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'CALL_COUNT', title:'총콜수', width:'5%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'START_TIME', title:'시작시각', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'STOP_TIME', title:'종료시각', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'ANI', title:'ANI', width:'5%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'DNIS', title:'DNIS', width:'5%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'AGENT_ID', title:'사용자번호', width:'7%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'AGENT_NAME', title:'사용자명', width:'7%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'MESSAGE', title:'메시지', width:'18%', attributes:_txtCenter, headerAttributes:_txtCenter}
];

var _snmpM02IpPhoneInfoColumns = [
    {field:'ALM_CNT', title:'경고', width:'5%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#= fn_print_icon(N_STATUS) #'},
    {field:'S_STATUS', title:'등록상태', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#= fn_change_text_color(N_STATUS, S_STATUS, null, null) #'},
    {field:'S_EXT_NO', title:'내선번호', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'ORG_NM', title:'부서명', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'EMP_NM', title:'직원명', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_IP', title:'IP', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_MAC_ADDR', title:'MAC_ADDR', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_STATUS_REASON', title:'현재상태', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#= fn_change_text_color(null, null, N_STATUS_REASON, S_STATUS_REASON) #'},
    {field:'S_DESC', title:'내용', width:'20%', attributes:_txtLeft, headerAttributes:_txtCenter, sortable: false},
];

var _extInfoColumns = [
    {field:'S_EXT_NUM', title:'내선번호', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'ORG_NM', title:'부서명', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'EMP_NM', title:'직원명', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_STATUS', title:'등록상태', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#= fn_change_text_color(N_STATUS, S_STATUS) #'},
    {field:'S_MAC_ADDR', title:'전화기 MAC_ADDR', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_ADDR', title:'전화기 IP', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter}
];

var _gatewayInfoColumns = [
    {field:'N_INDEX', title:'번호', width:'5%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_DESC', title:'장비명', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_INET_ADDR', title:'IP주소', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter, sortable: false},
    {field:'S_STATUS', title:'등록상태', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#= fn_change_text_color(N_STATUS, S_STATUS, null, null) #'},
    {field:'S_STATUS_REASON', title:'현재상태', width:'35%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#= fn_change_text_color(null, null, N_STATUS_REASON, S_STATUS_REASON) #'},
    {field:'S_PRODUCT_NAME', title:'제품명', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter}
];

var _h323InfoColumns = [
    {field:'S_NAME', title:'명칭', width:'12%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_DESC', title:'설명', width:'12%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_STATUS', title:'상태', width:'5%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_REMOTE_CM_ADDR_01', title:'REMOTE_CM_IP1', width:'12%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_REMOTE_CM_ADDR_02', title:'REMOTE_CM_IP2', width:'12%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_REMOTE_CM_ADDR_03', title:'REMOTE_CM_IP3', width:'12%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_STATUS_REASON', title:'전화기상태', width:'11%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#= fn_change_text_color(N_STATUS_REASON, S_STATUS_REASON) #'},
    {field:'D_REASON_TIME', title:'상태변경시각', width:'12%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_PRODUCT_NAME', title:'제품종류', width:'12%', attributes:_txtCenter, headerAttributes:_txtCenter}
];

var _sipInfoColumns = [
    {field:'N_INDEX', title:'번호', width:'5%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_NAME', title:'장비명', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_INET_ADDR', title:'IP주소', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_IN_PROTOCOL', title:'IN프로토콜', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'N_IN_PORT', title:'IN포트', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'N_OUT_PORT', title:'OUT포트', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_DESC', title:'설명', width:'20%', attributes:_txtLeft, headerAttributes:_txtCenter}
];

var _m03InterfaceInfoColumn = [
    {field:'S_DESC', title:'interface명', width:'150px', attributes:_txtLeft, headerAttributes:_txtCenter},
    {field:'N_MUT', title:'MTU 크기', width:'80px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'N_SPEED', title:'속도', width:'50px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_PHYS_ADDR', title:'물리 주소', width:'100px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_ADMIN_STATUS', title:'ADMIN 상태', width:'100px', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#= fn_change_text_color(N_ADMIN_STATUS, S_ADMIN_STATUS, null, null) #'},
    {field:'S_OPER_STATUS', title:'운영 상태', width:'80px', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#= fn_change_text_color(null, null, N_OPER_STATUS, S_OPER_STATUS) #'},
    {field:'S_LAST_CHANGE', title:'최종 변경', width:'150px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'N_IN_OCTETS', title:'수신 패킷', width:'80px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'N_OUT_OCTETS', title:'송신 패킷', width:'80px', attributes:_txtCenter, headerAttributes:_txtCenter}
];

var _m12InterfaceInfoColumn = [
   {field:'S_IF_DESCR', title:'interface명', width:'150px', attributes:_txtCenter, headerAttributes:_txtCenter},
   {field:'S_TYPE_NAME', title:'interface타입', width:'80px', attributes:_txtCenter, headerAttributes:_txtCenter},
   {field:'N_IF_MTU', title:'MTU', width:'50px', attributes:_txtCenter, headerAttributes:_txtCenter},
   {field:'N_IF_SPEED', title:'BPS', width:'100px', attributes:_txtCenter, headerAttributes:_txtCenter},
   {field:'S_IF_PHYS_ADDRESS', title:'물리 주소', width:'100px', attributes:_txtCenter, headerAttributes:_txtCenter},
   {field:'S_ADMIN_STATUS', title:'ADMIN 상태', width:'80px', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#= fn_change_text_color(N_IF_ADMIN_STATUS, S_ADMIN_STATUS, null, null) #'},
   {field:'S_OPER_STATUS', title:'운영 상태', width:'150px', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#= fn_change_text_color(null, null, N_IF_OPER_STATUS, S_OPER_STATUS) #'}                               
];

var _m03PriInterfaceInfoColumn = [
    {field:'S_DESC', title:'설명', width:'150px', attributes:_txtLeft, headerAttributes:_txtCenter},
    {field:'N_TOTAL', title:'전체', width:'80px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'N_E1_CNT_IDLE', title:'대기', width:'50px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'N_E1_CNT_ACTIVE', title:'통화중', width:'80px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_ADMIN_STATUS', title:'ADMIN 상태', width:'100px', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#= fn_change_text_color(N_ADMIN_STATUS, S_ADMIN_STATUS, null, null) #'},
    {field:'S_OPER_STATUS', title:'운영 상태', width:'100px', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#= fn_change_text_color(null, null, N_OPER_STATUS, S_OPER_STATUS) #'},
    {field:'S_LAST_CHANGE', title:'최종 변경', width:'150px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'N_MTU', title:'MTU 크기', width:'80px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'N_SPEED', title:'속도', width:'80px', attributes:_txtCenter, headerAttributes:_txtCenter}
];

var _m03DspInfoColumn = [
    {field:'S_OPER_STATE', title:'운영상태', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'N_ALARMS', title:'알람 개수', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_LAST_ALM_CAUSE', title:'Last 알람 원인', width:'20%', attributes:_txtLeft, headerAttributes:_txtCenter},
    {field:'S_LAST_ALM_CAUSE_TXT', title:'Last 알람 메시지', width:'20%', attributes:_txtLeft, headerAttributes:_txtCenter},
    {field:'D_LAST_ALM_TIME', title:'Last 알람 시각', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'N_TOTAL_CH', title:'TOTAL 채널', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'N_IN_USE_CH', title:'INUSE 채널', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'N_ACTIVE_CH', title:'Active 채널', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter}
];

var _vaInterfaceInfoColumn = [
    {field:'S_DESC', title:'명칭', width:'20%', attributes:_txtLeft, headerAttributes:_txtCenter},
    {field:'S_TEL_NUM', title:'전화번호', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_NAME', title:'지점명', width:'20%', attributes:_txtLeft, headerAttributes:_txtCenter},
    {field:'S_ADMIN_STATUS', title:'연결상태', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#= fn_change_text_color(N_ADMIN_STATUS, S_ADMIN_STATUS) #'},
    {field:'S_OPER_STATUS', title:'통화상태', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_TYPE', title:'타입', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'N_ERROS', title:'에러 수', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter}
];

var _dbStatusInfoColumn = [
	{field:'DBNAME'			,title:'DB명'				,width:'20%', attributes:_txtLeft, headerAttributes:_txtCenter},
	{field:'TYPE_NAME'		,title:'Type'				,width:'20%', attributes:_txtLeft, headerAttributes:_txtCenter},
	{field:'DB_STATE'		,title:'상태'				,width:'20%', attributes:_txtLeft, headerAttributes:_txtCenter},
	{field:'CONNECTION'		,title:'Connection'			,width:'20%', attributes:_txtLeft, headerAttributes:_txtCenter},
	{field:'TABLESPACEMAX'	,title:'TableSpace(MAX)'	,width:'20%', attributes:_txtLeft, headerAttributes:_txtCenter},
	{field:'TABLESPACECUR'	,title:'TableSpace(현재)'	,width:'20%', attributes:_txtLeft, headerAttributes:_txtCenter},
	{field:'TABLESPACE'		,title:'TableSpace'			,width:'20%', attributes:_txtLeft, headerAttributes:_txtCenter},
	
];

var kendoGridColumns = function() {
    return {
        errorStats : function() {
            return _errorStatsColumns;
        },
        errorHistory : function() {
            return _errorHistoryColumns;
        },
        phoneInfo : function() {
            return _phoneInfoColumns;
        },
        ipPhoneInfo : function() {
            return _ipPhoneInfoColumns;
        },
        ipsiInfo : function() {
            return _ipsiInfoColumns;
        },
        trunkInfo : function() {
            return _trunkInfoColumns;
        },
        alarmInfo : function() {
            return _alarmInfoColumns;
        },
        restartInfo : function() {
            return _restartInfoColumns;
        },
        huntInfo : function() {
            return _huntInfoColumns;
        },
        ifInfo : function() {
            return _ifInfoColumns;
        },
        trapInfo : function() {
            return _trapInfo;
        },
        ivrChannelInfo : function() {
            return _ivrChannelInfo;
        },
        recChannelInfo : function() {
            return _recChannelInfo;
        },
        snmpM02IpPhoneInfo : function() {
            return _snmpM02IpPhoneInfoColumns;
        },
        extInfo : function() {
            return _extInfoColumns;
        },
        gatewayInfo : function() {
            return _gatewayInfoColumns;
        },
        h323Info : function() {
            return _h323InfoColumns;
        },
        sipInfo : function() {
            return _sipInfoColumns;
        },
        m03InterfaceInfo : function() {
            return _m03InterfaceInfoColumn;
        },
        m12InterfaceInfo : function() {
            return _m12InterfaceInfoColumn;
        },
        m03PriInterfaceInfo : function() {
            return _m03PriInterfaceInfoColumn;
        },
        m03DspInfo : function() {
            return _m03DspInfoColumn;
        },
        vaInterfaceInfo : function() {
            return _vaInterfaceInfoColumn;
        },
        dbStatusInfo : function() {
        	return _dbStatusInfoColumn;
        }
    }
}