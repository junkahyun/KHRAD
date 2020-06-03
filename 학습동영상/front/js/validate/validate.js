// 필수입력사항 유효성검사
let validate_list = []; // 유효성 체크리스트
let names = []; // 유효성 체크리스트에 들어간 항목리스트(조회용)
let errors = {};

const validate_methods = {
	required: function (object_name, object, validate, message) { // 값이 존재하는지 체크
		if (object.value == null || object.value == "") {
			if(message !== null || message !== ""){
				errors[object_name] = message;
			}
			else{
				errors[object_name] = "필수요소를 입력해주세요.";
			}
			return false;
		}
	},
	checked: function (object_name, object, validate, message) { // 체크여부확인
		if (!object.checked) {
			if(message !== null || message !== ""){
				errors[object_name] = message;
			}
			else{
				errors[object_name] = "필수요소를 체크해주세요.";
			}
			return false;
		}
	},
	radio: function (object_name, object, validate, message) { // 체크여부확인
		if ($("[name=" + object_name + "]:checked").length == 0) {
			if(message !== null || message !== ""){
				errors[object_name] = message;
			}
			else{
				errors[object_name] = "필수요소를 체크해주세요.";
			}
			return false;
		}
	},
	charLeast: function (object_name, object, validate, message) { // 입력값 갯수 최소단위
		const length = validate.split(".")[1];

		if (object.value.length < length) {
			if(message !== null || message !== ""){
				errors[object_name] = message;
			}
			else{
				errors[object_name] = "입력값은 최소 "+ length + "자 이상이어야 합니다.";
			}
			return false;
		}
	},
	charLength: function (object_name, object, validate, message) { // 입력값 갯수 체크
		const length = validate.split(".")[1];
	
		if (object.value.length != 0 && object.value.length != length) {
			if(message !== null || message !== ""){
				errors[object_name] = message;
			}
			else{
				errors[object_name] = length + "자리의 값을 입력해주세요.";
			}
			return false;
		}
	},
	numeric: function (object_name, object, validate, message){  // 입력값 숫자체크
		const pattern = /[\D]/gi;   //패턴을 정의합니다
		const match = pattern.exec(object.value);  //입력된 값을 패턴에 적용한다

		if(match != null){
			if(message !== null || message !== ""){
				errors[object_name] = message;
			}
			else{
				errors[object_name] = "숫자만 입력해주세요.";
			}
			return false;
		}
	},
	mobile: function (object_name, object, validate, message){  // 입력값 숫자체크
		const pattern = /(^[0-9]{3}-[0-9]{2,4}-[0-9]{2,4})/gi;   //패턴을 정의합니다
		const match = pattern.exec(object.value);  //입력된 값을 패턴에 적용한다

		if(match == null){
			if(message !== null || message !== ""){
				errors[object_name] = message;
			}
			else{
				errors[object_name] = "올바른 핸드폰 번호를 입력해주세요.";
			}
			return false;
		}
	},
	jumin: function (object_name, object, validate, message){  // 입력값 숫자체크
		const pattern = /(^[0-9]{6}-[0-9]{7})/gi;   //패턴을 정의합니다
		const match = pattern.exec(object.value);  //입력된 값을 패턴에 적용한다
		const checker = [2, 3, 4, 5, 6, 7, 8, 9, 2, 3, 4, 5]; // 주민번호 체크용 리스트

		if (match == null){
			if(message !== null || message !== ""){
				errors[object_name] = message;
			}
			else{
				errors[object_name] = "올바른 주민번호를 입력해주세요.";
			}
			return false;
		} else {
			const value = object.value;
			const lastValue = value.substr(value.length - 1, value.length);
			// 입력한 주민번호를 마지막 번호를 제외하고 [1,2,3]과 같은 형태의 리스트로 변환
			const values = Array.from(value.substr(0, value.length - 1).replace("-", ""), x => Number(x));
			// values 리스트와 checker 리스트의 같은 index에 위치한 수끼리 곱하고 해당 숫자들을 모두 더한 값
			const sum = (values.map((x, i) => x * checker[i])).reduce((a, b) => a + b);
			let result = (11 - sum % 11) % 10;
			
			if (values[6] > 4) { // 외국인일경우
				if (result > 10) {
					result -= 10;
				}

				result += 2;

				if (result > 10) {
					result -= 10;
				}
			}
			
			if (result != lastValue) {
				if(message !== null || message !== ""){
					errors[object_name] = message;
				}
				else{
					errors[object_name] = "올바른 주민번호를 입력해주세요.";
				}
				return false;
			}
		}
	}
}

function errorsInit(){ // 에러값 초기화
	errors = {}; // error 정보가 담긴 Map 초기화

	// error메시지를 표시중인 object 목록
	const error_objects = document.getElementsByName("validate_error_message"); 

	// error메시지 제거
	for (let i = 0; i < error_objects.length; i++) {
		error_objects[i].innerHTML = "";
	}
}

function setValidateElement() {
	$("input").each(function(){
		const name = $(this).attr("name");
		const validate = $(this).data("validate");
		const message = $(this).data("message");
		const display = $(this).closest("tr").css("display") == "none";
		if (!names.includes(name) && typeof(validate) != "undefined" && !display) {
			validate_list.push({"name": name, "validate": validate, "message": message});
			names.push(name);
		}
	});	
	$("textarea").each(function(){
		const name = $(this).attr("name");
		const validate = $(this).data("validate");
		const message = $(this).data("message");
		const display = $(this).closest("tr").css("display") == "none";

		if (!names.includes(name) && typeof(validate) != "undefined" && !display) {
			validate_list.push({"name": name, "validate": validate, "message": message});
			names.push(name);
		}
	});
	$("select").each(function(){
		const name = $(this).attr("name");
		const validate = $(this).data("validate");
		const message = $(this).data("message");
		const display = "";

		if (!names.includes(name) && typeof(validate) != "undefined" && !display) {
			validate_list.push({"name": name, "validate": validate, "message": message});
			names.push(name);
		}
	});
}
function setValidateElementMedia() {
	var cont= 0;
	$("input").each(function(){
		cont += 1;
		const name = $(this).attr("name");
		const validate = $(this).data("validate");
		const message = $(this).data("message");
		const display = $(this).closest("tr").css("display") == "none";
		if (typeof(validate) != "undefined" && !display) {
			validate_list.push({"name": name, "validate": validate, "message": message});
			names.push(name);
		}
	});	
	$("textarea").each(function(){
		cont += 1;
		const name = $(this).attr("name");
		const validate = $(this).data("validate");
		const message = $(this).data("message");
		const display = $(this).closest("tr").css("display") == "none";

		if (typeof(validate) != "undefined" && !display) {
			validate_list.push({"name": name, "validate": validate, "message": message});
			names.push(name);
		}
	});
}

function alertValidateErrors() {
	for (let i = 0; i < validate_list.length; i++) {
		const element = validate_list[i]['name'];

		if (element in errors) {
			alert(validate_list[i]['message']);
			return false;
		}
	}
}

/* 유효성 검사 시작 
*  object_name = 해당 object의 name
*  objects = 해당 object 모음
*  
*  validates = 유효성 검사 목록
*/
function fnValidateStart(object_name, objects, validates, message) { 
	for (let i = 0; i < validates.length; i++) {
		const validate = validates[i].split(".")[0];

		for (let j = 0; j < objects.length; j++) {
			const object = objects[j];
			validate_methods[validate](object_name, object, validates[i], message);
		}
	}
}

function fnErrorMessageView(object_name) {
	if (object_name in errors) {
		const object = document.getElementById(object_name + "_error");
		object.innerHTML =  errors[object_name];
	}
}

function fnValidate(){
	errorsInit(); // 에러메시지 초기화
	// 유효성 검사
	for (let i = 0; i < validate_list.length; i++) {
		const element = validate_list[i];                         // 유효성검사 항목(해당 object의 name과 검사내용을 담은 Map)
		const object_name = element["name"];                      // 해당 object의 name
		const validates = element["validate"].split("|");         // 검사내용. |단위로 나뉘어진것을 쪼갠 List
		const message = element["message"];						  // 오류메시지
		const objects = document.getElementsByName(object_name);  // object_name에 해당하는 object들을 가져온 List

		fnValidateStart(object_name, objects, validates, message); // 유효성 검사 시작
		fnErrorMessageView(object_name); // 에러 메시지 표시
	}

	// 결과
	return new Promise(function(resolve, reject) { // 결과값 리턴
		resolve(errors);
	})
}
