<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 		uri="/WEB-INF/tlds/c.tld" %> 
<%@ taglib prefix="fn" 		uri="/WEB-INF/tlds/fn.tld" %>
<%@ taglib prefix="fmt"		uri="/WEB-INF/tlds/fmt.tld" %>
<%@ taglib prefix="utils"	uri="/WEB-INF/tlds/utils.tld" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>KH 정보교육원 RAD :: 학생설문조사</title>
<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/meta.jsp"/>
<c:set var="fq" value="${fn:split(data.first_q, '_')}"/>
<c:set var="sq" value="${fn:split(data.second_q, '_')}"/>
<c:set var="tq" value="${fn:split(data.third_q, '_')}"/>
<script type="text/javascript">
jQuery(function(){
	fnCurrentSub('03', "03");
	fnSurveyGetQuestion();
});

function fnSurveyGetQuestion(){
	var params = {
		template_no  : '${params.template_no}',
		degree       : '${params.degree}',
		classify     : '${params.classify}'
		
	};

	$.ajax({
		  url		: '${pageContext.request.contextPath}/rad/curr/surveyGetQuestion.kh'
		, data		: params
		, dataType	: 'html'
		, type		: 'post'
		, success	: function(data, textStatus){
			$("#survey_form_view").html(data);
			$("#survey_form_view").show();
		}
		, error		: function(jqXHR, textStatus, errorThrown){
			alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
		}
	});
}

function surveyDefaultTemplate() {
	var params = {
		template_no  : '${params.template_no}',
		degree       : '${params.degree}',
		classify     : '${params.classify}',
		curr_classify : '${params.curr_classify}'
	};

	$.ajax({
		  url		: '${pageContext.request.contextPath}/rad/curr/surveyDefaultTemplate.kh'
		, data		: params
		, dataType	: 'json'
		, type		: 'post'
		, success	: function(data, textStatus){
			alert("등록을 완료했습니다.");
		}
		, error		: function(jqXHR, textStatus, errorThrown){
			alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
		}
	});
}

function surveyTemplateDelete() {
	if (confirm("정말로 삭제하시겠습니까?")) {
		var params = {
			template_no  : '${params.template_no}'
		};

		$.ajax({
			url		: '${pageContext.request.contextPath}/rad/curr/surveyTemplateDelete.kh'
			, data		: params
			, dataType	: 'json'
			, type		: 'post'
			, success	: function(data, textStatus){
				alert("삭제를 완료했습니다.");
				location.href = "${pageContext.request.contextPath}/rad/curr/surveyFormList.kh?cpage=${params.cpage}&classify=${params.classify}";
			}
			, error		: function(jqXHR, textStatus, errorThrown){
				alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
			}
		});
	}
}
</script>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/rad/portlet/right_quick.jsp"/>
	<input type="hidden" id="location_name" value=disable>		
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/metaHeader_2018.jsp"/>
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/header_2018.jsp"/>
	<div id="body" onmouseover="fnCloseSubs();">
		<div id="headtitle">
			<c:if test="${params.classify == 'D'}">
			<div class="left">학생설문조사</div>
			</c:if>
			<c:if test="${params.classify == 'E'}">
			<div class="left">취업설문관리</div>
			</c:if>
			<div class="right">
			</div>
		</div>
		<div class="survey_top">
			<div class="survey_btns" style="font-size: 15px;">
				${params.survey_name} [${params.degree}차 설문조사]
			</div>
			-
		</div>
		<ul class="survey_form_view" id="survey_form_view">
			
		</ul>
		<div class="btns_center"> 
			<%--<utils:authority url="/rad/curr/surveyModify.kh">
				<c:if test="${sessionScope.aduser.role_code != 'TM' }">
					<a href="javascript:return false;" id="modify_btn" class="btn" 
						title="아직 등록되지 않은 회차를 등록합니다." onClick="document.modifyFrm.submit();">설문내용수정</a>
				</c:if>	
			</utils:authority>
			--%>
			<utils:authority url="/rad/curr/surveyTemplateDelete.kh">
				<c:if test="${sessionScope.aduser.role_code != 'TM' }">
					<a href="javascript:return void(0);" class="btn"
						title="설문조사 세트를 삭제합니다." onClick="surveyTemplateDelete();">설문삭제</a>
				</c:if>	
			</utils:authority>
			<utils:authority url="/rad/curr/surveyDefaultTemplate.kh">
				<a href="javascript:return false;" class="btn"
					title="이 설문조사 세트를 모든 운영과정에서 사용하도록 일괄적용합니다." onClick="surveyDefaultTemplate();">기본설문으로 설정</a>
			</utils:authority>				
			<a href="${pageContext.request.contextPath}/rad/curr/surveyFormList.kh?cpage=${params.cpage}&classify=${params.classify}" class="btn">목록으로 돌아가기</a>
		</div>
	</div>

	<form id="modifyFrm" name="modifyFrm" action="${pageContext.request.contextPath}/rad/curr/surveyModify.kh" method="post">
		<input type="hidden" id="cpage" name="cpage" value="${params.cpage}" />
		<input type="hidden" id="mode" name="mode" value="update" />
		<input type="hidden" id="template_no" name="template_no" value="${params.template_no}" />
		<input type="hidden" id="survey_name" name="survey_name" value="${params.survey_name}" />
		<input type="hidden" id="degree" name="degree" value="${params.degree}" />
		<input type="hidden" id="classify" name="classify" value="${params.classify}" />
		<input type="hidden" id="curr_classify" name="curr_classify" value="${params.curr_classify}" />
	</form>
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/footer.jsp"/>
</body>
</html>