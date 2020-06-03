<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.Date"%>
<%@page import="com.kh.utils.Utils"%>
<%@ taglib prefix="c" 		uri="/WEB-INF/tlds/c.tld" %> 
<%@ taglib prefix="fn" 		uri="/WEB-INF/tlds/fn.tld" %>
<%@ taglib prefix="fmt"		uri="/WEB-INF/tlds/fmt.tld" %>
<%@ taglib prefix="utils"	uri="/WEB-INF/tlds/utils.tld" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/survey/suite.js?2020051400000"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/chart/suite.css?2020051400000"/>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/survey/surveyChart.js?2020051400000"/>

<style>
.jobsurvey .right_table{min-height: 0}
</style>
<div class="survey_form" >
<c:set var="year" value="${fn:substring(params.survey_date,0,4)}"/>
<c:set var="month" value="${fn:substring(params.survey_date,4,6)}"/>
<c:set var="day" value="${fn:substring(params.survey_date,6,8)}"/>
<c:set var="res_no1" value="${fn:split(data.res_no,'-')[0]}"/>
<c:set var="res_no2" value="${fn:split(data.res_no,'-')[1]}"/>
<!-- 3차가 아닌경우 -->
<c:if test="${params.degree != '3'}">
<table cellpadding="0" cellspacing="0">
	<caption>설문결과 페이지</caption>
	<colgroup>
	   <col width="" />
	</colgroup>
	<thead>
		<tr>
			<th scope="col">
				<p class="title">${template.survey_name}&nbsp;/&nbsp;
					<span class="survey_date">설문일 : ${year}. ${month}. ${day}</span>&nbsp;/&nbsp;
					<span class="std_name">${data.name}
						<span class="std_birth">(${res_no1} - ${fn:substring(res_no2, 0, 1)})</span>
					</span>
				</p>
			</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="data" items="${qData}" varStatus="qvs">
			<c:set var="index" value="${qvs.count}"/>
			<!-- 질문 -->
			<tr>
				<td class="survey_question ${params.degree != '1' ? 'survey_question2' : ''}">${qvs.count}. ${data.question}</td>
			</tr>
			
			<!-- 답변 -->
			<!-- 도넛그래프인 경우 -->
			<c:if test="${data.result == '4'}">
			<tr>
				<td class="survey_graph" style="padding-top:0 !important">
					<div class="graph_wrap">
						<div id="monthInterview" class="svg-container" >
							<div class="graph_chart_left" id="chartbox${qvs.count}" 
							     name="chartName" data-value="${data.q_no}_${qvs.count}_1_${data.result}"
							     style="width:420px; height:300px;top: -57px;left: 15px; position: absolute;">
							</div>
							<text class="timer" style="position: absolute;top: 76px;left: 91px;text-align: center;">
								<tspan class="people" style="font-size:13px; color:#999;">설문참가인원</tspan><br>
								<tspan class="people" style="font-weight:bold; font-size:20px;position: relative;top: 9px;color: #5c5c5c;">${fn:length(list)}</tspan>
							</text>
						</div>	
						<!--//div id="graph_chart_content"-->
						<div class="std_chart">
							<p class="color_box"><span class="blue color" style="background: #2e69eb;"></span></p>
							<p class="color_box"><span class="skyblue color" style="background: #75aaf6;"></span></p>
							<p class="color_box"><span class="lightgray color" style="background: #dee1e8;"></span></p>
							<p class="color_box"><span class="navy color" style="background: #2b2b4f;"></span></p>
							<p class="color_box"><span class="pink color" style="background: #ff626d;"></span></p>
						</div>
						<!--//std_chart-->
						<div class="std_chart_wrap">
							<div class="std_chart_list" id="chart_${as.count}">
								<c:forEach var="answer" items="${data.aList}" varStatus="as">
									<div class="std_chart_list">
										<c:forEach var="s_data" items="${list}" >
											<c:set var="result" value="${fn:split(s_data.result,'¶')[index-1]}"/>
											<c:set var="result_split" value="${fn:split(result,'§')}"/>  
											<c:if test="${as.count == result_split[0]}">
												<p class="${params.stdt_no == s_data.stdt_no ? 'selected' : ''}" >${s_data.name}</p>
											</c:if>
										</c:forEach>
										<p style="opacity: 0;">공백임</p>
									</div>
								</c:forEach>
							</div>
						</div>
						<!--//std_chart_wrap-->
					</div>
					<!--//graph_wrap-->
				</td>
				<!--//survey_graph-->
				<tr>
					<td>기타답변</td>
				</tr>
				<tr>
					<td class="comment_content"> 
					<c:forEach var="s_data" items="${list}" >
					<c:set var="result" value="${fn:split(s_data.result,'¶')[index-1]}"/>
					<c:set var="result_split" value="${fn:split(result,'§')}"/>
					<c:set var="no2" value="${fn:split(s_data.res_no,'-')[1]}"/>  
					<c:if test="${fn:contains(result, '§')}">
		                <p class="memo_txt ${params.stdt_no == s_data.stdt_no ? 'selected' :''}">
	                      	<span class="std_name">${s_data.name}
								<span class="std_birth">(${fn:split(s_data.res_no,'-')[0]} - ${fn:substring(no2, 0, 1)}) : </span>
							</span>
	                   		<span class="comment">${result_split[1]}
	                   		</span>
	                	</p>
                	 </c:if>
	            	</c:forEach>
	                </td>
	            </tr>
			</tr>
			</tr>
			</c:if>
			
			<%-- 도넛그래프가 아닌 경우 --%>
			<c:if test="${data.result != '4'}">
			<tr>
				<%-- 개별답변 --%>
				<c:if test="${params.degree != '2'}">
				<td class="survey_answer">
				<c:forEach var="s_data" items="${list}">
					<c:if test="${params.stdt_no == s_data.stdt_no}">
						<c:set var="result" value="${fn:split(s_data.result,'¶')[index-1]}"/> 
						${result}
					</c:if>
				</c:forEach>
				</td>
				</c:if>
				
				<%-- 전체답변 --%>
				<c:if test="${params.degree == '2'}">
					<td class="comment_content"> 
					<c:forEach var="s_data" items="${list}">
					<c:set var="result" value="${fn:split(s_data.result,'¶')[index-1]}"/> 
					<c:set var="no2" value="${fn:split(s_data.res_no,'-')[1]}"/>
	                <p class="memo_txt ${params.stdt_no == s_data.stdt_no ? 'selected' :''}">
                      	<span class="std_name">${s_data.name}
							<span class="std_birth">(${fn:split(s_data.res_no,'-')[0]} - ${fn:substring(no2, 0, 1)}) : </span>
						</span>
                   		<span class="comment">${result}
                   		</span>
                	</p>
                	</c:forEach>
                	</td>
				</c:if>
			</tr>
			</c:if>
		</c:forEach>
	</tbody>
</table>
</c:if>
<%-- 3차인 경우 --%>
<c:if test="${params.degree == '3'}">
	<table cellpadding="0" cellspacing="0">
		<thead>
			<tr>
				<th>
				<p class="title">${template.survey_name}&nbsp;/&nbsp;
					<span class="survey_date">설문일 : ${year}. ${month}. ${day}</span>&nbsp;/&nbsp;
					<span class="std_name">${data.name}
					<span class="std_birth">(${res_no1} - ${fn:substring(res_no2, 0, 1)})</span></span>
				</p>
				</th>
			</tr>
		</thead>
	</table>
	<%-- 1.인적사항--%>
	<table cellpadding="0" cellspacing="0">
		<tbody>
			<tr>
				<td class="title_num" style="padding-left:0 !important;">1. 인적사항</td>
			</tr>
			<table class="scrolltable std_information" cellpadding="0" cellspacing="0">
				<caption>1.인적사항테이블</caption>
				<colgroup>
				   <col width="135"/>
				</colgroup>
				<tbody>
					<tr>
						<th scope="col">학생명</th>
						<td>${data.name}</td>
						<th scope="col" class="border_none">생년월일</th>
						<td>${fn:split(data.res_no,'-')[0]}</td>
					</tr>
					<tr>
						<th scope="col">휴대폰</th>
						<td>${data.mobile}</td>
						<th scope="col" class="border_none">이메일</th>
						<td>${data.email}</td>
					</tr>
					<tr>
						<th>주소</th>
						<td colspan="3">${fn:replace(data.address,'_',' ')}</td>
					</tr>
					<tr>
						<th scope="col">학교</th>
						<td>${fn:split(data.comaca,'_')[0]}</td>
						<th scope="col" class="border_none">전공</th>
						<td>${fn:split(data.comaca,'_')[1]}</td>
					</tr>
					<tr>
						<th scope="col">최종학력</th>
						<td>${data.academic}</td>
						<th scope="col" class="border_none">구분/졸업년도</th>
						<td>${fn:split(data.comaca,'_')[2]}(${data.graduation_date})</td>
					</tr>
					<tr>
						<th scope="col">자격증</th>
						<td colspan="3">${data.license}</td>
					</tr>
				</tbody>
			</table>
		</tbody>
	</table>
	<%-- 학생데이터 --%>
	<c:forEach var="s_data" items="${list}">
	<c:if test="${params.stdt_no == s_data.stdt_no}">
	<c:set var="result" value="${fn:split(s_data.result,'¶')}"/> 
	</c:if>
	</c:forEach>
	<c:forEach var="data" items="${qData}" varStatus="qvs">
		<table cellpadding="0" cellspacing="0">
			<tbody>
				<tr>
					<td class="title_num" style="padding-left:0 !important;">${qvs.count + 1}. ${qvs.count != 4 ? data.question : '취업과 관련하여 개인 상담 시 얘기 나누고 싶은 부분이 있다면 적어주세요.'}</td>
					<c:if test="${qvs.count == 2}">
					<td>
						<button id="openBtn" onclick="popStatistics();">설문통계</button>
					</td>
					</c:if>
				</tr>
				<table class="scrolltable std_information ${qvs.count == 1 ? 'std_information2' : ''}" cellpadding="0" cellspacing="0">
					<caption>${qvs.count + 1}. ${data.question}</caption>
					<colgroup>
					   <col width="${data.question_form == 1 ? '135' :''}"/>
					</colgroup>
					<tbody>
						<%-- 학생결과 가져오기 위한 index --%>
						<c:set var="index" value="${last_index == '' ? '0' : last_index}"/>
						
						<%-- 표형식인 경우 --%>
						<c:if test="${data.question_form == 1}">
						<c:if test="${qvs.count == 1}">
						<tr>
							<th>구분</th>
							<th style="width: 500px; border-left:0;">내용</th>
							<th style="border-left:0;">능력</th>
						</tr>
						</c:if>
						<c:if test="${qvs.count == 3}">
						<tr>
							<th>평가요소</th>
							<th style="width: 500px; border-left:0">평가기준</th>
							<th class="yes_txt" style="border-left:0">그렇다</th>
							<th class="no_txt" style="border-left:0">아니다</th>
						</tr>
						</c:if>
						
						<c:forEach var="sList" items="${data.sList}" varStatus="bvs" >
						
						<%-- 1, 3번 문제인 경우, (외국어,공인점수 항목 css를 맞춰주기 위해 공인점수 제외) --%>
						<c:if test="${qvs.count != 2 && sList.question != '공인점수'}">
						<tr class="multiple" name="q${qvs.count}">
							<td rowspan="${sList.count == 0 ? '' : sList.count}" 
								style="${qvs.count == 3 ? 'text-align: center;' : ''}"
								class="skill_title">${sList.question}</td>
							<%-- 문제 depth가 1 이상인 경우 --%>
							<c:if test="${sList.count > 0}">
								<c:forEach var="bList" items="${sList.bList}">
								<c:forEach var="bList1" items="${bList}" varStatus="bvs1" begin="0" end="0">
									<c:set var="sum_index" value="${index+1}"/>
									<c:set var="index" value="${sum_index}"/>
									<td >${bList1.question}</td>
									<c:if test="${qvs.count == 1}">
										<td>
											<c:forEach var="aList" items="${bList1.aList}" varStatus="avs" >
											<c:if test="${fn:contains(result[index-1], aList.a_no)}">${aList.answer}</c:if>
											</c:forEach>
										</td>
									</c:if>
									
									<c:if test="${qvs.count == 3}">
										<c:forEach var="aList" items="${bList1.aList}" varStatus="avs" >
										<c:if test="${fn:contains(result[index-1], aList.a_no)}">
										<c:set var="yes_no" value="${aList.a_no}"/>
										</c:if>
										</c:forEach>
										<td class="yes">${yes_no == 1 ? 'O' : ''}</td>
										<td class="no">${yes_no == 2 ? 'O' : ''}</td>
									</c:if>
								</c:forEach>
								</c:forEach>
							</c:if>
							<%-- 문제 depth가 1 이상이 아닌 경우 --%>
							<c:if test="${sList.count == 0 }">
								<c:if test="${sList.question != '외국어'}">
								<td colspan="2">
									<c:set var="sum_index" value="${index+1}"/>
									<c:set var="index" value="${sum_index}"/>
									${result[index-1]}
								</td>
								</c:if>
								<c:if test="${sList.question == '외국어'}">
								<c:set var="sum_index" value="${index+1}"/>
								<c:set var="index" value="${sum_index}"/>
								<td colspan="2" >${result[index-1]}(공인점수 : ${result[(index-1)+1]})</td>
								<c:set var="index" value="${sum_index+1}"/>
								</c:if>
							</c:if>
						</tr>
						
						<%-- 문제 depth가 1 이상인 경우 --%>
						<c:if test="${sList.count > 0}">
							<c:forEach var="bList" items="${sList.bList}">
							<c:forEach var="bList1" items="${bList}" varStatus="bvs1" begin="1" >
							<c:set var="sum_index" value="${index+1}"/>
							<c:set var="index" value="${sum_index}"/>
							<tr class="multiple" name="q${qvs.count}">
								<td >${bList1.question}</td>
								<c:if test="${qvs.count == 1}">
								<td>
									<c:forEach var="aList" items="${bList1.aList}" varStatus="avs" >
									<c:if test="${fn:contains(result[index-1], aList.a_no)}">${aList.answer}</c:if>
									</c:forEach>
								</td>
								</c:if>
								
								<c:if test="${qvs.count == 3}">
									<c:forEach var="aList" items="${bList1.aList}" varStatus="avs" >
									<c:if test="${fn:contains(result[index-1], aList.a_no)}">
									<c:set var="yes_no" value="${aList.a_no}"/>
									</c:if>
									</c:forEach>
									<td class="yes">${yes_no == 1 ? 'O' : ''}</td>
									<td class="no">${yes_no == 2 ? 'O' : ''}</td>
								</c:if>
							</tr>
							</c:forEach>
							</c:forEach>
						</c:if>
						</c:if>
						
						<%-- 2번 문제인경우 --%>
						<c:if test="${qvs.count == 2}">
						<tr>
							<th scope="col">${sList.question}</th>
							<%-- 답변 항목이 select인 경우 --%>
							<c:if test="${sList.direct_input == 2}">
							<td colspan="${sList.count}">
								<c:forEach var="bList" items="${sList.bList}">
								<c:forEach var="bList1" items="${bList}" varStatus="bvs1" >
								<c:set var="sum_index" value="${index+1}"/>
								<c:set var="index" value="${sum_index}"/>
								<p>${fn:split(bList1.question,'_')[0]}
								
								<c:if test="${sList.question != '희망 근무 지역'}">
								<c:forEach var="aList" items="${bList1.aList}" varStatus="avs" >
									<c:if test="${fn:contains(result[index-1], aList.a_no)}"> ${aList.answer} </c:if>
								</c:forEach>
								</c:if>
								
								<c:if test="${sList.question == '희망 근무 지역'}">
									${fn:replace(result[index-1],'§',' ')}
								</c:if>
								
								${fn:split(bList1.question,'_')[1]}
								</p>
								</c:forEach>
								</c:forEach>
							</td>
							</c:if>
							<%-- 답변 항목이 객관식/주관식인 경우 --%>
							<c:if test="${sList.direct_input == 0}">
							<c:set var="sum_index" value="${index+1}"/>
							<c:set var="index" value="${sum_index}"/>
							<td name="q${qvs.count}">
								<c:forEach var="bList" items="${sList.bList}">
								<c:forEach var="bList1" items="${bList}" varStatus="bvs1" >
								<c:forEach var="aList" items="${bList1.aList}" varStatus="avs" >
								<c:if test="${fn:contains(result[index-1], aList.a_no)}">${aList.answer}</c:if>
								</c:forEach>
								</c:forEach>
								</c:forEach>
							</td>
							</c:if>
						</tr>
						</c:if>
						</c:forEach>
						</c:if>
						
						<%-- 표형식이 아닌 경우 --%>
						<c:if test="${data.question_form == 0}">
						
						<%-- 답변 항목이 객관식/주관식인 경우 --%>
						<c:if test="${data.direct_input == 0 }">
						<tr class="single" id="q${qvs.count}">
						<td class="txt_form">
							<c:set var="sum_index" value="${index+1}"/>
							<c:set var="index" value="${sum_index}"/>
							${result[index-1]}
						</td>
						</tr>
						</c:if>
						
						</c:if>
						<c:set var="last_index" value="${index}"/>
					</tbody>
				</table>
			</tbody>
		</table>
	</c:forEach>
</c:if>

</div>
<div class="btn">
	<div class="btnMd">
		<a class="btn_navy" onclick="fnPrint();">인쇄</a>
		<a class="btn_red" onclick="fnSurveySelect('${params.stdt_no}', '${params.degree}', '${params.curr_no}', 'update');" style="box-shadow: none">내용수정</a>
	</div>
</div>

<div id="survey_popup" class="modal" style="display: none;">
	<div class="survey_content">
	  	<div class="popup_title">
		    <span class="close" onclick="closePop();">&times;</span>
			<p class="title">취업관련 문항 설문통계</p>
		</div>
		<!--//div class="popup_title"-->
		<div class="graphTable">
			<div class="graph_wrap">
				<c:forEach var="data" items="${qData}" varStatus="qvs">
					<c:set var="pop_index" value="${last_pop_index == '' ? '0' : last_pop_index}"/>
				
					<c:forEach var="sList" items="${data.sList}" varStatus="bvs" >
					<c:if test="${sList.count > 0 }">
					<c:forEach var="bList" items="${sList.bList}">
						<c:forEach var="bList1" items="${bList}" varStatus="bvs1" >
						<c:set var="sum_pop_index" value="${pop_index+1}"/>
						<c:set var="pop_index" value="${sum_pop_index}"/>
						</c:forEach>
					</c:forEach>
					</c:if>
					
					<c:if test="${sList.count == 0 }">
						<c:set var="sum_pop_index" value="${pop_index+1}"/>
						<c:set var="pop_index" value="${sum_pop_index}"/>
					</c:if>
					
					<!-- select박스인 경우 -->
					<c:if test="${sList.direct_input == 2}">
					<div class="graph_box">
						<h2>${sList.question}</h2>
						<div class="box box${pop_index}" id="chartbox${pop_index}" name="chartName" data-value="${sList.q_no}1_${pop_index}_${sList.count}_${sList.result}">
						</div>
					</div>
					</c:if>
					</c:forEach>
					
					<c:set var="last_pop_index" value="${pop_index}"/>
				</c:forEach>
			</div>
			<!--//div class="graph_wrap"-->
		</div>
		<!--//div class="graphTable"-->
	 </div>
	 <!--//div class="survey_content"-->
</div>
<!--//설문통계팝업-->

<script>
jQuery(function(){
	/** 통계 데이터 setting하는 함수_2020.05.06 */
	//surveyChart.js 참고
	settingChart();
});

/*
 * 통계 데이터 setting하는 함수_2020.05.14
 */
function settingChart(){
	let chartName = document.getElementsByName('chartName');//차트 name
	let chart_arr = [];//차트 배열
	
	chartName.forEach(function(entry,index){
		chart_arr.push(chartName[index].dataset.value);//data-value값 가져오기
 	});
	
	let chartData = [];//통계 데이터 배열
	
	for(let i=0; i<chart_arr.length; i++){
		let arr_split = chart_arr[i].split('_');
		let q_no = arr_split[0];//문제번호
		let chart_index = arr_split[1];//차트 div id 번호(문제순서임)
		let answer_count = arr_split[2];//dept갯수
		let chart_type = setting_chart_type(arr_split[3]);//차트타입
		let stdt_index = (chart_index - answer_count);//학생 답변 인덱스
		let a_count = 0;//답변 갯수
		
		if(chart_type !== 'bar'){//원형그래프,도넛그래프
			<c:forEach var="aData" items="${aData}">
				if('${aData.q_no}' === q_no){
					a_count++;
					<c:forEach var="s_data" items="${list}">
						var result = '${s_data.result}'.split('¶')[stdt_index];
						var result_split = result.split('§')[0];
						if('${aData.answer}' === ''){//희망 근무지역인 경우
							if(chartData.length > 0){
								for(let i=0; i<chartData.length; i++){
									//chartData배열에 학생이 입력한 답변이 있는지 체크
									//없으면 -1 , 있으면 1
									let arr_push_status = (chartData.findIndex(chart => chart.text === result_split));
									if(arr_push_status === -1 && result_split !== chartData[i].text){
										chartData.push(pushData(''+(chartData.length+1)+'', result_split, 1, chart_type));
										break;
									}
									else if(arr_push_status !== -1 && result_split === chartData[i].text){
										chartData[i].value += 1;
										break;
									}
								}
							}
							else{
								chartData.push(pushData('1', result_split, 1, chart_type));
							}
						}
						else{
							if('${aData.a_no}' === result_split){
								if(chartData.length < a_count){
									chartData.push(pushData('${aData.a_no}', '${aData.answer}'.substr(0, 13), 1, chart_type));
									if('${aData.answer}'.length > 13){//답변항목 글자가 긴 경우 잘라서 두번째 줄에 보여줌(중복 코드 수정 예정)
										a_count++;
										chartData.push(pushData('11', '${aData.answer}'.substr(13,'${aData.answer}'.length), 0, chart_type));
									}
								}
								else{
									for(let i = 0; i < chartData.length; i++){
										if(chartData[i].id === '${aData.a_no}'){
											chartData[i].value += 1;
											break;
										}
									}
								}
							}
							else{
								if(chartData.length < a_count){
									chartData.push(pushData('${aData.a_no}', '${aData.answer}'.substr(0, 13), 0, chart_type));
									if('${aData.answer}'.length > 13){//답변항목 글자가 긴 경우 잘라서 두번째 줄에 보여줌(중복 코드 수정 예정)
										a_count++;
										chartData.push(pushData('11', '${aData.answer}'.substr(13,'${aData.answer}'.length), 0, chart_type));
									}
								}
							}
						}
					</c:forEach>
				} 
				
			</c:forEach>
		}
		else{//막대그래프
			let stdt_data = [];//학생 답변 데이터		
			let priority = 0;//순위 카운트
			let priority_arr = [];//
			let add = [];//
			let select_count = 0;
			
			/** 학생1,2,3항목 답변 */
			for(let i = stdt_index; i<chart_index; i++){
				priority++;
				<c:forEach var="aData" items="${aData}">
					if('${aData.q_no}' === q_no){
						<c:forEach var="s_data" items="${list}">
							var result = '${s_data.result}'.split('¶')[i];
							var result_split = result.split('§')[0];
							if('${aData.a_no}' === result_split){
								select_count++;
							}
						</c:forEach>
						add.push('${aData.a_no}'+':'+select_count);
					}
					select_count = 0;
				</c:forEach>
				priority_arr.push('§'+add+'§');
				add = [];
			}
			
			/** 답변 */
			<c:forEach var="aData" items="${aData}">
				if('${aData.q_no}' === q_no){
					var value = [];
					var value_split = '';
					for(let i = 0; i<priority_arr.length; i++){
						value_split = priority_arr[i].replaceAll('§','').split(',');
						for(let j = 0; j<value_split.length; j++){
							if(value_split[j].split(':')[0] === '${aData.a_no}'){
								value.push(value_split[j].split(':')[1]);
							}
						}
					}
					chartData.push(pushData('${aData.a_no}', '${aData.answer}', value, chart_type));
					value = [];
				} 
			</c:forEach>
			priority_arr = [];
			priority = 0;
		}
		getChart(chartData, chart_index, chart_type);
		chartData = [];
		stdt_data = [];
	}
	
}

/*
 * 설문통계 팝업으로 보는 함수_2020.05.13
 */
 function popStatistics(){
	$('#survey_popup').css({"display":"block"});
}

/*
 * 설문통계 팝업 닫는 함수_2020.05.13
 */
 function closePop(){
	 $('#survey_popup').css({"display":"none"});
}

 /*
  * 인쇄 이전 페이지 세팅하는 함수_2020.05.07
  */
function beforePrintSetting(){
	$("#tab1").hide(0);
	$(".tit").hide(0);
	$(".viewTop").hide(0); 
	$("div.subcomTap.boxtapWrap").hide(0);
	$(".btn").hide(0);
	$(".floatOpen").hide(0);
	$("#header").hide(0);
	$("#footer").hide(0);
	$("#openBtn").hide(0)
	$(".jobsurvey .right_table").css({"float" : "left", "padding": "0px 50px 0 30px"});
	$("table").css({"width" : "80%"});
	$(".std_chart").css({"float" : "left", "margin-top" : "70px"});
	$(".std_chart_wrap").css({"float" : "left"});   
}

 /*
  * 브라우저별 인쇄가능 여부 체크하는 함수_2020.05.07
  */
function browserCheck(){
	if(navigator.userAgent.indexOf('Trident/7.0;')>0){
		alert("인터넷 익스플로러 11버전에서는 스크립트를 이용한 인쇄 기능을 지원하지 않습니다. 우클릭>인쇄 미리보기 기능을 이용해주세요.");
		return true;
	}
	else{
		beforePrintSetting();//인쇄할 내용물 세팅
		if( navigator.userAgent.indexOf("MSIE") > 0 ){   
			var OLECMDID = 7;
			var PROMPT = 1;
			var WebBrowser = '<OBJECT ID="WebBrowser1" WIDTH=0 HEIGHT=0 CLASSID="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2"></OBJECT>';
			document.body.insertAdjacentHTML('beforeEnd', WebBrowser);
			WebBrowser1.ExecWB( OLECMDID, PROMPT);
		} else if( navigator.userAgent.indexOf("Chrome") > 0){
			window.print();
		}
		return false;
	}
}

 /*
  * 인쇄후 페이지 세팅하는 함수_2020.05.07
  */
function afterPrintSetting(){
	$("#tab1").show(0);
	$(".tit").show(0);
	$(".viewTop").show(0);
	$("div.subcomTap.boxtapWrap").show(0);
	$(".btn").show(0);
	$(".floatOpen").show(0);
	$("#header").show(0);
	$("#footer").show(0);
	$("#openBtn").show(0);
	$(".jobsurvey .right_table").css({"float" : "left", "padding": "30px 50px 0 30px"});
	$("table").css({"width" : "100%"});
	$(".std_chart").css({"float" : "right", "margin-top" : "0px"});
	$(".std_chart_wrap").css({"float" : "right"});
}

 /*
  * 인쇄기능 추가하는 함수_2020.05.06
  */
function fnPrint(){
	if(browserCheck() === false){
		setTimeout(function(){
			afterPrintSetting();
		}, 500);
	}
}
</script>