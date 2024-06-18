<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.io.*" %>
<%@ include file="../basedados/basedados.h" %>
<%
session = request.getSession();
if (session.getAttribute("tipoUtilizador") == null || !session.getAttribute("tipoUtilizador").equals("1")) {
    out.println("<script>alert('UTILIZADOR NÃO AUTORIZADO: CONTACTE O ADMIN OU ENTRE COM OUTRO UTILIZADOR!')</script>");
    response.setHeader("Refresh", "0; URL=home.jsp");
}

// Verifica se o ID do utilizador foi passado por parâmetro
String idUtilizador = request.getParameter("idUtilizador");
if (idUtilizador != null) {
    try {
        // Consulta para obter os dados do utilizador pelo ID
        String sql = "SELECT * FROM utilizador WHERE idUtilizador = ?";
        ps = conn.prepareStatement(sql);
        ps.setString(1, idUtilizador);
        rs = ps.executeQuery();

        if (rs.next()) {
            String nomeUtilizador = rs.getString("nomeUtilizador");
            String mail = rs.getString("mail");
            String imagem = rs.getString("imagem");
            String morada = rs.getString("morada");
            String telemovel = rs.getString("telemovel");
            String tipoUtilizador = rs.getString("tipoUtilizador");

            // Consulta para obter os tipos de utilizador
            String tipoSql = "SELECT * FROM tipoutilizador";
            psTipo = conn.prepareStatement(tipoSql);
            rsTipo = psTipo.executeQuery();

%>
            <!DOCTYPE html>
            <html lang="pt-br">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Editar Utilizador</title>
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
                    <img style="float:right" src="./admin.png" width="46" height="46" id="img">
                </ul>
                <h1>Editar Utilizador</h1>
                <div id="conteudo-principal">
                    <form action="atualizar_utilizador.jsp" method="POST">
                        <input type="hidden" name="idUtilizador" value="<%= idUtilizador %>">
                        <label for="nome">Nome:</label>
                        <input type="text" name="nome" id="nome" value="<%= nomeUtilizador %>">
                        <label for="pass">Senha:</label>
                        <input type="password" id="pass" name="pass"><br>
                        <label for="email">Email:</label>
                        <input type="email" name="email" id="email" value="<%= mail %>">
                        <label for="imagem">Imagem:</label>
                        <input type="text" name="imagem" id="imagem" value="<%= imagem %>">
                        <label for="morada">Morada:</label>
                        <input type="text" name="morada" id="morada" value="<%= morada %>">
                        <label for="telefone">Telefone:</label>
                        <input type="text" name="telefone" id="telefone" value="<%= telemovel %>">
                        <label for="tipo">Tipo de Utilizador:</label><br>
                        <select name="tipo" id="tipo">
<%
            
            while (rsTipo.next()) {
                String idTipo = rsTipo.getString("id_Tipo");
                String descricao = rsTipo.getString("descricao");
                if (tipoUtilizador.equals(idTipo)) {
%>
                            <option value="<%= idTipo %>" selected><%= descricao %></option>
<%
                } else {
%>
                            <option value="<%= idTipo %>"><%= descricao %></option>
<%
                }
            }
            rsTipo.close();
%>
                        </select><br>            
                        <input type="submit" value="Atualizar">
                    </form>
                </div>
                <div id="footer" class="footer-space">
                    <p>&copy; Guilherme Pires & Tiago Farinha</p>
                </div>
            </body>
            </html>
<%
        } else {
            out.println("Utilizador não encontrado.");
        }
        rs.close();
        ps.close();
        psTipo.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
} else {
    out.println("ID do utilizador não fornecido.");
}
%>
