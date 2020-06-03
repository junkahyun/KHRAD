<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 		uri="/WEB-INF/tlds/c.tld" %> 
<%@ taglib prefix="fn" 		uri="/WEB-INF/tlds/fn.tld" %>
<%@ taglib prefix="fmt"		uri="/WEB-INF/tlds/fmt.tld" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<c:set var="role" value="${sessionScope.aduser.role_code}"/>
<c:set var="department" value="${sessionScope.aduser.depart}"/>
<!-- script type="text/javascript" src="<c:url value="/ckeditor/ckeditor.js" />"></script-->
<c:if test="${sessionScope.aduser.site_id == 'kh' }">
<title>KH정보교육원 RAD :: 컨텐츠관리</title>
</c:if>
<c:if test="${sessionScope.aduser.site_id == 'atents' }">
<title>아텐츠 RAD :: 컨텐츠관리</title>
</c:if>
<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/meta.jsp"/>
<script type="text/javascript">
var mode = "${params.mode}";

jQuery(function(){
	fnCurrentSub('07','02');
	
	var reg_date = '${data.reg_date}';
    var year = "";
    var month = "";
    var day = "";
    var hour = "";
    var min = "";
    var sec = "";
	if(reg_date != null && reg_date != "") {
		year = reg_date.substring(0,4);
		month = reg_date.substring(4,6);
		day = reg_date.substring(6,8);
		hour = reg_date.substring(8,10);
		min = reg_date.substring(10,12);
		sec = reg_date.substring(12,14);
	}
	else {
		var resultDate = new Date();
		var year = resultDate.getFullYear();
	    var month = resultDate.getMonth() + 1;
	    if (month < 10) { month = "0" + month; }
	    var day = resultDate.getDate();
	    if (day < 10) { day = "0" + day; }
	    var hour =  resultDate.getHours();
	    if (hour < 10) { hour = "0" + hour; }
	    var min =  resultDate.getMinutes();
	    if (min < 10) { min = "0" + min; }
	    var sec =  resultDate.getSeconds();
	    if (sec < 10) { sec = "0" + sec; }
	}
        
    $("#yy").val( year );
    $("#mm").val( month );
    $("#dd").val( day );
    $("#hour").val( hour );
    $("#min").val( min );
    $("#sec").val( sec );
    
	if('${params.share}' == 'false'){
		$("#yShare").checked;
	}else{
		$("#nShare").checked;
	}
	
	$("#thum_photo").on("change", fnOkThumnail);
	
});


function fnRegister() {
	
    $("#reg_date").val( $("#yy").val() + $("#mm").val() + $("#dd").val() + $("#hour").val() + $("#min").val() + $("#sec").val() );
    
	var f = document.getElementById("frm");
	f.action = '${pageContext.request.contextPath}/rad/contents/updateJobSupport.kh';
		
	var url = "rad/contents/jobSupport.kh?cpage=${params.cpage}";
	$("#url").val(url);
	
	var content1 = $('#contenttxt1').val();
	$('#content1').val(content1);
	
	var content2 = $('#contenttxt2').val();
	$('#content2').val(content2);
	
	var content3 = $('#contenttxt3').val();
	$('#content3').val(content3);
	//alert( $("#reg_date").val() );
	f.submit();
}
function fnBack(){
	location.href='${pageContext.request.contextPath}/rad/contents/jobSupport.kh?cpage=${params.cpage}';
} 

function fnThumnail(){
	$("#thum_photo").click();
}

function fnOkThumnail(e){
	var files = e.target.files;
	var file = Array.prototype.slice.call(files)[0];
	var val = file.type.split("/")[1];
	
	if(val=='jpg' || val=='png' || val=='JPG' || val=='PNG' || val=='jpeg' || val=='JPEG'){
		var reader = new FileReader();
		reader.onload = function(e) {
			$("#preview_photo").attr("src", e.target.result);
		}
		reader.readAsDataURL(file);
	} else {
		alert('프로필 사진은 jpg또는 png만 등록할 수 있습니다.');
	}
}

</script>

<style>
	#view_modify .view_form td{padding: 7px 15px;}
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/rad/portlet/right_quick.jsp"/>
	<input type="hidden" id="location_name" value=disable>	
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/metaHeader_2018.jsp"/>
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/header_2018.jsp"/>
	<div id="body" onmouseover="fnCloseSubs();">
		<div id="headtitle">
			<div class="left">상담선생님 소개</div>
			<div class="right">
			</div>
		</div>
		<form id="frm" name="frm" action="${pageContext.request.contextPath}/rad/contents/updateJobSupport.kh" method="post" enctype="multipart/form-data">
			<div id="view_modify">
				<table class="view_form" cellpadding="0" cellspacing="0" style="width:100%;">
					<tr><th colspan="2" class="view_form_title">상담선생님 수정</th></tr>
					<tr>
						<td rowspan="6" style="border-right: 1px solid #ececec;">
							<div class="info_img" style="width:133px;height:133px;margin:0 auto;border-radius:50%;overflow:hidden;">
		                        <a href="javascript:fnThumnail();" alt="프로필 이미지 변경">
									<img id="preview_photo" alt="상담선생님소개 기본썸네일" style="width:190px; margin-left:-21%;" src="${pageContext.request.contextPath}/upload/jobsupport/
									<c:if test="${data.photo == null || empty data.photo}">jobsupport_photo.jpg	</c:if>
									<c:if test="${data.photo != null && not empty data.photo}">${data.photo}</c:if>
									">
		                        </a>
		                       	<input type="file" id="thum_photo" name="thum_photo" style="display: none;">
		                    </div>
		                    <p style="text-align:center;margin-top:20px;">133*133<br>(사진 변경시 클릭)</p>
						</td>
						<td>
							<input type="text" id="department" style="width:280px;padding:2px 7px;line-height:27px;" value="${data.department}/${data.name} ${data.dept}" readonly="true">
							<div style="display: inline;">
								<input type="radio" name="share" value="true" id="yShare" checked="checked" <c:if test="${data.share eq 'true'}">checked</c:if>>배포
								<input type="radio" name="share" value="false" id="nShare" <c:if test="${data.share eq 'false'}">checked</c:if>>미배포 
							</div>
						</td>
					</tr>
					<tr>
						<td>
						<input type="text" id="emailphone" style="width:412px;padding:2px 7px;line-height:27px;" value="이메일 : ${data.email} / 연락처 : ${data.phone}" readonly="true">
						</td>
					</tr>
					<tr>
						<td>
							<input type="text" id="comment1" name="comment1" style="width:195px;padding:2px 7px;line-height:27px;" value="${data.comment1}">
							<input type="text" id="comment2" name="comment2" style="width:195px;padding:2px 7px;line-height:27px;" value="${data.comment2}">
						</td>
					</tr>
					<tr>
						<td><textarea id="contenttxt1" name="contenttxt1" style="width:950px;height:72px;padding:7px;border:1px solid #ececec;resize:none;">${data.content1}</textarea></td>
					</tr>
					<tr>
						<td><textarea id="contenttxt2" name="contenttxt2" style="width:950px;height:72px;padding:7px;border:1px solid #ececec;resize:none;">${data.content2}</textarea></td>
					</tr>
					<c:if test="${sessionScope.aduser.site_id =='atents' }">
					<tr>
						<td><textarea id="contenttxt3" name="contenttxt3" style="width:950px;height:72px;padding:7px;border:1px solid #ececec;resize:none;">${data.content3}</textarea></td>
					</tr>
					</c:if>
				</table>
			</div>
			<div style="text-align: center; margin-top: 30px;">
				<a class="btn" href="javascript:fnRegister();">수정</a>
				<a class="btn" href="javascript:fnBack();">취소</a>
			</div>
		
			<input type="hidden" id="no" name="no" value="${data.no}">
			<input type="hidden" id="idx" name="idx" value="${params.idx }">
			<input type="hidden" id="mode" name="mode" value="${params.mode }">
			<input type="hidden" id="no" name="no" value="${params.no }">
			<input type="hidden" id="share_1" value="${params.share}">
			<input type="hidden" id="id" name="id" value="${data.id}">
			<input type="hidden" id="photo" name="photo" value="${data.photo}">
			<input type="hidden" id="url" name="url">
			<input type="hidden" id="content1" name="content1">
			<input type="hidden" id="content2" name="content2">
			<input type="hidden" id="content3" name="content3">
		</form>
	</div>
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/footer.jsp"/>
</body>
</html>