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
</style>
<script>
/* 페이지 로딩시 반드시 실행되어야 하는 함수입니다. */
(function(){
	
})();


</script>

<div id="view_modify" style="margin-bottom:0px;">
<table cellpadding="0" cellspacing="0" class="" style="width:665px;">
	<c:if test="${fn:length(list) > 0}">
	<c:forEach var="data" items="${list}"> 
	<tr>
		<th>이름</th>
		<td >
			${data.name}
		</td>
		<th >연락처</th>
		<td > 
			${data.mobile}
		</td>
		<th >가입날짜</th>
		<td > 
			${fn:substring(data.reg_date,0,4)}.${fn:substring(data.reg_date,4,6)}.${fn:substring(data.reg_date,6,8)}
		</td>
		<c:if test="${data.quest_no == null}" >
		<td class="comment_btns" >
			<a id="btn_memoSave" class="btn" href="javascript:fnUserCheckSave('${data.stdt_no}','${params.quest_no}','${params.counselor}');" style="background:#2a2a4e;">확인</a>
		</td>
		</c:if>
		<c:if test="${data.quest_no != null}" >
		<td style="text-align: center;">
			<a id="btn_memoSave" class="btn" style="background:#fb606b;">완료</a>
		</td>
		</c:if>
	</tr>
	</c:forEach>
	</c:if>
	<c:if test="${fn:length(list) <= 0}">
	<tr>
		<td style="text-align: center;">
		가입된 학생이 존재하지 않습니다.
		</td>
	</tr>
	</c:if>
</table>
</div>