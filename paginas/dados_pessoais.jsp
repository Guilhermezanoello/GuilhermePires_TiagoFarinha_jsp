<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.io.*" %>
<%@ include file="../basedados/basedados.h" %>
<%
session = request.getSession();
if (session.getAttribute("tipoUtilizador") == null || Integer.parseInt(session.getAttribute("tipoUtilizador").toString()) < 1 || Integer.parseInt(session.getAttribute("tipoUtilizador").toString()) > 3) {
    out.println("<script>alert('UTILIZADOR NÃO AUTORIZADO: CONTACTE O ADMIN OU ENTRE COM OUTRO UTILIZADOR!')</script>");
    response.setHeader("Refresh", "0; url=home.jsp");
}

String sql = "SELECT * FROM utilizador WHERE idUtilizador = " + session.getAttribute("idUtilizador");
ResultSet result = null;
try {
    ps = conn.prepareStatement(sql);
    result = ps.executeQuery();
    if (result.next()) {
        String nomeUtilizador = result.getString("nomeUtilizador");
        String mail = result.getString("mail");
        String imagem = result.getString("imagem");
        String morada = result.getString("morada");
        String telemovel = result.getString("telemovel");
        
        %>

<!DOCTYPE html>
<html lang="pt-br">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="style.css">
    <title>Dados Pessoais</title>
<style>
    body {
        background-color: #001f3f;  /* Azul Marinho */
    }
        label {
            display: block;
            margin-top: 10px;
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
        <% 
        if (Integer.parseInt(session.getAttribute("tipoUtilizador").toString()) == 1) {
                out.println("<li><a href=\"pgLogadoAdmin.jsp\">Menu</a></li>");
            } else if (Integer.parseInt(session.getAttribute("tipoUtilizador").toString()) == 2) {
                out.println("<li><a href=\"pgLogadoDocente.jsp\">Menu</a></li>");
            } else if (Integer.parseInt(session.getAttribute("tipoUtilizador").toString()) == 3) {
                out.println("<li><a href=\"pgLogadoAluno.jsp\">Menu</a></li>");
            }
            out.println("<li style=\"float:right\"><a href=\"logout.jsp\">Logout</a></li>");
            out.println("<img style=\"float:right\" src=\"" + imagem + "\" width=\"46\" height=\"46\" id=\"img\">");
                
        %>
        </ul>
    <h1>Dados Pessoais</h1>
    <div id="conteudo-principal">
        <<form action="atualizar_dados.jsp" method="POST">
                    <label for="nomeUtilizador">Nome de Usuário:</label>
                    <input type="text" id="nomeUtilizador" name="nomeUtilizador" value="<%= nomeUtilizador %>" readonly>
        
                    <label for="pass">Senha:</label>
                    <input type="password" id="pass" name="pass"><br>
        
                    <label for="mail">Email:</label>
                    <input type="email" id="mail" name="mail" value="<%= mail %>">
        
                    <label for="imagem">Imagem:</label>
                    <input type="text" id="imagem" name="imagem" value="<%= imagem %>">
        
                    <label for="morada">Morada:</label>
                    <input type="text" id="morada" name="morada" value="<%= morada %>">
        
                    <label for="telemovel">Telemóvel:</label>
                    <input type="text" id="telemovel" name="telemovel" value="<%= telemovel %>">        
                    <input type="submit" value="Atualizar">
                </form>
    </div>
    <div id="footer">
        <p>&copy; Guilherme Pires & Tiago Farinha</p>
    </div>
</body>

</html>
<%
    }
} catch (SQLException e) {
    out.println("Erro ao executar consulta SQL: " + e.getMessage());
} finally {
    if (result != null) {
        try {
            result.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
%>
