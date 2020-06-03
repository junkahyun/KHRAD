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
<%@ page import="com.kh.utils.Utils"%>
<%	
	String incpage = Utils.nvl((String)request.getAttribute("incpage"), "1");
	int total = Integer.parseInt((String)request.getAttribute("total"));  
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<c:set var="role" value="${sessionScope.aduser.role_code}"/>
<c:set var="userid" value="${sessionScope.aduser.id}"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<c:if test="${sessionScope.aduser.site_id == 'kh' }">
<title>KH정보교육원 RAD :: 학습동영상</title>
</c:if>
<c:if test="${sessionScope.aduser.site_id == 'atents' }">
<title>아텐츠 RAD :: 학습동영상</title>
</c:if>
<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/meta_2018.jsp"/>
<style>
#media_view_middle{
	height: 400px;
}

#media_upload_tip{
	color : #999999;
}

</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/radCalandar_v2.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/resources/css/radCalandar_v2.css" />
<script src="${pageContext.request.contextPath }/resources/js/media/mediaUpload.js"></script>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/header_2018.jsp"/>
	<jsp:include page="/WEB-INF/jsp/rad/portlet/right_quick.jsp"/>
	
	<div id="media_student_popup" class="popupcom media_student_popup" style="top: 20%; left: 44%; width: 200px;">
	</div><!-- //media_student_popup -->	
	<!--  -->
	<!--comment_list_popup-->
	<div class="popupBg" id="popupBg2" onClick="closeCommentDataPopup();" style="z-index: 5; "></div>
		<form id="CommentShareForm" name="CommentShareForm">
			<div id="comment_data_popup">
				
			</div>
		</form>	
	<section id="section">
		<div class="sectionwrap subcomWrap">
			<div class="gonggamView">
				<div class="tit">
					<h3>학습동영상</h3>
				</div>
				<c:set value="${fn:split(mediaViewData.department,'/')}" var="department"/>
				<c:set value="${department[fn:length(department)-1]}" var="dep"/>				
				<div class="subcontent gongViewcontent">				
				<div class="viewTop">
					<div class="toptxt" style="position: relative;"><!-- data.share -->
						<p class="txt1"><c:if test="${shareCount >= 1}"><span class="on">[공유중]&nbsp</span></c:if>${mediaViewData.title}</p>
						<p class="txt2">${fn:substring(mediaViewData.reg_date, 0, 4)}. 
								${fn:substring(mediaViewData.reg_date, 4, 6)}. 
								${fn:substring(mediaViewData.reg_date, 6, 8)} 
								${fn:substring(mediaViewData.reg_date, 8, 10) }:
								${fn:substring(mediaViewData.reg_date, 10, 12) }:
								${fn:substring(mediaViewData.reg_date, 12, 14) }<br>
								${dep} ${mediaViewData.name} ${mediaViewData.dept }
						</p>		
					</div>
					<div class="topImg">
						<ul>
							<li class="thumbImg" style="background: url(${pageContext.request.contextPath}/upload/profile/${mediaViewData.userThum}) no-repeat; background-size:cover;"></li>	
						</ul>
					</div>
					<div class="topLine"></div>
				</div>				
				<div class="viewMiddle" id="media_view_middle">
					<div class="view_left">
						<iframe id="mediaView" width="600" height="338" src="" 
											frameborder="0" allowfullscreen></iframe>
						<div>
							<details id="media_upload_tip">
							<summary>* "관리자에 의해 재생이 제한된 영상입니다." 메세지가 뜨는 경우 (click)</summary>
								<p>동영상이 인코딩 중입니다. 인코딩이 완료되면 메세지는 없어지고, 동영상 재생이 가능합니다.<br/>
								- 인코딩 소요시간 : 약 1분 ~ 6시간<br/>
								- 동영상이 업로드된 순서대로 인코딩이 진행됩니다.<br/>
								- 인코딩 중인 동영상이 많으면 인코딩 시간이 더 소요될 수 있습니다.<br/>
								- 업로드 후 24시간이 지나도 해당 메세지가 나오면 업무협업 게시판으로 문의부탁드립니다.
								</p>
							</details>
						</div>
					</div>
					<div class="view_right">						
						<p class="title_right"><c:if test="${shareCount >= 1}"><span class="on">[공유중]&nbsp</span></c:if>${mediaViewData.title}</p>
						<p style="margin-top:10px;">· 영상분류 : ${mediaViewData.category} <c:if test="${mediaViewData.category == '홍보' or mediaViewData.category == '우리반영상'}"></c:if><c:if test="${mediaViewData.category == '자바' or mediaViewData.category == '보안' or mediaViewData.category == '사전학습' }">/${mediaViewData.sub_category_name}</c:if></p>
						<p>· 영상길이&nbsp:&nbsp ${mediaViewData.duration }</p>
						<p>· 총재생수&nbsp:&nbsp ${mediaViewData.hitcount == null or mediaViewData.hitcount == ''? 0: mediaViewData.hitcount}</p>
						<p>· 총댓글수&nbsp:&nbsp ${mediaViewData.count } <img src="${pageContext.request.contextPath}/resources/images/rad/main/view.png" style="vertical-align:bottom; margin-left:4px; display:${mediaViewData.count == 0 ?'none':''};" onclick="openCommentShareForm('${params.no}','recent','1')"></p>
						<p>· 총배포수&nbsp:&nbsp ${mediaViewData.listCount }</p>						
						<div class="midLine"></div>						
							<p style="overflow-x:hidden;overflow-y:auto;max-height:150px;">${mediaViewData.content }</p>
						<div class="botLine"></div>					
						<div class="btn_list">
							<ul>
								<li>
									<div class="btnSm video_share" style="margin-right:10px;">
									<c:if test="${mediaViewData.encode_flag == 2 or encoded == 2}">
										<a href="javascript:openShareDataPopup('', 'insert');" style="background:#3c83ff;">영상공유</a>
									</c:if>	
									</div>
								</li>
								<li>
									<utils:authority url="/rad/contents/mediaUploadSave.kh"> 
									<c:if test="${sessionScope.aduser.id == mediaViewData.reg_id or role == 'AM' or role == 'SM'}">
										<div class="btnSm modify" style="margin-right:10px;">
											<a href="javascript:void(0);" style="background:#ff626c; "
												onClick="document.frm.action = '${pageContext.request.contextPath}/rad/contents/mediaUploadForm.kh'; 
													document.frm.submit();">수정</a>
										</div><!--class="btnSm modify"-->
									</c:if>
									</utils:authority>
								</li>
								<li>
									<utils:authority url="/rad/contents/mediaUploadDelete.kh">
									<c:if test="${sessionScope.aduser.id == mediaViewData.reg_id or role == 'AM' or role == 'SM'}">
										<div class="btnSm dels">
											<a href="javascript:void(0);" 
												onClick="if(confirm('삭제시 데이터 복구가 불가능합니다.삭제하시겠습니까?')) {
													deleteMedia('${mediaViewData.media_id}');												
											}">삭제</a>												
										</div><!--class="btnSm dels"-->
									</c:if>	
									</utils:authority>
								</li>
							</ul>							
						</div>
					</div>
				</div>
				<%-- ${mediaViewData.title} --%>							
				<div class="viewMid">
					<p style="font-size:21px; font-weight:400; margin:19px 0 20px 0;">공유내역</p>
					<div class="announce_com_table">
						<div class="noticeTable">
							<table cellpadding="0" cellspacing="0">
								<caption>공유대상 테이블</caption>
								<colgroup>
									<col width="30" />
									<col width="50" /> 
									<col width="180" />
									<col width="100" /> 
									<col width="70" />
								</colgroup>
								<thead>
									<tr>
										<th scope="col">번호</th>
										<th scope="col">공유타입</th>
										<th scope="col">공유대상</th>
										<th scope="col">공유기간</th>
										<th scope="col">공유자</th>
									</tr>
								</thead>
								<tbody>
								<c:forEach items="${shareList}" var="data" varStatus="status">
									<tr class="fieldview_tap_list" onClick="openShareDataPopup('${data.sub_no}', 'update', '${mediaViewData.open_flag}','${data.no }','${data.curr_no }')">
										<td><%-- ${fn:length(shareList) - status.index} --%>${total - data.rnum +1}</td>
										<td>
											<c:if test="${data.share_type == ''}">특정 과정공유</c:if>
											<c:if test="${data.share_type != '' && data.share_type !='전체'}">${data.share_type}과정 전체공유</c:if>
											<c:if test="${data.share_type =='전체'}">전체공유</c:if>
										</td>
										<td class="text_left">
											<c:if test="${data.curr_name != null && data.curr_name != ''}">
												<c:set var="stdt_name_list" value="${fn:split(data.stdt_name, ',')}"/>
												<c:if test="${fn:length(stdt_name_list) <= 1}">
													<c:set var="stdt_name" value="${data.stdt_name }"/>
													<span>${data.curr_name}<c:if test="${data.count != 0 }">[${data.count }]</c:if></span><p>[${data.curr_begin_date}~${data.curr_end_date}] ${data.prof }/${data.empl }&nbsp;&nbsp;|&nbsp;&nbsp;${stdt_name}</p>
												</c:if>
												<c:if test="${fn:length(stdt_name_list) > 1 }">
													<c:set var="stdt_names" value="${fn:split(data.stdt_name,', ') }"/>
													<c:set var="stdt_name" value="${stdt_names[0]}"/>
													<span>${data.curr_name}<c:if test="${data.count != 0 }">[${data.count }]</c:if></span><p>[${data.curr_begin_date}~${data.curr_end_date}] ${data.prof }/${data.empl }&nbsp;&nbsp;|&nbsp;&nbsp;${stdt_name} 외 ${fn:length(stdt_name_list) -1}명</p>
												</c:if>
											</c:if>

											<c:if test="${data.curr_name == null || data.curr_name == ''}">
												<span>${data.share_type != '전체'? data.share_type : '전'} 과정 전체 <c:if test="${data.count != 0 }">[${data.count }]</c:if></span>
												<p>전체&nbsp&nbsp|&nbsp&nbsp전체</p>
											</c:if>
										</td>
										<td>
											<c:if test="${data.del_flag == '1'}"><span style="font-size:15px; color:black;" class="off">미배포설정</span></br></c:if>
											<c:if test="${data.del_flag == '0' }">
												<c:if test="${data.share_boolean == '1' }"><span style="font-size:15px; color:#74acf6;" class="off">공유대기</span></br></c:if>
												<c:if test="${data.share_boolean == '0' }">
													<c:if test="${data.time < 0 }"><span style="font-size:15px;" class="off">공유종료</span></c:if>
													<c:if test="${data.time > 0 }"><span style="font-size:15px;" class="on">D-<fmt:formatNumber value="${data.time/60/60/24 }" type="number"/></span></c:if>
													<c:if test="${data.time == 0 }"><span style="font-size:15px;" class="on">D-DAY</span></c:if></br>
												</c:if>
											</c:if>
											[공유기간]${fn:replace(data.begin_date,'. ','.')} ~ ${fn:replace(data.end_date,'. ','.')}
										</td>
										<td>
											${data.name}</br>
											${fn:substring(data.reg_date, 0, 4)}. 
											${fn:substring(data.reg_date, 4, 6)}. 
											${fn:substring(data.reg_date, 6, 8)} 
											${fn:substring(data.reg_date, 8, 10)}:${fn:substring(data.reg_date, 10, 12)}:${fn:substring(data.reg_date, 12, 14)}
										</td>											
									</tr>
								</c:forEach>
								<c:if test="${shareList == null || fn:length(shareList) == 0 }">
									<tr><td colspan="6" class="not_found">공유대상이 없습니다.</td></tr>
								</c:if>
								</tbody>
							</table>
							<div class="noticeBtn listNumBtn">
								<%=Utils.getPage2018(total,incpage, 10, 10)%>
								<div class="writeBtn">
									<div class="btnMd">
										<a href="javascript:openShareDataPopup('', 'insert');" class="btn">영상공유</a>
									</div>
								</div>
							</div>	
						</div>
					</div>
				</div>
					<div class="viewList"></div><!--class="viewList"-->
				</div><!--class="subcontent gongViewcontent"-->
			</div><!--class="gonggamView"-->
			<div class="ListpageBtn">
				<div class="btnMd">
					<a href="javascript:void(0)" onClick="document.frm.submit();">목록</a>
				</div>
			</div><!--class="ListpageBtn"-->
		</div><!--class="subcomWrap"-->
	</section>
	<!--팝업 bg 시작-->
	<div class="popupBg" id="popupBg" onClick="closeShareDataPopup();" style="z-index: 14;"></div>		
	<!--팝업 bg 끝-->	 
	<form id="shareForm" name="shareForm">
		<div id="share_data_popup">
		</div>	
	</form>	
	
	<form action="${pageContext.request.contextPath}/rad/contents/mediaUpload.kh?idx=${params.idx}" method="post" id="frm" name="frm">
		<input type="hidden" name="searchKey" id="searchKey" value="${data.key }">
		<input type="hidden" name="searchValue" id="searchValue" value="${data.value }">
		<input type="hidden" id="cpage" name="cpage" value="${params.cpage}">
		<input type="hidden" id="no" name="no" value="${params.no}">
		<input type="hidden" id="mode" name="mode" value="update">
	</form>	
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/footer_2018.jsp"/>	
</body>
<input type="hidden" id="category" value="${mediaViewData.category}" />
<input type="hidden" id="mediaToken" value="${mediaToken}" />
<script type="text/javascript">

$(function(){
	document.getElementById("mediaView").src = "https://play.mbus.tv/${mediaViewData.object_id}";	
})	
	function addShareData() {
		document.querySelector("#popupBg").style.display = "block";
		document.getElementById("share_data_popup").style.display = "block";
	}
	function addCommentShareData(){
		document.querySelector("#popupBg2").style.display = "block";
		document.getElementById("comment_data_popup").style.display = "block";
	}
	function closeCommentDataPopup(){
		document.getElementById("media_student_popup").style.display = "none";//
		$("#popupBg2").fadeOut();
		$("#comment_data_popup").fadeOut();
		$("#comment_data_popup").empty();
	}
	function closeShareDataPopup() {
		document.getElementById("media_student_popup").style.display = "none";
		$("#popupBg").fadeOut();
		$("#share_data_popup").fadeOut();
		$("#share_data_popup").empty();
	}

	function setCurr(no, currname, begin_date, end_date, prof, empl_charge) {
		document.getElementById("curr_no").value = no;
		document.getElementById("curr_name").value = currname;
		getSelectedCurrStudentList.detectCurrChangeEvent(no);
	}

	$.fn.currAutoComplete = function() {
		const checkNo = function(value) {
			const params = {
				name		: value,
				mideaShare	: "1"
			};

			$.ajax({
				url		: '${pageContext.request.contextPath}/rad/contents/currNoFinder.kh'
				, data		: params
				, dataType	: 'html'
				, type		: 'post'
				, success	: function(data, textStatus){
					$("#curr_name_list").show();
					$("#curr_name_list").html(data);
				}
				, error		: function(jqXHR, textStatus, errorThrown){
					alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
				}
			});
		}

		// keyup check
		$(this).keyup(function() {
			const value = $(this).val();
			checkNo(value);
		});

		$("body").on('click', function(e) {
			var clickObject = $(e.target);
			
			if (!clickObject.hasClass('curr_name_list')) {
				$("#curr_name_list").hide();
			}
		});
	}

	const getSelectedCurrStudentList = {
		"getStudentFromDb": function(value) {
			const params = {
				currNo		: value
			};

			$.ajax({
				url		: '${pageContext.request.contextPath}/rad/contents/getSelectedCurrStudentList.kh'
				, data		: params
				, dataType	: 'html'
				, type		: 'post'
				, success	: function(data, textStatus){
					//$("#media_student_popup").show();
					$("#share_student_view").hide();
					$(".multiselect").show();
					$(".multiselect").html(data);
				}
				, error		: function(jqXHR, textStatus, errorThrown){
					alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
				}
			});
		},
		"detectCurrChangeEvent": function(no){
			if (no != null && no != "") {
				getSelectedCurrStudentList.getStudentFromDb(no);
			}
		}
	}
	var expanded = false;

	function showCheckboxes() {
	  var checkboxes = document.getElementById("checkboxes");
	  if (!expanded) {
	    checkboxes.style.display = "block";
	    expanded = true;
	  } else {
 	    checkboxes.style.display = "none";
	    expanded = false;
	  }
	}
	
	function saveShareData(mode) {
		const form = document.getElementById("shareForm");
		const formData = new FormData(form);
		formData.append("no", "${mediaViewData.no}");
		formData.append("mode", mode);

		$.ajax({
			url		  : '${pageContext.request.contextPath}/rad/contents/mediaSharedMemberSave.kh'
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
	}

	function submitResult(response) {
		const result = response.result;
		const message = response.message;

		alert(message);

		if (Number(result) > 0) {
			window.location.reload();
		}
	}
	function deleteMediaAndMember(){
		document.frm.action = '${pageContext.request.contextPath}/rad/contents/mediaUploadDelete.kh'; 
		document.frm.submit();
	}
	function openShareDataPopup(sub_no, mode, open_flag, no, curr_no) {
		$("#share_data_popup").load('${pageContext.request.contextPath}/rad/contents/getShareDataForUpdate.kh', {sub_no: sub_no, mode: mode, open_flag:open_flag, no:no, curr_no:curr_no}, addShareData());
	}
	function openCommentShareForm(no , comment_stat, index){
		$("#comment_data_popup").load('${pageContext.request.contextPath}/rad/contents/getCommentData.kh', {no: no, comment_stat: comment_stat, index: index}, addCommentShareData());
	}
	function doPagingClick(page){
		location.href="${pageContext.request.contextPath}/rad/contents/mediaUploadView.kh?no="+${params.no}+"&incpage="+page;
	}
	function hideComment(no, sub_no, hide_flag, index, curr_no, open_flag, bSub_no, comment_stat){
   		if(hide_flag == 0){
   			boolean = confirm("해당 댓글을 숨김처리하시겠습니까?");
   			hide_flag = 1;
   		}else{
   			boolean = confirm("해당 댓글을 복구하시겠습니까?");
   			hide_flag =0;
   		}   		
   		var params = {
   				sub_no		: sub_no
   				, hide_flag	: hide_flag
   		};
   		if(boolean === true){
   			$.ajax({
   				url		  : '${pageContext.request.contextPath}/rad/contents/updateCommentDel.kh'
   				, data		  : params
   				, dataType	  : 'json'   				
   				, type		  : 'post'
   				, success	  : function(data, textStatus) {
   					if(data.result == 1){
	   					if(hide_flag ==1){
	   						alert("해당 댓글을 숨김처리 하였습니다.");	   						
	   					}else{
	   						alert("해당 댓글을 복구하였습니다.");	   						
	   					}
	   					if(comment_stat != null){
	   						openCommentShareForm(no, comment_stat, index);
	   					}else{
	   						openShareDataPopup(bSub_no, 'update', open_flag, no, curr_no);
	   					}
   					}else{
   						alert("댓글수정에 실패했습니다.");
   					}
   				}
   				, error		  : function(jqXHR, textStatus, errorThrown) {
   					alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
   				}
   			});
   		}
    }	
</script>

<style>
	.gongViewcontent .viewAdminBtn{text-align:right;}
	.listNumBtn>ul{border-top:none;}
	.popupBg{position:absolute; top:0; left:0; width:100%; height:100%; background:#000; opacity:0.4;}
	.dels > a{background: #2a2a4e;}
	.curr_name_list {
		position: absolute; 
		top: 40px; 
		left: 5px; 
		width: 598px; 
		height: 160px; 
		padding: 10px; 
		overflow-y: scroll; 
		display: none; 
		background: #fff; 
		z-index: 1; 
		border: 1px solid #ececec;
		text-align: left;
	}

	.ListBox select {
	  width: 620px;
	  max-height:55px;
	  padding-left:8px;
	  background:none;
	}
	
	#Listbox_in {
	  display: none;
	  overflow-y:auto;
	  background:#fff;
	  width:620px;
	  height:245px;
	  border-left:1px solid #ececec;
	  border-bottom:1px solid #ececec;
	}

	#comment_data_popup {
		display: none;  
		position:fixed; 
		width: 745px; 
		max-height: 339px; 
		bottom: 50%; 
		left: 29%;
		z-index: 999; 
	}

	#comment_data_popup .all_share{margin-left:10px;}

	#comment_data_popup .comment_title{
		width:745px; 
		height:50px; 
		background-color:#3b84ff;
		color:#fff;
		text-align:center;
		padding-top:15px;
		box-sizing:border-box;		
	}
	#comment_data_popup .close_btn{
		background: url(/resources/images/rad/tablePop_x_kh.png) no-repeat center right 15px;
		float: right;
	    margin-top: 16px;
	    display: inline-block;
	    width: 21px;
	    height: 21px;
	}
	#comment_data_popup table tbody>tr>th {
		background:#fff; 
		height:50px;
	}

	#comment_data_popup table tbody>tr>td {
		padding: 5px; 
		border:none; 
		text-align:left;
		width:685px; 
		padding-left:30px;
	}

	.subcomTap{
		margin-top:30px; 
		border:none; 
		padding-left:15px;
		box-sizing:border-box;
		height: 25px;
	}

	.subcomTap>ul>li>span{
		line-height:20px;
	    cursor: pointer;
	}

	.boxtapWrap ul li.outon span{
		color:#3b84ff;
	}

	#share_data_popup {
		display: block;  
		position:fixed; 
		width: 745px; 
		max-height: 339px; 
		bottom: 50%; 
		left: 29%;
		z-index: 999; 
	}
	.boxtapWrap ul li.outon p{
		background: #3b84ff;
    	width: inherit;
    	height: 3px;
    }
    .boxtapWrap ul li p{		
    	margin-top: 20px;
    }
	#share_data_popup .course{
		padding-top:15px;
	}	

	#share_data_popup .course_title{
		padding-top:12px;
		cursor:pointer;
	}	

	#share_data_popup .course_title p{
		margin-top:5px;
	}	

	#share_data_popup .all_share{
		margin-left:10px;
	}	

	#share_data_popup .share_title{
		width:745px; 
		height:50px; 
		background-color:#3b84ff; 
		color:#fff; 
		text-align:center; 
		padding-top:15px; 
		box-sizing:border-box;
	}
	#share_data_popup table tbody>tr>th {
		background:#fff; 
		height:50px; 
		width:100px;
	}

	#share_data_popup table tbody>tr>td {
		padding: 5px; 
		border:none; 
		text-align:left;
		width:620px;
	}

	table.comment_list{
		overflow-y:auto; 
		width:745px; 
		height:360px;
		display:block; 
		border-top:1px solid #f3f5f7; 
		margin-top:18px;
	}

	table.comment_list .name_date{
		padding-top:10px;
	}

	table.comment_list .title_middle{
		padding-bottom:10px;
		color:#999;
		font-size:12px;
	}

	table.comment_list .line_bottom{
		border-bottom:1px solid #ececec; 
		padding-bottom:15px;
		line-height:1.3;
	}

	table.comment_list .last{
		border-bottom:none;
	}

	.btn {
		background: #58697b;
		color:#fff; 
		display: inline-block;
	}

	.btn_update {height: 1em; 
		width: 25px; 
		background: url(${pageContext.request.contextPath}/resources/images/rad/btn_edit.jpg) no-repeat; background-position: 0px 1px;
		display: inline-block; 
		vertical-align: -3px; 
		margin-left: 5px;
	}	
	.comment_update textarea{
		height: 50px; 
		background: #f4f4f8; 
		border: 0; 
		width: 738px; 
		margin: 0; 
		padding: 0; 
		overflow: auto;
	}	

	.off_hidden{vertical-align:bottom; margin-left:5px;}
	.on_hidden{vertical-align:bottom; margin-left:5px;}

	.multiselect {
	  width: 200px;
	}

	.selectBox {
	  position: relative;
	}

	.selectBox select {
	  width: 620px;
	  max-height:55px;
	  padding-left:8px;	  
	}

	.overSelect {
	  position: absolute;
	  left: 0;
	  right: 0;
	  top: 0;
	  bottom: 0;
	}

	#checkboxes {
	  display: none;
	  overflow-y:auto;
	  background:#fff;
	  width:620px;
	  height:245px;
	  border-left:1px solid #ececec;
	  border-bottom:1px solid #ececec;
	}

	#checkboxes label {
	  display: block;
	  padding-left:10px;
	  margin-top:5px;
	}

	.share_btnBox{
		width:100%;
		background:pink; 
	}
	.share_btn {
		padding-left:10px;
		margin-top:5px;
		border-top:1px solid #f3f5f7;
	}
	.share_btn a {
		margin-right: 6px;
	    margin-bottom: 6px; 
		display:block; 
		color:#fff; 
		position:relative;
		top:6px;
		left:250px;
		padding:6px 10px; 
		line-height:12px; 
		width:22px;
		float:left;
		height:12px; 
		border-radius:19px; 
		letter-spacing:-0.5px; 
		font-size:12px;
		font-weight:300;
	}

		.announce_com_table .noticeTable table tbody td{
			padding:15px 10px;
		}

		.announce_com_table .noticeTable table tbody td p{
			color:#999; 
			font-weight:400; 
			line-height:1.5
		}

		.announce_com_table .noticeTable td.text_left{
			text-align:left; 
			line-height:2.0;
		}
		.announce_com_table .noticeTable td span{
			color:#000; 
			font-size:14px;
		}

		.announce_com_table .noticeTable .on{
		color:#ff626c;
		}

		.announce_com_table .noticeTable .off{
		color:#999;
		}
		.validate_error_message{
		color:#ff626c;
		}
</style>
</html>


