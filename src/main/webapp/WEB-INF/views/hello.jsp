<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<body>
<h2>Restricted area</h2>

<h3>Hello, ${username}</h3>

<c:url value="/logout" var="logoutUrl"/>
<sf:form action="${logoutUrl}" method="post">
    <input type="submit" value="Logout">
</sf:form>
</body>
</html>