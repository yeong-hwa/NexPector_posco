//전역 콤보 데이터
var g_cmb_data;
var g_tree_icon;

var max_combo_size = "150";

//로그인 시각
var g_login_dt;
//마지막 알람 체크 시각
var g_last_alarm_dt;

var g_last_dash_alarm_dt;

function gfn_get_combo_data()
{	
	ajax_reqAction("main.appcode.neonex", "", "callback_gfn_get_combo_data");
}

function callback_gfn_get_combo_data(str)
{
	window.g_cmb_data = eval('('+str+')');
}

function gfn_get_data(v_data_name, v_where, v_column)
{
	var tmp_obj = eval("g_cmb_data." + v_data_name);
	
	var obj;
	if(v_where != null && v_where != "")
		obj = $(tmp_obj).filter(function(){return eval("this."+v_where.replace(/&&/gi,"&&this."));});
	else
		obj = $(tmp_obj);
	
	var rtnStr = "";
	
	$(obj).each(function(key, val){
		rtnStr = eval("val." + v_column); return false;
	});
	
	return rtnStr;
}

/*
 * v_cmb_name : 저장한 데이터 명(쿼리에서 가져와서 저장할때 지정한 이름.)
 * v_cmb_tag_name : 생성할 tag의 이름
 * v_cmb_obj : 생성한 콤보의 html을 입력할 object명
 * v_first_val : 콤보박스 첫번째 값(선택,없음 등) value를 빈값 이외에 지정할시 선택:1 으로 입력
 * v_where : 걸러낼 조건
 */
function gfn_make_combo(v_cmb_name, v_cmb_tag_name, v_cmb_obj, v_first_val, v_where, v_etc)
{
	var tmp_obj = eval("g_cmb_data." + v_cmb_name);
	
	var obj;
	
	if(v_where != null && v_where != "")
		obj = $(tmp_obj).filter(function(){return eval("this."+v_where.replace(/&&/gi,"&&this."));});
	else
		obj = $(tmp_obj);
	
	
	var opt_str = "";
	
	if(v_first_val != null && v_first_val != "")
	{	
		var tmp_arr = v_first_val.split(":");
		
		var tmp_val = tmp_arr.length > 1?tmp_arr[1]:"";
		var tmp_txt = tmp_arr.length > 1?tmp_arr[0]:tmp_arr;

		opt_str += "<option value='" + tmp_val + "'>" + tmp_txt + "</option>";
	}
	
	$(obj).each(function(key, val){
		opt_str += "<option value='" + val.CODE + "'>" + val.VAL + "</option>";
	});
	
	var cmb_str = "<select name='"+v_cmb_tag_name+"' " + ((v_etc!=""&&v_etc!=null)?v_etc:"") + " style='width:"+ max_combo_size +";'>";
	cmb_str += opt_str;
	cmb_str += "</select>";
	$(v_cmb_obj).html(cmb_str);
}

function gfn_make_radio(v_rdo_name, v_rdo_tag_name, v_rdo_obj, v_where)
{
	var tmp_obj = eval("g_cmb_data." + v_rdo_name);
	
	var obj;
	
	if(v_where != null && v_where != "")
		obj = $(tmp_obj).filter(function(){return eval("this."+v_where.replace(/&&/gi,"&&this."));});
	else
		obj = $(tmp_obj);
	
	var rdo_str = "";
	
	$(obj).each(function(key, val){
		rdo_str += "<input type='radio' name='"+v_rdo_tag_name+"' value='" + val.CODE + "'>" + val.VAL;
	});
	
	$(v_rdo_obj).html(rdo_str);
}

function gfn_make_radio_tbl(v_rdo_name, v_rdo_tag_name, v_rdo_obj, v_where)
{
	var tmp_obj = eval("g_cmb_data." + v_rdo_name);
	
	var obj;
	
	if(v_where != null && v_where != "")
		obj = $(tmp_obj).filter(function(){return eval("this."+v_where.replace(/&&/gi,"&&this."));});
	else
		obj = $(tmp_obj);
	
	var rdo_str = "<table width='100%'>";
	
	$(obj).each(function(key, val){
		rdo_str += "<tr><td class='line_gray'><input type='radio' name='"+v_rdo_tag_name+"' value='" + val.CODE + "'>" + val.VAL + "</td></tr>";
	});
	
	rdo_str += "</table>";
	
	$(v_rdo_obj).html(rdo_str);
}