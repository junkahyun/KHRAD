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
	Calendar cal = Calendar.getInstance();
	Calendar currentDate = Calendar.getInstance();
	currentDate.add(cal.DATE, -7);
	
	String strCD = currentDate.get(currentDate.YEAR)+"";
	if(currentDate.get(cal.MONTH)<9) strCD+="0";
	strCD+=(currentDate.get(cal.MONTH)+1)+"";
	if(currentDate.get(cal.DATE)<10) strCD+="0";
	strCD+=currentDate.get(cal.DATE)+"";
	
	String cpage = Utils.nvl((String)request.getAttribute("cpage"), "1");
	int total = Integer.parseInt((String)request.getAttribute("total"));
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<c:set var="role" value="${sessionScope.aduser.role_code}"/>
<c:set var="currentDate" value="<%=strCD %>"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<c:if test="${sessionScope.aduser.site_id == 'kh' }">
<title>KH정보교육원 RAD :: 학습동영상</title>
</c:if>
<c:if test="${sessionScope.aduser.site_id == 'atents' }">
<title>아텐츠 RAD :: 학습동영상</title>
</c:if>
<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/meta_2018.jsp"/>

</head>
<body>
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/header_2018.jsp"/>
	<section id="section">
	<jsp:include page="/WEB-INF/jsp/rad/portlet/right_quick.jsp"/>
	<input type="hidden" id="location_name" value="학습동영상">	
		<div class="sectionwrap subcomWrap">
			<div class="mediaUpload">
				<div class="tit">
					<h3>학습동영상</h3>
				</div>
				<div class="subcomTap boxtapWrap">
					<ul>
						<li class="${params.sorting==null || params.sorting==''? 'outon':''}" id="all"><p><a href="javascript:fnSorting('',1);">전체동영상</a></p></li>
						<li class="${params.sorting=='자바'? 'outon':''}" id="java"><p><a href="javascript:fnSorting('자바',1);">자바동영상</a></p></li>
						<li class="${params.sorting=='보안'? 'outon':''}" id="security"><p><a href="javascript:fnSorting('보안',1);">보안동영상</a></p></li>
						<li class="${params.sorting=='홍보'? 'outon':''}" id="promotion"><p><a href="javascript:fnSorting('홍보',1);">홍보동영상</a></p></li>
						<li class="${params.sorting=='우리반영상'? 'outon':''}" id="promotion"><p><a href="javascript:fnSorting('우리반영상',1);">우리반영상</a></p></li>
						<li class="${params.sorting=='사전학습'? 'outon':''}" id="promotion"><p><a href="javascript:fnSorting('사전학습',1);">사전학습영상</a></p></li>
					</ul>
				</div>
				<div class="subcontent mediaUploadContent">
					<div class="mediaUploadMid">
					<!-- 검색폼 시작 -->
					<form action="${pageContext.request.contextPath}/rad/contents/mediaUpload.kh" method="post" id="frm" name="frm" style="margin-top:30px;">
						<div class="botsearchBox" style="margin-top: 0;">
						<div class="selectMenuWrap">
						<c:if test="${fn:length(categoryList) >0 }">
							<select id="searchCategory" style="width: 150px;">
							<c:if test="${params.sorting == '자바' or params.sorting == '보안'}">
								<option value="">${params.sorting }전체</option>
							</c:if>
								<c:forEach items="${categoryList }" var="clist">
									<option value="${clist.no }" ${params.category_no == clist.no? 'selected':'' }>${clist.name }</option>	
								</c:forEach>
							</select>
						</c:if>
						<select id="searchKey" name="searchKey" style="width: 150px;">
							<option value="TITLE" ${params.searchKey == 'TITLE'?'selected':''}>제목</option>
							<option value="NAME" ${params.searchKey == 'NAME'?'selected':''}>작성자</option>
						</select>
						</div><!--class="selectMenuWrap"-->
						<div class="searchBtn">
							<input type="text" id="searchValue" name="searchValue" size="35" onkeypress="if(event.keyCode==13) {fnSearch(); return false;}" style="text-align: center;" value="${params.searchValue}">
						</div>
						<div class="btnMd">
							<a href="javascript:fnSearch();" style="background: #2a2a4e; border-radius:0; padding: 9px 22px;">검색</a>
						</div>
						<utils:authority url="/rad/contents/mediaUploadForm.kh">
							<div class="writeBtn">
								<div class="btnMd">
									<a href="javascript:void(0);" 
									   onClick="document.frm.action = '${pageContext.request.contextPath}/rad/contents/mediaUploadForm.kh'; document.frm.submit();"
									   style="border-radius:0; background:#ff626c; padding: 9px 22px;">
									   동영상 업로드</a>
								</div>
							</div>
						</utils:authority>
						<input type="hidden" id="sorting" name="sorting" value="${params.sorting }">
						<input type="hidden" id="cpage" name="cpage" value="${params.cpage}">
						<input type="hidden" id="no" name="no" value="">
						<input type="hidden" id="category_no" name="category_no" value="">
						<input type="hidden" id="mode" name="mode" value="insert">
						</div><!--class="botsearchBox"-->
					</form>
					<!--//검색폼 끝-->
					<div style="width: 1280px; height: 1px; background: #f3f5f7; position: relative;"></div>
					<div class="border_line_1"></div>
					<div class="border_line_2"></div>
						<ul class="cf list1" >	
						<c:set var="length" value="${fn:length(list)}" />
						<c:forEach items="${list}" var="data" varStatus="status">
							<c:set var="itemDate" value="${fn:substring(data.reg_date, 0, 8)}" />
							<c:set var="counts" value="${(length != 12 && length - (length % 4) >= status.count) || (length == 12 && 10 >= status.count)}" />
							<li style='padding-right: 82px;'>
								<ul>
									<!-- 새글 표시 -->
									<li class="${(currentDate lt itemDate and not fn:contains(readNo, data.no))?'newNot':''}" style="height: 35px;width: 33px;margin-bottom: 20px;"></li>
									<li class="img" onclick="fnSelect('${data.no}')">
										<%-- 썸네일이 없는 경우 Midibus에서 제공하는 썸네일을 조회 --%>
										<img class="img_img" style="width: 280px; height: 158px;"
											<c:if test="${data.thumbnail != null && data.thumbnail != ''}">
												src="${pageContext.request.contextPath}/upload/contents/media/${fn:split(data.thumbnail, '|')[0]}" 
											</c:if>
											<c:if test="${data.thumbnail == null || data.thumbnail == ''}">
												src="https://${data.midi_thumbnail}" 
											</c:if>
											onerror="src='${pageContext.request.contextPath}/upload/admcom/video_default.jpg'"
										/>
										<div name="thumbnail_cover"></div>
										<img src="${pageContext.request.contextPath}/resources/images/rad/main/play_btn.png" name="play_btn">
										<span name="durationText">${fn:substring(data.duration, 3, 8)}</span>
									</li>
									<li class="txt">
										<p class="txt01">
											[${data.category}<c:if test="${data.category == '홍보' or data.category == '우리반영상'}"></c:if><c:if test="${data.category == '자바' or data.category == '보안' }">/${data.sub_category_name }</c:if>] ${data.name}
										</p>
										<p class="txt01">
											${fn:substring(data.reg_date, 0, 4)}. 
											${fn:substring(data.reg_date, 4, 6)}. 
											${fn:substring(data.reg_date, 6, 8)} 
											${fn:substring(data.reg_date, 8, 10)}:
											${fn:substring(data.reg_date, 10, 12)}:
											${fn:substring(data.reg_date, 12, 14)}
										</p>
										<p class="txt02" onclick="fnSelect('${data.no}')" style="text-overflow: ellipsis;overflow: hidden;width: 240px;white-space: nowrap;"><span style="color: #ff626c;"><c:if test="${data.share_count > 0}">[공유중]</c:if></span> ${data.title}</p>
									</li>
								</ul>
							</li>
							<c:if test="${!status.first && status.count % 4 == 0}">
							<br style="clear:both;"/>
							</c:if>
						</c:forEach>
						<c:if test="${list == null || fn:length(list) == 0}">
							<div style="text-align: center; padding: 100px; font-size: 15px;">검색 결과가 없습니다.</div>
						</c:if>
					</ul><!--class="list1"-->
						<div class="gongBtn listNumBtn">						
						<%= Utils.getPage2018(total,cpage, 12, 10) %>						
					</div><!--class="listNumBtn"-->
				</div><!--class="gongMid"-->
			</div><!--class="mediaUpload"-->
		</div><!--class="subcomWrap"-->		
	</section>
	<!--팝업 bg 시작-->
	<div class="popupBg"></div>
	<!--팝업 bg 끝-->
	
	<!-- 우측 퀵메뉴 시작 -->	
	<!-- 우측 퀵메뉴 끝 -->	
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/footer_2018.jsp"/>	
</body>

<script type="text/javascript">
	jQuery(function(){
		fnCurrentSub('07', '01');		
		checkDepart();
	});

	function checkDepart(){
		const departArr = {
				java : "자바", 
				security : "보안"
			};
		
		const userdepart = "${params.depart}";
		const userRole = "${params.roleFirstLetter}";
		
		if(userRole === "T"){/*롤코드가 T로 시작하는 경우, 해당 학부만 보이게 설정 합니다.*/
			for(var key in departArr){
				if(userdepart.indexOf(departArr[key]) < 0){
					$("#"+key+"").remove();
					$("#"+key+"2").remove();
				}
			}
		}
	}

	function doPagingClick(page){
		$("#cpage").val(page);
		document.frm.submit();
	}

	function fnSorting(data,cpage){
		$("#sorting").val(data);
		doPagingClick(cpage);
	}
	
	function fnSearch(){
		const category_no = $("#searchCategory option:selected").val();
		$("#category_no").val(category_no);
		doPagingClick(1);
	}
	
	function fnSelect(no) {
		document.frm.no.value = no;
		document.frm.action = "${pageContext.request.contextPath}/rad/contents/mediaUploadView.kh";
		document.frm.submit();
	}
</script>

<style>
	.img {position: relative;}
	div[name="thumbnail_cover"] {top: 0px; position: absolute; width: 280px; height: 158px; opacity: 0.4; background: #000;}
	img[name="play_btn"] {width: 45px; height: 45px; top: 65px; left: 120px; position: absolute;}
	span[name="durationText"] {bottom: 12px; right: -65px; position: absolute; padding: 4px; font-size: 13px; background: #000; color: #fff;}
	.boxtapWrap ul li.outon:after {content: "";display: block;width: 100%;height: 3px;background: #3b84ff;margin-top: 22px;bottom: 0;position: absolute;margin: 0;}
	.boxtapWrap ul li.outon p{color: #3b84ff;}
	.listNumBtn {height:90px;}
	.border_line_1{width:1280px; height:1px; background:#f3f5f7; position:relative; top:352px;}
	.border_line_2{width:1280px; height:1px; background:#f3f5f7; position:relative; top:701px;}
</style>
</html>