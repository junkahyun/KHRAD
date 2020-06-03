<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.Date"%>
<%@page import="com.kh.utils.Utils"%>
<%@ taglib prefix="c" 		uri="/WEB-INF/tlds/c.tld" %> 
<%@ taglib prefix="fn" 		uri="/WEB-INF/tlds/fn.tld" %>
<%@ taglib prefix="fmt"		uri="/WEB-INF/tlds/fmt.tld" %>
<%@ taglib prefix="utils"	uri="/WEB-INF/tlds/utils.tld" %>
<%@ taglib prefix="functions"	uri="/WEB-INF/tlds/functions.tld" %>
<%
	//치환 변수 선언
	pageContext.setAttribute("cn", "\n"); //Enter
	pageContext.setAttribute("br", "<br>"); //br 태그
%>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/survey/surveyAppend.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/survey/surveyLocation.js"></script>
<style>
.jobsurvey .right_table{min-height: 0}

#require_tip{
	text-align: right;
	padding-top: 10px;
	color: #555555;
}

.require_input{
    margin-left: 1px;
    color: #ff554d;
 	font-weight: 600; 	   
}

.survey_tip{
	color: #ff554d;
	display: none;
}
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
	<caption>설문결과 페이지 수정</caption>
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
		<tr>
			<td id="require_tip_td" style="background-color: #ffffff; padding-top: 0px; padding-bottom: 10px;">
				<p id="require_tip"><span class="require_input">*</span> : 필수 입력사항 </p>
			</td>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="data" items="${qData}" varStatus="qvs">
		<!-- 인덱스 -->
		<c:set var="index" value="${qvs.count}"/>
		<!-- 학생답변 -->
		<c:forEach var="s_data" items="${list}">
			<c:if test="${params.stdt_no == s_data.stdt_no}">
				<c:set var="result" value="${fn:split(s_data.result,'¶')[index-1]}"/> 
			</c:if>
		</c:forEach>
		<tr>
			<td class="survey_question ${params.degree != '1' ? 'survey_question2' : ''}">${qvs.count}. ${data.question}<span class="require_input">*</span></td>
		</tr>
		<%-- 답변항목이 주관식인 경우 --%>
		<c:if test="${data.answer == 0}">
		<tr class="single" id="q${qvs.count}">
			<td class="survey_answer">
				<textarea id="q${qvs.count}_a_cont">${fn:replace(result,br,cn)}</textarea>
			</td>
		</tr>
		</c:if>
		<%-- 답변항목이 객관식인 경우 --%>
		<c:if test="${data.answer > 0}">
		<tr class="multiple" id="q${qvs.count}">
			<td class="survey_graph">
				<div class="graph_wrap">
					<div class="graph_list_edit" >
					<c:forEach var="aData" items="${data.aList}" varStatus="avs">
						<p>
						<input type="radio" id="q${qvs.count}_a${avs.count}" name="q${qvs.count}" class="multiple" data-text="${aData.answer}" 
						       value="${aData.a_no}" ${fn:contains(result, aData.a_no) == true ? 'checked' : ''}/>${aData.answer}
						<%-- 답변 마지막 항목이 기타인 경우  --%>
						<c:if test="${avs.last && data.direct_input == 1}">
							<c:set var="result_split" value="${fn:split(result,'§')}"/>  
							<input type="text" class="etc_text" id="q${qvs.count}_a_cont" value="${result_split[1]}" style="border:1px solid #ececec; height: 35px; width:90%; padding:0 5px; margin-left: 5px;"/>
						</c:if>
						</p>
					</c:forEach>
					</div>
				</div>
			<td>
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
					<span class="std_birth">(${res_no1} - ${fn:substring(res_no2, 0, 1)})</span>
					</span>
				</p>
				</th>
			</tr>
			<tr>
			<td id="require_tip_td" style="background-color: #ffffff; padding-top: 0px; padding-bottom: 10px;">
				<p id="require_tip"><span class="require_input">*</span> : 필수 입력사항 </p>
			</td>
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
						<td>900403-1</td>
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
	<%-- 학생 결과 데이터 --%>
	<c:forEach var="s_data" items="${list}">
	<c:if test="${params.stdt_no == s_data.stdt_no}">
	<c:set var="result" value="${fn:split(s_data.result,'¶')}"/> 
	</c:if>
	</c:forEach>
	<c:forEach var="data" items="${qData}" varStatus="qvs">
	<table cellpadding="0" cellspacing="0">
		<tbody>
			<tr>
				<td class="title_num" style="padding-left:0 !important;">${qvs.count + 1 }. ${qvs.count != 4 ? data.question : '취업과 관련하여 개인 상담 시 얘기 나누고 싶은 부분이 있다면 적어주세요.'} </td>
			</tr>
			<table class="scrolltable std_information ${qvs.count == 1 ? 'std_information2' : ''}" cellpadding="0" cellspacing="0">
				<caption>${qvs.count + 1}. ${data.question}</caption>
				<colgroup>
				   <col width="${data.question_form == 1 ? '135' :''}"/>
				</colgroup>
				<tbody>
					<%-- 학생결과 가져오기 위한 index --%>
					<c:set var="index" value="${last_index == '' ? '0' : last_index}"/>
					<%-- 카운트 세팅 --%>
					<c:set var="count" value="0"/>
					<c:if test="${data.question_form == '1'}">
					<c:if test="${qvs.count == 1}">
					<tr>
						<th style="width:120px;">구분</th>
						<th>내용</th>
						<th style="width: 19%;">능력</th>
					</tr>
					</c:if>
					<c:if test="${qvs.count == 3}">
					<tr>
						<th>평가요소</th>
						<th>평가기준</th>
						<th class="yes_txt" style="border-left:0">그렇다</th>
						<th class="no_txt" style="border-left:0">아니다</th>
					</tr>
					</c:if>
					<c:forEach var="sList" items="${data.sList}" varStatus="bvs" >
					
					<%-- 1, 3번 문제인 경우, (외국어,공인점수 항목 css를 맞춰주기 위해 공인점수 제외) (설문조사 기준 2, 4번)--%>
					<c:if test="${qvs.count != 2 && sList.question != '공인점수'}">
					<tr class="multiple" name="q${qvs.count}">
						<td rowspan="${sList.count == 0 ? '' : sList.count}" 
							style="${qvs.count == 3 ? 'text-align: center;' : ''}"
							class="skill_title">${sList.question}<c:if test="${sList.question != '외국어'}"><span class="require_input">*</span></c:if></td>
						<%-- 문제 depth가 1 이상인 경우 --%>
						<c:if test="${sList.count > 0}">
							<c:forEach var="bList" items="${sList.bList}">
							<c:forEach var="bList1" items="${bList}" varStatus="bvs1" begin="0" end="0">
								<c:set var="sum_count" value="${count+1}"/>
								<c:set var="count" value="${sum_count}"/>
								<c:set var="sum_index" value="${index+1}"/>
								<c:set var="index" value="${sum_index}"/>
								<td >${bList1.question}</td>
								<c:if test="${qvs.count == 1}">
								<td>
									<c:forEach var="aList" items="${bList1.aList}" varStatus="avs" >
										<input type="radio" id="q${bList1.q_no}_a${avs.count}" name="q${qvs.count}_${count}" 
										       value="${aList.a_no}" class="multiple"
										       ${fn:contains(result[index-1], aList.a_no) == true ? 'checked' : ''}>&nbsp;${aList.answer}&nbsp;&nbsp;
									</c:forEach>
								</td>
								</c:if>
								
								<c:if test="${qvs.count == 3}">
									<c:forEach var="aList" items="${bList1.aList}" varStatus="avs" >
									<c:if test="${fn:contains(result[index-1], aList.a_no) == true}">
									<c:set var="yes_no" value="${aList.a_no}"/>
									</c:if>
									</c:forEach>
									<td class="yes">
										<input type="radio" class="radio_btn" id="q${bList1.q_no}_a1" name="q${qvs.count}_${count}" value="1"
										       ${yes_no == 1 ? 'checked' : ''}>
									</td>
									<td class="no">
										<input type="radio" class="radio_btn" id="q${bList1.q_no}_a2" name="q${qvs.count}_${count}" value="2"
											   ${yes_no == 2 ? 'checked' : ''}>
									</td>
								</c:if>
							</c:forEach>
							</c:forEach>
						</c:if>
						<%-- 문제 depth가 1 이상이 아닌 경우 --%>
						<c:if test="${sList.count == 0 }">
						<c:if test="${sList.question != '외국어'}">
							<td colspan="2">
								<c:set var="sum_count" value="${count+1}"/>
								<c:set var="count" value="${sum_count}"/>
								<c:set var="sum_index" value="${index+1}"/>
								<c:set var="index" value="${sum_index}"/>
								<textarea id="q${qvs.count}_${count}" name="q${qvs.count}_${count}" class="single" placeholder="" cols="50" rows="2" style="width:550px; border-color:#ececec; float: left; height:38px;">${result[index-1] }</textarea>
								<span id="sol${qvs.count}_${count}" class="survey_tip" style="clear: both; text-align: left;">필수 입력 항목입니다.</span>
							</td>
						</c:if>
						<c:if test="${sList.question == '외국어'}">
							<c:set var="sum_count" value="${count+1}"/>
							<c:set var="count" value="${sum_count}"/>
							<c:set var="sum_index" value="${index+1}"/>
							<c:set var="index" value="${sum_index}"/>
							<td style="border-right:1px solid #ececec">
								<textarea id="q${qvs.count}_${count}" name="q${qvs.count}_${count}" class="single"
								          placeholder="외국어 자격증명 입력" cols="50" rows="2" style="width:500px; border-color:#ececec; height:38px;">${result[index-1] }</textarea>
							</td>
							<td>
								공인점수: <input type="text" value="${result[(index-1)+1] }" id="q${qvs.count}_${count+1}" name="q${qvs.count}" class="single"
								                           style=" outline:none; border:1px solid #ececec; width:54px; height:35px; ">
							</td>
							<c:set var="index" value="${sum_index+1}"/>
						</c:if>
						</c:if>
					</tr>
					
					<%-- 문제 depth가 1 이상인 경우 --%>
					<c:if test="${sList.count > 0}">
					<c:forEach var="bList" items="${sList.bList}">
					<c:forEach var="bList1" items="${bList}" varStatus="bvs1" begin="1" >
					<tr class="multiple" name="q${qvs.count}">
						<c:set var="sum_count" value="${count+1}"/>
						<c:set var="count" value="${sum_count}"/>
						<c:set var="sum_index" value="${index+1}"/>
						<c:set var="index" value="${sum_index}"/>
						<td >${bList1.question}</td>
						<c:if test="${qvs.count == 1}">
						<td>
							<c:forEach var="aList" items="${bList1.aList}" varStatus="avs" >
								<input type="radio" id="q${bList1.q_no}_a${avs.count}" name="q${qvs.count}_${count}" 
								       value="${aList.a_no}" class="multiple"
								       ${fn:contains(result[index-1], aList.a_no) == true ? 'checked' : ''}>&nbsp;${aList.answer}&nbsp;&nbsp;
							</c:forEach>
						</td>
						</c:if>
						
						<c:if test="${qvs.count == 3}">
							<c:forEach var="aList" items="${bList1.aList}" varStatus="avs" >
							<c:if test="${fn:contains(result[index-1], aList.a_no) == true}">
							<c:set var="yes_no" value="${aList.a_no}"/>
							</c:if>
							</c:forEach>
							<td class="yes">
								<input type="radio" class="radio_btn" id="q${bList1.q_no}_a1" name="q${qvs.count}_${count}" value="1"
								       ${yes_no == 1 ? 'checked' : ''}>
							</td>
							<td class="no">
								<input type="radio" class="radio_btn" id="q${bList1.q_no}_a2" name="q${qvs.count}_${count}" value="2"
									   ${yes_no == 2 ? 'checked' : ''}>
							</td>
						</c:if>
					</tr>
					</c:forEach>
					</c:forEach>
					</c:if>
					</c:if>
					
					<%-- 2번 문제인경우 (설문조사 기준 3차 설문조사 3번) --%>
					<c:if test="${qvs.count == 2}">
					<tr>
						<th scope="col">${sList.question}<span class="require_input">*</span></th>
						<%-- 답변 항목이 select인 경우 --%>
						<c:if test="${sList.direct_input == 2}">
						<td colspan="${sList.count}">
							<ul>
								<c:forEach var="bList" items="${sList.bList}">
								<c:forEach var="bList1" items="${bList}" varStatus="bvs1" >
								<c:set var="sum_count" value="${count+1}"/>
								<c:set var="count" value="${sum_count}"/>
								<c:set var="sum_index" value="${index+1}"/>
								<c:set var="index" value="${sum_index}"/>
								<li >
								<span>${fn:split(bList1.question,'_')[0]}&nbsp;&nbsp;</span> 
								
								<c:if test="${sList.question != '희망 근무 지역'}">
								<select id="q${qvs.count}_${count}" name="q${qvs.count}" class="s_multiple" data-attribute="${sList.question}">
								<c:forEach var="aList" items="${bList1.aList}" varStatus="avs" >
									<option value="${aList.a_no}"  
									        ${fn:contains(result[index-1], aList.a_no) == true ? 'selected' : ''}>${aList.answer}</option>
								</c:forEach>
								</select>
								</c:if>
								
								<c:if test="${sList.question == '희망 근무 지역'}">
									<c:set var="result_set" value="${result[index-1]}"/>
									<c:set var="result_split" value="${fn:split(result_set,'§')}"/>
									<select id="q${qvs.count}_${count}_1" name="location_select1" data-value="${result_split[0]}" class="s_multiple" onchange="fnChangeLocation(this.value, this.id);">
										<option value="">선택</option>
										<option value="전지역" ${result_split[0] == '전지역' ? 'selected' : ''}>전지역</option>
										<option value="서울특별시" ${result_split[0] == '서울특별시' ? 'selected' : ''}>서울특별시</option>
										<option value="부산광역시" ${result_split[0] == '부산광역시' ? 'selected' : ''}>부산광역시</option>
										<option value="대구광역시" ${result_split[0] == '대구광역시' ? 'selected' : ''}>대구광역시</option>
										<option value="인천광역시" ${result_split[0] == '인천광역시' ? 'selected' : ''}>인천광역시</option>
										<option value="광주광역시" ${result_split[0] == '광주광역시' ? 'selected' : ''}>광주광역시</option>
										<option value="대전광역시" ${result_split[0] == '대전광역시' ? 'selected' : ''}>대전광역시</option>
										<option value="울산광역시" ${result_split[0] == '울산광역시' ? 'selected' : ''}>울산광역시</option>
										<option value="세종특별자치시" ${result_split[0] == '세종특별자치시' ? 'selected' : ''}>세종특별자치시</option>
										<option value="경기도" ${result_split[0] == '경기도' ? 'selected' : ''}>경기도</option>
										<option value="강원도" ${result_split[0] == '강원도' ? 'selected': ''}>강원도</option>
										<option value="충청북도" ${result_split[0] == '충청북도' ? 'selected' : ''}>충청북도</option>
										<option value="충청남도" ${result_split[0] == '충청남도' ? 'selected' : ''}>충청남도</option>
										<option value="전라북도" ${result_split[0] == '전라북도' ? 'selected' : ''}>전라북도</option>
										<option value="전라남도" ${result_split[0] == '전라남도' ? 'selected' : ''}>전라남도</option>
										<option value="경상북도" ${result_split[0] == '경상북도' ? 'selected' : ''}>경상북도</option>
										<option value="경상남도" ${result_split[0] == '경상남도' ? 'selected' : ''}>경상남도</option>
										<option value="제주특별자치도" ${result_split[0] == '제주특별자치도' ? selected : ''}>제주특별자치도</option>
									</select>
									<select id="q${qvs.count}_${count}_2" name="location_select2" data-value="${result_split[1]}" class="s_multiple"  onchange="fnPutLocation(this.value, this.id);">
										<option value="">선택</option>
									</select><br/>
									<span id="tip${qvs.count}_${count}_2" class="survey_tip">필수 선택 항목입니다.</span>
									<input type="hidden" id="q${qvs.count}_${count}" name="q${qvs.count}" class="s_multiple" data-attribute="${sList.question}" value="${result[index-1]}"/>
									<input type="hidden" id="hidden_${qvs.count}_${count}_2" name="hidden_location_select2" class="s_multiple" value="${result_split[1]}"/>
								</c:if>
								&nbsp;&nbsp;${fn:split(bList1.question,'_')[1]}
								</li>
								</c:forEach>
								</c:forEach>
							</ul>
						</td>
						</c:if>
						<%-- 답변 항목이 객관식/주관식인 경우 --%>
						<c:if test="${sList.direct_input == 0}">
						<td name="q${qvs.count}">
							<c:set var="sum_count" value="${count+1}"/>
							<c:set var="count" value="${sum_count}"/>
							<c:set var="sum_index" value="${index+1}"/>
							<c:set var="index" value="${sum_index}"/>
							<c:forEach var="bList" items="${sList.bList}">
							<c:forEach var="bList1" items="${bList}" varStatus="bvs1" >
							<c:forEach var="aList" items="${bList1.aList}" varStatus="avs" >
								<input type="radio" id="q${bList1.q_no}_a${avs.count}" name="q${qvs.count}_${count}" class="multiple" data-attribute="${sList.question}" 
								       value="${aList.a_no}" ${fn:contains(result[index-1], aList.a_no) == true ? 'checked' : ''}>&nbsp;${aList.answer}&nbsp;&nbsp;
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
						<c:set var="sum_count" value="${index+1}"/>
						<c:set var="index" value="${sum_count}"/>
						<textarea id="q${qvs.count}_a_cont">${fn:replace(result[index-1],br,cn)}</textarea>
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
<input type="hidden" id="hope_area"/><%-- 지역 --%>
<input type="hidden" id="hope_pay"/><%-- 보수 --%>
<input type="hidden" id="hope_field"/><%-- 분야 --%>
<input type="hidden" id="hope_reside"/><%-- 거주형태 --%>
</c:if>
</div>
<!--//survey_form-->
<div class="btn">
	<div class="btnMd">
		<a class="btn_navy" onclick="javascript:window.location.reload(true);">취소</a>
		<a onclick="fnCheck();" class="btn_red" style="box-shadow: none">수정내용 저장</a>
	</div>
</div>
<!--//btn-->
<script>
/** 
 * 수정페이지 들어올때 스크롤 상단으로 이동하는 함수_2020.05.04
 */ 
$(document).ready(function(){
	$('html, body').scrollTop(0);
	fnSettingSelect('location_select1');
});

/*
 * 설문조사 3차인 경우 학생 취업 희망사항에 UPDATE되도록 하는 함수_2020.05.28
 */
function settingStdtHope(){
	let q2 = document.getElementsByName('q2');
	let value1 = '';
	let value2 = '';
	let value3 = '';
	q2.forEach(function(entry,index){
		let attr = q2[index].dataset.attribute;
		if(attr !== undefined){
			if(attr === '희망 근무 지역'){
				value1 += q2[index].value.split('§')[0]+'/';
			}
			else if(attr === '최소 희망 연봉'){
				value2 += $('#'+q2[index].id+' option:selected').text()+'/';
			}
			else if(attr === '희망분야 및 직종'){
				value3 += $('#'+q2[index].id+' option:selected').text()+'/';
			}
		}
	});
	$('#hope_area').val(value1);
	$('#hope_pay').val(value2);
	$('#hope_field').val(value3);
}

/*
 * select박스 selected 주는 함수_2020.05.22
 * 수정화면 로딩시 학생이 선택한 희망 근무지역 로딩 
 */
 
function fnSettingSelect(select_name){
	let location_select = document.getElementsByName(select_name);
	location_select.forEach(function(entry,index){
		let id = location_select[index].id;
		let value = location_select[index].dataset.value;
		if(select_name === 'location_select1'){
			fnChangeLocation(value, id);
		}
		else{
			$('#'+id+'').val(value).attr('selected','selected');
		}
	});
	
	if(select_name === 'location_select1'){
		fnSettingSelect('location_select2');
	}
}

/** 
 * 수정내용 저장하는 함수_2020.05.04
 */ 
function fnSubmit(result){
	var params = {
			  curr_no		: '${params.curr_no}'
			, degree		: '${params.degree}'
			, stdt_no       : '${params.stdt_no}'
			, classify      : 'E'
			, result		: result
			, hope_area     : $('#hope_area').val()
			, hope_pay      : $('#hope_pay').val()
			, hope_field    : $('#hope_field').val()
			, hope_reside   : $('#hope_reside').val()
		}
		
		$.ajax({
			url			: '${pageContext.request.contextPath}/rad/recruit/updateSurvey.kh'
			, data			: params
			, dataType		: 'json'
			, type			: 'post'
			, async         : false
			, success		: function(data, textStatus){
				if(data['result']=='1'){
					alert('수정이 완료되었습니다.');
					window.location.reload(true);
				} 
			}
			, error		: function(jqXHR, textStatus, errorThrown){
				alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
			}
		}); 
}


function alertMessage3(i, j){
	$("span#sol"+i+"_"+j+"").css("display", "block");
}

function alertMessage4(i, j){
	$("span#tip"+i+"_"+j+"_2").css("display", "block");
}

/** 
 * 학생 답변 내용에 구분자(¶) 추가해주는 함수_2020.05.04
 */ 
 
// 수정화면 변경내용 저장 
function fnCheck(){
	
	var result = "";
	var i = 1;
	var count = '${qData_length}'; //질문 갯수
	
	settingStdtHope();
	
	//surveyAppend.js 참고
	if('${params.degree}' === '3'){//3차인경우
		
		
		
		// 알림메세지 초기화
		$("span#sol11_16").css("display", "none");
	
		for(var j = 9; j <= 11; j++){
			$("span#tip2_"+j+"_2").css("display", "none");	
			
			
			
		}
		
		// 설무조사 3차 필수 입력 유효성검사 및 알림 표시 
		if('${template.curr_classify}' == 'S'){
			// 설문조사 3차 (보안) 일때 
			// 1번 보안솔루션 미선택시
			
			var sol_value =  $("#q1_16").val();
			if(sol_value.length == 0){
				alert("설문 3차 2번 보안솔루션 항목을 입력해주세요.");
				alertMessage3(1, 16);
				return;
			}			
		}
	
		// 설문조사 3차 3번 희망근무지역 미선택시 
		var zio_flag = 0;
					
		for(var j = 9; j <= 11; j++){
			var tip_value = $("#q2_"+j+"_2 option:selected").val();
			var tip_text = $("#q2_"+j+"_1 option:selected").text();
					
			if (tip_text != '전지역'){
				if(tip_value.length == 0){
					alertMessage4(2, j);
					zio_flag++;
				}
			}
			
			// 희망근무지역 2번째 드롭다운 onclick 안했을 경우 저장 
			var location2_id = "q2_"+j+"_2";
			fnPutLocation(tip_value, location2_id);
		}
		
		if (zio_flag != 0){
			alert("설문 3차 희망근무지역 항목을 모두 선택해주세요.");
			return;
		}			
		// 설무조사 3차 필수 입력 유효성검사 및 알림 표시 끝 
	
		const curr_classify = '${template.curr_classify}'
		result = appendTableResult(result, count, i, curr_classify);
	}
	else{
		result = appendResult(result, count, i);
	}
	
	if(result !== true && result !== undefined && result !== ''){
		fnSubmit(result);
	}
}

</script>