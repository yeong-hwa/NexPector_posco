var cst;
var timeout = [];
var interval = [];
var global = {
    clearTimeout : _clear
};

/*$(function() {
    $('a').on('click', function() {
        _clear();
    });
});*/

function _clear() {
    var timeoutLength = timeout.length;
    for (var i = 0; i < timeoutLength; i++) {
        clearTimeout(timeout[i]); // component_screen.jsp 에서 선언한 실시간 장애현황 데이터 변환 timeout stop
    }
    timeout = [];

    var intervalLength = interval.length;
    for (var i = 0; i < intervalLength; i++) {
        clearInterval(interval[i]); // component_screen.jsp 에서 선언한 실시간 장애현황 데이터 변환 timeout stop
    }
    interval = [];
}

// Grid Header Attribute
var alignCenter = {style:'text-align:center;'};
var alignRight = {style:'text-align:right;'};
var alignLeft = {style:'text-align:left;'};

// jQuery Block UI Default Option
var blockUIOption = {
    css 	: {
        border					: 'none',
        padding					: '5px',
        backgroundColor			: '#000',
        '-webkit-border-radius'	: '10px',
        '-moz-border-radius'	: '10px',
        opacity					: .5,
        color					: '#fff'
    },
    message : '<h2>Please wait...</h2>'};

// Kendo Grid Default Option
var kendoGridDefaultOpt = {
    selectable	: 'row',
    sortable	: false,
    scrollable	: false,
    resizable	: true,
    pageable	: {
        pageSizes: [10, 15, 20, 30, 50, 100],
        messages : {
            empty	: "<strong>No data</strong>",
            display : "<span>전체 <strong style='color: #f35800;'>{2}</strong> 개 항목 중 <strong style='color: #f35800;'>{0}~{1}</strong> 번째 항목 출력</span>"
        }
    }
};

function Constants(contextPath) {
    var _contextPath    = contextPath,
        _countPerPage   = 0,
        _pageSize       = 0;

    this.contextPath = function(value) {
        if (value) {
            _contextPath = value;
        }
        return _contextPath;
    }

    this.countPerPage = function(value) {
        if (value) {
            _countPerPage = value;
        }
        return _countPerPage;
    }

    this.pageSize = function(value) {
        if (value) {
            _pageSize = value;
        }
        return _pageSize;
    }
}

function createConstants(contextPath) {
    cst = new Constants(contextPath);
    return cst;
}

// 그리드 데이터 Bound 후에 데이터가 존재 하지 않을때 처리
function gridDataBound(e) {
    var grid = e.sender;
    if (grid.dataSource.total() == 0) {
        var colCount = grid.columns.length;
        $(e.sender.wrapper)
            .find('tbody')
            .append('<tr class="kendo-data-row"><td colspan="' + colCount + '" style="text-align:center;">데이터가 존재하지 않습니다.</td></tr>');
    }
}