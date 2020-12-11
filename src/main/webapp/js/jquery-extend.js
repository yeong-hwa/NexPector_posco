$(function() {
    //_.mixin(s.exports()); // underscore string library 사용
    //$.extend({str : _});
    $.extend({defaultStr : function(str, defaultValue) {
        var s;
        if (str && str !== 'undefined') {
            s = str;
        }
        else {
            s = '';
        }
        return $.trim(s) === '' ? (defaultValue == null && defaultValue == undefined ? '' : defaultValue) : $.trim(s);
    }});
    //$.str = _; // underscore string library 를 jQuery function 에 확장해서 사용
});