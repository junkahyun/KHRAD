<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 		uri="/WEB-INF/tlds/c.tld" %> 
<%@ taglib prefix="fn" 		uri="/WEB-INF/tlds/fn.tld" %>
<%@ taglib prefix="fmt"		uri="/WEB-INF/tlds/fmt.tld" %>
<%@ taglib prefix="utils"	uri="/WEB-INF/tlds/utils.tld" %>
<style>
	.popup table {border-left:1px solid #ececec;border-top:1px solid #ececec;}
	.popup table th {text-align:center; background:#f9f9f9;border-right:1px solid #ececec;border-bottom:1px solid #ececec; width:60px;}
	.popup table td {border-right:1px solid #ececec;border-bottom:1px solid #ececec; padding: 5px 15px;}
	.popup table textarea {border: 1px solid #ececec; width:460px; height:140px;}

	#view_modify table .chk_interview label {display: none;}
	#view_modify table .chk_interview label.kh {display: block;}
	#memo_write {margin:0px; padding:0 5px;width:580px;background:white;}
	.search_cal{left:137px; bottom:-116px;}
	button.link_btn{border:none; color:#7a7a7a; cursor:pointer;font-size:12px; font-family:'Noto Sans KR', NanumGothic, Arial, Helvetica, sans-serif, "굴림체"}
</style>
<script>
/* 페이지 로딩시 반드시 실행되어야 하는 함수입니다. */
(function(){
	mkCalendar('c_next_skd_date');
	mkCalendar('c_reg_date');
	//mkCalendar('card_due');
	//mkCalendar('interview_date');	
	
	// insert,update인지에 따라 기본값을 세팅해주는 함수입니다.
	settingMode();
	
	//컨택매체를 선택하지 않았을 경우 기본값을 세팅해주는 함수입니다.
	settingContact();
	
	//문의학생 레벨별 메뉴호출	
	fnGetMenu('questionMainMenu');
	
	//방문일자 지정관련 날짜세팅 함수입니다.
	settingMeetingDate();
	
	settingETC();
	
})();

function settingMode(){
	// 온,오프라인문의 메모공유기능, 이슈학생 등록 기능에 사용 
	if(${params.mode=='update'}){
		fnGetMenu('questionSubMenu');
		
		//$("#c_result").val("1∮${data.result}∮${data.result_level}");
		if(${data.c_reg_date!=null and data.c_reg_date!=''}){
			var reg_date = "${data.c_reg_date}".split("∮");
			var reg_date_time = reg_date[1].split(":");
			$("#c_reg_date").val(reg_date[0]);
			$("#c_reg_date_time_hh").val(reg_date_time[0]);
			$("#c_reg_date_time_mm").val(reg_date_time[1]);
		}
		
		//$("#c_next_skd").val("11∮${data.next_skd}∮${data.level}");
		if(${data.next_skd_date!=null and data.next_skd_date!=''}){
			var next_skd_date = "${data.next_skd_date}".split("∮");
			var next_skd_date_time = next_skd_date[1].split(":");
			$("#c_next_skd_date").val(next_skd_date[0]);
			$("#c_next_skd_date_time_hh").val(next_skd_date_time[0]);
			$("#c_next_skd_date_time_mm").val(next_skd_date_time[1]);
		}
		
		if($("#c_next_skd").val().indexOf('면접')>0){
			$(".chk_interview").show();
		}
	} 
	else {
		fnSetTimeToNow('c_reg_date');
	}
}

function settingContact(){
	//내사접수는 방문상담부터 시작한다.
	//컨택매체를 선택하지 않았을 경우.
	var c = $("#contact").val();
	if($("#level").val()==0 && c=="") {
		//$(".popup_wrap .popup").outerHeight("650px");
		$("#c_contact_").show();
		$("#c_contact").change(function(){
			$("#contact").val(this.value);
			
			if(this.value=="내사"){
				$("#level").val(2);
			}
			else{
				$("#level").val(0);
			}
			fnGetMenu('questionMainMenu');
		});
	}
	else if($("#level").val()==0 && (c=="내사"||c=="개인")){
		$("#level").val(2);
	}
}

//온,오프라인문의 메모공유기능, 이슈학생 등록 기능에 사용 
function fnGetMenu(menu_id){
	var classify = $("#level").val()==0?1:$("#level").val();
	var parent_no = $("#c_result_no").val().split("∮")[0];
	var params = {
		menu_id 	: menu_id
	}

	$.ajax({
		  url		: '${pageContext.request.contextPath}/rad/question/questionMemoMenu.kh'
		, data		: params
		, dataType	: 'json'
		, type		: 'post'
		, async		: false
		, success	: function(data, textStatus) {
			var parentNo = 0; //optgroup용 분기용 변수
			var html = "<option value=''>선택</option>";
			for (var i = 0; i < Object.keys(data.list).length; i++) {
				//관리자용
				if(${params.mode=='update'}){
					if(data.list[i].menu_id==menu_id){
						//상담결과
						if(menu_id=='questionMainMenu'){
							html += "<option value='"+data.list[i].val+"'>"+data.list[i].name+"</option>";
						}
						//다음일정
						else {
							if(parentNo!=data.list[i].parent_no){
								if(i!=0) html+="</optgroup>";
								html += "<optgroup label='"+data.list[i].parent_name+"'>";
							}
							
							html += "<option value='"+data.list[i].val+"'>"+data.list[i].name+"</option>";
							if(i==Object.keys(data.list).length-1)
								html+="</optgroup>";
							parentNo=data.list[i].parent_no;
						}
					}
				}
				//일반사용자용 메모등록시
				else {
					if(data.list[i].menu_id==menu_id && data.list[i].classify==classify){
						//상담결과
						if(menu_id=='questionMainMenu'){
							html += "<option value='"+data.list[i].val+"'>"+data.list[i].name+"</option>";											
						}
						//다음일정
						else {
							if(data.list[i].parent_no == parent_no)
								html += "<option value='"+data.list[i].val+"'>"+data.list[i].name+"</option>";
						}
					}
				}
			} // end of for()
			
			//생성된 html select option에 추가 및 이벤트핸들러 추가
			if(menu_id=='questionMainMenu'){
				$("#c_result").html(html);
				
				//관리자용
				if(${params.mode=='update'}){
					var result = "${data.result}",
					level = "${data.result_level}";
					for (var i = 0; i < Object.keys(data.list).length; i++) {
						//메뉴리스트 중에서 해당하는 메뉴이름과 다음 level(db의 value컬럼)값을 대조해서 동일하면, 
						//상담결과로 선택한다.
						if(result==data.list[i].name && level==data.list[i].value) {
							var v = data.list[i].no+"∮"+result+"∮"+level;
							$("#c_result_no").val(data.list[i].no);
							$("#c_result").val(v);
						}
					}
				}			
				
				//다음일정 이벤트핸들러
				//서브메뉴를 가져올때 필요한 parent_no의 값을 대입해둔다.
				$("#c_result").change(function(){
					var v = this.value.split("∮")[1];
					//전화상담,방문상담 후 가망고객으로 바로 선택 -> 상담결과에 등록or면접 관련된 항목을 선택할경우  
					//학생 회원가입 여부 체크합니다.
					
					//면접예정용 운영과정조회
					if(v=='운영과정변경' || v=='가망' || v=='등록' || v=='면접예정' || v=='면접'){
						if(('${params.stdt_no}' !== "0" && '${params.user_no}' !== "0") || v == '취소'){
							/* if(v=='운영과정변경'){
								$("#c_curr_prospects_name_list").css("top","163px");
							} */
							if((v=='가망' && $("#curr_prospects").val()=="") || v=='면접예정'){
								$("#hasCurrProspects").show();
								$("#tr-disposableLink").hide();
								//$(".popup_wrap .popup").outerHeight("630px");
							}
							else if(v=='운영과정변경' && $("#curr_prospects").val()!=""){
								$("#hasCurrProspects").show();
								$("#tr-disposableLink").hide();
							}
							else if(v=='등록' && $("#curr_prospects").val()!=""){
								$("#tr-disposableLink").show();
								$("#hasCurrProspects").hide();
							}
							else if((v=='등록' || v=='운영과정변경') && $("#curr_prospects").val()==""){
								alert('문의번호 [${params.quest_no}]님은 면접진행이 되어있지 않습니다. \n면접일정을 먼저 등록해주세요.');
								$('#c_result').val('').prop('selected',true);
								$('#c_result_no').val('').prop('selected',true);
								$("#tr-disposableLink").hide();
								$("#hasCurrProspects").hide();
							}
							else{
								$("#hasCurrProspects").hide();
								$("#tr-disposableLink").hide();
								//$(".popup_wrap .popup").outerHeight("670px");
							}
						}
						else if('${params.user_count }' != 0){
							alert('다음일정 진행을 위해 회원가입여부 버튼을 클릭하여 수강생 정보를 매칭해주세요.');
							$('#c_result').val('').prop('selected',true);
							return
						} 
					}
					else {
						$("#hasCurrProspects").hide();
						//$(".popup_wrap .popup").outerHeight("630px");
					}
					
						
					$("#c_result_no").val(this.value.split("∮")[0]);
					fnGetMenu("questionSubMenu");
				});
			}
			else {
				$("#c_next_skd").html(html);	
				
				//관리자용
				if(${params.mode == 'update'}){
					var next_skd = "${data.next_skd}";
					var level = "${data.level}";
					
					for (var i = 0; i < Object.keys(data.list).length; i++) {
						if(next_skd==data.list[i].name && level==data.list[i].value){
							$("#c_next_skd").val(data.list[i].no+"∮${data.next_skd}∮${data.level}");
						}
					}
				}
				
				//다음일정 이벤트핸들러
				$("#c_next_skd").change(function(){
					var vn = this.value.split("∮")[1];
					if(vn=='면접' || vn=='등록예정' || vn=='등록완료'){
						//면접을 잡기 전에 학생이 입학등록을 하였는지 체크 합니다.
						if('${params.user_count}'  == 0){ 
					    	
					    	/* 다음일정이 면접인 경우 국기면접 페이지로 이동할수 있는 버튼을 보여준다. */
					    	if(vn=='면접'){
					    		fnChkInterview('show');
								
								//방문상담에서 면접일정 잡는 경우
								$("#hasCurrProspects").show();
								//$(".popup_wrap .popup").outerHeight("630px");
					    	}
					    	else if($('#c_result').val() === '8∮운영과정변경∮3'){
					    		$("#hasCurrProspects").show();
					    	}
					    	else {
								fnChkInterview('hide');
								$("#hasCurrProspects").hide();
								//$(".popup_wrap .popup").outerHeight("630px");
							}
						} 
						else if('${params.user_count}' != 0){
							alert('다음일정 진행을 위해 회원가입여부 버튼을 클릭하여 수강생 정보를 매칭해주세요.');
							$('#c_next_skd').val('').prop('selected',true);
							return
						} 
					}
				});
				
				if (${params.mode != 'update'}) {
					//다음일정 메뉴가 하나인 경우에는 자동선택되도록한다.
					//상담결과(v)의 값에 따른 다음일정(v_next)의 문자열을 삼항연산으로 담는다. 
					//메뉴리스트를 순회하면서 부모메뉴번호/메뉴이름을 비교해서, 일치하면, selectedIndex값을 이횽해서 선택한다.
					var v = $("#c_result").val().split("∮")[1] //상담결과
					, v_no = $("#c_result").val().split("∮")[0] //부모메뉴_no
					, v_next = v=='면접예정'?'면접':v=='등록'?'등록완료':v=='가망'?'등록예정':v=='문자발송'?'재컨택요망':'';
					
					var flag = 0; //다음일정메뉴가 한가지인 경우 구분용 flag
					for (var i = 0; i < Object.keys(data.list).length; i++) {
						if(v_next==data.list[i].name && v_no==data.list[i].parent_no){
							flag++;
						}
					}

					if(flag==1){
						$("#c_next_skd").prop("selectedIndex", 1);
					}
				}
				
				//면접인 경우에, 숨겼던 면접관련 버튼을 노출하고, next_skd_date는 disable처리한다.
				// 함수 fnChkInterview(id)를 호출!!
				if(v_next=='면접'){
					fnChkInterview('show');
				}
				else {
					fnChkInterview('hide');
				}
			}
		}
		, error		: function(jqXHR, textStatus, errorThrown) {
			alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
		}
	});
}

function settingMeetingDate(){
//////방문일자 지정달력관련 시작!!////////////////
	$.datepicker.regional['ko'] = {
        closeText: '닫기',
        prevText: '이전달',
        nextText: '다음달',
        currentText: '오늘',
        monthNames: ['1월(JAN)','2월(FEB)','3월(MAR)','4월(APR)','5월(MAY)','6월(JUN)',
        '7월(JUL)','8월(AUG)','9월(SEP)','10월(OCT)','11월(NOV)','12월(DEC)'],
        monthNamesShort: ['1월','2월','3월','4월','5월','6월',
        '7월','8월','9월','10월','11월','12월'],
        dayNames: ['일','월','화','수','목','금','토'],
        dayNamesShort: ['일','월','화','수','목','금','토'],
        dayNamesMin: ['일','월','화','수','목','금','토'],
        weekHeader: 'Wk',
        dateFormat: 'yy. mm. dd',
        firstDay: 0,
        isRTL: false,
        showMonthAfterYear: true,
        yearSuffix: '',
        showOn: 'both',
        buttonText: "달력",
        changeMonth: true,
        changeYear: true,
        showButtonPanel: true,
        yearRange: 'c-99:c+99',
    };
    $.datepicker.setDefaults($.datepicker.regional['ko']);
  
    var datepicker_default = {
        showOn: 'both',
        //showOn: "button",
        buttonImage: "${pageContext.request.contextPath}/resources/images/rad/calendar.png",
        //buttonImage: "${pageContext.request.contextPath}/resources/images/rad/icon_datepicker.png",
        buttonImageOnly: true,
        buttonText: "날짜선택",
        currentText: "이번달",
        changeMonth: true,
        changeYear: true,
        showButtonPanel: true,
        yearRange: 'c-99:c+99',
        showOtherMonths: true,
        selectOtherMonths: true
    }
  
    datepicker_default.closeText = "선택";
    datepicker_default.dateFormat = "yy. mm. dd";
  
    datepicker_default.beforeShow = function () {
        var selectDate = $("#c_curr_prospects_name").val().split(". ");
        var year = Number(selectDate[0]);
        
        var month = Number(selectDate[1]) - 1;
        var date = Number(selectDate[2]);
        $(this).datepicker( "option", "defaultDate", new Date(year, month, date) );
    }
    datepicker_default.onClose = function (dateText, inst) {
    	$("#c_curr_prospects_name").focus();
    	$("#c_curr_prospects_name").autoSearch(dateText);
	}
    
    $("#c_curr_prospects_name").datepicker(datepicker_default);
    //$("#c_curr_prospects_name").datepicker('setDate', new Date()); 
	///////방문일자 지정달력관련 끝!!////////////////
}

function settingETC(){
	//면접일 수정등의 경우에 대비해 부모페이지에서 branch값을 가져온다.
	$("#c_interview_branch"+$("[name=interview_branch]:checked").val()).prop('checked',true);
			
	//면접장소는 popup 라디오박스가 아닌 부모페이지 [name=interview_branch]:checked의 값을 취한다.
	//면접일/장소 수정은 부모페이지/팝업 모두 가능하다.--> 팝업에서만 가능.
	$("[name=c_interview_branch]").change(function(){
		$("#interview_branch"+this.value).prop("checked", true);
	});
}

document.getElementById('disposableLink').addEventListener('click',function(){
	let formData; 
	formData = {
			stdt_no  : '${params.stdt_no}',
			quest_no : '${params.quest_no}',
			curr_branch : '${curr.branch}',
			train_month : '${curr.train_month}'
	};
	$('#disposableLink').css('cursor','progress');
	$.ajax({
		url:'${pageContext.request.contextPath}/rad/question/disposableLink.kh',
		type:'post',
		dataType:'json',
		data:formData
	})
	.success(function(data,textStauts){
		$('#disposableLink').css('cursor','pointer');
		if(data.link === ''){
			alert('링크생성에 실패했습니다. 다시 시도해주세요.');
		}
		else{
			alert('일회성 링크가 학생의 이메일로 전송되었습니다. 해당 링크는 3일 후 만료됩니다.');
			$('#validateLink').css('display','inherit');
			$('#validateLink').val(data.link);
			const linkLeng = (data.link).length;
			console.log(linkLeng);
			$('#memo_write').val("일회성링크 : "+(data.link).substring(0,60)+"\n"+(data.link).substring(60,120)+"\n"+(data.link).substring(120,linkLeng));
			//sendLinkMobile(data.link);
		}
	})
	.error(function (jqXHR, textStatus, errorThrown) {
		alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
	});
});

function sendLinkMobile(link){
	const name = '${params.name}';
	const mobile = '${params.mobile}'.replace(/-/gi, "");
	
	var smsReceiver = "[";
		smsReceiver += "{"; 
		smsReceiver += "\"category\":\"이벤트\", ";
		smsReceiver += "\"recv_name\":\"" + name + "\", \"mobile\":\"" + mobile + "\"";
		smsReceiver += "}";
	    smsReceiver += "]";
	
    var message = '안녕하세요. ' + name + '님. \nKH 정보교육원 입니다.\n';
		message += '수강생 등록을 위하여 아래 링크에 접속하여 주민번호를 입력해주시기 바랍니다.'
		message += '주민번호 미등록시 수강생 등록이 불가하오니 꼭 등록을 완료하여 주시기 바랍니다.'
		message += '해당 링크는 입력이 완료된 경우나 3일이 지난 경우 만료됩니다.\n\n'+link+'';
		message += '\n\n';
	
    var params = {
			mode			: "insert",
			category		: "기타",
			mobile			: "15449970",
			title		 	: "[KH정보교육원]수강생 등록 안내메일입니다.",
			message 		: message,
			smsReceiver     : smsReceiver
	};
	$.ajax({
		url		    : '${pageContext.request.contextPath}/rad/main/sms/sendSmsOne.kh', 
	 	data		: params,
		async		: true,
		type		: 'post',
		success:function(data,textStatus){
		}
		,error:function (jqXHR, textStatus, errorThrown) {
			alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
		}
	});
}


//면접일정 관련 show/hide 함수
//면접메뉴버튼 토글, 다음일정_일시 disable토글.
function fnChkInterview(id){
	if(id=='show'){
		$(".chk_interview").show();
		$(".nxt_skd").prop("disabled","disabled");
		$("#c_next_skd_date").prop("disabled","disabled");
	}
	else {
		$(".chk_interview").hide();
		$(".nxt_skd").removeProp("disabled");
		$("#c_next_skd_date").removeProp("disabled");
	}
}

function fnGoToInterview(){
	var q_no=$("#no").val(); 
    const encodeName = encodeURI(encodeURIComponent($("#name").val()));
  	return window.open("${pageContext.request.contextPath}/rad/curr/interview.kh?q_no="+q_no+"&name="+encodeName,"_tab");
	  	
}
$("body").on('click', function(e) {
	var clickPoint = $(e.target);
	
	if (!clickPoint.hasClass('c_curr_prospects_name_list')) {
		$("#c_curr_prospects_name_list").hide();
	}
});

$.fn.autoSearch = function(e) {	
	var checkNo = function(value) {
		var params = {
			keyword		: value
		};
	
		$.ajax({
			url		: '${pageContext.request.contextPath}/rad/curr/currFinder.kh'
			, data		: params
			, dataType	: 'html'
			, type		: 'post'
			, success	: function(data, textStatus){
				$("#c_curr_prospects_name_list").show();
				$("#c_curr_prospects_name_list").html(data);
			}
			, error		: function(jqXHR, textStatus, errorThrown){
				alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
			}
		});
	}

	// keyup check
	$(this).keyup(function() {
		var value = $(this).val();
		checkNo(value);
	});
	if(e != null){
		var value = e;
		checkNo(value);
	}
}
$("#c_curr_prospects_name").autoSearch();
</script>

<div id="view_modify" style="margin-bottom:0px;">
<table cellpadding="0" cellspacing="0" class="" style="width:680px;">
	<tr id="c_contact_" style="display:none;">
		<th style="width:50px;">컨택매체</th>
		<td colspan="3">
			<select id="c_contact">
				<option value="">선택</option>
				<option value="홈페이지">홈페이지</option>
				<option value="모바일">모바일</option>
				<option value="대표전화">대표전화</option>
				<option value="개인">개인</option>
				<option value="내사">내사</option>
				<option value="오프라인">오프라인</option>
			</select>
		</td>
	</tr>
	<tr id="th_result_date">
		<th style="width:50px;">상담결과</th>
		<td style="width:135px;">
			<select id="c_result" style="width: 120px;"></select>
			<input type="hidden" id="c_result_no"><%-- 서브메뉴의 부모메뉴 No. --%>
		</td>
		<th style="width:50px;">일시</th>
		<td> 
			<input type="text" id="c_reg_date" style="width:70px;">
			<select id="c_reg_date_time_hh" style="width:60px; margin-top:7px;">
				<c:forEach var="hh" begin="0" end="23">
					<option>${hh<10?'0':''}${hh}</option>
				</c:forEach>
			</select> :
			<select id="c_reg_date_time_mm" style="width:60px;">
				<c:forEach var="mm" begin="0" end="59">
					<option>${mm<10?'0':''}${mm}</option>
				</c:forEach>
			</select>
			<a href="javascript:fnSetTimeToNow('c_reg_date');" class="btn" style="margin-bottom:6px;background:#2a2a4e;">Now</a>
			<a href="javascript:fnReset('c_reg');" class="btn" style="margin-bottom:6px;background:#fb606b;">Reset</a>
		</td>
	</tr>
	<!-- <tr id="row_res_no" style="display:none;">
		<th>주민번호</th>
		<td colspan="3">
			<input type="text" id="c_res_no1" maxlength="6" style="width: 70px;margin-right:10px;">-
			<input type="text" id="c_res_no2" maxlength="7" style="width: 70px;margin-right:10px;">
		</td>
	</tr> -->
	<tr id="tr-disposableLink" style="display:none;">
		<th>일회성 <br>링크 생성</th>
		<td colspan="3">
		<button type="button" class="btn link_btn" role="button" id="disposableLink" style="background:#ebecef;">링크 생성</button>
		<input id="validateLink" style="display:none;border: none; width: 84%;" disabled="disabled"></span>
		<input type="hidden" id="curr_prospects" value="${curr.no}" />
		</td>
	</tr>
	<tr id="hasCurrProspects" style="display:none;">
		<th style="width:50px;">운영과정</th>
		<td colspan="3">
			<c:set var="cpn" value="${curr.currname}(${curr.prof_name}) - ${curr.begin_date}_ (${curr.branch_name})"/>
			<input type="text" autocomplete="off" id="c_curr_prospects_name" placeholder="운영과정 날짜을 날짜로 검색하세요." value="${curr!=null?cpn:''}" style="width:511px;"/>
			<div id="c_curr_prospects_name_list" class="c_curr_prospects_name_list" style="position: absolute; top: 205px; left:113px; width: 498px; height: 300px; padding: 10px; overflow-y: scroll; display: none; background: #fff; z-index: 98; border: 1px solid #ececec; text-align:left;"></div>					
		</td>
	</tr>
	<tr>
		<th>상담요약</th>
		<td colspan="3">
			<input type="text" id="c_result_memo" style="width: 450px;margin-right:10px;" value="${data.result_memo}">
		</td>
	
	</tr>
	<tr id="th_call_duration">
		<th>상담시간</th>
		<td colspan="3"><input type="text" id="memo_call_duration" style="width:35px;" value="${data.call_duration}">분</th>
		<%-- 
		<th>방분상담여부</th>
		<td>	
			<input type="radio" id="visited1" name="visited" value="1" ${data.visited==1?'checked':'z'}><label for="visited1">예</label>
			<input type="radio" id="visited0" name="visited" value="0" ${data.visited==null or data.visited==0?'checked':''}><label for="visited0">아니오</label>
		</td> 
		--%>
	</tr>
		<tr>
		<th>내용</th>
		<td colspan="3">
			<input type="hidden" id="link" />
			<textarea id="memo_write" name="memo_write" style="resize:none;">${data.comment}</textarea><br/>
			<span id="pop_notice"></span>
		</td>
	</tr>
	<tr id="th_next_date">
		<th>다음일정</th>
		<td>
			<select id="c_next_skd" style="width: 120px;">
				<option value="">선택</option>
			</select>
			<a href="javascript:void(0)" onClick="fnGoToInterview();" class="btn chk_interview" style="display:none; margin:5px 0; background:#ebecef; color:#7a7a7a;">면접일정</a>
		</td>
		<th>일시</th>
		<td colspan="3">
			<input type="text" id="c_next_skd_date" class="nxt_skd" style="width:70px;">
			<select id="c_next_skd_date_time_hh" class="nxt_skd" style="width:60px; margin-top:7px;">
				<c:forEach var="hh" begin="0" end="23">
					<option>${hh<10?'0':''}${hh}</option>
				</c:forEach>
			</select> :
			<select id="c_next_skd_date_time_mm" class="nxt_skd" style="width:60px;">
				<c:forEach var="mm" begin="0" end="55" step="5">
					<option>${mm<10?'0':''}${mm}</option>
				</c:forEach>
			</select>
			<a href="javascript:fnSetTimeToNow('c_next_skd_date');" class="btn" style="margin-bottom:6px;background:#2a2a4e;">Now</a>
			<a href="javascript:fnReset('c_next_skd');" class="btn" style="margin-bottom:6px;background:#fb606b;">Reset</a>
			<br>
			<div class="chk_interview" style="display:none;">
				<label class="kh"><input type="radio" id="c_interview_branch2" class="nxt_skd" name="c_interview_branch" value="2" ${data.interview_branch=='2'?'checked':''} />강남</label>
				<label class="kh"><input type="radio" id="c_interview_branch6" class="nxt_skd"  name="c_interview_branch" value="6" ${data.interview_branch=='6'?'checked':''} />종로</label>
				<label class="kh"><input type="radio" id="c_interview_branch10" class="nxt_skd" name="c_interview_branch" value="10" ${data.interview_branch=='10'?'checked':''} />당산</label>
			</div>
		</td>
	</tr>
	<input type="hidden" id="comment_no" value="${data.comment_no}">
</table>
</div>