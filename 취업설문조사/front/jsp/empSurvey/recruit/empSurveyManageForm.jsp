<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 		uri="/WEB-INF/tlds/c.tld" %> 
<%@ taglib prefix="fn" 		uri="/WEB-INF/tlds/fn.tld" %>
<%@ taglib prefix="fmt"		uri="/WEB-INF/tlds/fmt.tld" %>
<%@ taglib prefix="utils"	uri="/WEB-INF/tlds/utils.tld" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<c:if test="${sessionScope.aduser.site_id == 'kh' }">
<title>KH정보교육원 RAD :: 취업 설문조사</title>
</c:if>

<c:if test="${sessionScope.aduser.site_id == 'atents' }">
<title>아텐츠 RAD :: 취업 설문조사</title>
</c:if>

<jsp:include page="/WEB-INF/jsp/rad/common/_kh/meta_2018.jsp"/>
<jsp:include page="/WEB-INF/jsp/rad/common/_kh/header_2018.jsp"/>			
<jsp:include page="/WEB-INF/jsp/rad/portlet/right_quick.jsp"/>
<style>
.on {}
</style>
</head>
<body>
	<section id="section">
		<div class="sectionwrap subcomWrap">
			<div class="jobsurvey_wrap">
				<div class="tit">
					<h3>취업설문관리</h3>
				</div>
				
				<div class="subcontent jobSurveyContent">
					<h2>취업설문 작성</h2>
					<div class="survey_top">
						<div class="survey_btns">
							<button class="btn" name="degreeBtn" onclick="selectDegree(1);">1차</a></button>
							<button class="btn" name="degreeBtn" onclick="selectDegree(2);">2차</a></button>
							<button class="btn" name="degreeBtn" onclick="selectDegree(3);">3차</a></button>
							<button class="btn" name="degreeBtn" onclick="selectDegree(4);">4차</a></button>
							<input type="hidden" id="degree" name="degree" value="" />
						</div>
						<select id="survey_set_list" >
							<option value="">이전 설문조사 불러오기</option>
							<c:forEach var="data" items="${sData}">
							<option value="${data.no}" ${params.preset_no == data.no ? 'selected' : ''}>${data.survey_name}</option>
							</c:forEach>
						</select>
					</div>
					<div id="sq1_count" class="sq_count">
						<table cellpadding="0" cellspacing="0" >
							<caption>취업설문 작성 테이블</caption>
							<colgroup>
							   <col width="163"> 
							</colgroup>
							<tbody>
								<tr>
									<th scope="col">문항수</th>
									<td class="first_td"> 
										<div class="ar_table num">
											<input type="text" id="add_q" name="num" value="1" class="num" disabled="disabled"/>
											<img onclick="fnQs(1);" src="${pageContext.request.contextPath}/resources/images/rad/arrow_top.jpg" alt="" width="22" height="18" class="bt_up"/>
											<img onclick="fnQs(-1);" src="${pageContext.request.contextPath}/resources/images/rad/arrow_bottom.jpg" alt="" width="22" height="17" class="bt_down"/>
										</div>
									</td>
								</tr>
								<tr>
									<th scope="col">설문 제목</th>
									<td>
										<label>
											<input type="text" id="survey_name" class="typing_box" value="${params.survey_name}" >
										</label>
									</td>
								</tr>
							</tbody>
						</table>
						<table cellpadding="0" cellspacing="0">
							<caption>취업설문 작성 테이블</caption>
							<colgroup>
							   <col width="163"> 
							</colgroup>
							<tbody>
							<!-- 한 줄 -->
							<tr id="node_first" name="question_tr">
								<th rowspan="3"><span name="span_quest_count">1</span>번<br>
									<div class="ar_table ar_num answer_count">
										<input type="text" id="answer_count_1" name="answer_count_1" class="num" value="1"  disabled="disabled"/>
										<img id="answer_1_1" onclick="fnAnswerPm(1, this.id);" src="${pageContext.request.contextPath}/resources/images/rad/arrow_top.jpg" alt="" width="22" height="18" class="bt_up"/>
										<img id="answer_1_2" onclick="fnAnswerPm(-1, this.id);" src="${pageContext.request.contextPath}/resources/images/rad/arrow_bottom.jpg" alt="" width="22" height="17" class="bt_down"/>
									</div>
								</th>
								<td>
									<ul class="survey_qna">
										<li name="question_cont"> 
											<div class="q_title">
												<%-- 질문 유형(컬럼 : question_form) --%>
												<label>
													<input type="radio" id="question_type_g_1" name="question_type_1" value="1" onclick="">객관식
												</label>
												<label>
													<input type="radio" id="question_type_j_1" name="question_type_1" value="0" onclick="">주관식
												</label>
												&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;
												<%-- 그래프 유형(컬럼 : result) --%>
												<label>
													<input type="radio" id="question_result_type_g_1" name="question_result_type_1" value="0" >그래프
												</label>
												<label>
													<input type="radio" id="question_result_type_j_1" name="question_result_type_1" value="1"> 평점
												</label>
												&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;
												<%-- 답변 유형(컬럼 : direct_input) --%>
												<div name="question_answer_count" class="sq_qg">
													<label><input type="radio" name="question_answer_direct_input_1" value="0"> 일반항목</label>
													<label><input type="radio" name="question_answer_direct_input_1" value="1"> 기타항목</label>
													<label><input type="radio" name="question_answer_direct_input_1" value="2"> 사유작성항목</label>
												</div>
											</div>
										</li>
									</ul>
								</td>
							</tr>
							<tr id="node_second" name="question_tr">
								<td>
									<label>
										<input type="text" value="" id="question_1" name="question_title_1" class="typing_box_cont">
									</label>
								</td>
							</tr>
							<tr id="node_third" name="question_tr">
								<td>
									<div class="q_cont">
										<ul class="question_satisfaction">
											<li><span>1)</span>&nbsp;&nbsp;<input type="text" id="question_answer_1_1" name="question_answer_1" value="매우만족"></li> 
										</ul>
									</div>
								</td>
							</tr>
							<!-- //한줄 -->
							</tbody>
						</table>
					</div>
						
					<!-- 자바, 보안 항목 -->
					<!-- <div id="sq3_count" class="sq_count">
						<div class="select_curr">
							<label>
								<input type="radio" id="java_radio" name="check_radio" value="java_box" class="input_checked" checked="checked">&nbsp;자바
							</label>
							<label>
								<input type="radio" id="security_radio" name="check_radio" value="security_box" class="input_checked">&nbsp;보안
							</label>
						</div>
					</div> -->
					
				</div>
			</div>
		</div>
		<div class="WriteBtn" style="text-align: center;">
			<div class="btnMd update">
			<a href="javascript:fnApply();" style="background: #ff626c;">
				<c:if test="${params.mode!='update'}">
					등록
				</c:if>
				<c:if test="${params.mode=='update'}">
					수정
				</c:if>
			</a>
			</div>
			<div class="btnMd cancel">
				<a href="javascript:fnBack();" style="background: #2a2a4e;">취소</a>
			</div>
		</div>
	</section>
<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/footer_2018.jsp"/>
</body>
<script>
jQuery(function(){
	
});


/*
 * 문항 추가하는 함수_2020.05.22
 */
let count = 1;
function fnQs(add_num){ 
	if(add_num === 1){
		count++;
		createChildNodes(add_num, count);
	}
	else if(add_num === -1){
		count--;
		removeChildNodes();
	}
	$('#add_q').empty().val(count, count);
}

/*
 * 문항 생성하는 함수(수정해야됨)_2020.05.22
 */
function createChildNodes(add_num, count){
	let node_first = document.getElementById('node_first');
	let node_second = document.getElementById('node_second');
	let node_third = document.getElementById('node_third');
	
	for(let i=0; i<add_num; i++){
		let cloneNode_first = node_first.cloneNode(true);
		let cloneNode_second = node_second.cloneNode(true);
		let cloneNode_third = node_third.cloneNode(true);
		
		$('#node_third').after(cloneNode_third)
		$('#node_third').after(cloneNode_second)
		$('#node_third').after(cloneNode_first)
	}
	
	changeHTML(count);
}

/*
 * id,name값 재설정 하는 함수(수정해야됨)_2020.05.25
 */
function reWriteClassAndId(count, type_clone, title_clone, answer_clone, answer_count_clone){
	//radio선택 부분 재설정
	type_clone.getElementsByTagName('input')[0].id = 'question_type_g_'+count;
	type_clone.getElementsByTagName('input')[0].name = 'question_type_'+count;
	
	type_clone.getElementsByTagName('input')[1].id = 'question_type_j_'+count;
	type_clone.getElementsByTagName('input')[1].name = 'question_type_'+count;
	
	type_clone.getElementsByTagName('input')[2].id = 'question_result_type_g_'+count;
	type_clone.getElementsByTagName('input')[2].name = 'question_result_type_'+count;
	
	type_clone.getEl
	ementsByTagName('input')[3].id = 'question_result_type_j_'+count;
	type_clone.getElementsByTagName('input')[3].name = 'question_result_type_'+count;
	
	type_clone.getElementsByTagName('input')[4].name = 'question_answer_direct_input_'+count;
	type_clone.getElementsByTagName('input')[5].name = 'question_answer_direct_input_'+count;
	type_clone.getElementsByTagName('input')[6].name = 'question_answer_direct_input_'+count;
	
	//제목 id, name값 재설정
	title_clone.id = 'question_'+count;
	title_clone.name = 'question_title_'+count;
	
	//답변 문항 id, name값 재설정
	answer_clone.getElementsByTagName('input')[0].id = 'question_answer_'+count+'_1';
	answer_clone.getElementsByTagName('input')[0].name = 'question_answer_'+count;
	
	answer_count_clone.children[1].id = 'answer_'+count+'_1';
	answer_count_clone.children[2].id = 'answer_'+count+'_2';
}

/*
 * 문항 번호 변경하는 함수(수정해야됨)_2020.05.22
 */
function changeHTML(count){
	console.log(count)
	let type_clone = document.getElementsByClassName('q_title')[count-1];//radio선택 부분
	let title_clone = document.getElementsByClassName('typing_box_cont')[count-1]; //제목 입력 부분
	let answer_clone = document.getElementsByClassName('question_satisfaction')[count-1];//답변 문항 부분
	let answer_count_clone = document.getElementsByClassName('answer_count')[count-1];//답변 문항 추가 부분
	
	//id, name값 재설정
	reWriteClassAndId(count, type_clone, title_clone, answer_clone, answer_count_clone);
	
	//항목 번호 재설정
	let span_clone = document.getElementsByName('span_quest_count');
	let span_index = span_clone.length;
	
	span_clone.forEach(function(entry,index){
		span_clone[index].innerText = (span_index + 1) - (span_index - index);
	});
}

/*
 * 항목 삭제하는 함수_2020.05.25
 */
function removeChildNodes(){
	let tr_length = document.getElementsByName('question_tr').length;
	
	for(let i = tr_length - 1; i >= tr_length - 3; i--){
		document.getElementsByName('question_tr')[i].remove();
	}
}

/*
 * 설문차수 선택하는 함수_2020.05.25
 */
function selectDegree(degree) {
	$("[name=degreeBtn]").removeClass();
	$("[name=degreeBtn]").addClass('btn');
	$("[name=degreeBtn]:eq(" + (degree - 1) + ")").addClass("on");
	$("#degree").val(degree);
}

let answer_count = 0;
/*
 * 답변 문항 추가하는 함수(수정해야됨)_2020.05.25
 */
function fnAnswerPm(add_num, id){
	let split_id = id.split('_')[1];
	console.log(add_num+', '+answer_count+', '+id);
	if(add_num === 1){
		answer_count++;
		let html = '<span id="answer_span_'+split_id+'_'+(answer_count)+'">'+answer_count+')</span>&nbsp;&nbsp;<input type="text" id="question_answer_'+split_id+'_'+answer_count+'" name="question_answer_'+split_id+'" value=""/>'
		$('#question_answer_'+split_id+'_'+(answer_count - 1)+'').after(html);
	}
	else if(add_num === -1){
		answer_count--;
		$('#question_answer_'+split_id+'_'+(answer_count + 1)+'').remove();
		$('#answer_span_'+split_id+'_'+(answer_count + 1)+'').remove();
	} 
}

/*
 * 설문조사 등록하는 함수(학생설문조사에 있던 코드임.)_2020.05.25
 */
function fnApply(){
	var degree = $("#degree").val();
	if( degree ==  null || degree == '' ) {
		alert("설문조사 차수를 선택하셔야 합니다.");
		return;
	}
	
	var $question = [];
	var $answer = [];

	$("[name=question_cont]").each(function(index){
		// 문제
		var question_map = new Map();
		index += 1;
		var answer = 0;
		var question = $("#question_" + index).val();
		var direct_input = $('[name=question_answer_direct_input_' + index + ']:checked').val();
		var type = $('[name=question_type_' + index + ']:checked').val();
		var result = $('[name=question_result_type_' + index + ']:checked').val();
		
		if (type == 1) { // 객관식인 경우
			answer = $("#question_answer_count_" + index).text();
		}

		// 문제 map에 해당 문제 정보 삽입
		$question.push({'q_no': index, 'question': question, 'answer': answer, 'direct_input': direct_input, 'result': result});

		// 답안
		var answer_list = [];

		for (var i = 1; i <= answer; i++) {
			var answer_value = $("#question_answer_" + index + "_" + i).val();
			answer_list.push({'q_no': index, 'a_no': i, 'answer': answer_value})
		}

		// 답안 map에 해당 답안 정보 삽입
		$answer.push(answer_list);
	});

	// List형태인 문제, 답안을 JSON형태로 변환하여 전송
	var params = {
		  question	    : JSON.stringify($question) 
		, answer	    : JSON.stringify($answer)
		, template_no   : '${params.template_no}'
		, template_name : $("#survey_name").val()
		, mode          : '${params.mode}'
		, degree        : $("#degree").val()
		, classify      : '${params.classify}'
	};

	$.ajax({
		  url		: '${pageContext.request.contextPath}/rad/curr/surveyFormSave.kh'
		, data		: params
		, dataType	: 'json'
		, type		: 'post'
		, success	: function(data, textStatus){
			if (data['result'] == 1 && '${params.mode}' == 'insert') {
				alert('저장되었습니다.');
				document.frm.action = "${pageContext.request.contextPath}/rad/curr/surveyFormList.kh?classify=${params.classify}";
				document.frm.submit();
			} else if (data['result'] == 1 && '${params.mode}' == 'update') {
				alert('수정되었습니다.');
				document.frm.action = "${pageContext.request.contextPath}/rad/curr/surveyForm.kh?classify=${params.classify}";
				document.frm.submit();
			} else {
				alert('오류가 발생했습니다. 다시 한 번 시도해주십시오.');
			}
		}
		, error		: function(jqXHR, textStatus, errorThrown){
			alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
		}
	});
}

function fnBack(){
	
}
</script>
</html>