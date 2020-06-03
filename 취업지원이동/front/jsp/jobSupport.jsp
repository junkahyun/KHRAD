<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 		uri="/WEB-INF/tlds/c.tld" %> 
<%@ taglib prefix="fn" 		uri="/WEB-INF/tlds/fn.tld" %>
<%@ taglib prefix="fmt"		uri="/WEB-INF/tlds/fmt.tld" %>
<%@ taglib prefix="utils"	uri="/WEB-INF/tlds/utils.tld" %>
<%@ page import="com.kh.utils.Utils"%>

<%
	String cpage = Utils.nvl((String)request.getAttribute("cpage"), "1");
	int total = Integer.parseInt((String)request.getAttribute("total"));
	
	Calendar currentDate = Calendar.getInstance();
	currentDate.add(currentDate.DATE, -3);
	
	String strCD = currentDate.get(currentDate.YEAR)+""; 
	if(currentDate.get(currentDate.MONTH)<9) strCD+="0";
	strCD+=(currentDate.get(currentDate.MONTH)+1)+"";
	if(currentDate.get(currentDate.DATE)<10) strCD+="0";
	strCD+=currentDate.get(currentDate.DATE)+"";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<c:if test="${sessionScope.aduser.site_id == 'kh' }">
<title>KH정보교육원 RAD :: 컨텐츠관리</title>
</c:if>
<c:if test="${sessionScope.aduser.site_id == 'atents' }">
<title>아텐츠 RAD :: 컨텐츠관리</title>
</c:if>
<c:set var="currentDate" value="<%=strCD %>"/>
<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/meta.jsp"/>
<style>
#board_list td{cursor:default;}
.dargRow{opacity: 0.3;}
.boff{background: #ececec;color: #444444;}
.bon{background: #2a2a4e;color: #fff;display: inline-block;}
</style>
<script type="text/javascript">
$(document).ready(function(){
	fnCurrentSub('07', '02');
	fnchangeSequence();
});

function fnchangeSequence(){
	let tr = "";
	let td = "";
	let arrayNo = new Array();//배열
	let total = "";
	
	let prevnum_row = "";
	let nextvnum_row = "";
	let nownum_row = "";
	<utils:authority url ="/rad/contents/jobSupportChange.kh">		
	$("#board_list").tableDnD({
		onDragClass:"dargRow",
		onDragStart:function(table,row){
			$("#board_list tr").mouseup(function (){
				/*현재 클릭된 row의 tr*/
				tr = $(this);//tr값
				td = tr.children();//td값
				arrayNo = new Array();//배열
				total = ${list.size()};//총 게시물수
				
				prevnum_row = $(this).prev().find("td").eq(1).find("input").val();//이전 로우
				nextvnum_row = $(this).next().find("td").eq(1).find("input").val();//다음 로우
				nownum = td.eq(0).find("input").val();//현재 넘버
				nownum_row = td.eq(1).find("input").val();//현재 로우
				
				/*이동된 위치에서 전체 넘버의 값을 배열에 넣어주기*/
				for(var i=0; i<parseInt(total); i++){
					arrayNo[i] = $(this).eq(0).parent().find("tr").eq(i+1).find("td").eq(0).find("input").val();
				}
			}); 
		},
		onDragStop:function(table,row){
			const form_data = {"arrayNo":arrayNo};
			
			if(arrayNo.length == 0){
				alert("해당 위치로는 이동할수 없습니다.");
				window.location.reload(true);
				return;
			}
			else{
				$.ajax({
					url:"${pageContext.request.contextPath}/rad/contents/jobSupportChange.kh",
					type:"get",
					data:form_data,
					dataType:"json",
					success:function(data){
						window.location.reload(true);
					},
					error:function(req,res,error){
						alert("code: "+req.status+", message: "+res.responseText+", error: "+error);
					} 
				 });  //end of ajax---------------   
			}
		}
	});
	</utils:authority>
}

function fnUpdate(no, photo){
	location.href="${pageContext.request.contextPath}/rad/contents/jobSupportForm.kh?mode=update&no="+no+"&cpage=${cpage}";
	
	if (photo != null && photo != '') {
		$("#preview_photo").attr("src", "${pageContext.request.contextPath}/upload/jobsupport/" + thumnail);
	}
}
function changebtn(role){
	$("#cpage").val(1);
	$("#role").val(role);
	document.frm.submit();
}
function doPagingClick(page){
	$("#cpage").val(page);
	document.frm.submit();
}

</script>
</head>
<body>
<div id="result"></div>
	<jsp:include page="/WEB-INF/jsp/rad/portlet/right_quick.jsp"/>
	<input type="hidden" id="location_name" value=" 컨텐츠관리 &nbsp; > &nbsp; 커뮤니티관리">	
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/metaHeader_2018.jsp"/>
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/header_2018.jsp"/>
	<div id="body" onmouseover="fnCloseSubs();" >
		<div id="headtitle">
			<div class="left">취업지원센터</div>
			<div class="right">
				<utils:authority url="/rad/contents/jobSupport.kh">
					<a href="${pageContext.request.contextPath}/rad/contents/jobSupport.kh" class="btn">상담선생님 소개</a>
				</utils:authority>
				<utils:authority url="/rad/contents/companyLec.kh">
				<c:if test="${sessionScope.aduser.site_id == 'kh' }">
					<a href="${pageContext.request.contextPath}/rad/contents/companyLec.kh" class="btn off">기업체초청특강</a>
				</c:if>
				</utils:authority>
				<utils:authority url="/rad/contents/preInterview.kh">
				<c:if test="${sessionScope.aduser.site_id == 'kh' }">
					<a href="${pageContext.request.contextPath}/rad/contents/preInterview.kh" class="btn off">실전대비면접</a>
				</c:if>	
				</utils:authority>
			</div>
		</div>
		<div id="result"></div>
		
		<a href="${sessionScope.aduser.site_id == 'kh'?'https://www.iei.or.kr/work/jobSupportTest.kh':'http://atentsgame.com/support.do?category=04' }" class="btn" style="margin-bottom: 25px; margin-right: 15px;" target="_blank">미리보기</a>
		<a class="btn ${params.role=='AC'? 'bon':'boff'}" style="margin-bottom: 25px; cursor: pointer;" onclick="changebtn('AC');">진로상담</a>
		<a class="btn ${params.role=='JC'? 'bon':'boff'}" style="margin-bottom: 25px; cursor: pointer;" onclick="changebtn('JC');">취업담임</a>
		<div align="right" style="margin-bottom: 1%;"></div>
		
		<table cellpadding="0" cellspacing="0" id="board_list">
			<tr style="cursor: none;" class="nodrag nodrop">
				<th width="5%" >번호</th>
				<th width="7%">구분</th>
				<th width="10%">소속</th>
				<th width="7%">사진</th>
				<th width="7%">성명</th>
				<th width="10%">연락처</th>
				<th width="">문구</th>
				<th width="10%">최근 업데이트</th>
				<th width="5%">배포여부</th>
				<th width="7%">관리</th>
				<th width="10%">이동</th>
			</tr>
			<c:forEach var="data" items="${list}" varStatus="status">
			<tr >
				<td class="nodrag nodrop">${list.size()-status.count+1}<br>
					<input type="hidden"  value="${data.no}" /><!-- 넘버 -->
				</td>
				<td>
					<c:if test="${data.role_code == 'JC'}">취업담임</c:if>
					<c:if test="${data.role_code == 'AC'}">진로상담</c:if>
					<input type="hidden"  value="${data.rnum}" /> <!-- 로우넘버 -->
				</td>
				<td>
					<c:if test="${fn:substring(data.department, 0, 4) != '입학상담' }">${fn:substring(data.department, 0, 4)}</c:if>
					<c:if test="${data.branch == 2 && fn:substring(data.department, 0, 4) == '입학상담'}">강남지원</c:if>
					<c:if test="${data.branch == 6 && fn:substring(data.department, 0, 4) == '입학상담'}">종로지원</c:if>
					<c:if test="${data.branch == 10 && fn:substring(data.department, 0, 4) == '입학상담'}">당산지원</c:if>
					<br>${fn:substring(data.department, 5, 10)}<br>${fn:substring(data.department, 11, 18)}</td>
				<td>
					<div style="width: 50px;height:50px;border-radius:50%;overflow:hidden;">
						<img style="width:145%;margin-left:-21%;" 
						<c:if test="${data.photo != null && not empty data.photo}">
						src="${pageContext.request.contextPath}/upload/jobsupport/${data.photo}"
						</c:if>
						onerror='this.src=${pageContext.request.contextPath}/upload/jobsupport/jobsupport_photo.jpg'/>
					</div>
				</td>
				<td>${data.name}<br>${data.dept}</td>
				<td>${data.email}<br>${data.phone}</td>
				<td style="color:#ea2026">
					<c:if test="${data.comment1 == null || empty data.comment1}">
						-
					</c:if>
					<c:if test="${data.comment1 != null && not empty data.comment1}">
						${data.comment1} ${sessionScope.aduser.site_id == 'kh' ? data.comment2 :''}
					</c:if>
				</td>
				<td>
					<c:if test="${data.reg_date == null || empty data.reg_date}">
						-
					</c:if>
					<c:if test="${data.reg_date != null && not empty data.reg_date}">
						${fn:substring(data.reg_date, 0, 4)}.${fn:substring(data.reg_date, 4, 6)}.${fn:substring(data.reg_date, 6, 8)}<br>${data.reg_id}
					</c:if>
				</td>
				<td >${(data.share == 'true')?'배포':'미배포'}</td>
				<td>
					<utils:authority url="/rad/contents/jobSupportForm.kh">
						<a href="javascript:fnUpdate('${data.no}');" class="list_gray" style="padding:0 13px;">수정</a>
					</utils:authority>
				</td>
				<td style="cursor: pointer;">이동하기</td>		
			</tr>
			</c:forEach>
			<c:if test="${list==null or fn:length(list)==0 }">
				<tr><td colspan="10" class="not_found">게시글이 없습니다.</td></tr>
			</c:if>
		</table>
		<form action="${pageContext.request.contextPath}/rad/contents/jobSupport.kh" method="post" id="frm" name="frm">
			<%-- <div id="board_nums">
				<%=Utils.getPage(total,cpage, 20, 10)%>
			</div> --%>
			<input type="hidden" id="cpage" name="cpage" value="${params.cpage}">
			<input type="hidden" id="role" name="role" value="${params.role}">
		</form>
	</div>
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/footer.jsp"/>
</body>
</html>