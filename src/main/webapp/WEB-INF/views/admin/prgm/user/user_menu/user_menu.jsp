<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>사용자 메뉴 관리</h2><span>Home &gt; 사용자 관리 &gt; 사용자 메뉴관리</span></div></div>
<!-- location // -->

<!-- 내용 -->
<div class="mana_box1">
	<table  cellpadding="0" cellspacing="0" class="table_left">
		<tr>
			<td class="bgtl1"></td>
			<td class="bgtc1"><strong>메뉴목록</strong><span class="admin_right"><input type="checkbox" id="menu_list_all_check" class="all_check"/><strong><label for="menu_list_all_check">전체선택</label></strong></span></td>
			<td class="bgtr1"></td>
		</tr>
		<tr>
			<td class="bgml1"></td>
			<td class="bgmc1">
				<dl id="menu_list">
					<!-- 동적 생성 -->
				</dl>
			</td>
			<td class="bgmr1"></td>
		</tr>
		<tr>
			<td class="bgbl1"></td>
			<td class="bgbc1"></td>
			<td class="bgbr1"></td>
		</tr>
	</table>
	<table class="table_center">
		<tr>
			<td  align="center" valign="middle">
				<a href="#"><img id="btn_left" src="<c:url value="/admin/images/botton/arrow2_1.jpg"/>" alt="이전" /></a>
				<a href="#"><img id="btn_right" src="<c:url value="/admin/images/botton/arrow2_2.jpg"/>" alt="다음" /></a>
			</td>
		</tr>
	</table>
	<table  cellpadding="0" cellspacing="0" class="table_right">
		<tr>
			<td class="bgtl1"></td>
			<td class="bgtc1">
				<strong>사용자 메뉴 목록</strong>
				<span class="admin_right">
					<strong>사용자 :</strong>
					<select name="S_USER_ID" id="sel_user_list">
					</select>
					<input type="checkbox" id="user_menu_list_all_check" class="all_check"/><strong><label for="user_menu_list_all_check">전체선택</label></strong>
				</span>
			</td>
			<td class="bgtr1"></td>
		</tr>
		<tr>
			<td class="bgml1"></td>
			<td class="bgmc1">
				<dl id="user_menu_list">
					<dt>&nbsp;</dt>
					<dd>&nbsp;</dd>
					<dd>&nbsp;</dd>
					<dd>&nbsp;</dd>
					<dd>&nbsp;</dd>
					<dd>&nbsp;</dd>
					<dd>&nbsp;</dd>
					<dt>&nbsp;</dt>
					<dd>&nbsp;</dd>
					<dd>&nbsp;</dd>
					<dd>&nbsp;</dd>
					<dd>&nbsp;</dd>
					<dd>&nbsp;</dd>
					<dd>&nbsp;</dd>
					<dd>&nbsp;</dd>
					<dd>&nbsp;</dd>
					<dd>&nbsp;</dd>
					<dd>&nbsp;</dd>
					<dt>&nbsp;</dt>
					<dd>&nbsp;</dd>
					<dd>&nbsp;</dd>
					<dd>&nbsp;</dd>
					<dd>&nbsp;</dd>
					<dd>&nbsp;</dd>
				</dl>
			</td>
			<td class="bgmr1"></td>
		</tr>
		<tr>
			<td class="bgbl1"></td>
			<td class="bgbc1"></td>
			<td class="bgbr1"></td>
		</tr>
	</table>
</div>
<!-- 내용 // -->

<script type="text/javascript">
	$(document).ready(function() {
		// 좌측 메뉴목록 조회
		makeMenuList('menu_list', '/admin/lst_user_menu.selMenuList.htm');
		initEvent();

		var $selUserList = $("#sel_user_list");
		cfn_makecombo_opt($selUserList, cst.contextPath() + '/admin/lst_common.cmb_user.htm', function(){
			$selUserList.on('change', fn_user_change).change();
		})
	});

	// Event 등록
	function initEvent() {
		// 메뉴목록 전체선택 checkbox click
		$('.all_check').on('click', function() {
			var $checkboxes = $(this).parents('table').find('input[type=checkbox]');
			if (this.checked) {
				$checkboxes.prop('checked', true);
			} else {
				$checkboxes.prop('checked', false);
			}
		});

		$('#btn_left').on('click', fn_left_click);
		$('#btn_right').on('click', fn_right_click);
	}

	function addEventChildCheckbox(wrapId) {
		var prefix = wrapId + '_';
		//  1depth 메뉴 checkbox click
		$('#' + wrapId).find('dt').children('input[type=checkbox]').on('click', function() {
			var $checkbox = $('.check_' + prefix + this.value);
			if (this.checked) {
				$checkbox.prop('checked', true);
			} else {
				$checkbox.prop('checked', false);
			}
		});

		//  2depth 메뉴 checkbox click
		$('#' + wrapId).find('dd').children('input[type=checkbox]').on('click', function() {
			var className = $(this).attr('class');
			var parentDepthId = $(this).attr('parent');
			if ($('.' + className).length === $('.' + className + ':checked').length) {
				$('#' + prefix + parentDepthId).prop('checked', true);
			} else {
				$('#' + prefix + parentDepthId).prop('checked', false);
			}
		});

		var $childCheckbox = $('#' + wrapId).find('input[type=checkbox]');
		$childCheckbox.on('click', function() {
			if ($childCheckbox.length === $('#' + wrapId).find('input[type=checkbox]:checked').length) {
				$('#' + prefix + 'all_check').prop('checked', true);
			} else {
				$('#' + prefix + 'all_check').prop('checked', false);
			}
		});
	}

	function isParent(code) {
		return parseInt(code) === 0;
	}

	function fn_user_change() {
		var param = 'S_USER_ID=' + $('#sel_user_list').val();
		makeMenuList('user_menu_list', '/admin/lst_user_menu.selUserMenuList.htm', param);
	}

	function makeMenuList(wrapId, url, param) {
		$.getJSON(cst.contextPath() + url, (param ? param : ''))
			.done(function(data) {
				$('#' + wrapId).empty();

				// Array 여부를 체크하는 이유는 값이 없을때는 Object 형태로 오기때문
				if ($.isArray(data)) {
					var prefix = wrapId + '_';
					$(data).each(function() {
						var innerHtml = isParent(this.PARENT_MENU) ? '<dt>' : '<dd>';
						innerHtml += isParent(this.PARENT_MENU) ? '▶' : '-';
						innerHtml += '<input type="checkbox" id="' + prefix + this.N_MENU_CODE + '" class="check_' + prefix + this.PARENT_MENU + '" parent="' +  this.PARENT_MENU + '" value="' + this.N_MENU_CODE + '"/>';
						innerHtml += '<label for="' + prefix + this.N_MENU_CODE + '">' + this.S_MENU_NAME + '</label>';
						innerHtml += isParent(this.PARENT_MENU) ? '</dt>' : '</dd>';
						$('#' + wrapId).append(innerHtml);
					});

					addEventChildCheckbox(wrapId);
				}
			});
	}

	function fn_user_menu_change(flag, val) {
		if (val === '') {
			alert('메뉴가 선택 되지 않았습니다.');
			return;
		}

		var param = '';
		param += 'S_USER_ID=' + $('#sel_user_list').val();
		param += '&FLAG=' + flag;
		param += '&SELECT_MENU='+ val;

		$.post(cst.contextPath() + '/admin/user_menu_change.htm', param)
			.done(fn_user_change);
	}

	function fn_left_click(event) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}
		if ($('#sel_user_list').val() === '') {
			alert('사용자가 선택되지 않았습니다.');
			$('#sel_user_list').focus();
			return;
		}

		var str = '';
		$('#user_menu_list').find('input[type=checkbox]:checked').each(function(){
			str += $(this).val() + ',';
		});
		fn_user_menu_change('D', str);
	}

	function fn_right_click(event) {
		if (event) {
			event.preventDefault ? event.preventDefault() : event.returnValue = false;
		}
		if($('#sel_user_list').val() === '') {
			alert('사용자가 선택되지 않았습니다.');
			$('#sel_user_list').focus();
			return;
		}

		var str = '';
		$('#menu_list').find('input[type=checkbox]:checked').each(function(){
			str += $(this).val() + ',';
		});
		fn_user_menu_change('I', str);
	}
</script>