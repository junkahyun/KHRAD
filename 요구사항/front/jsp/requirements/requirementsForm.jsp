<%@page import="java.util.Calendar"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="org.springframework.util.FileCopyUtils"%>
<%@page import="java.net.URL"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 		uri="/WEB-INF/tlds/c.tld" %> 
<%@ taglib prefix="fn" 		uri="/WEB-INF/tlds/fn.tld" %>
<%@ taglib prefix="fmt"		uri="/WEB-INF/tlds/fmt.tld" %>
<%@ taglib prefix="utils" uri="/WEB-INF/tlds/utils.tld"%>
<%
	Calendar cal = Calendar.getInstance();
	Calendar currentDate = Calendar.getInstance();
	
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
<c:set var="dept" value="${sessionScope.aduser.dept_code}"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>KH정보교육원 RAD :: 요구사항</title>
<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/meta_2018.jsp"/>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/validate/validate.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/caculateDate/caculateDate.js"></script>

<c:set var="today" value="<%= strCD %>"/>
<style>
	#searchUser4Calendar { width: 100%; height: 36px;}
	.popup_btns .btnSm {padding: 0px 5px;}
	#pre_require_div, #large_category_div, #middle_category_div{position: absolute;
    width: 261px;
    height: 142px;
    padding: 10px;
    margin-left: 0px;
    overflow-y: scroll;
    background: rgb(255, 255, 255);
    z-index: 98;
    border: 1px solid rgb(236, 236, 236);
    text-align: left;
    display: none;}
    .require_input{color : #ff554d;}
    textarea{width: 100.7%;border: 1px solid #dfe2e9;}
    .validate_error_message {display:none;}
    .collaboWritecontent table tr td label{line-height: 31px;}
</style>
</head>
<body>
	<!--헤더 시작-->
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/header_2018.jsp"/>				
	<!--헤더 끝-->
	<jsp:include page="/WEB-INF/jsp/rad/portlet/right_quick.jsp"/>
	<input type="hidden" id="location_name" value="disable">	
	
	<section id="section">
		<form id="frm" name="frm" action="${pageContext.request.contextPath}/rad/notice/requirementsOk.kh" method="post">
		<div class="sectionwrap subcomWrap">
			<div class="collaboWrite">
				<div class="tit">
					<h3>요구사항</h3>
				</div>
				<div class="subcontent collaboWritecontent Writecontent">
					<div class="writetit">
						<p id="writetit">요구사항 ${params.mode == 'insert' ? '작성':'수정'}</p>
					</div>
					<div class="writeTable">
						<span style="float: right;"> : 필수 입력 항목 </span><span class="require_input" style="float: right;">*</span>
						<table id="shared_area" cellpadding="0" cellspacing="0">
							<caption>요구사항 작성 테이블</caption>
							<tbody>
								<tr>
									<th>제목<span class="require_input">*</span></th>
									<td colspan="15">
										<input type="text" id="require_title" name="require_title"  
										       data-validate="charLeast.3" data-message="제목을 입력해주세요." value="${data.require_title}" 
										       style="width: 44%;">
										<span id="require_title_error" 
										    class="validate_error_message" 
											name="validate_error_message"></span>
									</td>
								</tr>
								<tr>
									<th style="width: 110px; ">작업번호</th>
									<td colspan="3" >
										${data.no}
									</td>
									<th style="width: 110px;">선행작업</th>
									<td colspan="3" >
										<input type="text" id="pre_require_no" name="pre_require_no" placeholder="요구사항 내용을 검색하세요."
										       value="${data.pre_require_no == 0 ? '':data.pre_require_no }" autocomplete="off">
										<div id="pre_require_div" class="pre_require_div"></div>
										<span id="pre_require_no_error" 
										    class="validate_error_message" 
											name="validate_error_message"></span>
									</td>
									<th style="width: 110px; ">대분류<span class="require_input">*</span></th>
									<td colspan="3" >
										<input type="text" id="large_category" name="large_category" 
										       data-validate="charLeast.3" data-message="대분류를 입력해주세요." value="${data.large_category}">
									    <div id="large_category_div" class="large_category_div" style="width: 158px;" ></div>
										<span id="large_category_error" 
										    class="validate_error_message" 
											name="validate_error_message"></span>
									</td>
									<th style="width: 110px; ">중분류<span class="require_input">*</span></th>
									<td colspan="4" >
										<input type="text" id="middle_category" name="middle_category" 
										       data-validate="charLeast.3" data-message="중분류를 입력해주세요." value="${data.middle_category}">
								        <div id="middle_category_div" class="middle_category_div" style="width: 158px;" ></div>
										<span id="middle_category_error" 
										    class="validate_error_message" 
											name="validate_error_message"></span>
									</td>
								</tr>
								<tr>
									<th style="vertical-align: middle;">요구사항 내용<span class="require_input">*</span></th>
									<td colspan="15" style="padding: 15px;">
										<textarea rows="8" id="require_content" name="require_content"  
										          data-validate="charLeast.3" data-message="요구사항 내용을 입력해주세요.">${fn:escapeXml(data.require_content)}</textarea>
										<span id="require_content_error" 
										    class="validate_error_message" 
											name="validate_error_message"></span>
									</td>
								</tr>
								<tr>
									<th style="width: 110px; ">요청부서<span class="require_input">*</span></th>
									<td colspan="3" >
										<input type="text" id="requesting_dept" name="requesting_dept"  
										       data-validate="charLeast.3" data-message="요청부서를 선택해주세요." 
										       value="${data.requesting_dept}" onclick="fnSelectDepartment();" readonly>
										<span id="requesting_dept_error" 
										    class="validate_error_message" 
											name="validate_error_message"></span>
									</td>
									<th style="width: 110px; ">요청자</th>
									<td colspan="3">
										<input type="text" id="requestor" name="requestor" value="${data.requestor}">
									</td>
									<th style="width: 110px; ">요청일<span class="require_input">*</span></th>
									<td colspan="3">
										<input type="text" id="request_date" name="request_date"  
											   data-validate="charLeast.3" data-message="요청일을 입력해주세요." value="${data.request_date}" readonly>
										<span id="request_date_error" 
										    class="validate_error_message" 
											name="validate_error_message"></span>
									</td>
									<th style="width: 110px; ">수용여부</th>
									<td colspan="4">
										<input type="radio" id="acceptance" name="acceptance" value="0" 
										       ${data.acceptance_flag == 0 ||  data.acceptance_flag == null ? 'checked' : ''}>
										<label for="acceptance">수용</label>
										<input type="radio" id="unacceptance" name="acceptance" value="1" 
										       ${data.acceptance_flag == 1 ? 'checked' : ''}>
										<label for="unacceptance">미수용</label>
									</td>
								</tr>
								<tr calss="tr_unacceptable">
									<th>미수용 사유</th>
									<td colspan="15">
										<input type="text" id="unacceptable_reason" name="unacceptable_reason" 
										       value="${data.unacceptable_reason}" style="width: 99.2%; ">
										<span id="unacceptable_reason_error" 
										    class="validate_error_message" 
											name="validate_error_message"></span>
									</td>
								</tr>
								<tr >
									<th style="width: 110px; ">담당자</th>
									<td colspan="3" >
										<input type="text" id="charger_name" name="charger_name" value="${data.charger_name}">
									</td>
									<th style="width: 110px; ">시작일</th>
									<td colspan="3">
										<input type="text" id="start_date" name="start_date" value="${data.start_date}" readonly>
									</td>
									<th style="width: 110px; ">완료일</th>
									<td colspan="3">
										<input type="text" id="completion_date" name="completion_date" value="${data.completion_date}"  
										       style="width: 105px;" readonly>
									</td>
									<th style="width: 110px; ">개발기간</th>
									<td colspan="4">
										<input type="text" id="develop_period" name="develop_period" maxlength="3" value="${data.develop_period}" >
									</td>
								</tr>
								<tr>
									<th>현재단계</th>
									<td colspan="6">
										<input type="radio" id="stage_0" name="stage_radio" value="0" ${data.develop_stage == null || data.develop_stage == '대기' ? 'checked':''}>
										<label for="stage_0">대기</label>
										<input type="radio" id="stage_1_1" name="stage_radio" value="1.1" ${data.develop_stage == '분석/설계' ? 'checked':''}>
										<label for="stage_1_1">분석/설계</label>
										<input type="radio" id="stage_1_2" name="stage_radio" value="1.2" ${data.develop_stage == '구현' ? 'checked':''}>
										<label for="stage_1_2">구현</label>
										<input type="radio" id="stage_1_3" name="stage_radio" value="1.3" ${data.develop_stage == '테스트' ? 'checked':''}>
										<label for="stage_1_3">테스트</label>
										<input type="radio" id="stage_2" name="stage_radio" value="2" ${data.develop_stage == '완료' ? 'checked':''}>
										<label for="stage_2">완료</label>
										
									</td>
									<th style="width: 110px; ">관련부서</th>
									<td colspan="10">
										<input type="checkbox" class="relate_check" id="relate_0" value="0" >
										<label for="relate_0">경영지원본부</label>
										<input type="checkbox" class="relate_check" id="relate_1" value="1" >
										<label for="relate_1">대외협력본부</label>
										<input type="checkbox" class="relate_check" id="relate_2" value="2" >
										<label for="relate_2">컨텐츠기획본부</label>
										<input type="checkbox" class="relate_check" id="relate_3" value="3" >
										<label for="relate_3">입학상담부</label><br>
										<input type="checkbox" class="relate_check" id="relate_4" value="4" >
										<label for="relate_4">취업지원부</label>
										<input type="checkbox" class="relate_check" id="relate_5" value="5" >
										<label for="relate_5">운영부</label>
										<input type="checkbox" class="relate_check" id="relate_6" value="6" >
										<label for="relate_6">교육부</label>
									</td>
								</tr>
								<tr calss="tr_delay" >
									<th>지연 여부</th>
									<td colspan="16">
										<input type="radio" id="delay_0" name="delay_radio" value="0" ${data.delay_status == null || data.delay_status == '0' ? 'checked':''}>
										<label for="delay_0">미지연</label>
										<input type="radio" id="delay_1" name="delay_radio" value="1" ${data.delay_status == '1' ? 'checked':''}>
										<label for="delay_1">지연</label>
									</td>
								</tr>
								<tr>
									<th>지연 사유</th>
									<td colspan="16">
										<input type="text" id="delay_reason" name="delay_reason" 
										       value="${data.delay_reason}" style="width: 99.2%;">
									</td>
								</tr>
								<tr>
									<th>비고</th>
									<td colspan="16">
										<input type="text" id="etc" name="etc" 
										       value="${data.etc}" style="width: 99.2%;">
									</td>
								</tr>
							</tbody>
						</table>
					</div><!-- class="writeTable"-->
					<div class="WriteBtn">
						<div class="btnMd update">
							<a href="javascript:fnApply();">
								${params.mode == 'insert' ? '등록' : '수정'}
							</a>
						</div>
						<div class="btnMd cancel">
							<a href="javascript:fnBack();">취소</a>
						</div>
						<input type="hidden" id="mode" name="mode" value="${params.mode}">
						<input type="hidden" id="no" name="no" value="${params.no }">
						<input type="hidden" id="url" name="url">
						<input type="hidden" id="acceptance_flag" name="acceptance_flag" value="">
						<input type="hidden" id="develop_stage" name="develop_stage" value=""> 
						<input type="hidden" id="relate_dept" name="relate_dept" value="">
						<input type="hidden" id="target" name="target" value="A">
						<input type="hidden" id="branch" name="branch" value="0">
					</div><!--class="WriteBtn"-->
				</div><!--class="subcontent gongWritecontent"-->
			</div><!--class="gonggamWrite"-->
		</div><!--class="subcomWrap"-->
		</form>
	</section>

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
	
	<!--팝업 bg 시작-->
	<div class="popupBg" onClick="fnClosePopup();"></div>
	<!--팝업 bg 끝-->

	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/footer_2018.jsp"/>	
</body>
<script type="text/javascript">
(function(){
	settingCalendar();
	autoSearchSetting();
	preRequireSearch();
	
	if('${params.mode}' === 'update'){
	
		settingCheck();
	}
}());

function settingCheck(){
	let dept_split = '${data.relate_dept}'.split('_');
	
	for(let i=0; i<dept_split.length; i++){
		$('.relate_check').each(function(index,entry){
			if($(this).val() === dept_split[i]){
				$(this).attr("checked",true);
			}
		});
	}
}

function settingCalendar(){
	mkCalendar('request_date', 0, 'downMonthpop');
	mkCalendar('start_date', 0, 'downMonthpop');
}

$("body").on('click', function(e) {
	var clickPoint = $(e.target);
	
	if (!clickPoint.hasClass('pre_require_div')) {
		$("#pre_require_div").hide();
	}
});

function autoSearchSetting(){
	$.fn.autoSearch = function (id, url) {
		var checkNo = function(value) {
			var params = {
				keyword		: value,
				searchID    : id,
				site_id     : '${params.site_id}'
			};
			if(value.replace(/^\s+|\s+$/g,"") == ""){
				return false;
			}
			$.ajax({
				url		: url
				, data		: params
				, dataType	: 'html'
				, type		: 'post'
				, success	: function(data, textStatus){
					$("#"+id+"").show();
					$("#"+id+"").html(data);
				}
				, error		: function(jqXHR, textStatus, errorThrown){
					alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
				}
			});
		}

		$(this).keyup(function() {
			var value = $(this).val();
			checkNo(value);
		});
	}
}

$('#develop_period').on("keyup",function(){
	let develop_period = this.value;
	const pattern = /[\D]/gi;   //패턴을 정의합니다
	const match = pattern.exec(develop_period);  //입력된 값을 패턴에 적용한다
	
	let start_date = $('#start_date').val();
	
	if(match !== null){
		alert('숫자만 입력해주세요.');
		$('#develop_period').val('');
		$('#develop_period').focus('');
	}
	else{
		if(develop_period !== '' && start_date !== ''){
			const period = parseInt(develop_period);
			let arrayDate = [];
			let count;
			
			arrayDate.push(start_date);
			
			while(count !== 0){  
				let pass_day  = '';
				let completion_date = '';
				
				let split_start = arrayDate[0].split('.');//시작일
				let start = new Date(split_start[0], split_start[1]-1, split_start[2]);//임시 시작일1
				let temp_comp = new Date(split_start[0], split_start[1]-1, split_start[2]);//임시 시작일2 
				
				if(arrayDate.length === 1){
					count = period;//기간
					completion_date = addPeriod(temp_comp, count, '');//임시 완료일
					count = weekend(start, count, pass_day);// 주말 갯수 구하기
				}
				else{
					split_start = arrayDate[arrayDate.length-1].split('.');//시작일
					start = new Date(split_start[0], split_start[1]-1, split_start[2]);//임시 시작일1
					temp_comp = new Date(split_start[0], split_start[1]-1, split_start[2]);//임시 시작일2 
					
					
					let temp_day = temp_comp.getDay();
					if(temp_day === 0 || temp_day === 6){
						pass_day = 'pass_day';
					}
					completion_date = addPeriod(temp_comp, count, 'temp_add');//임시 완료일
					count = weekend(start, count+1, pass_day);// 주말 갯수 구하기
				}
				temp_comp = completion_date;
				
				if(count !== 0){
					arrayDate.push(getFinalDate(temp_comp));
				} 
				else{
					const final_day = completion_date.getDay(); 
					temp_comp = getFianl(final_day, completion_date); 
					
					const comp = getFinalDate(temp_comp);
					$('#completion_date').val(comp);
				}
		 	}  
		}  
	}
})

function preRequireSearch(){
	let url = '${pageContext.request.contextPath}/rad/notice/requireAutoSearch.kh';
	$("#pre_require_no").autoSearch('pre_require_div', url);
}

setValidateElement();

function fnApply() { // 신청하기 진행
	fnValidate().then(errors => { // 유효성 검사 후 결과값에 따라 진행
		if (jQuery.isEmptyObject(errors)) { // valid => boolean
			fnUpdate();
		} else {
			for (let i = 0; i < validate_list.length; i++) {
				const element = validate_list[i]['name'];

				if (element in errors) {
					alert(validate_list[i]['message']);
					return;
				}
			}
		}
	});
}

function setInsertValue(){
	let acceptance = $("input:radio[name='acceptance']:checked").val();
	let develop_stage = $("input:radio[name='stage_radio']:checked").val();
	let delay_status = $("input:radio[name='delay_radio']:checked").val();
	$('#acceptance_flag').val(acceptance);
	$('#develop_stage').val(develop_stage);
	$('#delay_status').val(delay_status);
}

function setInsertCheck(){
	let dept = '';
	$('.relate_check:checked').each(function(){
		dept += $(this).val()+'_';
	});
	$('#relate_dept').val(dept);
}

function fnUpdate(){
	setInsertValue();
	setInsertCheck();
	if($('#request_date').val() === ''){
		alert('요청일을 입력해주세요.');
		return;
	}
	if($('#acceptance_flag').val() === '1' && $('#unacceptable_reason').val() === ''){
		alert('미수용 사유를 작성해주세요.');
		return;
	}
	if($('#start_date').val() !== '' && $('#develop_period').val() === ''){
		alert('개발기간을 입력해주세요.');
		return;
	}
	if($('#start_date').val() !== '' && $('#develop_period').val() === '0'){
		alert('완료일은 시작일보다 이전일 수 없습니다.');
		return;
	}
	if($('#delay_status').val() === '1' && $('#delay_reason').val() === ''){
		alert('지연사유를 작성해주세요.');
		return;
	}
	else{
		let encode = '${params.searchContent}';
		encode = encodeURI(encodeURIComponent(encode));
		var url = "rad/notice/";
		if('${params.mode}' === 'insert') url+="requirementsBoard.kh";
		else url+="requirementsView.kh?no=${params.no}&cpage=${params.cpage}&sort=${params.sort}&searchKey=${params.searchKey}&searchKey2=${params.searchKey2}&searchContent="+encode+"";
		$("#url").val(url);
		
		var f=document.getElementById('frm');
		f.submit();
	}
}

function fnBack(){
	if('${params.mode}' === 'insert')
		location.href='${pageContext.request.contextPath}/rad/notice/requirementsBoard.kh?cpage=${params.cpage}';
	else
		history.go(-2);
} 

function fnRetrieveOrg() {
	myTree = new dhtmlXTreeObject("viewOrg","100%","100%",0);
	myTree.setOnClickHandler(onTreeitemClick);
	myTree.setXMLAutoLoading("${pageContext.request.contextPath}/rad/auth/org/orgTree.kh");
	myTree.setImagePath("${pageContext.request.contextPath}/resources/js/dhtmlx/suite/skins/web/imgs/dhxtree_web/");
	myTree.setDataMode("xml");
	myTree.load("${pageContext.request.contextPath}/rad/auth/org/orgTree.kh?id=1");//KH정보교육원
	myTree.setOnClickHandler(onTreeitemClick);// 팝업요소 클릭이벤트
}


function onTreeitemClick(itemId,type){
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
			$("#requesting_dept").val( replaceAll(dept, "_", "/") );
		}
		, error		: function(jqXHR, textStatus, errorThrown) {
			alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
		}
	});
}

function fnSelectDepartment(){
	fnRetrieveOrg();	
	fnOpenPopup('department');
}

</script>
</html>