<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style class="removeStyle" type="text/css">
	.red { color:#ef3435 }
	.b { font-weight:bold }
	.pl10 { padding-left:10px }
	.green {color:#009933; }
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
						url 		: cst.contextPath() + "/watcher/kendoPagination_M03EnvVoltInfoLstQry.htm",
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

			$("#volt_pager").kendoPager({
				dataSource: dataSource,
				pageSize : 5,
				messages : {
					empty	: "<strong>No data</strong>",
					display : "<span>전체 <strong style='color: #f35800;'>{2}</strong> 개 항목 중 <strong style='color: #f35800;'>{0}~{1}</strong> 번째 항목 출력</span>"
				}
			});

			$("#volt_listView").kendoListView({
				dataSource : dataSource,
				template   : kendo.template($("#volt_template").html())
			});

		});
	});

</script>

<script type="text/x-kendo-template" id="volt_template">
	<div class="product" style="float: left; width: 25%;">
		<table width="100%" height="230" border="2" cellspacing="0" cellpadding="0" style="border-color: \\#e9e9e9;">
			<tr>
				<td style="padding:10px;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td colspan="2" class="b" align="center">#: S_DESC #</td>
						</tr>
						<tr>
							<td width="30%" align="right" style="padding:15px 0 10px 0;">
								# if (parseInt(N_STATE) === 1) {
								# <img src="<c:url value="/common/images/watcher/volt_img.jpg"/>" alt="정상" /> #
								} else {
								# <img src="<c:url value="/common/images/watcher/volt_img_warning.jpg"/>" alt="위험" /> #
								} #
							</td>
							<td valign="bottom" style="padding:15px 0 30px 0;">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="25" rowspan="3" valign="bottom">
											# var value = (parseInt(N_STATUS_VALUE) - parseInt(N_THRES_HOLD_LOW) + 0.000000001) / (parseInt(N_THRES_HOLD_HIGH) - parseInt(N_THRES_HOLD_LOW) + 0.000000001) * 100
											var value1 = (parseInt(N_STATUS_VALUE) - parseInt(N_THRES_HOLD_LOW) + 0.000000001) / (parseInt(N_THRES_HOLD_HIGH) - parseInt(N_THRES_HOLD_LOW) + 0.000000001) * 10 #
											<strong>#= value #%</strong>
											# if (parseInt(N_STATE) === 1) {
											# <span style="background-image:url('<c:url value="/common/images/watcher/volt_gauge.jpg"/>'); width:25px;height: #= value #0;"/> #
											} else {
											# <span style="background-image:url('<c:url value="/common/images/watcher/volt_gauge_warning.jpg"/>'); width:25px;height: #= value1 #0;"/> #
											} #
										</td>
										# if (parseInt(N_STATE) === 1) {
										# <td class="pl10 green b">최고 #: N_THRES_HOLD_HIGH_V # V</td> #
										} else {
										# <td class="pl10 red b">최고 #: N_THRES_HOLD_HIGH_V # V</td> #
										} #
									</tr>
									<tr>
										# if (parseInt(N_STATE) === 1) {
										# <td class="pl10 green b">현재 #: N_STATUS_VALUE_V # V</td> #
										} else {
										# <td class="pl10 red b">현재 #: N_STATUS_VALUE_V # V</td> #
										} #
									</tr>
									<tr>
										# if (parseInt(N_STATE) === 1) {
										# <td valign="bottom" class="pl10 green b">최저 #: N_THRES_HOLD_LOW_V # V</td> #
										} else {
										# <td valign="bottom" class="pl10 red b">최저 #: N_THRES_HOLD_LOW_V # V</td> #
										} #
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
</script>

<div id="volt_listView"></div>
<div id="volt_pager" class="k-pager-wrap"></div>
