<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="/WEB-INF/views/include/include.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
<link href="<c:url value="/common/js/dtree/dtree.css"/>" rel="stylesheet">
<script src="<c:url value="/common/js/dtree/dtree.js"/>"></script>
</head>

<%
	String action_file = "servergroup_img_mgr";
%>

<script>
	<!-- 페이지 로딩시 수행할 내용 -->
	function fn_init()
	{
		fn_getTreedata();
	}
	
	<!-- 조회 -->
	function fn_retrieve()
	{
		frm.target = "ifm_list";
		frm.action="<%=action_file%>.retrieve.neonex";
		frm.submit();	
	}
	
	<!-- 이미지 적용 실행 -->
	var old_obj;
	
	function fn_tree_click(obj, url)
	{
		$(old_obj).css("font","normal");
		$(obj).css("font","bold");
		old_obj = obj;
		var oimg = $("#img_url").attr("src",url);
	}
	
	function fn_getTreedata()
	{
		$.post("<c:url value="/admin/lst_svr_group_img.select_list.htm"/>", function(str){
			//alert(str);
			var data = $.parseJSON(str);
			d = new dTree('d');
			$(data).each(function(){
				d.add((this.N_GROUP_CODE==-1?0:this.N_GROUP_CODE), (this.N_UP_CODE==null?(this.N_GROUP_CODE==-1?-1:0):this.N_UP_CODE), this.S_GROUP_NAME+"<span style='display:none;''>"+this.S_IMAGE_URL+","+this.PARENT_CODE+","+this.N_GROUP_CODE+"</span>", "javascript:fn_tree_click(this, \'"+this.S_IMAGE_URL+"\', \'"+this.PARENT_CODE+"\', \'"+this.N_GROUP_CODE+"\');");
			});
			
			$("#grp_tree").html(d.toString());
			
			$(".dTreeNode").eq(0).children("a").click();
		    eval($(".dTreeNode").eq(0).children("a").attr("href"));
		});
	}
	
	<!-- 추가 -->
	function fn_insert()
	{
		frm.target = "";
		frm.action="<c:url value="/admin/go_prgm.system.svr_group_img.insert.htm"/>";
		frm.submit();	
	}
	
	<!-- 수정 -->
	function fn_update(obj_nm, obj_val)
	{
		var obj = document.createElement("input");
		obj.name = obj_nm;
		obj.type="hidden";
		obj.value = obj_val;
		
		frm.appendChild(obj);
		
		frm.nowpage.value = ifm_list.page_frm.nowpage.value;
		frm.target = "";
		frm.action="<%=action_file%>.update.neonex";
		frm.submit();
	}	
	
</script>
<body onload="fn_init()">
	<form name="frm" method="post">
		<!-- Iframe 부분 -->
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td height="47" background="${img1}/sotitle_bg.jpg" class="b f14"><img src="${img1}/sotitle_icon.jpg" hspace="3" align="absmiddle">
          	서버 그룹 맵 이미지 관리
          </td>
        </tr>
        <tr>
          <td height="30" align="right" valign="top">
          	<input style="width:70px; height:23px;" onClick="fn_insert()" type="button" value="등록"/>
          </td>
        </tr>
        <tr>
          <td>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr height="500">
              	<td width="20%" valign="top">
              		<div style="overflow:scroll;height:100%;width:250" class="box" style="padding:15px 15px 15px 15px;background-color:#FFFFFF;">
              		<table width="800" valign="top">
              			<tr height="500">
              				<td valign="top">
		              			<div id="grp_tree" style="overflow: scroll;width:250;height:500;">
		              			</div>
              				</td>
              			</tr>
              		</table>
              		</div>
				</td>
              	<td width="80%" valign="top">
	              	<table width="100%" id="img_table" height="100%" border="0" cellspacing="0" cellpadding="0">
		              <tr align="center">
		                <td width="100%" height="100%">
		                	<img id="img_url" width="100%" height="100%" src="aaa"/>
						</td>
		              </tr>
		            </table>
              	</td>
              </tr>
            </table>
          </td>
        </tr>
      </table>		
	</form>
</body>
</html>

