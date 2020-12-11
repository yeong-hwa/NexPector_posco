<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- stitle -->
<div class="avaya_stitle1" style="float: none;">
	<div class="st_under"><h4>IP전화기 정보</h4></div>
</div>
<!-- stitle // -->

<!-- stitle // -->
<div class="ip-phone">
	<form id="searchFrm" name="searchFrm">
		<div class="ip_listB" style="float: none; width: 100%">
			<ul>
				<li class="_left">
					<%--<strong>영업점</strong>
					<input type="text" id="branch_code" name="BRANCH_CODE" />--%>
					<strong>내선번호</strong>
					<input type="text" id="ext_num" name="S_EXT_NUM" size="" style="height:18px;"/>
					<strong>IP</strong>
					<input type="text" id="ip_address" name="S_IPADDRESS" size="" style="height:18px;"/>
					<strong>MAC_ADDR</strong>
					<input type="text" id="mac_address" name="S_MACADDRESS" size="" style="height:18px;"/>
					<a href="#" onclick="fn_retrieve(event);"><img src="<c:url value="/images/botton/search.jpg"/>" alt="검색" /></a>
				</li>
				<li class="_right"></li>
			</ul>
		</div>
	</form>
</div>

<!-- table_typ2-3 -->
<div id="snmpM02IpPhoneGrid" class="table_typ2-3"></div>
<!-- table_typ2-3 // -->

<script type="text/javascript">

	var pMonId = '${param.N_MON_ID}';

	$(document).ready(function() {
		var dataSource = new kendo.data.DataSource({
            transport		: {
                read		: {
                	type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/watcher/kendoPagination_M02PhoneInfoLstQry.htm",
					data 		: function(data) {
						return {
							'N_MON_ID' 		 : pMonId,
							'S_EXT_NO' 	 	 : $('#ext_num').val(),
							'S_INET_ADDR' 	 : $('#ip_address').val(),
							'S_MAC_ADDR' 	 : $('#mac_address').val(),
							'BRANCH_CODE' 	 : $('#branch_code').val()
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
            pageSize		: cst.countPerPage(),
            serverPaging	: true,
            serverSorting	: true
        });
		
		$("#snmpM02IpPhoneGrid")
	        .kendoGrid($.extend({}, kendoGridDefaultOpt, {
	            dataSource	: dataSource,
	            dataBound	: gridDataBound,
	            sortable	: {
	                mode : 'multiple',
	                allowUnsort : true
	            },
	            scrollable  : false,
	            columns		: [
   					{field:'ALM_CNT', title:'경고', width:'5%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}, template:'#= fn_print_icon(N_STATUS) #'},
				    {field:'S_STATUS', title:'등록상태', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}, template:'#= fn_change_text_color(N_STATUS, S_STATUS, null, null) #'},				    
				    {field:'S_EXT_NO', title:'내선번호', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				    {field:'S_IP', title:'IP', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				    {field:'S_MAC_ADDR', title:'MAC_ADDR', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				    {field:'S_STATUS_REASON', title:'현재상태', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}, template:'#= fn_change_text_color(null, null, N_STATUS_REASON, S_STATUS_REASON) #'},
				    {field:'S_DESC', title:'내용', width:'30%', attributes:{style:'text-align:left'}, headerAttributes:{style:'text-align:center'}, sortable: false}
   				]
	        }));
	});

	function fn_retrieve(event) {
		event.preventDefault ? event.preventDefault() : event.returnValue = false;
		$("#snmpM02IpPhoneGrid").data('kendoGrid').setDataSource(getGridDataSource());
	}

	function getGridDataSource() {
		return new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/watcher/kendoPagination_M02PhoneInfoLstQry.htm",
					data 		: function(data) {
						return {
							'N_MON_ID' 		 : pMonId,
							'S_EXT_NO' 	 	 : $('#ext_num').val(),
							'S_INET_ADDR' 	 : $('#ip_address').val(),
							'S_MAC_ADDR' 	 : $('#mac_address').val(),
							'BRANCH_CODE' 	 : $('#branch_code').val()
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
			pageSize		: cst.countPerPage(),
			serverPaging	: true,
			serverSorting	: true
		});
	}

	function fn_print_icon(status) {
		var img = status == 3 ? 'icon_waring_on.gif' : 'icon_waring_off.gif';
		return '<img src="' + cst.contextPath() + '/common/images/watcher' + '/' + img + '">'
	}

	function fn_change_text_color(n_status, s_status, n_reason, s_reason) {
		if (n_status != null) {
			if (parseInt(n_status) === 2) {
				return '<b style="color:blue">' + s_status + '</b>';
			}
			else {
				return '<b style="color:red">' + s_status + '</b>';
			}
		}
		else if (n_reason != null) {
			if (parseInt(n_reason) === 0) {
				return '<b style="color:blue">' + s_reason + '</b>';
			}
			else {
				return '<b style="color:red">' + s_reason + '</b>';
			}
		}
	}
</script>
