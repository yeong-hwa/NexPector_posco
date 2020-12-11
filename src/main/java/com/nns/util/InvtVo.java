/**========================================================
 * Filename : InvtVo.java
 * Function : 엑셀 파일 다운로드 
 * Comment  :
 * Version  : 1.0
 =========================================================*/

package com.nns.util;

public class InvtVo {
	
	private String N_MON_ID = "";				// 교환기ID
	private String N_MON_NAME = "";			// 교환기명
	private String S_IPADDRESS = "";			// 전화기IP
	private String S_EXT_NUM = "";				// 내선번호
	private String S_NAME = "";					// 사용자 정보
	private String S_COMMUNITY = "";			// SNMP Community
	private String N_SNMP_VER = "";			// SNMP 버전
	private String N_PORT = "";					// 포트
	private String S_TYPE = "";					// 전화기 타입
	private String N_GROUP = "";				// 그룹코드
	private String N_GROUP_NAME = "";		// 그룹명
	
	public InvtVo() {
    }

	public String getN_MON_ID() {
		return N_MON_ID;
	}

	public void setN_MON_ID(String n_MON_ID) {
		N_MON_ID = n_MON_ID;
	}

	public String getN_MON_NAME() {
		return N_MON_NAME;
	}

	public void setN_MON_NAME(String n_MON_NAME) {
		N_MON_NAME = n_MON_NAME;
	}

	public String getS_IPADDRESS() {
		return S_IPADDRESS;
	}

	public void setS_IPADDRESS(String s_IPADDRESS) {
		S_IPADDRESS = s_IPADDRESS;
	}

	public String getS_EXT_NUM() {
		return S_EXT_NUM;
	}

	public void setS_EXT_NUM(String s_EXT_NUM) {
		S_EXT_NUM = s_EXT_NUM;
	}

	public String getS_NAME() {
		return S_NAME;
	}

	public void setS_NAME(String s_NAME) {
		S_NAME = s_NAME;
	}

	public String getS_COMMUNITY() {
		return S_COMMUNITY;
	}

	public void setS_COMMUNITY(String s_COMMUNITY) {
		S_COMMUNITY = s_COMMUNITY;
	}

	public String getN_SNMP_VER() {
		return N_SNMP_VER;
	}

	public void setN_SNMP_VER(String n_SNMP_VER) {
		N_SNMP_VER = n_SNMP_VER;
	}

	public String getN_PORT() {
		return N_PORT;
	}

	public void setN_PORT(String n_PORT) {
		N_PORT = n_PORT;
	}

	public String getS_TYPE() {
		return S_TYPE;
	}

	public void setS_TYPE(String s_TYPE) {
		S_TYPE = s_TYPE;
	}

	public String getN_GROUP() {
		return N_GROUP;
	}

	public void setN_GROUP(String n_GROUP) {
		N_GROUP = n_GROUP;
	}

	public String getN_GROUP_NAME() {
		return N_GROUP_NAME;
	}

	public void setN_GROUP_NAME(String n_GROUP_NAME) {
		N_GROUP_NAME = n_GROUP_NAME;
	}
}