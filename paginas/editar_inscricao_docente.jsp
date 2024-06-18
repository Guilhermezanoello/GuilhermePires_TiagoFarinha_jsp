<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.io.*" %>
<%@ include file="../basedados/basedados.h" %>
<%
    session = request.getSession();
    if (session.getAttribute("tipoUtilizador") == null || !session.getAttribute("tipoUtilizador").equals("2")) {
        out.println("<script>alert('UTILIZADOR NÃO AUTORIZADO: CONTACTE O ADMIN OU ENTRE COM OUTRO UTILIZADOR!')</script>");
        response.setHeader("Refresh", "0; URL=home.jsp");
        return;
    }
    // Consulta SQL para obter informações do usuário
    String imagemSql = "SELECT * FROM utilizador WHERE idUtilizador = ?";
    psImagem = conn.prepareStatement(imagemSql);
    // Converte o atributo "idUtilizador" para Integer
    psImagem.setInt(1, Integer.parseInt((String) session.getAttribute("idUtilizador")));
    rsImagem = psImagem.executeQuery();
    // Verifica se há resultados
    if (rsImagem.next()) {
        String imagem = rsImagem.getString("imagem");
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Inscrição</title>
    <link rel="stylesheet" href="style.css">
    <style>
        body {
            background-color: #001f3f;
        }

        ul {
            list-style-type: none;
            margin: 0;
            padding: 0;
            overflow: hidden;
            background-color: #42A5F5;
        }

        li {
            float: left;
        }

        li a {
            display: block;
            color: whitesmoke;
            text-align: center;
            padding: 14px 16px;
            text-decoration: none;
            font-weight: bold;
        }

        li a:hover:not(.active) {
            background-color: #BBDEFB;
        }

        .active {
            background-color: #1976D2;
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
    <h1>Editar Inscrição</h1>

    <%
        if (request.getParameter("id_inscricao") != null) {
            int id_inscricao = Integer.parseInt(request.getParameter("id_inscricao"));

            // Verifica se a inscrição existe no banco de dados
            String sql = "SELECT * FROM inscricoes WHERE id_inscricao = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id_inscricao);
            rs = ps.executeQuery();

            if (rs.next()) {
                int idAluno = rs.getInt("id_aluno");
                int idCurso = rs.getInt("id_curso");
                String dataInscricao = rs.getString("data_inscricao");
                int vExamNacional = rs.getInt("v_exam_nacional");
                int statusInscricao = rs.getInt("status_inscricao");
    %>

    <form action="atualizar_inscricao_docente.jsp" method="POST">
        <input type="hidden" name="id_inscricao" value="<%= id_inscricao %>">

        <label for="aluno">Aluno:</label>
        <select name="aluno" id="aluno">
            <% 
                String sqlAlunos = "SELECT idUtilizador, nomeUtilizador FROM utilizador WHERE tipoUtilizador = 3";
                psAluno = conn.prepareStatement(sqlAlunos);
                rsAluno = psAluno.executeQuery();
                while (rsAluno.next()) {
                    int idUtilizador = rsAluno.getInt("idUtilizador");
                    String nomeUtilizador = rsAluno.getString("nomeUtilizador");
                    String selected = (idUtilizador == idAluno) ? "selected" : "";
                    out.print("<option value='" + idUtilizador + "' " + selected + ">" + nomeUtilizador + "</option>");
                }
                rsAluno.close();
                psAluno.close();
            %>
        </select><br>

        <label for="curso">Curso:</label>
        <select name="curso" id="curso">
            <% 
                String sqlCursos = "SELECT id_curso, titulo FROM cursos WHERE id_docente = ?";
                psTipoCurso = conn.prepareStatement(sqlCursos);
                psTipoCurso.setInt(1, Integer.parseInt((String) session.getAttribute("idUtilizador")));
                rsTipoCurso = psTipoCurso.executeQuery();
                while (rsTipoCurso.next()) {
                    int idCursoItem = rsTipoCurso.getInt("id_curso");
                    String tituloCurso = rsTipoCurso.getString("titulo");
                    String selected = (idCursoItem == idCurso) ? "selected" : "";
                    out.println("<option value='" + idCursoItem + "' " + selected + ">" + tituloCurso + "</option>");
                }
                rsTipoCurso.close();
                psTipoCurso.close();
            %>
        </select><br>

        <label for="data_inscricao">Data de Inscrição:</label>
        <input type="datetime-local" id="data_inscricao" name="data_inscricao" value="<%= dataInscricao %>"><br>

        <label for="vExamNacional">Valor do Exame Nacional:</label>
        <input type="number" id="vExamNacional" name="vExamNacional" value="<%= vExamNacional %>"><br>

        <label for="status_inscricao">Status da Inscrição:</label>
        <select name="status_inscricao" id="status_inscricao">
            <% 
                String sqlStatusInscricao = "SELECT id_status_inscricao, `desc` FROM status_inscricao";
                psStatusInscricao = conn.prepareStatement(sqlStatusInscricao);
                rsStatusInscricao = psStatusInscricao.executeQuery();
                while (rsStatusInscricao.next()) {
                    int idStatusInscricao = rsStatusInscricao.getInt("id_status_inscricao");
                    String descStatusInscricao = rsStatusInscricao.getString("desc");
                    String selected = (idStatusInscricao == statusInscricao) ? "selected" : "";
                    out.println("<option value='" + idStatusInscricao + "' " + selected + ">" + descStatusInscricao + "</option>");
                }
                rsStatusInscricao.close();
                psStatusInscricao.close();
            %>
        </select><br>

        <input type="submit" value="Atualizar">
    </form>

    <% 
            } else {
                out.println("Inscrição não encontrada.");
            }
            rs.close();
            ps.close();            
            psImagem.close();
            rsImagem.close();
        } else {
            out.println("ID da inscrição não fornecido.");
        }}
    %>

    <div id="footer">
        <p>&copy; Guilherme Pires & Tiago Farinha</p>
    </div>
</body>
</html>
