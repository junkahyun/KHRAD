<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 		uri="/WEB-INF/tlds/c.tld" %> 
<%@ taglib prefix="fn" 		uri="/WEB-INF/tlds/fn.tld" %>
<%@ taglib prefix="fmt"		uri="/WEB-INF/tlds/fmt.tld" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>KH 정보교육원 RAD :: 학생설문조사</title>
<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/meta.jsp"/>
<script type="text/javascript">
jQuery(function(){
	fnCurrentSub('03', "03");
	
	<c:forEach var="s_data" items="${sData}">
	if('${s_data.curr_classify}' === 'J'){
		$('#java_radio').val('${s_data.no}');
	}
	else if('${s_data.curr_classify}' === 'S'){
		$('#security_radio').val('${s_data.no}');
	}
	</c:forEach>
	
	
	$("#survey_set_list").on('change', function(){
		const value = $(this).val();
		console.log(value);
		document.frm.preset_no.value = value;
		document.frm.action = "${pageContext.request.contextPath}/rad/curr/surveyModify.kh?classify=${params.classify}";
		document.frm.submit();
	});

	if ("${params.mode}" == 'update' && "${fn:length(data)}" > 0 && "${params.preset_no}" == "") {
		$("#survey_set_list option").each(function(){
			if ($(this).val() == '${params.template_no}') {
				$("#survey_name").val($(this).text().trim());
			}
		});

		$(".insert_only").click(function(){
			return false;
		});
		
		if('${params.curr_classify}' === 'J' || '${params.curr_classify}' === 'S'){
			getThreeDegree('${params.curr_classify}');
		}
	}
	
	<c:if test="${params.mode == 'insert' && fn:length(data) == 0}">
		$("#sq1_count .ar_table span").html("1");
	</c:if>
});

function getThreeDegree(classify){
	$('#survey_qna').hide();	
	let template_no = '';
	
	if('${params.mode}' === 'insert'){
		<c:forEach var="s_data" items="${sData}">
		if('${s_data.curr_classify}' === 'J' && classify === 'J'){
			$('#survey_name').val('${s_data.survey_name}');
			$('#curr_classify').val(classify)
			template_no = $('#java_radio').val();
		}
		else if('${s_data.curr_classify}' === 'S' && classify === 'S'){
			$('#survey_name').val('${s_data.survey_name}');
			$('#curr_classify').val(classify)
			template_no = $('#security_radio').val();
		}
		</c:forEach>
	}
	else{
		template_no = '${params.template_no}';
		$('#curr_classify').val(classify);
	}
	
	$('#view_modify').css({'display' : 'block'})
	$("#view_modify").load('${pageContext.request.contextPath}/rad/curr/getThreeDegree.kh',{template_no : template_no}); 
}

<c:if test="${params.mode == 'insert' || fn:length(data) == 0 || (params.preset_no != null && params.preset_no != '')}">
	function fnAnswerPm(id, no1){ // 해당 문제 답변 갯수 조절 함수
		var count = Number($("#question_answer_count_box_" + no1 + " span").html()); // 현재 답변 갯수
		if(id == 0) { // 답변을 1개 줄이는 경우
			if(count == 1 || count == "1") return; // 현재 답변이 1개밖에 없는 경우 
			count--; 
			$("#sq1_" + no1 + " .q_cont ul li:last-child").remove(); // 해당 문제 답변 오브젝트 중 가장 마지막 오브젝트를 제거
		} 
		else { // 답변을 1개 늘리는 경우
			count++; 
			var html = "<li>("+count+") <input type='text' id='question_answer_" + no1 + "_" + count + "'></li>"; // 답변 오브젝트 문자열로 생성
			$("#sq1_" + no1 + " .q_cont ul").append(html);
		}

		$("#question_answer_count_box_" + no1 + " span").html(count); // 최종적으로 답변 갯수 표기 변경
	}

	function fnQsChange(no1, id){ // 객관식, 주관식 변경 함수
		if(id == 0) { // 주관식으로 변경
			$("#question_answer_count_cont_" + no1).hide(0);
			$("#sq1_" + no1 + " .q_cont ul").hide(0);
		} 
		else { // 객관식으로 변경
			$("#question_answer_count_cont_" + no1).show(0);
			$("#sq1_" + no1 + " .q_cont ul").show(0);
		}
	}

	function fnQs(id, no){ // 문제 추가 및 삭제 함수
		var c = Number($("#sq1_count .ar_table span").html());
		
		if (id == 0) { // 문제를 줄이는 경우
			if(c < 2) return;
			if(!confirm('입력하신 마지막 문제의 내용이 지워집니다. 문제수를 줄이시겠습니까?')) return;
			
			$("#survey_qna > li:last-child").remove();
			c--;
		} 
		else { // 문제를 늘리는 경우
			var html="";
			c++;
			html+="<li id='sq1_"+c+"' name='question_cont'>";
			html+="<div class='q_title'>";
			html+=""+c+". ";
			html+="<label><input type='radio' id='question_type_g_"+c+"' name='question_type_"+c+"' value='1' onclick='fnQsChange("+c+", 1);' checked> 객관식</label>";
			html+="<label><input type='radio' id='question_type_j_"+c+"' name='question_type_"+c+"' value='0' onclick='fnQsChange("+c+", 0);'> 주관식</label>";
			html+="&nbsp;&nbsp; |&nbsp;&nbsp";
			html+="<label><input type='radio' id='question_type_result_g_"+c+"' name='question_result_type_"+c+"' value='0' checked> 그래프</label>";
			html+="<label><input type='radio' id='question_type_result_j_"+c+"' name='question_result_type_"+c+"' value='1' > 평점</label>";
			html+="<div id='question_answer_count_cont_"+c+"' class='sq_qg'>";
			html+="&nbsp;&nbsp; |&nbsp;&nbsp;";
			html+="<div id='question_answer_count_box_"+c+"' class='ar_table'>";
			html+="<a href='javascript:fnAnswerPm(0, "+c+")' class='remove'>-</a>";
			html+="<span id='question_answer_count_"+c+"'>1</span>";
			html+="<a href='javascript:fnAnswerPm(1, "+c+")' class='add'>+</a>";
			html+="</div>&nbsp;&nbsp; |&nbsp;&nbsp;";
			html+="<label><input type='radio' name='question_answer_direct_input_"+c+"' value='0' checked> 일반항목</label>";
			html+="<label><input type='radio' name='question_answer_direct_input_"+c+"' value='1'> 기타항목</label>";
			html+="<label><input type='radio' name='question_answer_direct_input_"+c+"' value='2'> 사유작성항목</label>";
			html+="</div>";
			html+="</div>";
			html+="<div class='q_cont'>";
			html+="<input type='text' id='question_"+c+"' value=''>";
			html+="<ul>";
			html+="<li>(1) <input type='text' id='question_answer_"+c+"_1' value=''></li>";
			html+="</ul>";
			html+="</div>";
			html+="</li>";
			$("#survey_qna > li:last-child").after(html);
		}
		$("#sq1_count .ar_table span").html(c);
	}
</c:if>
function fnOk(){ // 수정내역 전송
	var degree = $("#degree").val();
	if( degree ==  null || degree == '' ) {
		alert("설문조사 차수를 선택하셔야 합니다.");
		return;
	}
	let survey_name = $('#survey_name').val();
	if(survey_name === ''){
		alert("설문조사 이름을 작성해주세요.");
		return;
	}
	
	var $question = [];
	var $answer = [];
	var answer_count = 0;
	
	/*
		3차 설문조사 등록 추가_2020.05.26
	*/
	if('${params.classify}' === 'E' && $('#degree').val() === '3'){
		let table_question_cont = document.getElementsByName('table_question_cont');
		let answer_cont = document.getElementsByName('answer_cont');
		
		table_question_cont.forEach(function(entry,index){
			let question_data = table_question_cont[index].dataset.value;
			let split_question = question_data.split('_');
			let question_value = table_question_cont[index].value;
			
			let q_index = split_question[0];
			let question = question_value !== undefined ? question_value : split_question[1];
			let answer = split_question[2];
			let direct_input = split_question[3];
			let result = split_question[4];
			
			answer_cont.forEach(function(entry,index){
				let answer_data = answer_cont[index].dataset.value;
				let split_answer = answer_data.split('_');
				let a_value = answer_cont[index].value;
				
				let a_index = split_answer[0];
				let answer_value = a_value !== undefined ? a_value : split_answer[1];
				let a_no = split_answer[2];
				
				if(a_index === q_index){
					answer_count++;
					
					var answer_list = [];
					answer_list.push({'q_no': a_index, 'a_no': a_no, 'answer': answer_value});
					$answer.push(answer_list);
				}
				
			})
			
			$question.push({'q_no': q_index, 'question': question, 'answer': (answer_count === 0 ? answer : answer_count), 'direct_input': direct_input, 'question_form': q_index === '4' ? '0' : '1','result': result});
			answer_count = 0;
		});
		
	}
	else{
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
			$question.push({'q_no': index, 'question': question, 'answer': answer, 'direct_input': direct_input, 'question_form': '0', 'result': result});

			// 답안
			var answer_list = [];

			for (var i = 1; i <= answer; i++) {
				var answer_value = $("#question_answer_" + index + "_" + i).val();
				answer_list.push({'q_no': index, 'a_no': i, 'answer': answer_value})
			}

			// 답안 map에 해당 답안 정보 삽입
			$answer.push(answer_list);
		});
	}

	// List형태인 문제, 답안을 JSON형태로 변환하여 전송
	var params = {
		  question	    : JSON.stringify($question) 
		, answer	    : JSON.stringify($answer)
		, template_no   : '${params.template_no}'
		, template_name : $("#survey_name").val()
		, mode          : '${params.mode}'
		, degree        : $("#degree").val()
		, classify      : '${params.classify}'
		, curr_classify : $('#curr_classify').val()
	};

	$.ajax({
		  url		: '${pageContext.request.contextPath}/rad/curr/surveyFormSave.kh'
		, data		: params
		, dataType	: 'json'
		, type		: 'post'
		, success	: function(data, textStatus){
			if ('${params.mode}' == 'insert') {
				alert('저장되었습니다.');
				document.frm.action = "${pageContext.request.contextPath}/rad/curr/surveyFormList.kh?classify=${params.classify}";
				document.frm.submit();
			}
			/*else if (data['result'] == 1 && '${params.mode}' == 'update') {
				alert('수정되었습니다.');
				document.frm.action = "${pageContext.request.contextPath}/rad/curr/surveyForm.kh?classify=${params.classify}";
				document.frm.submit();
			} else {
				alert('오류가 발생했습니다. 다시 한 번 시도해주십시오.');
			} */
		}
		, error		: function(jqXHR, textStatus, errorThrown){
			alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
		}
	});
}

function fnBack() {
	document.frm.action = "${pageContext.request.contextPath}/rad/curr/surveyFormList.kh?classify=${params.classify}";
	document.frm.submit();
}

function selectDegree(degree) {
	$('input:radio[name=check_radio]').attr('checked',false)
	if('${params.classify}' === 'E'){
		if(degree === 3){
			$('.select_curr').css({'display':'block'});
		}
		else{
			$('#view_modify').empty();
			$('#survey_name').val('');
			$('#survey_qna').show();
			$('#curr_classify').val('D')
			$('#view_modify').css({'display':'none'});
			$('.select_curr').css({'display':'none'});
		}
	}
	$("[name=degreeBtn]").addClass("off");
	$("[name=degreeBtn]:eq(" + (degree - 1) + ")").removeClass("off");
	$("#degree").val(degree);
}
</script>
<style type="text/css">
	.ar_table span { display: inline-block; width: 100%; }
	.search_cal { margin-top: -296px; }
	.btns_center a { height: 31px; line-height: 31px; }
	#start_date { width: 68px; }
	a.insert_only { ${params.mode == 'update' && fn:length(data) > 0 && (params.preset_no == null || params.preset_no == "") ? 'display: none !important;' : ''} }
</style>
</head>
<body>
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
			<div class="survey_btns">
				<c:if test="${params.mode == 'insert'}">
					<a href="javascript:void(0);" name="degreeBtn" class="btn off" onClick="selectDegree(1);">1차</a>
					<a href="javascript:void(0);" name="degreeBtn" class="btn off" onClick="selectDegree(2);">2차</a>
					<a href="javascript:void(0);" name="degreeBtn" class="btn off" onClick="selectDegree(3);">3차</a>
					<c:if test="${params.classify == 'E'}">
					<a href="javascript:void(0);" name="degreeBtn" class="btn off" onClick="selectDegree(4);">4차</a>
					</c:if>
					<input type="hidden" id="degree" name="degree" value="" />
				</c:if>
				<c:if test="${params.mode == 'update'}">
					<span class="btn ${params.degree != '1'?'off':''}">1차</span>
					<span class="btn ${params.degree != '2'?'off':''}">2차</span>
					<span class="btn ${params.degree != '3'?'off':''}">3차</span>
					<c:if test="${params.classify == 'E'}">
					<span class="btn ${params.degree != '4'?'off':''}">4차</span>
					</c:if>
				</c:if>
				<select id="survey_set_list" style="width: 300px;">
					<c:if test="${params.preset_no == null || params.preset_no == ''}">
					<option value="">설문조사 프리셋</option>
					</c:if>
					<c:forEach var="data" items="${sData}">
						<c:if test="${data.curr_classify == 'D'}">
						<option value="${data.no}" ${params.preset_no == data.no ? 'selected' : ''}>${data.survey_name} (${data.degree}차)</option>
						</c:if>
					</c:forEach>
				</select>
			</div>
			<div class="select_curr" style="display: none;">
				<label>
					<input type="radio" onclick="getThreeDegree('J');" id="java_radio" name="check_radio" value="java_box" class="input_checked">&nbsp;자바
				</label>
				<label>
					<input type="radio" onclick="getThreeDegree('S');" id="security_radio" name="check_radio" value="security_box" class="input_checked">&nbsp;보안
				</label>
			</div>
			<div id="sq1_count" class="sq_count">
				<span>문제수 :</span>
				<div class="ar_table">
					<a href="javascript:fnQs(0, 1);" class="remove insert_only">-</a>
						<span>${fn:length(data)}</span>
					<a href="javascript:fnQs(1, 1);" class="add insert_only">+</a>
				</div>
				 | 
				<span>설문조사이름 :</span>
				<input type="text" id="survey_name" value="${params.survey_name}" style="width: 500px;"/>
			</div>
		</div>

		<div id="view_modify" style="display: none">
		
		</div>
		<ul id="survey_qna" class="survey_qna" style="display: block;">
			<c:forEach var="data" items="${data}" varStatus="vs"> <%-- 문제 및 답변 오브젝트 생성 시작 --%>
				<li id="sq1_${vs.count}" name="question_cont"> <%-- 문제 컨테이너 --%>
					<div class="q_title">
						<%-- 문제번호 --%>
						${vs.count}. 
						<%-- 문제타입 --%>
						<label>
							<input type="radio" 
								id="question_type_g_${vs.count}" 
								name="question_type_${vs.count}" 
								value="1" 
								onclick="fnQsChange(${vs.count}, 1);" 
								${data.answer != '0'? 'checked':''}
								class="insert_only"
								> 
							객관식
						</label>
						<label>
							<input type="radio" 
								id="question_type_j_${vs.count}"
								name="question_type_${vs.count}" 
								value="0" 
								onclick="fnQsChange(${vs.count}, 0);" 
								${data.answer == '0'? 'checked':''}
								class="insert_only"
								> 
							주관식
						</label>
						&nbsp;&nbsp; |&nbsp;&nbsp;
						<%-- 결과타입 --%>
						<label>
							<input type="radio" 
								id="question_result_type_g_${vs.count}" 
								name="question_result_type_${vs.count}" 
								value="${data.result != '' ? data.result : 0}" 
								${data.result == '0' || data.result == '4'? 'checked':''}
								class="insert_only"
								> 
							그래프
						</label>
						<label>
							<input type="radio" 
								id="question_result_type_j_${vs.count}" 
								name="question_result_type_${vs.count}" 
								value="1" 
								${data.result == '1'? 'checked':''}
								class="insert_only"
								> 
							평점
						</label>
						<%-- 문제 답안갯수 컨테이너 (주관식일시 hide) --%>
						<div id="question_answer_count_cont_${vs.count}" class="sq_qg" ${data.answer == '0'? " style='display: none;'":""}>
							&nbsp;&nbsp; |&nbsp;&nbsp;
							<div id="question_answer_count_box_${vs.count}" class="ar_table"> <%-- 답안 갯수 조절 --%>
								<a href="javascript:fnAnswerPm(0, ${vs.count})" class="remove insert_only">-</a>
								<span id="question_answer_count_${vs.count}">${data.answer}</span>
								<a href="javascript:fnAnswerPm(1, ${vs.count})" class="add insert_only">+</a>
							</div>&nbsp;&nbsp; |&nbsp;&nbsp;
							<%-- 기타란 추가여부. --%>
							<label>
								<input 
									type="radio" 
									name='question_answer_direct_input_${vs.count}' 
									value='0' 
									${data.direct_input == '0'? 'checked':''}
									class="insert_only"
									> 
								일반항목
							</label>
							<label>
								<input 
									type="radio" 
									name='question_answer_direct_input_${vs.count}'
									value='1' 
									${data.direct_input == '1'? 'checked':''}
									class="insert_only"
									> 
								기타항목
							</label>
							<label>
								<input 
									type="radio" 
									name='question_answer_direct_input_${vs.count}' 
									value='2' 
									${data.direct_input == '2'? 'checked':''}
									class="insert_only"
									> 
								사유작성항목
							</label>
						</div>
					</div>
					<%-- 문제, 답안 내용 컨테이너 --%>
					<div class="q_cont">
						<input type="text" id="question_${vs.count}" value="${data.question}"> <%-- 문제 내용 --%>
						<ul ${data.answer == '0'? " style='display: none;'":""}>
							<c:forEach var="aList" items="${data.aList}" varStatus="vas">
							<li>(${vas.count}) <input type='text' id='question_answer_${vs.count}_${vas.count}' value="${aList.answer}"></li> <%-- 답안 내용 --%>
							</c:forEach>
						</ul>
					</div>
				</li>
			</c:forEach>
			
			<c:if test="${params.mode == 'insert' && fn:length(data) == 0}">
				<li id="sq1_1" name="question_cont"> <%-- 문제 컨테이너 --%>
					<div class="q_title">
						<%-- 문제번호 --%>
						1. 
						<%-- 문제타입 --%>
						<label><input type="radio" id="question_type_g_1" name="question_type_1" value="1" onclick="fnQsChange(1, 1);" checked> 객관식</label>
						<label><input type="radio" id="question_type_j_1" name="question_type_1" value="0" onclick="fnQsChange(1, 0);" > 주관식</label>
						&nbsp;&nbsp; |&nbsp;&nbsp;
						<%-- 결과타입 --%>
						<label><input type="radio" id="question_result_type_g_1" name="question_result_type_1" value="0" checked> 그래프</label>
						<label><input type="radio" id="question_result_type_j_1" name="question_result_type_1" value="1" > 평점</label>

						<%-- 문제 답안갯수 컨테이너 (주관식일시 hide) --%>
						<div id="question_answer_count_cont_1" class="sq_qg">
							&nbsp;&nbsp; |&nbsp;&nbsp;
							<div id="question_answer_count_box_1" class="ar_table"> <%-- 답안 갯수 조절 --%>
								<a href="javascript:fnAnswerPm(0, 1)" class="remove">-</a>
								<span id="question_answer_count_1">1</span>
								<a href="javascript:fnAnswerPm(1, 1)" class="add">+</a>
							</div>&nbsp;&nbsp; |&nbsp;&nbsp;
							<%-- 기타란 추가여부. --%>
							<label><input type="radio" name='question_answer_direct_input_1' value='0' checked> 일반항목</label>
							<label><input type="radio" name='question_answer_direct_input_1' value='1'> 기타항목</label>
							<label><input type="radio" name='question_answer_direct_input_1' value='2'> 사유작성항목</label>
						</div>
					</div>
					<%-- 문제, 답안 내용 컨테이너 --%>
					<div class="q_cont">
						<input type='text' id='question_1' value=''>
						<ul>
							<li>(1) <input type='text' id='question_answer_1_1' value=""></li> <%-- 답안 내용 --%>
						</ul>
					</div>
				</li>
			</c:if>
		</ul>

		<div class="btns_center">
			<c:if test="${params.mode == 'insert' || fn:length(data) == 0 || (params.preset_no != null && params.preset_no != '')}">
			<a href="javascript:fnOk();" class="btn">등록</a>
			</c:if>
			<a href="javascript:fnBack();" class="btn">취소</a>
		</div>
	</div>
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/footer.jsp"/>

	<form id="frm" name="frm" action="${pageContext.request.contextPath}/rad/curr/surveyFormList.kh" method="post">
		<input type="hidden" id="cpage" name="cpage" value="${params.cpage}" />
		<input type="hidden" id="mode" name="mode" value="${params.mode}" />
		<input type="hidden" id="template_no" name="template_no" value="${params.template_no}" />
		<input type="hidden" id="preset_no" name="preset_no" value="${params.preset_no}" />
		<input type="hidden" id="survey_name" name="survey_name" value="${params.survey_name}" />
		<input type="hidden" id="curr_classify" name="curr_classify" value="D" />
	</form>
</body>
</html>