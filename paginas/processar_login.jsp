<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.io.*, java.security.MessageDigest, java.security.NoSuchAlgorithmException" %>
<%@ include file="../basedados/basedados.h" %>
<%
    
    session = request.getSession();

    String nomeUtilizador = request.getParameter("utilizador");
    String pass = request.getParameter("senha");

    MessageDigest md = java.security.MessageDigest.getInstance("MD5");
    byte[] array = md.digest(pass.getBytes());
    StringBuffer sb = new StringBuffer();
    for (int i = 0; i < array.length; ++i) {
        sb.append(Integer.toHexString((array[i] & 0xFF) | 0x100).substring(1, 3));
    }
    String passMD5 = sb.toString();

    // Consulta SQL para verificar as credenciais
    String selectUtilizador = "SELECT * FROM utilizador WHERE nomeUtilizador = ? AND pass = ?";

    ps = conn.prepareStatement(selectUtilizador);
    ps.setString(1, nomeUtilizador);
    ps.setString(2, passMD5);
    rs = ps.executeQuery();

    try {
        if (rs.next()) {
            // Credenciais corretas, realizar login
            session.setAttribute("nomeUtilizador", rs.getString("nomeUtilizador"));
            session.setAttribute("tipoUtilizador", rs.getString("tipoUtilizador"));
            session.setAttribute("idUtilizador", rs.getString("idUtilizador"));

            response.sendRedirect("redirecionar.jsp");
        } else {
            // Credenciais inválidas, exibir mensagem de erro
            out.println("<script>alert('Dados de autentificação incorretos!');</script>");
            out.println("<meta http-equiv=\"refresh\" content=\"2; url=login.jsp\">");

        }

        ps.close();
        rs.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>