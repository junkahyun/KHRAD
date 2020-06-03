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
	</head>
	<body>
		<!--section-->
		<section id="section">
			<div class="sectionwrap subcomWrap">
				<div class="jobsurvey_wrap">
					<div class="tit">
						<h3>취업설문관리</h3>
					</div>
					<!--jobSurveyContent-->
					<div class="subcontent jobSurveyContent">
						<div class="botsearchBox" style="margin-top: 0;">
							<div class="btnMd">
								<a href="${pageContext.request.contextPath}/rad/recruit/empSurveyManageForm.kh?cpage=${params.cpage}&classify=${params.classify}&mode=insert" style="background: #ff626d;">취업설문등록</a>
							</div>
						</div><!--class="botsearchBox"-->
						<div class="Job_SurveyTable">
							<div class="Job_Survey_In">
								<table cellpadding="0" cellspacing="0" id="jobsurvey_tab">
									<caption>취업설문조사목록</caption>
									<colgroup>
									   <col width="70"> 
									   <col width="100"> 
									   <col width="500">
									   <col width="150"> 
									   <col width="100"> 
									   <col width="100"> 
									</colgroup>
									<thead>
										<tr>
											<th scope="col">번호</th>
											<th scope="col">회차</th>
											<th scope="col">설문조사명</th>
											<th scope="col">작성자</th>
											<th scope="col">등록일</th>
											<th scope="col">기본설문</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="data" items="${list}">
										<tr onclick="fnSelect('${data.template_no}', '${data.survey_name}', '${data.degree}', '${data.curr_classify}');">
											<td>${data.template_no}</td>
											<td>
												<p>${data.degree}차</p>
											</td>
											<td>
												<p class="center">${data.survey_name}</p>
											</td>
											<td>
												<p>
													<span class="write_name">${data.name}</span>
												</p>
											</td>
											<td>
												<p>${fn:substring(data.reg_date, 0, 4)}. ${fn:substring(data.reg_date, 4, 6)}. ${fn:substring(data.reg_date, 6, 8)}</p>
											</td>
											<td>
												<p>${data.default_flag == 1 ? '기본설문' : ''}</p>
											</td>
										</tr>
										</c:forEach>
									</tbody>
								</table>
							</div>
						</div>
						<!--listNumBtn-->
						<div class="listNumBtn">
							<%= Utils.getPage2018(total,cpage, 12, 10) %>
						</div>
						<!--//listNumBtn-->
					</div>
				</div>
			</div>
			<form action="${pageContext.request.contextPath}/rad/recruit/empSurveyManage.kh" method="post" id="searchFrm" name="searchFrm">
				<input type="hidden" name="template_no" id="template_no" value="">
				<input type="hidden" name="survey_name" id="survey_name" value="">
				<input type="hidden" name="degree" id="degree" value="">
				<input type="hidden" name="cpage" id="cpage" value="${params.cpage }">
				<input type="hidden" name="classify" id="classify" value="${params.classify }">
				<input type="hidden" name="curr_classify" id="curr_classify" value="">
			</form>
		</section>
		<!--//section-->
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/footer_2018.jsp"/>
	</body>
<script>
/*
 * 상세페이지 이동하는 함수_2020.05.21
 */
function fnSelect(template_no, survey_name, degree, curr_classfiy) {
	$("#template_no").val(template_no);
	$("#survey_name").val(survey_name);
	$("#degree").val(degree);
	$("#curr_classify").val(curr_classfiy);
	document.searchFrm.action = "${pageContext.request.contextPath}/rad/recruit/empSurveyManageView.kh";
	document.searchFrm.submit();
}

/*
 * 하단 페이지 넘버 클릭 시 페이지 이동하는 함수_2020.05.21
 */
function doPagingClick(page){
	$("#cpage").val(page);
	document.frm.submit();
}
</script>
</html>