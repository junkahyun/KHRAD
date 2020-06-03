<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 		uri="/WEB-INF/tlds/c.tld" %> 
<%@ taglib prefix="fn" 		uri="/WEB-INF/tlds/fn.tld" %>
<%@ taglib prefix="fmt"		uri="/WEB-INF/tlds/fmt.tld" %>
<%@ taglib prefix="utils"	uri="/WEB-INF/tlds/utils.tld" %>
<%@ page import="com.kh.utils.Utils"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>KH 정보교육원 RAD :: 이벤트 신청 집계 게시판</title>
<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/meta.jsp"/>

<c:if test="${params.idx=='MANAGER'}">
<style>

#headtitle { width: 900px; margin: 0 auto; overflow: hidden; padding-bottom: 25px; }
#board_reply .board_reply_list li .right { width: 870px; }

</style>
</c:if>

</head>
<body>
	<jsp:include page="/WEB-INF/jsp/rad/portlet/right_quick.jsp"/>
	<input type="hidden" id="location_name" value=" 문의관리 &nbsp; > &nbsp; 이벤트 신청 집계 게시판">	
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/metaHeader_2018.jsp"/>
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/header_2018.jsp"/>
	<div id="body" onmouseover="fnCloseSubs();" style="width: 1300px;">
		<div id="category_select_cont">
			<select id="category_select" style="width: 200px;">
				<option ${params.category == 'T202001' ? 'selected' : ''} value="T202001">2020. 01 토크콘서트</option>
				<option ${params.category == 'E201910' ? 'selected' : ''} value="E201910">2019. 10 채용박람회</option>
				<option ${params.category == 'E201903' ? 'selected' : ''} value="E201903">2019. 03 채용박람회</option>
				<option ${params.category == 'T201901' ? 'selected' : ''} value="T201901">2019. 01 토크콘서트</option>
				<option ${params.category == 'E201810' ? 'selected' : ''} value="E201810">2018. 10 채용박람회</option>
				<option ${params.category == 'T201801' ? 'selected' : ''} value="T201801">2018. 01 토크콘서트</option>
			</select>
		</div>
		<div id="content_cont">
		</div>
	</div>
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/footer.jsp"/>
</body>

<script>
	function getEventDetail(category, parameter) {
		var	params	= {
			category		: category,
			parameter	    : JSON.stringify(parameter)
		};
		
		$.ajax({
			url		: '${pageContext.request.contextPath}/rad/main/eventDetail.kh',
			dataType	: 'html',
			type		: 'post',
			data		: params,
			success		: function (data, textStatus) {
				$("#content_cont").html(data);
			},
			error		: function (jqXHR, textStatus, errorThrown) {
				alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
			}
		});
	}

	const category = '${params.category}';
	const parameter = JSON.parse('${parameter}');

	// 기본값
	if (category == '' || category == null) {
		getEventDetail('T202001', {mode: 'inquiry'});
	} else {
		getEventDetail(category, parameter);
	}

	$("#category_select").on('change', function(){
		const category = $(this).val();
		getEventDetail(category, {mode: 'inquiry'});
	});
</script>
</html>