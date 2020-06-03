<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 		uri="/WEB-INF/tlds/c.tld" %> 
<%@ taglib prefix="fn" 		uri="/WEB-INF/tlds/fn.tld" %>
<%@ taglib prefix="fmt"		uri="/WEB-INF/tlds/fmt.tld" %>
<%@ taglib prefix="utils"	uri="/WEB-INF/tlds/utils.tld" %>
<%@ page import="com.kh.utils.Utils"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.net.URL"%>
<!DOCTYPE html>
<c:set var="id" value="${sessionScope.aduser.id}"/>
<c:set var="site_id" value="${sessionScope.aduser.site_id}"/>
<c:set var="role_code" value="${sessionScope.aduser.role_code }"/>
<style>
.popup_btns .btn {padding: 4px 31px; letter-spacing:-0.5px; border-radius:19px; margin-left:10px; font-size:13px;}
input[type=tel]{width: 44px;
    height: 34px;
    margin-right: 10px;
    font-size: 13px;
    cursor: pointer;
    text-align: center;
    padding: 2px;
    line-height: 19px;
    border: 1px solid #ececec;
    margin: 1px;}
</style>
<div class="bg" onclick="fnClosePopup();"></div>
    <div class="popup" style="margin-top: -298.5px; margin-left: -485px;">
        <div class="popup_title_edit"><img src="${pageContext.request.contextPath }/resources/images/rad/popup_x_${site_id}.png" class="x_img" onclick="fnClosePopup();">계정정보 수정</div>
	        <div class="popup_content account" style="position: relative; ">
	            <div class="information_wrap">
	                <table class="scrolltable" cellpadding="0" cellspacing="0" style="border-bottom: 1px solid #ececec;">
	                    <tbody>
	                        <tr>
	                            <th rowspan="4">사진</th>
	                            <td rowspan="4">
		                            <img id="preview_photo" alt="" width="143px" style="border: #ececec 1px solid;" usemap="#pp_map" class="profile_img"
		                                 src="${pageContext.request.contextPath}/upload/profile/${data.thumnail}"
		                                 onerror="this.src='${pageContext.request.contextPath}/resources/images/account_basic${site_id == 'kh' ?'':'_atents'}.jpg'">
			                        <map name="pp_map" id="pp_map">
			                            <area shape="rect" coords="0, 0, 150, 150" href="javascript:fnThumnail();" alt="프로필 이미지 변경">
			                        </map>
			                        <form id="pform" name="pform" action="" method="post" enctype="multipart/form-data">
			                        <input type="file" id="thumnail_photo" name="thumnail_photo" style="display: none;">
			                        </form>
	                            </td>
							</tr>
							<tr>
	                            <th>소속(4대보험)</th>
	                            <td>
									<select id="attach" name="commonInput">
		                            	<option value="2">강남</option>
		                                <option value="6">종로</option>
		                                <option value="10">당산</option>
		                                <option value="7">이태원</option>
		                                <option value="12">인포텍</option>
		                                <option value="11">아텐츠</option>
	                                </select>
	                            </td>
	                            <th>재직여부</th>
	                            <td id="isStaus">${data.isoffice == 'I' ? '재직':'퇴사'}</td>
	                        </tr>
							<tr>
	                            <th>근무지원/부서</th>
	                            <td>
	                                <input type="text" id="department" name="commonInput"  readonly="true" onclick="fnSelectDepartment(0);" value="${data.department}">
	                                <input type="hidden" id="dept_code" name="commonInput" value="${data.dept_code}">
	                            </td>
	                            <th>직급/직책</th>
	                            <td>
	                                <select id="dept" name="commonInput">
	                                <option value="선택" selected="selected">선택</option>
	                                <option value="대표">대표</option>
	                                <option value="이사">이사</option>
	                                <option value="부사장">부사장</option>
	                                <option value="원장">원장</option>
	                                <option value="부원장">부원장</option>
									<option value="본부장">본부장</option>
	                                <option value="지원장">지원장</option>
	                                <option value="학과장">학과장</option>
	                                <option value="소장">소장</option>
	                                <option value="부장">부장</option>
	                                <option value="과장">과장</option>
	                                <option value="실장">실장</option>
	                                <option value="팀장">팀장</option>
	                                <option value="대리">대리</option>
	                                <option value="주임">주임</option>
	                                <option value="사원">사원</option>
	                                <option value="강사">강사</option>
	                                </select>
	                            </td>
	                        </tr>
	                        <tr>
	                            <th>휴대전화</th>
	                            <td>
									<input type="tel" id="mobile0" maxlength="3" value="${fn:split(data.mobile,'-')[0]}">-
									<input type="tel" id="mobile1" maxlength="4" value="${fn:split(data.mobile,'-')[1]}">-
									<input type="tel" id="mobile2" maxlength="4" value="${fn:split(data.mobile,'-')[2]}">
								</td>
	                            <th>사내전화</th>
	                            <td>
	                            	<input type="tel" id="phone0" maxlength="3" value="${fn:split(data.phone,'-')[0]}">-
									<input type="tel" id="phone1" maxlength="4" value="${fn:split(data.phone,'-')[1]}">-
									<input type="tel" id="phone2" maxlength="4" value="${fn:split(data.phone,'-')[2]}">
								</td>
	                        </tr>
							<tr>
	                            <th>이름</th>
	                            <td>
	                                <input type="text" id="name" name="commonInput" value="${data.name}">
	                            </td>
								<th>개인메일</th>
								<td>
									<input type="text" id="p_email" name="commonInput" value="${data.p_email}">
								</td>
							   <th>사내메일</th>
								<td>
									<input type="text" id="email" name="commonInput" value="${data.email}">
								</td>
							</tr>
	                        <tr>
								<th>영문이름</th>
								<td>
									<input type="text" id="engname" name="commonInput" value="${data.engname}">
								</td>
	                            <th>입사일</th>
	                            <td>
									<input type="text" id="join_date">
								</td>
	                            <th>네이트온</th>
								<td>
									<input type="text" id="messanger" name="commonInput" value="${data.messanger}"> 
								</td>
						   </tr>
	                        <tr>
	                            <th>아이디</th>
	                            <td>
									<input type="text" id="id" name="commonInput" value="${data.id}" disabled="disabled">
								</td>
	                            <th>수습기간</th>
	                            <td>
									<select id="fix_month" name="commonInput">
										<option value="">선택</option>
										<option value="수습없음" style="color:#222;">수습없음</option>
										<option value="수습1개월" style="color:#222;">수습1개월</option>
										<option value="수습2개월" style="color:#222;">수습2개월</option>
	                                </select>
								</td>
								<th>은행</th>
								<td>
									<select id="bank" name="commonInput">
										<option value="IBK" selected="selected">기업은행</option>
										<option value="KB">국민은행</option>
										<option value="SHIN">신한(구조흥)은행</option>
										<option value="KEB">KEB하나(구외환)은행</option>
										<option value="SC">SC제일은행</option>
										<option value="CITI">한국씨티은행</option>
										<option value="KAKAO">카카오뱅크</option>
										<option value="KHCC">새마을금고</option>
										<option value="EPOST">우체국</option>
										<option value="NH">농협</option>
										<option value="SH">수협</option>
										<option value="CU">신협</option>
									</select>
								</td>
	                        </tr>
	                        <tr>
	                            <th>생일</th>
								<td colspan="3">									
									<input type="text" id="birth">
									<input name="yu" type="radio" class="txt2" id="yu_0" value="0"/>
									<label for="yu_0">양력</label>
									<input name="yu" type="radio" class="txt2" id="yu_1" value="1"/>
									<label for="yu_1">음력</label>
								</td>
								<th>계좌번호</th>
								<td>
									<input type="text" id="account" name="commonInput" maxlength="20" onkeypress="numeric();" onkeyup="fnToNext(this);" onkeydown='return onlyNumber(event)' style="IME-MODE:disabled;" value="${data.account}">
								</td>
	                        </tr>
	                        <tr>
	                            <th>주소</th>
	                            <td colspan="3"><input type="text" id="address" name="commonInput" style="width:489px; text-align:left;" value="${data.address}"></td>
								<th>퇴사일</th>
								<td>
									<input type="text" id="out_date">
									<input type="hidden" id="ret_del" value="${data.ret_del}">
								</td>
	                        </tr>
	                        
	                        <tr class="onlyManager">
	                            <th>직무</th>
	                            <td>
									<select id="role_code" name="commonInput">
									<option value="선택" selected="selected">선택</option>
									<c:forEach var="roleObj" items="${roleList}" varStatus="vs">
                                   		<c:if test="${vs.count != 2 and vs.count != 3 and roleObj.name != 'AM'}">
                                    	<option value="${roleObj.name }" >${roleObj.description }</option>
                                    	</c:if>
	                                </c:forEach>
	                                <option value="없음">없음</option>
	                                </select>
								</td>
	                            <th>관리자</th>
	                            <td>
	                            	<ul>
	                            	<li>
	                            		<input type="radio" id="is_manager_y" style="cursor: pointer;" name="is_manager" value="Y"/>
	                            		<label for="is_manager_y">예&nbsp;&nbsp;</label>

	                            		<input type="radio" id="is_manager_n" style="cursor: pointer;" name="is_manager" value="N"/>
	                            		<label for="is_manager_n">아니오</label>
	                            	</li>
	                            	</ul>
	                            </td>
	                            <th>비고</th>
	                            <td>
	                            	<input type="text" id="etc" name="commonInput" value="${data.etc}">
	                            </td>
	                        </tr>
	                        <tr class="onlyManager">
	                            <th style="border-bottom:0px;">권한</th>
	                            <td colspan="5">
	                                <c:forEach var="roleObj" items="${roleList}" varStatus="vs">
	                                    <c:if test="${vs.count % 5 == 1}">
	                                    <ul class="role_cont">
	                                    </c:if>
	                                    <li>
                                            <input name="role_${roleObj.pos}" type="checkbox" value="${roleObj.pos}" class="txt2 autho" id="role_${roleObj.pos}" />
                                            <label for="role_${roleObj.pos}">${roleObj.description}</label>
	                                    </li>
	                                    <c:if test="${vs.count % 5 == 0}">
	                                    </ul>
	                                    </c:if>
	                                </c:forEach> 
	                            </td>
	                        </tr>
	                        <!-- 끝 -->
	                        
	                        <!-- 퇴직자, 퇴직신청자만 보임 -->
	                        <tr class="onlyRetire">
	                            <th>요청자</th>
	                            <td>
									<span id="ret_writer">${data.ret_writer}</span>
								</td>
	                            <th>퇴직예정일</th>
	                            <td>
									<span id="ret_date">${fn:substring(data.ret_date,0,4)}. ${fn:substring(data.ret_date,5,8)}. ${fn:substring(data.ret_date,9,12)}</span>
								</td>
	                            <th id="ret_down">사직서 다운로드</th>
	                            <td>
									<div class="file_down">
										<c:set var="retFile" value="${fn:split(data.ret_fileupload,'|')}"/>
										<img src='${pageContext.request.contextPath}/resources/images/rad/file.png' class='file_att'>
										<span id="rfile_name" onclick="doFileDownload('${retFile[0]}','${retFile[1]}','${data.no}', 'retire');">
										<!-- 파일이름이 긴 경우 ...을 붙힙니다. -->
										<c:if test="${fn:length(retFile[1]) > 18}">
										${fn:substring(retFile[1],0,9)}....
										</c:if> 
										
										<c:if test="${fn:length(retFile[1]) <= 18}">
										${retFile[1]}
										</c:if> 
										</span>
									</div>
								</td>
	                        </tr>
							 <tr class="onlyRetire">
	                           <th style="border-bottom:0px;">퇴직사유</th>
	                           <td colspan="5">${data.ret_reason}</td>
	                           <!-- <input type="text" name="commonInput" placeholder="개인사유, 대학 진학으로 퇴사, 회사 복지에 대한 불만 등등" style="width:803px; text-align:left;" id="ret_reason" name="ret_reason" value=""> -->
	                        </tr>
	                        <!-- 끝 -->
	                        
	                    </tbody>
	                </table>
	            </div>
	            
            <div class="popup_btns">
				<a href="javascript:fnvalidate();" class="btn" id="savebutton" style="background : ${site_id == 'kh' ? '#ff626c' : '#36d3b6'};">${data.role_code == '없음' ? '승인완료':'수정'}</a>
                <a href="javascript:fnClosePopup();" class="btn" style="background:#2a2a4e;">취소</a>
            </div>
        </div>
    </div>
	    
<!-- 권한관련 -->
<div class="popup_wrap" id="popup_authority">
	<div class="bg" onclick="fnClosePopup();"></div>
	<div class="popup" style="width: 600px;">
		<div class="popup_title">허용권한</div>
		<div class="popup_content">
			<div id="viewAuthority">
			
			</div> 
			<div class="popup_btns">
				<a href="javascript: $('#popup_authority').fadeOut();" class="btn">닫기</a>
			</div>
		</div>
	</div>
</div>
<!-- 끝 -->
		
<!-- 조직도 팝업 -->
<div class="popup_wrap" id="popup_department">
	<div class="bg" onclick="fnClosePopup();"></div>
	<div class="popup" style="width: 300px;">
		<div class="popup_title">조직도</div>
		<div class="popup_content">
			<div id="viewOrg" style="display: block; height: 250px; overflow: auto;">
			
			</div> 
			<div class="popup_btns">
				<a href="javascript: $('#popup_department').fadeOut();" class="btn">닫기</a>
			</div>
		</div>
	</div>
</div>

<script>
	var site_id = "${site_id}";

	(function (){
		mkCalendar('join_date', 0, 'downMonthpop');
		mkCalendar('out_date', 0, 'downMonthpop');
		mkCalendar('birth', 0, 'downMonthpop');
		
		fnSettingRoleCheck();
		fnSettingProp();
		fnSettingDate();
		fnSettingAuthority();
		
		$('#thumnail_photo').on('change',fnOkThumnail);
	})();
	
	function fnRetrieveOrg() {
		myTree = new dhtmlXTreeObject("viewOrg","100%","100%",0); // 팝업css 세팅
		myTree.setXMLAutoLoading("${pageContext.request.contextPath}/rad/auth/org/orgTree.kh");//팝업 요소 로딩
		myTree.setImagePath("${pageContext.request.contextPath}/resources/js/dhtmlx/suite/skins/web/imgs/dhxtree_web/");//팝업 이미지 경로
		myTree.setDataMode("xml");
		myTree.load("${pageContext.request.contextPath}/rad/auth/org/orgTree.kh?id=1");//KH정보교육원
		myTree.setOnClickHandler(onTreeitemClick);// 팝업요소 클릭이벤트
	}
	
	function onTreeitemClick(itemId,type){
		$('#popup_department').fadeOut();
		if(orgFlag == 0) {
			$('#dept_code').val( itemId );
			$.ajax({
				  url		: '${pageContext.request.contextPath}/rad/auth/accountOrgHierarchy.kh'
				, data		: {no : itemId}
				, dataType	: 'json'
				, type		: 'post'})
				.success(function(data, textStatus) {
					var dept = data['parentOrgs'];
					if(site_id == 'kh'){
						$("#department").val( dept.split("_").slice(1).join("/") );
					}
					else if(site_id == 'atents'){
						$("#department").val( dept.split("_").slice(0).join("/") );
					}
				})
				.error(function(jqXHR, textStatus, errorThrown) {
					alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
				})
		}
		else {
			$("#dept_code4search").val(itemId);
			$("#cpage").val(1);
			document.frm.submit();
		}
	}
	
	function fnSettingRoleCheck(){
		let role = "${role_code}";
		let id = "${id}";
		let roleArr = ["AM", "SM", "EO", "nocturn93", "hay4863", "ghdthdud0806"];
		let settingRole = 0;
		
		for(let i=0; i<roleArr.length; i++){
			if(role.indexOf(roleArr[i]) !== -1 || id.indexOf(roleArr[i]) !== -1){
				settingRole = 1;
			}
		}
		
		if(settingRole === 1){
			$("#id").attr("disabled","disabled");
			$(".onlyManager").show();
			$(".information_wrap .scrolltable").css({"overflow":"auto"});
			if("${data.ret_del}" === "0"){
				$(".onlyRetire").hide();
			}
			else if("${data.ret_del}" === "1"){
				$(".onlyRetire").show();
			}//end of if~else------
		}
		else if(settingRole === 0){
			$("#id").attr("disabled","disabled");
			$("#join_date").attr("disabled","disabled");
			$("#out_date").attr("disabled","disabled");
			$(".onlyManager").hide();
			$(".onlyRetire").hide();
			$(".information_wrap .scrolltable").css({"overflow":"hidden"});
		}
	}
	
	function fnSettingProp(){
		const is_manager = "${data.is_manager}";
		
		$("#yu_${data.yu}").prop("checked",true);
		$("#is_manager_"+is_manager.toLowerCase()+"").prop("checked",true);
		$("#attach").val("${data.attach}").prop("selected",true);
		$("#fix_month").val("${data.fix_month}").prop("selected",true);
		$("#bank").val("${data.bank}").prop("selected",true);
		$("#dept").val("${data.dept}").prop("selected",true);
		$("#role_code").val("${data.role_code}").prop("selected",true);
	}
	
	function fnSettingDate(){
		const out_date = "${data.out_date}";
		const join_date = "${data.join_date}";
		const birth = "${data.birth}";
		
		if(out_date !== '. . '){
			stCalendarDateAll("out_date", Number(out_date.split(". ")[0]), Number(out_date.split(". ")[1]), Number(out_date.split(". ")[2]));
		} 
		stCalendarDateAll("join_date", Number(join_date.split(". ")[0]), Number(join_date.split(". ")[1]), Number(join_date.split(". ")[2]));
		stCalendarDateAll("birth", Number(birth.split(". ")[0]), Number(birth.split(". ")[1]), Number(birth.split(". ")[2]));
	}
	
	function fnSettingAuthority(){
		var mask = 0;
		if("${data.authority}" !== null){
			<c:forEach var="roleObj" items="${roleList}" varStatus="vs">
			mask = (1 << ${roleObj.pos });
			if( ("${data.authority}" & mask) == mask ) {
				$("[name=role_" + ${roleObj.pos} + "]").prop("checked", true);
			}
			else{
				$("[name=role_" + ${roleObj.pos} + "]").prop("checked", false);
			}
			</c:forEach>
		} 
		else if("${data.authority}" === null){
			$(".autho").prop("checked", false);
		}
	}
	
	function fnThumnail(){
		$("#thumnail_photo").click();
	}

	function fnOkThumnail(e){
		var files = e.target.files;
		var file = Array.prototype.slice.call(files)[0];
		var val = file.type.split("/")[1];
		
		if(val=='jpg' || val=='png' || val=='JPG' || val=='PNG' || val=='jpeg' || val=='JPEG'){
			var reader = new FileReader();
			reader.onload = function(e) {
				$("#preview_photo").attr("src", e.target.result);
			}
			reader.readAsDataURL(file);
		} else {
			alert('프로필 사진은 jpg또는 png만 등록할 수 있습니다.');
		}
	}
	
	function fnSelectDepartment(flag){
		orgFlag = flag;
		fnRetrieveOrg();
		fnOpenPopup('department');
	}
	
	function fnvalidate(){
		const ret_del = "${data.ret_del}";	
		let out_date = $("#out_date").val();
		let role_code = $("#role_code").val();
		let authority = 0;
		
		<c:forEach var="roleObj" items="${roleList}" varStatus="vs">
		if($("#role_"+${roleObj.pos}).prop("checked") === true) {
			const pos = Number($("#role_"+${roleObj.pos}).val());
			authority |= (1 << pos);
		}
		</c:forEach>
		
		if(role_code === "선택" || role_code === "없음"){
			alert('직무를 선택해주세요.');
			return;
		}
		if(ret_del === "1" && (out_date === "" || out_date === null)){
			alert("퇴사일을 선택해주세요!");
			return;
		}
		if(authority === 0){
			alert("권한을 선택해주세요.");
			return;
		}
		else{
			fnsubmitAccount(authority);
		}
	}
	
	function fnsubmitAccount(authority){
		/* 승인완료시 이메일 전송을 하기 위해 추가한 값이었습니다. 
		    작업시 메일전송에 관한 확실한 기획이 정해져 있지 않아 주석처리 하였습니다. */
		/* const savebtn = "0";
		if($("#savebutton").text() === "승인완료"){
			savebtn = "1";
		} */
		
		let commonNames = document.getElementsByName("commonInput");
		var userformData = new FormData();
		
		for(let i=0; i<commonNames.length; i++){
			userformData.append(commonNames[i].id , commonNames[i].value); 
		}
		userformData.append("mobile" , $('#mobile0').val()+"-"+$('#mobile1').val()+"-"+$('#mobile2').val());
		userformData.append("phone" , $('#phone0').val()+"-"+$('#phone1').val()+"-"+$('#phone2').val());
		userformData.append("birth" , $("#birth").val());
		userformData.append("join_date" , $("#join_date").val());
		userformData.append("out_date" , $("#out_date").val());
		//userformData.append("branch" , branch);
		userformData.append("yu" , $(":radio[name='yu']:checked").val());
		userformData.append("authority" , authority);
		userformData.append("update_id" , "${id}");
		userformData.append("is_manager" , $(":radio[name=is_manager]:checked").val());		
		userformData.append("sub_no" ,'${params.no}');
		/* 계정관리 팝업에서 퇴사처리를 하게 되는 경우 */
		if($("#isStaus").text().trim() === "재직" && $("#out_date").val() !== ""){
			if(confirm("퇴사처리를 하시겠습니까?") === true){
				userformData.append("category" ,"account_retire");
				ajax(userformData);
				return;
			}
		}
		else if($("#isStaus").text().trim() === "재직" || $("#isStaus").text().trim() === "퇴사"){
			userformData.append("category" ,"account_apply");
			ajax(userformData);
		}
		
	} 
	
	function ajax(userformData){
		$.ajax({
			  url		: '${pageContext.request.contextPath}/rad/auth/accountSave.kh'
			, data		: userformData
			, dataType	: 'json'
			, contentType : false
			, processData : false
			, type		: 'post'
			, success	: function(data, textStatus) {
				var result = data['result'];
				if(result==0) {
					alert('등록에 실패하였습니다.');
				}else {
					var form = $("#pform")[0];
					var formData = new FormData(form);
					formData.append("fileObj", $("#thumnail_photo")[0].files[0]);
					formData.append("id", $("#id").val());
					const RIbtn = "${RIbtn}";
					
					$.ajax({
						url: '${pageContext.request.contextPath}/rad/auth/accountThumSave.kh',
						processData: false,
						contentType: false,
						data: formData,
						type: 'POST',
						success: function(result){
							alert('등록되었습니다.');
							if(RIbtn === "1"){
								fnIsO('A');
							}
							else{
								doPagingClick('${params.cpage}');
							}
						}
					})
				}
			}
			, error		: function(jqXHR, textStatus, errorThrown) {
				alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
			}
		});
	}
</script>