<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Login</title>
    <link rel="stylesheet" href="<c:url value="/resources/css/bootstrap.min.css" />">
</head>
<body>

<c:url value="/login" var="loginUrl"/>

<div class="container">
    <div class="row" style="margin-top: 50px">

        <form class="" action="${loginUrl}" method="post">
            <c:if test="${param.error != null}">
                <div class="form-group has-error">
                    <div class="form-control"><p class="text-danger">Invalid username and password.</p></div>
                </div>
            </c:if>
            <c:if test="${param.logout != null}">
                <div class="form-group has-success">
                    <div class="form-control"><p class="text-success">You have been logged out.</p></div>
                </div>
            </c:if>

            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" name="username" class="form-control" id="username" placeholder="Username">
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" name="password" class="form-control" id="password" placeholder="Password">
            </div>
            <button type="submit" class="btn btn-default">Submit</button>

        </form>
    </div>
</div>
</body>
</html>
