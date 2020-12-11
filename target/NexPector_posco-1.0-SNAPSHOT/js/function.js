$(function(){

	$("#topmenu li a").bind("keyup mouseover", function(){
		$(this).parent().siblings().children("ul").hide();
		$(this).parent().children("ul").show();
	});

	$("#topmenu").bind("blur mouseleave", function(){
		//$(this).children("li").children("ul").hide();
	});

	$("#topmenu .menu6 li:last a").bind("blur", function(){
		$(this).parent().parent().hide();
	});

	if ($(".m_commonBody").length > 0) {
		$(":radio, :checkbox").css("border-style", "none");
		}

	if ($("#Mquick").length > 0) {

		var currentPosition = parseInt($("#Mquick").css("top"));
		  $(window).scroll(function() {
		    var position = $(window).scrollTop();
		    $("#Mquick").stop().animate({"top":position+currentPosition+"px"},400);
		  });

	} else if ($("#quick").length > 0) {
		var currentPosition = parseInt($("#quick").css("top"));
		  $(window).scroll(function() {
		    var position = $(window).scrollTop();
		    $("#quick").stop().animate({"top":position+currentPosition+"px"},400);
		  });

	}

	if ($(".m_popupClose").length > 0) {
		if ($(".conRistLong table").height() > 200 && $(".conRistLong table").length > 0) {

		var win_height = $(".conRistLong table").height() + $(".m_popupClose").height()+105;
		$(".m_popupClose").css( {
			"top" : win_height + "px"
		});
		} else {
			var win_height = $(window).height() - $(".m_popupClose").height() + 50;
			$(".m_popupClose").css( {
				"top" : win_height + "px"
			});
		}
	}
/*
	if ($.browser.opera) {
		$("#quick_function li:not('#con_print')").hide();

	 } else if($.browser.safari) {

	 } else if($.browser.mozilla) {
		 $("#quick_function li:not('#con_print')").hide();

	 } else if($.browser.webkit) {
		 $("#quick_function li:not('#con_print')").hide();

	 } else if($.browser.msie) {

	 }
*/
	$("#zoomin_btn").click(function(){
		zoomIn();
		return false;
	});
	$("#zoomout_btn").click(function(){
		zoomOut();
		return false;
	});
	$("#default_btn").click(function(){
		zoomDefault();
		return false;
	});

	$("#con_print").click(function(){
	        window.print();
	        return false;
	});

	var nowZoom = 100; // �������
	var maxZoom = 130; // �ִ����(500�����ϸ� 5�� Ŀ����)
	var minZoom = 80; // �ּҺ���


	function zoomIn(){
	if (nowZoom < maxZoom){
		nowZoom += 5;
	}else{
		alert("ȭ���� �ִ���� �Դϴ�.\n\n�⺻������ �����ø� ������� ���ư��ϴ�.");
	return;
	}
		$("#wapper").css("zoom", nowZoom+"%");
	}

	function zoomOut(){

	if (nowZoom > minZoom){
		nowZoom -= 5;
	}else{
		alert("ȭ���� �ּҺ��� �Դϴ�.\n\n�⺻������ �����ø� ������� ���ư��ϴ�.");
	return;
	}
		$("#wapper").css("zoom", nowZoom+"%");
	}

	function zoomDefault(){
		nowZoom = 100;
	$("#wapper").css("zoom", nowZoom+"%");
	}

});

<!--
//�Ǹ޴�_Ÿ��1
function avaya_tab1() {
document.getElementById('tapBox1').style.display='block'
document.getElementById('tapBox2').style.display='none'
document.getElementById('tapBox3').style.display='none'
document.getElementById('tapBox4').style.display='none'
document.getElementById('tapBox5').style.display='none'
document.getElementById('tapBox6').style.display='none'
document.getElementById('tapBox7').style.display='none'
document.getElementById('tapBox8').style.display='none'
document.getElementById('tapBox9').style.display='none'
document.getElementById('tapBox10').style.display='none'
document.getElementById('tapBox11').style.display='none'
document.getElementById('tapBox12').style.display='none'

}

function avaya_tab2() {
document.getElementById('tapBox1').style.display='none'
document.getElementById('tapBox2').style.display='block'
document.getElementById('tapBox3').style.display='none'
document.getElementById('tapBox4').style.display='none'
document.getElementById('tapBox5').style.display='none'
document.getElementById('tapBox6').style.display='none'
document.getElementById('tapBox7').style.display='none'
document.getElementById('tapBox8').style.display='none'
document.getElementById('tapBox9').style.display='none'
document.getElementById('tapBox10').style.display='none'
document.getElementById('tapBox11').style.display='none'
document.getElementById('tapBox12').style.display='none'
}

function avaya_tab3() {
document.getElementById('tapBox1').style.display='none'
document.getElementById('tapBox2').style.display='none'
document.getElementById('tapBox3').style.display='block'
document.getElementById('tapBox4').style.display='none'
document.getElementById('tapBox5').style.display='none'
document.getElementById('tapBox6').style.display='none'
document.getElementById('tapBox7').style.display='none'
document.getElementById('tapBox8').style.display='none'
document.getElementById('tapBox9').style.display='none'
document.getElementById('tapBox10').style.display='none'
document.getElementById('tapBox11').style.display='none'
document.getElementById('tapBox12').style.display='none'
}

function avaya_tab4() {
document.getElementById('tapBox1').style.display='none'
document.getElementById('tapBox2').style.display='none'
document.getElementById('tapBox3').style.display='none'
document.getElementById('tapBox4').style.display='block'
document.getElementById('tapBox5').style.display='none'
document.getElementById('tapBox6').style.display='none'
document.getElementById('tapBox7').style.display='none'
document.getElementById('tapBox8').style.display='none'
document.getElementById('tapBox9').style.display='none'
document.getElementById('tapBox10').style.display='none'
document.getElementById('tapBox11').style.display='none'
document.getElementById('tapBox12').style.display='none'
}

function avaya_tab5() {
document.getElementById('tapBox1').style.display='none'
document.getElementById('tapBox2').style.display='none'
document.getElementById('tapBox3').style.display='none'
document.getElementById('tapBox4').style.display='none'
document.getElementById('tapBox5').style.display='block'
document.getElementById('tapBox6').style.display='none'
document.getElementById('tapBox7').style.display='none'
document.getElementById('tapBox8').style.display='none'
document.getElementById('tapBox9').style.display='none'
document.getElementById('tapBox10').style.display='none'
document.getElementById('tapBox11').style.display='none'
document.getElementById('tapBox12').style.display='none'
}

function avaya_tab6() {
document.getElementById('tapBox1').style.display='none'
document.getElementById('tapBox2').style.display='none'
document.getElementById('tapBox3').style.display='none'
document.getElementById('tapBox4').style.display='none'
document.getElementById('tapBox5').style.display='none'
document.getElementById('tapBox6').style.display='block'
document.getElementById('tapBox7').style.display='none'
document.getElementById('tapBox8').style.display='none'
document.getElementById('tapBox9').style.display='none'
document.getElementById('tapBox10').style.display='none'
document.getElementById('tapBox11').style.display='none'
document.getElementById('tapBox12').style.display='none'
}

function avaya_tab7() {
document.getElementById('tapBox1').style.display='none'
document.getElementById('tapBox2').style.display='none'
document.getElementById('tapBox3').style.display='none'
document.getElementById('tapBox4').style.display='none'
document.getElementById('tapBox5').style.display='none'
document.getElementById('tapBox6').style.display='none'
document.getElementById('tapBox7').style.display='block'
document.getElementById('tapBox8').style.display='none'
document.getElementById('tapBox9').style.display='none'
document.getElementById('tapBox10').style.display='none'
document.getElementById('tapBox11').style.display='none'
document.getElementById('tapBox12').style.display='none'
}

function avaya_tab8() {
document.getElementById('tapBox1').style.display='none'
document.getElementById('tapBox2').style.display='none'
document.getElementById('tapBox3').style.display='none'
document.getElementById('tapBox4').style.display='none'
document.getElementById('tapBox5').style.display='none'
document.getElementById('tapBox6').style.display='none'
document.getElementById('tapBox7').style.display='none'
document.getElementById('tapBox8').style.display='block'
document.getElementById('tapBox9').style.display='none'
document.getElementById('tapBox10').style.display='none'
document.getElementById('tapBox11').style.display='none'
document.getElementById('tapBox12').style.display='none'
}

function avaya_tab9() {
document.getElementById('tapBox1').style.display='none'
document.getElementById('tapBox2').style.display='none'
document.getElementById('tapBox3').style.display='none'
document.getElementById('tapBox4').style.display='none'
document.getElementById('tapBox5').style.display='none'
document.getElementById('tapBox6').style.display='none'
document.getElementById('tapBox7').style.display='none'
document.getElementById('tapBox8').style.display='none'
document.getElementById('tapBox9').style.display='block'
document.getElementById('tapBox10').style.display='none'
document.getElementById('tapBox11').style.display='none'
document.getElementById('tapBox12').style.display='none'
}

function avaya_tab10() {
document.getElementById('tapBox1').style.display='none'
document.getElementById('tapBox2').style.display='none'
document.getElementById('tapBox3').style.display='none'
document.getElementById('tapBox4').style.display='none'
document.getElementById('tapBox5').style.display='none'
document.getElementById('tapBox6').style.display='none'
document.getElementById('tapBox7').style.display='none'
document.getElementById('tapBox8').style.display='none'
document.getElementById('tapBox9').style.display='none'
document.getElementById('tapBox10').style.display='block'
document.getElementById('tapBox11').style.display='none'
document.getElementById('tapBox12').style.display='none'
}

function avaya_tab11() {
document.getElementById('tapBox1').style.display='none'
document.getElementById('tapBox2').style.display='none'
document.getElementById('tapBox3').style.display='none'
document.getElementById('tapBox4').style.display='none'
document.getElementById('tapBox5').style.display='none'
document.getElementById('tapBox6').style.display='none'
document.getElementById('tapBox7').style.display='none'
document.getElementById('tapBox8').style.display='none'
document.getElementById('tapBox9').style.display='none'
document.getElementById('tapBox10').style.display='none'
document.getElementById('tapBox11').style.display='block'
document.getElementById('tapBox12').style.display='none'
}

function avaya_tab12() {
document.getElementById('tapBox1').style.display='none'
document.getElementById('tapBox2').style.display='none'
document.getElementById('tapBox3').style.display='none'
document.getElementById('tapBox4').style.display='none'
document.getElementById('tapBox5').style.display='none'
document.getElementById('tapBox6').style.display='none'
document.getElementById('tapBox7').style.display='none'
document.getElementById('tapBox8').style.display='none'
document.getElementById('tapBox9').style.display='none'
document.getElementById('tapBox10').style.display='none'
document.getElementById('tapBox11').style.display='none'
document.getElementById('tapBox12').style.display='block'
}

//-->