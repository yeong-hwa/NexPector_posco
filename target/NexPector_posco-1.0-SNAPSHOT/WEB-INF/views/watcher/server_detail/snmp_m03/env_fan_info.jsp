<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>

<style class="removeStyle" type="text/css">
	#fan_info_listView { padding: 10px 5px; margin-bottom: -1px; }
	.k-listview:after { content: "."; display: block; height: 0; clear: both; visibility: hidden; }
	.product { float: left; position: relative; height: 110px; margin: 0 5px; padding: 0; }
	.product img { width: 74px; height: 75px; }
	.product h3 { margin: 0; padding: 3px 5px 0 0; max-width: 72px; overflow: hidden; line-height: 0.9em;font-size: .9em; font-weight: normal; text-transform: uppercase; color: #575c5f; font-weight: bold; text-align: center; }
</style>

<script type="text/javascript">

	var pMonId = '${param.N_MON_ID}';

	$(document).ready(function() {
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/watcher/kendoPagination_M03EnvFanInfoLstQry.htm",
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
			pageSize		: 20,
			serverPaging	: true
		});

		$("#fan_info_pager").kendoPager({
			dataSource: dataSource,
			pageSize : 5,
			messages : {
				empty	: "<strong>No data</strong>",
				display : "<span>전체 <strong style='color: #f35800;'>{2}</strong> 개 항목 중 <strong style='color: #f35800;'>{0}~{1}</strong> 번째 항목 출력</span>"
			}
		});

		$("#fan_info_listView").kendoListView({
			dataSource : dataSource,
			template   : kendo.template($("#fan_info_template").html())
		});

	});
</script>

<script type="text/x-kendo-template" id="fan_info_template">
	<div class="product">
		# if (parseInt(N_STATE) === 1) {
			# <img src="<c:url value="/common/images/watcher/fan_img.jpg"/>" alt="정상" /> #
		} else {
			# <img src="<c:url value="/common/images/watcher/fan_warning.gif"/>" alt="위험" /> #
		} #
		<h3>#: S_DESC #</h3>
	</div>
</script>

<div id="fan_info_listView"></div>
<div id="fan_info_pager" class="k-pager-wrap"></div>