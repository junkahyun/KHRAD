<%@ page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 		uri="/WEB-INF/tlds/c.tld" %> 
<%@ taglib prefix="fn" 		uri="/WEB-INF/tlds/fn.tld" %>
<%@ taglib prefix="fmt"		uri="/WEB-INF/tlds/fmt.tld" %>
<%
	Calendar cal = Calendar.getInstance();
	String year = cal.get(Calendar.YEAR) + "";
%>
<script>

	function cacaulateDate(completion_date){
		let split_date = completion_date.split('.');
		let change_type_date = new Date(split_date[0], split_date[1]-1, split_date[2]);
		let count = 0;
		
        var tmp = change_type_date.getDay();
        switch (tmp) {
			case 1:
			case 2:
			case 3:
			case 4:
				count = 1;
				break;
			case 5:	
				count = 3;
				break;
			default:
				break;
		}
        change_type_date.setDate(change_type_date.getDate() + count);   
        change_type_date.setMonth(change_type_date.getMonth() + 1);   
        
       	return change_type_date.getFullYear() + '. ' +  change_type_date.getMonth() + '. ' +change_type_date.getDate();
	}
	
	function setRequireValue(no, completion_date) {
		date = cacaulateDate(completion_date);
		
		if(no !== ''){
			$("#pre_require_no").val(no);
		}
		if(completion_date !== ''){
			$("#start_date").val(date);
		}
		$('#pre_require_div').hide();
	}
</script>
<style>
    .passFinder_list_li {font-size: 13px; padding-bottom: 7px; cursor: pointer; font-weight: 300;}
    .passFinder_list_li:hover {color: black;}
    .passFinder_list_li_category{font-size: 13px; padding-bottom: 7px; cursor: pointer; font-weight: 300; color:#ff554d;}
    #board_search .board_search_line div {text-align: left;}
</style>
<div>
<c:if test="${fn:length(list) != 0 }">
    <ul>
        <c:forEach items="${list}" var="data">
        	<%-- <c:if test="${params.searchID == 'pre_require_div'}"> --%>
            <li onClick="setRequireValue('${data.no}', '${data.completion_date}')" class="passFinder_list_li">
                ${data.no}번 - ${data.require_title}(담당자 : ${data.charger_name})
            </li> 
        </c:forEach>
    </ul>
</c:if>
<c:if test="${fn:length(list) == 0 }">
    <ul>
        <li class="passFinder_list_li">
            등록된 요구사항이 없습니다.
        </li>    
    </ul>
</c:if>
</div>