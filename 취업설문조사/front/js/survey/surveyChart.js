/**
 * 설문조사 통계 데이터_2020.05.20
 */

/** 
 * 통계 색상 세팅_2020.05.06
 */ 
function settingColor(a_no){
	let color = "";
		switch (a_no) {
			case "1":
				color = "#3b84ff";
				break;
			case "2":
				color = "#74acf7";
				break;
			case "3":
				color = "#dfe2e9";
				break;
			case "4":
				color = "#2b2b4f";
				break;
			case "5":
				color = "#fe626d";
				break;
			case "6":
				color = "#ffdc50";
				break;
			case "7":
				color = "#e99d00";
				break;
			case "8":
				color = "#d181c9";
				break;
			case "9":
				color = "#39ad4c";
				break;
			case "10":
				color = "#69af68";
				break;
			case "11":
				color = "#fafbfd";
				break;
			default:
				break;
		}
	
	return color;
}

/** 
 * 통계 데이터 세팅_2020.05.06
 */ 
function pushData(a_no, answer, value, chart_type){
	let color = settingColor(a_no);//통계 색상 세팅
	
	if(chart_type !== 'bar'){
		return {id : a_no, text : answer, value : value, color : color};
	}
	else{
		return {title : answer , "1순위" : value[0] ,"2순위" : value[1] , "3순위" : value[2]};
	}
}

/*
 * 통계 차트 타입 setting_2020.05.20
 */
function setting_chart_type(arr_split){
	switch (arr_split) {
		case '2':
			return 'pie';
		case '3':
			return 'bar';
		case '4':
			return 'donut';
		default:
			break;
	}
}

/** 
 * 통계 데이터 표출_2020.05.06_수정_2020.05.14
 */
function getChart(chartData, index, chartType){
	let config = "";
	
	/** suite.js참고 */
	if(chartType !== 'bar'){
		config = {
				type: chartType,
				series: [//원형 그래프
					{
						value: "value",
						color: "color",
						subType:"valueOnly"
					}
				],
				legend: {//우측 표시
					values: {
						id: "value",
						text: "text",
						color: "color"
					},
					halign: "right",
					valign: "middle",
					margin: 30,
					itemPadding: 14
				}
			};
	}
	else if(chartType === 'bar'){
		config = {
				type: "bar",
				scales: {
					"bottom" : {
						text: "title",
						scaleRotate : 90
					},
					"left" : {
						maxTicks: 5,// y축 숫자 표시 갯수
						max: 30, //최대 학생 수
						min: 0 //최소 값
					}
				},
				series: [ //막대로 표시할 항목들 
					{
						id: "1", 
						value: "1순위",
						color: "#3b84ff",
						fill: "#3b84ff",
						barWidth: 10
					},
					{
						id: "2",
						value: "2순위",
						color: "#2a2a4e",
						fill: "#2a2a4e",
						barWidth: 10
					},
					{
						id: "3",
						value: "3순위",
						color: "#dbdbe2",
						fill: "#dbdbe2",
						barWidth: 10
					}
				],
				legend: {
					series: ["1", "2", "3"], //상단 표시할 부분
					halign: "right",
					valign: "top",
					form :"circle"
				}
			};
	}

	let chart = new dhx.Chart("chartbox"+index+"", config);
	chart.data.parse(chartData);
}