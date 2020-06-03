<%@ page import="java.util.List"%>
<%@ page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 		uri="/WEB-INF/tlds/c.tld" %> 
<%@ taglib prefix="fn" 		uri="/WEB-INF/tlds/fn.tld" %>
<%@ taglib prefix="fmt"		uri="/WEB-INF/tlds/fmt.tld" %>
<%@ taglib prefix="utils"	uri="/WEB-INF/tlds/utils.tld" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<c:if test="${sessionScope.aduser.site_id == 'kh' }">
<title>KH정보교육원 RAD :: 학사관리</title>
</c:if>
<c:if test="${sessionScope.aduser.site_id == 'atents' }">
<title>아텐츠 RAD :: 학사관리</title>
</c:if>
<c:set var="currentDate" value="<%=new java.util.Date() %>"/>
<c:set var="role" value="${sessionScope.aduser.role_code}"/>
<c:set var="currentDate"><fmt:formatDate value="${currentDate}" pattern="yyyyMMdd" /></c:set>
<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/meta.jsp"/>
<script type="text/javascript" src="${pageContext.request.contextPath }/resources/js/jqplot/excanvas.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath }/resources/js/jqplot/jquery.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath }/resources/js/jqplot/jquery.jqplot.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath }/resources/js/jqplot/plugins/jqplot.barRenderer.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath }/resources/js/jqplot/plugins/jqplot.canvasAxisLabelRenderer.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath }/resources/js/jqplot/plugins/jqplot.canvasAxisTickRenderer.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath }/resources/js/jqplot/plugins/jqplot.canvasOverlay.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath }/resources/js/jqplot/plugins/jqplot.canvasTextRenderer.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath }/resources/js/jqplot/plugins/jqplot.categoryAxisRenderer.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath }/resources/js/jqplot/plugins/jqplot.highlighter.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath }/resources/js/jqplot/plugins/jqplot.pointLabels.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath }/resources/js/jqplot/plugins/jqplot.pieRenderer.min.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/resources/js/jqplot/jquery.jqplot.min.css" />

<script type="text/javascript">
jQuery(function(){
	fnCurrentSub('03', "03");
	
	$.jqplot.config.enablePlugins = true;
	var list = '${list}'; // 답변 리스트
	if(list != null && list != '[]') {
		// 문자열 상태인 답변 리스트에서 괄호를 제거하여 split을 통해 list형태를 만들 수 있도록 수정
		list = list.replaceAll("{", "");
		list = list.replaceAll("}]", "");
		list = list.split('}, ');

		// 문제 및 답안 리스트에서 답안갯수값을 JS List 변수에 저장
		var chart_nos = [];
		<c:forEach var="qData" items="${qData}" varStatus="vs">
			chart_nos.push("${qData.answer}");
		</c:forEach>
		
		var tp = 0
		for (var i = 0; i < list.length; i++) { // 답변 리스트 반복문
			if (chart_nos[i] != 0) { // 해당되는 번호의 문제가 객관식인 경우
				var temp = [];
				for (var j = 0; j < chart_nos[i]; j++) { // 답안 갯수만큼 반복문
					tp_cont = list[i];
					tp = 0;
					if (tp_cont.indexOf((j + 1) + '=') != -1){
						tp_cont = tp_cont.split((j + 1) + '=')[1];
						if (tp_cont.indexOf(',') != -1) tp_cont = tp_cont.split(',')[0];
						tp = tp_cont;
					}
					temp.push([j + 1 + '', tp * 1]);
				}
				fnChart(i + 1, temp);
			}
		}
	}
});
function fnChart(id, data){
	$('#q'+id+'_bar').jqplot([data], {
          seriesDefaults:{
              renderer:$.jqplot.BarRenderer
            , rendererOptions: {
                  varyBarColor: true
            },
            shadow: false
        }
		, axesDefaults:{
        	tickOptions:{
        		  fontSize : '12px'
        		, textColor : '#888888'
        	}
        }
        , axes:{
            xaxis:{
                renderer: $.jqplot.CategoryAxisRenderer
            }
        }
        , grid:{
        	  background: '#FFFFFF'
        	, shadow : false
        	, borderWidth : 0
        	, drawGridLines : false
        }        
    });
	var plot1 = $.jqplot('q'+id+'_pie', [data], {
		gridPadding: {top:0, bottom:38, left:0, right:0},
		seriesDefaults:{
            shadow: false, 
            renderer:$.jqplot.PieRenderer, 
            rendererOptions:{
                sliceMargin: 4, 
                startAngle: -90,
                showDataLabels: true
            }
        },
		legend:{
			show:true, 
			placement: 'outside', 
			rendererOptions: {
				numberRows: 1
			}, 
			location:'s',
			marginTop: '0'
		}
        , grid:{
	      	  background: '#FFFFFF'
	      	, shadow : false
	      	, drawBorder: false
	      	, drawGridLines : false
		}
        ,highlighter:{
        	show:false
        }
	});
}
function fnAdd(id, no){
	var rc = Number($("#rowcount_"+no).html());
	
	if(id==0) { 
		rc++;
		
		var html = "<tr>";
		html+="<td>"+rc+"</td>";
		html+="<td><textarea id='opinion_"+no+"_"+rc+"'></textarea></td>";
		html+="<td><textarea id='feedback_"+no+"_"+rc+"'></textarea></td>";
		html+="</tr>";

		if(no==1) {
			$("#survey_comment tbody .row_2").before(html);
		} else if(no==2) {
			$("#survey_comment tbody").append(html);
		}
	} else if(id==1) {
		if(rc==1) return;
		
		rc--;

		if(confirm('칸을 지우며 내용이 사라집니다. 정말 지우시겠습니까?')){
			if(no==1) {
				$("#survey_comment tbody tr:eq("+rc+")").remove();
			} else if(no==2) {
				$("#survey_comment tbody tr:last-child").remove();
			}
		} else {
			return;
		}
	}
	$("#rowcount_"+no).html(rc);
	$(".row_"+no+" td:first-child").attr("rowspan", rc);
}
function fnSave(){
	var o="", f="";
	var oc=0; fc=0;
	var t;
	
	oc=Number($("#rowcount_1").html());
	fc=Number($("#rowcount_2").html());
	
	for(var i=1; i<=oc; i++) {
		t=$("#opinion_1_"+i).val();
		if(t!=null && t!='') o+=$("#opinion_1_"+i).val();
		else o+="n";

		t=$("#feedback_1_"+i).val();
		if(t!=null && t!='') f+=$("#feedback_1_"+i).val();
		else f+="n";
		
		if(i!=oc){
			o+="∮";
			f+="∮";
		}
	}

	o+="∫";
	f+="∫";

	for(var i=1; i<=fc; i++) {
		t=$("#opinion_2_"+i).val();
		if(t!=null && t!='') o+=$("#opinion_2_"+i).val();
		else o+="n";

		t=$("#feedback_2_"+i).val();
		if(t!=null && t!='') f+=$("#feedback_2_"+i).val();
		else f+="n";
		
		if(i!=fc){
			o+="∮";
			f+="∮";
		}
	}
	
	var params = {
		  no		: '${cData.no}'
		, curr_no	: '${params.no}'
		, degree	: '${params.degree}'
		, opinion	: o
		, feedback	: f
	};
	$.ajax({
		  url		: '${pageContext.request.contextPath}/rad/curr/surveyComment.kh'
		, data		: params
		, dataType	: 'json'
		, type		: 'post'
		, success	: function (data, textStatus){
			var r = data['result'];
			if(r==0) {
				alert("저장에 실패하였습니다. 다시 한 번 시도해주세요.");
			} else {
				alert("저장되었습니다.");
				location.href='${pageContext.request.contextPath}/rad/curr/surveyView.kh?no=${params.no}&start_date=${params.all_date}&degree=${params.degree}&cpage=${params.cpage}&branch=${params.branch}&search=${params.search}&template_no=${params.template_no}'
			}
		}
		, error		: function (jqXHR, textStatus, errorThrown){
			alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
		}
	});
}

function fnDegree(degree, template_no , classify){
	location.href="${pageContext.request.contextPath}/rad/curr/surveyView.kh?no=${params.no}&start_date=${params.all_date}&degree="+degree+"&cpage=${params.cpage}&branch=${params.branch}&search=${params.search}&template_no="+template_no+"&template_set=${params.template_set}&classify="+classify;
}

function fnPrint(){
	$("body").css("background", "#FFFFFF");
	$("#top").hide(0);
	$("#head").hide(0);
	$("#footer").hide(0);
	$("#headtitle").hide(0);
	$(".survey_btns").hide(0);
	
	if( navigator.userAgent.indexOf("MSIE") > 0 ){   
		var OLECMDID = 7;
		var PROMPT = 1;
		var WebBrowser = '<OBJECT ID="WebBrowser1" WIDTH=0 HEIGHT=0 CLASSID="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2"></OBJECT>';
		document.body.insertAdjacentHTML('beforeEnd', WebBrowser);
		WebBrowser1.ExecWB( OLECMDID, PROMPT);
	} else if( navigator.userAgent.indexOf("Chrome") > 0){
		window.print();
	}
	
	setTimeout(function(){
		$("body").css("background", "#F5F5F5");
		$("#top").show(0);
		$("#head").show(0);
		$("#footer").show(0);
		$("#headtitle").show(0);
		$(".survey_btns").show(0);
	}, 500);
	if(navigator.userAgent.indexOf('Trident/7.0;')>0){
		alert("인터넷 익스플로러 11버전에서는 스크립트를 이용한 인쇄 기능을 지원하지 않습니다. 우클릭>인쇄 미리보기 기능을 이용해주세요.");
		return;
	}
}
</script>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/metaHeader_2018.jsp"/>
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/header_2018.jsp"/>
	<div id="body" onmouseover="fnCloseSubs();">
		<div id="headtitle">
			<div class="left">학생설문조사</div>
			<div class="right">
			</div>
		</div>
		<div class="survey_top" style="height: 250px;">
			<div class="survey_btns" style="float: none;">
				<a href="javascript:fnDegree(1, ${fn:split(params.template_set, '_')[0]}, '${params.classify}');" class="btn${params.degree==1?'':' off'}">1차</a>
				<a href="javascript:fnDegree(2, ${fn:split(params.template_set, '_')[1]}, '${params.classify}');" class="btn${params.degree==2?'':' off'}">2차</a>
				<a href="javascript:fnDegree(3, ${fn:split(params.template_set, '_')[2]}, '${params.classify}');" class="btn${params.degree==3?'':' off'}">3차</a>
			</div>
			―${curData.note }
			<input type="hidden" value="${curData.note}" id="noteV">
			<div id="timetable_title">
				<div class="left">
					<h3>[${curData.branch} ${curData.classroom}]${curData.currname }</h3>
					<p>${curData.begin_date } ~ ${curData.end_date } | ${curData.begin_time} ~ ${curData.end_time}<br>${curData.prof} 강사 | ${curData.empl_charge} 취업담임</p>
				</div>
				<c:set var="bd" value="${fn:replace(curData.begin_date, '. ', '') }"/>
				<c:set var="ed" value="${fn:replace(curData.end_date, '. ', '') }"/>
				<c:if test="${currentDate<bd}"><div class="right app">모집중</div></c:if>
				<c:if test="${currentDate>=bd}">
					<c:if test="${currentDate<=ed}"><div class="right ing">수업중</div></c:if>
					<c:if test="${currentDate>ed}"><div class="right end">종료</div></c:if>
				</c:if>
			</div>
			<div class="survey_txt">
				<span>설문 시작일</span> : ${fn:substring(params.start_date, 0, 4) }. ${fn:substring(params.start_date, 4, 6) }. ${fn:substring(params.start_date, 6, 8) } /
				<span>수강인원</span> : ${data.stdt} &nbsp;&nbsp; 
				<span>설문참가인원</span> : ${data.cv} &nbsp;&nbsp; 
				<span>설문참가율</span> : <fmt:formatNumber value="${(data.stdt != 0) ? data.cv / data.stdt : 0}" type="percent" pattern="0.0%"/>
			</div>
		</div>
		<c:if test="${list!=null and fn:length(list)!=0}">
		<div id="survey">
			<c:forEach var="qData" items="${qData}" varStatus="vs">
				<div class="survey_q">
					<p class="q">${vs.count}. ${qData.question}</p>
					<c:if test="${qData.answer != '0'}">
						<table cellpadding="0" cellspacing="0">
							<tr>
								<th>&nbsp;</th>
								<c:forEach var="answer" items="${qData.aList}" varStatus="as">
								<th>(${as.count}) ${answer.answer}</th>
								</c:forEach>
							</tr>
							<tr>
								<c:set var="score" value="0" />
								<td>개수</td>
								<c:forEach begin="1" end="${qData.answer}" varStatus="as">
								<c:set var="flag" value="0" />
									<c:forEach var="temp" items="${qData.temp}">
										<c:set var="t" value="${fn:split(temp, '=')}" />
										<c:if test="${t[0] != 'conts' && t[0] == as.count}">
											<td>${t[1]}</td>
											<c:set var="flag" value="1" />
											<c:set var="score" value="${score + (t[1] * (6 - as.count))}" />
										</c:if>
									</c:forEach>
									<c:if test="${flag == 0}">
										<td></td>
									</c:if>
								</c:forEach>
							</tr>
							<tr>
								<td>비율</td>
								<c:forEach begin="1" end="${qData.answer}" varStatus="as">
								<c:set var="flag" value="0" />
									<c:forEach var="temp" items="${qData.temp}">
										<c:set var="t" value="${fn:split(temp, '=')}" />
										<c:if test="${t[0] != 'conts' && t[0] == as.count}">
											<td><fmt:formatNumber value="${t[1]/data.cv}" type="percent"/></td>
											<c:set var="flag" value="1" />
										</c:if>
									</c:forEach>
									<c:if test="${flag == 0}">
										<td></td>
									</c:if>
								</c:forEach>
							</tr>
						</table>
						<c:if test="${qData.result == 0}">
							<table class="survery_range" cellpadding="0" cellspacing="0">
								<tr>
									<td><div id="q${vs.count}_bar"></div></td>
									<td><div id="q${vs.count}_pie"></div></td>
								</tr>
							</table>
						</c:if>
						<c:if test="${qData.result == 1}">
							<table class="survery_range" cellpadding="0" cellspacing="0" style="display: table-column;">
								<tr>
									<td><div id="q${vs.count}_bar"></div></td>
									<td><div id="q${vs.count}_pie"></div></td>
								</tr>
							</table>
							<span></span>
							<table cellpadding="0" cellspacing="0" style="width: 311px;">
								<tr>
									<td style="width: 122px;">평균만족도</td>
									<td style="font-size: 20px;"><fmt:formatNumber value="${score / data.cv}" pattern="0.0"/></td>
									<td>
										<div style="position: absolute; left: 21px; width: ${(score / (data.cv * 5)) * 67}px; overflow-x: hidden;">
											<img src="${pageContext.request.contextPath}/resources/images/rad/survey/survey_star_count_5.png" />
										</div>
										<div><img src="${pageContext.request.contextPath}/resources/images/rad/survey/survey_star_count_0.png" /></div>
									</td>
								</tr>
							</table>
						</c:if>
					</c:if>

					<c:set var="temp" value="${fn:split(list[vs.index]['conts'], '§')}"/>
					<c:if test="${temp!=null and temp!='' and fn:length(temp)!=0 }">
						<ul>
						<c:forEach var="t" items="${temp}">
							<li>- ${t}</li>
						</c:forEach>
						</ul>
					</c:if>
				</div>
			</c:forEach>

			<div id="survey_c">
				<c:if test="${(cData==null or cData=='') and role!='E' and role!='C' and role!='U'}">
				<p id="title">${data.currname} 설문조사 결과 및 피드백</p>
				<table id="survey_comment" cellpadding="0" cellspacing="0">
					<thead>
						<tr>
							<th width="150">구분</th>
							<th width="150">연번</th>
							<th width="460">의견</th>
							<th width="460">피드백</th>
						</tr>
					</thead>
					<tbody>
						<tr class="row_1">
							<td>
								관리관련<br>
								<div class="ar_table">
									<a href="javascript:fnAdd(1, 1);" class="remove">-</a>
									<span id="rowcount_1">1</span>
									<a href="javascript:fnAdd(0, 1);" class="add">+</a>
								</div>
							</td>
							<td>1</td>
							<td><textarea id="opinion_1_1"></textarea></td>
							<td><textarea id="feedback_1_1"></textarea></td>
						</tr>
						<tr class="row_2">
							<td>
								강사관련<br>
								<div class="ar_table">
									<a href="javascript:fnAdd(1, 2);" class="remove">-</a>
									<span id="rowcount_2">1</span>
									<a href="javascript:fnAdd(0, 2);" class="add">+</a>
								</div>
							</td>
							<td>1</td>
							<td><textarea id="opinion_2_1"></textarea></td>
							<td><textarea id="feedback_2_1"></textarea></td>
						</tr>
					</tbody>
				</table>
				</c:if>
				<c:if test="${cData!=null and cData!=''}">
				<p id="title">${data.currname} 설문조사 결과 및 피드백</p>
				<table id="survey_comment" cellpadding="0" cellspacing="0">
					<thead>
						<tr>
							<th width="150">구분</th>
							<th width="150">연번</th>
							<th width="460">의견</th>
							<th width="460">피드백</th>
						</tr>
					</thead>
					<tbody>
						<c:set var="opinion" value="${fn:split(cData.opinion, '∫') }"/>
						<c:set var="feedback" value="${fn:split(cData.feedback, '∫') }"/>
						<c:set var="o" value="${fn:split(opinion[0], '∮') }"/>
						<c:set var="f" value="${fn:split(feedback[0], '∮') }"/>
						<tr class="row_1">
							<td rowspan="${fn:length(o) }">
								관리관련<c:if test="${role!='E' and role!='C' and role!='U'}"><br>
								<div class="ar_table">
									<a href="javascript:fnAdd(1, 1);" class="remove">-</a>
									<span id="rowcount_1">${fn:length(o) }</span>
									<a href="javascript:fnAdd(0, 1);" class="add">+</a>
								</div></c:if>
							</td>
							<td>1</td>
							<c:if test="${role!='E' and role!='C' and role!='U'}">
							<td><textarea id="opinion_1_1">${o[0]!='n'? o[0]:'' }</textarea></td>
							<td><textarea id="feedback_1_1">${f[0]!='n'? f[0]:'' }</textarea></td>
							</c:if>
							<c:if test="${role=='E' or role=='C' or role=='U'}">
							<td style="padding: 5px;">${o[0]!='n'? o[0]:'' }</td>
							<td style="padding: 5px;">${f[0]!='n'? f[0]:'' }</td>
							</c:if>
						</tr>
						<c:forEach var="c" begin="2" end="${fn:length(o) }">
						<tr>
							<td>${c }</td>
							<c:if test="${role!='E' and role!='C' and role!='U'}">
							<td><textarea id="opinion_1_${c }">${o[c-1]!='n'? o[c-1]:'' }</textarea></td>
							<td><textarea id="feedback_1_${c }">${f[c-1]!='n'? f[c-1]:'' }</textarea></td>
							</c:if>
							<c:if test="${role=='E' or role=='C' or role=='U'}">
							<td style="padding: 5px;">${o[c-1]!='n'? o[c-1]:'' }</td>
							<td style="padding: 5px;">${f[c-1]!='n'? f[c-1]:'' }</td>
							</c:if>
						</tr>
						</c:forEach>
						<c:set var="o" value="${fn:split(opinion[1], '∮') }"/>
						<c:set var="f" value="${fn:split(feedback[1], '∮') }"/>
						<tr class="row_2">
							<td rowspan="${fn:length(o) }">
								강사관련<c:if test="${role!='E' and role!='C' and role!='U'}"><br>
								<div class="ar_table">
									<a href="javascript:fnAdd(1, 2);" class="remove">-</a>
									<span id="rowcount_2">${fn:length(o) }</span>
									<a href="javascript:fnAdd(0, 2);" class="add">+</a>
								</div></c:if>
							</td>
							<td>1</td>
							<c:if test="${role!='E' and role!='C' and role!='U'}">
							<td><textarea id="opinion_2_1">${o[0]!='n'? o[0]:'' }</textarea></td>
							<td><textarea id="feedback_2_1">${f[0]!='n'? f[0]:'' }</textarea></td>
							</c:if>
							<c:if test="${role=='E' or role=='C' or role=='U'}">
							<td style="padding: 5px;">${o[0]!='n'? o[0]:'' }</td>
							<td style="padding: 5px;">${f[0]!='n'? f[0]:'' }</td>
							</c:if>
						</tr>
						<c:forEach var="c" begin="2" end="${fn:length(o) }">
						<tr>
							<td>${c }</td>
							<c:if test="${role!='E' and role!='C' and role!='U'}">
							<td><textarea id="opinion_2_${c }">${o[c-1]!='n'? o[c-1]:'' }</textarea></td>
							<td><textarea id="feedback_2_${c }">${f[c-1]!='n'? f[c-1]:'' }</textarea></td>
							</c:if>
							<c:if test="${role=='E' or role=='C' or role=='U'}">
							<td style="padding: 5px;">${o[c-1]!='n'? o[c-1]:'' }</td>
							<td style="padding: 5px;">${f[c-1]!='n'? f[c-1]:'' }</td>
							</c:if>
						</tr>
						</c:forEach>
					</tbody>
				</table>
				</c:if>
			</div>
		</div>

		</c:if>
		<c:if test="${list==null or fn:length(list)==0}">
		+
		<div class="not_found" style="padding-top: 0;border-bottom: 1px solid #ececec;">설문 내역이 없습니다</div>
		</c:if>
		<div class="btns_center">
			<utils:authority url="/rad/curr/surveyComment.kh">
			<a href="javascript:fnSave();" class="btn">설문조사 결과 및 피드백 저장</a>
			</utils:authority>
			<a href="javascript:fnPrint();" class="btn">인쇄하기</a>
			<a href="${pageContext.request.contextPath}/rad/curr/survey.kh?cpage=${params.cpage}&branch=${params.branch}&searchKey=${params.searchKey}&surveing=${params.surveing}&searchValue=${params.searchValue}" class="btn">목록으로 돌아가기</a>
		</div>
	</div>
	<jsp:include page="/WEB-INF/jsp/rad/common/_${sessionScope.aduser.site_id }/footer_2018.jsp"/>
</body>
</html>