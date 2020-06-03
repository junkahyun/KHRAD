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
<%
	String cpage = Utils.nvl((String)request.getAttribute("cpage"), "1");
	int total = Integer.parseInt((String)request.getAttribute("total"));

	Calendar cal = Calendar.getInstance();
	Calendar currentDate = Calendar.getInstance();
	currentDate.add(cal.DATE, -3);
	
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
<c:if test="${sessionScope.aduser.site_id == 'kh' }">
<title>KH정보교육원 RAD :: 요구사항</title>
</c:if>
<c:if test="${sessionScope.aduser.site_id == 'atents' }">
<title>아텐츠 RAD :: 요구사항</title>
</c:if>
<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/meta_2018.jsp"/>
<c:set var="currentDate" value="<%=strCD %>"/>
<style>
	.listNumBtn > ul { border-top-width: 0px; }
	.listNumBtn { height: 70px; }
	
	.tdt{color: #999999;}
	.tdt1{color: #3e3e3e;}

	.btn {padding: 9px 31px; background: #f4f4f8; display: inline-block; font-size: 13px;}
	.on {color: #fff; background: #2a2a4e;}
	
	.btnMd a.pagingBtn{background: #2a2a4e;border-radius: 0;padding: 9px 23px;}
	
	.botsearchBox .searchBtn input[type=text]{width: 150px;}
	.collabotypeWrap .view2{width: 112px;}
	.view3{width: 112px;}
</style>

</head>
<body>
	<!--헤더 시작-->
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/header_2018.jsp"/>			
	<!--헤더 끝-->
	<jsp:include page="/WEB-INF/jsp/rad/portlet/right_quick.jsp"/>
	<input type="hidden" id="location_name" value="요구사항">	
	<section id="section">
		<div class="sectionwrap subcomWrap">
			<div class="collaborate">
				<div class="tit">
					<h3>요구사항</h3>
				</div>
				<div class="subcontent collabocontent">
					<div class="lefttop">
						<a class="btn ${params.sort == '-1'?'on':'off'}" href="javascript:fnSort('-1');">전체</a>
						<a class="btn ${params.sort == '0'?'on':'off'}" href="javascript:fnSort('0');">대기중</a>
						<a class="btn ${params.sort == '1' || params.sort == null || params.sort == '' ? 'on':'off'}" href="javascript:fnSort('1');">진행중</a>
						<a class="btn ${params.sort == '2'?'on':'off'}" href="javascript:fnSort('2');">완료</a>
					</div><!--class="righttop"-->
				<div class="righttop">
				<form action="${pageContext.request.contextPath}/rad/notice/requirementsBoard.kh" method="post" id="searchFrm" name="searchFrm">				
				<div class="botsearchBox" style="margin: 0px;">
					<div class="selectMenuWrap collabotypeWrap">
						<select id="searchKey_select" name="searchKey" class="select_view view2" onchange="showCalendar(this.value);">
							<option value="BR.REQUIRE_TITLE">제목</option>
							<option value="BR.REQUIRE_CONTENT">내용</option>
							<option value="BRO.COMPLETION_DATE">완료일</option>
							<option value="BR.REQUESTOR">요청자</option>
							<option value="BRO.CHARGER_NAME">담당자</option>
						</select>
						<select id="searchKey_select2" name="searchKey2" class="select_view view1" >
							<option value="">관련부서 전체</option>
							<option value="0">경영지원본부</option>
							<option value="1">대외협력본부</option>
							<option value="2">컨텐츠기획본부</option>
							<option value="3">입학상담부</option>
							<option value="4">취업지원부</option>
							<option value="5">운영부</option>
							<option value="6">교육부</option>
						</select>
					</div><!--class="selectMenuWrap"-->
					<div class="searchBtn">
						<input type="text" id="hiddenContent" name="" style="display: none;" value="">
						<input type="text" id="searchContent" name="searchContent" value="${params.searchContent}">
						<select id="orderKey_select" name="orderKey" class="select_view view3" >
							<option value="">정렬기준</option>
							<option value="BRO.START_DATE ASC">시작일순</option>
							<option value="BRO.START_DATE DESC">시작일역순</option>
							<option value="BRO.COMPLETION_DATE ASC">완료일순</option>
							<option value="BRO.COMPLETION_DATE DESC">완료일역순</option>
						</select>
					</div>
					<div class="btnMd">
						<a class="pagingBtn" href="javascript:searchContent(1)">검색</a>
					</div>
					<div class="btnMd">
						<a class="pagingBtn" href="javascript:searchClickInit(1)" style="background: #fb606b;">검색초기화</a>
					</div>
					<input type="hidden" id="searchcpage" name="cpage" value="${params.cpage}">
					<input type="hidden" id="sort" name="sort" value="${params.sort == null ? '1' : params.sort}">
					<input type="hidden" id="no" name="no" value="">
				</div><!--class="botsearchBox"-->
				</form>
				</div>
					<div class="collaboTable noticeTable">
						<table cellpadding="0" cellspacing="0">
							<caption>요구사항</caption>
							<colgroup>
							   <col width="60" />
							   <col width="120" />
							   <col width="120" />
							   <col width="400" />
							   <col width="650" />
							   <col width="300" />
							   <col width="100" />
							   <col width="150" />
							   <col width="120" />
							   <col width="150" />
							   <col width="150" />
							   <col width="120" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col">번호</th>
									<th scope="col">작업번호</th>
									<th scope="col">선행작업</th>
									<th scope="col">카테고리</th>
									<th scope="col">요구사항</th>
									<th scope="col">요청부서</th>
									<th scope="col">요청자</th>
									<th scope="col">요청일</th>
									<th scope="col">담당자</th>
									<th scope="col">시작일</th>
									<th scope="col">완료일</th>
									<th scope="col">현재단계</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="data" items="${list}">
									<c:set var="itemDate" value='${fn:substring(data.reg_date, 0, 8) }'/>
									<tr >
										<td onclick="fnSelect('${data.no}');" class="borleft tdt">${total - data.rnum + 1}</td>
										<td onclick="fnSelect('${data.no}');" class="borleft tdt">${data.no}</td>
										<td onclick="fnSelect('${data.pre_require_no == 0 ? data.no :data.pre_require_no}');" class="tdt1">${data.pre_require_no == 0 ? '':data.pre_require_no }</td>
										<td onclick="fnSelect('${data.no}');" class="tdt1" style="text-align:left">${data.large_category} > ${data.middle_category}</td>
										<td onclick="fnSelect('${data.no}');" class="title tdt1">
											<p class="${((currentDate le itemDate and not fn:contains(readNo, data.no)))?'newNot':''}">
											${data.require_title}
											<c:if test="${data.comment_count > 0}">[${data.comment_count}]</c:if>
											</p>
										</td>
										<td onclick="fnSelect('${data.no}');" class="tdt1">${data.requesting_dept}</td>
										<td onclick="fnSelect('${data.no}');" class="tdt1">${data.requestor}</td>
										<td onclick="fnSelect('${data.no}');" class="tdt1">${data.request_date}</td>
										<td onclick="fnSelect('${data.no}');" class="tdt1">${data.charger_name}</td>
										<td onclick="fnSelect('${data.no}');" class="tdt1">${data.start_date}</td>
										<td onclick="fnSelect('${data.no}');" class="tdt1">${data.completion_date}</td>
										<td onclick="fnSelect('${data.no}');" class="tdt1">${data.develop_stage}</td>
									</tr>
								</c:forEach>
								
								<c:if test="${fn:length(list)==0 }">
								<tr><td colspan="14" class="not_found">게시글이 없습니다.</td></tr>
								</c:if>
							</tbody>
						</table>
					</div><!--class="collaboTable"-->
					<div id="board_nums" class="collaboBtn listNumBtn">
						<%=Utils.getPage2018(total,cpage, 20, 10)%>
						<utils:authority url="/rad/notice/requirementsForm.kh">
						<div class="writeBtn">
							<div class="btnMd">
								<a href="${pageContext.request.contextPath}/rad/notice/requirementsForm.kh?mode=insert">글쓰기</a>
							</div>
						</div>
						</utils:authority>
					</div><!--class="listNumBtn"-->
				</div><!--class="subcontent collabocontent"-->
			</div><!--class="collaborate"-->
		</div><!--class="subcomWrap"-->
	</section>
	
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/footer_2018.jsp"/>	
</body>

<script>
$(function(){
	settingSelected();
});

function settingSelected(){
	$("#searchKey_select2 option[value='${params.searchKey2}']").attr("selected", true); 
	$("#searchKey_select option[value='${params.searchKey}']").attr("selected", true); 
	$("#orderKey_select option[value='${params.orderKey}']").attr("selected", true); 
}

function showCalendar(selectValue){
	$('#hiddenContent').val('');
	$('#searchContent').val('');
	if(selectValue === 'BRO.COMPLETION_DATE'){
		mkCalendar('hiddenContent', 0, 'downMonthpop');
		$('#searchContent').css('display','none');
	}
	else{
		$('#hiddenContent').css('display','none');
		$('#searchContent').css('display','');
	}
}

function fnSelect(no){
	$("#no").val(no);
	document.searchFrm.action = "${pageContext.request.contextPath}/rad/notice/requirementsView.kh";
	document.searchFrm.submit();
}

function searchContent(page){
	const hidden = $('#hiddenContent').val();
	if(hidden !== ''){
		$("#searchContent").val(hidden);
	}
	$("#searchcpage").val(page);
	//$('#sort').val('-1');
	document.searchFrm.submit();
}

function doPagingClick(page){
	$("#searchcpage").val(page);
	document.searchFrm.submit();
}

function searchClickInit(page){
	$('#sort').val('1');
	$("#searchcpage").val(page);
	$('#hiddenContent').val('');
	$('#searchContent').val('');
	$('#searchKey_select').val('');
	$('#searchKey_select2').val('');
	$('#orderKey_select').val('');
	document.searchFrm.submit();
} 

function fnSort(sort) {
	$("#sort").val(sort);
	$("#searchcpage").val('1');
	document.searchFrm.submit();
}
</script>
</html>