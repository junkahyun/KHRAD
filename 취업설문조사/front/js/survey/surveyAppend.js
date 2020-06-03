/**
 * 설문조사 학생 결과 append
 */
function pushResult(target_value){
	return target_value + "¶" ;
}

function alertMessage(i){
	alert("질문에 대한 답을 선택해주세요. 질문번호 : "+i);
}

//(설문조사 3차) 필수 항목 미선택 알림  
function alertMessage2(i, j){
	$("span#q"+i+"_"+j+"").css("display", "block");
}

function alertMessage3(i, j){
	$("span#sol"+i+"_"+j+"").css("display", "block");
}

function alertMessage4(i, j){
	$("span#tip"+i+"_"+j+"_2").css("display", "block");
}

/** 객관식, 주관식인 경우 학생답변 데이터 */
function appendResult(result, count, i){
	for(var i = i; i <= count; i++){
		var class_name = $("#q" + i).attr('class');
		if (class_name === 'multiple') {
			if ($("input:radio[name=q"+i+"]:checked").val() === undefined || $('input[name=q'+i+']:checked').val() === undefined) {
				alertMessage(i);
				return true;
			}
			else {
				result += $('input[name=q'+i+']:checked').val();
				let checked_id =  $('input[name=q'+i+']:checked').attr('id');
				var answer = $('#q'+i+'_a_cont').val();
				
				/** 항목을 기타로 선택한 경우만 input값을 가져오도록 변경 */
				if($('#'+checked_id+'').attr('data-text') !== '기타' && $('#'+checked_id+'').attr('data-text') !== undefined){
					answer = '';
				}
				
				if ($('#q'+i+'_a_cont').css('display') != 'none' && answer != undefined && answer != '') {
					result += ("§" + answer.replace(/"/g, '\\"').replace(/'/g, "\\'"));
				}
			}
		}

		if (class_name === 'single') {
			var answer = $('#q'+i+'_a_cont').val();
			if(answer === ''){
				alertMessage(i);
				return true;
			}
			else{
				result += answer.replace(/"/g, '\\"').replace(/'/g, "\\'");
			}
		}

		if (i != count) {
			result += "¶";
		} 
	}
	
	return result;
}


/** 표형식인 경우 학생답변 데이터 */
function appendTableResult(result, count, i, curr_classify){
	
	if(curr_classify == 'S'){
		lang_value =  $("#q1_17").val();
		if(lang_value.length == 0){
			$("#q1_17").val("없음");
		}
	
		lang_score_value =  $("#q1_18").val();
		if(lang_score_value.length == 0){
			$("#q1_18").val("-");
		}		
	}
	
	if(curr_classify == 'J'){
		if (i =='1'){
			lang_value =  $("#q1_25").val();
			if(lang_value.length == 0){
				$("#q1_25").val("없음");
			}
		
			lang_score_value =  $("#q1_26").val();
			if(lang_score_value.length == 0){
				$("#q1_26").val("-");
			}
		}		
	}
	
	for(var i = i; i <= count; i++){
		let qname = document.getElementsByName('q'+i+'');
		let q_length = qname.length;
		let target_value = '';
		
		if(q_length > 1){ // 같은 name인 여러개인 경우 = 표형식임.
			for(var j = 1; j <= q_length; j++){
				if($("input:radio[name=q"+i+"_"+j+"]:checked").val() !== undefined){
					target_value = $("input:radio[name=q"+i+"_"+j+"]:checked").val();
					result += pushResult(target_value);
					
					/** 취업관리 > 학생취업 항목 데이터 추가_2020.05.28 */
					let radio_attr = $("input:radio[name=q"+i+"_"+j+"]:checked").attr('data-attribute');
					if(radio_attr !== undefined){
						if(target_value === '1'){
							$('#hope_reside').val('자취');
						}
						else{
							$('#hope_reside').val('출퇴근');
						}
					}
				}
				else if($("#q"+i+"_"+j+"").val() !== ''){
					target_value = $("#q"+i+"_"+j+"").val();
					result += pushResult(target_value);
				}
				else if($("textarea[name=q"+i+"_"+j+"]").val() !== undefined){
					target_value = $("textarea[name=q"+i+"_"+j+"]").val();
					result += pushResult(target_value);
				}
				else if($("#q"+i+"_"+j+" option:selected").val() !== undefined){
					target_value = $("#q"+i+"_"+j+" option:selected").val();
					result += pushResult(target_value);
				}
				else{
					alertMessage(i);
					return;
				}
			}
		}
		else{// 객관식, 주관식인 경우
			// 설문조사 3차 5번 유효성검사 및 알림창 		
			let answer = $('#q'+i+'_a_cont').val();
			
			if(answer === ''){
				answer = '없음';
			}
			
			result += answer.replace(/"/g, '\\"').replace(/'/g, "\\'");
		}
	}
	
	return result;
}