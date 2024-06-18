<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.io.*" %>
<%@ include file="../basedados/basedados.h" %>
<!DOCTYPE html>
<html lang="pt-br">
<%
String imagem = ""; // Inicializa a variável imagem

try {
    session = request.getSession();
    if (session.getAttribute("tipoUtilizador") == null || !session.getAttribute("tipoUtilizador").equals("2")) {
        out.println("<script>alert('UTILIZADOR NÃO AUTORIZADO: CONTACTE O ADMIN OU ENTRE COM OUTRO UTILIZADOR!')</script>");
        response.setHeader("Refresh", "0; URL=home.jsp");
    } else {
        // Consulta SQL para obter informações do usuário
        String imagemSql = "SELECT * FROM utilizador WHERE idUtilizador = ?";
        psImagem = conn.prepareStatement(imagemSql); // Atribuindo o PreparedStatement
        // Convertendo o atributo "idUtilizador" para Integer
        psImagem.setInt(1, Integer.parseInt((String) session.getAttribute("idUtilizador")));
        rsImagem = psImagem.executeQuery(); // Atribuindo o ResultSet
        // Verificando se há resultados
        if (rsImagem.next()) {
            imagem = rsImagem.getString("imagem");

            String queryDocentes = "SELECT idUtilizador, nomeUtilizador FROM utilizador WHERE idUtilizador = ?";
            psDocente = conn.prepareStatement(queryDocentes);
            psDocente.setString(1, (String) session.getAttribute("idUtilizador"));
            rsDocente = psDocente.executeQuery();

            String queryTiposCurso = "SELECT id_tipo_curso, descricao FROM tipo_curso";
            psTipoCurso = conn.prepareStatement(queryTiposCurso);
            rsTipoCurso = psTipoCurso.executeQuery();
        }
    }
} catch (SQLException e) {
    e.printStackTrace();
}
%>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Adicionar Curso</title>
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
        <li><a class="active" href="pgLogadoDocente.jsp">Menu</a></li>
        <% if (session.getAttribute("nomeUtilizador") == null) { %>
            <li style="float:right"><a href="login.jsp">Login</a></li>
            <li style="float:right"><a href="registo.jsp">Regista-te</a></li>
        <% } else { %>
            <li style="float:right"><a href="logout.jsp">Logout</a></li>        
            <img style="float:right" src="./<%= imagem %>" width="46" height="46" id="img">
        <% } %>
    </ul>

    <h1>Adicionar Curso</h1>
    <form action="processar_curso_docente.jsp" method="POST">
        <label for="titulo">Título do Curso:</label>
        <input type="text" name="titulo" id="titulo" required>
        <label for="descricao">Descrição:</label>
        <textarea id="descricao" name="descricao"></textarea><br>

        <label for="docente">Docente:</label>
        <select name="docente" id="docente">
            <option value="" disabled selected>Selecione um docente</option>
            <% 
                while (rsDocente.next()) { 
            %>
                    <option value="<%= rsDocente.getInt("idUtilizador") %>"><%= rsDocente.getString("nomeUtilizador") %></option>
            <% 
                } 
            %>
        </select>

        <label for="tipo_curso">Tipo de Curso:</label>
        <select name="tipo_curso" id="tipo_curso">
            <option value="" disabled selected>Selecione um tipo de curso</option>
            <% 
                while (rsTipoCurso.next()) { 
            %>
                    <option value="<%= rsTipoCurso.getInt("id_tipo_curso") %>"><%= rsTipoCurso.getString("descricao") %></option>
            <% 
                } 
            %>
        </select>

        <label for="data_inicio">Data de Início:</label>
        <input type="date" name="data_inicio" id="data_inicio" required>

        <label for="data_fim">Data de Fim:</label>
        <input type="date" name="data_fim" id="data_fim" required>

        <label for="limite_alunos">Limite de Alunos:</label>
        <input type="number" name="limite_alunos" id="limite_alunos" min="0" max="30" required><br><br>

        <input type="submit" value="Adicionar Curso">
    </form>

    <!-- Rodapé -->
    <div id="footer">
        <p>&copy; Guilherme Pires & Tiago Farinha</p>
    </div>

    <% 
        // Fechar recursos e conexão com o banco de dados
        try {
            if (rsDocente != null) rsDocente.close();
            if (psDocente != null) psDocente.close();
            if (rsTipoCurso != null) rsTipoCurso.close();
            if (psTipoCurso != null) psTipoCurso.close();
            if (rsImagem != null) rsImagem.close();
            if (psImagem != null) psImagem.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        } 
    %>
</body>
</html>
