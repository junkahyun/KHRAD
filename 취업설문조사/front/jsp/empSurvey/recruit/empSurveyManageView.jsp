<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 		uri="/WEB-INF/tlds/c.tld" %> 
<%@ taglib prefix="fn" 		uri="/WEB-INF/tlds/fn.tld" %>
<%@ taglib prefix="fmt"		uri="/WEB-INF/tlds/fmt.tld" %>
<%@ taglib prefix="utils"	uri="/WEB-INF/tlds/utils.tld" %>
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
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/job_survey.css?2020052100000"/>
	</head>
	<body>
		<!--section-->
		<section id="section">
			<div class="sectionwrap subcomWrap">
				<div class="jobsurvey_wrap viewwrap">
					<div class="tit">
						<h3>취업설문관리</h3>
					</div>
					<!--jobSurveyContent-->
					<div class="subcontent jobSurveyContent viewcontent">
						<div class="viewTop">
							<div class="toptxt">
								<p class="txt1">${template.survey_name}</p>
								<p class="txt2">등록일 : ${template.reg_date} | 작성자 : ${template.reg_name}</p>
							</div>
							<div class="topImg">
								<ul>
									<li class="thumbImg " style=" background: url(${pageContext.request.contextPath}/upload/profile/${template.reg_thum});background-size: cover;"></li>	
								</ul>
							</div>
							<div class="topLine"></div>
						</div>
						<!--//viewTop-->
						<!--class="Job_SurveyTable"-->
						
						<div class="Job_SurveyTable">
							<c:if test="${params.degree != '3'}">
							<div class="Job_SurveyView">
								<!-- 1,2,4차 인 경우 -->
								<table cellpadding="0" cellspacing="0">
									<caption>취업설문보기페이지</caption>
									<thead></thead>
									<tbody>
										<c:forEach var="data" items="${qData}" varStatus="qvs">
										<%-- 답변항목이 주관식인 경우 --%>
										<c:if test="${data.answer == 0}">
										<tr>
											<td>
												<p class="question_title">${qvs.count}. ${data.question}</p>
												<p class="question_answer">수강생 답변</p>
											</td>
										</tr>
										</c:if>
										<%-- 답변항목이 객관식인 경우 --%>
										<c:if test="${data.answer > 0}">
										<tr>
											<td >
												<p class="question_title">${qvs.count}. ${data.question}</p>
												<c:forEach var="aData" items="${data.aList}" varStatus="avs">
													<p class="question_answer">${avs.count}). ${aData.answer}</p>
												</c:forEach>
											<td>
										</tr>
										</c:if>
										</c:forEach>
									</tbody>
								</table>
							</div>
							<!--//class="Job_SurveyView-->
							</c:if>
							
							<c:if test="${params.degree == '3'}">
								<div class="right_table right_survey_answer" id="result_form">
									<div class="survey_form" >
										<!-- 3차 인 경우 -->
										<c:forEach var="data" items="${qData}" varStatus="qvs">
											<table cellpadding="0" cellspacing="0">
												<tbody>
													<tr>
														<td class="title_num" style="padding-left:0 !important;">${qvs.count + 1}. ${qvs.count != 4 ? data.question : '취업과 관련하여 개인 상담 시 얘기 나누고 싶은 부분이 있다면 적어주세요.'}</td>
													</tr>
													<table class="scrolltable std_information ${qvs.count == 1 ? 'std_information2' : ''}" cellpadding="0" cellspacing="0">
														<caption>${qvs.count + 1}. ${data.question}</caption>
														<colgroup>
														   <col width="${data.question_form == 1 ? '135' :''}"/>
														</colgroup>
														<tbody>
															<%-- 학생결과 가져오기 위한 index --%>
															<c:set var="index" value="${last_index == '' ? '0' : last_index}"/>
															
															<%-- 표형식인 경우 --%>
															<c:if test="${data.question_form == 1}">
															<c:if test="${qvs.count == 1}">
															<tr>
																<th>구분</th>
																<th style="width: 500px; border-left:0;">내용</th>
																<th style="border-left:0;">능력</th>
															</tr>
															</c:if>
															<c:if test="${qvs.count == 3}">
															<tr>
																<th>평가요소</th>
																<th style="width: 500px; border-left:0">평가기준</th>
																<th class="yes_txt" style="border-left:0">그렇다</th>
																<th class="no_txt" style="border-left:0">아니다</th>
															</tr>
															</c:if>
															
															<c:forEach var="sList" items="${data.sList}" varStatus="bvs" >
															
															<%-- 1, 3번 문제인 경우, (외국어,공인점수 항목 css를 맞춰주기 위해 공인점수 제외) --%>
															<c:if test="${qvs.count != 2 && sList.question != '공인점수'}">
															<tr class="multiple" name="q${qvs.count}">
																<td rowspan="${sList.count == 0 ? '' : sList.count}" 
																	style="${qvs.count == 3 ? 'text-align: center;' : ''}"
																	class="skill_title">${sList.question}</td>
																<%-- 문제 depth가 1 이상인 경우 --%>
																<c:if test="${sList.count > 0}">
																	<c:forEach var="bList" items="${sList.bList}">
																	<c:forEach var="bList1" items="${bList}" varStatus="bvs1" begin="0" end="0">
																		<td >${bList1.question}</td>
																		<c:if test="${qvs.count == 1}">
																			<td>
																				<c:forEach var="aList" items="${bList1.aList}" varStatus="avs" >
																				${aList.answer}
																				</c:forEach>
																			</td>
																		</c:if>
																		
																		<c:if test="${qvs.count == 3}">
																			<td class="yes"></td>
																			<td class="no"></td>
																		</c:if>
																	</c:forEach>
																	</c:forEach>
																</c:if>
																<%-- 문제 depth가 1 이상이 아닌 경우 --%>
																<c:if test="${sList.count == 0 }">
																	<c:if test="${sList.question != '외국어'}">
																	<td colspan="2">
																	외국어 입력
																	</td>
																	</c:if>
																	<c:if test="${sList.question == '외국어'}">
																	<td colspan="2" >(공인점수 : )</td>
																	</c:if>
																</c:if>
															</tr>
															
															<%-- 문제 depth가 1 이상인 경우 --%>
															<c:if test="${sList.count > 0}">
																<c:forEach var="bList" items="${sList.bList}">
																<c:forEach var="bList1" items="${bList}" varStatus="bvs1" begin="1" >
																<tr class="multiple" name="q${qvs.count}">
																	<td >${bList1.question}</td>
																	<c:if test="${qvs.count == 1}">
																	<td>
																		<c:forEach var="aList" items="${bList1.aList}" varStatus="avs" >
																		${aList.answer}
																		</c:forEach>
																	</td>
																	</c:if>
																	
																	<c:if test="${qvs.count == 3}">
																		<td class="yes"></td>
																		<td class="no"></td>
																	</c:if>
																</tr>
																</c:forEach>
																</c:forEach>
															</c:if>
															</c:if>
															
															<%-- 2번 문제인경우 --%>
															<c:if test="${qvs.count == 2}">
															<tr>
																<th scope="col">${sList.question}</th>
																<%-- 답변 항목이 select인 경우 --%>
																<c:if test="${sList.direct_input == 2}">
																<td colspan="${sList.count}">
																		<c:forEach var="bList" items="${sList.bList}">
																		<c:forEach var="bList1" items="${bList}" varStatus="bvs1" >
																		<p>
																			${fn:split(bList1.question,'_')[0]}
																			${fn:split(bList1.question,'_')[1]}
																		</p>
																		</c:forEach>
																		</c:forEach>
																</td>
																</c:if>
																<%-- 답변 항목이 객관식/주관식인 경우 --%>
																<c:if test="${sList.direct_input == 0}">
																<td name="q${qvs.count}">
																	<c:forEach var="bList" items="${sList.bList}">
																	<c:forEach var="bList1" items="${bList}" varStatus="bvs1" >
																	<c:forEach var="aList" items="${bList1.aList}" varStatus="avs" >
																	${aList.answer}
																	</c:forEach>
																	</c:forEach>
																	</c:forEach>
																</td>
																</c:if>
															</tr>
															</c:if>
															</c:forEach>
															</c:if>
															
															<%-- 표형식이 아닌 경우 --%>
															<c:if test="${data.question_form == 0}">
															
																<%-- 답변 항목이 객관식/주관식인 경우 --%>
																<c:if test="${data.direct_input == 0 }">
																<tr class="single" id="q${qvs.count}">
																<td class="txt_form">
																
																</td>
																</tr>
																</c:if>
															</c:if>
														</tbody>
													</table>
												</tbody>
											</table>
										</c:forEach>
									</div>
								</div>
							</c:if>	
						</div>
						<!--//class="Job_SurveyTable"-->
						
						<div class="btnMd">
							<a href="" class="btn_red">수정</a>
							<a onClick="surveyDefaultTemplate();" class="btn_blue">기본설문으로 설정</a>
							<a onClick="surveyTemplateDelete();" class="btn_navy" style="box-shadow: none">삭제</a>
						</div>
					</div>
					<!--//class="subcontent jobSurveyContent"-->
					<div class="ListpageBtn">
						<div class="btnMd">
							<a onclick="fnBackList();">목록</a>
						</div>
					</div>
				</div>
				<!--//class="jobsurvey_wrap"-->
			</div>
			<!--//class="sectionwrap subcomWrap"-->
			<form action="#" id="frm" name="frm" method="post">
				<input type="hidden" id="cpage" name="cpage" value="${params.cpage}" />
				<input type="hidden" id="mode" name="mode" value="update" />
				<input type="hidden" id="template_no" name="template_no" value="${params.template_no}" />
				<input type="hidden" id="survey_name" name="survey_name" value="${params.survey_name}" />
				<input type="hidden" id="degree" name="degree" value="${params.degree}" />
				<input type="hidden" id="classify" name="classify" value="${params.classify}" />
			</form>
		</section>
		<!--//section-->
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/footer_2018.jsp"/>
	</body>
	<script>
	/*
	 * 목록 버튼 클릭하는 함수_2020.05.21
	 */
	function fnBackList(){
		document.frm.action = '${pageContext.request.contextPath}/rad/recruit/empSurveyManage.kh';
		document.frm.submit();
	}
	
	/*
	 * 설문 삭제하는 함수_2020.05.21
	 */
	function surveyTemplateDelete() {
		if (confirm("정말로 삭제하시겠습니까?")) {
			var params = {
				template_no  : '${params.template_no}'
			};

			$.ajax({
				url		: '${pageContext.request.contextPath}/rad/curr/surveyTemplateDelete.kh'
				, data		: params
				, dataType	: 'json'
				, type		: 'post'
				, success	: function(data, textStatus){
					alert("삭제를 완료했습니다.");
					location.href = "${pageContext.request.contextPath}/rad/recruit/empSurveyManage.kh?cpage=${params.cpage}&classify=${params.classify}";
				}
				, error		: function(jqXHR, textStatus, errorThrown){
					alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
				}
			});
		}
	}
	
	/*
	 * 기본 설문 등록하는 함수_2020.05.21
	 */
	function surveyDefaultTemplate() {
		var params = {
			template_no  : '${params.template_no}',
			degree       : '${params.degree}',
			classify     : '${params.classify}',
			curr_classify : '${params.curr_classify}'
		};

		$.ajax({
			  url		: '${pageContext.request.contextPath}/rad/curr/surveyDefaultTemplate.kh'
			, data		: params
			, dataType	: 'json'
			, type		: 'post'
			, success	: function(data, textStatus){
				alert("등록을 완료했습니다.");
			}
			, error		: function(jqXHR, textStatus, errorThrown){
				alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
			}
		});
	}
	</script>
</html>