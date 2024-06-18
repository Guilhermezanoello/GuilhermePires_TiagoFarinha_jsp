<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.io.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.math.BigInteger" %>
<%@ include file="../basedados/basedados.h" %>
<%
    
    session = request.getSession();

    String nomeUtilizador = request.getParameter("nomeUtilizador");
    String mail = request.getParameter("email");
    String imagem = "default.png";
    String morada = request.getParameter("morada");
    String pass = request.getParameter("senha");
    // Calcula o hash MD5 da senha
    MessageDigest md = MessageDigest.getInstance("MD5");
    md.update(pass.getBytes());
    byte[] digest = md.digest();
    String senhaMD5 = new BigInteger(1, digest).toString(16);

    // Certificando-se de que o hash tenha 32 caracteres
    while (senhaMD5.length() < 32) {
        senhaMD5 = "0" + senhaMD5;
    }
    String telemovel = request.getParameter("telemovel");
    int tipoUtilizador = 4; // Valor fixo utilizador não validado

    // Prepara a consulta SQL
    String query = "INSERT INTO utilizador (nomeUtilizador, mail, imagem, morada, pass, telemovel, tipoUtilizador) VALUES (?, ?, ?, ?, ?, ?, ?)";
    ps = conn.prepareStatement(query);
    ps.setString(1, nomeUtilizador);
    ps.setString(2, mail);
    ps.setString(3, imagem);
    ps.setString(4, morada);
    ps.setString(5, senhaMD5);
    ps.setString(6, telemovel);
    ps.setInt(7, tipoUtilizador);

    // Executa a consulta SQL
    int rowsAffected = ps.executeUpdate();

    // Verifica se o registro foi inserido com sucesso
    if (rowsAffected > 0) {
        response.sendRedirect("home.jsp");
    } else {
        out.println("Erro ao inserir o registro.");
    }

    // Fecha o PreparedStatement
    ps.close();
%>
