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
    <title>Gestão de Utilizadores</title>
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
        text-align: center;
    }

    th {
        background-color: #42A5F5;  /* Azul Secundário */
        color: whitesmoke;  /* Brancofumado */
        text-align: center;
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
        <li><a class="active" href="pgLogadoAdmin.jsp">Menu</a></li>
        <% if (session.getAttribute("tipoUtilizador") == null) { %>
            <li style="float:right"><a href="login.jsp">Login</a></li>
            <li style="float:right"><a href="registo.jsp">Regista-te</a></li>
        <% } else { %>
            <li style="float:right"><a href="logout.jsp">Logout</a></li>
            <img style="float:right" src="./admin.png" width="46" height="46" id="img">
        <% } %>
    </ul>
    <h1>Gestão de Utilizadores</h1>

    <% 
    try {
        String sql = "SELECT * FROM utilizador";
        ps = conn.prepareStatement(sql);
        rs = ps.executeQuery();

        if (rs.next()) {
    %>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>Email</th>
                    <th>Imagem</th>
                    <th>Morada</th>
                    <th>Telefone</th>
                    <th>Tipo de Utilizador</th>
                    <th>Ações</th>
                </tr>
    <%
            do {
                String descricao = "";

                String tipoUtilizador = rs.getString("tipoUtilizador");
                String tipoSql = "SELECT descricao FROM tipoutilizador WHERE id_Tipo = ?";
                psTipo = conn.prepareStatement(tipoSql);
                psTipo.setString(1, tipoUtilizador);
                rsTipo = psTipo.executeQuery();

                if (rsTipo.next()) {
                    descricao = rsTipo.getString("descricao");
                }
    %>
                <tr>
                    <td><%= rs.getString("idUtilizador") %></td>
                    <td><%= rs.getString("nomeUtilizador") %></td>
                    <td><%= rs.getString("mail") %></td>
                    <td><%= rs.getString("imagem") %></td>
                    <td><%= rs.getString("morada") %></td>
                    <td><%= rs.getString("telemovel") %></td>
                    <td><%= descricao %></td>
                    <td>
                        <form id="editar_inscricao" action="editar_utilizador.jsp" method="POST" style="display:inline;">
                            <input type="hidden" name="idUtilizador" value="<%= rs.getString("idUtilizador") %>">
                            <input type="submit" value="Editar">
                        </form>
                        |
                        <form id="excluir_inscricao" action="apagar_utilizador.jsp" method="POST" style="display:inline;">
                            <input type="hidden" name="idUtilizador" value="<%= rs.getString("idUtilizador") %>">
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
    } catch (SQLException e) {
        e.printStackTrace();
    }
    %>

    <button onclick="location.href='adicionar_utilizador.jsp'">Adicionar Novo Utilizador</button>

    <div id="footer">
        <p>&copy; Guilherme Pires & Tiago Farinha</p>
    </div>
</body>

</html>
