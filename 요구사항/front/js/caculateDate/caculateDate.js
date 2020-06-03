/**
 * 요구사항 게시판 날짜 계산
 */

function addPeriod(date, period, temp_add){
	if(temp_add !== ''){
		date.setDate(date.getDate() + period);
	}
	else{
		date.setDate(date.getDate() + (period - 1));
	}
	
	return date;
}

function weekend(date, period, pass_day){
	let count = 0;
	
	for(let i=1; i<=period; i++) { 
		let temp_date = date;
        var tmp = temp_date.getDay();
       
        if(tmp === 0 || tmp === 6) {
        	count++;
        }
        
        if(period > 1 && i === 1 && pass_day === 'pass_day'){
        	count--;
        }
        
        temp_date.setDate(temp_date.getDate() + 1); 
	}
	
	return count;
}

function getFianl(day, date){
	if(day === 6){//토
		date.setDate(date.getDate() +2);
	}
	 else if(day === 0){//일
		 date.setDate(date.getDate() +1);
	} 
	
	return date;
}

function getFinalDate(temp_comp){
	let year = temp_comp.getFullYear();
	let month = (temp_comp.getMonth() + 1) < 10 ? '0'+(temp_comp.getMonth() + 1) : (temp_comp.getMonth() + 1);
	let date = temp_comp.getDate() < 10 ? '0'+temp_comp.getDate() : temp_comp.getDate();
	
	return year+'. '+month+'. '+date;
}