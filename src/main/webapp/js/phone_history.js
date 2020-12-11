// Grid Header
var _txtRight = {style:'text-align:right'},
    _txtLeft = {style:'text-align:left'},
    _txtCenter = {style:'text-align:center'};

var _errorColumns = [
	{headerTemplate: '<input type="checkbox" id="all_check" name="ALL_CHECK" value="Y"/>', width:'5%', attributes:_txtCenter, headerAttributes:_txtCenter, sortable : false, template:kendo.template($('#checkboxTemplate').html())},
    {field:'D_UPDATE_TIME', title:'발생시각', width:'120px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_ALM_STATUS_NAME', title:'상태', width:'120px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_LOCATION', title:'지역', width:'120px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_NAME', title:'지점명', width:'120px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_RUNNING', title:'러닝명', width:'80px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_IP_ADDRESS', title:'IP Address', width:'100px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'S_EXT_NUM', title:'전화번호', width:'100px', attributes:_txtCenter, headerAttributes:_txtCenter},
    {field:'D_SKIP_TIME', title:'미표시기간', width:'200px', attributes:_txtLeft, headerAttributes:_txtCenter}
];

var kendoGridColumns = function() {
    return {
        error : function() {
            return _errorColumns;
        }
    }
}