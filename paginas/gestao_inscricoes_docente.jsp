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
psImagem = conn.prepareStatement(imagemSql); // Atribuindo o PreparedStatement
// Converte o atributo "idUtilizador" para Integer
psImagem.setInt(1, Integer.parseInt((String) session.getAttribute("idUtilizador")));
rsImagem = psImagem.executeQuery(); // Atribuindo o ResultSet
// Verifica se há resultados
if (rsImagem.next()) {
    String imagem = rsImagem.getString("imagem");
%>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestão de Inscricaos</title>
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

    <h1>Gestão de Inscrições</h1>
    <% 
    try {
        String sql = "SELECT * FROM inscricoes " +"INNER JOIN cursos ON inscricoes.id_curso = cursos.id_curso " +
             "WHERE cursos.id_docente = ? " +
             "ORDER BY cursos.id_curso DESC, inscricoes.v_exam_nacional DESC";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt((String) session.getAttribute("idUtilizador")));
            rs = ps.executeQuery();

        if (rs.next()) {
    %>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Aluno</th>
                    <th>Curso</th>
                    <th>Valor do Exame Nacional</th>
                    <th>Data de Inscrição</th>
                    <th>Status da Inscrição</th>
                    <th>Ações</th>
                </tr>
    <%
            do {
                String nomeUtilizador = "";

                String id_aluno = rs.getString("id_aluno");
                String alunoSql = "SELECT nomeUtilizador FROM utilizador WHERE idUtilizador = ?";
                psAluno = conn.prepareStatement(alunoSql);
                psAluno.setString(1, id_aluno);
                rsAluno = psAluno.executeQuery();

                if (rsAluno.next()) {
                    nomeUtilizador = rsAluno.getString("nomeUtilizador");
                }

                String titulo = "";

                String id_curso = rs.getString("id_curso");
                String cursoSql = "SELECT titulo FROM cursos WHERE id_curso = ?";
                psTituloCurso = conn.prepareStatement(cursoSql);
                psTituloCurso.setString(1, id_curso);
                rsTituloCurso = psTituloCurso.executeQuery();

                if (rsTituloCurso.next()) {
                    titulo = rsTituloCurso.getString("titulo");
                }

                String esdadoDesc = "";

                String estadocurso = rs.getString("status_inscricao");
                String estadoSql = "SELECT * FROM status_inscricao WHERE id_status_inscricao = ?";
                psEstado = conn.prepareStatement(estadoSql);
                psEstado.setString(1, estadocurso);
                rsEstado = psEstado.executeQuery();

                if (rsEstado.next()) {
                    esdadoDesc = rsEstado.getString("desc");
                }
    %>
                <tr>
                    <td><%= rs.getString("id_inscricao") %></td>
                    <td><%= nomeUtilizador %></td>
                    <td><%= titulo %></td>
                    <td><%= rs.getString("v_exam_nacional") %></td>
                    <td><%= rs.getString("data_inscricao") %></td>
                    <td><%= esdadoDesc %></td>
                    <td>
                        <form id="aprovar_inscricao" action="aprovar_inscricao_docente.jsp" method="POST" style="display:inline;">
                            <input type="hidden" name="id_inscricao" value="<%= rs.getString("id_inscricao") %>">
                            <input type="hidden" name="id_curso" value="<%= rs.getString("id_curso") %>">
                            <input type="submit" value="Aprovar">
                        </form>
                        |
                        <form id="editar_inscricao" action="editar_inscricao_docente.jsp" method="POST" style="display:inline;">
                            <input type="hidden" name="id_inscricao" value="<%= rs.getString("id_inscricao") %>">
                            <input type="submit" value="Editar">
                        </form>
                        |
                        <form id="excluir_inscricao" action="excluir_inscricao_docente.jsp" method="POST" style="display:inline;">
                            <input type="hidden" name="id_inscricao" value="<%= rs.getString("id_inscricao") %>">
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
    <button onclick="location.href='adicionar_inscricao_docente.jsp'">Adicionar Inscrição</button>
    <div id="footer">
        <p>&copy; Guilherme Pires & Tiago Farinha</p>
    </div>
</body>

</html>