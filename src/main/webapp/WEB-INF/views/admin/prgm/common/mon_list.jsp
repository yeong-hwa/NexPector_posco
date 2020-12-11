<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- 검색영역 -->
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<dd>
					<select name="SEARCH_TYPE" value="${param.SEARCH_TYPE}" id="SEARCH_TYPE">
                		<option value="ID">장비ID</option>
                		<option value="NM">장비명</option>
                		<option value="IP">장비IP</option>
                	</select>
                	<input type="text" name="SEARCH_KEYWORD" id="SEARCH_KEYWORD" value="${param.SEARCH_KEYWORD}" class="int_f input_search"/>
				</dd>
			</dl>
			<!-- 검색항목 // -->

			<!-- 버튼 -->
			<span class="his_search_bt"><a href="#" id="search"><img src="<c:url value="/images/botton/search_1.jpg"/>" alt="검색" /></a></span>
			<!-- 버튼 // -->
		</li>
		<li class="rightbg">&nbsp;</li>
	</ul>
</div>
<!-- 검색영역 //-->
<div id="mon_info_grid">
</div>

<script type="text/javascript">

	var grid;

    $(document).ready(function() {
		initGrid();
		initEvent();
	});
    
 	// Event 등록
	function initEvent() {
		
		$(".input_search").keypress(function(event){
			if(kendo.keys.ENTER === event.keyCode) {
				event.preventDefault();
				$("#search").click();
			}
		});
		
		$('#search').on('click', function(event) {
			event.preventDefault();
			grid.dataSource.read();
		});
		
	}

    function initGrid() {
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/kendoPagination_mon_info.select_list.htm",
					data 		: function(data) {
						return {
							'SEARCH_TYPE'   : $.trim($('#SEARCH_TYPE').val()),
							'SEARCH_KEYWORD': $.trim($('#SEARCH_KEYWORD').val())
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
					var totalCount = response.length > 0 ? response[0].TOTAL_COUNT : 0;
					return totalCount;
				}
			},
			pageSize		: cst.countPerPage(),
			serverPaging	: true,
			serverSorting	: true
		});

		grid = $("#mon_info_grid")
					.kendoGrid($.extend({}, kendoGridDefaultOpt, {
						dataSource	: dataSource,
						dataBound	: function(e) {
							gridDataBound(e);
							dblclickMonGrid && dblclickMonGrid.apply(this, [grid]); // 이 페이지를 호출하는 각 페이지에서 구현해야함.
						},
						resizable	: false,
						sortable	: {
							mode 		: 'multiple',
							allowUnsort : true
						},
						columns		: [
							{field:'N_MON_ID', 	 title:'장비ID', width:'30%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
							{field:'S_MON_NAME', title:'장비명', width:'40%', attributes:{style:'text-align:left'}, 	  headerAttributes:{style:'text-align:center'}},
							{field:'S_MON_IP', 	 title:'장비IP', width:'30%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}}
						]
					})).data('kendoGrid');
    }
</script>