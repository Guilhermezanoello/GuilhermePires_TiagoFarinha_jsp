<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.io.*" %>
<%@ include file="../basedados/basedados.h" %>
<!DOCTYPE html>
<html lang="pt-br">
<%
session = request.getSession();
if (session.getAttribute("tipoUtilizador") == null || !session.getAttribute("tipoUtilizador").equals("2")) {
    out.println("<script>alert('UTILIZADOR NÃO AUTORIZADO: CONTACTE O ADMIN OU ENTRE COM OUTRO UTILIZADOR!')</script>");
    response.setHeader("Refresh", "0; URL=home.jsp");
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
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestão de Cursos</title>
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

        table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 30px;
        background-color:  #42A5F5;  /* Cor de fundo da tabela */
        color: black;  /* Cor do texto da tabela */
        }

        th,
        td {
            padding: 8px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #42A5F5;  /* Azul Secundário */
            color: whitesmoke;  /* Brancofumado */
        }

        tr:nth-child(even) {
            background-color: #BBDEFB;  /* Azul Claro */
        }

        tr:hover {
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
    <h1>Gestão de Cursos</h1>
    <% 
    try {
        String sql = "SELECT * FROM cursos WHERE id_docente = ?";
        ps = conn.prepareStatement(sql);
        ps.setString(1, (String) session.getAttribute("idUtilizador"));
        rs = ps.executeQuery();

        if (rs.next()) {
    %>
            <table>
                <tr><th>ID</th><th>Título</th><th>Docente</th><th>Tipo de Curso</th>
                  <th>Data de Início</th><th>Data de Fim</th><th>Limite de Alunos</th>
                  <th>Estado do Curso</th><th>Ações</th></tr>
    <%
            do {
                String nomeUtilizador = "";

                String id_docente = rs.getString("id_docente");
                String docenteSql = "SELECT nomeUtilizador FROM utilizador WHERE idUtilizador = ?";
                psDocente = conn.prepareStatement(docenteSql);
                psDocente.setString(1, id_docente);
                rsDocente = psDocente.executeQuery();

                if (rsDocente.next()) {
                    nomeUtilizador = rsDocente.getString("nomeUtilizador");
                }

                String descricao = "";

                String tipo_curso = rs.getString("tipo_curso");
                String cursoSql = "SELECT descricao FROM tipo_curso WHERE id_tipo_curso = ?";
                psTipoCurso = conn.prepareStatement(cursoSql);
                psTipoCurso.setString(1, tipo_curso);
                rsTipoCurso = psTipoCurso.executeQuery();

                if (rsTipoCurso.next()) {
                    descricao = rsTipoCurso.getString("descricao");
                }

                String esdadoDesc = "";

                String estadocurso = rs.getString("estado_curso");
                String estadoSql = "SELECT * FROM estadocurso WHERE id_estado_curso = ?";
                psEstado = conn.prepareStatement(estadoSql);
                psEstado.setString(1, estadocurso);
                rsEstado = psEstado.executeQuery();

                if (rsEstado.next()) {
                    esdadoDesc = rsEstado.getString("desc");
                }
    %>
                <tr>
                    <td><%= rs.getString("id_curso") %></td>
                    <td><%= rs.getString("titulo") %></td>
                    <td><%= nomeUtilizador %></td>
                    <td><%= descricao %></td>
                    <td><%= rs.getString("data_inicio") %></td>
                    <td><%= rs.getString("data_fim") %></td>
                    <td><%= rs.getString("limite_alunos") %></td>
                    <td><%= esdadoDesc %></td>
                    <td>
                        <form id="editar_inscricao" action="editar_curso_docente.jsp" method="POST" style="display:inline;">
                            <input type="hidden" name="id_curso" value="<%= rs.getString("id_curso") %>">
                            <input type="submit" value="Editar">
                        </form>
                        |
                        <form id="excluir_inscricao" action="excluir_curso_docente.jsp" method="POST" style="display:inline;">
                            <input type="hidden" name="id_curso" value="<%= rs.getString("id_curso") %>">
                            <input type="submit" value="Apagar">
                        </form>
                    </td>
                </tr>
    <%
            } while (rs.next());
    %>
            </table>
    <%
        } else {
            out.println("Nenhum registro encontrado.");
        }

        ps.close();
        psImagem.close();
        rsImagem.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }}
    %>
    <button onclick="location.href='adicionar_cursos_docente.jsp'">Adicionar Cursos</button>
    <div id="footer">
        <p>&copy; Guilherme Pires & Tiago Farinha</p>
    </div>
</body>

</html>
