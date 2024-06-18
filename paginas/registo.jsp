<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="pt-br">

<head>
    <link rel="stylesheet" href="style.css">
    <!--<link rel="stylesheet" href="stylelogin.css">-->
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registo</title>
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
        font-weight: bold;  /* Deixa o texto em negrito */
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
        <li style="float:right"><a href="login.jsp">Login</a></li>
        <li style="float:right"><a class="active" href="registo.jsp">Regista-te</a></li>
    </ul>
    <h1 style="color: whitesmoke ;">FormaEst - Educação por Excelência!!!</h1>

    <h1 style="color: whitesmoke ">Registo</h1>

    <div id="section">
        <form action="processar_registo.jsp" method="POST">
            <label for="nomeUtilizador">Utilizador:</label>
            <input type="text" id="nomeUtilizador" name="nomeUtilizador" required><br><br>

            <label for="senha">Senha:</label>
            <input type="password" id="senha" name="senha" required><br><br>

            <label for="nome">Nome:</label>
            <input type="text" id="nome" name="nome" required><br><br>

            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required><br><br>

            <label for="telemovel">Telemóvel:</label>
            <input type="tel" id="telemovel" name="telemovel" required><br><br>

            <label for="morada">Morada:</label>
            <input type="text" id="morada" name="morada" required><br><br>

            <input type="submit" value="Enviar">
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