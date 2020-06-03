<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="/WEB-INF/tlds/c.tld"%>
<%@ taglib prefix="fn" uri="/WEB-INF/tlds/fn.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tlds/fmt.tld"%>
<script>
	
	function changeView(no){

		location.href="${pageContext.request.contextPath}/rad/notice/issueView.kh?no=" + no + "&cpage="+cpage;
	}
		
	$('.gongViewcontent .txtList li').eq(0).css({'left':'0'});
	$('.gongViewcontent .txtList li').eq(1).css({'left':'215px'});
	$('.gongViewcontent .txtList li').eq(2).css({'left':'430px'});
	$('.gongViewcontent .txtList li').eq(3).css({'left':'645px'});
	$('.gongViewcontent .txtList li').eq(4).css({'left':'860px'});
	
	
	$('.gongViewcontent .imgList li').on('mouseover',function(){
		var idx=$(this).index();
		$('.gongViewcontent .txtList li').eq(idx).css({'display':'block'});
	});
	$('.gongViewcontent .imgList li').on('mouseout',function(){
		var idx=$(this).index();
		$('.gongViewcontent .txtList li').eq(idx).css({'display':'none'});
	});
	
	$('.gongViewcontent .txtList li').on('mouseover',function(){
		var idx=$(this).index();
		$('.gongViewcontent .txtList li').eq(idx).css({'display':'block'});
	});
	$('.gongViewcontent .txtList li').on('mouseout',function(){
		var idx=$(this).index();
		$('.gongViewcontent .txtList li').eq(idx).css({'display':'none'});
	});
	
	
</script>


						 <%-- <c:if test="${params.rnum==3 }"> --%>
							<%-- <div class="listPrev listBtncom">
								<a>
									<img src="${pageContext.request.contextPath}/resources/images/rad/cirarrow_prev.png" alt="공감썸네일리스트 prev" />
								</a>
							</div> --%>
						<%-- </c:if>	 --%>
						<%-- <c:if test="${!params.rnum==3 }"> --%>
								
							<div class="listPrev listBtncom" onclick="doPagingThumL();">
									
							</div>
								
						 <%-- </c:if> --%>
						
						<div class="listThumb">														
							<ul class="imgList">
								<c:set var="length" value="${fn:length(list)}" />
								<c:forEach var="list" items="${list}" varStatus="status">
									<%-- <li style="background: url('${pageContext.request.contextPath}/upload/admcom/${fn:split(list.addfile1, '|')[0] }'); no-repeat;  background-size: cover;" class=" selected ${list.no} ${list.no==params.no?'on':''}" onClick="changeView('${list.no}',${cpage1});"  onerror="src='${pageContext.request.contextPath}/upload/admcom/gonggam_default.jpg'"> --%>	
									<li>
									<img  src="${pageContext.request.contextPath}/upload/admcom/${fn:split(list.addfile1, '|')[0] }" onerror="src='${pageContext.request.contextPath}/upload/admcom/gonggam_default.jpg'"  width="215px" height="170px"/>
									</li>
								</c:forEach>
							</ul>
							<ul class="txtList">
								<c:set var="length" value="${fn:length(list)}" />
								<c:forEach var="data" items="${list}" varStatus="status">
									<li onclick="changeView('${data.no}');">
										<p class="txt1">[${empty data.branch?'전':data.branch}지원]<br />${fn:substring(data.reg_date, 0, 4) }. ${fn:substring(data.reg_date, 4, 6) }. ${fn:substring(data.reg_date, 6, 8) }</p>
										<p class="txt2">${data.title}</p>
									</li>	
								</c:forEach>
							</ul>						
						</div>
						
								
							<div class="listNext listBtncom" onclick="doPagingThumR()">
									
							</div>
								
					
						<%-- <c:if test="${lastPage eq cpage}">
							<div class="listNext listBtncom">
								<a>
									<img src="${pageContext.request.contextPath}/resources/images/rad/cirarrow_next.png" alt="공감썸네일리스트 next" />
								</a>
							</div>
						</c:if> --%>
						
					