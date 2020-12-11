<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div id="center_statue_grid_area">
	<div id="server_status_grid_0" class="k-grid k-widget" data-role="grid">
		<table role="grid" data-role="" class="">
			<colgroup id="center_colgroup">
				<col style="width: 70px;">
				<col style="width: 70px;">
			</colgroup>
			<thead class="k-grid-header" role="rowgroup">
				<tr id="center_header" role="row">
					<th role="columnheader" data-field="S_GROUP_NAME" rowspan="1" data-title="서버그룹" data-index="0" style="text-align: center;" class="k-header">서버그룹</th>
					<th role="columnheader" data-field="GROUP_STATUS" rowspan="1" data-title="구성현황" data-index="1" style="text-align: center;" class="k-header">구성현황</th>
				</tr>
			</thead>
			<tbody id="center_body" role="rowgroup">
			</tbody>
		</table>
	</div>
</div>
<script type="text/javascript">
	var configInfo = { 
			typeTdWidth: "100px"  // 램프 컬럼 너비
			, intervalTerm : 10000 // refresh Time
	};
	 
 	var typeHeaderCount;
	// var typeHeaderArr;
	var serverGroupArr;
	var centerInfoArr;
	$(document).ready(function() {
		init();
	});

	function init() {
		// makeHeader 호출 후 makeBody
		makeHeader(makeBody);
	};
	
	// 센터 현황판 표시
	function setCenterInfo() {
		$.get(cst.contextPath() + '/watcher/lst_selectGroupAllStatus.htm')
		.done(function(sData) {
			centerInfoArr = JSON.parse(sData);
			
			// 센터현황 컬럼 정보 세팅
			for (var i = 0; i < centerInfoArr.length; i ++) {
				var centerInfo = centerInfoArr[i];
				
				$("#row_" + centerInfo.N_GROUP_CODE + " #total_group_cnt").text('ㆍ전체: ' + centerInfo.ALL_MON_GRP_CNT);
				$("#row_" + centerInfo.N_GROUP_CODE + " #connect_group_cnt").text('ㆍ연결: ' + centerInfo.ALL_CON_GRP_CNT);
				$("#row_" + centerInfo.N_GROUP_CODE + " #error_group_cnt").text('ㆍ장애: ' + centerInfo.ALL_ALM_GRP_CNT);
			}	
			
			// 서버그룹 컬럼과 센터현황 컬럼만 남기고 초기화
			for (var j = 0; j < serverGroupArr.length; j++) {
				var serverGroup = serverGroupArr[j];
				
				var rowDom = $("#row_" + serverGroup.N_GROUP_CODE);
				var firstTd = rowDom.children().eq(0); // 서버그룹 td 임시 보관
				var secondTd = rowDom.children().eq(1); // 센터현황 td 임시 보관

				// 서버그룹 센터현황만 남기고 제거
				rowDom.empty(); 
				rowDom.append(firstTd);
				rowDom.append(secondTd);
			}
			
			// 서버 그룹의 컬럼들을 그린다
			var inx = 0;
	 		for (var q = 1; q <= serverGroupArr.length; q ++) {
 				for (var k = 1; k <= typeHeaderCount.MAX_CNT; k ++) {
	 				var centerInfo = centerInfoArr[inx];
	 				
	 				if(centerInfo) {
						var rowDom = $("#row_" + centerInfo.N_GROUP_CODE);
		 				var htmlStr = "";
		 				var imgSrc = getLampImgSrc(centerInfo);

		 				htmlStr += "<td style='text-align: center;'><a href='" + '/watcher/realtime_stats/component/center_detail.htm?N_GROUP_CODE=' + centerInfo.N_GROUP_CODE + '&N_TYPE_CODE=' + centerInfo.N_TYPE_CODE + "' style='display: inline-block;width: 100%;'>";
						htmlStr += "	<img id='type_img_" + centerInfo.N_TYPE_CODE +  "' src='" + imgSrc + "' height='27' />";
						// htmlStr += "	<div id='type_cnt_" + centerInfo.N_TYPE_CODE + "'>" + centerInfo.TYPE_ALL_CNT + "/" + centerInfo.TYPE_ALM_CNT  + "</div>";
						htmlStr += "	<div class='k-button' style='width:110px; display:block; margin:0 auto; padding:0; background-color:#FFF; font-size:80%;'>" + centerInfo.S_TYPE_NAME + "(" + centerInfo.TYPE_ALL_CNT + "/" + centerInfo.TYPE_ALM_CNT  + ")</div>";
						htmlStr += "</a></td>";
						
						rowDom.append(htmlStr);
	 				}
					inx++;
				}
			}
	 		// 서버 그룹의 나머지 컬럼을 채워준다.
	 		for (var q = 0; q < serverGroupArr.length; q ++) { 
	 			var rowDom = $("#row_" + serverGroupArr[q].N_GROUP_CODE);
	 			
	 			var headerLength = typeHeaderCount.MAX_CNT + 2;
	 			
	 			for (var i = rowDom.children().length; i < headerLength; i++) {
	 				var htmlStr = "";
	 				htmlStr += "<td>";
	 				htmlStr += "</td>";
	 				
	 				rowDom.append(htmlStr);
	 			}
	 		}

		});
	}
	
/* 	function makeHeader(callback) {
		$.get(cst.contextPath() + '/watcher/lst_cmb_svr_type.htm')
		.done(function(sData) {
			typeHeaderArr = JSON.parse(sData);
			console.log('typeHeaderArr: ', typeHeaderArr);
			for (var i = 0; i < typeHeaderArr.length; i ++ ) {
				$('#center_colgroup').append("<col style='width: " + configInfo.typeTdWidth + ";'>"); // %는 없을 시 컬럼 크기가 줄어들음
				$('#center_header').append('<th role="columnheader" rowspan="1" style="text-align: center;" class="k-header"></th>');
			}
			callback();
		});
	}
 */
 
	function makeHeader(callback) {
		$.get(cst.contextPath() + '/watcher/map_max_type_header_cnt.htm')
		.done(function(sData) {
			typeHeaderCount = JSON.parse(sData);
			console.log('maxTypeHeaderCount: ', typeHeaderCount);
			for (var i = 0; i < typeHeaderCount.MAX_CNT; i ++ ) {
				$('#center_colgroup').append("<col style='width: " + configInfo.typeTdWidth + ";'>"); // %는 없을 시 컬럼 크기가 줄어들음
				$('#center_header').append('<th role="columnheader" rowspan="1" style="text-align: center;" class="k-header"></th>');
			}
			callback();
		})
	}
 
	function makeBody() {
		// search server type code array
		$.get(cst.contextPath() + '/watcher/lst_common.serverGroupsEachUser.htm')
		.done(function(sData) {
			serverGroupArr = JSON.parse(sData);
			console.log('serverGroupArr:', serverGroupArr);
			for (var i = 0; i < serverGroupArr.length; i ++) {
				
				var htmlStr = "";
				htmlStr +=	"<tr id='row_" + serverGroupArr[i].N_GROUP_CODE + "'>";
				htmlStr += 		"<td style='text-align: center;'>" + serverGroupArr[i].S_GROUP_NAME + "</td>";
				htmlStr +=		"<td class='left' style='line-height:1.2em;'>"
				htmlStr +=			"<ul style='font-size:100%;'>";
				htmlStr += 				"<li><div style='' id='total_group_cnt'> ㆍ전체:"  + 0 + "</div></li>";
				htmlStr += 				"<li><div style='' id='connect_group_cnt'>ㆍ연결: " + 0 + "</div></li>";
				htmlStr += 				"<li><div style='' id='error_group_cnt'>ㆍ장애: " + 0 + "</div></li>";
				htmlStr +=			"</ul>";
				htmlStr +=		"</td>";
				
/*  				for (var j = 0; j < typeHeaderArr.length; j ++) {
					htmlStr += "<td style='text-align: center;'>";
					htmlStr += "<img id='type_img_" + typeHeaderArr[j].CODE +  "' src='/images/botton/ico_ok.gif' height='30' />";
					htmlStr += "<span id='type_cnt_" + typeHeaderArr[j].CODE + "'>0/0" + "</span>";
					htmlStr += "</td>";
				} */

				htmlStr += "</tr>";
				
				$("#center_body").append(htmlStr);
				
			}
			setCenterInfo();
			interval.push(window.setInterval(setCenterInfo, configInfo.intervalTerm));
		});
	}
	
	function getLampImgSrc(obj) {
		var imgSrc;
		
		/* 알람램프 장애,주의:빨강, 문제없음:초록 */
		if (parseInt(obj.TYPE_ALL_CNT) === 0) {	//장비수가 없으면 회색
			imgSrc = cst.contextPath() + '/images/botton/icon_siren_gray.png';		
		//} else if (parseInt(typeAlmCnt) > 0 && parseInt(typeRating) === 2) {	//주의
		//	imgSrc = cst.contextPath() + '/images/botton/ico_err_yellow.gif';
		} else if (parseInt(obj.TYPE_ALM_CNT) > 0 && parseInt(obj.TYPE_ALM_STATUS) === 3) {	//확인
			imgSrc = cst.contextPath() + '/images/botton/ico_err_yellow.gif';
		} else if (parseInt(obj.TYPE_ALM_CNT) > 0 && parseInt(obj.TYPE_ALM_STATUS) === 2) { 	//장애
			imgSrc = cst.contextPath() + '/images/botton/ico_err.gif';
		} else {
			imgSrc = cst.contextPath() + '/images/botton/ico_ok.gif';
		}
		
		return imgSrc;
	}
	
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

//				interval.push(setInterval(function () {
					for (var i = 0, length = dataSources.length; i < length; i++) {
//						dataSources[i].read({value : groupCodes[i]});
						dataSources[i].read();
					}
//				}, 10000));
			})
//		});
	}


	// 센터현황 Column Html 생성
	function templateServerStatus(allCnt, conCnt, almCnt) {
		var html = '';
		html += ' <ul> ';
		html += ' 	<li>ㆍ전체<input type="text" value="' + allCnt + '" disabled /></li> ';
		html += '	<li>ㆍ연결<input type="text" value="' + conCnt + '" disabled /></li> ';
		html += ' 	<li>ㆍ장애<input type="text" value="' + almCnt + '" disabled /></li> ';
		html += ' </ul> ';
		return html;
	}

	// Server Type 이미지 및 수량 Html 생성
	function templateServerType(groupCode, typeCode, typeAllCnt, typeAlmCnt, typeConCnt, typeStatus) {
		var imgSrc;
		
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