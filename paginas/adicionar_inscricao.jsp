<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.io.*" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ include file="../basedados/basedados.h" %>
<!DOCTYPE html>
<html lang="pt-br">
<%
    // Define o valor padrão para formattedDateTime
    String formattedDateTime = "";

    try {
        session = request.getSession();
        if (session.getAttribute("tipoUtilizador") == null || !session.getAttribute("tipoUtilizador").equals("1")) {
            out.println("<script>alert('UTILIZADOR NÃO AUTORIZADO: CONTACTE O ADMIN OU ENTRE COM OUTRO UTILIZADOR!')</script>");
            response.setHeader("Refresh", "0; URL=home.jsp");
        }

        // Consulta para obter os alunos
        String queryAlunos = "SELECT idUtilizador, nomeUtilizador FROM utilizador WHERE tipoUtilizador = 3";
        psAluno = conn.prepareStatement(queryAlunos);
        rsAluno = psAluno.executeQuery();

        // Consulta para obter os cursos
        String queryCursos = "SELECT id_curso, titulo FROM cursos";
        psTipoCurso = conn.prepareStatement(queryCursos);
        rsTipoCurso = psTipoCurso.executeQuery();

        // Consulta para obter os estados de inscrição
        String queryStatusInscricao = "SELECT id_status_inscricao, `desc` FROM status_inscricao";
        psStatusInscricao = conn.prepareStatement(queryStatusInscricao);
        rsStatusInscricao = psStatusInscricao.executeQuery();

        // Define o fuso horário para Portugal (UTC+0)
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
        LocalDateTime currentDateTime = LocalDateTime.now();

        // Formata a data e hora atual
        formattedDateTime = currentDateTime.format(formatter);
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Adicionar Inscrição</title>
    <link rel="stylesheet" href="style.css">
    <style>
        body {
            background-color: #001f3f; /* Azul Marinho */
            margin-bottom: 60px;
        }

        ul {
            list-style-type: none;
            margin: 0;
            padding: 0;
            overflow: hidden;
            background-color: #42A5F5; /* Azul Secundário */
        }

        li {
            float: left;
        }

        li a {
            display: block;
            color: whitesmoke; /* Brancofumado */
            text-align: center;
            padding: 14px 16px;
            text-decoration: none;
            font-weight: bold;
        }

        li a:hover:not(.active) {
            background-color: #BBDEFB; /* Azul Claro */
        }

        .active {
            background-color: #1976D2; /* Azul Escuro */
        }

        form {
            margin-top: 30px;
        }

        label {
            display: block;
            margin-bottom: 10px;
        }

        input[type="submit"] {
            background-color: #42A5F5;
            color: white;
            padding: 10px 20px;
            border: none;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <ul>
        <li><a href="home.jsp">Home</a></li>
        <li><a href="contactos.jsp">Contactos</a></li>
        <li><a href="infomais.jsp">Info +</a></li>
        <li><a class="active" href="pgLogadoAdmin.jsp">Menu</a></li>
        <% if (session.getAttribute("nomeUtilizador") == null) { %>
            <li style="float:right"><a href="login.jsp">Login</a></li>
            <li style="float:right"><a href="registo.jsp">Regista-te</a></li>
        <% } else { %>
            <li style="float:right"><a href="logout.jsp">Logout</a></li>
            <img style="float:right" src="./admin.png" width="46" height="46" id="img">
        <% } %>
    </ul>
    <h1>Adicionar Inscrição</h1>
    <form action="processar_inscricao.jsp" method="POST">
        <label for="aluno">Aluno:</label>
        <select name="aluno" id="aluno">
            <option value="" disabled selected>Selecione um aluno</option>
            <% 
            while (rsAluno.next()) { 
            %>
                <option value="<%= rsAluno.getInt("idUtilizador") %>"><%= rsAluno.getString("nomeUtilizador") %></option>
            <% 
            } 
            %>
        </select>

        <label for="curso">Curso:</label>
        <select name="curso" id="curso">
            <option value="" disabled selected>Selecione um curso</option>
            <% 
            while (rsTipoCurso.next()) { 
            %>
                <option value="<%= rsTipoCurso.getInt("id_curso") %>"><%= rsTipoCurso.getString("titulo") %></option>
            <% 
            } 
            %>
        </select>

        <label for="data_inscricao">Data de Inscrição:</label>
        <input type="datetime-local" name="data_inscricao" id="data_inscricao" value="<%= formattedDateTime %>" required>

        <label for="v_exam_nacional">Valor do Exame Nacional:</label>
        <input type="number" name="v_exam_nacional" id="v_exam_nacional" min="0" max="20" required>

        <label for="status_inscricao">Status da Inscrição:</label>
        <select name="status_inscricao" id="status_inscricao">
            <option value="" disabled selected>Selecione um status de inscrição</option>
            <% 
            while (rsStatusInscricao.next()) { 
            %>
                <option value="<%= rsStatusInscricao.getInt("id_status_inscricao") %>"><%= rsStatusInscricao.getString("desc") %></option>
            <% 
            } 
            %>
        </select>

        <input type="submit" value="Adicionar Inscrição">
    </form>

    <% 
    // Fechar ligação e recursos
    try {
        if (rsAluno != null) rsAluno.close();
        if (psAluno != null) psAluno.close();
        if (rsTipoCurso != null) rsTipoCurso.close();
        if (psTipoCurso != null) psTipoCurso.close();
        if (rsStatusInscricao != null) rsStatusInscricao.close();
        if (psStatusInscricao != null) psStatusInscricao.close();
        if (conn != null) conn.close();
    } catch (SQLException e) {
        e.printStackTrace();
    } 
    %>
    <div id="footer">
        <p>&copy; Guilherme Pires & Tiago Farinha</p>
    </div>
</body>
</html>
