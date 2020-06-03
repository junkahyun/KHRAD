<%@page import="java.util.Calendar"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="org.springframework.util.FileCopyUtils"%>
<%@page import="java.net.URL"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 		uri="/WEB-INF/tlds/c.tld" %> 
<%@ taglib prefix="fn" 		uri="/WEB-INF/tlds/fn.tld" %>
<%@ taglib prefix="fmt"		uri="/WEB-INF/tlds/fmt.tld" %>
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
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<c:if test="${sessionScope.aduser.site_id == 'kh' }">
<title>KH정보교육원 RAD :: 학습동영상</title>
</c:if>
<c:if test="${sessionScope.aduser.site_id == 'atents' }">
<title>아텐츠 RAD :: 학습동영상</title>
</c:if>
<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/meta_2018.jsp"/>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/validate/validate.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/radCalandar_v2.js"></script>
<script src="${pageContext.request.contextPath }/resources/js/media/mediaUpload.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/resources/css/radCalandar_v2.css" />
<c:set var="currentDate" value="<%=strCD %>"/>
</head>
<script>
let categorySelectFlag = false;
var count =0;
$(function(){
	setSubCategory('${mediaViewData.category_no}', '${mediaViewData.sub_category}', false);
});

function makeTheMediaUpload(){
	categorySelectFlag = true;
	$("#mediaUploadCont a").css({"background": "#2a2a4e", "cursor": "pointer"});
}

function setSubCategory(no, selectedSubCategoryNo, flag){
	if(no == 3 || no == 4) {
		$("#sebu_category").hide();
	}
	else { 
		$("#sebu_category").show();
	} 
	
	if($("input:radio[name='category']").is(":checked") === true && no === ""){
		no = $("input:radio[name='category']").val() == '자바' ? "1": "2";
	}
	
	$("#subCategory option").hide();
	$("#subCategory option[name=subCategory" + no + "]").show();

	if (selectedSubCategoryNo == null || selectedSubCategoryNo == '') {
		$("#subCategory option[name=subCategory" + no + "]:eq(0)").prop("selected", true);
	}

	if (flag === true) {
		makeTheMediaUpload();
	}
};

function addMediaForm(){
	count += 1;
	var html = '<tr class="'+count+'row"><th colspan=2>추가 업로드 동영상</th></tr>';
	html += '<tr><th>제목</th><td><input type="text" id="title'+count+'" name="title'+count+'" data-validate="required"data-message="제목을 입력해주세요." value="" style="width: 700px;"><span id="title'+count+'_error" class="validate_error_message" name="validate_error_message"></span></td></tr>';
	html += '<tr><th>썸네일</th><td class="file" id="thumbnailUploadCont'+count+'"><div class="fileInput"><input type="text" id="thumbName'+count+'" name="thumbName'+count+'" readonly value=""><input type="file" id="uploadThumb'+count+'" name="thumbnail'+count+'" style="display:none;" value="" onchange="document.getElementById(\'thumbName'+count+'\').value = this.value"><div class="txtdel" onClick="document.querySelector(\'#thumbnailUploadCont'+count+'\' input).value = ;"><img src="${pageContext.request.contextPath}/resources/images/rad/input_x.png" alt="글씨 삭제 버튼"></div></div><span class="btnSm file_btn"><a href="javascript:void(0)" onClick="document.getElementById(\'uploadThumb'+count+'\').click();">찾아보기</a></span></td></tr>';
	html += '<tr><th>학습 동영상</th><td class="file" id="mediaUploadCont'+count+'"><div class="fileInput"><input type="text" id="mediaFileName'+count+'" name="media'+count+'" readonly value="" data-validate="required" data-message="동영상을 업로드해주세요."><div class="txtdel" onClick="document.querySelector(\'#mediaUploadCont input'+count+'\').value = "";"><img src="${pageContext.request.contextPath}/resources/images/rad/input_x.png" alt="글씨 삭제 버튼"></div></div><span class="btnSm file_btn"><a href="javascript:void(0)" onClick="document.getElementById(\'mediaFile'+count+'\').click();">찾아보기</a></span><div><span id="media'+count+'_error" class="validate_error_message" name="validate_error_message"></span></div></td></tr>';
	html += '<tr><th>설명</th><td><textarea id="content'+count+'" name="content'+count+'" data-validate="required" data-message="설명을 입력해주세요." style="border: 1px solid #dfe2e9; width: 83%; margin: 6px 0; height: 85px; overflow-y: auto; "></textarea><span id="content'+count+'_error" class="validate_error_message" name="validate_error_message"></span></td></tr>';
	html += '<form id="mediaFrm'+count+'" name="mediaFrm'+count+'" ></form>';	
	html += '<input type="hidden" id="duration'+count+'" name="duration'+count+'" value=""><input type="hidden" id="midi_thumbnail'+count+'" name="midi_thumbnail'+count+'" value=""><input type="hidden" id="object_id'+count+'" name="object_id'+count+'" value=""><input type="hidden" id="media_id'+count+'" name="media_id'+count+'" value=""><input type="hidden" id="media_no'+count+'" name="media_no'+count+'" value="">';
	$("#mediaTable tr:last").after(html);
	var mediaFile = '<input type="file" id="mediaFile'+count+'" name="file" style="display:none;" onchange="document.getElementById(\'mediaFileName'+count+'\').value=this.value;">';
	var form =$("#mediaFrm"+count);
	form.append(mediaFile);
	$("#count").val(count);
}
function uploadMultiMedia(){
	var uploadFlag = $("#uploadFlag").val();//동영상 업로드시 false
	
	if(uploadFlag == 'true'){ // 동영상 수정시 
		fnEachSubmitData('0','true');
		return false;
	}
	var uploadingCount = $("#count").val();
	
	for(var i = 0; i <= uploadingCount; i++){		
		fnEachCreateData(i);
	}
}

// 동영상 등록 insert
function fnEachCreateData(index) {
	var i = index;
	var formData = new FormData();
	formData.append("sub_category", $("#subCategory option:selected").val());
	formData.append("category",$(':input:radio[name="category"]:checked').val());		
	formData.append("title", $("#title"+i).val());
	formData.append("media", $("#mediaFileName"+i).val());
	if($("#uploadThumb"+i)[0].files[0] == "undefined" || $("#uploadThumb"+i)[0].files[0] == null){
		formData.append("thumbnail", "");
	}else{
		formData.append("thumbnail", $("#uploadThumb"+i)[0].files[0]);
	}
	formData.append("content", $("#content"+i).val());
	formData.append("mode", $("#mode").val());
	
	
	$.ajax({
		url		  : '${pageContext.request.contextPath}/rad/contents/createMediaUpload.kh'
		, data		  : formData
		, dataType	  : 'json'
		, contentType : false
		, async		  : false
		, processData : false
		, type		  : 'post'
		, success	  : function(data, textStatus) {
			var media_no = data['result']; 
			if(data['result'] != null || data['result'] != ''){
				$("#media_no"+i).val(media_no);
				uploadMedia('${mediaId}', i);
			}
		}
		, error		  : function(jqXHR, textStatus, errorThrown) {
			alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
		}
	});
};

function removeMediaForm(no){
	count += -1;
	if(count < 0){
		count = 0;
	}
	$("#count").val(count);
	var tr = $("."+no+"row").closest('tr');
	 
	tr.next('tr').next('tr').next('tr').next('tr').remove();
	tr.next('tr').next('tr').next('tr').remove();
	tr.next('tr').next('tr').remove();
	tr.next('tr').remove();
	tr.remove(); 
	$("#mediaFrm"+no).remove();
	$("#duration"+no).remove();
	$("#midi_thumbnail"+no).remove();
	$("#object_id"+no).remove();
	$("#media_id"+no).remove();
	$("#media_no"+no).remove();
}

</script>
<body><!-- count > 1 display else display none  -->
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/header_2018.jsp"/>
	<jsp:include page="/WEB-INF/jsp/rad/portlet/right_quick.jsp"/>
	<input type="hidden" id="location_name" value="disable">	

	<!-- 로딩용 오브젝트 -->
	<div class="popup_layer" id="loading">
		<div class="popup_layer_bg"></div>
		<div class="popup_layer_cont" style="background: none; height: 155px; width: 180px;">
			<img src="${pageContext.request.contextPath}/resources/images/sub06/sub06_loading.gif" alt="now loading....">
		</div>
	</div>

	<div id="media_student_popup" class="popupcom media_student_popup" style="top: 20%; left: 44%; width: 200px;">
	</div><!-- //media_student_popup -->
	
	<form id="tx_editor_form" name="tx_editor_form" action="${pageContext.request.contextPath}/rad/contents/mediaUploadSave.kh" method="post" enctype="multipart/form-data">
	<section id="section">
		<div class="sectionwrap subcomWrap">
			<div class="gonggamWrite">
				<div class="tit">
					<h3>학습동영상</h3>
				</div>
				<div class="subcontent gongWritecontent Writecontent">
					<div class="writetit">
						<p>학습동영상 ${params.mode=='insert'? '등록':'수정' }
						<c:if test="${params.mode == 'insert' }">
							<img id="minus_btn" onClick="removeMediaForm(document.getElementById('count').value);" src="${pageContext.request.contextPath}/resources/images/rad/minus_btn_media.png" style="float:right; margin-top: 3px; margin-left: 5px;" >
							<img onClick="addMediaForm();" src="${pageContext.request.contextPath}/resources/images/rad/main/calweekPlus.png" style="float:right; margin-top: 3px;">
						</c:if>
						</p>
					</div>
					<div class="writeTable">
						<table cellpadding="0" cellspacing="0" id="mediaTable">
							<caption>학습동영상 작성 테이블</caption>
							<colgroup>
							   <col width="118" /> 
							   <col width="1059" />
							</colgroup>
							<tbody>								
								<tr>
									<th>작성자</th>
									<td>${params.mode == 'update'? mediaViewData.name : sessionScope.aduser.name}</td>
								</tr>
								<tr>
									<th>카테고리</th>
									<td>
										<c:if test="${sessionScope.aduser.role_code == 'TP' || sessionScope.aduser.role_code == 'TF'}">
											<label>
												<input type="radio" name="category" data-validate="radio" data-message="카테고리를 선택해주세요." 
													value="${fn:contains(sessionScope.aduser.depart, '자바') ? '자바' : '보안' }" 
													${mediaViewData.category != null or mediaViewData.category == '' ? 'checked' : ''} 
													onClick="setSubCategory('${fn:contains(sessionScope.aduser.depart, '자바') ? '1' : '2' }', '', true);" />
												${fn:contains(sessionScope.aduser.depart, '자바') ? '자바' : '보안' }
											</label>
										</c:if>
										<c:if test="${sessionScope.aduser.role_code != 'TP' && sessionScope.aduser.role_code != 'TF'}">
											<c:if test="${sessionScope.aduser.role_code =='TM' }">
												<label>
													<input type="radio" name="category" data-validate="radio" data-message="카테고리를 선택해주세요."
														value="${fn:contains(sessionScope.aduser.depart, '자바') ? '자바' : '보안' }" 
														${mediaViewData.category != '' ? 'checked' : ''} 
														onClick="setSubCategory('${fn:contains(sessionScope.aduser.depart, '자바') ? '1' : '2' }', '', true);" />
													${fn:contains(sessionScope.aduser.depart, '자바') ? '자바' : '보안' } 
												</label>	
											</c:if>
											<c:if test="${sessionScope.aduser.role_code !='TM' }">
												<label>
													<input type="radio" name="category" value="자바" data-validate="radio"
													       data-message="카테고리를 선택해주세요." ${mediaViewData.category == '자바' || mediaViewData.category == null ? 'checked' : ''} 
														   onClick="setSubCategory('1', '', true);"/>자바
												</label>											
												<label>
													<input type="radio" name="category" value="보안" ${mediaViewData.category == '보안' ? 'checked' : ''} 
													       onClick="setSubCategory('2', '', true);"/>보안
												</label>
											</c:if>
											<label>
												<input type="radio" name="category" value="홍보" ${mediaViewData.category == '홍보' ? 'checked' : ''} 
												       onClick="setSubCategory('3', '', true);"/>홍보
											</label>
										</c:if>
										<label>
											<input type="radio" name="category" value="우리반영상" ${mediaViewData.category == '우리반영상' ? 'checked' : ''} 
											       onClick="setSubCategory('4', '', true);"/>우리반영상
										</label>
										<label>
											<input type="radio" name="category" value="사전학습" ${mediaViewData.category == '사전학습' ? 'checked' : ''} 
											       onClick="setSubCategory('5', '', true);"/>사전학습
										</label>
										<span id="category_error" class="validate_error_message" name="validate_error_message"></span>
									</td>
								</tr>
								<tr id="sebu_category">
									<th>세부 카테고리</th>
									<td>
										<select id="subCategory" name="subCategory" style="width: 165px;">
											<option value="">전체영상</option>
											<c:forEach items="${subCategoryList}" var="subCategory">
												<option value="${subCategory.no}" 
												        name="subCategory${subCategory.parent_no}"
														${mediaViewData.sub_category == subCategory.no ? 'selected' : ''}
														style="display: none;">
														${subCategory.name}</option>
											</c:forEach>
										</select>
									</td>
								</tr>
								<tr>
									<th>제목</th>
									<td>
										<input type="text" id="title0" name="title0" data-validate="required"
											data-message="제목을 입력해주세요." value="${mediaViewData.title}" style="width: 700px;">
										<span id="title0_error" class="validate_error_message" name="validate_error_message"></span>
									</td>
								</tr>								
								<tr>
									<th>썸네일</th>
									<td class="file" id="thumbnailUploadCont0">
										<div class="fileInput">
											<input type="text" id="thumbName0" name="thumbName0" readonly
												value="${fn:split(mediaViewData.thumbnail, '|')[1]}">
											<input type="file" id="uploadThumb0" name="thumbnail0" style="display:none;" value=""
												onchange="document.getElementById('thumbName0').value = this.value">
											<div class="txtdel" 
												onClick="document.querySelector('#thumbnailUploadCont0 input').value = '';">
												<img src="${pageContext.request.contextPath}/resources/images/rad/input_x.png" alt="글씨 삭제 버튼">
											</div>
										</div>
										<span class="btnSm file_btn">
											<a href="javascript:void(0)" onClick="document.getElementById('uploadThumb0').click();">찾아보기</a>
										</span>
									</td>
								</tr>
								<tr>
									<th>동영상</th>
									<td class="file" id="mediaUploadCont0">
										<div class="fileInput">
											<input type="text" id="mediaFileName0" name="media0" readonly value="${mediaViewData.media}"
												data-validate="required" data-message="동영상을 업로드해주세요.">
											<div class="txtdel"
												onClick="document.querySelector('#mediaUploadCont0 input').value = '';">
												<img src="${pageContext.request.contextPath}/resources/images/rad/input_x.png" alt="글씨 삭제 버튼">
											</div>
										</div>
										<span class="btnSm file_btn">
											<a href="javascript:void(0)" 
												onClick="document.getElementById('mediaFile0').click(); document.getElementById('uploadFlag').value=false">찾아보기</a>
												<!-- if(categorySelectFlag) <onclick조건 수정> -->
												<!-- style="background: #ececec; cursor: default;"  -->
										</span>
										<div><span id="media0_error" class="validate_error_message" name="validate_error_message"></span></div>
									</td>
								</tr>
								<tr>
									<th>설명</th>
									<td>
										<textarea id="content0" name="content0" data-validate="required" data-message="설명을 입력해주세요." style="border: 1px solid #dfe2e9; width: 83%; margin: 6px 0; height: 85px; overflow-y: auto; ">${mediaViewData.content}</textarea>										
										<span id="content0_error" class="validate_error_message" name="validate_error_message"></span>
									</td>
								</tr>
							</tbody>
						</table>
					</div><!-- class="writeTable"-->
					<div class="WriteBtn">
						<div class="btnMd update" >
							<a href="javascript:void(0);" onClick="fnValidateData();">
								<c:if test="${params.mode!='update'}">등록</c:if>
								<c:if test="${params.mode=='update'}">수정</c:if>
							</a>
						</div>
						<div class="btnMd cancel">
							<a href="javascript:void(0);" onClick="document.backFrm.submit();">취소</a>
						</div>
						<input type="hidden" id="duration0" name="duration0" value="${mediaViewData.duration}">
						<input type="hidden" id="midi_thumbnail0" name="midi_thumbnail0" value="${mediaViewData.midi_thumbnail}">
						<input type="hidden" id="object_id0" name="object_id0" value="${mediaViewData.object_id}">
						<input type="hidden" id="media_id0" name="media_id0" value="${mediaViewData.media_id}">
						<input type="hidden" id="media_no0" name="media_no0" value="${params.no}">
						<input type="hidden" id="mode" name="mode" value="${params.mode}">
						<input type="hidden" id="no" name="no" value="${params.no}">
						<input type="hidden" id="cpage" name="cpage" value="${params.cpage}">
						<input type="hidden" id="url" name="url" value="rad/contents/mediaUpload${params.mode == 'insert' ? '' : 'View'}.kh">
						<input type="hidden" id="count" name="count" value="0" >
						<input type="hidden" id="uploadFlag" value="${params.mode == 'update'?'true':false }"> 
					</div><!--class="WriteBtn"-->
				</div><!--class="subcontent gongWritecontent"-->
			</div><!--class="gonggamWrite"-->
		</div><!--class="subcomWrap"-->
	</section>
	</form>
	<form id="mediaFrm0" name="mediaFrm0">
		<input type="file" 
			id="mediaFile0" 
			name="file" 
			style="display:none;"
			onchange="document.getElementById('mediaFileName0').value=this.value;"
			>	
		<input type="hidden" id="mediaToken" value="${mediaToken}" />
	</form>

	<form name="backFrm" action="${pageContext.request.contextPath}/rad/contents/mediaUpload${params.mode == 'insert' ? '' : 'View'}.kh" method="POST">
		<input type="hidden" name="no" value="${params.no}">
		<input type="hidden" name="cpage" value="${params.cpage}">
		<input type="hidden" name="searchKey" value="${params.searchKey}">
		<input type="hidden" name="searchValue" value="${params.searchValue}">
		<input type="hidden" name="mode" value="${params.mode}">
	</form>
	
	<!--팝업 bg 시작-->
	<div class="popupBg" onClick="fnClosePopup();"></div>
	<!--팝업 bg 끝-->
	
	<!-- 우측 퀵메뉴 시작 -->	
	<!-- 우측 퀵메뉴 끝 -->	
	
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/footer_2018.jsp"/>	
</body>

<script type="text/javascript">
	// 필수입력사항 유효성검사용 값 세팅(validate.js)	
	function fnValidateData(){ // 등록 진행
		setValidateElement();
		fnValidate().then(errors => { // 유효성 검사 후 결과값에 따라 진행
			if (jQuery.isEmptyObject(errors)) { // valid => boolean				
				uploadMultiMedia();
			} else {
				alertValidateErrors();
			}
		});
	}

/*  	function fnSubmitData() {
		const form = document.getElementById("tx_editor_form");
		const formData = new FormData(form);
		formData.append("sub_category",$("#subCategory option:selected").val());		
		$.ajax({
			url		  : '${pageContext.request.contextPath}/rad/contents/mediaUploadSave.kh'
			, data		  : formData
			, dataType	  : 'json'
			, contentType : false
			, processData : false
			, type		  : 'post'
			, success	  : function(data, textStatus) {
				submitResult(data);
			}
			, error		  : function(jqXHR, textStatus, errorThrown) {
				alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
			}
		});
	}; */
	//이곳에서는 insert 대신 업데이트만 시행하도록 변경. 업데이트시에는 밑 주석처리한것들 모아서 보내기.
	function fnEachSubmitData(index , complete) {    // 0, true 
		var i = index;
		var mode = $("#mode").val();
		var formData = new FormData();
		formData.append("object_id", $("#object_id"+i).val());
		formData.append("media_id", $("#media_id"+i).val());
		formData.append("duration", $("#duration"+i).val());
		formData.append("midi_thumbnail", $("#midi_thumbnail"+i).val());
		formData.append("media_no", $("#media_no"+i).val());
		formData.append("mode", $("#mode").val()); 
		formData.append("no", $("#no").val());
		
		if(mode == 'update'){
			formData.append("sub_category", $("#subCategory option:selected").val());
			formData.append("category",$(':input:radio[name="category"]:checked').val());		
			formData.append("title", $("#title"+i).val());
			formData.append("content", $("#content"+i).val());
			formData.append("media", $("#mediaFileName"+i).val());
			if($("#uploadThumb"+i)[0].files[0] == "undefined" || $("#uploadThumb"+i)[0].files[0] == null){
				formData.append("thumbnail", "");
			}else{
				formData.append("thumbnail", $("#uploadThumb"+i)[0].files[0]);
			}
		}
		$.ajax({
			url		  : '${pageContext.request.contextPath}/rad/contents/mediaUploadSave.kh'
			, data		  : formData
			, dataType	  : 'json'
			, contentType : false
			, processData : false
			, type		  : 'post'
			, success	  : function(data, textStatus) {
				//submitResult(data);
				if(complete == 'true'){
					submitResult(data);
				}
			}
			, error		  : function(jqXHR, textStatus, errorThrown) {
				alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
			}
		});
	};
	

	function submitResult(response) {
		const result = response.result;
		const message = response.message;
		alert(message);

		if (Number(result) > 0) {
			document.backFrm.submit();
		}
	}	
</script>

<style>
	.curr_name_list {
		position: absolute; 
		top: 40px; 
		left: 15px; 
		width: 700px; 
		height: 300px; 
		padding: 10px; 
		overflow-y: scroll; 
		display: none; 
		background: #fff; 
		z-index: 1; 
		border: 1px solid #ececec;
	}
</style>
</html>