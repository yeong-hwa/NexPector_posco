<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="/WEB-INF/views/include/include.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<%--해당 화면의 url --%>
<c:set var="app_url"><c:url value='/admin/go_prgm.mon.vg_mng'/></c:set>
<c:set var="app_nm" value="vg_mng"/>

<%--해당 화면의 제목 --%>
<c:set var="app_title_name" value="VoiceGateway 담당자 관리"/>

<script>
	<%-- 데이터의 키 값(Update 및 상세 조회시 사용할 Key 값 여러개일경우 세미콜론(;) 으로 구분 --%>
	var v_key_col = "N_MON_ID;S_USER_NAME;S_USER_PHONE";

	<%-- 데이터의 표현할 컬럼 및 컬럼에 대한 이름 table 테그 등 에서 사용 --%>
	var v_lst_head = [
		["감시장비ID","10%","N_MON_ID"]
		, ["감시장비명","15%","S_MON_NAME"]
		, ["서버그룹명","25%","S_GROUP_NAME"]
		, ["담당자 명","20%","S_USER_NAME"]
		, ["담당자 연락처","30%","S_USER_PHONE"]
	];
</script>
<body>
	<form name="frm" method="post">
		<input type="hidden" name="app_url" value="${app_url}">
		<input type="hidden" name="app_nm" value="${app_nm}">
		<input type='hidden' name='order_id' value='${param.order_id}'>
		<input type='hidden' name='asc_desc' value='${param.asc_desc}'>
		<!-- Iframe 부분 -->
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td height="47" background="${img1}/sotitle_bg.jpg" class="b f14"><img src="${img1}/sotitle_icon.jpg" hspace="3" align="absmiddle">
          	${app_title_name}
          </td>
        </tr>
        <tr>
          <td style="padding:10px 0 10px 0">
          <!-- 검색 start -->
          <table width="100%" border="0" cellspacing="0" cellpadding="0" id="search_data">
              <tr>
                <td height="45" align="center" class="box">
                	<!-- search 이미지 -->
                	<img src="${img1}/img_search.jpg" align="absmiddle">

                	<span style="vertical-align:top">
                	<img src="${img1}/icon_arrow.png" align="absmiddle">
                	장비명
                	<input type="text" name="S_MON_NAME" class="input_search" id="textfield" style="width:90px;height:20px">
                	<img src="${img1}/icon_arrow.png" align="absmiddle">
                	담당자 명
                		<input type="text" name="S_USER_NAME" style="width:100px;" value="">
                	<img src="${img1}/icon_arrow.png" align="absmiddle">
                	담당자 연락처
                		<input type="text" name="S_USER_PHONE" style="width:100px;" value="">
                	</span>
                  	<img onclick="javascript:fn_retrieve('1')" class="btn_search" src="${img1}/btn_search.png" width="78" height="26" hspace="10" align="absmiddle">
                  </td>
              </tr>
            </table>
            <!-- 검색 end -->
            </td>
        </tr>
        <tr>
          <td height="30" align="right" valign="top">
          	<input style="width:70px; height:23px;" onClick="fn_insert()" type="button" value="등록"/>
            &nbsp;
          </td>
        </tr>
        <tr>
          <td>

			<div id="div_page_list">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
	              <tr align="center" class="cls_header"></tr>
            	</table>
			</div>
			<input type="hidden" name="nowpage" value="<c:if test='${param.nowpage==null}'>1</c:if>${param.nowpage}">
			<input type="hidden" name="pagecnt" value="15">
			<input type="hidden" name="page_totalcnt" value="0">
			<div id="paging"></div>
            </td>
        </tr>
      </table>
	</form>
</body>
</html>

<!--공통 스크립트 부분 -->
<script>
	$(function(){
		fn_retrieve();
		$(v_lst_head).each(function(){
			var asc_desc_str = "";
			if('${param.order_id}' == this[2]) asc_desc_str = '${param.asc_desc}'=='ASC'?"▲":"▼";

			var tmp_append_str = '<td width="' + this[1] + '" class="table_title text11 b"><label style="cursor:pointer;" onclick="fn_head_click(this,\'' + this[2] + '\')">' + this[0] + asc_desc_str + '</label></td>';
			$(".cls_header").append(tmp_append_str);
		});
	});
	//테이블 소트 기능
	function fn_head_click(obj, col)
	{
		var head_txt = $(obj).text();
		if(head_txt.indexOf("▲") > -1){
			$("input[name='asc_desc']").val("DESC");
			$(".cls_header td").each(function(){
				$(this).children("label").text($(this).children("label").text().replace("▲","").replace("▼",""));
			});
			$(obj).text($(obj).text()+"▼");
		}
		else if(head_txt.indexOf("▼") > -1){
			$("input[name='asc_desc']").val("ASC");
			$(".cls_header td").each(function(){
				$(this).children("label").text($(this).children("label").text().replace("▲","").replace("▼",""));
			});
			$(obj).text($(obj).text()+"▲");
		}
		else{
			$("input[name='asc_desc']").val("ASC");
			$(".cls_header td").each(function(){
				$(this).children("label").text($(this).children("label").text().replace("▲","").replace("▼",""));
			});
			$(obj).text($(obj).text()+"▲");
		}

		$("input[name='order_id']").val(col);

		fn_retrieve();
	}

	<!-- 조회 -->
	function fn_retrieve(spage)
	{
		// 검색후 페이지 조정 function
		if(spage=="1"){
			$("form[name='frm'] input[name='nowpage']").val("1");
		}

		$("body").block({	message: "<img width='230' height='10' src='${img1}/loader.gif'>" });
		var param = $("form[name='frm']").serialize();
		$.post("<c:url value='/page_${app_nm}.select_list.htm'/>", param, function(str){
			var data = $.parseJSON(str);
			$(".cls_list").remove();

			var tdsize = $(data.data).size();

			if(tdsize>=1){
				$(data.data).each(function(idx){
					<!-- 검색된 데이타가 있을때 시작 -->
					var tmp_obj = this;
					var list_body_str = "";

					$(v_lst_head).each(function(){
						list_body_str += "<td class='line_gray' " + (this[3]==null?"":this[3]) + ">&nbsp;" + (eval("tmp_obj."+this[2])==null?"":eval("tmp_obj."+this[2])) + "&nbsp;</td>";
					});

					$("<tr/>", {
						'class': "line_gray cls_list"
						, align: "center"
						, html: list_body_str
						, style: "cursor:pointer"
					}).click(function(){
						//클릭시 상세 조회 화면 및 수정 화면
						var upd_param = "UPD_FLAG=Y&nowpage=" + $("form[name='frm'] input[name='nowpage']").val();

						var tmp_arr_col = v_key_col.split(";");
						$(tmp_arr_col).each(function(){
							upd_param += "&" + this + "=" + eval("tmp_obj."+this);
						});
						//+ "&" + v_key_col + "=" + eval("tmp_obj."+v_key_col);

						var tmp_arr_obj = new Array();
						$("#search_data input, #search_data select").each(function(idx){
							tmp_arr_obj[idx] = "<input type='hidden' name='"+$(this).attr("name")+"' value='"+$(this).val()+"'>";
						});

						$("<form name='frm_upd' method='post' action='${app_url}.insert.htm'/>").append(
							[
								"<input type='hidden' name='UPD_FLAG' value='Y'>"
								, "<input type='hidden' name='nowpage' value='" + $("form[name='frm'] input[name='nowpage']").val() + "'>"
								, "<input type='hidden' name='app_nm' value='${app_nm}'>"
								, "<input type='hidden' name='app_url' value='${app_url}'>"
								, "<input type='hidden' name='N_MON_ID' value='" + tmp_obj.N_MON_ID + "'>"
								, "<input type='hidden' name='S_USER_NAME' value='" + tmp_obj.S_USER_NAME + "'>"
								, "<input type='hidden' name='S_USER_PHONE' value='" + tmp_obj.S_USER_PHONE + "'>"
								, "<input type='hidden' name='UPD_PARAM' value='" + upd_param + "'>"
							]
						).append(tmp_arr_obj).appendTo("body");

						$("form[name='frm_upd']").submit();
					}).appendTo("#div_page_list table");


				});
			}
			<!-- 검색된 데이타가 있을때 종료 -->
			<!-- 검색된 데이타가 없을때 시작 -->WW
			else {
				var array = [{tag: "1"}];
				var list_body_str = "";
				jQuery.each(array, function(idx, value){
					var tmp_obj = this;
					list_body_str += "<td align='center' colspan='7'>&nbsp; 검색된 데이타가 없음 &nbsp;</td>";
				})

				$("<tr/>", {
					'class': "line_gray cls_list"
					, align: "center"
					, html: list_body_str
					, style: "cursor:pointer"
				}).appendTo("#div_page_list table");
			}
			<!-- 검색된 데이타가 없을때 종료 -->
			/*
			*		페이징 처리
			*/
			$("input[name='page_totalcnt']").val(data.cnt);
			param = $("form[name='frm']").serialize();
			$.post("<c:url value='/pageNavigate.htm'/>", param, function(str){
				$("#paging").html(str);
			});

			$(".cls_list").hover(function(){
				$(this).css("backgroundColor", "#EFEFEF");
			}, function(){
				$(this).css("backgroundColor", "");
			});

			$("body").unblock();
		});
	}

	<!-- 추가 -->
	function fn_insert()
	{
		frm.target = "";
		frm.action="${app_url}.insert.htm";
		frm.submit();
	}

	<!-- 추가 -->
	function fn_excel()
	{
		frm.target = "";
		frm.action=".excel.neonex";
		frm.submit();
	}
</script>