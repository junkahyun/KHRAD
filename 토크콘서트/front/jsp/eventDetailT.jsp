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
<c:set var="currentDate" value="<%=strCD %>"/>
<c:set var="deliver_time" value="<%= deliver_time %>" />

<style>
	#board_list td {cursor: auto;}
	#board_list .tichekcode_select {cursor: pointer;}
	
	.right .btn_wrap .btn {cursor: pointer;}
	
	.popup{position: absolute; width: 300px; top: 50%; left: 50%; display:none;}
	.popup .popup_top{float: left; width: 300px; height: 53px; text-align: center; background: #80a8cc;}
	.popup .popup_top p{color: #fff; line-height: 53px; font-size: 15px; letter-spacing: -0.5px;}
	.popup .popup_mid{float: left; width: 300px; text-align: center; border-bottom: 1px solid #ececec; background: #fff;}
	.popup .popup_mid .mid_fir{margin-top: 17px; font-size: 14px; letter-spacing: -1px; font-weight: bold; color: #242424;}
	.popup .popup_mid .mid_las{margin-top: 10px; margin-bottom: 15px; letter-spacing: -0.7px; font-size: 13px;}
	.popup .popup_mid .mid_chk{margin-bottom: 15px; margin-left: 32px; text-align: left;}
	.popup .popup_btn_box{float: left; width: 300px; height: 85px; background: #fff;}
	.popup .popup_btn_box .popup_btn_wrap{width: 123px; height: 35px; margin: 25px auto 0;}
	.popup .popup_btn_box .popup_btn_wrap .popup_btn{float: left; width: 59px; height: 35px; background: #58697b; text-align: center; cursor: pointer;}
	.popup .popup_btn_box .popup_btn_wrap .popup_btn p{color: #fff; line-height: 35px;}
</style>

<div id="headtitle" style="width: 100%;">
    <div class="left">이벤트 신청 집계 게시판</div>
    <div class="right" style="width: 100%; float:none; clear: both; padding-top: 15px;">
        <div class="btn_wrap btn_branch" style="float:left;">
            <div class="btn off" name="btn_branch" onClick="doSortClick('branch', '')">
                <p>전체보기</p>
            </div>
            <div class="btn off" name="btn_branch" data-branch="2" onClick="doSortClick('branch', '2')">
                <p>강남</p>
            </div>
            <div class="btn off" name="btn_branch" data-branch="6" onClick="doSortClick('branch', '6')">
                <p>종로</p>
            </div>
            <div class="btn off" name="btn_branch" data-branch="10" onClick="doSortClick('branch', '10')">
                <p>당산</p>
            </div>
            <div class="btn off" name="btn_branch" data-branch="0" onClick="doSortClick('branch', '0')">
                <p>기타</p>
            </div>
            &nbsp;|&nbsp;
            <div class="btn off" name="btn_stdtForm" onClick="doSortClick('stdtForm', '')">
                <p>전체</p>
            </div>
            <div class="btn off" name="btn_stdtForm" data-stdtform="S" onClick="doSortClick('stdtForm', 'S')">
                <p>수강생</p>
            </div>
            <div class="btn off" name="btn_stdtForm" data-stdtform="G" onClick="doSortClick('stdtForm', 'G')">
                <p>수료생</p>
            </div>
            <div class="btn off" name="btn_stdtForm" data-stdtform="N" onClick="doSortClick('stdtForm', 'N')">
                <p>일반인</p>
            </div>
            &nbsp;|&nbsp;
            <c:if test="${params.mode == 'inquiry'}">
                <div class="btn" data-branch="0" onClick="fnModeChange('question')">
                    <p style="color: #fff;">질문현황</p>
                </div>
            </c:if>
            <c:if test="${params.mode == 'question'}">
                <div class="btn" data-branch="0" onClick="fnModeChange('inquiry')">	
                    <p style="color: #fff;">신청현황</p>
                </div>
            </c:if>
        </div>
                
            
        <c:if test="${params.mode == 'inquiry'}">
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
        </c:if>
        <c:if test="${params.mode == 'question'}">
        <div class="btn_wrap btn_question" style="float: right;">
            <div class="btn off" onClick="doSortClick('question', '')">
                <p>전체보기</p>
            </div>
            <div class="btn off" onClick="doSortClick('question', 0)">
                <p>전문가강연</p>
            </div>
            <div class="btn off" onClick="doSortClick('question', 1)">
                <p>KH선배</p>
            </div>
        </c:if>
        <%-- <form action="${pageContext.request.contextPath}/rad/main/event.kh" method="post" id="Frm2" name="Frm2" class="btn">	 --%>
            <utils:authority url="/rad/main/eventExcel.kh">
                <a href="javascript:fnExcel('${params.mode}');" class="btn">리스트 엑셀 다운로드</a>
            </utils:authority>
            <utils:authority url="/rad/main/sms/sendGroupSms.kh">
                <a href="javascript:sendGroupSms();" class="btn">리마인드 문자 전송</a>
            </utils:authority>
        <!-- </form> -->
        </div>
    </div>
</div>

<c:if test="${params.mode == 'inquiry'}">
    <table cellpadding="0" cellspacing="0" id="board_list">
        <tr>
            <th width="2%">번호</th>
            <th width="5%;">이름</th>
            <th width="10%;">전화번호</th>
            <th width="5%;">지원</th>
            <th width="10%;">강사/취업담임</th>
            <th width="10%;">신청일자</th>
            <th width="10%;">예매번호</th>
            <th width="8%;">문자발송</th>
            <th width="10%;">발송시간</th>
            <th width="5%;">담당자</th>
            <th width="8%;">티켓교환여부</th>
            <th width="10%;">교환일</th>
            <th width="8%;">교환담당자</th>
        </tr>
        <c:forEach var="data" items="${list}" varStatus="status">
        <c:set var="itemDate" value='${fn:substring(data.applydate, 0, 8) }'/>
        <tr>
            <td>${total - data.rnum + 1}</td>
            <td class="title" style="text-align: center;">${data.name}
                <c:if test="${currentDate le itemDate}"><span class="list_new"></span></c:if>
            </td>
            <td>${data.mobile}</td>
            <td>${data.branch == null?'기타':data.branch}</td>
            <td>${data.prof} / ${data.empl}</td>
            <td>${fn:substring(data.applydate, 0, 4)}. ${fn:substring(data.applydate, 4, 6)}. ${fn:substring(data.applydate, 6, 8)}</td>
            <c:set var="year" value="${fn:substring(params.category,1,5)}"/>
            <td>KH-${year}-<c:forEach begin="1" end="${4 - fn:length(fn:split(data.tichekcode, '-')[1])}">0</c:forEach>${fn:split(data.tichekcode, '-')[1]}</td>
            <c:if test="${data.status == 0}">
                <td onClick="fnSendSms('${data.no}', '${data.name}', '${data.mobile}', '${data.tichekcode}')">
                    <div style="height: 35px; background: #58697b; cursor: pointer; color: #fff; line-height: 35px;">SMS발송</div>
                </td>
            </c:if>
            <c:if test="${data.status != 0}">
                <td>
                </td>
            </c:if>
            <td>
                <c:if test="${data.deliverdate != ''}">
                    ${fn:substring(data.deliverdate, 0, 4) }. ${fn:substring(data.deliverdate, 4, 6) }. ${fn:substring(data.deliverdate, 6, 8) } ${fn:substring(data.deliverdate, 8, 10) }:${fn:substring(data.deliverdate, 10, 12) }:${fn:substring(data.deliverdate, 12, 14) }
                </c:if>
            </td>
            <td>${data.manager}</td>
            <c:if test="${data.publish == 0}">
                <td onClick="fnPublish('${data.no}')">
                    <div style="height: 35px; background: #58697b; cursor: pointer; color: #fff; line-height: 35px;">티켓교환</div>
                </td>
            </c:if>
            <c:if test="${data.publish != 0}">
                <td>
                    교환완료
                </td>
            </c:if>
            <td>
                <c:if test="${data.publishdate != null}">
                    ${fn:substring(data.publishdate, 0, 4) }. ${fn:substring(data.publishdate, 4, 6) }. ${fn:substring(data.publishdate, 6, 8) } ${fn:substring(data.publishdate, 8, 10) }:${fn:substring(data.publishdate, 10, 12) }:${fn:substring(data.publishdate, 12, 14) }
                </c:if>
            </td>
            <td>${data.publisher}</td>
        </tr>
        </c:forEach>
        <c:if test="${list==null or fn:length(list)==0 }">
            <tr><td colspan="13" class="not_found">게시글이 없습니다.</td></tr>
        </c:if>
    </table>
</c:if>

<c:if test="${params.mode == 'question'}">
    <table cellpadding="0" cellspacing="0" id="board_list">
        <tr>
            <th width="5%">번호</th>
            <th width="5%;">이름</th>
            <th width="10%;">전화번호</th>
            <th width="5%;">지원</th>
            <th width="10%;">강사/취업담임</th>
            <th width="10%;">종강일</th>
            <th width="15%;">강연자 분류</th>
            <th>질문내용</th>
        </tr>
        <c:forEach var="data" items="${list}" varStatus="status">
        <tr>
            <td>${total - data.rnum + 1}</td>
            <td class="title" style="text-align: center;">${data.name}</td>
            <td>${data.mobile}</td>
            <td>${data.branch}</td>
            <td>${data.prof} / ${data.empl}</td>
            <td>${data.end_date}</td>
            <td>${data.classify}</td>
            <c:set var="question" value="${fn:split(data.question,'∮')}"/>
            <td>${question[0]}<br>${question[1]}</td>
        </tr>
        </c:forEach>
        <c:if test="${list==null or fn:length(list)==0 }">
            <tr><td colspan="8" class="not_found">게시글이 없습니다.</td></tr>
        </c:if>
    </table>
</c:if>
<div id="board_nums">
    <%=Utils.getPage(total,cpage, 20, 20)%>
</div>

<form action="${pageContext.request.contextPath}/rad/main/event.kh" method="post" id="searchFrm" name="searchFrm">
<div id="board_search">
    <div class="board_search_line" style="border: 0; text-align: center;">
        <input id="searchKey" name="searchKey" style="width: 105px;" value="NAME">
        <input type="text" id="searcValue" name="searchValue" size="35" onkeydown="fnSearchEnter();" style="text-align: center;" value="${params.searchValue }">
        <a href="javascript:fnSearch();" class="btn">검색</a>
        
    </div>
</div>
<input type="hidden" name="category" id="category" value="${params.category}">
<input type="hidden" name="key" id="key" value="${data.key }">
<input type="hidden" name="value" id="value" value="${data.value }">
<input type="hidden" name="cpage" id="cpage" value="${params.cpage }">
<input type="hidden" name="branch_sort" id="branch_sort" value="${params.branch_sort}">
<input type="hidden" name="stdtForm_sort" id="stdtForm_sort" value="${params.stdtForm_sort}">
<input type="hidden" name="status_sort" id="status_sort" value="${params.status_sort}">
<input type="hidden" name="question_sort" id="question_sort" value="${params.question_sort}">
<input type="hidden" name="mode" id="mode" value="${params.mode}">
</form>

</div>

<div class="popup popup_del" name="popup">
    <div class="popup_top">
        <p>비밀번호를 입력해주세요</p>
    </div>
    <div class="popup_mid">
        <p class="mid_las"><input type="text" style="width: 218px;" id="del_pass"></p>
    </div>
    <div class="popup_btn_box">
        <div class="popup_btn_wrap">
            <div class="popup_btn del_save" style="margin-right: 5px;">
                <p>삭제</p>
            </div>
            <div class="popup_btn del_cancel">
                <p>취소</p>
            </div>
        </div>
    </div>
</div>

<input type="hidden" id="target_no" />

<script>
function fnExcel(mode){
    if (mode == 'question') {
        document.searchFrm.action='${pageContext.request.contextPath}/rad/main/eventExcelQuestion.kh';	
    } else {
        document.searchFrm.action='${pageContext.request.contextPath}/rad/main/eventExcel.kh';
    }
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
    $("[name=btn_branch]").each(function(){
        if (branch == null || branch == '') {
            $(this).removeClass("off");
            $(this).children().css({'color':'#fff'});
            return false;
        }
        
        if (branch == $(this).data("branch")) {
            $(this).removeClass("off");
            $(this).children().css({'color':'#fff'});
        }
    });

    var stdtForm = "${params.stdtForm_sort}"
    $("[name=btn_stdtForm]").each(function(){
        if (stdtForm == null || stdtForm == '') {
            $(this).removeClass("off");
            $(this).children().css({'color':'#fff'});
            return false;
        }

        if (stdtForm == $(this).data("stdtform")) {
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

    var question = "${params.question_sort}"
    $(".btn_question > .btn").each(function(){
        if (question == null || question == '') {
            $(this).removeClass("off");
            $(this).children().css({'color':'#fff'});
            return false;
        }
        
        if (question == (Number($(this).index()) - 1)) {
            $(this).removeClass("off");
            $(this).children().css({'color':'#fff'});
        }
    });
    
    // 삭제함수
    $(".delete_btn").click(function(event){
        $(".popup_del").css({'left':(event.pageX - 300), 'top':event.pageY});
        $(".popup_del").show();
    });
    
    $(".del_cancel").click(function(){
        $(".popup_del").hide();
        $("#target_no").val("");
    });
    
    $(".del_save").click(function(){
        fndelete();
    });
});

function fndelete(){
    var pass = $("#del_pass").val();
    
    if (pass != '1q2w3e') {
        alert("잘못된 비밀번호입니다. 다시 입력해주세요.");
        return false;
    }
    
    var	params	= {
            no	:  $("#target_no").val(),
        };

    $.ajax({
        url		: '${pageContext.request.contextPath}/rad/main/deleteEvent.kh',
        dataType	: 'json',
        type		: 'post',
        data		: params,
        success		: function (data, textStatus) {
            alert('삭제되었습니다.');
            
            /* 상담신청 초기화 */
            document.location.reload();
        },
        error		: function (jqXHR, textStatus, errorThrown) {
            alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
        }
    });
};

function doSortClick(category, value){
    if (category == 'branch') {
        $("#branch_sort").val(value);
    }
    else if (category == 'status'){
        $("#status_sort").val(value);
    }
    else if (category == 'stdtForm') {
        $("#stdtForm_sort").val(value);
    }
    else if (category == 'question'){
        $("#question_sort").val(value);
    }
    
    var f = document.getElementById('searchFrm');
    document.searchFrm.action='${pageContext.request.contextPath}/rad/main/event.kh';
    f.submit();
}

function fnModeChange(mode) {
    var f = document.getElementById('searchFrm');
    document.getElementById('mode').value = mode;
    document.searchFrm.action='${pageContext.request.contextPath}/rad/main/event.kh';
    f.submit();
}

function doPagingClick(page){
    document.getElementById("cpage").value = page;
    var f = document.getElementById('searchFrm');
    
    document.searchFrm.action='${pageContext.request.contextPath}/rad/main/event.kh';
    f.submit();
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
        category        : 'TALK'
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

function fnPublish(no) {
    var	params	= {
        no				: no
    };
    
    $.ajax({
        url		: '${pageContext.request.contextPath}/rad/main/insertEventPublish.kh',
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
function fnSendSms(no, name, mobile, tichekcode){
    mobile = mobile.replace(/-/gi, ""); 
    
    tichekcode = "0".repeat(4 - tichekcode.split("-")[1].length) + tichekcode.split("-")[1];
    
    var smsReceiver = "[";
        smsReceiver += "{"; 
        smsReceiver += "\"category\":\"이벤트\", ";
        smsReceiver += "\"recv_name\":\"" + name + "\", \"mobile\":\"" + mobile + "\"";
        smsReceiver += "}";
        smsReceiver += "]";
    
    if( confirm(name + "씨에게 티켓을 보내시겠습니까?") == false ) {
        return;
    }

    var message = '2020 KH정보교육원 토크콘서트\n';

    message += '\n' +
    '예매번호:KH-2020-' + tichekcode +'\n' +
    '장소 : 흰물결아트센터 화이트홀\n' +
    '일시 : 2020.01.11(토), 13시 30분\n' +
    'MC  : 이정수\n' +
    '공연 : 하은\n' +
    '강연 : 페이스북 파트너 엔지니어 박민혁 팀장\n' +
    '선배와의 대화 : 자바&보안 KH 수료생 선배\n' +
    '\n' +
    '참여하신 모든 분께는 2020년 탁상용 캘린더를 드립니다. 토크콘서트에 참여해주셔서 감사드립니다.\n';
    
    var params = {
            mode			: "insert",
            category		: "이벤트",
            mobile			: "15449970",
            title		 	: "2020 KH정보교육원 토크콘서트 안내 SMS입니다",
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
    var message = '안녕하세요. KH정보교육원입니다.\n';
        message += '\n' +
        '2020 KH토크콘서트를 신청해주셔서 감사드리며 [토크콘서트 티켓교환] 안내드립니다.\n' +
        '티켓 교환 기간 : 1/6(월)~1/10(금)\n' +
        '위 기간 내에 수강생분들은 예매 번호가 포함된 문자를 신청한 지원의 안내데스크(강남1관 2층, 종로2층, 당산20층)에 보여주시면, 콘서트 티켓으로 교환해드립니다.\n' +
        '수료생 및 기타신청자, 학원 방문이 어려우신 분은 콘서트 당일, 콘서트 장에서 교환하실 수 있습니다.\n';
    
    var params = {
            mode			: "insert",
            category		: "이벤트",
            mobile			: "15449970",
            title		 	: "2020 KH정보교육원 토크콘서트 안내입니다",
            message 		: message,
            event_category  : '${params.category}'
    };

    $.ajax({
        url		: '${pageContext.request.contextPath}/rad/main/sms/sendEventTalkSms.kh' 
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
</script>