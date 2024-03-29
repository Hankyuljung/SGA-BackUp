<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<fmt:requestEncoding value="UTF-8"/>
<!DOCTYPE html>
<html lang="ko">

<head>

    <title>AdminAccount</title>

<script type="text/javascript">
	$(document).ready(function(){
		getFullAdminAccount();
		
		const body = document.querySelector('body');
	    const modal = document.querySelector('.modal');
	    const btnOpenPopup = document.querySelector('.btn-open-popup');
	    const btnClosePopup = document.querySelector('.btn-close-popup');
	    const btnConfirm = document.querySelector('.btn-confirm');
	
        btnOpenPopup.addEventListener('click', () => {
          modal.classList.toggle('show');

          if (modal.classList.contains('show')) {
            body.style.overflow = 'hidden';
          }
        });
        
        btnClosePopup.addEventListener('click', () => {
        	 modal.classList.toggle('show');

             if (modal.classList.contains('show')) {
               body.style.overflow = 'hidden';
             }
        });

        modal.addEventListener('click', (event) => {
          if (event.target === modal) {
            modal.classList.toggle('show');
 
            if (!modal.classList.contains('show')) {
              body.style.overflow = 'auto';
            }
          }
     	});
        
        btnConfirm.addEventListener('click', () => {
   	    	modal.classList.toggle('show');

	        if (modal.classList.contains('show')) {
	          body.style.overflow = 'hidden';
	        }
        });
	    
        
	});
	
	function getFullAdminAccount(){
		var token = localStorage.getItem("token");
		
		$.ajax({
			type: "GET",
			url: "/adminAC/getAdminACList",
			beforeSend: function (xhr) {
                xhr.setRequestHeader("Authorization","Bearer " + token);
            },
            success: function(res) {
            	console.log(res);
        		for(data in res){
       				$("#adminTable").append($("<tr><td>" + JSON.stringify(res[data].admin_idx) + "</td>"
       						+ "<td>" + JSON.stringify(res[data].admin_id).replaceAll("\"", "") + "</td>"
	       					+ "<td>" + JSON.stringify(res[data].admin_name).replaceAll("\"", "") + "</td>"
       						+ "<td>" + JSON.stringify(res[data].admin_roleGroup).replaceAll("\"", "") + "</td>"
       						+ "<td><button type='button' class='btn btn-danger' onclick='delAdminAccount("+ JSON.stringify(res[data].admin_idx) +")'>계정삭제</button> &nbsp;"
       						+ "<button type='button' class='btn btn-success' onclick='location.href=\"/swagger-ui/\"'>비밀번호변경</button></td>"
       						+ "</tr>"
       				));	       	
        		}
        	},
        	error : function(){
        		alert('에러!!!');
        	}
			
		});
	}
	
	function delAdminAccount(idx){
		var token = localStorage.getItem("token");
		
		$.ajax({
			type: "POST",
			url: "/adminAC/deleteAdminAccount",
			data: {
				"admin_idx" : idx
			},
			beforeSend: function (xhr) {
                xhr.setRequestHeader("Authorization","Bearer " + token);
            },
            success: function(res) {
            	alert('삭제성공');
            	location.reload();
        	},
        	error : function(){
        		alert('에러!!!');
        	}
			
		});
	}
	
	function changePassword(id){
		var token = localStorage.getItem("token");
		
		$.ajax({
			type: "POST",
			url: "/adminAC/ChangePassword",
			data: {
				"id" : id
			},
			beforeSend: function (xhr) {
                xhr.setRequestHeader("Authorization","Bearer " + token);
            },
            success: function(res) {
            	alert('비밀번호 변경 성공');
        	},
        	error : function(){
        		alert('에러!!!');
        	}
			
		});
	}
	
	function addAdminAccount(){
		var token = localStorage.getItem("token");
		
		var admin_id = $("#inputAdminId").val();
		var admin_password = $("#inputAdminPW").val();
		var admin_name = $("#inputAdminUser").val();
		var admin_roleGroup = $("#roleGroup").val();
		
		if(admin_id == "" || admin_id == null){
			alert('아이디를 입력해주세요.');
			$("#inputAdminId").focus();
			return
		}
		
		if(admin_password == "" || admin_password == null){
			alert('비밀번호를 입력해주세요.');
			$("#inputAdminPW").focus();
			return
		}
		
		if(admin_name == "" || admin_name == null){
			alert('사용자명을 입력해주세요.');
			$("#inputAdminUser").focus();
			return
		}
		
		if(admin_roleGroup == "권한 선택"){
			alert('권한을 선택해 주세요.');
			return
		}
		
		$.ajax({
			type: "POST",
			url: "/adminAC/addAdminAccount",
			data: {
				"admin_id" : admin_id,
				"admin_password" : admin_password,
				"admin_name" : admin_name,
				"admin_roleGroup" : admin_roleGroup
			},
			beforeSend: function (xhr) {
                xhr.setRequestHeader("Authorization","Bearer " + token);
            },
            success: function(res) {
            	alert('계정 추가 성공');
            	location.reload();
        	},
        	error : function(){
        		alert('계정을 추가하지 못했습니다. 다음의 이유일 가능성이 높습니다. ex)계정 중복');
        	}
			
		});
	}

</script>

<style type="text/css">
	.col{
		text-align: right;
	}
	
	#adminTable{
		border: 3px solid black;
		margin: 5px;
		padding: 5px;
		width: 100%
	}
	
	th {
		border: 3px solid black;
		text-align: center;
		padding: 15px;
	}
	
	td {
		border: 3px solid black;
		text-align: center;
		padding: 15px;
	}
	
	.modal {
        position: absolute;
        top: 0;
        left: 0;

        width: 100%;
        height: 100%;

        display: none;

        background-color: rgba(0, 0, 0, 0.4);
     }

     .modal.show {
       display: block;
     }

     .modal_body {
       position: absolute;
       top: 50%;
       left: 50%;

       width: 400px;
       height: 400px;

       padding: 40px;

       text-align: center;

       background-color: rgb(255, 255, 255);
       border-radius: 10px;
       box-shadow: 0 2px 3px 0 rgba(34, 36, 38, 0.15);

       transform: translateX(-50%) translateY(-50%);
     }
    
</style>
</head>

<body id="page-top">

	<!-- Begin Page Content -->
	<div class="container-fluid">
		<!-- Page Heading -->
		<h1 class="h3 mb-4 text-gray-800">관리자 계정 설정 페이지</h1>
		
		<div class="modal"> 
			<div class="modal_body">
				<h1>관리자 계정 생성</h1>
				
				<div class="input-group mb-3">
				  <span class="input-group-text">Admin ID : </span>
				  <input type="text" id="inputAdminId" class="form-control" placeholder="ID 입력" aria-label="admin_id" aria-describedby="basic-addon1">
				</div>
				
				<div class="input-group mb-3">
				  <span class="input-group-text">Admin PW : </span>
				  <input type="password" id="inputAdminPW" class="form-control" placeholder="Password 입력" aria-label="admin_password" aria-describedby="basic-addon1">
				</div>
				
				<div class="input-group mb-3">
				  <span class="input-group-text">사용자 이름 : </span>
				  <input type="text" id="inputAdminUser" class="form-control" placeholder="사용자 이름 입력" aria-label="admin_name" aria-describedby="basic-addon1">
				</div>
				
				<select id="roleGroup" class="form-select" aria-label="privilege_select">
				  <option selected>권한 선택</option>
				  <option value="ADMIN">ADMIN</option>
				  <option value="USER">USER</option>
				  <option value="OTHER">OTHER</option>
				</select>
				
				<br><br>
			
				<button class="btn btn-warning btn-confirm" onclick='addAdminAccount();'>확인</button>
				<button class="btn btn-warning btn-close-popup">취소</button>
			</div>
		</div>
		<button class="btn btn-warning btn-open-popup">계정생성</button>
		
		<table id="adminTable">
			<tr>
				<th width="10%">No</hd>
				<th width="20%">계정명</th>
				<th width="20%">사용자명</th>
				<th width="20%">권한</th>
				<th>Control</th>
			</tr>
			
		</table>
	</div>
	<!-- /.container-fluid -->
	                       
</body>

</html>