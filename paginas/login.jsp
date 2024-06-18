<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="pt-br">

<head>
    <link rel="stylesheet" href="style.css">
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>

<style>
    body {
        background-color: #001f3f;  /* Azul Marinho */
    }
    ul {
        list-style-type: none;
        margin: 0;
        padding: 0;
        overflow: hidden;
        background-color: #42A5F5;  /* Azul Secundário */
    }
    
    li {
        float: left;
    }
    
    li a {
        display: block;
        color: whitesmoke;  /* Brancofumado */
        text-align: center;
        padding: 14px 16px;
        text-decoration: none;
        font-weight: bold; 
    }
    
    li a:hover:not(.active) {
        background-color: #BBDEFB;  /* Azul Claro */
    }

    .active {
        background-color: #1976D2;  /* Azul Escuro */
    }
</style>
</head>

<body>
    <ul>
        <li><a href="home.jsp">Home</a></li>
        <li><a href="contactos.jsp">Contactos</a></li>
        <li><a href="infomais.jsp">Info +</a></li>
        <%
        session = request.getSession();
        if (session.getAttribute("tipoUtilizador") == null) {
            out.println("<li style=\"float:right\"><a class=\"active\" href=\"login.jsp\">Login</a></li>");
            out.println("<li style=\"float:right\"><a href=\"registo.jsp\">Regista-te</a></li>");
        } else {
            out.println("<script> alert('VOCÊ JÁ ESTÁ LOGADO: REALIZE LOGOUT PARA ENTRAR COM OUTRA CONTA!')</script>");
            out.println("<li style=\"float:right\"><a href=\"logout.jsp\">Logout</a></li>");
        }
        %>
        
    </ul>
    <h1 style="color: whitesmoke ;">FormaEst - Educação por Excelência!!!</h1>

    <h1 style="color: whitesmoke">Login</h1>

    <div id="section">
        <form action="processar_login.jsp" method="POST">
            <label for="utilizador">Utilizador:</label>
            <input type="text" id="utilizador" name="utilizador" required><br><br>

            <label for="senha">Senha:</label>
            <input type="password" id="senha" name="senha" required><br><br>

            
            <input type="submit" value="Entrar">
        </form>
        <div class="article">
            <h1></h1>
            <p></p>
        </div>
        <div class="article">
            <h1></h1>
            <p></p>
        </div>
    </div>
    <div id="footer">
        <p>&copy; Guilherme Pires & Tiago Farinha</p>
    </div>
</body>

</html>