Spring Security Custom Login Form example (Java Configuration)
===============================
[![Build Status](https://travis-ci.org/haozl/spring-security-custom-login-form-jc.svg)](https://travis-ci.org/haozl/spring-security-custom-login-form-jc)

Example on how to configure and create a spring security custom login form with Java configuration

### 1. Technologies used
* Spring 4.2.4.RELEASE
* Spring Security 4.0.3.RELEASE
* Maven 3

### 2. Run the application
```shell
$ git clone https://github.com/haozl/spring-security-custom-login-form-jc.git
$ mvn jetty:run
```
Visit ```http://localhost:8080```

### 3. Import the sample project into Eclipse IDE
1. ```$ mvn eclipse:eclipse```
2. File->Import->Existing projects into workspace

### 4. Add dependencies
**pom.xml**
```xml
    <properties>
        <spring.version>4.2.4.RELEASE</spring.version>
        <spring-security.version>4.0.3.RELEASE</spring-security.version>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-core</artifactId>
            <version>${spring.version}</version>
        </dependency>

        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-web</artifactId>
            <version>${spring.version}</version>
        </dependency>

        <dependency>
            <groupId>org.springframework.security</groupId>
            <artifactId>spring-security-web</artifactId>
            <version>${spring-security.version}</version>
        </dependency>
        <dependency>
            <groupId>org.springframework.security</groupId>
            <artifactId>spring-security-config</artifactId>
            <version>${spring-security.version}</version>
        </dependency>

        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>javax.servlet-api</artifactId>
            <version>3.1.0</version>
            <scope>provided</scope>
        </dependency>

        <dependency>
            <groupId>javax.servlet.jsp</groupId>
            <artifactId>jsp-api</artifactId>
            <version>2.1</version>
            <scope>provided</scope>
        </dependency>

        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-webmvc</artifactId>
            <version>${spring.version}</version>
        </dependency>

        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-test</artifactId>
            <version>${spring.version}</version>
            <scope>test</scope>
        </dependency>

        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.11</version>
            <scope>test</scope>
        </dependency>
        
        <dependency>
            <groupId>jstl</groupId>
            <artifactId>jstl</artifactId>
            <version>1.2</version>
        </dependency>
    </dependencies>
```

### 5. Create Spring Security configuration and use custom login form
**SecurityConfig.java**
```java
@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    public void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {
        auth
                .inMemoryAuthentication()
                .withUser("user").password("password").roles("USER").and()
                .withUser("sa").password("123").roles("USER");
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.authorizeRequests()
                .antMatchers("/resources/**","/join").permitAll()
                .anyRequest().authenticated()
                .and()
                .formLogin()
//                .and().httpBasic();
                .loginPage("/login").permitAll()
                .and().logout().permitAll();
    }
}
```


### 6. Register Spring Security
**SecurityWebApplicationInitializer.java**
```java
import org.springframework.security.web.context.AbstractSecurityWebApplicationInitializer;

public class SecurityWebApplicationInitializer extends AbstractSecurityWebApplicationInitializer {

    //register Spring Security in getRootConfigClasses
//    public SecurityWebApplicationInitializer() {
//        super(SecurityConfig.class);
//    }
}
```
**MyWebInitializer.java**
```java
package com.example.config;

import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

public class MyWebInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {
    @Override
    protected Class<?>[] getRootConfigClasses() {
        return new Class<?>[]{RootConfig.class, SecurityConfig.class};
    }

    @Override
    protected Class<?>[] getServletConfigClasses() {
        return new Class<?>[]{WebConfig.class};
    }

    @Override
    protected String[] getServletMappings() {
        return new String[]{"/"};
    }
}
```

### 7. Create Controller
**HelloController.java**
```java
...
import java.security.Principal;

@Controller
public class HelloController {
    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String printWelcome(ModelMap model, Principal principal) {
        String username = principal.getName();
        model.addAttribute("username", username);
        return "hello";
    }
```
#### Login view controller
```java
    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public String login() {
        return "login";
    }
}
```

### 8. Create login view
**login.jsp**
```html
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
```
> Remember to add CSRF token to the login form 
```<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>```

