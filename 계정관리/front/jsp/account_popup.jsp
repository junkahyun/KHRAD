<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 		uri="/WEB-INF/tlds/c.tld" %> 
<%@ taglib prefix="fn" 		uri="/WEB-INF/tlds/fn.tld" %>
<%@ taglib prefix="fmt"		uri="/WEB-INF/tlds/fmt.tld" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<style>
.popupBg {display: none;position: absolute;top: 0;left: 0;z-index: 98;width: 100%;height: 335%; background: #000000;opacity: 0.4;}
input, textarea {font-family: 'Malgun Gothic', '맑은 고딕', '돋움', Dotum, sans-serif;}
.account_popup {width:340px; font-family: 'Noto Sans KR', NanumGothic, Arial, Helvetica, sans-serif, "굴림체"; font-size:13px; letter-spacing:-1px; color: #3e3e3e;}
.nameK { font-size:18px; font-weight:500; color:#fff; }
.nameE{ letter-spacing:0; font-weight:200; line-height:17px; color:#fff; }
.sosok{font-weight:200; margin-top:8px; color:#fff; }
.top .img{position:absolute; bottom:-63px; left:50%; margin-left:-63px; width:125px; height:125px;-o-border-radius:50%;
	-moz-border-radius:50%;
	-ms-border-radius:50%;
	-webkit-border-radius:50%;
	border-radius: 50%;
	-webkit-box-shadow:0 8px 15px 1px rgba(0, 0, 0, 0.1);
	-moz-box-shadow:0 8px 15px 1px rgba(0, 0, 0, 0.1);
	box-shadow:0 8px 15px 1px rgba(0, 0, 0, 0.1);}
.btncom_account{ height:34px; position:relative; text-align:center;}
.btncom_account a{cursor: pointer; color:#fff; display:block; padding: 10px 25px; letter-spacing: -0.5px; border-radius:19px; font-size:13px;}
.pop_btn{ position:absolute; left:79.5px; bottom:-1px; width:34px;}
.pop_close{background:#2a2a4e; position:absolute; right:80px; bottom:-1px;}
.mid .midbox1 ul li p span { color: #7a7a7a; font-weight: 300; font-size: 13px;}
.mid .midbox2 {width:197px; max-height:230px;margin:0 auto; padding:26px 0px; text-align:left;}
.mid .midbox2 ul { margin:0 auto; width:235px; font-weight:300;}
.jojicPopup>.bot{text-align:center; border: 1px solid #f3f5f7;border-top: 0; border-bottom:0; padding-bottom:51px; box-sizing:border-box; }
.jojicPopup>.mid>.midbox2>ul>li{margin-bottom: 5px;}
</style>
<div class="top accountTop" >
	<p class="nameK">${data.name} ${data.dept}</p>
	<p class="nameE">${data.engname}</p>
	<p class="sosok">${fn:replace(data.department, '/', ' / ')}</p>
	<div class="img" style="background: url(${pageContext.request.contextPath}/upload/profile/${(data.thumnail == null or empty data.thumnail)?'empty.jpg':data.thumnail}) no-repeat; background-size: cover;"></div>
</div><!--class="top"-->
<div class="mid">
	<div class="midbox1">
		<ul>
			<li style="width: 80px;"><p><span class="attachName">소속</span><br/><span class="black" style="color:#3e3e3e; font-size:15px; font-weight:500; letter-spacing:-0.5px;">${data.attachname}</span></p></li>
			<li class="line"></li>
			<li style="width: 80px;"><p><span>입사일</span><br/><span class="black" style="color:#3e3e3e; font-size:15px; font-weight:500; letter-spacing:-0.5px;">${data.join_date}</p></li>
			<li class="line"></li>
			<li style="width: 80px;"><p><span>재직여부</span><br><span class="black" style="color:#3e3e3e; font-size:15px; font-weight:500; letter-spacing:-0.5px;">${data.isoffice == 'I'?'재직':'퇴사'}</span></p></li>
		</ul>
	</div><!--class="midbox1"-->
	<div class="midbox2" style="margin: 0 auto;">
		<ul>
			<li><p>아&nbsp;&nbsp;이&nbsp;&nbsp;디&nbsp; : &nbsp;${data.id}</p></li>
			<li><p>생년월일&nbsp; : &nbsp;${data.birth}</p></li>
			<li><p>휴대번호&nbsp; : &nbsp;${data.mobile}</p></li>
			<c:set  var="iei" value="iei.or.kr"/>
			<c:set  var="atents" value="atentsgame.com"/>
			<li><p>사내메일&nbsp; : &nbsp;${data.email}</p></li>
			<li><p>사내전화&nbsp; : &nbsp;${data.phone == ''?'-':data.phone}</p></li>
			<li><p>네이트온&nbsp; : &nbsp;${data.messanger }</p></li>
			<li><p>개인메일&nbsp; : &nbsp;${data.p_email}</p></li>
			<li><p id="accNum">은행계좌&nbsp; : &nbsp;<c:if test="${data.bank ne null and data.bank ne ''}">${data.bankname}(${data.account})</c:if></p></li>
			<li><p>주&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;소&nbsp; : &nbsp;${data.address}</p></li>
			<c:if test="${data.isoffice == 'O'}">
			<li><p>퇴&nbsp;&nbsp;사&nbsp;&nbsp;일&nbsp; : &nbsp;${data.out_date}</p></li>
			</c:if>
		</ul>
	</div><!--class="midbox2"-->
</div><!--class="mid"-->
<div class="bot">
	<div class="btncom_account">
		<a href="javascript:fnApply('${data.no}');" style="" class="pop_btn" id="pop_${data.no}">수정</a>
		<a href="javascript:orgPopupClose();" class="pop_close">창닫기</a>
	</div>
</div><!--class="bot"-->

<script>
	(() => {
		fnChangePopColor();
		fnAccountDown();
	})();
	
	/* 팝업 수정버튼,배경색,이름 변경입니다. */
	function fnChangePopColor(){
		const site_id = "${sessionScope.aduser.site_id}";
		const changePopColor = {
				kh : (() => {
					$(".pop_btn").attr('style','background:#ff626c;');
					$(".accountTop").css({"background":"#3b84ff"});
					$(".attachName").text("소속");
				}),
				atents : (() => {
					$(".pop_btn").attr('style','background:#36d3b6;');
					$(".accountTop").css({"background":"#ff554d"});
					$(".attachName").text("근무지점");
				})
		}
		changePopColor[site_id]();
	}
	
	/* 계좌번호가 길때 아래로 떨어뜨려서 보기위한 함수입니다. */
	function fnAccountDown(){
		const account = $("#accNum").text();
		if(account !== '' || account !== null){
			if(account.length > 33 ){
				$("#accNum").empty().html("은행계좌&nbsp; : &nbsp;<c:if test='${data.bank ne null}'>${data.bankname}<p style='margin-left:60px'>(${data.account})</p></c:if></p>")
				$(".btncom_account").css("height","67px");
			}
		}
	}
	
	function orgPopupClose() {
		$('.jojicPopup').fadeOut();
		$('.popupBg').fadeOut();
		
		$('html').off('scroll touchmove mousewheel');
	}
</script>