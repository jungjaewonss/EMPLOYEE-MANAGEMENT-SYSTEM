<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="root" value="${pageContext.request.contextPath}/"/>        
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>departmentList</title>
<script  src="http://code.jquery.com/jquery-latest.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-modal/0.9.1/jquery.modal.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-modal/0.9.1/jquery.modal.min.css"/>
<script type="text/javascript">
	$(document).ready(function(){
		
		//messageがある場合メッセージ出力
		if('${msg}' != ''){
			alert("${msg}");
		}
	});
	
	
	function search(){
		var option = $("#searchSelect option:selected").val();
		var text = $("#text").val();
			
		if(option == 'gender'){
			text = $("#genderSelect option:selected").val();
		}
		
		// 条件検索通信
		$.ajax({
			url : "${root}department/searchList",
			type : "post",
			data : {"option":option,"text":text},
			dataType:"json",
			success: function(data){
				listHtml="";
				alert(data.length);			
				if(data == ''){
					listHtml+='<b style="font-size:30px">';
					listHtml+='該当するユーザー情報がありません.';
					listHtml+='</b>';
					$("#tbody").html(listHtml);
				}else if(data.length >= 10){
					listHtml+='<b style="font-size:30px">';
					listHtml+='ユーザー情報が多すぎるため、条件を絞って再検索してください。';																			
					listHtml+='</b>';
					$("#tbody").html(listHtml);			
					return false;
				}
				
				$.each(data , function(idx,val){					
					listHtml+="<tr>";
					listHtml+="<td>"+val.id+"</td>";
					listHtml+="<td>"+val.name+"</td>";
					listHtml+="<td>"+val.department+"</td>";
					listHtml+="<td>"+val.positions+"</td>";				
					listHtml+="<td>"+val.gender+"</td>";
					listHtml+="<td>"+val.joindate+"</td>";
					listHtml+="<td>"+val.phone+"</td>";
					listHtml+="<td>";
					listHtml+="<button class='btn btn-info'";
					listHtml+= 'onclick='+'location.href="${root}department/updateForm?id='+val.id+'"';
					listHtml+= ">"+"修正"+"</btuoon>"
					
					listHtml+="<button class='btn btn-warning'";
					listHtml+= 'onclick='+"deleteMem("+val.id+");";
					listHtml+= ">"+"削除"+"</btuoon>"
					listHtml+="</tr>";
				}); 
				
				$("#tbody").html(listHtml);			
			},
			error:function(){
				alert("erorr");
			}
		});
	}
	
	//Optionが変わることによって画面変更
	function change(){
		var option = $("#searchSelect option:selected").val();
		
		if(option == 'gender'){
			$("#text").css("display",'none');
			$("#genderSelect").css("display","inline");
		}
		else if(option == 'id'){
			$("#text").css("display",'inline');
			$("#genderSelect").css("display","none");
		}
		else if(option == 'department'){
			$("#text").css("display",'inline');
			$("#genderSelect").css("display","none");
		}
		else if(option == 'name'){
			$("#text").css("display",'inline');
			$("#genderSelect").css("display","none");
		}
		else if(option == 'joindate'){
			$("#text").css("display",'inline');
			$("#genderSelect").css("display","none");
		}
	}
	
	function deleteMem(id){
		if(confirm("削除しますか？")){
			$.ajax({
				url:"${root}department/delete",
				type:"get",
				data: {"id":id},
				success: function(data){				
					if(data == 1){
						alert("削除完了しました。");
						location.href="${root}";
					}				
				},
				error: function(){
					alert("deleteError");
				}
			});
		}	
	}
	
	function csvbtn(){
		const filename = "employeeInfomation.csv";
		var option = $("#searchSelect option:selected").val();
		var text = $("#text").val();
		
		$.ajax({
			url : "${root}department/searchList",
			type : "post",
			data : {"option":option,"text":text},
			dataType:"json",
			success:function(data){
				getCSV(filename,data);
			},
			error:function(){
				alert("error");
			}
		});
		
	}
	
	function getCSV(filename,data){
		var csv = [];
		var row = [];
		
		row.push(
			"番号",
			"名前",
			"部署",
			"職責",
			"性別",
			"入社日",
			"電話番号"		
		);
		csv.push(row.join(","));
	
		$.each(data,function(idx,val){
			row=[];
			row.push(
				val.id,
				val.name,
				val.department,
				val.positions,
				val.gender,
				val.joindate,
				val.phone
			);
			
			csv.push(row.join(","));
		});		
		downloadCSV(csv.join("\n"), filename);		
	}
	
	function downloadCSV(csv,filename){
		var csvFile;
		var downloadLink;
		
		const BOM = "\uFEFF";
		csv = BOM + csv;
		
		csvFile = new Blob([csv], {type:"text/csv"});
		downloadLink = document.createElement("a");
		downloadLink.download = filename;
		downloadLink.href = window.URL.createObjectURL(csvFile);
		downloadLink.style.display = "none";
		document.body.appendChild(downloadLink);
		downloadLink.click();
	}
	
	function modalon(){
		$("#modal").modal("show");
	}
		
</script>
</head>
<body>
	
	<div>
		<form id="searchForm">
			<b>キーワード選択</b>
			<select id="searchSelect" onchange="change();">
				<option value="all">AllSearch</option>
				<option value="id">Id Search</option>
				<option value="department">Department Search</option>
				<option value="name">Name Search</option>
				<option value="gender">Gender Search</option>
				<option value="joindate">JoinDate Search</option>
			</select>
			
			<select id="genderSelect"  style="display: none;">
				<option value="man">man</option>
				<option value="woman">woman</option>
			</select>
			
			<input type="text" id="text"/>
			<input type="button" class="btn btn-primary" value="検索" onclick="search()"/>
			<input type="button" class="btn btn-succes" value="登録" onclick="location.href='${root}department/joinForm'"/>
		</form>
			<button type="button" class="btn btn-info" id="csvbtn" onclick="csvbtn();" style="background-color: green;">CSVダウンロード</button>
			<button type="button" class="btn btn-info" onclick="modalon();" >アップロード</button>
			
	<!-- MODAL -->
	 <div id="modal" class="modal">
  		<p id="modalContent">
			<button class="btn btn-primary" onclick="location.href='${root}department/uploadCsv?val=0'">登録</button>
			<button class="btn btn-info" onclick="location.href='${root}department/uploadCsv?val=1'">修正</button>
			<button class="btn btn-warning" onclick="location.href='${root}department/uploadCsv?val=2'">削除</button>
  		</p>
 		 <a href="#" rel="modal:close">閉じる</a>
	</div>
			
	<!-- 모달끝 -->					
		<table class='table table-bordered' id="emptable">
			<thead>
			<tr>
				<th>番号</th>
				<th>名前</th>
				<th>部署</th>				
				<th>職責</th>				
				<th>性別</th>
				<th>入社日</th>
				<th>電話番号</th>
				<th>空欄</th>
			</tr>
			</thead>
			
			<tbody id="tbody">
				<c:forEach items="${allList}" var="val">
					<tr>
						<td>${val.id}</td>
						<td>${val.name}</td>
						<td>${val.department}</td>
						<td>${val.positions}</td>												
						<td>${val.gender}</td>
						<td>${val.joindate}</td>
						<td>${val.phone}</td>						
						<td>
							<button class="btn btn-info"  onclick="location.href='${root}department/updateForm?id=${val.id}'">修正</button>
							<button class="btn btn-warning" onclick="deleteMem(${val.id});">削除</button>
						</td>
					</tr>
				</c:forEach>
			</tbody>		
		</table>		
	</div>	
</body>
</html>