<%@page import="java.util.Calendar"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="org.springframework.util.FileCopyUtils"%>
<%@page import="java.net.URL"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 		uri="/WEB-INF/tlds/c.tld" %> 
<%@ taglib prefix="fn" 		uri="/WEB-INF/tlds/fn.tld" %>
<%@ taglib prefix="fmt"		uri="/WEB-INF/tlds/fmt.tld" %>
<%@ taglib prefix="utils"	uri="/WEB-INF/tlds/utils.tld" %>
<%@ page import="com.kh.utils.Utils"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<c:if test="${sessionScope.aduser.site_id == 'kh' }">
<title>KH정보교육원 RAD :: 취업 설문조사</title>
</c:if>
<c:if test="${sessionScope.aduser.site_id == 'atents' }">
<title>아텐츠 RAD :: 취업 설문조사</title>
</c:if>
<jsp:include page="/WEB-INF/jsp/rad/common/_kh/meta_2018.jsp"/>

</head>
	<body>
		<!--헤더 시작-->
		<jsp:include page="/WEB-INF/jsp/rad/common/_kh/header_2018.jsp"/>			
		<!--헤더 끝-->
		<jsp:include page="/WEB-INF/jsp/rad/portlet/right_quick.jsp"/>
		<input type="hidden" id="location_name" value="취업설문">	
		<!--section-->
		<section id="section">
			<div class="sectionwrap subcomWrap">
				<div class="jobsurvey">
					<div class="tit">
						<h3>취업 설문조사</h3>
					</div>
					<div class="viewTop">
						<div class="toptxt">
							<p class="txt1">[${curData.branch} ${curData.classroom}]${curData.currname }</p>
							<p class="txt2">${curData.begin_date } ~ ${curData.end_date } | ${curData.begin_time} ~ ${curData.end_time}</p>
							<p class="txt3">${curData.prof} 강사 / ${curData.empl_charge} 취업담임</p>
						</div>
						<div class="topImg">
							<ul>
								<li class="thumbImg" style="background: url(${pageContext.request.contextPath}/upload/profile/${curData.prof_thum}) no-repeat; background-size: cover;"></li>
								<li class="thumbImg" style="background: url(${pageContext.request.contextPath}/upload/profile/${curData.empl_thum}) no-repeat; background-size: cover;"></li>						
							</ul>
						</div>
					</div>
					<div class="subcomTap boxtapWrap">
						<c:set var="emp_end" value="${fn:split(params.emp_survey_end,'_')}"/>
						<ul class="tab">
							<li class="${params.degree == '1' ? 'outon' : ''}"
								<c:if test="${emp_end[0] != '0' }">
							    onclick="fnChangeSurvey('1', '${emp_end[0]}');"
							    </c:if>
							    >
								<p>
									<a class="${emp_end[0] == '0' ? 'sur_yet' : 'sur_done'}">설문 1차</a>
								</p>
							</li>		
							
							<li class="${params.degree == '2' ? 'outon' : ''}"
								<c:if test="${emp_end[1] != '0' }">
							    onclick="fnChangeSurvey('2', '${emp_end[1]}');"
							    </c:if>
							    >
								<p>
									<a class="${emp_end[1] == '0' ? 'sur_yet' : 'sur_done'}">설문 2차</a>
								</p>
							</li>	
							<li class="${params.degree == '3' ? 'outon' : ''}"
								<c:if test="${emp_end[2] != '0' }">
							    onclick="fnChangeSurvey('3', '${emp_end[2]}');"
							    </c:if>
							    >
								<p>
									<a class="${emp_end[2] == '0' ? 'sur_yet' : 'sur_done'}">설문 3차</a>
								</p>
							</li>						
							<li class="${params.degree == '4' ? 'outon' : ''}"
								<c:if test="${emp_end[3] != '0' }">
							    onclick="fnChangeSurvey('4', '${emp_end[3]}');"
 								</c:if>
							    >
								<p >
									<a class="${emp_end[3] == '0' ? 'sur_yet' : 'sur_done'}">설문 4차</a>
								</p>
							</li>						
						</ul>
					</div>
					<div class="subcontent">
						<div id="tab1" class="tabcontent outon">
							<div class="left_table_wrap">
								<div class="left_table">
									<div class="jobsurveyTable">
										<table cellpadding="0" cellspacing="0">
											<caption>취업설문조사</caption>
											<colgroup>
												<col width="" />
												<col width="" />
												<col width="" />
											</colgroup>
											<thead>
												<tr>
													<c:if test="${params.degree != '2' and params.degree != '4'}">
													<th scope="col">
														<input type="checkbox" name="all_check" onclick="fnCheck();">
													</th>
													</c:if>
													<th scope="col" class="${params.degree != '2' and params.degree != '4' ? '' : 'number_th'}">번호</th>
													<th scope="col" class="${params.degree != '2' and params.degree != '4' ? '' : 'name_th'}">이름(생년월일)</th>
													<th scope="col" class="${params.degree != '2' and params.degree != '4' ? '' : 'icon_th'}">설문여부</th>
												</tr>
											</thead>
											<tbody>
												<c:forEach var="sData" items="${sList}" varStatus="vs">
												<tr onclick="" id="s_${sData.no}" class="backTR">
													<c:set var="no2" value="${fn:split(sData.res_no,'-')[1]}"/>
													<c:if test="${params.degree != '2' and params.degree != '4'}">
													<td class="tdt1">
														<!-- data-res 선택학생 엑셀 다운로드시 생년월일 데이터 전달 -->
														<input type="checkbox" name="all_check" data-value="${sData.no}" data-res="${fn:split(sData.res_no,'-')[0]} - ${fn:substring(no2, 0, 1)}">
													</td>
													</c:if>
													<td>${vs.count}</td>
													
													<c:set var="status" value="${(emp_end[params.degree-1] == '1' and sData.survey_status == 1) 
													                           or emp_end[params.degree-1] == '2' ? 'done' : 'ing'}" />
													<td class="survey_${status}" onclick="fnSurveySelect('${sData.no}', '${params.degree}', '${params.curr_no}', '');">
														${sData.name}<span class="std_birth">(${fn:split(sData.res_no,'-')[0]} - ${fn:substring(no2, 0, 1)})</span>
														<c:if test="${sData.course == '탈락'}">(${sData.course})</c:if>
														<!-- 엑셀 전체 다운로드시 생년월일 데이터 전달 -->
														<input type="hidden" name="res_no_list" value="${fn:split(sData.res_no,'-')[0]} - ${fn:substring(no2, 0, 1)}" />
													</td>
													<td class="survey_${status}">
														<c:if test="${status == 'ing'}">
															<c:if test="${emp_end[params.degree-1] == '0' }">
															-
															</c:if>
															<c:if test="${emp_end[params.degree-1] != '0' }">
															<img src="${pageContext.request.contextPath}/resources/images/common/ing_icon.png" class="survey_ing_icon">
															</c:if>
														</c:if>
														<c:if test="${status == 'done' && sData.survey_status == 1}">
														완료
														</c:if>
														<c:if test="${status == 'done' && sData.survey_status == 0}">
														미응시
														</c:if>
													</td>													
												</tr>							
												
												</c:forEach>
											</tbody>
										</table>
									</div>
									<!--//jobsurveyTable-->
								</div>
								<!--//left_table-->
							</div>
							<!--//left_table_wrap-->
						</div>
						<div class="right_table right_survey_answer" id="result_form">
							<!-- 학생 결과 보기 -->
						</div>
						<!--//right_table-->
					</div>
					<!--//tab1-->
					<div class="btn">
						<div class="btnMd">
							<c:if test="${params.degree == '1' or params.degree == '3' }">
							<a class="btn_red" onclick="fnExcel('check');">선택명단 다운로드</a>
							<a class="btn_red" onclick="fnExcel('all');">전체 다운로드</a>
							</c:if>
							<c:if test="${params.degree == '2' or params.degree == '4' }">
							<a class="btn_red" onclick="fnExcel('statistics');">통계 다운로드</a>
							</c:if>
							<c:if test="${params.degree == '4'}">
							<a class="btn_red" onclick="fnExcel('all');">만족도 조사 및 내용 다운로드</a>
							</c:if>
							<a onclick="fnBackList();" class="btn_blue">목록</a>
						</div>
					</div>
				<!--//btn-->
				</div>
				<!--//subcontent-->
			</div>
			<!--//jobsurvey-->
		</div>
		<!--//sectionwrap subcomWrap-->
		<form action="#" id="frm" name="frm" method="post">
			<input type="hidden" name="curr_no" id="curr_no" value="${params.curr_no}">
			<input type="hidden" name="template_no" id="template_no" value="${params.template_no}">
			<input type="hidden" name="emp_survey_date" id="emp_survey_date" value="${params.emp_survey_date}">
			<input type="hidden" name="emp_survey_end" id="emp_survey_end" value="${params.emp_survey_end}">
			<input type="hidden" name="cpage" id="cpage" value="${params.cpage}">
			<input type="hidden" name="branch" id="branch" value="${params.branch}">			
			<input type="hidden" name="search" id="search" value="${params.search}">
			<input type="hidden" name="degree" id="degree" value="${params.degree}">	
			<input type="hidden" name="classify" id="classify" value="${params.classify}">		
			<input type="hidden" name="stdt_no" id="stdt_no" value="${params.firstStudent}">
			<input type="hidden" name="stdt_arr" id="stdt_arr" value="">		
			<input type="hidden" name="excel_down" id="excel_down" value="">
			<input type="hidden" name="mode" id="mode" value="">			
		</form>
	</section>
	<!--//section-->
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/footer_2018.jsp"/>	
	<script>
	</script>
</body>

<script>
jQuery(function(){
	/* 페이지 로딩시 설문조사 결과 페이지 세팅하는 함수_2020.05.07 */
	fnSurveySelect('${params.firstStudent}', '${params.degree}', '${params.curr_no}', '');
	/* 클릭된 학생의 tr색깔 변경 */
	fnChangeColorTR('${params.firstStudent}');
	// 0528 엑셀 다운로드시 학생 생년월일 전달 
	//fnPushResNo();
});


/*
 * 클릭된 학생의 tr색깔 변경하는 함수_2020.05.20
 */
function fnChangeColorTR(stdt_no){
	const click_stdt_no = $('#stdt_no').val();
	$('.backTR').css({'background' : ''});//배경색 전체 초기화
	
	if(click_stdt_no === stdt_no){//클릭한 tr만 색깔 변경
		$('#s_'+stdt_no+'').css({'background' : '#fafbfc'});
	}
}

/*
 * 수정 시 체크박스 disabled하는 함수_2020.05.20
 */
function fnChangeAttribute(mode){
	if(mode === 'update'){
		$('input[name="all_check"]').attr('disabled','disabled');
	}
}

/*
 * 상단 설문조사 차수 클릭 시 페이지 이동하는 함수_2020.05.07
 */
function fnChangeSurvey(degree, end_status){
	if(end_status === '1'){
		alert('해당 설문조사는 진행중입니다.\n설문조사 완료후 결과 조회가 가능합니다.');
		return;
	}
	$('#degree').val(degree);
	$('#excel_down').val('');
	document.frm.action = '${pageContext.request.contextPath}/rad/recruit/empSurveyView.kh';
	document.frm.submit();
}

/*
 * 설문조사결과 페이지 불러오는 함수_2020.05.07
 */
function fnSurveySelect(stdt_no, degree, curr_no, mode){
	document.frm.stdt_no.value = stdt_no;
	document.frm.mode.value = mode;
	fnChangeColorTR(stdt_no);
	fnChangeAttribute(mode);
	$("#result_form").load('${pageContext.request.contextPath}/rad/recruit/empSurveyResult.kh', 
							{curr_no: curr_no, degree : degree , classify: 'E' , stdt_no : stdt_no, 
						     template_no : '${params.template_no}', emp_survey_date : '${params.emp_survey_date}',
						     mode : mode});
}

/*
 * 목록 버튼 클릭하는 함수_2020.05.07
 */
function fnBackList(){
	document.frm.action = '${pageContext.request.contextPath}/rad/recruit/empSurvey.kh';
	document.frm.submit();
}



//0528 엑셀 전체 다운로드시 학생 생년월일 전달 
function fnPushResNo(){
	// 기존에 추가한 학생 생년월일 초기화 
	$('.check-ch3').remove();
		
	const ch3 = document.getElementsByName('res_no_list');
	let appendInput = '';
	ch3.forEach(function(item, index){
		$('#frm').append('<input type="hidden" name= "ch3" class="check-ch3" value="'+ch3[index].value+'">');
	});	
	
}

//0528 엑셀 선택 다운로드시 학생 생년월일 전달 
function fnPushCheckResNo(){
	// 기존에 추가한 학생 생년월일 초기화 
	$('.check-ch3').remove();
	
	let ch3= document.getElementsByName('all_check');
	let appendInput = '';
	ch3.forEach(function(item, index){
		if(ch3[index].checked === true){
			$('#frm').append('<input type="hidden" name= "ch3" class="check-ch3" value="'+ch3[index].dataset.res+'">');
		}
	});	
}


/*
 * 설문조사 결과 엑셀다운로드하는 함수_2020.05.08
 */
 function fnExcel(excel_down){
	// 선택항목 다운로드 
	if(excel_down === 'check'){
		 let stdt_arr = [];
		 let all_check = document.getElementsByName('all_check');
		 let false_count = 0;
		 all_check.forEach(function(entry,index){
			 if(all_check[index].checked === true){
				 stdt_arr.push(all_check[index].dataset.value);
			 }
			 else{
				 false_count++;
			 }
		 })
		 if(all_check.length === false_count){
			 alert('체크박스를 하나 이상 클릭해 주세요.');
			 return;
		 }
		 else{
			 $('#stdt_arr').val(stdt_arr);
		 }
		 		 
		 fnPushCheckResNo();
	} else {
		fnPushResNo();
	}
		
	document.frm.excel_down.value = excel_down;
	document.frm.action = '${pageContext.request.contextPath}/rad/recruit/empSurveyExcel.kh';
	document.frm.submit(); 
}

/*
 * 체크박스 전체체크하는 함수
 */
 function fnCheck(){
	 let all_check = document.getElementsByName('all_check');
	 all_check.forEach(function(entry,index){
		 if(all_check[index].checked === true){
			 all_check[index].checked = false;
		 }
		 else{
			 all_check[index].checked = true;
		 }
	 });
}
</script>
</html>