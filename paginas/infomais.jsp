<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.io.*" %>
<%@ include file="../basedados/basedados.h" %>
<!DOCTYPE html>
<html lang="pt-br">

<head>
    <link rel="stylesheet" href="style.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Info +</title>
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
</style>
</head>

<body>
    <ul>
        <li><a href="home.jsp">Home</a></li>
        <li><a href="contactos.jsp">Contactos</a></li>
        <li><a class="active" href="infomais.jsp">Info +</a></li>
        <%
         session = request.getSession();
        if (session.getAttribute("tipoUtilizador") == null) {
        %>
            <li style="float:right"><a href="login.jsp">Login</a></li>
            <li style="float:right"><a href="registo.jsp">Regista-te</a></li>
        <% } else {
            Object idUtilizador = session.getAttribute("idUtilizador");
            int id = idUtilizador != null ? Integer.parseInt(idUtilizador.toString()) : 0;
            String sql = "SELECT * FROM utilizador WHERE idUtilizador = " + id;
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                int tipoUtilizador = rs.getInt("tipoUtilizador");
                String imagem = rs.getString("imagem");

                if(tipoUtilizador == 1){
                    out.print("<li><a href=\"pgLogadoAdmin.jsp\">Menu</a></li>");
                } else if (tipoUtilizador == 2) {
                    out.print("<li><a href=\"pgLogadoDocente.jsp\">Menu</a></li>");
                } else if(tipoUtilizador == 3){
                    out.print("<li><a href=\"pgLogadoAluno.jsp\">Menu</a></li>");
                }
                out.print("<li style=\"float:right\"><a href='logout.jsp'>Logout</a></li>");
            }
        }
        %>
    </ul>
    <div id="section">
        <div class="article">
            <h1>CTPs</h1>
            <p>Descubra nossos Cursos Técnicos Profissionais (CTPs) projetados para fornecer habilidades práticas e conhecimento especializado. Para mais informações, realize o registo ou entre em contato conosco por e-mail.</p>
        </div>
        <div class="article">
            <h1>Licenciaturas</h1>
            <p>Explore nossos programas de Licenciatura e dê o primeiro passo para uma carreira de sucesso. Para mais informações, realize o registo ou entre em contato conosco por e-mail.</p>
        </div>
        <div class="article">
            <h1>Mestrados</h1>
            <p>Aprofunde seu conhecimento e se destaque no mercado de trabalho com nossos programas de Mestrado. Para mais informações, realize o registo ou entre em contato conosco por e-mail.</p>
        </div>
        <div class="article">
            <h1>Contacto</h1>
            <p>Email: ctps@formaest.pt</p>
        </div>
        <div class="article">
            <h1>Contacto</h1>
            <p>Email: licenciatura@formaest.pt</p>
        </div>
        <div class="article">
            <h1>Contacto</h1>
            <p>Email: mestrado@formaest.pt</p>
        </div>
    </div>


    <div id="footer">
        <p>&copy; Guilherme Pires & Tiago Farinha</p>
    </div>
</body>

</html>