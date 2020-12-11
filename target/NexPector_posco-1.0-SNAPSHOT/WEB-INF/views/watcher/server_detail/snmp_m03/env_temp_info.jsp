<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style class="removeStyle" type="text/css">
	.red { color:#ef3435 }
	.b { font-weight:bold }
	.bblue { color:#276fe6 }

	.pl21 { padding-left:21px }
	.text14 {font-size:14px }

	.black {color:#000000;}
	.tem_view { border:2px solid #e9e9e9; }

	.servicebox_fax01 ul{margin-left:0px;}
	.servicebox_fax01 li{float:left; width:135px; height:57px; margin-left:15px;}
</style>

<script>
	$(function(){
		var pMonId = '${param.N_MON_ID}';

		$(document).ready(function() {
			var dataSource = new kendo.data.DataSource({
				transport		: {
					read		: {
						type		: 'post',
						dataType	: 'json',
						contentType	: 'application/json;charset=UTF-8',
						url 		: cst.contextPath() + "/watcher/kendoPagination_M03EnvTempInfoLstQry.htm",
						data 		: function(data) {
							return {
								'N_MON_ID' : pMonId
							};
						}
					},
					parameterMap: function (data, opperation) {
						return JSON.stringify(data);
					}
				},
				schema			: {
					data	: function(data) {
						return data;
					},
					total 	: function(response) {
						return response.length > 0 ? response[0].TOTAL_COUNT : 0;
					}
				},
				pageSize		: 8,
				serverPaging	: true
			});

			$("#temp_pager").kendoPager({
				dataSource: dataSource,
				pageSize : 5,
				messages : {
					empty	: "<strong>No data</strong>",
					display : "<span>전체 <strong style='color: #f35800;'>{2}</strong> 개 항목 중 <strong style='color: #f35800;'>{0}~{1}</strong> 번째 항목 출력</span>"
				}
			});

			$("#temp_listView").kendoListView({
				dataSource : dataSource,
				template   : kendo.template($("#temp_template").html())
			});

		});
	});

</script>

<script type="text/x-kendo-template" id="temp_template">
	<div class="product" style="float: left; width: 25%;">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td align="center" valign="top" class="tem_view" style="padding:10px 0 10px 0;"><table width="225" border="0" cellspacing="0" cellpadding="0">
					<tr>
						# if (parseInt(N_STATE) === 1) {
						# <td class="text14 b pl21 black">#: S_DESC #</td> #
						} else {
						# <td class="text14 b pl21 red">#: S_DESC #</td> #
						} #
					</tr>
					<tr>
						<td class="pl21" style="padding-bottom:8px;">Last Show Down #: N_LAST_SHUTDOWN #</td>
					</tr>
					<tr>
						# if (parseInt(N_STATE) === 1) {
						# <td height="30" valign="top" background="<c:url value="/common/images/watcher/tem_img.jpg"/>" style="padding:17px 0 0 62px;"> #
						} else {
						# <td height="30" valign="top" background="<c:url value="/common/images/watcher/tem_img_warning.jpg"/>" style="padding:17px 0 0 62px;"> #
						} #
							<table border="0" cellspacing="0" cellpadding="0" style="width: #= (parseInt(N_STATUS_VALUE) + 0.000000001) / (parseInt(N_THRES_HOLD) + 0.000000001) * 90 #%; max-width: 100%;">
								<tr>
									# if (parseInt(N_STATE) === 1) {
									# <td width="97%" height="7" background="<c:url value="/common/images/watcher/tem_img_low.jpg"/>"><img src="<c:url value="/common/images/watcher/dot.png"/>"></td> #
									} else {
									# <td width="97%" height="7" background="<c:url value="/common/images/watcher/tem_img_warning_low.jpg"/>"><img src="<c:url value="/common/images/watcher/dot.png"/>"></td> #
									} #

									# if (parseInt(N_STATE) === 1) {
									# <td background="<c:url value="/common/images/watcher/tem_img_h.jpg"/>"><img src="<c:url value="/common/images/watcher/dot.png"/>"></td> #
									} else {
									# <td background="<c:url value="/common/images/watcher/tem_img_warning_h.jpg"/>"><img src="<c:url value="/common/images/watcher/dot.png"/>"></td> #
									} #
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td align="center" class="b"><span class="bblue text14">현재 #: N_STATUS_VALUE #℃</span> / 한계점 #: N_THRES_HOLD #℃</td>
					</tr>
				</table></td>
			</tr>
		</table>
	</div>
</script>

<div id="temp_listView"></div>
<div id="temp_pager" class="k-pager-wrap"></div>
