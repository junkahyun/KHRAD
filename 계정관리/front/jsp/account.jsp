<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 		uri="/WEB-INF/tlds/c.tld" %> 
<%@ taglib prefix="fn" 		uri="/WEB-INF/tlds/fn.tld" %>
<%@ taglib prefix="fmt"		uri="/WEB-INF/tlds/fmt.tld" %>
<%@ taglib prefix="utils"	uri="/WEB-INF/tlds/utils.tld" %>
<%@ page import="com.kh.utils.Utils"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.net.URL"%>
<%@page import="org.springframework.util.FileCopyUtils"%>
<%
	String cpage = Utils.nvl((String)request.getAttribute("cpage"), "1");
	int total = Integer.parseInt((String)request.getAttribute("total"));
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<c:set var="id" value="${sessionScope.aduser.id}"/>
<c:set var="role_code" value="${sessionScope.aduser.role_code }"/>
<c:set var="dept_code" value="${sessionScope.aduser.dept_code }"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="Cache-Control" content="no-cache">
<meta http-equiv="Expires" content="0">
<meta http-equiv="Pragma" content="no-cache">

<c:if test="${sessionScope.aduser.site_id == 'kh' }">
<title>KH정보교육원 RAD :: 사이트관리</title>
</c:if>
<c:if test="${sessionScope.aduser.site_id == 'atents' }">
<title>아텐츠 RAD :: 사이트관리</title>
</c:if>
<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/meta.jsp"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/resources/css/jojicdo_2018.css?201805031854" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/resources/css/_kh/jojicdo_color.css?201805031854" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/js/dhtmlx/suite/dhtmlx.css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/resources/js/swiper-4.2.0/css/swiper.min.css?201805031854" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/resources/css/_${sessionScope.aduser.site_id }/account_popcalender.css" />
<script src="${pageContext.request.contextPath}/resources/js/dhtmlx/suite/dhtmlx.js"></script>
<script src="${pageContext.request.contextPath }/resources/js/swiper-4.2.0/js/swiper.min.js?201805031854"></script>
<script src="${pageContext.request.contextPath}/resources/js/radselect.js?201805031854"></script>
<script src="${pageContext.request.contextPath}/resources/js/radCalaendar_2018.js?201805031854"></script>
<script src="${pageContext.request.contextPath}/resources/js/rad.js?201903251352"></script>

<style>
#address::-webkit-input-placeholder {color: #bcbcbc;}
/* 수정 @dongxuan09 2017-06-30 */
#board_list td .list_blue {position:inherit; top:0px;}
#board_list td .list_gray {position:inherit; top:0px; margin-top:1px;}
#board_list td .list_black {position:inherit; top:0px; margin-top:1px;}
.popup .info_txt label{
	position: absolute;top: 8px;left: 2px;width: 145px;height: 25px;text-align: center;
    line-height: 25px;font-size: 12px;font-weight: 300;letter-spacing: -0.3px;color: #7a7a7a;
    font-family: inherit;border: 0;border-radius: 0;cursor: text;outline-style: none;-webkit-appearance: none;
}
.popup table th { width: 100px; padding:0;}
.popup .popup_btns { margin-top: 15px; padding-top: 15px;}
.popup .info_txt label:nth-child(4) {top: 44px;}
.popup_btns .btn {padding: 4px 31px; letter-spacing:-0.5px; border-radius:19px; margin-left:10px; font-size:13px;}
.smsList:nth-child(2){padding: 0px;padding-bottom: 21px;padding-top: 19px;}
.side_btns .btn { height: 31px; line-height: 31px;}
.list_blue, .list_black, .list_gray, .list_red {width: 83px; padding: 0 !important;}
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/metaHeader_2018.jsp"/>
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/header_2018.jsp"/>
	<jsp:include page="/WEB-INF/jsp/rad/portlet/right_quick.jsp"/>
	<input type="hidden" id="location_name" value=" 사이트관리 &nbsp; > &nbsp; 계정관리">
	<div id="body" onmouseover="fnCloseSubs();" style="width: 100%;">
		<div id="headtitle">
			<div class="left">계정관리</div>
			<div class="right">
			</div>
		</div>
		<div class="side_btns">
			<div class="left">
				<c:if test="${role_code=='AM' or role_code=='SM' or role_code=='EO'}">
				<select id="select_site_id" onchange="fnChangeSite();">
	                <option value="*" <c:if test="${params.search_site_id == '*' }">selected</c:if> >전체</option>
	                <option value="kh" <c:if test="${params.search_site_id == 'kh' }">selected</c:if> >KH</option>
	                <option value="atents" <c:if test="${params.search_site_id == 'atents' }">selected</c:if> >Atents</option>
				</select>
				</c:if>
	                                
				<a href="javascript:fnBranch('');" class="btn ${params.branchs==null or params.branchs==''? '':'off'}">전체보기</a>
				<c:forEach var="bds" items="${bList }" varStatus="vs">
				<a href="javascript:fnBranch(${bds.no});" class="btn ${bds.no==params.branchs? '':'off'}">${bds.name }</a>
				</c:forEach>
			</div>
			<div class="right">
			<c:if test="${fn:substring(role_code, 0, 1) != 'T'}">
				<%--<input id="selectMenu">  --%>
				<input type="text"  name="depart4search" value="${parentOrgs }" placeHolder="부서선택" onclick="javascript:fnSelectDepartment(1);" style="width: 200px;" readonly="true">
				<a href="javascript:fnDepartReset();" class="btn on">부서 초기화</a>
				<a href="javascript:fnIsO('A');" class="btn ${params.searchIsoffice=='A' or (params.isRole!='T' and (params.searchIsoffice==null || params.searchIsoffice==''))? 'on':'off'}">전체</a>
				<a href="javascript:fnIsO('I');" class="btn ${params.searchIsoffice=='I'? 'on':'off'}">임직원</a>
				<a href="javascript:fnIsO('IO');" class="btn ${params.searchIsoffice=='IO'? 'on':'off'}">임직원 퇴사</a>
				<a href="javascript:fnIsr('T');" class="btn ${params.isRole=='T'? 'on':'off' }">강사</a>
				<a href="javascript:fnIsO('TO');" class="btn ${params.searchIsoffice=='TO'? 'on':'off'}">강사 퇴사</a>
			</c:if>
			<c:if test="${fn:substring(role_code, 0, 1) == 'T'}">
				<a href="javascript:fnIsr('T');" class="btn ${params.searchIsoffice==null || params.searchIsoffice==''? 'on':'off'}">강사</a>
			</c:if>
			
			<c:if test="${role_code=='AM' or role_code=='SM' or id == 'nocturn93' or id == 'hay4863'}">
				<a href="javascript:fnRIT('RI');" class="btn" id="retireButton">퇴직신청</a>
			</c:if>
			
			</div>
		</div>
		
		<table cellpadding="0" cellspacing="0" id="board_list">
			<tr>
				<th width="2%"><input type="checkbox" name="unSelectedList"></th>
				<th width="3%">번호</th>
				<th width="5%">아이디</th>
				<th width="100px;">사진</th>
				<th width="5%">성명</th>
				<th width="8%">영문명</th>
				<th width="6%">직급/직책</th>
				<th width="6%">생일</th>
				<th width="10%">부서</th>
				<th width="6%">직무</th>
				<th width="9%">사내전화</th>
				<th width="9%">휴대전화</th>
				<th width="7%">네이트온</th>
				<th width="7%">사내메일</th>
				<th width="5%">입사일</th>
				<th width="5%">퇴사일</th>
				<th width="16%">관리</th>
			</tr>
			<c:forEach var="data" items="${list}">
			<tr>
				<td>
					<input type="checkbox" name="unSelectedItem">
					<input type="hidden" name="no" value="${data.no}"> 
					<input type="hidden" name="name" value="${data.name}"> 
					<input type="hidden" name="mobile" value="${data.mobile}">
				</td>
				<td>${total-data.rnum+1 }</td>
				<td>${data.id }</td>
				<td onClick="javascript:fnUserView('${data.no}','AC');">
					<c:if test="${data.thumnail == null || empty data.thumnail}">
						<c:if test="${sessionScope.aduser.site_id == 'kh' }">
							<img width="85px" height="93px" style="border:#ececec solid 1px;" src="${pageContext.request.contextPath}/resources/images/account_basic.jpg" />
						</c:if>
						
						<c:if test="${sessionScope.aduser.site_id == 'atents' }">
							<img width="85px" height="93px" style="border:#ececec solid 1px;" src="${pageContext.request.contextPath}/resources/images/account_basic_atents.jpg" />
						</c:if>
					</c:if>
					
					<c:if test="${data.thumnail != null && not empty data.thumnail}">
						<img width="85px" height="93px" style="border:#ececec solid 1px;" src="${pageContext.request.contextPath}/upload/profile/${data.thumnail}" />
					</c:if>
				</td>
				<td onClick="javascript:fnUserView('${data.no}','AC');">
					${data.name }
				</td>
				<td onClick="javascript:fnUserView('${data.no}','AC');">
					${data.engname }
				</td>
				<td onClick="javascript:fnUserView('${data.no}','AC');">
					${data.dept }
				</td>
				<td onClick="javascript:fnUserView('${data.no}','AC');">
					<c:if test="${data.birth!=null and data.birth!='' }">${fn:substring(data.birth, 0, 4)}.<br/>${fn:substring(data.birth, 6, 8)}. ${fn:substring(data.birth, 10, 12)}(${data.yu=='1'? '음':'양' })</c:if>
				</td>
				<td onClick="javascript:fnUserView('${data.no}','AC');">
					${fn:replace(data.depart, '/', '/<br/>')}
				</td>
				<td onClick="javascript:fnUserView('${data.no}','AC');">
					${data.role_code_name }
					<%-- 
					<select id="role_code" disabled="disabled">
					<c:forEach var="roleObj" items="${roleList}" varStatus="vs">
                        <option value="${roleObj.name }" <c:if test="${data.role_code == roleObj.name }">selected</c:if> >${roleObj.description }</option>
                    </c:forEach>
                    </select>
                    --%>
				</td>
				<td onClick="javascript:fnUserView('${data.no}','AC');">
					${data.phone }
				</td>
				<td onClick="javascript:fnUserView('${data.no}','AC');">
					${data.mobile }
				</td>
				<td onClick="javascript:fnUserView('${data.no}','AC');">
					${data.messanger }
				</td>
				<td onClick="javascript:fnUserView('${data.no}','AC');">
					${data.email }
				</td>
				<td onClick="javascript:fnUserView('${data.no}','AC');">
					${fn:substring(data.join_date, 0, 4) }.<br/>${fn:substring(data.join_date, 4, 6) }. ${fn:substring(data.join_date, 6, 8) }
				</td>
				<td onClick="javascript:fnUserView('${data.no}','AC');">
					<c:if test="${data.out_date!=null and data.out_date!=''}">${fn:substring(data.out_date, 0, 4) }.<br/>${fn:substring(data.out_date, 4, 6) }. ${fn:substring(data.out_date, 6, 8) }</c:if>
				</td>
				<td>
					<c:if test="${data.role_code_name != '없음'}">
						<utils:authority url="/rad/auth/accountSave.kh">
						<c:if test="${role_code=='AM' or role_code=='SM' or role_code=='EO' or ((sessionScope.aduser.branch==data.branch and data.role_code!='AM') or (sessionScope.aduser.depart == '경영지원부/회계팀'))}">
						<a href="javascript:fnApply('${data.no}');" class="list_blue">수정</a>
						</c:if>
						</utils:authority>
						
						<utils:authority url="/rad/auth/accountChangeTempPass.kh">
						<c:if test="${role_code=='AM' or role_code=='SM' or role_code=='EO' or ((sessionScope.aduser.branch==data.branch and data.role_code!='AM') or (sessionScope.aduser.depart == '경영지원부/회계팀'))}">
						<a href="javascript:fnChangeTempPass('${data.no}');" class="list_gray">임시비번발행</a>
						</c:if>
						</utils:authority>
						
						<utils:authority url="/rad/auth/accountDelete.kh">
						<c:if test="${role_code=='AM' or role_code=='SM' or id == 'nocturn93'}">
						<a href="javascript:fnDelete('${data.no}');" class="list_gray">삭제</a> 
						</c:if>
						</utils:authority>
					</c:if>
					
					<!-- 계정신청 시 보여지는 버튼 -->
					<c:if test="${data.role_code_name == '없음'}">
						<utils:authority url="/rad/auth/accountApply.kh">
						<%-- <c:if test="${sessionScope.aduser.role_code=='SM' or sessionScope.aduser.id == 'nocturn93'}"> --%>
						<a href="javascript:fnApply('${data.no}');" class="list_red" id="list_red${data.no}">승인대기</a>
						<%-- </c:if> --%>
						</utils:authority> 
						
						<c:set var="serverName" value="${fn:split(data.fileupload, '|')[0]}"/>
						<c:set var="origiName" value="${fn:split(data.fileupload, '|')[1]}"/>
						
						<c:if test="${data.file_del == 0}">
						<a href="javascript:doFileDownload('${serverName}','${origiName}','${data.no}','');" class="list_gray" id="accountDown${data.no}">서류다운로드</a>
						</c:if>
						<input type="hidden" id="file_del${data.no}" value="${data.file_del == 0 ? 0 : 1}">
					</c:if>
				</td>
			</tr>
			</c:forEach>
			<c:if test="${list==null or fn:length(list)==0}">
			<tr><td class="not_fount" colspan="17">등록된 계정이 없습니다.</td></tr>
			</c:if>
		</table>
		<div id="board_nums">
			<%=Utils.getPage(total,cpage, 20, 20)%>
		</div>
	</div>
	
	
	<!-- 계정등록 등록,수정팝업 -->
	<div class="popup_wrap" id="popup_insert" style="display: none;"></div>
	<!-- 계정등록,수정팝업 끝 -->
	
	<!-- 조직도 팝업 -->
	<div class="jojicPopup popup account_popup" style="z-index:99;text-align: -webkit-center;"></div>
	<div class="popupBg" onClick="orgPopupClose();" style="display: block;opacity: 0.4;"></div>
	<!-- 조직도 팝업 끝 -->
	
	<!-- 전송내역 상세보기 팝업 -->
	<div class="popup_wrap smsPopCom" id="popupSmsUpdate">
		<div class="bg" onclick="fnClosePopup();"></div>
		<div class="popup" style="width: 830px; height: 536px;margin-left: -450px;margin-top: -238px;">
			<div class="smsPopTitle" id="detailSmsTitle">메시지 전송<img src="${pageContext.request.contextPath}/resources/images/rad/smsPopQuestion.jpg" id="smsPopTitleQuestionIcon"></div>
			<div class="smsPopTitleQuestion" id="smsPopTitleQuestion">
				<p class="smsPopTitleQuestion_title">메시지 전송안내</p>
				<div class="smsPopTitleQuestion_txt">
					<p>· KH 앱이 설치된 수신자는 앱을 통해<br>&nbsp;&nbsp;&nbsp;Push알림으로 메시지가 전송됩니다.</p>
					<p>· 일정시간동안 Push 메시지를 확인하지<br>&nbsp;&nbsp;&nbsp;않는  앱 수신자에게는 같은 내용의<br>&nbsp;&nbsp;&nbsp;메시지를 SMS를 통해 재전송 됩니다.</p>
					<p>· 앱을 설치하지 않은 수신자 및 긴급인 경우에는<br>&nbsp;&nbsp;&nbsp;SMS를 통해 전송됩니다.</p>
				</div>
			</div><!-- //smsPopTitleQuestion -->
			
			<div class="popup_content cf" id="popSmsUpdateContent" >
				
			</div><!-- //popup_content -->
			<div class="popup_btn">
				<div class="btnSm" style="margin-right: 5px;">
					<a href="javascript: fnSendSms()"style="background: #ff626c;">메시지전송</a>
				</div>
				<div class="btnSm">
					<a href="javascript: $('#popupSmsUpdate').fadeOut()" style="background: #2a2a4e;">취소</a>
				</div>
			</div>
		</div><!-- //popup -->
	</div><!-- //popup_sms -->
	<div class="popup_wrap account" id="popup_view" style="display: none;">
		<div class="bg" onclick="fnClosePopup();"></div>
			<div class="popup" style="width: 340px; margin-top: -258px; margin-left: -441px;">
			<div class="popup_title">사원정보</div>
			<div class="popup_content" >
				<div id="member_detail">
				</div>
				
				<div class="popupBg" onClick="orgPopupClose();"></div>
			</div>
		</div>
	</div>
	<!-- 전송내역 상세보기 팝업 끝 -->
	<!-- 조직도 팝업 -->
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
	<%-- 
	<div class="popup_wrap" id="popup_multiplesms">
		<div class="bg" onclick="fnClosePopup();"></div>
		<div class="popup" style="width: 480px; height: 620px;"> 
			<div class="popup_title" id="detailSmsTitle">SMS 대량발송</div>
			<div class="popup_content" >
				<div id="detailPane" style="height: 480px;">
					<div  style="width:400px; height:430px;float:left; border:1px solid #eee; padding: 10px;" >
						<div id="selectListPane" style="height: 230px; overflow: auto;" >
							<div id="selectListItems" style="overflow: auto;">
								<center>메시지를 수신할 사람을 선택하시기 바랍니다.</center>
							</div>
						</div>
						<div  style="float:right;">
							<a href="javascript: fnRemove()" class="btn">수신자 삭제</a>
						</div>
						<div style="width:100%; height:193px; float:left; border:1px solid #ececec; background: #FFFFFF; position:relative; background-image: url(""); ">
							<input type="hidden" id="mode" value="insert" >
							<table style="width:100%; ">
								<tr>
									<td width="100px;">보내는사람</td>
									<td colspan="3">
										<input type="text" id="sms_from" onkeyup="fnCheckNo('from');" value="${fn:replace(sessionScope.aduser.mobile, '-', '')}" style="width:100%;">
									</td>
								</tr>
								<tr>
									<td >제       목</td>
									<td colspan="3">
										<input type="text" id="sms_subject" maxlength="20" value="${params.sms_subject}" style="width:100%;" >
									</td>
								</tr>
								<tr>
									<td colspan="4">
										<textarea id="sms_msg" onkeyup="fnSmsCont()" rows="10" style="width:100%;" >${params.sms_msg}</textarea>
									</td>
								</tr>
							</table>
						</div>
					</div>
				</div>
				<div class="popup_btns">
					<a href="javascript: fnSendSms()" class="btn">메시지 전송</a>
					<a href="javascript: $('#popup_multiplesms').fadeOut()" class="btn">닫기</a>
				</div>
			</div>
		</div>
	</div>
	--%>
	
	<!-- 파일 다운로드용 폼 -->
	<form name="filefrm" method="post" action="${pageContext.request.contextPath}/rad/auth/accountdownload.kh">
		<input type="hidden" name="serverName" id="serverName"/>
		<input type="hidden" name="origiName" id="origiName"/>
		<input type="hidden" name="accountno" id="accountno"/>
		<input type="hidden" name="retireDown" id="retireDown"/>
		<input type="hidden" name="aduserId" id="aduserId"/>
	</form>
	
	<form action="${pageContext.request.contextPath}/rad/auth/account.kh" method="post" id="frm" name="frm">
		<div id="board_search">
			<div class="board_search_line" style="border: 0; text-align: center;">
				<input id="searchKey" name="searchKey" style="width: 105px;">
				<input type="text" id="searchValue" name="searchValue" onkeydown="fnSearchEnter();" size="35" style="text-align: center;" value="${params.searchValue }">
				<a href="javascript:fnSearch();" class="btn" style="background: #80a8cc; height: 31px; line-height: 31px;">검색</a>

				<utils:authority url="/rad/auth/accountChangeTempPass.kh">
				<a href="javascript:fnChangeTempPass();" class="btn etc">전체 임시비밀번호발행</a>
				</utils:authority>
				<a href="javascript:fnSmsPopupOpen();" class="btn etc">SMS 수신자 추가 및 발송</a>
			</div>
		</div>
		<input type="hidden" id="search_site_id" name="search_site_id" value="${params.search_site_id }">
		<input type="hidden" id="site_ids" name="site_ids" value="${params.site_id }">
		<input type="hidden" id="cpage" name="cpage" value="${params.cpage }">
		<input type="hidden" id="searchIsoffice" name="searchIsoffice" value="${params.searchIsoffice }">
		<input type="hidden" id="isRole" name="isRole" value="${params.isRole }">
		<input type="hidden" id="branchs" name="branchs" value="${params.branchs }">
		<input type="hidden" id="isDepart" name="isDepart" value="${params.isDepart }">
		<input type="hidden" id="dept_code4search" name="dept_code4search" value="${params.dept_code4search }">
	</form>
	
	<%-- <form action="${pageContext.request.contextPath}/rad/main/free.kh" id="freeFrm" name="freeFrm" method="post">
		<input type="hidden" id="dept_code_free" name="dept_code">
		<input type="hidden" id="id_free" name="id">
	</form> --%>
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/footer.jsp"/>
</body>

<script>
//var myTree;
//var mode ='insert';
var no=0;
var orgFlag=0; // 0: for update, 1: for search 

(function(){
	fnCurrentSub('09', '05');
	/* 하단 검색창 설정 함수 */
	mkSelectDA('selectMenu', '부서별보기_대표이사_회계팀_강남지원_종로지원_기획본부', '선택_대표이사_회계팀_강남지원_종로지원_기획본부');
	mkSelectD('searchKey', '이름_전화번호', 'NAME_MOBILE');
	mkdSelectedValue('selectMenu', "${params.isDepart==null or params.isDepart==''? '선택':params.isDepart}");
	mkdSelectedValue('searchKey', "${params.searchKey==null or params.searchKey==''? 'NAME':params.searchKey}");
	/* 하단 검색창 설정 함수 */
	
	smsPopTitleHover();/* sms팝업 css 함수 */
	hideRetireBtn();/* 퇴직신청 버튼 노출 유무 함수 */
})();

function smsPopTitleHover(){
	$("#smsPopTitleQuestionIcon").hover(
		function(){
			$('#smsPopTitleQuestion').css("display", "block");
		},
		function(){
			$('#smsPopTitleQuestion').css("display", "none");
		}
	);
		
	$("#smsPopTitleQuestion").hover(
		function(){
			$('#smsPopTitleQuestion').css("display", "block");
		},
		function(){
			$('#smsPopTitleQuestion').css("display", "none");
		}
	);
}

function hideRetireBtn(){
	const RIbtn = "${RIbtn}";
	if(RIbtn === "0"){
		$("#retireButton").hide();
	}
	else{
		$("#retireButton").show();
	}
}

// 사내전화, 전화번호 수정
function fnToNext(obj, event){
	var l = $(obj).prop("maxlength");
	if(l == $(obj).val().trim().length)
		$(obj).next().focus();
	

		event = event || window.event;
		var keyID = (event.which) ? event.which : event.keyCode;
		if ( keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
			return;
		else
			event.target.value = event.target.value.replace(/[^0-9]/g, "");
}

function onlyNumber(event){
	event = event || window.event;
	var keyID = (event.which) ? event.which : event.keyCode;
	if ( (keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
		return;
	else
		return false;
}
//사내전화, 전화번호 끝

function fnSelectDepartment(flag){
	orgFlag = flag;
	fnRetrieveOrg();
	fnOpenPopup('department');
}

function fnRetrieveOrg() {
	myTree = new dhtmlXTreeObject("viewOrg","100%","100%",0);
	myTree.setOnClickHandler(onTreeitemClick);
	myTree.setXMLAutoLoading("${pageContext.request.contextPath}/rad/auth/org/orgTree.kh");
	myTree.setImagePath("${pageContext.request.contextPath}/resources/js/dhtmlx/suite/skins/web/imgs/dhxtree_web/");
	myTree.setDataMode("xml");
	myTree.load("${pageContext.request.contextPath}/rad/auth/org/orgTree.kh?id=1");
}

function onTreeitemClick(itemId,type){
	$('#popup_department').fadeOut();
	
	if(orgFlag == 0) {
		$('#dept_code').val( itemId );
		$.ajax({
			  url		: '${pageContext.request.contextPath}/rad/auth/accountOrgHierarchy.kh'
			, data		: {no : itemId}
			, dataType	: 'json'
			, type		: 'post'})
			.success(function(data, textStatus) {
				var dept = data['parentOrgs'];
				if(site_id == 'kh'){
					$("#department").val( dept.split("_").slice(1).join("/") );
				}
				else if(site_id == 'atents'){
					$("#department").val( dept.split("_").slice(0).join("/") );
				}
			})
			.error(function(jqXHR, textStatus, errorThrown) {
				alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
			})
	}
	else {
		$("#dept_code4search").val(itemId);
		$("#cpage").val(1);
		document.frm.submit();
	}
}

/* 계정팝업 */
function fnApply(no){
	let documentDownStatus = document.getElementById("accountDown"+no+"");
	if(documentDownStatus !== null){
		if($("#file_del"+no+"").val() === "0"){
			alert("서류다운로드를 해주세요!");
			return;
		}
	}
	$.ajax({
		url	: '${pageContext.request.contextPath}/rad/auth/accountMainPopUp.kh',
		dataType : "html",
		type : "get",
		data : {no : no}})
		.success (function(data, textStatus){
			$('#popup_insert').html(data);	
		})
		.error (function (jqXHR, textStatus, errorThrown) {
			alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
	})
		fnOpenPopup('insert');
}

/*사용자 팝업으로 보기*/
function fnUserView(no,gubun){
	$.ajax({
		  url		: '${pageContext.request.contextPath}/rad/main/selectUserInfo.kh'
		, data		: {no : no, gubun : gubun}
		, dataType	: 'html'
		, type		: 'post'})
		.success(function(data, textStatus) {
			$(".jojicPopup").html(data);
			$('.jojicPopup').fadeIn();
			$('.popupBg').fadeIn();
		})
		.error (function (jqXHR, textStatus, errorThrown) {
			alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
	})
}

function fnChangeSite(){
	$("#cpage").val(1);
	$("#search_site_id").val( $("#select_site_id option:selected").val() );
	document.frm.submit();
}
function fnBranch(no){
	$("#branchs").val(no);
	$("#cpage").val(1);
	document.frm.submit();
}
function doPagingClick(page){
	$("#cpage").val(page);
	document.frm.submit();
}
function fnIsO(iso){
	$("#searchIsoffice").val(iso);
	$("#isRole").val('');
	$("#cpage").val(1);
	document.frm.submit();
}
function fnIsr(role){
	$("#searchIsoffice").val('');
	$("#isRole").val(role);
	$("#cpage").val(1);
	document.frm.submit();
}

function fnRIT(role){
	$("#searchIsoffice").val("RI");
	$("#isRole").val('');
	$("#cpage").val(1);
	document.frm.submit();
}

function fnDelete(no){
	if(!confirm('정말로 삭제하시겠습니까?')){
		return;
	}
	$.ajax({
		  url		: '${pageContext.request.contextPath}/rad/auth/accountDelete.kh'
		, data		: {no : no}
		, dataType	: 'json'
		, type		: 'post'})
		.success(function(data, textStatus) {
			var result = data.result;
			if(result === 0) {
				alert('삭제에 실패하였습니다.');
			} else {
				alert('삭제했습니다..');
				doPagingClick('${params.cpage}');
			}
		})
		.error(function(jqXHR, textStatus, errorThrown) {
			alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
		})
}

/* 계정관리 페이지 변경되기 이전에 있던 연차관리 탭관련 함수입니다. */
/* function fnFree(dept_code, id){
	$("#dept_code_free").val(dept_code);
	$("#id_free").val(id);
	document.freeFrm.submit();
} */

function fnSearchEnter(){
	if(event.keyCode==13){
		fnSearch();
	}
}

function fnSearch(){
	if($("#searchValue").val() === null && $("#searchValue").val() === ''){
		alert('검색어를 입력해주십시오.');
		return;
	}
	document.frm.action = '${pageContext.request.contextPath}/rad/auth/account.kh';
	document.frm.submit();
}

function fnChangeTempPass(no){
	if(no !== null) {
		if(confirm('선택한 사용자의 비밀번호가 초기화 됩니다. 정말로 초기화 하시겠습니까?') === false){
			return;
		}
	}
	else {
		if(confirm('최근 7일간 비밀번호를 변경하지 않은 사용자들의 비밀번호가 초기화 됩니다. 시간이 소요되는 작업입니다. 정말로 초기화 하시겠습니까?') === false){
			return;
		}
	}
	$.ajax({
		  url		: '${pageContext.request.contextPath}/rad/auth/accountChangeTempPass.kh'
		, data		: {no : no}
		, type		: 'post'})
		.success(function(data, textStatus) {
			alert("성공적으로 임시 비밀번호가 발행 되었습니다.");
		})
		.error(function(jqXHR, textStatus, errorThrown) {
			alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
		})
}

function fnDepartReset() {
	$("[name=depart4search]").val("");
	$("#dept_code4search").val("");
	fnSearch();
}

/////////////// SMS 보내기  START ///////////////////////////
function fnCheckboxAttachEvent(){
	$(':checkbox[name=selectedList]').click (function () {
		 if ($(this).prop("checked") == true) {
          $("input[name=selectedItem]").prop("checked", true);
       }
       else {
          $("input[name=selectedItem]").prop("checked", false);
       }
	});
	
	$(':checkbox[name=unSelectedList]').click (function () {
      if ($(this).prop("checked") == true) {
          $("input[name=unSelectedItem]").prop("checked", true);
      }
      else {
          $("input[name=unSelectedItem]").prop("checked", false);
      }
	});
}

function fnSmsPopupOpen(){
	/*
	var smsReceiver = "[";
	var i=0;
	$(':checkbox[name=unSelectedItem]').each (function () {
		if ($(this).prop("checked") == true) {
			
			if( i > 0 ) smsReceiver += ",";
			smsReceiver += "{"; 
			smsReceiver += "\"category\":\"직원\", ";
			smsReceiver += "\"recv_name\":\"" + $(this).siblings("[name=name]").val() + "\", \"mobile\":\"" + $(this).siblings("[name=mobile]").val() + "\"";
			smsReceiver += "\"category\":\"account\", ";
			smsReceiver += "\"no\":\"" + $(this).siblings("[name=no]").val() + "\", ";
			smsReceiver += "\"recv_name\":\"" + $(this).siblings("[name=name]").val() + "\", ";
			smsReceiver += "\"mobile\":\"" + $(this).siblings("[name=mobile]").val() + "\"";
			smsReceiver += "}";
		}
	}); 
	smsReceiver += "]";
	*/
	
	var smsReceiver = "[";
	var i=0;
	$(':checkbox[name=unSelectedItem]').each (function () {
		if ($(this).prop("checked") == true) {
			
			if( i > 0 ) smsReceiver += ",";
			smsReceiver += "{"; 
			smsReceiver += "\"category\":\"account\", ";
			smsReceiver += "\"recv_name\":\"" + $(this).siblings("[name=name]").val() + "\", \"mobile\":\"" + $(this).siblings("[name=mobile]").val() + "\"";
			smsReceiver += "}";
		}
	}); 
	smsReceiver += "]";
	
	var params = {
		category		: "직원",
		session_key		: "account",
		smsReceiver		: smsReceiver
	};
	
	$.ajax({
		  url		: '${pageContext.request.contextPath}/rad/main/sms/smsAddReceiver.kh' 
		, data		: params
		, async		: true
		, type		: 'post'
		//, contentType: "application/x-www-form-urlencoded; charset=UTF-8"
		, success	: function(data, textStatus) {
			$("#selectListItems").html( data );
			
			//$("#selectListItems").html( data );
			//fnCheckboxAttachEvent();
			//fnOpenPopup('multiplesms');
			
			$("#popSmsUpdateContent").html( data );
			fnCheckboxAttachEvent();
			
			//fnOpenPopup('multiplesms');
			$('#popupSmsUpdate').show();
		}
		, error		: function(jqXHR, textStatus, errorThrown) {
			alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
		}
	});
}

function fnRemove(){
	var smsReceiver = "[";
	var i=0;
	$(':checkbox[name=selectedItem]').each (function () {
		if ($(this).prop("checked") == true) {
			
			if( i > 0 ) smsReceiver += ",";
			smsReceiver += "{"; 
			smsReceiver += "\"category\":\"직원\", ";
			smsReceiver += "\"recv_name\":\"" + $(this).siblings("[name=recv_name]").val() + "\", \"mobile\":\"" + $(this).siblings("[name=mobile]").val() + "\"";
			smsReceiver += "}";
		}
	});
	smsReceiver += "]";
	
	var params = {
		category		: "직원",
		smsReceiver		: smsReceiver
	};
	
	$.ajax({
		  url		: '${pageContext.request.contextPath}/rad/main/sms/smsRemoveReceiver.kh' 
		, data		: params
		, async		: true
		, type		: 'post'})
		//, contentType: "application/x-www-form-urlencoded; charset=UTF-8"
		.success(function(data, textStatus) {
			$("#selectListItems").html( data );
			fnCheckboxAttachEvent();
		})
		.error(function(jqXHR, textStatus, errorThrown) {
			alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
		})
}

function fnRemoveReceiver(obj, recv_name, mobile){
	var smsReceiver = "[";
	var i=0;
	$(':checkbox[name=selectedItem]').each (function () {
		if ($(this).prop("checked") == true) {
			
			if( i > 0 ) smsReceiver += ",";
			smsReceiver += "{"; 
			smsReceiver += "\"category\":\"직원\", ";
			smsReceiver += "\"recv_name\":\"" + $(this).siblings("[name=recv_name]").val() + "\", \"mobile\":\"" + $(this).siblings("[name=mobile]").val() + "\"";
			smsReceiver += "}";
		}
	});
	smsReceiver += "{"; 
	smsReceiver += "\"category\":\"account\", ";
	smsReceiver += "\"recv_name\":\"" + recv_name + "\", \"mobile\":\"" + mobile + "\"";
	smsReceiver += "}";
	smsReceiver += "]";
	
	var params = {
		category		: "직원",
		session_key		: "account",
		smsReceiver		: smsReceiver
	};
	
	$.ajax({
		  url		: '${pageContext.request.contextPath}/rad/main/sms/smsRemoveReceiver.kh' 
		, data		: params
		, async		: true
		, type		: 'post'
		//, contentType: "application/x-www-form-urlencoded; charset=UTF-8"
		, success	: function(data, textStatus) {
			$("#selectListItems").html( data );
			fnCheckboxAttachEvent();
			//$("#selectListItems").html( data );
			//fnCheckboxAttachEvent();
			$(obj).parent().parent().remove();
			
			var len = $(".smsListTableContent ul").length;
			if( len == 0 ) {
				$(".smsListTableContent").html( "<ul class='cf'><li class='not_fount' >메시지를 전송할 사람이 없습니다.</li></ul>" );
			}
		}
		, error		: function(jqXHR, textStatus, errorThrown) {
			alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
		}
	});
}

function fnChangeUrgent() {
	var sub = $('#sms_subject').val();
	if( $('#urgent').prop("checked") == true ) {
		if( sub != null && sub != '' ) {
			var pos = sub.indexOf('긴급!');
			if( pos == -1 ) {
				pos = sub.indexOf('[KH정보교육원]');
				if( pos > -1 ) {
					$('#sms_subject').val( '[KH정보교육원] 긴급!' + sub.substring(pos+9))
				}
				else {
					$('#sms_subject').val( '[KH정보교육원] 긴급! ' + sub)
				}
			}
		}
	}
	else {
		if( sub != null && sub != '' ) {
			var pos = sub.indexOf('긴급!');
			if( pos > -1 ) {
				$('#sms_subject').val( '[KH정보교육원] ' + sub.substring(pos+3))
			}
		}
	}
}

function fnChangeCategory(){
	var subject = '[KH정보교육원] ' + (($('#urgent').prop("checked") == true) ? '긴급! ' : '') + $('#smsPopCatagory option:selected').val() + '입니다';
	$('#sms_subject').val( subject )
}
	
function fnSendSms(){
	var category = $("#smsPopCatagory").val();
	if( category == null || category == '' ) {
		alert("카테고리는  필수 입력 사항입니다.");
		return;
	}
	
	var subject = $("#sms_subject").val();
	if( subject == null || subject == '' ) {
		alert("제목은  필수 입력 사항입니다.");
		return;
	}
	var msg = $("#sms_msg").val();
	if( msg == null || msg == '' ) {
		alert("메시지 내용은  필수 입력 사항입니다.");
		return;
	}
	
	if( confirm("다수에게 메시지를 보내는 것은 시간이 소요 되는 작업입니다. (한명당 1초 정도의 지연시간이 필요합니다)\n진행 하시겠습니까 ?") == false ) {
		return;
	}
	
	var params = {
			mode			: "insert",
			category		: "직원",
			is_student		: "false",
			category		: category,
			session_key		: "account",
			is_emergency	: ($("#urgent").prop("checked") == true) ? "1" : "0",
			is_confirm		: ($("#confirm").prop("checked") == true) ? "1" : "0",
			mobile			: $("#sms_from").val(),
			title		 	: $("#sms_subject").val(),
			message 		: $("#sms_msg").val()
	};
	
	$.ajax({
		  url		: '${pageContext.request.contextPath}/rad/main/sms/sendSms.kh' 
		, data		: params
		, async		: true
		, type		: 'post'
		//, contentType: "application/x-www-form-urlencoded; charset=UTF-8"
		, success	: function(data, textStatus) {
			$('#popup_insert').fadeOut();
			if( confirm("성공적으로 전송했습니다. 보낸 내역 화면으로 이동하시겠습니까 ?") == true ) {
				
				location.href = '${pageContext.request.contextPath}/rad/main/sms/smsMultiple.kh';
			}
			else {
				location.reload();
			}
		}
		, error		: function(jqXHR, textStatus, errorThrown) {
			alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
		}
	});
	
	return false;
}
/////////////// SMS 보내기  END /////////////////////////

/*서류다운로드*/
function doFileDownload(serverName, origiName, no, retire){
	let frm = document.filefrm;
	
	frm.serverName.value = serverName;
	frm.origiName.value = encodeURIComponent(origiName);
	frm.accountno.value = no;
	frm.retireDown.value = retire;
	
	if(retire === "" || retire === null){
		if(confirm("다운로드 후 제출서류가 DB상에서 삭제되어 복구할수 없습니다. 다운로드 하시겠습니까?") === true){
			frm.submit();
			$("#accountDown"+no+"").remove();
			$("#file_del"+no+"").val("1");
		}
		else{
			return;
		}
	}
	else{
		frm.submit();
	}
}
</script>
</html>