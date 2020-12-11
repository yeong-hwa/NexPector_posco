<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- stitle -->
<div class="avaya_stitle1" style="float: none;">
    <div class="st_under"><h4>담당자 정보</h4></div>
</div>
<!-- stitle // -->
<!-- table_typ2-2 -->
<div id="contact_info_grid" class="table_typ2-2" style="width: 50%;">
</div>
<!-- table_typ2-3 // -->

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>

<script type="text/javascript">

    var pMonId = '${param.N_MON_ID}';

    $(function() {
        var dataSource = new kendo.data.DataSource({
            transport		: {
                read		: {
                    type		: 'post',
                    dataType	: 'json',
                    url 		: cst.contextPath() + "/watcher/lst_server_detail.contactInfoLstQry.htm",
                    data 		: function(data) {
                        return { 'N_MON_ID' : pMonId };
                    }
                }
            },
            schema			: {
                data	: function(data) {
                    return $.isArray(data) ? data : [];
                },
                total 	: function(response) {
                    return response.length > 0 ? response[0].TOTAL_COUNT : 0;
                }
            }
        });

        $("#contact_info_grid")
            .kendoGrid($.extend({}, kendoGridDefaultOpt, {
                dataSource	: dataSource,
                dataBound   : function(e) {
                    var grid = e.sender;
                    if (grid.dataSource.total() == 0) {
                        var colCount = grid.columns.length;
                        $(e.sender.wrapper)
                                .find('tbody')
                                .append('<tr class="kendo-data-row"><td colspan="' + colCount + '" style="text-align:center;">담당자 정보가 존재하지 않습니다.</td></tr>');
                    }
                },
                sortable	: false,
                pageable    : false,
                columns		: [
                    {field:'S_DEPART', title:'부서', width:'33%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
                    {field:'S_NAME', title:'이름', width:'33%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
                    {field:'S_PHONE', title:'연락처', width:'34%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}}
                ]
            }));
    });
</script>
