<%@page import="java.util.Calendar"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="org.springframework.util.FileCopyUtils"%>
<%@page import="java.net.URL"%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="c" 		uri="/WEB-INF/tlds/c.tld" %> 
<%@ taglib prefix="fn" 		uri="/WEB-INF/tlds/fn.tld" %>
<%@ taglib prefix="fmt"		uri="/WEB-INF/tlds/fmt.tld" %>
<%@ taglib prefix="utils"	uri="/WEB-INF/tlds/utils.tld" %>
<%
	Calendar cal = Calendar.getInstance();
	Calendar currentDate = Calendar.getInstance();
	currentDate.add(cal.DATE, -7);
	
	String strCD = currentDate.get(currentDate.YEAR)+"";
	if(currentDate.get(cal.MONTH)<9) strCD+="0";
	strCD+=(currentDate.get(cal.MONTH)+1)+"";
	if(currentDate.get(cal.DATE)<10) strCD+="0";
	strCD+=currentDate.get(cal.DATE)+"";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<c:set var="role" value="${sessionScope.aduser.role_code}"/>
<c:set var="depart" value="${sessionScope.aduser.depart}"/>
<c:set var="dept_code" value="${sessionScope.aduser.dept_code}"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<c:if test="${sessionScope.aduser.site_id == 'kh' }">
<title>KH정보교육원 RAD :: 퇴직신청</title>
</c:if>
<c:if test="${sessionScope.aduser.site_id == 'atents' }">
<title>아텐츠 RAD :: 퇴직신청</title>
</c:if>
<link rel="shortcut icon" href="${pageContext.request.contextPath}/favicon.ico">
<c:set var="currentDate" value="<%=strCD %>"/>
</head>
<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/meta_2018.jsp"/>
<style>
	#popup_department table tbody tr td {border: 0px; text-align: left;}
	table .selectMenuWrap {left: 8px;}
	
	.yeartable { margin-bottom: 30px; }
	.year_Btn .btnMd { margin-top: 0px; }
	.erro{color: #ff554d;}
</style>
<script type="text/javascript">
var ajax = new rad.util.Ajax();
var mode = 'view';
useCal = function (){
	var direction = '';
	direction = 'downMonthpop';
	
	mkCalendar('ret_date', 0, direction);
	$("#ret_date").val("");
	
	$(".radCalendar").css({"top":"23px","left":"38px"});
}

jQuery(function(){
	useCal();
	var userid='${sessionScope.aduser.id}';
	var dept='${sessionScope.aduser.dept_code}';
	var is_manager = '${sessionScope.aduser.is_manager}';
	var site_id = '${sessionScope.aduser.site_id}';
	
	if(site_id === 'atents' && (userid === 'ghdthdud0806'  || userid === 'nocturn93')){
		dept = "111";
	}
	onTreeitemClick(dept, 'computed',is_manager,userid);
	
	$("#mymenus").css("height", $("#main_subs").outerHeight()+"px");
	
	/* <c:if test="${sessionScope.aduser.is_manager == 'Y' || dept_code == '1135'}"> */
	myTree = new dhtmlXTreeObject("viewOrg","100%","100%",0);
	myTree.setOnClickHandler(onTreeitemClick);
	myTree.setXMLAutoLoading("${pageContext.request.contextPath}/rad/auth/org/orgTree.kh");
	myTree.setImagePath("${pageContext.request.contextPath}/resources/js/dhtmlx/suite/skins/web/imgs/dhxtree_web/");
	myTree.setDataMode("xml");
	myTree.load("${pageContext.request.contextPath}/rad/auth/org/orgTree.kh?id=1");//KH정보교육원
	<c:if test="${params.dept_code != null }">
	onTreeitemClick('${params.dept_code}');
	</c:if>
	/* </c:if> */

	<c:if test="${params.dept_code != null }">
	$("#org_member").val('${params.id}');
	</c:if>
});

function onTreeitemClick(itemId,type,is_manager,userid){
	//alert("click " + itemId);
	$('#popup_department').fadeOut();
	
	$('#dept_code').val( itemId );
	var params = {
		  no		: itemId
	};

	ajax.send({
		  url		: '${pageContext.request.contextPath}/rad/auth/accountOrgHierarchy.kh'
		, data		: params
		, dataType	: 'json'
		, type		: 'post'
		, success	: function(data, textStatus) {
			var dept = data['parentOrgs'];
			
			$("#depart").val( replaceAll(dept, "_", "/") );
			$("#dept_name").val( $("#depart").val() );
			$("#dept_code").val(itemId);
			
			params = {
				  dept_code : itemId,
				  is_manager : is_manager,
				  userid : userid
			};
			ajax.send({
				  url		: '${pageContext.request.contextPath}/rad/main/orgMember.kh'
				, data		: params
				, type		: 'post'
				, success	: function(data, textStatus) {
					$("#org_member").html(data);
					
					<c:if test="${params.userid != null }">
					$("#org_member").val('${params.userid}');
					</c:if>
				}
			});
		}
		, error		: function(jqXHR, textStatus, errorThrown) {
			alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
		}
	});
}

function fnValidate(){
	if($("#ret_date").val() === null || $("#ret_date").val() === ''){
		$(".no_ret_date").text('퇴직일을 선택해주세요.');
		return;
	}
	else{
		$(".no_ret_date").hide();
	}
	
	if($("#ret_reason").val() === null || $("#ret_reason").val() === ''){
		$(".no_ret_reason").text('퇴직사유를 적어주세요.');
		return;
	}
	else{
		$(".no_ret_reason").hide();
	}
	
	if($("#filename").val() !== null && $("#filename").val() !== ''){
		const fileType = $("#filename").val().split(".").pop().toLowerCase();
		if((fileType !== "jpg") && (fileType !== "png") && (fileType !== "gif")){
			$(".no_file").text('이미지파일 (.jpg, .png, .gif ) 만 업로드 가능합니다.');
			return;
		}
		else {
			$(".no_file").hide();
		}
	}
	
	fnOk();
}

function fnOk(){
	var frm = document.frm;
	frm.id.value = $("#org_member").val();
	frm.ret_writer.value = $("#aduser").text();
	frm.submit();
}

function fnSelectDepartment(){
	fnOpenPopup('department');
}

function FileUploadAction(){
	$(".btn_find").trigger("click");
}

</script>
<body>
<jsp:include page="/WEB-INF/jsp/rad/portlet/right_quick.jsp"/>
<input type="hidden" id="location_name" value="퇴직신청">	
	<div id="select_bg" onclick="calSelectClose()"></div>
	<div class="popup_wrap" id="popup_department">
		<div class="bg" onclick="fnClosePopup();"></div>
		<div class="popup" style="width: 300px;">
			<div class="popup_title">조직도</div>
			<div class="popup_content">
				<div id="viewOrg" style="display: block; height: 250px; overflow: auto;">
				
				</div> 
				<div class="popup_btns">
					<a href="javascript: $('#popup_department').fadeOut();" class="btn">닫기</a>
				</div>
			</div>
		</div>
	</div>
	
	<!--헤더 시작-->
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/header_2018.jsp"/>				
	<!--헤더 끝-->
	
	
	<section id="section">
		<div class="sectionwrap subcomWrap">
			<div class="submenu cf">
				<div class="subleft">
					<!-- subInfo-->
					<jsp:include page="/WEB-INF/jsp/rad/portlet/myInfo.jsp"/>
				</div><!--class="myleft"-->
				<div class="subright">
					<div class="subtap boxtapWrap">
						<ul class="cf">
							<li onClick="javascript:location.href='${pageContext.request.contextPath}/rad/main/free.kh'"><p>연차현황</p></li>
							<%-- <li onClick="javascript:location.href='${pageContext.request.contextPath}/rad/main/lazy.kh'"><p>근태현황</p></li> --%>
							<li class="on" onClick="javascript:location.href='${pageContext.request.contextPath}/rad/main/retire.kh'"><p>퇴직신청</p></li>
							<li onClick="javascript:location.href='${pageContext.request.contextPath}/rad/main/myinfo.kh'"><p>내정보수정</p></li>
						</ul>
					</div><!--class="mytap-->
					
					<form action="${pageContext.request.contextPath}/rad/main/retireMember.kh" name="frm" method="post" enctype="multipart/form-data">
					<div class="mybody">
						<!--퇴직신청시작-->
						<div class="retire">
							<div class="retiretable">
								<table cellpadding="0" cellspacing="0">
									<tbody>
										<tr>
											<th>작성자</th>
											<td>
											<p id="aduser">${sessionScope.aduser.depart}&nbsp;${sessionScope.aduser.name}</p>
											</td>
											<input type="hidden" id="id" name="id"/>
											<input type="hidden" id="ret_writer" value="" name="ret_writer"/>
										</tr>
										<tr>
											<th>퇴직자</th>
											<td>
												<div>
													<div class="selectmemberWrap">
														<c:if test="${(dept_code == '1135') or role == 'AM' or role == 'EO'}">
															<input type="text" id="depart" name="depart" placeHolder="부서선택" onclick="javascript:fnSelectDepartment();" style="width: 200px;" readonly="true">
															<select id="org_member" class="select_view" style="width:400px;"></select>
														</c:if>
														<c:if test="${!(dept_code == '1135') and role != 'AM' and role != 'EO'}">
															<select id="org_member" class="select_view" style="width:400px;">
															</select>
														</c:if>
													</div>
												</div>
											</td>
										</tr>
										<tr>
											<th>퇴직일</th>
											<td>
												<input type="text" style="width:100px;" id="ret_date" name="ret_date"></input><br>
												<span class="erro no_ret_date"></span>
											</td>
										</tr>
										<tr>
											<th>퇴직사유</th>
											<td>
												<input type="text" style="width:726px;" id="ret_reason" name="ret_reason"></input><br>
												<span class="erro no_ret_reason"></span>
											</td>
										</tr>
										<tr>
											<th>사직서 업로드</th>
											<td>
												<input type="text" class="picture_up" style="width:632px;" id="filename" name="filename">
												<input type="file" id="fileupload" name="fileupload" onchange="javascript:document.getElementById('filename').value=this.value" style="float: right;position: absolute;opacity: 0;cursor: pointer;">
												<div class="btn_find" onclick="FileUploadAction();" >
													찾아보기
												</div><br>
												<span class="erro no_file"></span>
											</td>
										</tr>
									</tbody>
								</table>
								<div class="btn_retire" onclick="javascript:fnValidate();">퇴직신청</div>
							</div><!-- class="retire"-->
						<!--퇴직신청 끝-->
						</div>
					</div>
					</form>
				</div>
			</div>
		</div>
	</section>
	
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/footer_2018.jsp"/>
	
<script>

	var rightHeightfree=$('.subright').height();
	$('.subleft').css({'height':rightHeightfree});

</script>
</body>
</html>