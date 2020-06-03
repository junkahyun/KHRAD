<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 		uri="/WEB-INF/tlds/c.tld" %> 
<%@ taglib prefix="fn" 		uri="/WEB-INF/tlds/fn.tld" %>
<%@ taglib prefix="fmt"		uri="/WEB-INF/tlds/fmt.tld" %>
<%@ taglib prefix="utils"	uri="/WEB-INF/tlds/utils.tld" %>
<%@ page import="com.kh.utils.Utils"%>

<%
	String cpage = Utils.nvl((String)request.getAttribute("cpage"), "1");
	int total = Integer.parseInt((String)request.getAttribute("total"));
	
	Calendar currentDate = Calendar.getInstance();
	currentDate.add(currentDate.DATE, -1);
	
	String strCD = currentDate.get(currentDate.YEAR)+""; 
	if(currentDate.get(currentDate.MONTH)<9) strCD+="0";
	strCD+=(currentDate.get(currentDate.MONTH)+1)+"";
	if(currentDate.get(currentDate.DATE)<10) strCD+="0";
	strCD+=currentDate.get(currentDate.DATE)+"";
	
	long time = System.currentTimeMillis();
	SimpleDateFormat dayTime = new SimpleDateFormat("yyyyMMddhhmmss");
	String deliver_time = dayTime.format(new Date(time));
%>

<style>
	#board_list td {cursor: auto;}
	#board_list .tichekcode_select {cursor: pointer;}
	
	.right .btn_wrap .btn {cursor: pointer;}
</style>

<div id="headtitle" style="width: 100%;">
    <div class="left">이벤트 신청 집계 게시판</div>
    <div class="right" style="width: 100%; float:none; clear: both; padding-top: 15px;">
        <div class="btn_wrap btn_branch" style="float:left;">
            <div class="btn off" onClick="doSortClick('branch', '')">
                <p>전체보기</p>
            </div>
            <div class="btn off" onClick="doSortClick('branch', '강남')">
                <p>강남</p>
            </div>
            <div class="btn off" onClick="doSortClick('branch', '종로')">
                <p>종로</p>
            </div>
            <div class="btn off" onClick="doSortClick('branch', '당산')">
                <p>당산</p>
            </div>
            <div class="btn off" onClick="doSortClick('branch', '이태원')">
                <p>이태원</p>
            </div>
        </div>
            
        
        <div class="btn_wrap btn_status" style="float: right;">
            <div class="btn off" onClick="doSortClick('status', '')">
                <p>전체보기</p>
            </div>
            <div class="btn off" onClick="doSortClick('status', 0)">
                <p>미발송</p>
            </div>
            <div class="btn off" onClick="doSortClick('status', 1)">
                <p>발송완료</p>
            </div>
        
        <%-- <form action="${pageContext.request.contextPath}/rad/main/event.kh" method="post" id="Frm2" name="Frm2" class="btn">	 --%>
            <utils:authority url="/rad/main/eventExcel.kh">
                <a href="javascript:fnExcel('searchFrm');" class="btn">리스트 엑셀 다운로드</a>
            </utils:authority>
			<utils:authority url="/rad/main/sms/sendGroupSms.kh">
                <a href="#" name="popup" class="remind_btn btn">리마인드 문자 전송</a>
            </utils:authority>
        <!-- </form> -->
        </div>
    </div>
</div>
<table cellpadding="0" cellspacing="0" id="board_list">
    <tr>
        <th width="2%">번호</th>
        <th width="5%;">이름</th>
        <th width="3%;">수강상황</th>
        <th width="7%;">전화번호</th>
        <th width="10%;">과정</th>
        <th width="8%;">기업설명회</th>
		<th width="8%;">직무 특강</th>
		<th width="8%;">트렌드 특강</th>
        <th width="8%;">기업솔루션 특강</th>
        <th width="8%;">선배와의대화</th>
        <th width="5%;">문자발송</th>
        <th width="5%;">재발송</th>
        <th width="6%;">발송일</th>
        <th width="4%;">발송자</th>
    </tr>
    <c:forEach var="data" items="${list}" varStatus="status">
    <c:set var="itemDate" value='${fn:substring(data.applydate, 0, 8) }'/>
    <tr>
        <td>${total - data.rnum + 1}</td>
        <td class="title" style="text-align: center;">${data.name}
            <c:if test="${currentDate le itemDate}"><span class="list_new"></span></c:if>
        </td>
        <td>${data.course}</td>
        <td>${data.mobile}</td>
        <td>${data.currname}</td>
        <td>
			<c:set var="programList" value="${fn:split(data.program, '/')}" />
            <c:forEach var="program" items="${programList}" varStatus="status">
				<c:if test="${fn:contains(program, '기업설명회 및 면접')}">
					${fn:split(program, ':')[1]}<br/>
				</c:if>
			</c:forEach>
        </td>
        <td>
			<c:forEach var="program" items="${programList}" varStatus="status">
				<c:if test="${fn:contains(program, '직무특강')}">
					${fn:split(program, ':')[1]}<br/>
				</c:if>
			</c:forEach>
        </td>
		<td>
			<c:forEach var="program" items="${programList}" varStatus="status">
				<c:if test="${fn:contains(program, '트렌드 특강')}">
					${fn:split(program, ':')[1]}<br/>
				</c:if>
			</c:forEach>
        </td>
        <td>
			<c:forEach var="program" items="${programList}" varStatus="status">
				<c:if test="${fn:contains(program, '기업솔루션 원데이 특강')}">
					${fn:split(program, ':')[1]}<br/>
				</c:if>
			</c:forEach>
        </td>
		<td>
			<c:forEach var="program" items="${programList}" varStatus="status">
				<c:if test="${fn:contains(program, '선배와의 대화')}">
					${fn:split(program, ':')[1]}<br/>
				</c:if>
			</c:forEach>
        </td>
        <c:if test="${data.status == 0}">
            <td onClick="fnSendSms('${data.no}', '${data.name}', '${data.mobile}', '${data.program}')">
                <div style="height: 35px; background: #58697b; cursor: pointer; color: #fff; line-height: 35px;">SMS발송</div>
            </td>
        </c:if>
        <c:if test="${data.status != 0}">
            <td>
            </td>
        </c:if>
        <%-- <c:if test="${data.status == 1 && data['기업설명회'] != ''}">
            <td onClick="fnSendSms2('${data.no}', '${data.name}', '${data.mobile}', '${fn:replace(data['기업설명회'], '"', '')}')">
                <div style="height: 35px; background: #58697b; cursor: pointer; color: #fff; line-height: 35px;">재발송</div>
            </td>
        </c:if>
        <c:if test="${data.status != 1 || data['기업설명회'] == ''}">
            <td>
            </td>
        </c:if> --%>
		<td></td>
        <td>
            <c:if test="${data.deliverdate != ''}">
                ${fn:substring(data.deliverdate, 0, 4) }. ${fn:substring(data.deliverdate, 4, 6) }. ${fn:substring(data.deliverdate, 6, 8) } ${fn:substring(data.deliverdate, 8, 10) }:${fn:substring(data.deliverdate, 10, 12) }:${fn:substring(data.deliverdate, 12, 14) }
            </c:if>
        </td>
        <td>${data.manager}</td>
    </tr>
    </c:forEach>
    <c:if test="${list==null or fn:length(list)==0 }">
        <tr><td colspan="15" class="not_found">게시글이 없습니다.</td></tr>
    </c:if>
</table>
<div id="board_nums">
    <%=Utils.getPage(total, cpage, 20, 20)%>
</div>

<form action="${pageContext.request.contextPath}/rad/main/event.kh" method="post" id="searchFrm" name="searchFrm">
    <div id="board_search">
        <div class="board_search_line" style="border: 0; text-align: center;">
            <input id="searchKey" name="searchKey" style="width: 105px;" value="NAME">
            <input type="text" id="searcValue" name="searchValue" size="35" onkeydown="fnSearchEnter();" style="text-align: center;" value="${params.searchValue }">
            <a href="javascript:fnSearch();" class="btn">검색</a>
            
        </div>
	</div>
	<input type="hidden" name="category" id="category" value="${params.category }">
    <input type="hidden" name="key" id="key" value="${data.key }">
    <input type="hidden" name="value" id="value" value="${data.value }">
    <input type="hidden" name="cpage" id="cpage" value="${params.cpage }">
    <input type="hidden" name="branch_sort" id="branch_sort" value="${params.branch_sort}">
    <input type="hidden" name="status_sort" id="status_sort" value="${params.status_sort}">
</form>

<c:if test="${params.idx=='MANAGER'}">
</div>
</c:if>
</div>

<div class="popup_wrap" id="popup_remind" name="popup">
	<div class="bg" onclick="fnClosePopup();"></div>
	<div class="popup" style="width: 450px;">
		<div class="popup_title" style="text-align:left;padding:0 30px;font-size:14px;">리마인드 문자전송 <a href="javascript:fnClosePopup();" class="pop_close_btn"></a></div>
		<div class="popup_content" style="border-bottom: 1px solid #f3f5f7;">
			<select id="program_category" style="width:250px; margin-bottom:10px;">
				<option value="인버스">[기업설명회]인버스</option>
				<option value="사이버다임">[기업설명회]사이버다임</option>
				<!-- <option value="보우테크">보우테크</option> -->
				<!-- <option value="이글루시큐리티">이글루시큐리티</option> -->
				<option value="싸이버원 ">[기업설명회]싸이버원 </option>
				<option value="파워젠">[기업설명회]파워젠</option>
				<option value="필라웨어">[기업설명회]필라웨어</option>
				<option value="이루인포">[기업설명회]이루인포</option>				
				<option value="[자바특강] 4차산업혁명 시대의 소프트웨어 개발자">[자바특강] 4차산업혁명 시대의 소프트웨어 개발자</option>
				<option value="[보안특강] 정보보안 파트별 직무의 이해">[보안특강] 정보보안 파트별 직무의 이해</option>
				<!-- <option value="시스템, 네트워크 보안 엔지니어">시스템, 네트워크 보안 엔지니어</option>
				<option value="모의해킹/악성코드 분석">모의해킹/악성코드 분석</option>
				<option value="주요전략기술 빅데이터">주요전략기술 빅데이터</option>
				<option value="주요전략기술 AI&전자정부">주요전략기술 AI&전자정부</option>
				<option value="투비소프트 넥사크로17">투비소프트 넥사크로17</option>
				<option value="씨큐아이 통합 네트워크">씨큐아이 통합 네트워크</option> -->
				<option value="[자바특강] 18년 수료 임승우선배">[자바특강] 18년 수료 임승우선배</option>
				<option value="[보안특강] 18년 수료 이석범선배">[보안특강] 18년 수료 이석범선배</option>
				<option value="[종일반/자바선배] 16년 수료 지형민선배">[종일반/자바선배] 16년 수료 지형민선배</option>
				<option value="[종일반/보안선배] 16년 수료 윤정훈 선배">[종일반/보안선배] 16년 수료 윤정훈 선배</option>
			</select>
			<textarea id="memo_write_mod" style="border: 1px solid #ececec; background: #f5f5f5; padding: 10px; width: 370px; height: 200px;"></textarea>
		</div>
		<div id="ok1" class="popup_content"> 
			<div class="popup_btns" style="padding: 0;">
				<div class="btnSm"><a href="javascript:sendGroupSms();" style="background:#ff626c;">전송</a></div>
				<div class="btnSm"><a href="javascript:fnClosePopup();" style="background:#2a2a4e;margin-left: 5px;">취소</a></div>
			</div>
		</div>
	</div>
</div>

<script>
	function fnExcel(frmid){
		document.searchFrm.action='${pageContext.request.contextPath}/rad/main/eventEmplExcel.kh';
		document.searchFrm.submit();
	}

	$(document).click(function(event) { 
		if(!$(event.target).closest('[name=popup]').length) {
			if($('.popup').is(":visible")) {
				$('.popup').hide();
			}
		}        
	});

	$(function(){
		mkSelectDB("searchKey", '성명', "NAME");
		
		var branch = "${params.branch_sort}"
		$(".btn_branch > .btn").each(function(){
			if (branch == null || branch == '') {
				$(this).removeClass("off");
				$(this).children().css({'color':'#fff'});
				return false;
			}
			
			if (branch == $(this).children("p").text()) {
				$(this).removeClass("off");
				$(this).children().css({'color':'#fff'});
			}
		});
		
		var status = "${params.status_sort}"
		$(".btn_status > .btn").each(function(){
			if (status == null || status == '') {
				$(this).removeClass("off");
				$(this).children().css({'color':'#fff'});
				return false;
			}
			
			if (status == (Number($(this).index()) - 1)) {
				$(this).removeClass("off");
				$(this).children().css({'color':'#fff'});
			}
		});
		
		// 리마인드 문자
		$(".remind_btn").click(function(event){
			const sms_text = "2019 하반기 채용박람회 행사안내입니다\n\n" + program_map["인버스"] + "시간을 꼭 지켜주시기 바랍니다.\n";
			$("#memo_write_mod").text(sms_text);
			$("#popup_remind").show();
			$(".popup").css({'left':(event.pageX / 2), 'top':(event.pageY / 2)});
		});

		$("#program_category").change(function(e){
			const program = $(e.target).val();
			const sms_text = "2019 하반기 채용박람회 행사안내입니다\n\n" + program_map[program] + "시간을 꼭 지켜주시기 바랍니다.\n";
			$("#memo_write_mod").text(sms_text);
		});
	});
	
	function doSortClick(category, value){
		if (category == 'branch') {
			$("#branch_sort").val(value);
		}
		else if (category == 'status'){
			$("#status_sort").val(value);
		}
		
		var f = document.getElementById('searchFrm');
		document.searchFrm.cpage.value = 1;
		document.searchFrm.action='${pageContext.request.contextPath}/rad/main/event.kh';
		f.submit();
	}
	
	function doPagingClick(page){
		document.getElementById("cpage").value = page;
		var f = document.getElementById('searchFrm');
		
		document.searchFrm.action='${pageContext.request.contextPath}/rad/main/event.kh';
		f.submit();
	}
	
	function fnSelect(no, name){
		$("#target_no").val(no);
		$(".mid_fir").text(name + " 님의 티켓번호");
	}
	
	function fnSearch(){
		var f = document.getElementById('searchFrm');
		document.searchFrm.action='${pageContext.request.contextPath}/rad/main/event.kh';
		f.submit();
	}
	
	function fnSearchEnter(){
		if(event.keyCode==13)
			fnSearch();
	}
	
	function statusSave(no, status){
		var	params	= {
			no				: no,
			deliver_time	: '${deliver_time}',
			status          : status,
			category        : 'EMPL'
		};
		
		$.ajax({
			url		: '${pageContext.request.contextPath}/rad/main/insertEventTicket.kh',
			dataType	: 'json',
			type		: 'post',
			data		: params,
			success		: function (data, textStatus) {
				alert('등록되었습니다');
				
				/* 상담신청 초기화 */
				var f = document.getElementById('searchFrm');
				document.searchFrm.action='${pageContext.request.contextPath}/rad/main/event.kh';
				f.submit();
			},
			error		: function (jqXHR, textStatus, errorThrown) {
				alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
			}
		});
	}
	

	
	
/////////////// SMS 보내기  START ///////////////////////////
	function fnSendSms(no, name, mobile, program){
		mobile = mobile.replace(/-/gi, "");
		
		var smsReceiver = "[";
			smsReceiver += "{"; 
			smsReceiver += "\"category\":\"이벤트\", ";
			smsReceiver += "\"recv_name\":\"" + name + "\", \"mobile\":\"" + mobile + "\"";
			smsReceiver += "}";
		    smsReceiver += "]";
		
		if( confirm(name + "씨에게 신청내역을 보내시겠습니까?") == false ) {
			return;
		}

		var message = '안녕하세요. ' + name + '님,\n';
			message += '2019 하반기 채용박람회 참여해 주셔서 감사합니다.채용박람회 신청확인 및 취소는 KH정보교육원 홈페이지 > 마이페이지에서 가능합니다. ';
			message += '\n\n';

		if (program.indexOf("파워젠") != -1) {
			message += powergen;
		}
		if (program.indexOf("싸이버원") != -1) {
			message += cyberone;
		}
		if (program.indexOf("인버스") != -1) {
		message += inverse;
		}
		if (program.indexOf("필라웨어") != -1) {
			message += feelaware;
		}
		if (program.indexOf("이루인포") != -1) {
			message += irooinfo;
		}
		if (program.indexOf("사이버다임") != -1) {
			message += cyber;
		}
		if (program.indexOf("보우테크") != -1) {
			message += bow;
		}
		if (program.indexOf("이글루시큐리티") != -1) {
			message += egloo;
		}		
		if (program.indexOf("시스템, 네트워크 보안 엔지니어_1부") != -1) {
			message += system_morning;
		}
		else if (program.indexOf("시스템, 네트워크 보안 엔지니어_2부") != -1) {
			message += system_after;
		}
		if (program.indexOf("정보보안 파트별 직무의 이해_1부") != -1) {
			message += manage_morning;
		}
		else if (program.indexOf("정보보안 파트별 직무의 이해_2부") != -1) {
			message += manage_after;
		}
		if (program.indexOf("4차산업혁명 시대의 소프트웨어 개발자_1부") != -1) {
			message += java_morning;
		}
		else if (program.indexOf("4차산업혁명 시대의 소프트웨어 개발자_2부") != -1) {
			message += java_after;
		}
		if (program.indexOf("모의해킹 악성코드 분석_1부") != -1) {
			message += hacking_morning;
		}
		else if (program.indexOf("모의해킹 악성코드 분석_2부") != -1) {
			message += hacking_after;
		}

		if (program.indexOf("주요전략기술 AI&전자정부_1부") != -1) {
			message += AI_morning;
		}
		else if (program.indexOf("주요전략기술 AI&전자정부_2부") != -1) {
			message += AI_after;
		}
		if (program.indexOf("주요전략기술 빅데이터_1부") != -1) {
			message += bigdata_morning;
		}
		else if (program.indexOf("주요전략기술 빅데이터_2부") != -1) {
			message += bigdata_after;
		}

		if (program.indexOf("씨큐아이 통합 네트워크_1부") != -1) {
			message += seeq_morning;
		}
		else if (program.indexOf("씨큐아이 통합 네트워크_2부") != -1) {
			message += seeq_after;
		}
		if (program.indexOf("투비소프트 넥사크로17_1부") != -1) {
			message += tobe_morning;
		}
		else if (program.indexOf("투비소프트 넥사크로17_2부") != -1) {
			message += tobe_after;
		}
		
		if (program.indexOf("이석범선배_1부") != -1) {
			message += eldersecurity_morning;
		}
		else if (program.indexOf("이석범선배_2부") != -1) {
			message += eldersecurity_after;
		}
		if (program.indexOf("임승우선배_1부") != -1) {
			message += elderjava_morning;
		}
		else if (program.indexOf("임승우선배_2부") != -1) {
			message += elderjava_after;
		}
		if (program.indexOf("지형민선배_종일") != -1) {
			message += elderjava_all;
		}
		if (program.indexOf("윤정훈선배_종일") != -1) {
			message += eldersecurity_all;
		}
		message += '시간을 꼭 지켜주시기 바랍니다.\n';
		
		var params = {
				mode			: "insert",
				category		: "이벤트",
				mobile			: "15449970",
				title		 	: "2019 하반기 채용박람회 안내 SMS입니다",
				message 		: message,
				smsReceiver     : smsReceiver
		};
		
		$.ajax({
				url		: '${pageContext.request.contextPath}/rad/main/sms/sendSmsOne.kh' 
			, data		: params
			, async		: true
			, type		: 'post'
			//, contentType: "application/x-www-form-urlencoded; charset=UTF-8"
			, success	: function(data, textStatus) {
				$('#popup_insert').fadeOut();
				alert("성공적으로 전송했습니다."); 

				statusSave(no, '1');
			}
			, error		: function(jqXHR, textStatus, errorThrown) {
				alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
			}
		});
	}

	// 리마인드 문자
	function sendGroupSms() {
		if( confirm("다수에게 메시지를 보내는 것은 시간이 소요 되는 작업입니다. (한명당 1초 정도의 지연시간이 필요합니다)\n진행 하시겠습니까 ?") == false ) {
			return;
		}

		var params = {
			mode			: "insert",
			category		: "이벤트",
			mobile			: "15449970",
			program         : $("#program_category").val(),
			program_message : $("#memo_write_mod").text(),
			title		 	: "2019 하반기 채용박람회 안내 SMS입니다",
			event_category  : '${params.category}'
		};

		$.ajax({
			url		: '${pageContext.request.contextPath}/rad/main/sms/sendEventEmplSms.kh'
			, data		: params
			, async		: true
			, type		: 'post'
			//, contentType: "application/x-www-form-urlencoded; charset=UTF-8"
			, success	: function(data, textStatus) {
				if( confirm("성공적으로 전송했습니다. 보낸 내역 화면으로 이동하시겠습니까 ?") == true ) { 
					location.href = '${pageContext.request.contextPath}/rad/main/sms/smsMultiple.kh';
				}
			}
			, error		: function(jqXHR, textStatus, errorThrown) {
				alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
			}
		});
		
		return false;
	}
	/////////////// SMS 보내기  END /////////////////////////

const inverse = '기업설명회 / 인버스\n'
			+ '일정: 2019.10.23(수) 13:30 ~ 13:50\n'
			+ '장소: 강남지원 2관 3층 세미나실\n\n';
 
const cyber = '기업설명회 / 사이버다임\n'
			+ '일정: 2019.10.30(수) 13:30 ~ 13:50\n'
			+ '장소: 강남지원 2관 3층 세미나실\n\n';

const bow = '기업설명회 / 보우테크\n'
			+ '일정: 2019.03.21(목) 10:00 ~ 10:20\n'
			+ '장소: 강남지원 2관 3층 세미나실\n\n';

const egloo = '기업설명회 / 이글루시큐리티\n'
			+ '일정: 2019.03.20(수) 10:00 ~ 10:20\n'
			+ '장소: 강남지원 2관 3층 세미나실\n\n';

const cyberone = '기업설명회 / 싸이버원 \n'
			+ '일정: 2019.10.22(화) 13:30 ~ 13:50\n'
			+ '장소: 강남지원 2관 3층 세미나실\n\n';
			
const powergen = '기업설명회 / 파워젠\n'
			+ '일정: 2019.10.21(월) 13:30 ~ 13:50\n'
			+ '장소: 강남지원 2관 3층 세미나실\n\n';
			
const feelaware = '기업설명회 / 필라웨어\n'
			+ '일정: 2019.10.24(목) 13:30 ~ 13:50\n'
			+ '장소: 강남지원 2관 3층 세미나실\n\n';

const irooinfo = '기업설명회 / 이루인포\n'
			+ '일정: 2019.10.25(금) 13:30 ~ 13:50\n'
			+ '장소: 강남지원 2관 3층 세미나실\n\n';
			
const system_morning = '직무특강 / [보안특강] 시스템·네트워크 보안 엔지니어_1부\n'
			+ '일정: 2019.03.19(화) 13:30 - 15:00\n'
			+ '장소: 강남지원 2관 3층 세미나실\n\n';

const system_after = '직무특강 / [보안특강] 시스템·네트워크 보안 엔지니어_2부\n'
			+ '일정: 2019.03.19(화) 15:30 - 17:00\n'
			+ '장소: 강남지원 2관 3층 세미나실\n\n';
	
const manage_morning = '직무특강 / [보안특강] 정보보안 파트별 직무의 이해_1부\n'
			+ '일정: 2019.10.29(화) 13:30 - 15:00\n'
			+ '장소: 강남지원 2관 3층 세미나실\n\n';

const manage_after = '직무특강 / [보안특강] 정보보안 파트별 직무의 이해_2부\n'
			+ '일정: 2019.10.29(화) 15:30 - 17:00\n'
			+ '장소: 강남지원 2관 3층 세미나실\n\n';
	
const java_morning = '직무특강 / [자바특강] 4차산업혁명 시대의 소프트웨어 개발자_1부\n'
			+ '일정: 2019.10.28(월) 13:30 - 15:00\n'
			+ '장소: 강남지원 2관 3층 세미나실\n\n';
	
const java_after = '직무특강 / [자바특강] 4차산업혁명 시대의 소프트웨어 개발자_2부\n'
			+ '일정: 2019.10.28(월) 15:30 - 17:00\n'
			+ '장소: 강남지원 2관 3층 세미나실\n\n';
	
const hacking_morning = '직무특강 / [보안특강]모의해킹/악성코드 분석_1부\n'
			+ '일정: 2019.04.12(금) 13:30 - 15:00\n'
			+ '장소: 강남지원 2관 3층 세미나실\n\n';
	
const hacking_after = '직무특강 / [보안특강]모의해킹/악성코드 분석_2부\n'
			+ '일정: 2019.04.12(금) 15:30 - 17:00\n'
			+ '장소: 강남지원 2관 3층 세미나실\n\n';

const AI_morning = '직무특강 / [특강] 2019년 주요 전략기술(AI＆전자정부프레임워크)_1부\n'
			+ '일정: 2019.03.26(화) 13:00 - 15:00\n'
			+ '장소: 강남지원 2관 3층 세미나실\n\n';
	
const AI_after = '직무특강 / [특강] 2019년 주요 전략기술(AI＆전자정부프레임워크)_2부\n'
			+ '일정: 2019.03.26(화) 15:30 - 17:30\n'
			+ '장소: 강남지원 2관 3층 세미나실\n\n';
	
const bigdata_morning = '직무특강 / [특강] 2019년 주요 전략기술(빅데이터&AI강의)_1부\n'
			+ '일정: 2019.04.08(월) 12:30 - 14:30\n'
			+ '장소: 강남지원 2관 3층 세미나실\n\n';
	
const bigdata_after = '직무특강 / [특강] 2019년 주요 전략기술(빅데이터&AI강의)_2부\n'
			+ '일정: 2019.04.08(월) 15:30 - 17:30\n'
			+ '장소: 강남지원 2관 3층 세미나실\n\n';

const seeq_morning = '직무특강 / [보안특강] I DAY 씨큐아이 통합네트워크 보안 (MF2)_1부\n'
			+ '일정: 2019.04.02(화) 12:00 - 15:00\n'
			+ '장소: 강남지원 2관 3층 세미나실\n\n';
	
const seeq_after = '직무특강 / [보안특강] I DAY 씨큐아이 통합네트워크 보안 (MF2)_2부\n'
			+ '일정: 2019.04.02(화) 15:30 - 18:30\n'
			+ '장소: 강남지원 2관 3층 세미나실\n\n';
	
const tobe_morning = '직무특강 / [자바특강] I DAY 투비소프트 넥사크로 17_1부\n'
			+ '일정: 2019.04.03(수) 12:00 - 15:00\n'
			+ '장소: 강남지원 2관 3층 세미나실\n\n';
	
const tobe_after = '직무특강 / [자바특강] I DAY 투비소프트 넥사크로 17_2부\n'
			+ '일정: 2019.04.03(수) 15:30 - 18:30\n'
			+ '장소: 강남지원 2관 3층 세미나실\n\n';

const eldersecurity_morning = '선배와의 대화 / [보안특강] 18년 수료 이석범선배_1부\n'
			+ '일정: 2019.11.1(금) 13:30 - 15:00\n'
			+ '장소: 강남지원 2관 3층 세미나실\n\n';
	
const eldersecurity_after = '선배와의 대화 / [보안특강] 18년 수료 이석범선배_2부\n'
			+ '일정: 2019.11.1(금) 15:30 - 17:00\n'
			+ '장소: 강남지원 2관 3층 세미나실\n\n';
	
const elderjava_morning = '선배와의 대화 / [자바특강] 18년 수료 임승우선배_1부\n'
			+ '일정: 2019.10.31(목) 13:30 - 15:00\n'
			+ '장소: 강남지원 2관 3층 세미나실\n\n';
	
const elderjava_after = '선배와의 대화 / [자바특강] 18년 수료 임승우선배_2부\n'
			+ '일정: 2019.10.31(목) 15:30 - 17:00\n'
			+ '장소: 강남지원 2관 3층 세미나실\n\n';

const elderjava_all = '선배와의 대화 / [종일반/자바선배] 16년 수료 지형민선배\n'
			+ '일정: 2019.10.24(목) 18:30 - 20:00\n'
			+ '장소: 강남지원 2관 3층 세미나실\n\n';
	
const eldersecurity_all = '선배와의 대화 / [종일반/보안선배] 16년 수료 윤정훈 선배\n'
			+ '일정: 2019.10.22(화) 18:30 - 20:00\n'
			+ '장소: 강남지원 2관 3층 세미나실\n\n';
			
const program_map = {
	"인버스": inverse,
	"사이버다임": cyber,
	"보우테크": bow,
	"이글루시큐리티": egloo,
	"싸이버원 ": cyberone,
	"[자바특강] 4차산업혁명 시대의 소프트웨어 개발자": java_morning + java_after,
	"[보안특강] 정보보안 파트별 직무의 이해": manage_morning + manage_after,
	"시스템, 네트워크 보안 엔지니어": system_morning + system_after,
	"모의해킹/악성코드 분석": hacking_morning + hacking_after,
	"주요전략기술 빅데이터": bigdata_morning + bigdata_after,
	"주요전략기술 AI&전자정부": AI_morning + AI_after,
	"투비소프트 넥사크로17": tobe_morning + tobe_after,
	"씨큐아이 통합 네트워크": seeq_morning + seeq_after,
	"[자바특강] 18년 수료 임승우선배": elderjava_morning + elderjava_after,
	"[보안특강] 18년 수료 이석범선배": eldersecurity_morning + eldersecurity_after,
	"이루인포"	: irooinfo,
	"파워젠"  : powergen,
	"필라웨어"	: feelaware,
	"[종일반/자바선배] 16년 수료 지형민선배" : elderjava_all,
	"[종일반/보안선배] 16년 수료 윤정훈 선배" : eldersecurity_all,
}

</script>
</html>