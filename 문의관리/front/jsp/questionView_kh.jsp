<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="/WEB-INF/tlds/c.tld"%>
<%@ taglib prefix="fn" uri="/WEB-INF/tlds/fn.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tlds/fmt.tld"%>
<%@ taglib prefix="utils" uri="/WEB-INF/tlds/utils.tld"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>KH정보교육원 RAD :: 문의관리</title>
<c:set var="role" value="${sessionScope.aduser.role_code}" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath }/resources/css/eval.css" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath }/resources/css/preLearning.css" />
<jsp:include page="/WEB-INF/jsp/rad/common/_kh/meta.jsp" />
<style>
#body {
	overflow: inherit;
	min-height: 1000px;
	background: none;
}

#view_modify {
	overflow: inherit;
}

#view_modify .comment {
	min-height: 700px;
}

#view_modify .modify_form {
	margin-bottom: 25px;
}

#view_modify .modify_form .res_container {
	position: relative;
}

#view_modify .modify_form .res_container input#res_memo {
	width: 67px;
	text-align: center;
}

#view_modify .modify_form .res_container span {
	position: absolute;
}

#view_modify .modify_form .res_container span.openP {
	position: absolute;
	left: 2px;
	top: 7px;
}

#view_modify .modify_form .res_container span.closeP {
	position: absolute;
	left: 69px;
	top: 7px;
}

#view_modify .modify_form .res_container select {
	border: 1px solid #ececec;
	height: 31px;
	width: 137px;
}

#view_modify .modify_form select {
	font-family: 'Noto Sans KR', NanumGothic, Arial, Helvetica, sans-serif,
		"굴림체";
	font-size: 12px;
	color: #707070;
}

#view_modify .left {
	width: 695px;
	float: left;
}

#view_modify #board_list {
	width: 695px;
	margin-top: 30px;
}

#view_modify #board_list .upper {
	padding: 5px 0 5px 0;
	background: #ececec;
}

#view_modify #board_list .lower {
	padding: 5px 0 0 0;
}

#view_modify #board_list .left {
	width: 40%;
	padding-top: 6px;
}

#view_modify #board_list .right {
	width: 55%;
}

#view_modify #board_list th {
	width: 100px;
}

#board_list tr.insert:hover td {
	background: #fff;
	cursor: inherit;
}

#view_modify #board_list #curr_prospects_name {
	width: 380px;
}

#view_modify .comment_btns {
	padding-top: 13px;
}

#view_modify .comment_btns p {
	text-align: left;
	margin-bottom: 15px;
}

#view_modify .comment_btns .meta {
	display: none;
	margin: 0 0 15px 20px;
	padding: 5px;
	background: #f9f9f9;
}

#view_modify #board_list .prospects_due {
	display: inline-block;
	width: 49%;
	padding-top: 1px;
}

#view_modify #board_list th.no_border_bottom {
	border-bottom: 0px;
}

#interview_date {
	overflow: inherit;
}

#tbl_memo_container {
	width: 80%;
	margin-top: 30px;
	padding: 0 10px;
}

#tbl_memo_container .tbl_memo {
	width: 465px;
	border-top: 1px solid #ececec;
}

#view_modify .modify_form select {
	width: 132px;
	height: 34px;
	border: 1px solid #ececec;
}

#memo_list .btn {
	height: 25px;
	line-height: 25px;
	padding: 0px 5px;
	font-size: 11px;
	background: #ececec;
	color: #646464;
	margin-right: 10px;
}

#memo_list .cont .btn {
	margin-bottom: 10px;
}

#view_modify .comment .comment_btns {
	padding: 30px;
}

.readonly {
	background: #ececec;
}

.select .select_view span {
	display: inline;
	padding: 0 10px;
}

.select>span {
	font-size: 12px;
}

.popup table th {
	text-align: center;
	padding: 0px;
}

td.checked_teacher {
	padding-left: 10px;
	font-size: 12px;
}

td.checked_teacher p {
	padding: 3px 8px;
}

.delete_x {
	cursor: pointer;
	padding-left: 7px;
}

.select {
	background: url(../../../resources/images/rad/select_more.jpg) no-repeat;
	background-position: right;
}

.select ul li:hover {
	background: unset;
}

.select ul li {
	border-bottom: 0;
}

.select>ul>li {
	font-size: 12px;
}
</style>
<script type="text/javascript">
	var idc = 0, t2 = "";

	jQuery(function() {
		//달력으로 인한 css조정으로 footer가 올라오는 오류방지용.
		$("#body").height(
				$("#view_modify .left").height() + $("#headtitle").height());

		if ('${params.idx}' == 'offline') {
			fnCurrentSub('02', '02');
		} else if ('${params.classify}' == 'x') {
			fnCurrentSub('02', '05');
		} else {
			fnCurrentSub('02', '01');
		}

		//mkCalendar('card_due');

		mkSelect('consuresult', '선택_등록_가망고객_등록예정_상담예정_연결안됨_재컨텍요망_가망없음');
		mkSelectChange('know_root',
				'선택_네이버검색_구글검색_다음검색_HRD검색_지인소개_고용센터_현수막/전단지_이공계기술연수_페이스북_기타');

		mkSelect('regcurri', '선택_자바_정보보안_웹디자인_재직자과정_기타');
		mkdSelected(
				'regcurri',
				"${data.stdt_major_sub==null or data.stdt_major_sub==''? '선택':data.stdt_major_sub}");

		var conre = '${data.consuresult}';
		if (conre.indexOf('[') == -1) {
			mkdSelected('consuresult',
					"${data.consuresult==null or data.consuresult==''? '선택':data.consuresult}");
		} else {
			conre = conre.split("[");
			mkdSelected('consuresult', conre[0]);
			$("#consuresult_d").val(conre[1].replace("]", ""));
		}

		if ('${data.know_root}'.indexOf('기타') != -1) {
			var kr = '${data.know_root}'.split('_');
			mkdSelected('know_root', kr[0]);
			$("#know_root_s").val(kr[1]);
		} else {
			mkdSelected('know_root',
					"${data.know_root==null or data.know_root==''? '선택':data.know_root}");
			$("#know_root_s").hide(0);
		}

		$("#know_root").change(function() {
			var kr = $("#know_root").val();
			if (kr == '기타')
				$("#know_root_s").show(0);
			else
				$("#know_root_s").hide(0);
		});

		var res_id = $("#res_id").val();
		var role = '${role}';

		// 문의관리가 시작될때(상담내역을 하나도 남기지 않았을 경우)
		// 내사로 시작된 경우에는 상담결과에 <level2-방문상담/미방문> 메뉴를 보여주기 위한 이벤트핸들러 설정.
		if ($("#prospects").val() == "") {
			$("#contact").change(function() {

				if (this.value == "내사")
					$("#level").val(2);
				else
					$("#level").val(0);
			});
		}

		$('#branch-${data.quest_branch}').attr('checked', true);
	});

	function fnQuestionUpdate() {
		var params = {
			no : '${data.no}',
			req_comment : $("#req_comment").val()
		}

		$
				.ajax({
					url : '${pageContext.request.contextPath}/rad/question/questionViewUpdate.kh',
					data : params,
					dataType : 'json',
					type : 'post',
					success : function(data, textStatus) {
						var result = data['result'];

						if (result == 0) {
							alert('문의 내용 수정에 실패했습니다. 다시 시도해주십시오.');
						} else {
							alert('문의 내용이 수정되었습니다.');
						}
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alert('오류가 발생했습니다\n[' + textStatus + ']\n'
								+ errorThrown);
					}
				});
	}

	function fnOk() {
		var conre = $("#consuresult").val();
		var conre_d = $("#consuresult_d").val();
		if (conre_d != null && conre_d != '') {
			conre = conre + "[" + conre_d + "]";
		}

		var kr = $("#know_root").val();
		if (kr == '기타')
			kr = kr + "_" + $("#know_root_s").val();

		var c_reg_date = "", c_next_skd_date = "";
		if ($("#c_reg_date").val() != '')
			c_reg_date = $("#c_reg_date").val() + "∮"
					+ $("#c_reg_date_time_hh").val() + ":"
					+ $("#c_reg_date_time_mm").val();
		if ($("#c_next_skd").val() != '')
			c_next_skd_date = $("#c_next_skd_date").val() + "∮"
					+ $("#c_next_skd_date_time_hh").val() + ":"
					+ $("#c_next_skd_date_time_mm").val();

		var regcurri = $("#regcurri").val();
		if ($('#res_id').val() === null || $('#res_id').val() === '') {
			alert('상담자를 선택해주세요.');
			return;
		}
		if ($("#contact").val() == null || $("#contact").val() == '') {
			alert('컨택매체를 선택해주십시오.');
			return;
		}

		var params = {
			no : '${data.no}',
			branch : $("#branch").val(),
			branchs : $('input[name=branchs]:checked').val(),
			gender : '',
			age : '',
			academic : '',
			career : $("#career").val(),
			res_memo : $("#res_memo").val(),
			res_id : $("#res_id").val(),
			consuresult : conre,
			regcurri : '',
			know_root : kr,
			contact : $("#contact").val(),
			reg_id : '${sessionScope.aduser.id}',
			name : $("#name").val(),
			mobile : $("#mobile").val(),
			address_city : '',
			address_gun : '',
			address_etc : '',
			graduDate : '',
			card_due : '',
			exp : 0, //경험유무
			recommend : '', //추천여부
			hasCard : 0,  //카드발급여부
			chance : '', //등록여부 
			old_preLearning : $('#old_preLearning').val(), // 이전 사전학습번호
			preLearning : $('#preLearning').val(), // 사전학습번호
			stdt_no : $("#stdt_no").val()
		// 학생번호
		};

		$.ajax({
			url : '${pageContext.request.contextPath}/rad/question/questionSave.kh',
			data : params,
			dataType : 'json',
			type : 'post',
			success : function(data, textStatus) {
				var result = data['result'];
				if (result == 0) {
					alert('기본정보저장에 실패하였습니다.');
				} else {
					alert('저장했습니다.');
					var f = document.getElementById('back_frm');
					f.action = '${pageContext.request.contextPath}/rad/question/questionView.kh';
					f.submit();
				}
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert('오류가 발생했습니다\n[' + textStatus + ']\n'
						+ errorThrown);
			}
		});
	}
	function fnDelete() {
		if ($('#password').val() != $('#pass_ok').val()) {
			alert('비밀번호가 일치하지 않습니다.');
			return;
		}

		if (confirm('삭제하시겠습니까?')) {
			var params = {
				no : '${data.no}'
			};
			$
					.ajax({
						url : '${pageContext.request.contextPath}/rad/question/questionDelete.kh',
						data : params,
						dataType : 'json',
						type : 'post',
						success : function(data, textStatus) {
							var result = data['result'];
							if (result == 0) {
								alert('삭제에 실패하였습니다.');
							} else {
								alert('삭제하였습니다.');
								var f = document.getElementById('back_frm');
								f.submit();
							}
						},
						error : function(jqXHR, textStatus, errorThrown) {
							alert('오류가 발생했습니다\n[' + textStatus + ']\n'
									+ errorThrown);
						}
					});
		}
	}
	/* 상담기록 삭제 */
	function fnMemoDel(comment_no) {
		var params = {
			mode : 'delete',
			comment_no : comment_no
		}
		$
				.ajax({
					url : '${pageContext.request.contextPath}/rad/question/questionMemoSave.kh',
					data : params,
					dataType : 'html',
					type : 'post',
					success : function(data, textStatus) {
						var result = data['result'];
						if (result == 0) {
							alert('상담내역 삭제실패!');
						} else {
							alert('상담내역을 삭제했습니다.');
							location.reload();
						}

					},
					error : function(jqXHR, textStatus, errorThrown) {
						alert('오류가 발생했습니다\n[' + textStatus + ']\n'
								+ errorThrown);
					}
				});
	}

	
	function fnSetTimeToNow(id) {
		var d = new Date(), date = d.getFullYear()
				+ ". "
				+ (d.getMonth() + 1 < 10 ? '0' + (d.getMonth() + 1) : d
						.getMonth() + 1) + ". "
				+ (d.getDate() < 10 ? '0' + d.getDate() : d.getDate()), hh = d
				.getHours() < 10 ? '0' + d.getHours() : d.getHours();
		//5분단위로 환산
		var mm = 5 * (parseInt(d.getMinutes() / 5));
		mm = mm < 10 ? '0' + mm : mm;
		$("#" + id).val(date);
		$("#" + id + "_time_hh").val(hh);
		$("#" + id + "_time_mm").val(mm);
	}

	/* 상담내역 팝업 보는 함수 */
	function fnQuestionMemoForm(mode, comment_no) {
		var params = {
			mode : mode,
			comment_no : comment_no,
			no : $("#curr_prospects").val(),
			site_id : 'kh',
			stdt_no : '${stdt_no}',
			quest_no : '${data.no}',
			user_no : '${user_no}',
			mobile : '${data.mobile}',
			name : '${data.name}',
			user_count : '${data.user_count}'
		}

		$
				.ajax({
					url : '${pageContext.request.contextPath}/rad/question/questionMemoForm.kh',
					data : params,
					dataType : 'html',
					type : 'post',
					success : function(data, textStatus) {
						var title = mode == 'update' ? ':: 상담내역 수정 ::'
								: ':: 상담내역 등록 ::';
				
						$("#popup_questionMemoForm .popup_title").text(title);
						$("#popup_questionMemoForm .popup_content").html(data);
						$("#popup_questionMemoForm").fadeIn();

						// 여기서 param mode를 share로 변경 
						$("#btn_memoSave").prop("href",
								"javascript:fnMemoSave('" + mode + "');");
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alert('오류가 발생했습니다\n[' + textStatus + ']\n'
								+ errorThrown);
					}
				});
	}

	function fnCheckUserMaster(mode, comment_no) {
		var params = {
			quest_no : '${data.no}',
			counselor : $("#res_id").val(),
			mobile : '${data.mobile}'
		}

		$.ajax({
			url : '${pageContext.request.contextPath}/rad/question/checkUserMasterPop.kh',
			data : params,
			dataType : 'html',
			type : 'post',
			success : function(data, textStatus) {
				var title = "회원가입여부 확인";
				$("#popup_checkUserMasterForm .popup_title").text(title);
				$("#popup_checkUserMasterForm .popup_content").html(data);
				$("#popup_checkUserMasterForm").fadeIn();
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert('오류가 발생했습니다\n[' + textStatus + ']\n'
						+ errorThrown);
			}
		});

	}

	/* 회원가입 완료 화인 */
	function fnUserCheckSave(stdt_no, quest_no, counselor) {
		var params = {
			stdt_no : stdt_no,
			quest_no : quest_no,
			counselor : counselor
		}
		if (confirm("회원가입 확인을 완료하시겠습니까?") === true) {
			$.ajax({
					url : '${pageContext.request.contextPath}/rad/question/userCheckSave.kh',
					data : params,
					dataType : 'json',
					type : 'post',
					success : function(data, textStatus) {
						var result = data['result'];
						if (result == 0) {
							alert('회원가입 확인에 실패하였습니다.');
						} else if (result == -1) {
							alert('해당문의번호로 회원등록이 완료된 학생이 존재합니다.');
						} else {
							alert(data['message']);
							location.reload();
						}
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alert('오류가 발생했습니다\n[' + textStatus + ']\n'
								+ errorThrown);
					}
				});
		}
	}

	/** 상담내역 팝업 유효성 검사*/
	function fnMemoSave(mode) {
		var result_value = 0;
		
		if('${data.res_id}'  === '' || null){
			alert("상담자를 등록 후 기본정보 저장을 먼저 진행해주세요.");
			return;
		}
		
		if ($("#c_result").val() == null || $("#c_result").val() == '') {
			alert('상담결과를 선택하세요.');
			return;
		}
		if ($("#c_reg_date").val() == null || $("#c_reg_date").val() == '') {
			alert('일시를 선택하세요.');
			return;
		}
		if ($("#c_next_skd").val() == null || $("#c_next_skd").val() == '') {
			alert('다음일정을 선택하세요.');
			return;
		}

		var c_reg_date = "", c_next_skd_date = "";
		if ($("#c_reg_date").val() != '')
			c_reg_date = $("#c_reg_date").val() + "∮"
					+ $("#c_reg_date_time_hh").val() + ":"
					+ $("#c_reg_date_time_mm").val();
		if ($("#c_next_skd").val() != '' && $("#c_next_skd_date").val() != '')
			c_next_skd_date = $("#c_next_skd_date").val() + "∮"
					+ $("#c_next_skd_date_time_hh").val() + ":"
					+ $("#c_next_skd_date_time_mm").val();

		var c_result = $("#c_result").val().split("∮")[1], c_next_skd = $(
				"#c_next_skd").val().split("∮")[1];

		//면접예정용 운영과정조회
		if ((c_result == '면접예정' || c_result == '가망' || c_result == '등록' || c_next_skd == '면접')
				&& $("#curr_prospects").val() == "") {
			alert('운영과정을 입력하세요.');
			$("#c_curr_prospects_name").focus();
			return;
		}
		if ((c_result == '면접예정' || c_next_skd == '면접')
				&& $("#c_next_skd_date").val() == '') {
			alert("면접일정을 입력하세요.");
			return;
		}
	
		if (c_result == '등록' && $("#curr_prospects_start_date").val() == ''
				&& mode != 'update') {
			alert("잘못된 과정입니다. 올바른 과정으로 변경한 뒤 등록해주세요.");
			return;
		}
		
		if (mode === 'bgclick') {
			return;
		}
	
		if (confirm('상담내역을 등록하시겠습니까?')) {
			var params = {
				no : '${data.no}',
				comment_no : $("#comment_no").val(),
				mode : mode,
				contact : $("#c_contact").val(),
				comment : $("#memo_write").val(),
				call_duration : $("#memo_call_duration").val(),
				reg_id : '${sessionScope.aduser.name}',
				c_result : c_result,
				c_result_memo : $("#c_result_memo").val(),
				c_reg_date : c_reg_date,
				c_next_skd : c_next_skd,
				c_next_skd_date : c_next_skd_date,
				visited : c_result == "방문상담" ? '1' : '0',
				level : $("#c_next_skd").val().split("∮")[2],
				curr_prospects : $("#curr_prospects").val(),
				start_date : $("#curr_prospects_start_date").val(), 
				stdtNo           : '${stdt_no}', 
				counselor         : $("#res_id").val()
			 };

			if (c_result == '면접예정' || c_next_skd == '면접') {
				params.interview_no = $("#interview_no").val();
				params.interview_num = $("#interview_num").val(); /* 고유번호 */
				params.interview_date = $("#c_next_skd_date").val()
				params.interview_time = $("#c_next_skd_date_time_hh").val()
						+ ":" + $("#c_next_skd_date_time_mm").val();
				params.interview_branch = $("[name=c_interview_branch]:checked").val();
				//params.charge		= $("#res_id").val();
				params.counselor = $("#res_id").val();
				params.update_name = '${sessionScope.aduser.name}';
				params.introduce = '${sessionScope.aduser.name}';
				params.name = $("#name").val();
			}
			if (c_result == '등록') {
				params.name = $("#name").val();
				params.mobile = $("#mobile").val();
				params.reg_curr = $("#curr_prospects").val();
				params.start_date = $("#curr_prospects_start_date").val();
				params.reg_date = $("#c_reg_date").val();
				params.counselor = $("#res_id").val();
				params.result_value = result_value;
			}
			fnMemoSaveAjax(params);
		}
	}

	/* 상담내역 팝업 내용 저장 */
	function fnMemoSaveAjax(params) {
		$
				.ajax({
					url : '${pageContext.request.contextPath}/rad/question/questionMemoSave.kh',
					data : params,
					dataType : 'json',
					type : 'post',
					success : function(data, textStatus) {
						var result = data['result'];
						if (result == 0) {
							alert('상담내역 등록에 실패하였습니다.');
						} else {
							//등록인경우 result=>원서번호이다.
							if ((params.mode != 'share_pop') && (params.mode != 'issue_pop')){
								if (params.reg_curr != null){
									if (confirm("학생을 등록했습니다. \n" + params.name
											+ " 학생의 원서번호는 [" + result
											+ "]입니다.\n등록학생페이지로 이동하시겠습니까?"))
										location.href = '${pageContext.request.contextPath}/rad/student/studentView.kh?no='
												+ result;
									return;
								}
							}
							location.reload();
						}
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alert('오류가 발생했습니다\n[' + textStatus + ']\n'
								+ errorThrown);
					}
				});
	}

	function fnBack() {
		var f = document.getElementById("back_frm");
		f.submit();
	}

	function fnPreEvalStart(quest_no) {
		var params = {
			quest_no : quest_no,
			t_type : 0,
			ncs_type : $("#pre_eval_form input[name='ncs_type']:checked").val(),
			eval_duration : $(
					"#pre_eval_form input[name='eval_duration']:checked").val(),
			charger : '${sessionScope.aduser.id}'
		}

		$.ajax({
			url : '${pageContext.request.contextPath}/rad/curr/preEvalForm.kh',
			data : params,
			dataType : 'html',
			type : 'post',
			success : function(data, textStatus) {
				$("#problem_content").html(data);
				fnOpenPopup('preeval_problem');
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert('오류가 발생했습니다\n[' + textStatus + ']\n' + errorThrown);
			}
		});
	}

	function fnEvalOk() {
		document.evalForm.submit();
	}

	function fnPreEvalResult(quest_no) {
		var params = {
			quest_no : quest_no
		}

		$
				.ajax({
					url : '${pageContext.request.contextPath}/rad/curr/preEvalScore.kh',
					data : params,
					dataType : 'html',
					type : 'post',
					success : function(data, textStatus) {

						$("#result_content").html(data);
						fnOpenPopup('preeval_result');

					},
					error : function(jqXHR, textStatus, errorThrown) {
						alert('오류가 발생했습니다\n[' + textStatus + ']\n'
								+ errorThrown);
					}
				});
	}

	function fnUserClosePopup() {
		location.reload();
	}

	function fnPopupPreLearning(stdt_no) {

		var params = "";
		$
				.ajax({
					url : '${pageContext.request.contextPath}/rad/curr/preLearningPopup.kh',
					data : params
					//, dataType	: 'json'
					,
					type : 'post',
					success : function(data, textStatus) {
						$("#preLearningPane").html(data);

						fnOpenPopup('preLearning');
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alert('오류가 발생했습니다\n[' + textStatus + ']\n'
								+ errorThrown);
					}
				});
	}

	function fnKeySearchPreLearning() {
		if (event.keyCode != 13) {
			return false;
		}

		fnSearchPreLearning();
	}

	function fnSearchPreLearning() {
		var params = {
			searchGubun : $("#searchGubun").val(),
			searchTarget : $("#searchTarget").val()
		};
		$
				.ajax({
					url : '${pageContext.request.contextPath}/rad/curr/preLearningPopup.kh',
					data : params,
					type : 'post',
					success : function(data, textStatus) {

						$("#preLearningPane").html(data);
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alert('오류가 발생했습니다\n[' + textStatus + ']\n'
								+ errorThrown);
					}
				});
	}

	function fnSelectPreLearning(no) {
		var params = {
			no : no,
			stdt_no : $("#stdt_no").val()
		};
		$
				.ajax({
					url : '${pageContext.request.contextPath}/rad/curr/addPreLearning.kh',
					data : params,
					type : 'post',
					success : function(data, textStatus) {
						var result = data['error_code'];
						if (result == 0) {
							alert('선택한 사전학습에 추가가 되었습니다.');
							var dataMap = data['dataMap'];

							$("#curr_pre_learning_date").val(
									dataMap.learning_date);

							fnClosePopup();
						} else {
							alert(data['error_msg'])
						}
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alert('오류가 발생했습니다\n[' + textStatus + ']\n'
								+ errorThrown);
					}
				});
	}
	// 20200210 상담내역 공유 ver 2
	
	// 메모공유, 이슈등록시   팝업창  일부hide 처리
	function popHide(){
		$("#th_result_date").hide();
		$("#th_call_duration").hide();
		$("#th_next_date").hide(); 
	}
	
		/* 상담내역 팝업 보는 함수 */
	function fnQuestionMemoShareForm(mode, comment_no, mode_ch) {
		var params = {
			mode : mode,
			comment_no : comment_no,
			no : $("#curr_prospects").val(),
			site_id : 'kh',
			stdt_no : '${stdt_no}',
			quest_no : '${data.no}',
			user_no : '${user_no}',
			mobile : '${data.mobile}',
			name : '${data.name}',
			user_count : '${data.user_count}',
			mode_ch : mode_ch
		}

		$
				.ajax({
					url : '${pageContext.request.contextPath}/rad/question/questionMemoForm.kh',
					data : params,
					dataType : 'html',
					type : 'post',
					success : function(data, textStatus) {
						var title = ':: 상담내역 공유 ::';
						$("#popup_questionMemoForm .popup_title").text(title);
						$("#popup_questionMemoForm .popup_content").html(data);
						fnSetTimeToNow('c_reg_date');
						$("#pop_notice").text("* 시간표관리 - 관리일지 [입학관리]탭에 공유됩니다.");
						$("#pop_notice").show();
						$("#popup_questionMemoForm").fadeIn();
						
						popHide();
						
						$("#btn_memoSave").prop("href",
								"javascript:fnMemoSave('" + mode_ch + "');");
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alert('오류가 발생했습니다\n[' + textStatus + ']\n'
								+ errorThrown);
					}
				});
	}
	

	// 20200212 상담내역 공유 ver 2
	/* [이슈학생 공유] 버튼 클릭시 상담내역 팝업 보는 함수 */
	function fnQuestionMemoIssueForm(mode, comment_no, mode_ch) {
		var params = {
			mode : mode,
			comment_no : comment_no,
			no : $("#curr_prospects").val(),
			site_id : 'kh',
			stdt_no : '${stdt_no}',
			quest_no : '${data.no}',
			user_no : '${user_no}',
			mobile : '${data.mobile}',
			name : '${data.name}',
			user_count : '${data.user_count}',
			mode_ch : mode_ch
		}

		$
			.ajax({
				url : '${pageContext.request.contextPath}/rad/question/questionMemoForm.kh',
				data : params,
				dataType : 'html',
				type : 'post',
				success : function(data, textStatus) {
					var title = ':: 이슈학생 등록 ::';
					$("#popup_questionMemoForm .popup_title").text(title);
					$("#popup_questionMemoForm .popup_content").html(data);
					fnSetTimeToNow('c_reg_date');
					$("#pop_notice").text("* 시간표관리 - 관리일지 [이슈학생]칸에 공유됩니다.");
					$("#pop_notice").show();
					$("#popup_questionMemoForm").fadeIn();
					popHide();
					
					$("#btn_memoSave").prop("href",
							"javascript:fnMemoSave('" + mode_ch + "');");
				},
				error : function(jqXHR, textStatus, errorThrown) {
					alert('오류가 발생했습니다\n[' + textStatus + ']\n'
							+ errorThrown);
				}
			});
	}	
	
	/* 상담기록 공유해제 */
	function fnMemoShareCancel(comment_no) {
		var params = {
			mode : 'share_cancel',
			comment_no : comment_no,
			stdt_no : '${stdt_no}'
		}
		$
				.ajax({
					url : '${pageContext.request.contextPath}/rad/question/questionMemoSave.kh',
					data : params,
					dataType : 'html',
					type : 'post',
					success : function(data, textStatus) {
						var result = data['result'];
						if (result == 0) {
							alert('상담내역 공유해제 실패!');
						} else {
							alert('상담내역 공유를 해제했습니다. (RAD 메뉴 : 시간표관리 > 각 반 [입학관리]탭에 공유하기 해제)');
							
							location.reload();
						}

					},
					error : function(jqXHR, textStatus, errorThrown) {
						alert('상담내역 공유 해제 오류가 발생했습니다\n[' + textStatus + ']\n'
								+ errorThrown);
					}
				});
	}	
	/* 상담기록 공유해제 끝 */
	
	/* 이슈학생 완료 (학사관리> 시간표관리 - 관리일지 이슈학생에 공유됐던 내용 완료(=해제)) */
		function fnIssueStdtCompleted(comment_no, comment) {

				var params = {
					mode      : 'complete_share'
					, stdt_no   : '${stdt_no}'
					, comment_no : comment_no
					, comment : comment
				};

				$
					.ajax({
							url : '${pageContext.request.contextPath}/rad/student/issueStdtComplete.kh',
							data : params,
							dataType : 'json',
							type : 'post',
							success : function(data, textStatus) {
								var result = data.result;

								if (result == '1') {
									alert('이슈학생이 완료되었습니다.');
									window.location.reload();
								} else if (result == '0') {
									alert('이슈학생 완료가 실패했습니다.');
								}
							},
							error : function(jqXHR, textStatus, errorThrown) {
							alert('오류가 발생했습니다\n[' + textStatus + ']\n'
										+ errorThrown);
							}
						});
			}
			/* 이슈학생 완료 끝 (학사관리> 시간표관리 - 관리일지 이슈학생에 공유됐던 내용 완료(=해제)) */
</script>

</head>
<body>
	<!-- <body oncontextmenu="return false" ondragstart="return false" onselectstart="return false"> -->
	<c:set var="userid" value="${sessionScope.aduser.id}" />
	<!-- 학교 검색 POPUP -->
	<div class="popup_wrap" id="popup_schoolFinder">
		<div class="bg" onclick="$('#popup_schoolFinder').fadeOut()"></div>
		<div class="popup"
			style="width: 562px; height: 733px; margin-left: -300px; margin-top: -350px;">
			<div class="popup_title" id="detailSmsTitle">학교명 검색</div>
			<div class="popup_content">
				<!-- 학교선택 -->
				<div id="findSchool"></div>
			</div>

			<a class="btn" href="javascript:fnSchoolFinderOff();"
				style="margin-left: 256px;">닫기</a>

		</div>
	</div>
	<!-- 학과 검색 POPUP -->
	<div class="popup_wrap" id="popup_majorFinder">
		<div class="bg" onclick="$('#popup_majorFinder').fadeOut()"></div>
		<div class="popup"
			style="width: 533px; height: 733px; margin-left: -300px; margin-top: -350px;">
			<div class="popup_title" id="detailSmsTitle">학과명 검색</div>
			<div class="popup_content">
				<!-- 학과선택 -->
				<div id="findMajor"></div>
			</div>
			<a class="btn" href="javascript:fnMajorFinderOff();"
				style="margin-left: 256px;">닫기</a>
		</div>
	</div>
	<!-- 문의삭제 popup 시작 -->
	<div class="popup_wrap" id="popup_delete">
		<div class="bg" onclick="fnClosePopup();"></div>
		<div class="popup" style="width: 400px;">
			<div class="popup_title">문의 삭제 비밀번호 확인</div>
			<div class="popup_content">
				<table cellpadding="0" cellspacing="0">
					<tr>
						<th style="width: 80px;">비밀번호 확인</th>
						<td><input type="password" id="password" /><input
							type="hidden" id="pass_ok" value="${data.password}" /></td>
					</tr>
				</table>
				<div class="popup_btns popup_btn_insert">
					<a href="javascript:fnDelete();" class="btn">삭제</a> <a
						href="javascript:fnClosePopup();" class="btn">취소</a>
				</div>
			</div>
		</div>
	</div>
	<!-- 문의삭제 popup 끝 -->

	<!-- 상담내역 등록 popup 시작-->
	<div class="popup_wrap" id="popup_questionMemoForm">
		<div class="bg" onclick="fnMemoSave('bgclick');"></div>
		<div class="popup"
			style="transform: translateX(-50%) translateY(-50%);">
			<div class="popup_title" style="background: #74acf6;"></div>
			<div class="popup_content" style="padding: 20px 25px;"></div>
			<div class="popup_btn">
				<table class="view_form" cellpadding="0" cellspacing="0"
					style="width: 100%; margin-bottom: 20px; border: 0px;">
					<tr>
						<td class="comment_btns"
							style="border-left: 1px solid #ececec; border: 0px; text-align: center;">
							<a id="btn_memoSave" class="btn" href="javascript:fnMemoSave();"
							style="background: #2a2a4e;">저장</a> <a class="btn"
							href="javascript:$('#popup_questionMemoForm').fadeOut();"
							style="background: #fb606b;">취소</a>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
	<!-- 상담내역 등록 popup 끝-->

	<!-- 회원가입완료 확인 popup 시작-->
	<div class="popup_wrap" id="popup_checkUserMasterForm">
		<div class="bg"></div>
		<div class="popup"
			style="transform: translateX(-50%) translateY(-50%);">
			<div class="popup_title" style="background: #74acf6;"></div>
			<div class="popup_content" style="padding: 20px 25px;"></div>
			<div class="popup_btn">
				<table class="view_form" cellpadding="0" cellspacing="0"
					style="width: 100%; margin-bottom: 20px; border: 0px;">
					<tr>
						<td class="comment_btns"
							style="border-left: 1px solid #ececec; border: 0px; text-align: center;">
							<a class="btn"
							href="javascript:$('#popup_checkUserMasterForm').fadeOut();"
							style="background: #fb606b;">닫기</a>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
	<!-- 회원가입완료 확인 popup 끝-->

	<!-- 사전학습 설정 popup -->
	<div class="popup_wrap" id="popup_preLearning">
		<div class="bg" onclick="fnClosePopup();"></div>
		<div class="popup" style="width: 630px; height: 470px;">
			<div class="popup_title">사전학습</div>
			<div class="popup_content">
				<div id="preLearningPane"></div>
				<div class="popup_btns">
					<a href="javascript:fnClosePopup();" class="btn">닫기</a>
				</div>
			</div>
		</div>
	</div>

	<!-- 사전평가 설정 popup -->
	<div class="popup_wrap" id="popup_preeval">
		<div class="bg" onclick="fnClosePopup();"></div>
		<div class="popup" style="width: 400px;">
			<div class="popup_title">사전평가 설정</div>
			<div class="popup_content">
				<form id="pre_eval_form">
					<table cellpadding="0" cellspacing="0">
						<tr>
							<th style="width: 80px;">전공구분</th>
							<td><input type="radio" name="ncs_type" value="0" checked />자바
								<input type="radio" name="ncs_type" value="1" />보안</td>
						</tr>
						<tr>
							<th>평가시간</th>
							<td><input type="radio" name="eval_duration" value="10"
								checked />10분 <input type="radio" name="eval_duration"
								value="30" />30분 <input type="radio" name="eval_duration"
								value="60" />1시간</td>
						</tr>
					</table>
					<div class="popup_btns popup_btn_insert">
						<a href="javascript:fnPreEvalStart('${data.no }');" class="btn">평가시작</a>
						<a href="javascript:fnClosePopup();" class="btn">취소</a>
					</div>
				</form>
			</div>
		</div>
	</div>

	<!-- 사전평가 문제 popup -->
	<div class="popup_wrap" id="popup_preeval_problem">
		<div class="bg" onclick="fnClosePopup();"></div>
		<div class="popup" style="width: 1000px; height: 600px;">
			<div class="popup_title">사전평가</div>
			<div class="popup_content">
				<div id="problem_content"
					style="overflow-y: auto; max-height: 450px;"></div>
				<div class="popup_btns popup_btn_insert">
					<a href="javascript:fnEvalOk();" class="btn">제출하기</a>
				</div>
				</form>
			</div>
		</div>
	</div>

	<!-- 사전평가 결과 popup -->
	<div class="popup_wrap" id="popup_preeval_result">
		<div class="bg" onclick="fnClosePopup();"></div>
		<div class="popup" style="width: 1000px; height: 600px;">
			<div class="popup_title">사전평가 결과</div>
			<div class="popup_content">
				<div id="result_content"
					style="overflow-y: auto; max-height: 450px;"></div>
				<div class="popup_btns popup_btn_insert">
					<a href="javascript:fnClosePopup();" class="btn">닫기</a>
				</div>
				</form>
			</div>
		</div>
	</div>

	<!-- 본문 -->
	<input type="hidden" id="location_name" value=disable>
	<jsp:include page="/WEB-INF/jsp/rad/common/_kh/metaHeader_2018.jsp" />
	<jsp:include page="/WEB-INF/jsp/rad/common/_kh/header_2018.jsp" />
	<jsp:include page="/WEB-INF/jsp/rad/portlet/right_quick.jsp" />
	<div id="body" onmouseover="fnCloseSubs();">
		<div id="headtitle">
			<div class="left">
				<c:if test="${params.idx == 'offline'}">
				오프라인 문의
				</c:if>

				<c:if test="${params.idx == 'online'}">
				온라인 문의
				</c:if>

				<c:if test="${params.classify == 'X'}">
				세미나 문의
				</c:if>
			</div>
			<div class="right"></div>
		</div>
		<div id="view_modify">
			<div class="left">
				<table class="modify_form" cellpadding="0" cellspacing="0">
					<tr>
						<th colspan="4" class="modify_form_title">문의번호 - ${data.no}</th>
					</tr>
					<tr>
						<th>이름</th>
						<td><c:if test="${userid=='nocturn93' or userid=='leekh'}">
								<input type="text" id="name" value="${data.name }">
							</c:if> <c:if test="${userid!='nocturn93' and userid!='leekh'}">${data.name }<input
									type="hidden" id="name" value="${data.name }">
							</c:if> <%-- 
						<c:if test="${role=='A'}"><input type="text" id="name" value="${data.name }"></c:if>
						<c:if test="${role!='A'}">${data.name }<input type="hidden" id="name" value="${data.name }"></c:if>
						--%></td>
						<th>연락처</th>
						<td><c:if test="${userid=='nocturn93' or userid=='leekh'}">
								<input type="text" id="mobile" value="${data.mobile }">
							</c:if> <c:if test="${userid!='nocturn93' and userid!='leekh'}">${data.mobile }<input
									type="hidden" id="mobile" value="${data.mobile }">
							</c:if> <%-- 
						<c:if test="${role=='A'}"><input type="text" id="mobile" value="${data.mobile }"></c:if>
						<c:if test="${role!='A'}">${data.mobile }<input type="hidden" id="mobile" value="${data.mobile }"></c:if>
						--%></td>
					</tr>
					<tr>
						<th>문의일자</th>
						<td>${fn:substring(data.reg_date, 0, 4)}.
							${fn:substring(data.reg_date, 4, 6)}.
							${fn:substring(data.reg_date, 6, 8)}</td>
						<th>문의종류</th>
						<td>${data.classify}</td>
					</tr>
					<tr>
						<th>문의과정</th>
						<td colspan="3">
							취업연계 : 
							<c:if 
								test="${data.job!=null and data.job!=''}">${data.job}<br />
							</c:if> 
							<c:if test="${data.industrial!=null and data.industrial!=''}">${data.industrial}<br /></c:if>
							
							<c:if test="${data.region!=null and data.region!=''}">지산맞 : ${data.region}<br />
							</c:if> <c:if
								test="${data.engineering_it!=null and data.engineering_it!=''}">이공계 : ${data.engineering_it }<br />
							</c:if> <c:if test="${data.game!=null and data.game!=''}">인문특화 : ${data.game}<br />
							</c:if> <c:if test="${data.inform!=null and data.inform!=''}">과정평가형 : ${data.inform}<br />
							</c:if> <c:if test="${data.today_card!=null and data.today_card!=''}">내일배움 : ${data.today_card }<br />
							</c:if> <c:if test="${data.shot!=null and data.shot!=''}">단과/재직자 : ${data.shot }<br />
							</c:if> <c:if test="${data.national!=null and data.national!=''}">자격증 : ${data.national}</c:if>
						</td>
					</tr>
					<tr>
						<th>문의내용 <br> <c:if test="${params.idx eq 'offline'}">
								<c:if
									test="${sessionScope.aduser.role_code == 'UV' || role eq 'AM' || role eq 'EO'}">
									<a href="javascript:fnQuestionUpdate();" class="btn"
										style="margin-top: 10px;">수정</a>
								</c:if>
							</c:if>
						</th>
						<td colspan="3"><textarea
								style="width: 98%; height: 100px; border: 1px solid #ececec; resize: none;"
								id="req_comment">${data.req_comment}</textarea></td>
					</tr>
					<tr>
						<th>IP</th>
						<td>${data.ip}</td>
						<th>문의지점</th>
						<td><label for="branch-2"> <input type="radio"
								id="branch-2" value="2" name="branchs" />강남
						</label> <label for="branch-6"> <input type="radio" id="branch-6"
								value="6" name="branchs" />종로
						</label> <label for="branch-10"> <input type="radio"
								id="branch-10" value="10" name="branchs" />당산
						</label> <label for="branch-7"> <input type="radio" id="branch-7"
								value="7" name="branchs" />이태원
						</label> <%-- ${data.branchs} --%> <input type="hidden" id="branch"
							name="branch" value="-"></td>
					</tr>
					<tr>
						<th>상담자</th>
						<td colspan="3">
							<div class="res_container">
								<%-- 데이터 migration --%>
								<c:set var="idx" value="${fn:indexOf(data.res_id,']')}" />
								<c:set var="res_memo"
									value="${data.res_memo==null and idx!= -1?(fn:substring(data.res_id,1,idx)):data.res_memo}" />
								<c:set var="res_id"
									value="${idx==-1?data.res_id:(fn:substringAfter(data.res_id,']'))}" />
								<input type="text" id="res_memo" name="res_memo"
									value="${res_memo}" placeholder="상담자메모"> <span
									class="openP">[</span> <span class="closeP">]</span>
								<%-- <input type="text" id="res_id" name="res_id" value="${data.res_id }"> --%>
								<select id="res_id" name="res_id">
									<option value="">선택</option>
									<c:set var="dept" value="" />
									<c:forEach var="c" items="${counselorList}" varStatus="vs">
										<c:if test="${c.department!=dept}">
											<c:set var="dept" value="${c.department}" />
											<c:if test="${vs.index!=0}">
												</optgroup>
											</c:if>
											<c:set var="dept_"
												value="${fn:substringAfter(c.department,'/')}" />
											<optgroup label="${fn:contains(dept_,'팀')?dept_: '입학상담부'}">
										</c:if>
										<option ${res_id==c.name?'selected':''}>${c.name}</option>
										<c:if test="${fn:length(counselorList)==vs.count}">
											</optgroup>
										</c:if>
									</c:forEach>
								</select>
							</div>
						</td>
					</tr>
					<tr>
						<th>컨택매체</th>
						<td><select id="contact" name="contact" style="width: 215px;">
								<!-- onchange="fnContactChange(this.value);" -->
								<option value="">선택</option>
								<option value="홈페이지" ${data.contact=='홈페이지'?'selected':''}>홈페이지</option>
								<option value="모바일" ${data.contact=='모바일'?'selected':''}>모바일</option>
								<option value="대표전화" ${data.contact=='대표전화'?'selected':''}>대표전화</option>
								<option value="개인" ${data.contact=='개인'?'selected':''}>개인</option>
								<option value="내사" ${data.contact=='내사'?'selected':''}>내사</option>
								<option value="오프라인" ${data.contact=='오프라인'?'selected':''}>오프라인</option>
						</select></td>
						<th>문의경로</th>
						<td><input id="know_root" style="width: 132px;"> <input
							type="text" style="width: 300px;" id="know_root_s"></td>
					</tr>
				</table>

				<utils:authority url="/rad/question/questionMemoSave.kh">
					<a href="javascript:fnCheckUserMaster('insert');" class="btn"
						style="background:${data.check_user == null ? '#fb606b':'#ececec'};">회원가입여부
						확인</a>
				</utils:authority>
				<table class="modify_form" cellpadding="0" cellspacing="0">
					<tr>
						<th >생년월일</th>
						<td colspan="8"><input class="readonly" type="text"
							style="width: 190px;" value="${fn:substring(data.birth,0,6)}"
							placeholder="학생이등록하는 정보입니다." readonly="readonly" /></td>
						<%-- <th>성별</th>
					<td>
						<input type="radio" id="gender_1" value="남" name="gender" ${data.gender=='남'? 'checked':'' }>
						<label for="gender_1">남</label>&nbsp;
						<input type="radio" id="gender_2" value="여" name="gender" ${data.gender=='여'? 'checked':'' }>
						<label for="gender_2">여</label>
					</td>
					<th>나이</th>
					<td><input type="text" id="age" name="age" value="${fn:replace(data.age,'세','')}" style="width:65px;"/> 세</td> --%>
					</tr>
					<tr>
						<th >주소</th>
						<td colspan="8"><c:set var="address"
								value="${fn:split(data.stdt_address,'_')}" /> <input
							class="readonly" type="text" style="width: 190px;"
							value="${address[0]}${address[1]}${address[2]}"
							placeholder="학생이등록하는 정보입니다." readonly="readonly" /></td>
					</tr>
					<tr>
						<th>학교</th>
						<td colspan="3"><c:set var="comaca"
								value="${fn:split(data.stdt_comaca,'_')}" /> <input
							class="readonly" type="text" value="${comaca[0]}"
							style="width: 190px;" placeholder="학생이등록하는 정보입니다."
							readonly="readonly" /></td>
						<th>전공</th>
						<td colspan="3"><input class="readonly" type="text" value="${comaca[1]}"
							style="width: 190px;" placeholder="학생이등록하는 정보입니다."
							readonly="readonly"></td>
					</tr>
					<tr>
						<th>최종학력</th>
						<td colspan="3"><input class="readonly" type="text"
							value="${data.stdt_academic}" style="width: 190px;"
							placeholder="학생이등록하는 정보입니다." readonly="readonly" /></td>
						<th>구분/졸업년월</th>
						<td colspan="3"><input class="readonly" type="text"
							value="${comaca[2]} / ${data.stdt_graduation_date}"
							style="width: 190px;" placeholder="학생이등록하는 정보입니다."
							readonly="readonly" /></td>
					</tr>
					<tr>
						<th >면접일</th>
						<td colspan="2"><input class="readonly" type="text"
							value="${data.interview_date} / ${data.interview_time}" style="width: 120px;"
							placeholder="면접일 입니다." readonly="readonly" /></td>
						<th >사전평가점수</th>
						<td colspan="2"><input class="readonly" type="text"
							value="${data.assessment}"
							style="width: 77px;" placeholder="사전평가점수"
							readonly="readonly" /></td>
						<th >사전학습여부</th>
						<td colspan="2"><input class="readonly" type="text"
							<c:if test="${play_time_rate > 0}">
							value="O (${play_time_rate}%)"
							</c:if>f
							<c:if test="${play_time_rate == 0}">
							value="X"
							</c:if>
							style="width: 77px;" placeholder=""
							readonly="readonly" /></td>
					</tr>
				</table>
				<table class="modify_form" cellpadding="0" cellspacing="0">
					<c:if test="${data.consuresult != null and data.consuresult != ''}">
						<tr>
							<th>(구)상담결과</th>
							<td colspan="3"><input id="consuresult" name="consuresult"
								style="width: 112px;" value="${data.consuresult }"> <input
								type="text" style="width: 433px;" id="consuresult_d"
								placeholder="더이상 사용하지 마세요." readonly></td>
						</tr>
					</c:if>
					<tr>
						<th>주요이력</th>
						<td colspan="3"><input type="text" id="career" name="career"
							value="${data.career}" style="width: 554px;"></td>
					</tr>
					<tr>
						<th>신청과정</th>
						<td colspan="3"><input id="regcurri" style="width: 213px;">
						</td>
					</tr>
				</table>

				<!-- 가망고객관리 readonly 테이블 -->
				<table class="modify_form" cellpadding="0" cellspacing="0">
					<tr>
						<th style="border-top: 1px solid #ececec;">가망고객<br>관리
						</th>
						<td class="no_border_bottom"
							style="border-top: 1px solid #ececec;"><input type="text"
							id="prospects" class="readonly"
							value="${data.prospects!=null and data.prospects!=''?data.prospects:(fn:substringBefore(data.consuresult,'['))}"
							readonly> <!-- 기존 문의고객들의 마이그레이션을 위해서 level값을 조정할 수 있게 한다. -->
							<input
							type="${(fn:length(list)>0) and empty list[fn:length(list)-1].result?'number':'hidden'}"
							maxlength="1" min="0" max="3" id="level" value="${data.level}"
							style="width: 24px; margin-top: 3px;"></td>
						<th style="border-top: 1px solid #ececec;">면접예정일</th>
						<td style="border-top: 1px solid #ececec;"><input type="text"
							id="interview_date" class="readonly" style="background: #ececec;"
							value="${data.interview_date}" readonly /> <br> <input
							type="text" id="interview_time" class="readonly"
							value="${data.interview_time}"
							style="margin-top: 5px; width: 80px; margin-right: 16px;"
							readonly /> <input type="text" id="interview_branch_name"
							class="readonly"
							value="${data.interview_branch==2?'강남':data.interview_branch==6?'종로':data.interview_branch==10?'당산':''}"
							style="margin-top: 5px; width: 102px;" readonly />
							<div style="display: none;">
								<input type="radio" id="interview_branch2"
									name="interview_branch" value="2"
									${data.interview_branch=='2'?'checked':''} disabled /><label
									for="interview_branch2">강남</label> <input type="radio"
									id="interview_branch6" name="interview_branch" value="6"
									${data.interview_branch=='6'?'checked':''} disabled /><label
									for="interview_branch6">종로</label> <input type="radio"
									id="interview_branch10" name="interview_branch" value="10"
									${data.interview_branch=='10'?'checked':''} disabled /><label
									for="interview_branch10">당산</label>
							</div> <input type="hidden" id="interview_num"
							value="${data.interview_num}" /> <!-- 인터뷰일정테이블 고유번호 --> <input
							type="hidden" id="interview_no" value="${data.interview_no}" />
							<!-- 인터뷰일정테이블용 ex)2017. 08. 18_자바_오후 --></td>
					</tr>
					<tr>
						<th>운영과정</th>
						<td colspan="3" class="no_border_bottom"><c:set var="cpn"
								value="${data.currname}(${data.prof}) - ${data.begin_date}_${fn:substring(data.begin_time, 0, 2) == '09'?'오전':'오후'} (${data.branch_name})" />
							<input type="text" id="curr_prospects_name" class="readonly"
							value="${data.curr_prospects!=null and data.curr_prospects!=''?cpn:''}"
							style="width: 554px;" readonly="readonly" /> <input
							type="hidden" id="curr_prospects" value="${data.curr_prospects}" />
							<input type="hidden" id="curr_prospects_start_date"
							value="${data.begin_date}" /> <input type="hidden" id="stdt_no"
							value="${stdt_no}" /></td>
					</tr>

					<c:set var="status"
						value="${data.prospects!=null and data.prospects!=''?data.prospects:(fn:substringBefore(data.consuresult,'['))}" />
					<c:if test="${stdt_no != 0}">
						<tr>
							<th>사전학습</th>
							<td colspan="3" class="no_border_bottom">
								<input type="hidden" id="old_preLearning" value="${preLearningMap.no}" />
								<select
									id="preLearning" style="width: 100%;"
									<c:if test="${preEvalCount > 0 }">disabled="true"</c:if>>
										<option value="">사전학습을 선택하시기 바랍니다</option>
										<c:forEach var="preLearning" items="${preLearningList}"
											varStatus="vs">
											<option value="${preLearning.no }"
												<c:if test="${preLearning.no == preLearningMap.no }">selected</c:if>>${preLearning.target }
												- ${preLearning.prof_name } ${preLearning.learning_date }
												(${preLearning.att_cnt })명</option>
										</c:forEach>
								</select> 
								<%-- 
									<a class="btn" href="javascript:fnPopupPreLearning('${data.no}');">사전학습일정선택</a>
								--%>
							</td>
						</tr>
					</c:if>
					<tr>
						<td colspan="4" class="comment_btns"
							style="padding: 20px 0 30px 0; border-left: 1px solid #ececec;">

							<%-- 
						<c:if test="${preTestMap.cnt == 0 }">
						<a href="javascript:fnOpenPopup('preeval');" class="btn">사전평가</a>
						</c:if>
						<c:if test="${preTestMap.cnt > 0 }">
						<a href="javascript:fnPreEvalResult('${data.no }');" class="btn">사전평가 결과확인</a>
						</c:if>
						--%> 
							<utils:authority url="/rad/question/questionSave.kh">
								<a href="javascript:fnOk();" class="btn"
									style="background: #2a2a4e;">기본정보 저장</a>
							</utils:authority> <c:if
								test="${sessionScope.aduser.role_code=='AM' or sessionScope.aduser.role_code=='SM' or sessionScope.aduser.id=='jhyang' or sessionScope.aduser.id=='hjsong' or sessionScope.aduser.id=='nocturn93' or sessionScope.aduser.id=='ghdthdud0806'}">
								<utils:authority url="/rad/question/questionDelete.kh">
									<a href="javascript:fnOpenPopup('delete');" class="btn"
										style="background: #2a2a4e;">삭제</a>
								</utils:authority>
							</c:if> 
							<%-- 
						<utils:authority url="/rad/question/questionDelete.kh"> 
						<a href="javascript:fnOpenPopup('delete');" class="btn">삭제</a>
						</utils:authority>
						--%>
							 <a href="javascript:fnBack();" class="btn" style="background: #fb606b;">나가기</a>
							<form
								action="${pageContext.request.contextPath}/rad/question/question.kh"
								method="post" id="back_frm" style="display: inline;">
								<input type="hidden" name="start_date" id="start_date"
									value="${params.start_date}" /> <input type="hidden"
									name="end_date" id="end_date" value="${params.end_date}" /> <input
									type="hidden" name="consuresult" id="consuresultS"
									value="${params.consuresult}" /> <input type="hidden"
									name="contact" id="contactS" value="${params.contact}" /> <input
									type="hidden" name="know_root" id="know_rootS"
									value="${params.know_root}" /> <input type="hidden"
									name="know_root_value" id="know_root_valueS"
									value="${params.know_root_value}" /> <input type="hidden"
									name="search_key" id="search_key" value="${params.search_key}" />
								<input type="hidden" name="search_value" id="search_value"
									value="${params.search_value}" /> <input type="hidden"
									name="classify" id="classifyS" value="${params.classify}" /> <input
									type="hidden" name="regcurri" id="regicurriS"
									value="${params.regcurri}" /> <input type="hidden"
									name="isall" id="isall" value="${params.isall}" /> <input
									type="hidden" name="domain" id="domain_search"
									value="${params.domain_search }" /> <input type="hidden"
									name="cpage" id="cpage" value="${params.cpage}" /> <input
									type="hidden" name="idx" id="idx" value="${params.idx}" /> <input
									type="hidden" name="branch_domain" id="branch_domain"
									value="${params.branch_domain }" /> <input type="hidden"
									name="branch" id="branchS"
									value="${params.branch=='선택'? '':params.branch}" /> <input
									type="hidden" name="no" id="no" value="${params.no}" /> <input
									type="hidden" name="sms_subject" id="sms_subject_param"
									value="${params.sms_subject}" /> <input type="hidden"
									name="sms_msg" id="sms_msg_param" value="${params.sms_msg}" />
								<input type="hidden" name="search_online" id="search_online"
									value="${params.search_online}" /> <input type="hidden"
									name="search_offline" id="search_offline"
									value="${params.search_offline}" />
							</form>
						</td>
					</tr>
				</table>
			</div>

			<div class="right">
				<table cellpadding="0" cellspacing="0" id="board_list"
					style="margin-top: 0px; width: 100%;">
					<tr>
						<th colspan="5" style="background: #74acf6; height: 20px;">상담내역</th>
					</tr>
				</table>
				<div class="comment">
					<div class="comment_btns">
						<utils:authority url="/rad/question/questionMemoSave.kh">
							<a href="javascript:fnQuestionMemoForm('insert');" class="btn"
								style="background: #2a2a4e;">상담내역등록</a>
						</utils:authority>
					</div>
					<div id="memo_list">
						<c:forEach var="dataM" items="${list}" varStatus="vs">
							<div id="memo${dataM.no}" class="comment_cont">
								<p class="cont" style="padding-top: 10px;">
									<a class="btn"> ${vs.count} ${dataM.result} </a>
									<c:if
										test="${dataM.result_memo!=null and dataM.result_memo!=''}">
										<a class="btn"> ${dataM.result_memo} </a>
									</c:if>
									<br>
									${fn:split(dataM.comment,'∮')[0]}${fn:split(dataM.comment,'∮')[1]}${fn:split(dataM.comment,'∮')[2]}
									<c:if
										test="${(dataM.call_duration!=null and dataM.call_duration!='') or (dataM.next_skd!=null and dataM.next_skd!='')}">
										<p class="cont" style="padding: 0 20px 0 20px;">
											<c:if
												test="${dataM.call_duration!=null and dataM.call_duration!=''}">
												<a class="btn"> 상담시간 : ${dataM.call_duration} 분 </a>
											</c:if>
											<c:if test="${dataM.next_skd!=null and dataM.next_skd!=''}">
												<a class="btn"> 다음일정 : ${dataM.next_skd}
													${fn:replace(dataM.next_skd_date,'∮',' ')} </a>
											</c:if>
										</p>
									</c:if>
								</p>
								<p class="meta">
									<%-- <c:if test="${dataM.call_duration!=null and dataM.call_duration!=''}">
										<a class="btn">
										통화시간 : ${dataM.call_duration} 분
										</a>
									</c:if>
									<c:if test="${dataM.next_skd!=null and dataM.next_skd!=''}">
										<a class="btn">
										다음일정 : ${dataM.next_skd} ${fn:replace(dataM.next_skd_date,'∮',' ')}
										</a>
									</c:if> --%>
									<%-- 기존메모데이터는 reg_date를 사용하고, 신규데이터는 사용자입력일시를 사용한다. --%>
									<c:if test="${dataM.c_reg_date!=null and dataM.c_reg_date!=''}">
										${fn:replace(dataM.c_reg_date,'∮',' ')} | ${dataM.reg_id}
									</c:if>
									<c:if test="${dataM.c_reg_date==null or dataM.c_reg_date==''}">
										${fn:substring(dataM.reg_date, 0, 4)}. ${fn:substring(dataM.reg_date, 4, 6)}. ${fn:substring(dataM.reg_date, 6, 8)} ${fn:substring(dataM.reg_date, 8, 10)}:${fn:substring(dataM.reg_date, 10, 12)} | ${dataM.reg_id}
									</c:if>
									
									 <utils:authority url="/rad/question/questionMemoShare.kh">
										<c:if test="${data.check_user == null}">
											<a onclick="alert('회원가입한 학생만 메모공유가 가능합니다.');" class="btn"
											style="color: #707070; background: #ececec; cursor: pointer;" title="회원가입한 학생만 메모공유가 가능합니다.">공유</a>
										</c:if>
										
										<c:if test="${data.check_user !=null and dataM.share_comment==0}">
											<a href="javascript:fnQuestionMemoShareForm('update','${dataM.no}', 'share_pop');" class="btn"
											style="color: #fff; background: #ff839b; cursor: pointer;">공유</a>
										</c:if>
										
										<c:if test="${data.check_user !=null and dataM.share_comment==1}">
											<a href="javascript:fnMemoShareCancel('${dataM.no}');" class="btn"
											style="color: #fff; background: #ff839b; cursor: pointer;">공유해제</a>
										</c:if>
									</utils:authority> 
									
									<utils:authority url="/rad/question/questionMemoIssueShare.kh">
										<c:if test="${data.check_user == null}">
											<a onclick="alert('회원가입한 학생만 이슈학생 등록이 가능합니다.');" class="btn"
											style="color: #707070; background: #ececec; cursor: pointer;" title="회원가입한 학생만 이슈학생 등록이 가능합니다.">이슈학생등록</a>
										</c:if>									
									
										<c:if test="${data.check_user !=null and params.share_issue_no=='0'}">
											<a href="javascript:fnQuestionMemoIssueForm('update','${dataM.no}', 'issue_pop');" class="btn" 
											style="color: #fff; background: #ff839b; cursor: pointer;">이슈학생 등록</a>
										</c:if>
									
										<c:if test="${params.share_issue_no!=null and dataM.no==params.share_issue_comment_no}">
											<a href="javascript:fnIssueStdtCompleted('${dataM.no}');"
											class="btn" style="color: #fff; background: #ff839b; cursor: pointer;"> 이슈학생 해제</a>
										</c:if>	
										
										<c:if test="${data.check_user !=null and params.share_issue_no !='0'}">
											<a onclick="alert('이슈학생 등록은 학생당 1번만 가능합니다.\n* 이슈학생 해제 후 재등록 가능\n* 이슈학생 해제메뉴 : 학사관리 > 시간표관리 - 관리일지');" class="btn" 
											style="color: #707070; background: #ececec; cursor: pointer;"
											 title="이슈학생 등록은 학생당 1번만 가능합니다.(이슈학생 해제 후 재등록 가능)">이슈학생 등록</a>
										</c:if>
									 </utils:authority> 
								</p>
									
									<%--관리자용 수정, 삭제--%>
									<%-- <c:if test="${dataM.reg_unique_id != null && dataM.reg_unique_id == sessionScope.aduser.id}"> 
										<a href="javascript:fnQuestionMemoForm('update', '${dataM.no}');" class="btn" style="color:#fff; background:#58697b;">수정</a>
									</c:if>  
									<utils:authority url="/rad/*">	
										<a href="javascript:fnMemoDel('${dataM.no}');" class="btn"
											style="color: #fff; background: #ff839b;">삭제</a>
									</utils:authority> --%>		
								<!-- class="meta" 끝 -->
							</div>
						</c:forEach>
					</div>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="/WEB-INF/jsp/rad/common/_kh/footer.jsp" />
</body>
<script type="text/javascript">
	$("div.select > span").click(function() {
		$(this).next("ul").toggle();
		return false;
	});
	$("div.select > ul > li").click(
			function() {
				$(this).parent().hide().parent("div.select").children("span")
						.text($(this).text());
				$(this).prependTo($(this).parent());
			});
</script>
</html>