function cfn_input_num() {
	if(jQuery.isNumeric(String.fromCharCode(event.keyCode)))
	{			
		return true;
	}
	return false;
}

function cfn_input_num2(val) {
	if(jQuery.isNumeric(val))
	{			
		return true;
	}
	return false;
}

var tmp_ip_value;
/*
 * .input_numberic 클래스로 지정되면 숫자만 입력 받는다.
 */
$(function() {
	$(".input_numberic").css("ime-mode", "disabled"); //한글입력을 받지 않는다.	    
	$(".input_numberic").keypress(function(event){
         if(!cfn_input_num()) { event.preventDefault(); }
    });

	$(".넌숫자만").css("ime-mode", "disabled"); //한글입력을 받지 않는다.	    
	$(".넌숫자만").keypress(function(event){
         if(!cfn_input_num()) { event.preventDefault(); }
    });

	$(".넌IP입력").css("ime-mode", "disabled"); //한글입력을 받지 않는다.	    
	$(".넌IP입력").keypress(function(event){
		//alert(event.keyCode);
		//alert(String.fromCharCode(event.keyCode));
		//alert($(this).val().length);
         if((!cfn_input_num() && String.fromCharCode(event.keyCode) != '.') || $(this).val().length >= 15) {
        	 event.preventDefault(); 
         }
         
         //alert($(this).val() + "-" + $(this).val().replace(/\./gi, ""));
         if($(this).val().length - $(this).val().replace(/\./gi, "").length >= 3 && String.fromCharCode(event.keyCode) == '.'){
        	 event.preventDefault();
         }
         
         tmp_ip_value = $(this).val();
    });
	$(".넌IP입력").keyup(function(event){
		if(tmp_ip_paste_flag)
		{
			var tmp_data = $(this).val().replace(/ /gi, '');
			for(var i=0;i<tmp_data.length;i++)
			{	
				if((!jQuery.isNumeric(tmp_data.charAt(i)) && tmp_data.charAt(i) != '.') || $(this).val().length >= 15) {
		        	 //alert("붙여넣기 데이터가 IP 형식이 아닙니다." + tmp_data.charAt(i) + "[" + i + "]");
					 alert("붙여넣기 데이터가 IP 형식이 아닙니다.");
		        	 tmp_ip_paste_flag = false;
		        	 $(this).val("");
		        	 return;
		        }
			}
			$(this).val(tmp_data);
			tmp_ip_paste_flag = false;
		}
		
		//점 2개 연속으로 입력 못하게 함.
		if($(this).val().replace(/\.\./gi,".").length != $(this).val().length)
		{
			$(this).val($(this).val().replace(/\.\./gi,"."));
		}
		
		//IP 자리수당 숫자 제한
		var tmp_data = $(this).val().split(".");
		var tmp_flag = false;
		$(tmp_data).each(function(){
			if(this > 255)
			{
				alert('IP 입력값이 초과되었습니다.(자릿수당 최대 255)');
				tmp_flag = true;
				return false;
			}
		});
		
		if(tmp_flag)
		{
			$(this).val(tmp_ip_value);
		}
	});
	var tmp_ip_paste_flag = false;
	$(".넌IP입력").bind("paste", function(event){
		tmp_ip_paste_flag = true;
	});

	$(".넌한글안돼").css("ime-mode", "disabled"); //한글입력을 받지 않는다.	

//검색조건에서 엔터치면 해당하는 클래스의 버튼을 클릭.
	$(".input_search").keypress(function(event){
         if(event.keyCode == '13') 
        	 $(".btn_search").click();
       });
	
	var temp_row_color;
	$(".tr_row_list").hover(function(){
		temp_row_color = $(this).css("backgroundColor");
		$(this).css("backgroundColor", "#CCCCDD");
	}, function(){
		$(this).css("backgroundColor", temp_row_color);
		temp_row_color = "";
	});
});
