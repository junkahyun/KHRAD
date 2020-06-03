<%@page import="java.util.Calendar"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="org.springframework.util.FileCopyUtils"%>
<%@page import="java.net.URL"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 		uri="/WEB-INF/tlds/c.tld" %> 
<%@ taglib prefix="fn" 		uri="/WEB-INF/tlds/fn.tld" %>
<%@ taglib prefix="fmt"		uri="/WEB-INF/tlds/fmt.tld" %>
<%@ taglib prefix="functions"	uri="/WEB-INF/tlds/functions.tld" %>
<%@ taglib prefix="utils"	uri="/WEB-INF/tlds/utils.tld" %>
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
<title>KH정보교육원 RAD :: 요구사항</title>
</c:if>
<c:if test="${sessionScope.aduser.site_id == 'atents' }">
<title>아텐츠 RAD :: 요구사항</title>
</c:if>
<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/meta_2018.jsp"/>
<c:set var="currentDate" value="<%=strCD %>"/>
</head>
<style>
	.viewBot .replyWrite { position: relative; } 
	.viewBot .replyWrite .reply_btn { right: 0px; }
	.viewBot .replyWrite textarea { width: 1043px; height: 38px; }
	.viewAdminBtn .delcollabo>a { background: #2a2a4e; }
	.btn_update{height: 1em; width: 25px; background: url(${pageContext.request.contextPath}/resources/images/rad/btn_edit.jpg) no-repeat; background-position: 0px 1px;
			    display: inline-block; vertical-align: -3px; margin-left: 5px;}	
	.btn{background: #58697b; color:#fff; display: inline-block; }
	.comment_update textarea{height: 50px; background: #f4f4f8; border: 0; width: 1012px; margin: 0; padding: 0; overflow: auto;}
</style>	
<script>
$(function(){
	if (parseInt("${data.reg_date}") > parseInt("${standardDate + 4000000}")) {
		checkNewContents();
	}
	
	let decode = decodeURI(decodeURIComponent('${params.searchContent}'));
	$('#searchContent').val(decode);
	
	settingRelate();
});


function settingRelate(){
	let dept_split = '${data.relate_dept}'.split('_');
	let relate_dept = '';
	for(let i=0; i<dept_split.length; i++){
		switch (dept_split[i]) {
			case '0':
				relate_dept += '경영지원본부'+', '
				break;
			case '1':
				relate_dept += '대외협력본부'+', '
				break;
			case '2':
				relate_dept += '컨텐츠기획본부'+', '
				break;
			case '3':
				relate_dept += '입학상담부'+', '
				break;
			case '4':
				relate_dept += '취업지원부'+', '
				break;
			case '5':
				relate_dept += '운영부'+', '
				break;
			case '6':
				relate_dept += '교육부'+', '
				break;
			default:
				break;
		}
	}
	$('#relate_dept').html(relate_dept.substr(0,relate_dept.length-2));
}

function checkNewContents(){
	/* JSON을 통해 읽은 글 확인 함수 */
	var params = {
			no			: "${data.no}"
		  , category	: "requirements"
	}
	$.ajax({
		  url			: '${pageContext.request.contextPath}/rad/alarm/checkAlram.kh'
		, data			: params
		, type			: 'post'
		, success		: function(data){
		}
		, error			: function(textStatus, errorThrown){
			alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
		}
		
	});
	$.ajax({
		  url			: '${pageContext.request.contextPath}/rad/main/checkNewContents.kh'
		, data			: params
		, type			: 'post'
		, success		: function(data){
		}
		, error			: function(textStatus, errorThrown){
			alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
		}
		
	});
}

function fnUpdateRequire(){
	document.backListFrm.mode.value = 'update';
	document.backListFrm.action = '${pageContext.request.contextPath}/rad/notice/requirementsForm.kh';
	document.backListFrm.submit();
}

function fnDeleteRequire(){
	if (!confirm('해당 글을 삭제하시겠습니까?')) {
		return;
	}
	var params={
		  no		: '${data.no}',
		  category  : 'requirements'
	};
	$.ajax({
		  url		: '${pageContext.request.contextPath}/rad/notice/requirementDelete.kh'
		, data		: params
		, dataType	: 'json'
		, type		: 'post'
		, success	: function(data, textStatus) {
			var result = data['result'];
			if(result==0) {
				alert('게시물 삭제에 실패하였습니다.');
			} else {
				alert('게시물이 삭제되었습니다.');
				document.backListFrm.submit();
			}
		}
		, error		: function(jqXHR, textStatus, errorThrown) {
			alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
		}
	});
}

function fnInsertComment(){
	var bool = false;

	bool = $("#comment_area").val() != '';
	
	if (!bool) {
		alert("댓글을 입력해주세요.");
		return false;
	}
	
	if (!window.confirm('입력하신 댓글과 현재상태를 저장하시겠습니까?')) {
		return false;
	}
	
	var params={
		no		: '${params.no}'
		, comment	: $("#comment_area").val() 
		, id		: '${sessionScope.aduser.id}'
		, name		: '${sessionScope.aduser.name}'
		, status    : $("[name=status]:checked").val()
		, mode		: 'insert'
		, board_name: 'requirement'
		, reg_id	: '${data.reg_id}'
	};

	$.ajax({
		url		: '${pageContext.request.contextPath}/rad/notice/requirementComment.kh'
		, data		: params
		, dataType	: 'json'
		, type		: 'post'
		, success	: function(data, textStatus) {
			var result = data['result'];
			if(result==0) {
				alert('댓글 등록에 실패하였습니다.');
			} else {
				alert('댓글이 등록되었습니다.');
				location.href = '${pageContext.request.contextPath}/rad/notice/requirementsView.kh?no=${params.no}&cpage=${params.cpage}&parent=${params.parent}';
			}
		}
		, error		: function(jqXHR, textStatus, errorThrown) {
			alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
		}
	});
}

function fnUpdateCommentForm(index, cancel){
	index = Number(index);
	if(!cancel){		
		$(".board_reply_list > li:eq(" + index + ") > .comment_view").css('display', 'none');
		$(".board_reply_list > li:eq(" + index + ") > .comment_update").css('display', 'block');
		$(".board_reply_list > li:eq(" + index + ") > .comment_update textarea").focus();
	}else{
		$(".board_reply_list > li:eq(" + index + ") > .comment_view").css('display', 'block');
		$(".board_reply_list > li:eq(" + index + ") > .comment_update").css('display', 'none');
	}
}

function fnUpdateComment(sub_no, index){
	var params={
			  no		: '${params.no}'
			, sub_no    : sub_no
			, comment	: $("#update_comment_area"+index).val() 
			, id		: '${sessionScope.aduser.id}'
			, mode		: 'update'			
		};
	$.ajax({
		  url		: '${pageContext.request.contextPath}/rad/notice/requirementComment.kh'
		, data		: params
		, dataType	: 'json'
		, type		: 'post'
		, success	: function(data, textStatus) {
			var result = data['result'];
			if(result==0) {
				alert('댓글 수정에 실패하였습니다.');
			} else {
				alert('댓글을 수정했습니다.');
				location.href = '${pageContext.request.contextPath}/rad/notice/requirementsView.kh?no=${params.no}&cpage=${params.cpage}';
			}
		}
		, error		: function(jqXHR, textStatus, errorThrown) {
			alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
		}
	});
}

function fnDeleteComment(subno){
	var params={
		mode		: 'delete'
		, sub_no	: subno
	};

	$.ajax({
		url		: '${pageContext.request.contextPath}/rad/notice/requirementComment.kh'
		, data		: params
		, dataType	: 'json'
		, type		: 'post'
		, success	: function(data, textStatus) {
			var result = data['result'];
			if(result==0) {
				alert('댓글 삭제에 실패하였습니다.');
			} else {
				alert('댓글이 삭제되었습니다.');
				location.href = '${pageContext.request.contextPath}/rad/notice/requirementsView.kh?no=${params.no}&cpage=${params.cpage}';
			}
		}
		, error		: function(jqXHR, textStatus, errorThrown) {
			alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
		}
	});
}
</script>											
<body>
	<!--헤더 시작-->
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/header_2018.jsp"/>				
	<!--헤더 끝-->
	<jsp:include page="/WEB-INF/jsp/rad/portlet/right_quick.jsp"/>
	<input type="hidden" id="location_name" value="disable">	
	
	<section id="section">
		<div class="sectionwrap subcomWrap">
			<div class="collaboView">
				<div class="tit">
					<h3>요구사항</h3>
				</div>
				<div class="subcontent collaboViewcontent">
					<div class="viewTop">
						<div class="toptxt">
							<p class="txt1">
							    ${data.require_title} 
							</p>
							<p class="txt2">등록일 : ${fn:substring(data.reg_date, 0, 4) }. ${fn:substring(data.reg_date, 4, 6) }. ${fn:substring(data.reg_date, 6, 8) } ${fn:substring(data.reg_date, 8, 10) }:${fn:substring(data.reg_date, 10, 12) }:${fn:substring(data.reg_date, 12, 14) }   
							|   작성자 : ${data.reg_name}
							</p>
						</div>
						<div class="topImg">
							<ul>
								<li class="thumbImg thumbImg1" style="background: url(${pageContext.request.contextPath}/upload/profile/${data.thumnail}) no-repeat; background-size: cover;"></li>
							</ul>
						</div>
						<div class="topLine"></div>
					</div><!--class="viewTop"-->
					<div class="subcontent collaboWritecontent Writecontent" style="padding: 30px 0px; border-top: none;">
					<div class="writeTable">
						<table id="shared_area" cellpadding="0" cellspacing="0">
							<caption>요구사항 작성 테이블</caption>
							<tbody>
								<tr>
									<th style="width: 110px; ">작업번호</th>
									<td colspan="3" >
										${data.no}
										<input type="hidden" id="no" name="no" value="${data.no}">
									</td>
									<th style="width: 110px; ">선행작업</th>
									<td colspan="3" >
										${data.pre_require_no == 0 ? '':data.pre_require_no }
										<div id="pre_require_div" class="pre_require_div"></div>
										<span id="pre_require_no_error" 
										    class="validate_error_message" 
											name="validate_error_message"></span>
									</td>
									<th style="width: 110px; ">대분류</th>
									<td colspan="3" >
										${data.large_category}
									</td>
									<th style="width: 110px; ">중분류</th>
									<td colspan="4" >
										${data.middle_category}
									</td>
								</tr>
								<tr>
									<th style="vertical-align: middle;">요구사항 내용</th>
									<td colspan="15" style="height: 97px;">
										<textarea rows="8" cols="6" disabled="disabled" style="min-height:100px; width: 98%; padding: 10px;">${fn:escapeXml(data.require_content)}</textarea>
									</td>
								</tr>
								<tr>
									<th style="width: 110px; ">요청부서</th>
									<td colspan="3" >
										${data.requesting_dept}
									</td>
									<th style="width: 110px; ">요청자</th>
									<td colspan="3">
										${data.requestor}
									</td>
									<th style="width: 110px; ">요청일</th>
									<td colspan="3">
										${data.request_date}
									</td>
									<th style="width: 110px; ">수용여부</th>
									<td colspan="4">
										${data.acceptance_flag == 0 ? '수용' : '미수용'}
									</td>
								</tr>
								<tr>
									<th>미수용 사유</th>
									<td colspan="15">
										${data.unacceptable_reason}
									</td>
								</tr>
								<tr>
									<th style="width: 110px; ">담당자</th>
									<td colspan="3" >
										${data.charger_name}
									</td>
									<th style="width: 110px; ">시작일</th>
									<td colspan="3">
										${data.start_date}
									</td>
									<th style="width: 110px; ">완료일</th>
									<td colspan="3">
										${data.completion_date}
									</td>
									<th style="width: 110px; ">개발기간</th>
									<td colspan="4">
										${data.develop_period}
									</td>
								</tr>
								<tr>
									<th>현재단계</th>
									<td colspan="3">
										${data.develop_stage}
									</td>
									<th>관련부서</th>
									<td colspan="13" id="relate_dept">
									</td>
								</tr>
								<tr calss="tr_delay" >
									<th>지연 여부</th>
									<td colspan="3">
										${data.delay_status == 0 ? '미지연' : '지연'}
									</td>
									<th>지연 사유</th>
									<td colspan="13">
										${data.delay_reason}
									</td>
								</tr>
								<tr>
									<th>비고</th>
									<td colspan="16">
										${data.etc}
									</td>
								</tr>
							</tbody>
						</table>
						</div>
					</div><!--class="viewMid"-->
					<div class="viewBot">
						<div class="replyWrap">
							<div class="viewAdminBtn">
								<c:if test="${!(data.parent != 0 && data.parent_del == 1)}">
									<c:set var="role" value="${sessionScope.aduser.role_code}"/>
									<utils:authority url="/rad/notice/requirementsForm.kh">
									<c:if test="${sessionScope.aduser.id == data.reg_id or role == 'AM' or role == 'SM'}">
										<div class="btnSm modify">
											<a href="javascript:fnUpdateRequire();">수정</a>
										</div>
									</c:if>
									</utils:authority>
								</c:if>
								<utils:authority url="/rad/notice/requirementDelete.kh">
								<c:if test="${sessionScope.aduser.id == data.reg_id or role == 'AM' or role == 'SM'}">
									<div class="btnSm delcollabo">
										<a href="javascript:fnDeleteRequire();">삭제</a>
									</div>
								</c:if>
								</utils:authority>
							</div><!--class="viewAdminBtn"-->
							
							<c:if test="${cList != null and fn:length(cList) != 0}">
								<p class="ok">댓글확인[${fn:length(cList)}]</p>
								<div class="replyList">
									<ul class="replyList board_reply_list">
										<c:forEach var="cd" items="${cList}" varStatus="status">
										<li class="cf">
											<span class="thumbImg" style="background: url(${pageContext.request.contextPath}/upload/profile/${cd.thumnail}) no-repeat; background-size: cover;"></span>
											<p class="txt1">${cd.name } ${fn:substring(cd.reg_date, 0, 4) }. ${fn:substring(cd.reg_date, 4, 6) }. ${fn:substring(cd.reg_date, 6, 8) }</p>
											<p class="txt2 comment_view" style="display:block">
												${fn:replace(functions:nl2br(cd.comment), "<script>", "<xmp><script></xmp>")}
											<c:if test="${sessionScope.aduser.id==cd.id }">
												<a class="btn_update" href="javascript:fnUpdateCommentForm('${status.index}');">&nbsp;</a>
												<a class="btn_delete" href="javascript:fnDeleteComment(${cd.sub_no });">&nbsp;</a>
											</c:if>
											</p>
											<p class="right comment_update" style="display:none;">
										    	<textarea id="update_comment_area${status.index }" onfocus="javascript:this.value = '${fn:replace(functions:nl2br(cd.comment), "<script>", "<xmp><script></xmp>")}';" ></textarea>
										        <a class="btn" href="javascript:fnUpdateComment(${cd.sub_no },'${status.index }');" style="background:#ff626c;letter-spacing: -0.5px;font-size: 12px;padding: 15px 17.5px;">수정</a>
											    <a class="btn" href="javascript:fnUpdateCommentForm('${status.index}','취소');" style="background:#2a2a4e;letter-spacing: -0.5px;font-size: 12px;padding: 15px 17.5px;">취소</a>											    
										    </p>
										</li>
										</c:forEach>
									</ul>
								</div><!-- class="replyList"-->
							</c:if>
							<div class="replyRadio" style="padding-top: 30px;">
							</div><!--class="replyRadio"-->
							<div class="replyWrite cf">
								<textarea id="comment_area"></textarea>
								<div class="reply_btn">
									<a href="javascript:fnInsertComment();">댓글 등록</a>
								</div>
							</div><!--class="replyWrite"-->
						</div><!--class="replyWrap"-->

						<c:if test="${count != 0}">
						<div id="replyWrap" class="pageBtnWrap noticeTable" style="padding: 15px 0px;">
						</div><!--id="replyWrap"-->
						</c:if>
						
						<div class="pageBtnWrap" ${count != 0 ? 'style="border-top-width: 0px;"' : ''}>
							<div class="pageBtn pageBtn-prev">
								<ul>
									<c:if test="${pn.prevno != null and pn.prevno != ''}">
										<li>이전글</li>
										<li class="bar">|</li>
										<li><a href="${pageContext.request.contextPath}/rad/notice/requirementsView.kh?no=${pn.prevno}">${pn.prevtitle}</a></li>
										<li class="date">${fn:substring(pn.prevdate, 0, 4)}. ${fn:substring(pn.prevdate, 4, 6)}. ${fn:substring(pn.prevdate, 6, 8)}</li>
									</c:if>
									<c:if test="${pn.prevno == null or pn.prevno == ''}">
										<li>이전글</li>
										<li class="bar">|</li>
										<li><a href="">이전글이 없습니다.</a></li>
										<li class="date"></li>
									</c:if>
								</ul>
							</div>
							<div class="pageBtn pageBtn-next">
								<ul>
									<c:if test="${pn.nextno != null and pn.nextno != ''}">
										<li>다음글</li>
										<li class="bar">|</li>
										<li><a href="${pageContext.request.contextPath}/rad/notice/requirementsView.kh?no=${pn.nextno}">${pn.nexttitle}</a></li>
										<li class="date">${fn:substring(pn.nextdate, 0, 4)}. ${fn:substring(pn.nextdate, 4, 6)}. ${fn:substring(pn.nextdate, 6, 8)}</li>
									</c:if>
									<c:if test="${pn.nextno == null or pn.nextno == ''}">
										<li>다음글</li>
										<li class="bar">|</li>
										<li><a href="">다음글이 없습니다.</a></li>
										<li class="date"></li>
									</c:if>
								</ul>
							</div>
						</div><!--class="pageBtnWrap"-->
					</div><!--class="viewBot"-->
				</div><!--class="subcontent collaboViewcontent"-->
			</div><!--class="collaboView"-->
			<div class="ListpageBtn">
				<div class="btnMd">
					<a href="javascript:document.backListFrm.submit();">목록</a>
				</div>
			</div><!--class="ListpageBtn"-->
		</div><!--class="subcomWrap"-->
	</section>
	<form id="backListFrm" name="backListFrm" action="${pageContext.request.contextPath}/rad/notice/requirementsBoard.kh" method="post">
		<input type="hidden" name="searchKey" value="${params.searchKey}" />
		<input type="hidden" name="searchKey2" value="${params.searchKey2}" />
		<input type="hidden" id="searchContent" name="searchContent" value="${params.searchContent}" />
		<input type="hidden" name="sort" value="${params.sort}" />
		<input type="hidden" name="cpage" value="${params.cpage}" />
		<input type="hidden" name="no" value="${data.no}" />
		<input type="hidden" name="sub_no" value="${data.sub_no}" />
		<input type="hidden" name="mode" value="" />
		<input type="hidden" name="cpage" value="${params.cpage}" />
	</form>

	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/footer_2018.jsp"/>	
</body>
</html>