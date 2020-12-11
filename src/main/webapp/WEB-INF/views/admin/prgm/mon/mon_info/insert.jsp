<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>감시장비 정보 등록</h2><span>Home &gt; 감시장비 관리 &gt; 감시장비 정보 등록</span></div></div>

<form id="mon_insert_form" name="mon_insert_form" data-role="validator">
<input type="hidden" id="mon_info_delete_list" name="MON_INFO_DELETE_LIST" value=""/>
	<div style="float: left;margin-bottom: 5px;">
		<a href="#" id="btn_list" class="css_btn_class">목록</a>
	</div>
	<!-- manager_contBox1 -->
	<div class="manager_contBox1">
		<!-- 사용자등록 -->
		<div class="table_typ2-5">
			<table summary="" cellpadding="0" cellspacing="0">
				<caption></caption>
				<colgroup>
					<col width="15%" />
					<col width="35%" />
					<col width="15%" />
					<col width="35%" />
				</colgroup>
				<tr>
					<td class="filed_A left">장비타입</td>
					<td class="filed_B left">
		            	<select id="N_TYPE_CODE" name="N_TYPE_CODE">
		            		<option value="">선택</option>
		            	</select>
		            	<script>
		            		$(function(){
		            			$("select[name='N_TYPE_CODE']").change(function(){
		            				if($("select[name='N_TYPE_CODE'] option:selected").val() == '1000')
		            				{
		            					$("select[name='S_CM_TYPE']").val("");
		            					$("#cmb_cm_type").show();
		            				}
		            				else
		            				{
		            					$("select[name='S_CM_TYPE']").val("");
		            					$("#cmb_cm_type").hide();
		            				}
		            				fn_maxMonId_value($("#N_TYPE_CODE").val());
		            			});
		            		});
		            	</script>
		            	<span id="cmb_cm_type" style="display:none;">
		            		<SELECT name="S_CM_TYPE" id="S_CM_TYPE">
		            			<option value="">선택</option>
		            			<option value="Call서버">Call서버</option>
		            			<option value="기타">기타</option>
		            		</SELECT>
		            	</span>
					</td>				
					<td class="filed_A left">장비ID</td>
					<td class="filed_B left">
						<input type="text" name="N_MON_ID" id="N_MON_ID" value=""  maxlength="10" class="manaint_f dupl_chk" placeholder="장비ID(숫자만입력)"/>
		            	<input type="hidden" name="chk_val" value="">
		            	<font id="msg" color="red"></font>
					</td>
				</tr>
				<tr>
					<td class="filed_A left">장비명</td>
					<td class="filed_B left">
						<input type="text" name="S_MON_NAME" id="S_MON_NAME" value=""  maxlength="30" class="manaint_f" placeholder="장비명"/>
					</td>
					<td class="filed_A left">장비IP</td>
					<td class="filed_B left">
						<input type="text" name="S_MON_IP" id="S_MON_IP" value=""  maxlength="15" class="manaint_f" placeholder="장비IP(127.0.0.1)"/>
					</td>
				</tr>

				<tr id="rack_info1" style="display: none;">
					<td class="filed_A left">장비 타입</td>
					<td class="filed_B left">
						<select id="N_DASHBOARD_MON_TYPE" name="N_DASHBOARD_MON_TYPE">
							<option value="">선택</option>
						</select>
					</td>
					<td class="filed_A left">랙(Rack) 이름</td>
					<td class="filed_B left">
						<select id="N_RACK_ID" name="N_RACK_ID">
							<option value="">선택</option>
						</select>
					</td>
				</tr>

				<tr id="rack_info2" style="display: none;">
					<td class="filed_A left">랙(Rack) 위치</td>
					<td class="filed_B left">
						<input type="text" name="N_RACK_LOCATION" id="N_RACK_LOCATION" value="" maxlength="2" class="manaint_f"/>
					</td>
					
					
					<td class="filed_A left">랙(Rack) 유닛</td>
					<td class="filed_B left">
						<input type="text" name="N_RACK_UNIT" id="N_RACK_UNIT" value="" maxlength="2" class="manaint_f"/>
					</td>
				</tr>

				<tr>
					<td class="filed_A left">그룹명</td>
					<td class="filed_B left">
						<select id="N_GROUP_CODE" name="N_GROUP_CODE">
							<option value="">선택</option>
						</select>
					</td>
					<td class="filed_A left">감시타입</td>
					<td class="filed_B left">
		            	<cmb:combo qryname="cmb_svr_style" seltagname="N_STYLE_CODE" firstdata="선택" etc="id=\"N_STYLE_CODE\" onchange=\"fn_svr_style_change(this.value);\""/>
					</td>
				</tr>
				
				<tr>
					<td class="filed_A left">호스트명</td>
					<td class="filed_B left">
						<input type="text" name="S_HOST" id="S_HOST" value="" class="manaint_f" style="width:90%;" placeholder="호스트명"/>
					</td>
					<td class="filed_A left">Dashboard Link ID</td>
					<td class="filed_B left"><input type="text" name="S_DASHBOARD_LINKID" id="S_DASHBOARD_LINKID" style="width:150px;" value=""></td>
				</tr>
				<tr>
					<td class="filed_A left">설명</td>
					<td class="filed_B left">
						<input type="text" name="S_DESC" id="S_DESC" value="" class="manaint_f" style="width:90%;" placeholder="설명"/>
					</td>
					<td class="filed_A left"></td>
					<td class="filed_B left"></td>
				</tr>					
			</table>

			<div id="snmp_info" style="display: none;">
				<table summary="" cellpadding="0" cellspacing="0">
					<caption></caption>
					<colgroup>
						<col width="15%" />
						<col width="35%" />
						<col width="15%" />
						<col width="35%" />
					</colgroup>

					<tr>
						<td class="filed_A left">SNMP장비</td>
						<td class="filed_B left"><cmb:combo qryname="cmb_snmp_man_code" seltagname="N_SNMP_MAN_CODE" firstdata="선택"/></td>

						<td class="filed_A left">SNMP Port</td>
						<td class="filed_B left"><input type="text" name="N_SNMP_PORT" id="N_SNMP_PORT" class="넌숫자만" style="width:150px;" value="" placeholder="포트 번호 (기본 161)"></td>
					</tr>
					<tr>
						<td class="filed_A left">SNMP Version</td>
						<td class="filed_B left">
							<script>
								$(function(){
									$("select[name='N_SNMP_VERSION']").change(function(){
										if($("select[name='N_SNMP_VERSION'] option:selected").val() == '3') {
											$("#snmpv3_info").show("fast");
											$("#snmp_comunity1").hide();
											$("#snmp_comunity2").hide();
										}
										else {
											$("#snmpv3_info").hide("fast");
											$("#snmp_comunity1").show();
											$("#snmp_comunity2").show();
										}
									});

								});
							</script>
							<span id="cmb_ver_type" >
								<SELECT name="N_SNMP_VERSION">
									<option value="">선택</option>
									<option value="1">v1</option>
									<option value="2">v2</option>
									<option value="3">v3</option>
								</SELECT>
							</span>
						</td>

						<td class="filed_A left" id="snmp_comunity1">SNMP Community</td>
						<td class="filed_B left" id="snmp_comunity2"><input type="text" name="S_SNMP_COMMUNITY" id="S_SNMP_COMMUNITY" style="width:150px;" value="" placeholder="public or private"></td>
					</tr>
				</table>
			</div>

			<!-- snmp v3 security info start 2015.04.21 -->
			<div id="snmpv3_info" style="display: none;">
				<table summary="" cellpadding="0" cellspacing="0">
					<caption></caption>
					<colgroup>
						<col width="15%" />
						<col width="35%" />
						<col width="15%" />
						<col width="35%" />
					</colgroup>
					<tr>
						<td class="filed_A left">Security Name</td>
						<td class="filed_B left"><input type="text" id="S_SECURITY_NAME" name="S_SECURITY_NAME" style="width:150px;" value=""></td>

						<td class="filed_A left">인증 암호화</td>
						<td class="filed_B left">
							<script>
								$(function(){
									$("select[name='N_AUTH_CODE']").change(function(){
										if($("select[name='N_AUTH_CODE'] option:selected").val() == '0') {
											$("#S_AUTH_PASS").val("");
											$("#S_AUTH_PASS").attr("placeholder", "입력할 수 없음");
											$("#S_AUTH_PASS").prop("readonly", true);
										} else {
											$("#S_AUTH_PASS").attr("placeholder", "인증 비빌번호");
											$("#S_AUTH_PASS").prop("readonly", false);
										}
									});
			
								});
							</script>
							<input type="text" id="S_AUTH_PASS" name="S_AUTH_PASS" style="width:150px;" value="" placeholder="인증 비빌번호">
							<cmb:combo qryname="cmb_auth_code" seltagname="N_AUTH_CODE" firstdata="선택"/>
						</td>
					</tr>
					<tr>
						<td class="filed_A left">사설 암호화</td>
						<td class="filed_B left">
							<script>
								$(function(){
									$("select[name='N_PRIV_CODE']").change(function(){
										if($("select[name='N_PRIV_CODE'] option:selected").val() == '0') {
											$("#S_PRIV_PASS").val("");
											$("#S_PRIV_PASS").attr("placeholder", "입력할 수 없음");
											$("#S_PRIV_PASS").prop("readonly", true);
										} else {
											$("#S_PRIV_PASS").attr("placeholder", "데이터 비빌번호");
											$("#S_PRIV_PASS").prop("readonly", false);
										}
									});
			
								});
							</script>
							<input type="text" id="S_PRIV_PASS" name="S_PRIV_PASS" style="width:150px;" value="" placeholder="데이터 비빌번호">
							<cmb:combo qryname="cmb_priv_code" seltagname="N_PRIV_CODE" firstdata="선택"/>
						</td>

						<td class="filed_A left">엔진 ID</td>
						<td class="filed_B left"><input type="text" name="S_ENGINE_ID" id="S_ENGINE_ID" style="width:150px;" value="" placeholder="최대 24자리 값"></td>
					</tr>
				</table>
			</div>
			<!-- snmp v3 security info end 2015.04.21 -->
			
			<div id="icmp_info" style="display: none;">
				<table summary="" cellpadding="0" cellspacing="0">
					<caption></caption>
					<colgroup>
						<col width="15%" />
						<col width="35%" />
						<col width="15%" />
						<col width="35%" />
					</colgroup>
					<tr>
						<td class="filed_A left">ICMP 명칭</td>
						<td class="filed_B left"><input type="text" name="S_ICMP_NAME" id="S_ICMP_NAME" style="width:150px;" value=""></td>

						<td class="filed_A left">체크주기(초)</td>
						<td class="filed_B left"><input type="text" name="N_CHECK_TIME" id="N_CHECK_TIME" class="넌숫자만" style="width:150px;" value=""></td>
					</tr>
					<tr>
						<td class="filed_A left">응답시간(ms)</td>
						<td class="filed_B left"><input type="text" name="N_RES_TIME" id="N_RES_TIME" class="넌숫자만" style="width:150px;" value=""></td>

						<td class="filed_A left">TimeOut(ms)</td>
						<td class="filed_B left"><input type="text" name="N_TIME_OUT" id="N_TIME_OUT" class="넌숫자만" style="width:150px;" value=""></td>
					</tr>
					<tr>
						<td class="filed_A left">장애인식카운트</td>
						<td class="filed_B left"><input type="text" name="N_ALM_CNT" id="N_ALM_CNT" class="넌숫자만" style="width:150px;" value=""></td>

						<td class="filed_A left">장애등급</td>
						<td class="filed_B left"><cmb:combo qryname="cmb_alm_rating" seltagname="N_ALM_RAT"/></td>
					</tr>
				</table>
			</div>

			<!-- botton -->
			<div id="botton_align_center1">
				<a href="#" id="btn_save" class="css_btn_class">저장</a>&nbsp;&nbsp;&nbsp;
				<a href="#" id="btn_cancel" class="css_btn_class">취소</a>&nbsp;&nbsp;&nbsp;
				<c:if test="${param.updateFlag == 'U'}">
					<a href="#" id="btn_remove" class="css_btn_class3">삭제</a>
				</c:if>
			</div>
			<!-- botton // -->
		</div>
	</div>
	<!-- manager_contBox1 // -->
	<input type="hidden" name="N_MENU_CODE" id="N_MENU_CODE" value="${param.N_MENU_CODE}"/>
	<input type="hidden" name="updateFlag" value="${param.updateFlag}"/>
	<input type="hidden" id="N_URL_TEMP" name="N_URL_TEMP" >
</form>

<form id="go_list_form" method="get">
	<input type="hidden" name="searchParam" value="${param.searchParam}"/>
</form>

<script>

	$(document).ready(function() {
		cfn_makecombo_opt($("#N_GROUP_CODE"), "<c:url value="/admin/lst_common.cmb_svr_group.htm"/>");
		cfn_makecombo_opt($("#N_TYPE_CODE"), "<c:url value="/admin/lst_common.cmb_svr_type.htm"/>");
		cfn_makecombo_opt($("#N_DASHBOARD_MON_TYPE"), "<c:url value="/admin/lst_common.cmb_dashboard_mon_type.htm"/>");
		
		$("#mon_insert_form").kendoValidator().data("kendoValidator");
	
		initEvent();
	
		// 수정 페이지
		if ('U' === '${param.updateFlag}') {
			// 수정시에는 ID 입력 불가로 변경
			var $userIdWrap = $('#N_MON_ID').parent();
			$userIdWrap
				.empty()
				.append('<span id="N_MON_ID">${param.N_MON_ID}</span>')
				.append('<input type="hidden" name="N_MON_ID" value="${param.N_MON_ID}"/>');
	
			detailInfoDataSetting('${param.N_MON_ID}');
		}
	});

	function detailInfoDataSetting(monId) {
		
		$("form[name='mon_insert_form'] input[name='N_MON_ID']").attr("readonly", true);
		var param = {'N_MON_ID'	: monId};
		$.getJSON("<c:url value='/admin/map_mon_info.detail_info.htm'/>", param, function(data){
			$("form[name='mon_insert_form'] input[type='text'], form[name='mon_insert_form'] input[type='password']").each(function(){
				var tmp_input_name = $(this).attr("name");
				$("form[name='mon_insert_form'] input[name='"+tmp_input_name+"']").val(eval("data."+tmp_input_name));
			});
			$("form[name='mon_insert_form'] select").each(function(){
				var tmp_input_name = $(this).attr("name");
				$("form[name='mon_insert_form'] select[name='"+tmp_input_name+"']").val(eval("data."+tmp_input_name));
			});

			// 상세 페이지 검색후  감시종류 selected
			if(data.N_TYPE_CODE==1000){
				$("select[name='S_CM_TYPE']").val("");
				$("#cmb_cm_type").show();
				$("select[name='S_CM_TYPE']").val(data.S_CM_TYPE);
			}

			// 상세 페이지 검색후 감시타입 selected
			if(data.N_STYLE_CODE==1 || data.N_STYLE_CODE==2){
				fn_svr_style_change(data.N_STYLE_CODE);
				
				// snmp v3 
				if (data.N_STYLE_CODE==2 && data.N_SNMP_VERSION==3) {
					$("#snmpv3_info").show("fast");
					$("#snmp_comunity1").hide();
					$("#snmp_comunity2").hide();
					/* 상단 쿼리에서 갓을 설정.
					 * S_SECURITY_NAME
					 * S_AUTH_PASS
					 * S_PRIV_PASS
					 * S_ENGINE_ID
					 */
	                // 
	                if($("select[name='N_AUTH_CODE'] option:selected").val() == '0') {
						$("#S_AUTH_PASS").val("");
						$("#S_AUTH_PASS").attr("placeholder", "입력할 수 없음");
						$("#S_AUTH_PASS").prop("readonly", true);
					} else $("#S_AUTH_PASS").prop("readonly", false);

	                if($("select[name='N_PRIV_CODE'] option:selected").val() == '0') {
						$("#S_PRIV_PASS").val("");
						$("#S_PRIV_PASS").attr("placeholder", "입력할 수 없음");
						$("#S_PRIV_PASS").prop("readonly", true);
					} else {$("#S_PRIV_PASS").prop("readonly", false)};
				}
			}

			$("#rack_info1").hide();
			$("#rack_info2").hide();
			$("select[name='N_RACK_ID']").val("");
			$('#N_RACK_LOCATION').val("");
			$('#N_RACK_UNIT').val("");
			$("select[name='N_DASHBOARD_MON_TYPE']").val("");

		});
	}

	<c:if test="${param.updateFlag != 'U'}">
	$(function(){
		$(".dupl_chk").blur(function(){
			fn_duplication_chk(this);
		});
	});
	</c:if>

	function fn_duplication_chk(obj)
	{
		var param = $("form[name='mon_insert_form']").serialize();
		$.getJSON("<c:url value='map_mon_info.dul_chk.htm'/>", param, function(data){
			if(data.CNT > 0) {
				$("#msg").remove();
				$("<span/>", {
					'id':"msg"
					, html:"중복된 ID 입니다."
					, style:"color:red;"
				}).appendTo($(obj).parent("td"));
			}
			else {
				$("#msg").remove();
			}
		});
	}

	function fn_svr_style_change(val)
	{
		if(val == "2")	//SNMP
		{
			$("#snmp_info").show("fast");
			$("#icmp_info").hide("fast");
			
			// 등록 페이지일 경우만
			if ('U' != '${param.updateFlag}') {
				$('#N_SNMP_PORT').val('161');
				$("select[name='N_SNMP_VERSION']").val('2');
			}
		}
		else if(val == "1")	//ICMP
		{
			$("#icmp_info").show("fast");
			$("#snmp_info").hide("fast");
			
			// 등록 페이지일 경우만
			if ('U' != '${param.updateFlag}') {
				$('#S_ICMP_NAME').val($('#S_MON_NAME').val());
				$('#N_CHECK_TIME').val('10');
				$('#N_RES_TIME').val('1500');
				$('#N_TIME_OUT').val('3000');
				$('#N_ALM_CNT').val('5');
			}
		}
		else
		{
			$("#snmp_info").hide("fast");
			$("#icmp_info").hide("fast");
		}
	}
	
	// IP주소 벨리데이션 체크
	function verifyIP(IPvalue) {
		var errorString = "";
		var theName = "IPaddress";
	
		var ipPattern = /^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/;
		var ipArray = IPvalue.match(ipPattern);
	
		if (ipArray == null)
			errorString = "IP 주소를 입력 하셔야함";
		else {
			for (i = 0; i < 5; i++) {
				thisSegment = ipArray[i];
				if (thisSegment > 255) {
					errorString = "유효한 IP 주소가 아닙니다";
					i = 4;
				}
			}
		}
	
		if (errorString == "") {
			return true;
		}
		else {
			alert(errorString);
			$('#S_MON_IP').focus();
			return false;
		}
	}

	function initEvent() {
		$('#btn_cancel').on('click', function(event) {
			event.preventDefault();
			if ( confirm("작성된 데이터를 초기화 하시겠습니까?") ) {
				clearFormData();
			}
		});
	
		$('#btn_save').on('click', save);
	
		$('#btn_remove').on('click', del);
		
		$('#btn_list').on('click', function() {
			$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.mon_info.retrieve.htm').submit();
		});
		
		$('input[type=text]').focusout(function() {
			this.value = $.trim(this.value);
		});
	}

	function save()
	{
		// 벨리데이션 체크
		if ('U' !== '${param.updateFlag}') {
			if ($('#N_MON_ID').val() == "" || $('#N_MON_ID').val() == null) {
				alert("장비 ID를 입력 하셔야함");
				$('#N_MON_ID').focus();
				return;
			}

		}
		if ($('#S_MON_NAME').val() == "" || $('#S_MON_NAME').val() == null) {
			alert("장비명을 입력 하셔야함");
			$('#S_MON_NAME').focus();
			return;
		}

		if ($('#S_MON_IP').val() == "" || $('#S_MON_IP').val() == null) {
			alert("장비IP를 입력 하셔야함");
			$('#S_MON_IP').focus();
			return;
		}
		// IP 주소 체크 벨리데이션
		if (!verifyIP($('#S_MON_IP').val())) return;

		if ($("select[name=N_GROUP_CODE]").val() == "" || $("select[name=N_GROUP_CODE]").val() == null) {
			alert("그룹명을 선택 하셔야함");
			$('#N_GROUP_CODE').focus();
			return;
		}

		var selectRackId = $("select[name='N_RACK_ID'] option:selected").val();

		if (selectRackId != "" && selectRackId != null) {

			if ($('#N_RACK_LOCATION').val() == "" || $('#N_RACK_LOCATION').val() == null) {
				alert("랙(Rack) 위치를 입력하십시오.");
				$('#N_RACK_LOCATION').focus();
				return;
			}
			if ($('#N_RACK_UNIT').val() == "" || $('#N_RACK_UNIT').val() == null) {
				alert("랙(Rack) 유닛을 입력하십시오.");
				$('#N_RACK_UNIT').focus();
				return;
			}
		}


		if ($("select[name=N_TYPE_CODE]").val() == "" || $("select[name=N_TYPE_CODE]").val() == null) {
			alert("감시종류를 선택 하셔야함");
			$('#N_TYPE_CODE').focus();
			return;
		}

		if ($("select[name=N_TYPE_CODE]").val() == "1000") {
			if ($("select[name=S_CM_TYPE]").val() == "" || $("select[name=S_CM_TYPE]").val() == null) {
				alert("감시종류 기타를 선택 하셔야함");
				$('#S_CM_TYPE').focus();
				return;
			}
		}

		if ($("select[name=N_STYLE_CODE]").val() == "" || $("select[name=N_STYLE_CODE]").val() == null) {
			alert("감시타입 선택 하셔야함");
			$('#N_STYLE_CODE').focus();
			return;
		}

		// ICMP 일경우
		if ($("select[name=N_STYLE_CODE]").val() == "1") {
			//S_ICMP_NAME
			if ($('#S_ICMP_NAME').val() == "" || $('#S_ICMP_NAME').val() == null) {
				alert("ICMP 명칭을 입력 하셔야함");
				$('#S_ICMP_NAME').focus();
				return;
			}

			if ($('#N_CHECK_TIME').val() == "" || $('#N_CHECK_TIME').val() == null) {
				alert("체크주기(초)를 입력 하셔야함");
				$('#N_CHECK_TIME').focus();
				return;
			}

			if ($('#N_RES_TIME').val() == "" || $('#N_RES_TIME').val() == null) {
				alert("응답시간(ms)을 입력 하셔야함");
				$('#N_RES_TIME').focus();
				return;
			}

			if ($('#N_TIME_OUT').val() == "" || $('#N_TIME_OUT').val() == null) {
				alert("TimeOut(초)을 입력 하셔야함");
				$('#N_TIME_OUT').focus();
				return;
			}

			if ($('#N_ALM_CNT').val() == "" || $('#N_ALM_CNT').val() == null) {
				alert("장애인식카운트를 입력 하셔야함");
				$('#N_ALM_CNT').focus();
				return;
			}

			if ($("select[name=N_ALM_RAT]").val() == "" || $("select[name=N_ALM_RAT]").val() == null) {
				alert("장애등급을 선택 하셔야함");
				$('#N_ALM_RAT').focus();
				return;
			}
		}

		// SNMP일 경우
		if ($("select[name=N_STYLE_CODE]").val() == "2") {

			if ($("select[name=N_SNMP_MAN_CODE]").val() == "" || $("select[name=N_SNMP_MAN_CODE]").val() == null) {
				alert("SNMP 장비를 선택 하셔야함");
				$('#N_SNMP_MAN_CODE').focus();
				return;
			}

			if ($('#N_SNMP_PORT').val() == "" || $('#N_SNMP_PORT').val() == null) {
				alert("SNMP Port를 입력 하셔야함");
				$('#N_SNMP_PORT').focus();
				return;
			}

			if ($("select[name='N_SNMP_VERSION'] option:selected").val() != "3"
					&& ($('#S_SNMP_COMMUNITY').val() == "" || $('#S_SNMP_COMMUNITY').val() == null)) {
				alert("SNMP Community를 입력 하셔야함");
				$('#S_SNMP_COMMUNITY').focus();
				return;
			}


			if ($("select[name='N_SNMP_VERSION'] option:selected").val() == ""
					|| $("select[name='N_SNMP_VERSION'] option:selected").val() == null) {
				alert("N_SNMP_VERSION을 선택 하셔야함");
				$('#N_SNMP_VERSION').focus();
				return;
			}

			if ($("select[name='N_SNMP_VERSION'] option:selected").val() == "3"
					&& ($('#S_SECURITY_NAME').val() == "" || $('#S_SECURITY_NAME').val() == null)) {
				alert("Security Name을 입력 하셔야함");
				$('#S_SECURITY_NAME').focus();
				return;
			}

			if ($("select[name='N_AUTH_CODE'] option:selected").val() != ""
					&& $("select[name='N_AUTH_CODE'] option:selected").val() != null
					&& $("select[name='N_AUTH_CODE'] option:selected").val() != "0"
					&& ($('#S_AUTH_PASS').val() == "" || $('#S_AUTH_PASS').val() == null)) {
				alert("인증 암호화 비밀번호를 입력 하셔야함");
				$('#S_AUTH_PASS').focus();
				return;
			}

			if ($("select[name='N_AUTH_CODE'] option:selected").val() != ""
					&& $("select[name='N_AUTH_CODE'] option:selected").val() != null
					&& $("select[name='N_AUTH_CODE'] option:selected").val() != "0"
					&& ($('#S_AUTH_PASS').val().length < 8)) {
				alert("인증 암호화 비밀번호를 8자리 이상 입력 하셔야함");
				$('#S_AUTH_PASS').focus();
				return;
			}

			if ($("select[name='N_PRIV_CODE'] option:selected").val() != ""
					&& $("select[name='N_PRIV_CODE'] option:selected").val() != null
					&& $("select[name='N_PRIV_CODE'] option:selected").val() != "0"
					&& ($('#S_PRIV_PASS').val() == "" || $('#S_PRIV_PASS').val() == null)) {
				alert("사설 암호화 비밀번호를 입력 하셔야함");
				$('#N_PRIV_PASS').focus();
				return;
			}

			if ($("select[name='N_PRIV_CODE'] option:selected").val() != ""
					&& $("select[name='N_PRIV_CODE'] option:selected").val() != null
					&& $("select[name='N_PRIV_CODE'] option:selected").val() != "0"
					&& ($('#S_PRIV_PASS').val().length < 8)) {
				alert("사설 암호화 비밀번호를 8자리 이상 입력 하셔야함");
				$('#N_PRIV_PASS').focus();
				return;
			}

			if ($("select[name='N_SNMP_VERSION'] option:selected").val() == "3") {
				if ($("select[name='N_AUTH_CODE'] option:selected").val() == ""
						|| $("select[name='N_AUTH_CODE'] option:selected").val() == null) {
					alert("인증 암호화 코드를 선택 하셔야함");
					$('#N_AUTH_CODE').focus();
					return;
				}
				if ($("select[name='N_PRIV_CODE'] option:selected").val() == ""
						|| $("select[name='N_PRIV_CODE'] option:selected").val() == null) {
					alert("사설 암호화 코드를 선택 하셔야함");
					$('#N_PRIV_CODE').focus();
					return;
				}
				if ($('#S_ENGINE_ID').val() == "" || $('#S_ENGINE_ID').val() == null) {
					alert("엔진 ID를 입력 하셔야함");
					$('#S_ENGINE_ID').focus();
					return;
				}
				if ($('#S_ENGINE_ID').val().length > 24) {
					alert("최대 24자리 까지 입력 가능함");
					$('#S_ENGINE_ID').focus();
					return;
				}
			}
		}

		<c:if test="${param.updateFlag != 'U'}">
			fn_duplication_chk($(".dupl_chk"));
			if($("#msg").text() != "")
			{
				alert("중복되지 않은 ID를 지정하여 주십시오.");
				return;
			}
		</c:if>

		var chk_flag = true;
		$(".chk_val").each(function(idx){
			if($(this).val() == "" || $(this).val() == null) {
				alert($(this).parent("td").parent("tr").children(".title_nm").text().trim() + " 이/가 입력되지 않았습니다.");
				chk_flag = false;
				return false;
			}
		});
		if(!chk_flag) return;

		var tmp_sms_no = "";

		$(".div_sms_no").each(function(idx){
			if(idx != 0) tmp_sms_no += ",";
			tmp_sms_no += $(this).children("input[name='S_SMS_NAME']").val() + ";" + $(this).children("input[name='S_SMS_NO']").val();
		});

		$("input[name='S_SMS_NO_LIST']").val(tmp_sms_no);


		var url = ('${param.updateFlag}' != 'U')?"<c:url value='/admin/insert_mon_info.htm'/>":"<c:url value='/admin/update_mon_info.htm'/>";

		var param = $("form[name='mon_insert_form']").serialize();
		$.post(url, param, function(str){
			var data = $.parseJSON(str);
			if(data.RSLT != null && data.RSLT > 0) {
				alert('저장되었습니다.');
				goListPage();
				return;
			}
			else {
				alert("저장 실패 하였습니다.\n" + data.ERRMSG + "");
				fn_cancel();
				return;
			}
		});
	}
	
	// 삭제
	function del()
	{
		if(!confirm("정말 삭제 하시겠습니까?"))
			return;
		
		var tmp_mon_info = $("#N_MON_ID").text() + ";"
       					 + $("#S_MON_IP").val()
		$("#mon_info_delete_list").val(tmp_mon_info);
		
		$.blockUI(blockUIOption);
		var url = "<c:url value='/admin/delete_mon_info.htm'/>";
		var param = $("form[name='mon_insert_form']").serialize();
		
		$.post(url, param, function(str){
			var data = $.parseJSON(str);
			if(data.RSLT != null && data.RSLT > 0) {
				alert('삭제되었습니다.');
				goListPage();
				return;
			}
			else {
				alert("삭제 실패 하였습니다.\n" + data.ERRMSG + "");
				goListPage();
				return;
			}
		})
		.always(function() {
			$.unblockUI();
		});
	}
	
	function clearFormData() {
		if ('U' === '${param.updateFlag}') {
			detailInfoDataSetting('${param.N_MON_ID}');
		} else {
			$("form")[0].reset();
		}
		$("#mon_insert_form span.k-tooltip-validation").hide(); // kendo validator 문구 초기화
	}

	function goListPage() {
		$('#go_list_form').attr('action', cst.contextPath() + '/admin/go_prgm.mon.mon_info.retrieve.htm').submit();
	}
	
	function fn_maxMonId_value(nTypeCode)
	{
		$.getJSON("<c:url value='map_mon_info.select_monId_maxValue.htm'/>", {"N_TYPE_CODE" : nTypeCode}, function(data){
			$("#N_MON_ID").val(data.MAX_MON_ID);
		});
	}
</script>