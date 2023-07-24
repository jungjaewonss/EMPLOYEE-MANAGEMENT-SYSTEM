<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="root" value="${pageContext.request.contextPath}/"/>       
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<c:if test="${val eq 0}">
		<h1>登録</h1>
		<form action="${root}department/uploadFile" method="post" enctype="multipart/form-data">
		<input type="file" id="uploadfile" name="csvfile" accept=".csv"/>
		<input type="hidden" name="val" value="0"/>
		<input type="submit">
		</form>
	</c:if>
	
	<c:if test="${val eq 1}">
		<h1>修正</h1>
		<form action="${root}department/uploadFile" method="post" enctype="multipart/form-data">
		<input type="file" id="uploadfile" name="csvfile" accept=".csv"/>
		<input type="hidden" name="val" value="1"/>
		<input type="submit">
		</form>
	</c:if>
	
	<c:if test="${val eq 2}">
		<h1>削除</h1>
		<form action="${root}department/uploadFile" method="post" enctype="multipart/form-data">
		<input type="file" id="uploadfile" name="csvfile" accept=".csv"/>
		<input type="hidden" name="val" value="2"/>
		<input type="submit">
		</form>
	</c:if>
</body>
</html>