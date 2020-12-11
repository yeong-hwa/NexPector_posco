package com.nns.common.constants;

public class ChangeHistoryConstants {

	/**
	 * 1 감시장비 정보변경 
	 * 2 임계치 정보변경 
	 * 3 사용자 정보 변경 
	 * 4 알람 정보 변경 
	 * 5 사용자 메뉴 관리 
	 * 6 서버 그룹 코드 관리
	 */
	
	public static final Integer LOGIN_LOGOUT_EVEVT_TYPE = 0;
	public static final Integer MON_INFO_CHANGE_EVENT_TYPE = 1;
	public static final Integer THRESHOLD_INFO_CHANGE_EVENT_TYPE = 2;
	public static final Integer USER_INFO_CHANGE_EVENT_TYPE = 3;
	public static final Integer ALM_INFO_CHANGE_EVENT_TYPE = 4;
	public static final Integer USER_MENU_CHANGE_EVEVT_TYPE = 5;
	public static final Integer SERVER_GROUP_CODE_CHANGE_EVENT_TYPE = 6;
	
//	0	로그인/로그아웃
	public static final String LOGIN_EVENT_DATA = "로그인";
	public static final String LOGOUT_EVENT_DATA = "로그아웃";
	
//	1	감시장비 정보변경
	public static final String MON_INFO_ADD = "감시 장비 추가";
	public static final String MON_INFO_MODIFY = "감시 장비 수정";
	public static final String MON_INFO_DELETE = "감시 장비 삭제";

//  2	임계치 정보 변경
	public static final String THRESHOLD_INFO_ADD = "임계치 정보 등록";
	public static final String THRESHOLD_INFO_MODIFY = "임계치 정보 수정";
	public static final String THRESHOLD_INFO_DELETE = "임계치 정보 삭제";

//	3	사용자 정보 변경
	public static final String USER_INFO_ADD = "사용자 추가";
	public static final String USER_INFO_MODIFY = "사용자 정보 변경";
	public static final String USER_INFO_DELETE = "사용자 삭제";
	
//	4	알람 정보 변경
	public static final String ALM_INFO_ADD = "알람 정보  추가";
	public static final String ALM_INFO_MODIFY = "알람 정보 변경";
	public static final String ALM_INFO_DELETE = "알람 정보 삭제";	
	
//	5	사용자 메뉴 관리
	public static final String USER_MENU_ADD = "메뉴 추가";
	public static final String USER_MENU_DELETE = "메뉴 삭제";
	
//	6	서버 그룹 코드 관리
	public static final String SERVER_GROUP_CODE_ADD = "서버 그룹 코드 추가";
	public static final String SERVER_GROUP_CODE_MODIFY = "서버 그룹 코드 변경";
	public static final String SERVER_GROUP_CODE_DELETE = "서버 그룹 코드 삭제";
}
