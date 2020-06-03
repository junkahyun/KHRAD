String.prototype.trim = function() 
{
	return this.replace(/(^\s*)|(\s*$)/g, "");
}

/* checker */

//문자입력 금지 함수 설정
function fncOnlyNumber(obj) 
{
	if(event.keyCode != 9)
	{
		if( event.keyCode < 48 || event.keyCode > 57)
		{
			event.keyCode=0;
		}
		
		if(isNaN(obj.value))
		{
		    //return ""+obj.value.substr(0, obj.value.length-1);
		    //fnAlertOpen(obj.value);
		    fnAlertOpen("문자는 사용할 수 없습니다.");
		    obj.value = obj.value.substr(0, obj.value.length-1);
		    //fnAlertOpen(obj.value);
	    }
		//if(obj.value==0) return obj.value
	
	    obj.value = obj.value;
	}
}

//email validation check
function email_check(obj)
{
	var	value	= $.trim($(obj).val());		// trim
	
	if(value == '')
	{
		fnAlertOpen('이메일을 입력하세요.');
		frm.email.focus();
		return false;
	}
	else if(value.indexOf('@') == -1 || value.indexOf('*') != -1)
	{
		fnAlertOpen('이메일 형식이 유효하지 않습니다.');
		$(obj).focus();
		return false;
	}
	else
	{
		var array_data = value.split("@");
		if(array_data.length == 1 || array_data[1].indexOf('.') == -1)
		{
			fnAlertOpen('이메일 형식이 유효하지 않습니다.');
			$(obj).focus();
			return false;
		}
		else
		{
			var tmp = array_data[1].split(".");
			if(tmp[1] == '')
			{
				fnAlertOpen('이메일 형식이 유효하지 않습니다.');
				$(obj).focus();
				return false;
			}
		}
	}
	
	return true;
}


//password valid check
function password_check(obj)
{
	var	value			= $.trim($(obj).val());		// 비밀번호
	//var	confrimvalue	= $.trim($(confirmobj).val());		// 비밀번호 확인

	var pattern = /^[a-zA-Z0-9]{3,50}$/;   //패턴을 정의합니다
	var match = pattern.exec(value);  //입력된 값을 패턴에 적용한다 
	
	if(value.length < 6) 
	{
		fnAlertOpen("비밀번호는 최소6자이상 입력해야합니다.") ;
		return false;
	}
	
	if (match == null) //패턴과 일치하지 않는다면
	{
		fnAlertOpen("비밀번호는 영문자와 숫자만 입력 가능합니다.") ;
		value = "";
		//confrimvalue = "";
		$(obj).focus() ;
		return false;
	}
	
	
	
	var pattern1 = /[a-zA-Z]{1,50}/;   //패턴을 정의합니다
	var match1 = pattern1.exec(value);  //입력된 값을 패턴에 적용한다 
	
	var pattern2 = /[0-9]{1,50}/;   //패턴을 정의합니다
	var match2 = pattern2.exec(value);  //입력된 값을 패턴에 적용한다 
	
	if(match1 == null || match2 == null)
	{
		fnAlertOpen("비밀번호는 영문자와 숫자를 혼용해야 합니다.") ;
		value = "";
		//confrimvalue = "";
		$(obj).focus() ;
		return false;
	}
	 
	return true;
}

function isPhoneNumber1(ob, gubun) {
	if(ob.length < gubun){
		return false;
	}
	var pattern = /^[0-9]{2,4}$/gi;   //패턴을 정의합니다
	var match = pattern.exec(ob);  //입력된 값을 패턴에 적용한다 
	if(match == null){
		return false;
	}
	return true;
}

function isGrade(ob, gubun) {
	 if (event.keyCode >= 48 && event.keyCode <= 57) { //숫자키만 입력
	        return true;
	    } else {
	        event.returnValue = false;
	    }
}



function isID(val){
	var pattern = /^[a-zA-Z0-9]{1,50}$/;   //패턴을 정의합니다
	var match = pattern.exec(val);  //입력된 값을 패턴에 적용한다
	if(match==null) {
		return true;
	}
	return false;
}

function fnPaste(){
	var regex = /\D/ig;
	if(regex.test(window.clipboardData.getData("text"))){
		return false;
	}else{
		return true;
	}
}

function no_special(){
	if( (event.keyCode > 32 && event.keyCode < 48) || (event.keyCode > 57 && event.keyCode < 65) || (event.keyCode > 90 && event.keyCode < 97) ){
		event.returnValue = false;
	}
}


function emailCheck(str)
{
	if(str.search((/(\S+)@(\S+)\.(\S+)/)) == -1)
	{
		return true;
	}
	else
	{
		return false;
	}
}

function email2Check(str) {
	if(str.search((/^[a-zA-Z0-9]{1,50}.[a-zA-Z.]{1,50}$/)) == -1) {
		return true;
	} else {
		return false;
	}
}