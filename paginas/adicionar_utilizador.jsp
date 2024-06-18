<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.io.*" %>
<%@ include file="../basedados/basedados.h" %>
<!DOCTYPE html>
<html lang="pt-br">
<%
session = request.getSession();
if (session.getAttribute("tipoUtilizador") == null || !session.getAttribute("tipoUtilizador").equals("1")) {
    out.println("<script>alert('UTILIZADOR NÃO AUTORIZADO: CONTACTE O ADMIN OU ENTRE COM OUTRO UTILIZADOR!')</script>");
    response.setHeader("Refresh", "0; URL=home.jsp");
}
%>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Adicionar Utilizador</title>
    <link rel="stylesheet" href="style.css">

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

    #conteudo-principal {
        margin-bottom: 80px;
    }

    .footer-space {
        height: 50px;
    }
</style>
</head>

<body>
    <ul>
        <li><a href="home.jsp">Home</a></li>
        <li><a href="contactos.jsp">Contactos</a></li>
        <li><a href="infomais.jsp">Info +</a></li>
        <li><a class="active" href="pgLogadoAdmin.jsp">Menu</a></li>
        <li style="float:right"><a href="logout.jsp">Logout</a></li>
        <img style="float:right" src="./admin.png" width="60" height="60" id="img">
    </ul>
    <h1>Adicionar Utilizador</h1>

    <div id="conteudo-principal">
        <form method="POST" action="processar_adicionar_utilizador.jsp">
            <label for="nomeUtilizador">Nome:</label>
            <input type="text" id="nomeUtilizador" name="nomeUtilizador" required><br>

            <label for="pass">Senha:</label>
            <input type="password" id="pass" name="pass" required><br>

            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required><br>

            <label for="imagem">Imagem:</label>
            <input type="text" id="imagem" name="imagem" required><br>

            <label for="morada">Morada:</label>
            <input type="text" id="morada" name="morada" required><br>

            <label for="telemovel">Telemóvel:</label>
            <input type="tel" id="telemovel" name="telemovel" required><br>

            <label for="tipoUtilizador">Tipo de Utilizador:</label>
            <select id="tipoUtilizador" name="tipoUtilizador" required>
                <option value="1">Administrador</option>
                <option value="2">Docente</option>
                <option value="3">Aluno</option>
                <option value="4">Utilizador não validado</option>
                <option value="5">Utilizador apagado</option>
            </select><br>
            <button type="submit">Adicionar Utilizador</button>
        </form>
    </div>
    <div id="footer" class="footer-space">
        <p>&copy; Guilherme Pires & Tiago Farinha</p>
    </div>
</body>

</html>