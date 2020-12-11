<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div id="center_statue_grid_area"></div>

<script type="text/javascript">
	$(document).ready(function() {
		makeGridColumns(initCenterStatusGrid);
	});

	// 센터별 그리드 생성
	function initCenterStatusGrid(columns) {

//		var groupCodesXhr 		= $.get(cst.contextPath() + '/watcher/lst_common.groupCodes.htm'); // search group code array
		var serverTypeCodesXhr 	= $.get(cst.contextPath() + '/watcher/lst_common.serverTypeCodes.htm'); // search server type code array

//		groupCodesXhr.done(function(g_sData) { // group codes data callback
//			var groupCodes 	= JSON.parse(g_sData);
			var typeArr;
			var dataSources = [];

			serverTypeCodesXhr.done(function(s_sData) { // server type datas callback
				typeArr = JSON.parse(s_sData);

				for (var i = 0, length = columns.length; i < length; i++) {
					$('#center_statue_grid_area').append('<div id="server_status_grid_' + i + '" class="table_typv1">');

					var dataSource = new kendo.data.DataSource({
						transport: {
							read: {
								url: cst.contextPath() + '/watcher/lst_selectGroupAllStatus.htm',
								dataType: "json",
								data 		: function(data) {
//									return {value : groupCodes[i]};
									return data;
								}
							}
						},
						schema			: {
							data	: function(data) {
								var array = [];
								for (var i = 0, length = data.length; i < length; i++) { // server group loop
									var obj = data[i];
									for (var j = 0, length2 = typeArr.length; j < length2; j++) { // server type loop
										
										if (parseInt(obj.N_TYPE_CODE) === typeArr[j]) {
											obj['TYPE_ALL_CNT_' + typeArr[j]] = parseInt(obj.TYPE_ALL_CNT);
											obj['TYPE_ALM_CNT_' + typeArr[j]] = parseInt(obj.TYPE_ALM_CNT);
											obj['TYPE_CON_CNT_' + typeArr[j]] = parseInt(obj.TYPE_CON_CNT);
											obj['TYPE_ALM_STATUS_' + typeArr[j]] = parseInt(obj.TYPE_ALM_STATUS);
										}
										else {
											obj['TYPE_ALL_CNT_' + typeArr[j]] = 0;
											obj['TYPE_ALM_CNT_' + typeArr[j]] = 0;
											obj['TYPE_CON_CNT_' + typeArr[j]] = 0;
											obj['TYPE_ALM_STATUS_' + typeArr[j]] = 0;
										} 
									}
									array.push(obj);
								}
								return groupBy(array, typeArr);
							}
						}
					});

					createCenterStatusGrid('#server_status_grid_' + i, columns[i], dataSource);
					dataSources.push(dataSource);
				}

				interval.push(setInterval(function () {
					for (var i = 0, length = dataSources.length; i < length; i++) {
//						dataSources[i].read({value : groupCodes[i]});
						dataSources[i].read();
					}
				}, 10000));
			})
//		});
	}

	function groupBy(arr, typeArr) {
		var result = arr;
		var groupCode = parseInt(result[0].N_GROUP_CODE);
		for (var i = 0, length = result.length; i < length; i++) {
			var obj = result[i];
			if ( obj && groupCode === parseInt(result[i].N_GROUP_CODE) ) {
				for (var j = 0, length2 = typeArr.length; j < length2; j++) {
					// arr 가 첫번째 index 가 아니고 서버 타입의 카운트값이 0이 아니면
					// arr의 전 index 값의 object 에 새로운 값을 넣는다.
					if (i !== 0 && obj['TYPE_ALL_CNT_' + typeArr[j]] !== 0) {	
						result[i - 1]['TYPE_ALL_CNT_' + typeArr[j]] = obj['TYPE_ALL_CNT_' + typeArr[j]];
						result[i - 1]['TYPE_ALM_CNT_' + typeArr[j]] = obj['TYPE_ALM_CNT_' + typeArr[j]];
						result[i - 1]['TYPE_CON_CNT_' + typeArr[j]] = obj['TYPE_CON_CNT_' + typeArr[j]];
						result[i - 1]['TYPE_ALM_STATUS_' + typeArr[j]] = obj['TYPE_ALM_STATUS_' + typeArr[j]];
						result.splice(i, 1); // arr 의 index -1 에 값을 집어넣고 현재 index 제거
						--i;
						break;
					}
				}
			}
			if ( obj ) groupCode = parseInt(obj.N_GROUP_CODE);
		}
		return result;
	}

	// 그리드 header columns 동적 생성
	function makeGridColumns(fn) {
		// 센터 그룹 컬럼 Header 생성
//		$.get(cst.contextPath() + '/watcher/lst_selectCenterMainGroup.htm').done(function(sData) {
//			var data = JSON.parse(sData);
			var totalColumns = [];
//			for (var i = 0, length = data ? data.length : 0; i < length; i++) {
//				var obj = data[i];
				var columnsServerType = [];
				var columnsObj = {
					field 			: '',
					title 			: '',
					width 			: '8%',
					attributes		: {style:'text-align:center;'},
					headerAttributes: {style:'text-align:center;'}
				};
				columnsObj.field = 'S_GROUP_NAME';
//				columnsObj.title = obj.VAL;
				columnsObj.title = '서버그룹';
//				columnsObj.template = '#=S_GROUP_NAME#<input type="hidden" name="searchGroupCode" value="#=N_GROUP_CODE#">';
				columnsServerType.push(columnsObj); // 센터 그룹
				columnsServerType.push({field:'GROUP_STATUS', title:'구성현황', width:'7%', attributes:{'class':'left'},
					headerAttributes:{style:'text-align:center;'}, template : '#=templateServerStatus(ALL_MON_GRP_CNT, ALL_CON_GRP_CNT, ALL_ALM_GRP_CNT )#'}); // 센터현황

				totalColumns.push(columnsServerType); // 센터 그룹별 columns 임시 저장
//			}

			// 서버 Type 컬럼 Header 생성
			$.get(cst.contextPath() + '/watcher/lst_cmb_svr_type.htm')
					.done(function(sData2) {
						var data2 = JSON.parse(sData2);
						for (var i = 0, length = totalColumns.length; i < length; i++)
						{
							for (var j = 0, length2 = data2 ? data2.length : 0; j < length2; j++)
							{
								var obj = data2[j];
								var columnsObj = {
									field 			: '',
									title 			: '',
									width 			: '7%',
									attributes		: {style:'text-align:center;'},
									headerAttributes: {style:'text-align:center;'},
									template		: '#=templateServerType(   N_GROUP_CODE,' + 
																			   obj.CODE + 
																			', TYPE_ALL_CNT_' + obj.CODE + 
																			', TYPE_ALM_CNT_' + obj.CODE + 
																			', TYPE_CON_CNT_' + obj.CODE +
																			', TYPE_ALM_STATUS_' + obj.CODE +
																		    ')#'
								};
								columnsObj.field = 'TYPE_' + obj.CODE;
								columnsObj.title = obj.VAL;
								totalColumns[i].push(columnsObj);
							}
						}
						fn.apply(null, [totalColumns]);
					});
//		});
	}

	// 센터현황 Column Html 생성
	function templateServerStatus(allCnt, conCnt, almCnt) {
		var html = '';
		html += ' <ul> ';
		html += ' 	<li>ㆍ전체: ' + allCnt + '</li> ';
		html += '	<li>ㆍ연결: ' + conCnt + '</li> ';
		html += ' 	<li>ㆍ장애: ' + almCnt + '</li> ';
		html += ' </ul> ';
		return html;
	}

	// Server Type 이미지 및 수량 Html 생성
	function templateServerType(groupCode, typeCode, typeAllCnt, typeAlmCnt, typeConCnt, typeStatus) {
		var imgSrc;
		
		/* 2016.01.08 현대 캐피탈용 (알람램프 장애:빨강, 주의:노랑, 문제없음:초록) 
		if (parseInt(typeAllCnt) === 0) {	//장비수가 없으면 회색
			imgSrc = cst.contextPath() + '/images/botton/icon_siren_gray.png';		
		} else if (parseInt(typeAlmCnt) > 0 && parseInt(typeRating) === 2) {	//주의
			imgSrc = cst.contextPath() + '/images/botton/ico_err_yellow.gif';
		} else if (parseInt(typeAlmCnt) > 0) { 	//장애
			imgSrc = cst.contextPath() + '/images/botton/ico_err.gif';
		} else {
			imgSrc = cst.contextPath() + '/images/botton/ico_ok.gif';
		} */

		/* 알람램프 장애,주의:빨강, 문제없음:초록 */
		if (parseInt(typeAllCnt) === 0) {	//장비수가 없으면 회색
			imgSrc = cst.contextPath() + '/images/botton/icon_siren_gray.png';		
		//} else if (parseInt(typeAlmCnt) > 0 && parseInt(typeRating) === 2) {	//주의
		//	imgSrc = cst.contextPath() + '/images/botton/ico_err_yellow.gif';
		} else if (parseInt(typeAlmCnt) > 0 && parseInt(typeStatus) === 3) {	//확인
			imgSrc = cst.contextPath() + '/images/botton/ico_err_yellow.gif';
		} else if (parseInt(typeAlmCnt) > 0 && parseInt(typeStatus) === 2) { 	//장애
			imgSrc = cst.contextPath() + '/images/botton/ico_err.gif';
		} else {
			imgSrc = cst.contextPath() + '/images/botton/ico_ok.gif';
		}
		
		var html = '<img src="' + imgSrc + '" alt="" height="30"/>';
		html += '<span>' + typeAllCnt + '/' + typeAlmCnt + '</span>';
		html += '<input type="hidden" name="searchGroupCode" value="' + groupCode + '">';
		html += '<input type="hidden" name="searchTypeCode" value="' + typeCode + '">';

		return html;
	}

	// 센터 전체현황 그리드 등록
	function createCenterStatusGrid(selector, columns, dataSource) {
		return $(selector)
					.kendoGrid($.extend({}, kendoGridDefaultOpt, {
						dataSource	: dataSource,
						autoBind	: true,
						change		: function() {
							$.map(this.select(), function(item) {
								var groupCode, typeCode;
								
								if ($(item).index() === 0 || $(item).index() === 1 ) { // 서버그룹, 센터현황
									return;
								}

								if ( parseInt($(item).text().split('/')[0]) === 0 ) {
									alert('대상 장비가 존재하지 않습니다.');
									return;
								}

								if ( $(item).index() === 0 ) { // 장비그룹
									groupCode = $(item).find('input[name=searchGroupCode]').val();
									typeCode = -1;
								}
								else { // 장비타입
									groupCode = $(item).find('input[name=searchGroupCode]').val();
									typeCode = $(item).find('input[name=searchTypeCode]').val();
								}

								location.href = cst.contextPath() + '/watcher/realtime_stats/component/center_detail.htm?N_GROUP_CODE=' + groupCode + '&N_TYPE_CODE=' + typeCode;
							});
						},
						columns		: columns
						/*[
						 {width:'5%', attributes:{style:'text-align:center;'}, template : '<img src="<c:url value="/images/botton/ico_aus.gif"/>" alt="">'},
						 {field:'S_MON_NAME', title:'장비명', width:'10%', attributes:{style:'text-align:center;'}, headerAttributes:{style:'text-align:center;'}},
						 {field:'S_ALM_MSG', title:'장애내용', width:'70%', attributes:{style:'text-align:left;'}, headerAttributes:{style:'text-align:center;'}},
						 {field:'D_UPDATE_TIME', title:'날짜', width:'15%', attributes:{style:'text-align:center;'}, headerAttributes:{style:'text-align:center;'}}
						 ]*/,
						scrollable	: false,
						selectable	: 'cell',
	//				height		: 200,
						pageable	: false
					})).data('kendoGrid');
	}
</script>