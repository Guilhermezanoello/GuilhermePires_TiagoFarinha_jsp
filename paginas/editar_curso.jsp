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
    <title>Editar Curso</title>
    <link rel="stylesheet" href="style.css">
    <style>
        body {
            background-color: #001f3f;
            /* Azul Marinho */
        }

        ul {
            list-style-type: none;
            margin: 0;
            padding: 0;
            overflow: hidden;
            background-color: #42A5F5;
            /* Azul Secundário */
        }

        li {
            float: left;
        }

        li a {
            display: block;
            color: whitesmoke;
            /* Brancofumado */
            text-align: center;
            padding: 14px 16px;
            text-decoration: none;
            font-weight: bold;
        }

        li a:hover:not(.active) {
            background-color: #BBDEFB;
            /* Azul Claro */
        }

        .active {
            background-color: #1976D2;
            /* Azul Escuro */
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
        <% if (session.getAttribute("nomeUtilizador") == null) { %>
            <li style="float:right"><a href="login.jsp">Login</a></li>
            <li style="float:right"><a href="registo.jsp">Regista-te</a></li>
        <% } else { %>
            <li style="float:right"><a href="logout.jsp">Logout</a></li>
            <img style="float:right" src="./admin.png" width="46" height="46" id="img">
        <% } %>
    </ul>

    <h1>Editar Curso</h1>

    <%
        if (request.getParameter("id_curso") != null) {
            int idCurso = Integer.parseInt(request.getParameter("id_curso"));

            // Verifica se o curso existe
            try {
                String sql = "SELECT * FROM cursos WHERE id_curso = ?";
                ps = conn.prepareStatement(sql);
                ps.setInt(1, idCurso);
                rs = ps.executeQuery();

                if (rs.next()) {
                    String titulo = rs.getString("titulo");
                    String descricao = rs.getString("descricao");
                    String dataInicio = rs.getString("data_inicio");
                    String dataFim = rs.getString("data_fim");
                    int limiteAlunos = rs.getInt("limite_alunos");
                    int idDocente = rs.getInt("id_docente");
                    int tipoCurso = rs.getInt("tipo_curso");
                    int estadoCurso = rs.getInt("estado_curso");
    %>

                    <form action="atualizar_curso.jsp" method="POST">
                        <input type="hidden" name="idCurso" value="<%= idCurso %>">

                        <label for="titulo">Título do Curso:</label>
                        <input type="text" id="titulo" name="titulo" value="<%= titulo %>"><br>

                        <label for="descricao">Descrição:</label>
                        <textarea id="descricao" name="descricao"><%= descricao %></textarea><br>

                        <label for="dataInicio">Data de Início:</label>
                        <input type="date" id="dataInicio" name="dataInicio" value="<%= dataInicio %>"><br>

                        <label for="dataFim">Data de Fim:</label>
                        <input type="date" id="dataFim" name="dataFim" value="<%= dataFim %>"><br>

                        <label for="limiteAlunos">Limite de Alunos:</label>
                        <input type="number" id="limiteAlunos" name="limiteAlunos" min="0" max="30" value="<%= limiteAlunos %>"><br>

                        <label for="idDocente">Docente:</label>
                        <select name="idDocente" id="idDocente">
                            <% 
                                // Buscar docentes no banco de dados
                                String sqlDocentes = "SELECT idUtilizador, nomeUtilizador FROM utilizador WHERE tipoUtilizador = 2";
                                psDocente = conn.prepareStatement(sqlDocentes);
                                rsDocente = psDocente.executeQuery();

                                while (rsDocente.next()) {
                                    int docenteId = rsDocente.getInt("idUtilizador");
                                    String nomeDocente = rsDocente.getString("nomeUtilizador");
                                    String selected = (docenteId == idDocente) ? "selected" : "";
                            %>
                                    <option value="<%= docenteId %>" <%= selected %>><%= nomeDocente %></option>
                            <% } %>
                        </select><br>

                        <label for="tipoCurso">Tipo de Curso:</label>
                        <select name="tipoCurso" id="tipoCurso">
                            <% 
                                // Buscar tipos de curso no banco de dados
                                String sqlTiposCurso = "SELECT id_tipo_curso, descricao FROM tipo_curso";
                                psTipoCurso = conn.prepareStatement(sqlTiposCurso);
                                rsTipoCurso = psTipoCurso.executeQuery();

                                while (rsTipoCurso.next()) {
                                    int tipoCursoId = rsTipoCurso.getInt("id_tipo_curso");
                                    String descricaoTipoCurso = rsTipoCurso.getString("descricao");
                                    String selected = (tipoCursoId == tipoCurso) ? "selected" : "";
                            %>
                                    <option value="<%= tipoCursoId %>" <%= selected %>><%= descricaoTipoCurso %></option>
                            <% } %>
                        </select><br>

                        <label for="estadoCurso">Estado do Curso:</label>
                        <select name="estadoCurso" id="estadoCurso">
                            <% 
                                // Busca os estados de curso
                                String sqlEstadosCurso = "SELECT id_estado_curso, `desc` FROM estadocurso";
                                psEstado = conn.prepareStatement(sqlEstadosCurso);
                                rsEstado = psEstado.executeQuery();

                                while (rsEstado.next()) {
                                    int estadoId = rsEstado.getInt("id_estado_curso");
                                    String estadoDesc = rsEstado.getString("desc");
                                    String selected = (estadoId == estadoCurso) ? "selected" : "";
                            %>
                                    <option value="<%= estadoId %>" <%= selected %>><%= estadoDesc %></option>
                            <% } %>
                        </select><br>

                        <input type="submit" value="Atualizar">
                    </form>
    <%
                } else {
                    out.println("Curso não encontrado.");
                }

                ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else {
            out.println("ID do curso não fornecido.");
        }
    %>

    <div id="footer">
        <p>&copy; Guilherme Pires & Tiago Farinha</p>
    </div>

</body>

</html>
