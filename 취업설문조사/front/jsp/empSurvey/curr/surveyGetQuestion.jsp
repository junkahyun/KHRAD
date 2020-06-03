<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 		uri="/WEB-INF/tlds/c.tld" %> 
<%@ taglib prefix="fn" 		uri="/WEB-INF/tlds/fn.tld" %>
<%@ taglib prefix="fmt"		uri="/WEB-INF/tlds/fmt.tld" %>

<c:forEach var="data" items="${data}" varStatus="qvs">
	<c:if test="${params.classify == 'E' && params.degree == '3'}">
	<div id="view_modify">
	<table cellpadding="0" cellspacing="0" class="view_form" style="width: 100%;">
		<tbody>
			<tr>
				<td class="title_num" style="padding-left:0 !important;">${qvs.count}. ${data.question}</td>
			</tr>
			<table class="view_form" cellpadding="0" cellspacing="0" style="width: 100%;">
				<caption>${qvs.count + 1}. ${data.question}</caption>
				<colgroup>
				   <col width="${data.question_form == 1 ? '135' :''}"/>
				</colgroup>
				<tbody>
					<c:set var="count" value="0"/>
					<c:if test="${data.question_form == '1'}">
					<c:if test="${qvs.count == 1}">
					<tr>
						<th >구분</th>
						<th>내용</th>
						<th >능력</th>
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
					<c:if test="${qvs.count != 2}">
					<tr class="multiple" name="q${qvs.count}">
						<td rowspan="${sList.count == 0 ? '' : sList.count}" 
							style="${qvs.count == 3 ? 'text-align: center;' : ''}"
							class="skill_title">${sList.question}</td>
						<%-- 문제 depth가 1 이상인 경우 --%>
						<c:if test="${sList.count > 0}">
							<c:forEach var="bList" items="${sList.bList}">
							<c:forEach var="bList1" items="${bList}" varStatus="bvs1" begin="0" end="0">
								<c:set var="sum_count" value="${count+1}"/>
								<c:set var="count" value="${sum_count}"/>
								<td >${bList1.question}</td>
								<c:if test="${qvs.count == 1}">
								<td>
									<c:forEach var="aList" items="${bList1.aList}" varStatus="avs" >
										&nbsp;${aList.answer}&nbsp;&nbsp;
									</c:forEach>
								</td>
								</c:if>
								
								<c:if test="${qvs.count == 3}">
									<td class="yes">
										그렇다
									</td>
									<td class="no">
										아니다
									</td>
								</c:if>
							</c:forEach>
							</c:forEach>
						</c:if>
						<%-- 문제 depth가 1 이상이 아닌 경우 --%>
						<c:if test="${sList.count == 0 }">
							<td colspan="2">
								<c:set var="sum_count" value="${count+1}"/>
								<c:set var="count" value="${sum_count}"/>
								학생답변
							</td>
						</c:if>
					</tr>
					
					<%-- 문제 depth가 1 이상인 경우 --%>
					<c:if test="${sList.count > 0}">
					<c:forEach var="bList" items="${sList.bList}">
					<c:forEach var="bList1" items="${bList}" varStatus="bvs1" begin="1" >
					<tr class="multiple" name="q${qvs.count}">
						<c:set var="sum_count" value="${count+1}"/>
						<c:set var="count" value="${sum_count}"/>
						<td >${bList1.question}</td>
						<c:if test="${qvs.count == 1}">
						<td>
							<c:forEach var="aList" items="${bList1.aList}" varStatus="avs" >
								&nbsp;${aList.answer}&nbsp;&nbsp;
							</c:forEach>
						</td>
						</c:if>
						
						<c:if test="${qvs.count == 3}">
							<td class="yes">
								그렇다
							</td>
							<td class="no">
								아니다
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
						<th scope="col">${sList.question}</th>
						<%-- 답변 항목이 select인 경우 --%>
						<c:if test="${sList.direct_input == 2}">
						<td colspan="${sList.count}">
							<ul>
								<c:forEach var="bList" items="${sList.bList}">
								<c:forEach var="bList1" items="${bList}" varStatus="bvs1" >
								<c:set var="sum_count" value="${count+1}"/>
								<c:set var="count" value="${sum_count}"/>
								<li >
								<span>${fn:split(bList1.question,'_')[0]}&nbsp;&nbsp;</span> 
								
								<c:if test="${sList.question != '희망 근무 지역'}">
								<select id="q${qvs.count}_${count}" name="q${qvs.count}" class="s_multiple" style="width: 10%;">
								<c:forEach var="aList" items="${bList1.aList}" varStatus="avs" >
									<option value="${aList.a_no}">${aList.answer}</option>
								</c:forEach>
								</select>
								</c:if>
								
								<c:if test="${sList.question == '희망 근무 지역'}">
									<select id="q${qvs.count}_${count}_1" name="location_select1" class="s_multiple" onchange="fnChangeLocation(this.value, this.id);" style="width: 10%;">
										<option value="">선택</option>
										<option value="전지역" >전지역</option>
										<option value="서울특별시" >서울특별시</option>
										<option value="부산광역시" >부산광역시</option>
										<option value="대구광역시" >대구광역시</option>
										<option value="인천광역시" >인천광역시</option>
										<option value="광주광역시" >광주광역시</option>
										<option value="대전광역시" >대전광역시</option>
										<option value="울산광역시" >울산광역시</option>
										<option value="서울특별자치시" >서울특별자치시</option>
										<option value="경기도" >경기도</option>
										<option value="강원도" >강원도</option>
										<option value="충청북도" >충청북도</option>
										<option value="충청남도" >충청남도</option>
										<option value="전라북도" >전라북도</option>
										<option value="전라남도" >전라남도</option>
										<option value="경상북도" >경상북도</option>
										<option value="경상남도" >경상남도</option>
										<option value="제주특별자치도" >제주특별자치도</option>
									</select>
									<select id="q${qvs.count}_${count}_2" name="location_select2"  class="s_multiple"  onchange="fnPutLocation(this.value, this.id);" style="width: 10%;">
										<option value="">선택</option>
									</select>
									<input type="hidden" id="q${qvs.count}_${count}" name="q${qvs.count}" class="s_multiple" value=""/>
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
							<c:forEach var="bList" items="${sList.bList}">
							<c:forEach var="bList1" items="${bList}" varStatus="bvs1" >
							<c:forEach var="aList" items="${bList1.aList}" varStatus="avs" >
								&nbsp;${aList.answer}&nbsp;&nbsp;
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
						<c:set var="sum_count" value="${count+1}"/>
						<c:set var="count" value="${sum_count}"/>
						<textarea id="q${qvs.count}_a_cont" style="width:100%; border: none;" disabled="disabled">학생답변</textarea>
					</td>
					</tr>
					</c:if>
					
					</c:if>
				</tbody>
			</table>
		</tbody>
	</table>
	</div>
	</c:if>
	
	<c:if test="${params.classify != 'E' || params.degree != '3'}">
    <li>
        <p>${qvs.count}. ${data.question}</p>
        <c:if test="${data.answer != '0'}">
            <ol>
                <c:forEach var="aList" items="${data.aList}" varStatus="avs">
                <li>(${avs.count}) ${aList.answer}</li>
                </c:forEach>
            </ol>
        </c:if>
        <c:if test="${data.answer == '0'}">
            개별입력
        </c:if>
    </li>
    </c:if>
</c:forEach>