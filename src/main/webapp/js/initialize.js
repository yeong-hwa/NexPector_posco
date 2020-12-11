var sDatepicker, eDatepicker;

function _startChange() {
    var startDate = sDatepicker.value(),
        endDate = eDatepicker.value();

    if (startDate) {
        startDate = new Date(startDate);
        startDate.setDate(startDate.getDate());
        eDatepicker.min(startDate);
    }
    else if (endDate) {
        sDatepicker.max(new Date(endDate));
    }
    else {
        endDate = new Date();
        sDatepicker.max(endDate);
        eDatepicker.min(endDate);
    }
}

function _endChange() {
    var endDate = eDatepicker.value(),
        startDate = sDatepicker.value();

    if (endDate) {
        endDate = new Date(endDate);
        endDate.setDate(endDate.getDate());
        sDatepicker.max(endDate);
    }
    else if (startDate) {
        eDatepicker.min(new Date(startDate));
    }
    else {
        endDate = new Date();
        sDatepicker.max(endDate);
        eDatepicker.min(endDate);
    }
}

function createStartKendoDatepicker(elementId) {
    var beforeDate = new Date();
    beforeDate.setDate(new Date().getDate());

    sDatepicker = _defaultKendoDatepicker(elementId, { change : _startChange }, beforeDate);
    return sDatepicker;
}

function createStartKendoDatepickerWithDate(elementId, begindDate) {
    sDatepicker = _defaultKendoDatepicker(elementId, { change : _startChange }, begindDate);
    return sDatepicker;
}

function createEndKendoDatepicker(elementId) {
    var afterDate = new Date();
    afterDate.setDate(new Date().getDate());
    
    eDatepicker = _defaultKendoDatepicker(elementId, { change : _endChange }, afterDate);
    return eDatepicker;
}

function createKendoDatepicker(elementId, options) {
    var date = new Date();
    date.setDate(new Date().getDate());
	
    _defaultKendoDatepicker(elementId, options, date);
}

function _defaultKendoDatepicker(elementId, options, date) {

    var datepickerOpts = {
        animation: {
            close: {
                effects: "zoom:out",
                duration: 300
            }
        },
        format: 'yyyy-MM-dd',
        value: date
    };

    $.extend(datepickerOpts, options);

    var datepicker = $("#" + elementId).kendoDatePicker(datepickerOpts).data("kendoDatePicker");
    datepicker.enable(true);
    datepicker.element.css({'height' : '1.2em'});
    datepicker.wrapper.css({'width' : '160px'});
    datepicker.wrapper.prevObject.css({'height' : '1.6em'});

    return datepicker;
}

function createDropDownList(elementId, dataSource, options) {
    var opt = {
        dataTextField	: "VAL",
        dataValueField	: "CODE",
        dataSource		: dataSource,
        index			: 0
    };
    $.extend(opt, options);
    var dropDownList = $("#" + elementId).kendoDropDownList(opt).data("kendoDropDownList");
    dropDownList.span.css('height', '1.3em');
    return dropDownList;
}

function fn_server_group_change() {
    var serverGroupCode = $("#group_code").data('kendoDropDownList').value();
    if(serverGroupCode === '') {
        $('#mon_id').data("kendoDropDownList").enable(false);
        return;
    }

    $.getJSON(cst.contextPath() + '/watcher/lst_svrComboQry.htm', { 'N_GROUP_CODE' : serverGroupCode })
        .done(function(data) {
            if ( $.isEmptyObject(data) ) {
                $('#mon_id').data("kendoDropDownList").enable(false);
                $('#mon_id').data("kendoDropDownList").setDataSource([]);
            }
            else {
                $('#mon_id').data("kendoDropDownList").enable(true);
                $('#mon_id').data("kendoDropDownList").setDataSource(data);
            }
        });
}