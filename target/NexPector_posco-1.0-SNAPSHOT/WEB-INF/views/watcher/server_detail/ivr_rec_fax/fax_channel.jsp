<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/include.jsp" %>

<script type="text/javascript" src="<c:url value="/common/js/jquery-ui-1.10.3.custom/js/jquery-ui-1.10.3.custom.js"/>"></script>
<script type="text/javascript" src="<c:url value="/common/js/jquery-ui-1.10.3.custom/js/jquery.ui.datepicker-ko.js"/>"></script>
<link rel="stylesheet" href="<c:url value="/common/js/jquery-ui-1.10.3.custom/css/ui-lightness/jquery-ui-1.10.3.custom.css"/>"/>

<script type="text/javascript">

	var dataTimer;

	$(document).ready( function() {
		fn_init();
  	});

	function fn_init() {
    	fn_data_polling();
    	dataTimer = setInterval("fn_data_polling()", 10000);
	}

	function fn_data_polling() {

		$.ajax({
			url:'<c:url value="/watcher/server_detail/ivr_rec_fax/fax_channel.htm"/>',
	        type:"post",
	        data:{N_MON_ID : $('#N_MON_ID').val(), SORT_COLUMN : $('#SORT_COLUMN').val(), SORT_ORDER : $('#SORT_ORDER').val() },
	        dataType : "json",
	        success: function(RES){

	        	fn_col_init();

	        	if (RES.SORT_COLUMN != null && RES.SORT_ORDER != null) {
	        		var sortColumn = RES.SORT_COLUMN;
	        		var sortOrder = RES.SORT_ORDER;

	        		$("#SORT_COLUMN").val(sortColumn);
	        		$("#SORT_ORDER").val(sortOrder);

	        		fn_set_sort_col(sortColumn, sortOrder);

				} else {
					$("#SORT_COLUMN").val("");
					$("#SORT_ORDER").val("");
				}


	        	var inHtml = "";
	        	if (RES.GRID != null && RES.GRID.length > 0) {


					$.each(RES.GRID, function(INDEX, DATA) {

		        		inHtml += "<tr>";
		        		inHtml += "<td height=\"31\" align=\"center\" class=\"line_gray text11\">";

						var icon = DATA.STATUS;
						if (icon == 0) {
							inHtml += "<img src=\"${img2}/icon_o_gray.png\" alt=\"gray\" style=\"vertical-align:middle; margin-right:4px;\">";
						} else {
							inHtml += "<img src=\"${img2}/icon_o_green.png\" alt=\"green\" style=\"vertical-align:middle; margin-right:4px;\">";
						}
						inHtml += fn_empty(DATA.CH_NO_NAME);
						inHtml += "</td>";

		        		inHtml += "<td height=\"31\" align=\"center\" class=\"line_gray text11\">" + fn_empty(DATA.STATUS_NAME) + "</td>";
		        		inHtml += "<td height=\"31\" align=\"center\" class=\"line_gray text11\">" + fn_empty(DATA.CH_TYPE_NAME) + "</td>";
		        		inHtml += "<td height=\"31\" align=\"center\" class=\"line_gray text11\">" + fn_empty(DATA.START_TIME) + "</td>";
		        		inHtml += "<td height=\"31\" align=\"center\" class=\"line_gray text11\">" + fn_empty(DATA.STOP_TIME) + "</td>";

		        		inHtml += "<td height=\"31\" align=\"center\" class=\"line_gray text11\">" + fn_empty(DATA.ANI) + "</td>";
		        		inHtml += "<td height=\"31\" align=\"center\" class=\"line_gray text11\">" + fn_empty(DATA.DID) + "</td>";
		        		inHtml += "<td height=\"31\" align=\"center\" class=\"line_gray text11\">" + fn_empty(DATA.DIAL_NUM) + "</td>";

		        		inHtml += "<td height=\"31\" align=\"center\" class=\"line_gray text11\">" + fn_empty(DATA.TOTAL_SEND_CALL) + "</td>";
		        		inHtml += "<td height=\"31\" align=\"center\" class=\"line_gray text11\">" + fn_empty(DATA.TOTAL_RECV_CALL) + "</td>";
		        		inHtml += "<td height=\"31\" align=\"center\" class=\"line_gray text11\">" + fn_empty(DATA.MESSAGE) + "</td>";
		        		inHtml += "</tr>";
					});

	        	} else {

	        		inHtml += "<tr>";
	        		inHtml += "<td width=\"100%\"  height=\"31\" align=\"center\" class=\"line_gray text11\" colspan=\"11\">검색된 데이터가 없음</td>";
	        		inHtml += "</tr>";
	        	}
	        	$("#result_grid").empty().html(inHtml);
	        	inHtml = "";

	        },
	        error: function(res,error) {
	            // alert("에러가 발생했습니다."+error);
	        }
		});

	}

	function fn_empty(value) {
		if(value == null || value == "") {
			return "&nbsp;";
		}
		return value;
	}

	function fn_set_sort_col(colName, colOrder) {
		var name = ("#col_" + colName).toLowerCase();
		var text = $(name).text();
		if (colOrder == "ASC") {
			$(name).text((text + "▲"));
		} else {
			$(name).text((text + "▼"));
		}
	}

	function fn_col_init() {
		$("#col_ch_no_name").text("채널");
		$("#col_status_name").text("상태");
		$("#col_ch_type_name").text("타입");
		$("#col_start_time").text("시작시각");
		$("#col_stop_time").text("종료시각");
		$("#col_ani").text("ANI");
		$("#col_did").text("DID");
		$("#col_dial_num").text("발신번호");
		$("#col_total_send_call").text("발신콜수");
		$("#col_total_recv_call").text("수신콜수");
		$("#col_message").text("메시지");
	}

	function fn_column_click(col) {
		clearInterval(dataTimer);
		dataTimer = null;

		var sortColumn = $("#SORT_COLUMN").val();
		var sortOrder = $("#SORT_ORDER").val();

		if (col != sortColumn) {
			$("#SORT_COLUMN").val(col);
			sortOrder = "";
		}

		if (sortOrder == "ASC") {
			$("#SORT_ORDER").val("DESC");
		} else {
			$("#SORT_ORDER").val("ASC");
		}

		fn_init();
	}

</script>

<body style="background-color: transparent;">

<input type="hidden" id="N_MON_ID" name="N_MON_ID" value="${param.N_MON_ID}">
<input type="hidden" id="SORT_COLUMN" name="SORT_COLUMN" value="">
<input type="hidden" id="SORT_ORDER" name="SORT_ORDER" value="">

<!-- SUB TAB 시작 -->
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td background="${img2}/tab_lc.jpg">&nbsp;</td>
    <td bgcolor="#FFFFFF" style="padding:15px 20px 20px 20px">



      <!-- 서비스정보 시작 -->
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <colgroup>
          <col width="6%" />
          <col width="7%" />
          <col width="7%" />
          <col width="13%"/>
          <col width="13%"/>
          <col width="5%" />
          <col width="5%" />
          <col width="9%" />
          <col width="7%" />
          <col width="7%" />
          <col width="21%"/>
        </colgroup>
        <thead>
          <tr align="center">
            <td id="col_ch_no_name"      style="cursor:pointer;" onclick="fn_column_click('CH_NO_NAME')"      height="34" background="${img2}/table_title.jpg" class="b text11 gray">채널</td>
            <td id="col_status_name"     style="cursor:pointer;" onclick="fn_column_click('STATUS_NAME')"     background="${img2}/table_title.jpg" class="b text11 gray">상태</td>
            <td id="col_ch_type_name"    style="cursor:pointer;" onclick="fn_column_click('CH_TYPE_NAME')"    background="${img2}/table_title.jpg" class="b text11 gray">타입</td>
            <td id="col_start_time"      style="cursor:pointer;" onclick="fn_column_click('START_TIME')"      background="${img2}/table_title.jpg" class="b text11 gray">시작시각</td>
            <td id="col_stop_time"       style="cursor:pointer;" onclick="fn_column_click('STOP_TIME')"       background="${img2}/table_title.jpg" class="b text11 gray">종료시각</td>
            <td id="col_ani"             style="cursor:pointer;" onclick="fn_column_click('ANI')"             background="${img2}/table_title.jpg" class="b text11 gray">ANI</td>
            <td id="col_did"             style="cursor:pointer;" onclick="fn_column_click('DID')"             background="${img2}/table_title.jpg" class="b text11 gray">DID</td>
            <td id="col_dial_num"        style="cursor:pointer;" onclick="fn_column_click('DIAL_NUM')"        background="${img2}/table_title.jpg" class="b text11 gray">발신번호</td>
            <td id="col_total_send_call" style="cursor:pointer;" onclick="fn_column_click('TOTAL_SEND_CALL')" background="${img2}/table_title.jpg" class="b text11 gray">발신콜수</td>
            <td id="col_total_recv_call" style="cursor:pointer;" onclick="fn_column_click('TOTAL_RECV_CALL')" background="${img2}/table_title.jpg" class="b text11 gray">수신콜수</td>
            <td id="col_message"         style="cursor:pointer;" onclick="fn_column_click('MESSAGE')"         background="${img2}/table_title.jpg" class="b text11 gray">메시지</td>
          </tr>
        </thead>
        <tfoot>
          <tr>
            <td colspan="11" bgcolor="c2c3c5"><img src="${img2}/dot.png"></td>
          </tr>
          <tr>
            <td colspan="11">&nbsp;</td>
          </tr>
        </tfoot>
        <tbody id="result_grid">
          <tr>
            <td height="31" align="center" class="line_gray text11">&nbsp;</td>
            <td height="31" align="center" class="line_gray text11">&nbsp;</td>
            <td height="31" align="center" class="line_gray text11">&nbsp;</td>
            <td height="31" align="center" class="line_gray text11">&nbsp;</td>
            <td height="31" align="center" class="line_gray text11">&nbsp;</td>
            <td height="31" align="center" class="line_gray text11">&nbsp;</td>
            <td height="31" align="center" class="line_gray text11">&nbsp;</td>
            <td height="31" align="center" class="line_gray text11">&nbsp;</td>
            <td height="31" align="center" class="line_gray text11">&nbsp;</td>
            <td height="31" align="center" class="line_gray text11">&nbsp;</td>
            <td height="31" align="center" class="line_gray text11">&nbsp;</td>
          </tr>
        </tbody>
      </table>
      <!-- 서비스정보 끝 -->



    </td>
    <td background="${img2}/tab_rc.jpg">&nbsp;</td>
  </tr>
  <tr>
    <td><img src="${img2}/tab_lb.jpg"></td>
    <td height="4" background="${img2}/tab_ceb.jpg"><img src="${img2}/dot.png"></td>
    <td><img src="${img2}/tab_rb.jpg"></td>
  </tr>
</table>
<!-- SUB TAB 끝 -->
</body>