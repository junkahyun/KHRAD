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
<c:set var="currentDate"><fmt:formatDate value="<%=date%>" pattern="yyyyMMdd" /></c:set>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<c:if test="${sessionScope.aduser.site_id == 'kh' }">
<title>KH정보교육원 RAD :: 학사관리</title>
</c:if>
<c:if test="${sessionScope.aduser.site_id == 'atents' }">
<title>아텐츠 RAD :: 학사관리</title>
</c:if>
<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/meta.jsp"/>
<script type="text/javascript">
jQuery(function(){
	fnCurrentSub('03', "03");
	mkSelectDB("searchKey", '과정명,강의실,강사명,담임명', "C.CURRNAME,R.NAME,D.NAME,E.NAME");
	mkdSelectedValue('searchKey', "${params.searchKey==null or params.searchKey==''? 'CURRNAME':params.searchKey}");
});

//currView로 이동 제목만 걸어놨음(진행중에 관한 결과때문에)
function fnSelectLocation(no){
	location.href="${pageContext.request.contextPath}/rad/curr/currView.kh?no="+no;
}

//개강일순 개강일역순 종강일순 정렬
function fnSearch(search){
	$("#search").val(search)
	doPagingClick(1);
	/* location.href='${pageContext.request.contextPath}/rad/curr/survey.kh?search='+search+'&branch=${params.branch}'; */
}

//검색창 글자 수 체크
function fnSearchEnter(){
	if(event.keyCode==13)
		fnSearch2();
}

//설문 진행중 버튼
function fnSelect(no, survey_date, template_no, degree){
	if(survey_date==null || survey_date==''){
		alert('설문 기간이 지정되지 않은 과정입니다.');
		return;
	}

	location.href="${pageContext.request.contextPath}/rad/curr/surveyView.kh?no="+no+"&start_date="+survey_date+"&template_set=" + template_no + "&template_no="+template_no.split("_")[degree - 1]+"&degree="+degree+"&cpage=${params.cpage}&branch=${params.branch}&search=${params.search}&classify=D";
}

//각 지원 탭
function fnBranch(no){
	$("#branch").val(no);
	doPagingClick(1);
}

//페이징버튼
function doPagingClick(page){
	$("#cpage").val(page);
	document.searchFrm.submit();
}

//검색 폼 검색 버튼
function fnSearch2(){
	doPagingClick(1);	
}

</script>
<style type="text/css">
#board_list .cname { cursor: pointer; }
</style>
</head>
<body>
	<input type="hidden" id="location_name" value=" 학사관리 &nbsp; > &nbsp; 학생설문조사">	
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/metaHeader_2018.jsp"/>
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/header_2018.jsp"/>
	<jsp:include page="/WEB-INF/jsp/rad/portlet/right_quick.jsp"/>
	<div id="body" onmouseover="fnCloseSubs();" style="width: 100%;">
		<div id="headtitle">
			<div class="left">학생설문조사</div>
			<div class="right">
			</div>
		</div>
		<!-- 검색 폼 시작  -->
		<form action="${pageContext.request.contextPath}/rad/curr/survey.kh" method="post" id="searchFrm" name="searchFrm">
			<div id="board_search">
				<div class="board_search_line" style="border: 0; text-align: center;">
					<input id="searchKey" name="searchKey" style="width: 105px;" value="CURRNAME">
					<input type="text" id="searchValue" name="searchValue" size="35" onkeydown="fnSearchEnter();" style="text-align: center;" value="${params.searchValue }">
				</div>
				<div class="board_search_btns">
					<a href="javascript:fnSearch2();" class="btn">검색</a>
					<a href="${pageContext.request.contextPath}/rad/curr/survey.kh?branch=${params.branch}" class="btn">전체보기</a>
				</div>
			</div>
			<input type="hidden" name="no" id="no" value="">
			<input type="hidden" name="cpage" id="cpage" value="${params.cpage}">
			<input type="hidden" name="branch" id="branch" value="${params.branch}">			
			<input type="hidden" name="search" id="search" value="${params.search}">
			<input type="hidden" name="surveing" id="surveing" value="${params.surveing}">
		</form>
		<div class="side_btns">
			<div class="left">
				<c:forEach var="bds" items="${brList }" varStatus="vs">
				<a href="javascript:fnBranch(${bds.no});" class="btn ${bds.no==params.branch? '':'off'}">${bds.name }</a>
				</c:forEach>
			</div>
			<div class="right">
				<a href="javascript: return false;" onClick="fnSearch('ASC');" class="btn ${params.search == 'ASC' ? '' : 'off'}">개강일순</a>
				<a href="javascript: return false;" onClick="fnSearch('DESC');" class="btn ${params.search == 'DESC' ? '' : 'off'}">개강일역순</a>
				<a href="javascript: return false;" onClick="fnSearch('END');" class="btn ${params.search == 'END' ? '' : 'off'}">종강일순</a>
				<a href="javascript: return false;" 
					onClick="document.getElementById('surveing').value = (${params.surveing} == false); document.searchFrm.submit();" 
					class="btn ${params.surveing == 'true' ? '' : 'off'}"
					>설문조사 중인 과정</a>
				<utils:authority url="/rad/curr/surveyFormList.kh">
				<a href="${pageContext.request.contextPath}/rad/curr/surveyFormList.kh?cpage=1&classify=D" class="btn on">설문내용관리</a>
				</utils:authority>
			</div>
		</div>
		<table cellpadding="0" cellspacing="0" id="board_list">
			<tr>
				<th width="2%">번호</th>
				<th width="17%">과정명</th>
				<th width="5%">기수</th>
				<th width="5%;">강의실</th>
				<th width="5%;">개강일</th>
				<th width="5%;">종강일</th>
				<th width="3%;">담당교수</th>
				<th width="5%;">취업담당자</th>
				<th width="7%;">1차 설문</th>
				<th width="7%;">2차 설문</th>
				<th width="7%;">3차 설문</th>
				<th width="4%;">설문 비밀번호</th>
			</tr>
			<c:forEach var="data" items="${list}">
			<c:set var="cvdate" value="${fn:split(data.survey_date, '_')}"/>
			<tr>
				<td>${total-data.rnum+1}</td>
				<td onclick="fnSelectLocation(${data.no});">${data.currname}</td>
				<td>${data.class_count}</td>
				<td>${data.classroom}</td>
				<td>${data.begin_date}</td>
				<td>${data.end_date}</td>
				<td>${data.prof}</td>
				<td>${data.empl_charge}</td>
				<td class="cname" onclick="fnSelect(${data.no}, '${data.survey_date}', '${data.survey_template}', 1);">
					<c:if test="${cvdate[0]>currentDate}">${fn:substring(cvdate[0], 0, 4) }. ${fn:substring(cvdate[0], 4, 6) }. ${fn:substring(cvdate[0], 6, 8) }</c:if>
					<c:if test="${cvdate[0]<=currentDate and cvdate[0]!=''}">
						${fn:substring(cvdate[0], 0, 4) }. ${fn:substring(cvdate[0], 4, 6) }. ${fn:substring(cvdate[0], 6, 8) }<br/>
						${data.cv1} / ${data.person}
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						${fn:substring(data.survey_end, 0, 1)=='1'? "<span class='list_gray'>완료</span>":"<span class='list_blue'>진행중</span>"}
					</c:if>
				</td>
				<td class="cname" onclick="fnSelect(${data.no}, '${data.survey_date}', '${data.survey_template}', 2);">
					<c:if test="${cvdate[1]>currentDate}">${fn:substring(cvdate[1], 0, 4) }. ${fn:substring(cvdate[1], 4, 6) }. ${fn:substring(cvdate[1], 6, 8) }</c:if>
					<c:if test="${cvdate[1]<=currentDate and cvdate[1]!=''}">
						${fn:substring(cvdate[1], 0, 4) }. ${fn:substring(cvdate[1], 4, 6) }. ${fn:substring(cvdate[1], 6, 8) }<br/>
						${data.cv2} / ${data.person}
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						${fn:substring(data.survey_end, 2, 3)=='1'? "<span class='list_gray'>완료</span>":"<span class='list_blue'>진행중</span>"}
					</c:if>
				</td>
				<td class="cname" onclick="fnSelect(${data.no}, '${data.survey_date}', '${data.survey_template}', 3);">
					<c:if test="${cvdate[2]>currentDate}">${fn:substring(cvdate[2], 0, 4) }. ${fn:substring(cvdate[2], 4, 6) }. ${fn:substring(cvdate[2], 6, 8) }</c:if>
					<c:if test="${cvdate[2]<=currentDate and cvdate[2]!=''}">
						${fn:substring(cvdate[2], 0, 4) }. ${fn:substring(cvdate[2], 4, 6) }. ${fn:substring(cvdate[2], 6, 8) }<br/>
						${data.cv3} / ${data.person}
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						${fn:substring(data.survey_end, 4, 5)=='1'? "<span class='list_gray'>완료</span>":"<span class='list_blue'>진행중</span>"}
					</c:if>
				</td>
				<td>${data.password}</td>
			</tr>
			</c:forEach>
			<c:if test="${list==null or fn:length(list)==0}">
			<tr><td style="padding: 30px; text-align: center;" colspan="12">등록된 운영과정이 없습니다.</td></tr>
			</c:if>
		</table>
		<div id="board_nums">
			<%=Utils.getPage(total,cpage, 20, 20)%>
		</div>
		
	</div>
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/footer_2018.jsp"/>
</body>
</html>