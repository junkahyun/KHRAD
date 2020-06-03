<%@page import="java.util.Date"%>
<%@page import="com.kh.utils.Utils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 		uri="/WEB-INF/tlds/c.tld" %> 
<%@ taglib prefix="fn" 		uri="/WEB-INF/tlds/fn.tld" %>
<%@ taglib prefix="fmt"		uri="/WEB-INF/tlds/fmt.tld" %>
<%@ taglib prefix="utils"	uri="/WEB-INF/tlds/utils.tld" %>
<%
	String cpage = Utils.nvl((String)request.getAttribute("cpage"), "1");
	int total = (Integer)request.getAttribute("total");
	Date date = new Date();
%>
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
<jsp:include page="/WEB-INF/jsp/rad/common/_kh/header_2018.jsp"/>			
<jsp:include page="/WEB-INF/jsp/rad/portlet/right_quick.jsp"/>

<script type="text/javascript">
/**
 * 상단 지원탭 클릭 시 페이지 이동하는 함수_2020.05.04
 */
function fnBranch(no){
	$("#branch").val(no);
	doPagingClick(1);
}

/*
 * 하단 페이지 넘버 클릭 시 페이지 이동하는 함수_2020.05.04
 */
function doPagingClick(page){
	$("#cpage").val(page);
	document.frm.submit();
}

/*
 * 검색시 글자수 체크하는 함수_2020.05.07
 */
function fnSearchEnter(){
	if(event.keyCode==13){
		fnSearch2();
	}
}

/*
 * 검색 버튼 클릭시 페이지 이동하는 함수_2020.05.07
 */
function fnSearch2(){
	doPagingClick(1);	
}

/*
 * 과정명 클릭 시 설문결과 페이지 이동하는 함수_2020.05.04
 */
function fnSelect(curr_no, template_no, emp_survey_date, emp_survey_end){
	$('#curr_no').val(curr_no);
	$('#template_no').val(template_no);
	$('#emp_survey_date').val(emp_survey_date);
	$('#emp_survey_end').val(emp_survey_end);
	document.frm.action = '${pageContext.request.contextPath}/rad/recruit/empSurveyView.kh';
	document.frm.submit();
}

/*
 * confirm 메시지 세팅하는 함수_2020.05.07
 */
 function confirmMessage(emp_index){
	let message = '';
	switch (emp_index) {
		case '0':
			message = '설문조사를 시작하시겠습니까?';
			break;
		case '1':
			message = '설문조사를 종료하시겠습니까?';
			break;
		case '2':
			message = '설문조사를 재시작 하시겠습니까?';
			break;
		default:
			break;
	}
	return confirm(message);
}

/*
 * alert 메시지 세팅하는 함수_2020.05.07
 */
function alertMessage(emp_index){
	let message = '';
	switch (emp_index) {
		case '0':
			message = '설문조사가 시작되었습니다.';
			break;
		case '1':
			message = '설문조사가 종료되었습니다.';
			break;
		case '2':
			message = '설문조사가 재시작되었습니다.';
			break;
		default:
			break;
	}
	return alert(message);
}

/*
 * 설문조사 버튼 클릭 시 설문 상태 변경하는 함수_2020.05.04
 */
function surveyStatusChange(no, degree, emp_date, emp_end){
	const split_end = emp_end.split('_');
	const emp_index = split_end[degree - 1];
	
	if(emp_end.indexOf('1') !== -1 && emp_index !== '1'){
		alert('설문조사는 동시에 진행할 수 없습니다.');
	}
	else if(confirmMessage(emp_index) === true){
		const params = {
				no : no,				
				degree : degree,
				emp_date : emp_date,
				emp_end : emp_end
		};
		
		$.ajax({
			  url		: '${pageContext.request.contextPath}/rad/recruit/surveyStatusChange.kh' 
			, data		: params
			, async		: true
			, type		: 'post'
			, success	: function(data, textStatus) {
				alertMessage(emp_index);
				window.location.reload();
			}
			, error		: function(jqXHR, textStatus, errorThrown) {
				alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
			}
		}); 
	}
}
</script>
</head>
	<body>
		<!--section-->
		<section id="section">
			<div class="sectionwrap subcomWrap">
				<div class="jobsurvey_wrap">
					<div class="tit">
						<h3>취업 설문조사</h3>
					</div>
					<div class="subcomTap boxtapWrap">
						<ul class="tab">
							<c:forEach var="bds" items="${brList }" varStatus="vs">
							<li class="${bds.no==params.branch? 'outon':''}">
								<p>
									<a href="javascript:fnBranch(${bds.no});">${bds.name}지원</a>
								</p>
							</li>
							</c:forEach>
						</ul>
					</div>
					<!--jobSurveyContent-->
					<div class="subcontent jobSurveyContent">
						<!-- 검색폼 시작 -->
						<form action="${pageContext.request.contextPath}/rad/recruit/empSurvey.kh" id="frm" name="frm" method="post" style="width:1186px;">
						<div class="botsearchBox" style="margin-top: 0;">
							<div class="selectMenuWrap">
								<select id="searchKey" name="searchKey">
									<option value="D.NAME"  ${params.searchKey == 'D.NAME' ||  params.searchKey == '' ? 'selected' : ''}>강사</option>
									<option value="E.NAME" ${params.searchKey == 'E.NAME'  ? 'selected' : ''}>취업담임</option>
								</select>
							</div><!--class="selectMenuWrap"-->
							<input type="text" class="text" id="searchValue" name="searchValue" onkeydown="fnSearchEnter();" value="${params.searchValue }">
							<div class="btnMd">
								<a href="javascript:fnSearch2();" style="background: #2a2a4e;">검색</a>
								<!-- 취업설문관리 새로운 페이지 링크 :  /rad/recruit/empSurveyManage.kh -->
								<utils:authority url="/rad/curr/surveyFormList.kh">
								<a href="${pageContext.request.contextPath}/rad/curr/surveyFormList.kh?cpage=1&classify=E" style="background: #ff626d;">취업설문관리</a>
								</utils:authority>
							</div>
						</div><!--class="botsearchBox"-->
							<input type="hidden" name="curr_no" id="curr_no" value="">
							<input type="hidden" name="template_no" id="template_no" value="">
							<input type="hidden" name="emp_survey_date" id="emp_survey_date" value="">
							<input type="hidden" name="emp_survey_end" id="emp_survey_end" value="">
							<input type="hidden" name="classify" id="classify" value="E">
							<input type="hidden" name="cpage" id="cpage" value="${params.cpage}">
							<input type="hidden" name="branch" id="branch" value="${params.branch}">			
							<input type="hidden" name="search" id="search" value="${params.search}">
							<input type="hidden" name="surveing" id="surveing" value="${params.surveing}">
						</form>
						<!-- 검색폼 끝 -->
						<div class="Job_SurveyTable">
							<div class="Job_Survey_In">
								<table cellpadding="0" cellspacing="0" id="jobsurvey_tab">
									<caption>취업설문조사목록</caption>
									<colgroup>
									   <col width="70"> 
									   <col width="220"> 
									   <col width="500">
									   <col width="260"> 
									   <col width="50"> 
									   <col width="50">  
									   <col width="50">
									   <col width="50">
									</colgroup>
									<thead>
										<tr>
											<th scope="col">번호</th>
											<th scope="col">기간</th>
											<th scope="col">과정명</th>
											<th scope="col">강사/담임</th>
											<th scope="col">1차</th>
											<th scope="col">2차</th>
											<th scope="col">3차</th>
											<th scope="col">4차</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="data" items="${list}">
										<c:set var="end_status" value="${fn:split(data.emp_survey_end,'_')}"></c:set>
										<tr>
											<td>${total-data.rnum+1}</td>
											<td>
												<p>${data.begin_date} ~ ${data.end_date}</p>
											</td>
											<td style="cursor: pointer;">
												<p class="left" 
												<c:if test="${fn:contains(data.emp_survey_end,'2')}">
												onclick="fnSelect('${data.no}', '${data.emp_survey_template}', '${data.emp_survey_date}', '${data.emp_survey_end}');"
												</c:if>
												>
												${data.currname}
												</p>
											</td>
											<td>
												<p>
													<span class="teacher_name">${data.prof} 강사</span>&nbsp;/&nbsp;<span class="jobteacher_name">${data.empl_charge} 취업담임</span>
												</p>
											</td>
											<td><!-- 1차 -->
												<button class="survey ${end_status[0] == '1' ? 'ing' : ''}" 
												        onclick="surveyStatusChange('${data.no}', '1', '${data.emp_survey_date}', '${data.emp_survey_end}');" >
												${end_status[0] == '0' ? '미진행' : (end_status[0] == '1' ? '진행중' : '완료')}
												</button>
											</td>
											<td><!-- 2차 -->
												<button class="survey ${end_status[1] == '1' ? 'ing' : ''}" 
												        onclick="surveyStatusChange('${data.no}', '2', '${data.emp_survey_date}', '${data.emp_survey_end}');" >
												${end_status[1] == '0' ? '미진행' : (end_status[1] == '1' ? '진행중' : '완료')}
												</button>
											</td>
											<td><!-- 3차 -->
												<button class="survey ${end_status[2] == '1' ? 'ing' : ''}" 
												        onclick="surveyStatusChange('${data.no}', '3', '${data.emp_survey_date}', '${data.emp_survey_end}');" >
												${end_status[2] == '0' ? '미진행' : (end_status[2] == '1' ? '진행중' : '완료')}
												</button>
											</td>
											<td><!-- 4차 -->
												<button class="survey ${end_status[3] == '1' ? 'ing' : ''}" 
												        onclick="surveyStatusChange('${data.no}', '4', '${data.emp_survey_date}', '${data.emp_survey_end}');" >
												${end_status[3] == '0' ? '미진행' : (end_status[3] == '1' ? '진행중' : '완료')}
												</button>
											</td>	
										</tr>
										</c:forEach>
									</tbody>
								</table>
							</div>
						</div>
						<div class="listNumBtn">
							<%= Utils.getPage2018(total,cpage, 20, 10) %>								
						</div>
					</div>
				</div>
			</div>
		</section>
		<!--//section-->
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/footer_2018.jsp"/>
	</body>
</html>

