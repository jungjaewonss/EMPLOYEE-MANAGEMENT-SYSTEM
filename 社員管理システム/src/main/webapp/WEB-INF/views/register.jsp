<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="root" value="${pageContext.request.contextPath}/"/>    
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JOIN</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-modal/0.9.1/jquery.modal.min.js"></script>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-modal/0.9.1/jquery.modal.min.css" />
    <script>
    	
  		$(document).ready(function(){
  			var today =	getToday();
  			$("#joindate").val(today);
  		});
    	
        function sub(){
            var name = $("#name").val();
            var deptno = $("#departmentSelect option:selected").val();
            var positions = $("#positionSelect option:selected").val();
            var gender = $("input[name=gender]:checked").val();
          	var phone = $("#phone").val();
          	var joindate = $("#joindate").val();
          	var department = "";
          	if(deptno == '001'){
          		department = '総務部';
			}
          	else if(deptno == '002'){
          		department = '経理部';
          	}
          	else if(deptno == '003'){
          		department = '営業部';
          	}
          	else if(deptno == '004'){
          		department = '技術部';
          	}
			
          	
          	
          	if(typeof gender == "undefined"){
          		gender = "";
          	}
          	if(name==''){
          		alert("名前を入力してください。");
          		$("#name").focus();
          		return false;
          	}
          	if(name.length > 20){
          		alert("名前を２０文字以下で入力してください。");
          		$("#name").focus();
          		return false;
          	}
          	if(phone.length > 13){
          		alert("電話番法の文字数が１３文字を超過。");
          		$("#phone").focus();
          		return false;
          	}
          	
            $.ajax({
            	url:"${root}department/join",
            	type:"post",
            	data:{	"name":name,
            			"deptno":deptno,
            			"gender":gender,
            			"joindate":joindate,
            			"positions":positions,
            			"phone":phone          			
            		},
            	success:function(){
            			
            			var listHtml="";
                		listHtml+="<h2>"+'登録に成功しました。'+"</h2>"
                		listHtml+="名前  :"+name+"<br>";
                		listHtml+="部署  :"+department+"<br>";
                		listHtml+="職責  :"+positions+"<br>";
                		listHtml+="性別  :"+gender+"<br>";
                		listHtml+="入社日 :"+joindate+"<br>";
                		listHtml+="電話番号 :"+phone+"<br>";
                		
                		console.log(listHtml);
                		$("#modalContent").append(listHtml);
                		
                		$("#modal").modal('show');
            		
            		
            		
            	},
            	error:function(){
            		alert("가입실패");
            	}
            });
            
        }
        
        function getToday(){
            var date = new Date();
            var year = date.getFullYear();
            var month = ("0" + (1 + date.getMonth())).slice(-2);
            var day = ("0" + date.getDate()).slice(-2);
			
            var todayDate = year+'-'+month+'-'+day;
      
            return todayDate;
        }
        
    
    </script>
</head>
<body>
	<center>
    <h2>社員情報詳細画</h2>

    <div>
        <form action="#" method="post" accept-charset="UTF-8">
            <table class="table table-bordered" style="text-align: center; border: 1px solid #dddddd; width:50%">
                <tr>
                    <td style="width: 100px; vertical-align: middle;">名前</td>
                    <td><input class="form-control" type="text" maxlength="30"
                        placeholder="名前を入力してください。"  id="name" name="name" /></td>
                </tr>

                <tr>
                    <td style="width: 100px; vertical-align: middle;">部署</td>
                    <td colspan="2">
                    	<select id="departmentSelect">
                    		<option value=" ">部署名</option>
							<option value="001">総務部</option>
							<option value="002">経理部</option>
							<option value="003">営業部</option>
							<option value="004">技術部</option>
						</select>
                    </td>
                </tr>
                
                <tr>
                    <td style="width: 100px; vertical-align: middle;">職責</td>
                    <td colspan="2">
                    	<select id="positionSelect">
                    		<option value="">職責</option>
							<option value="社員">社員</option>
							<option value="部長">部長</option>
							<option value="社長">社長</option>
						</select>
                    </td>
                </tr>
                
	
                <tr>
                	<td style="width: 100px; vertical-align: middle;">性別</td>
                    <td colspan="3" style="text-align: center;">
                        <input type="radio" name="gender" value="man" />男
                        <input type="radio" name="gender" value="woman" />女
                    </td>
                </tr>
                
                <tr>
                	<td style="width: 100px; vertical-align: middle;">入社日</td>
                    <td colspan="3" style="text-align: center;">
                        <input type="date" name="joindate" id="joindate" value=""  style="text-align: center;"/>
                    </td>
                </tr>
                <a href="a">
                <tr>
                	<td style="width: 100px; vertical-align: middle;">電話番号</td>
                    <td colspan="3" style="text-align: center;">
                        <input type="text" name="phone" id="phone" value=""  style="text-align: center;"/>
                    </td>
                </tr>
             
                <tr>
                    <td colspan="3" style="text-align : left;">
                        <input type="button" value="登録" class="btn btn-primary btn-sm" onclick="sub();"/>
                        <input type="button" value="社員リスト" class="btn btn-primary btn-sm" onclick="location.href='${root}department/allList'"/>                      
                    </td>
                </tr>
                
          
	          </table>
		</form> 
    </div>
    
    <div id="modal" class="modal">
  		<p id="modalContent"></p>
 		 <a href="#" rel="modal:close">닫기</a>
	</div>

      
      
    </center>
</body>
</html>