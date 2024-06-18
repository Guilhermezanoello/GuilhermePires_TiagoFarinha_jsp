<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.io.*, java.security.MessageDigest, java.security.NoSuchAlgorithmException" %>
<%@ include file="../basedados/basedados.h" %>
<%
session = request.getSession();
if (session.getAttribute("tipoUtilizador") == null || Integer.parseInt(session.getAttribute("tipoUtilizador").toString()) < 1 || Integer.parseInt(session.getAttribute("tipoUtilizador").toString()) > 3) {
    out.println("<script>alert('UTILIZADOR NÃO AUTORIZADO: CONTACTE O ADMIN OU ENTRE COM OUTRO UTILIZADOR!')</script>");
    response.setHeader("Refresh", "0; url=home.jsp");
}

if ("POST".equals(request.getMethod())) {
    String nomeUtilizador = request.getParameter("nomeUtilizador");
    String pass = request.getParameter("pass");
    String mail = request.getParameter("mail");
    String imagem = request.getParameter("imagem");
    String morada = request.getParameter("morada");
    String telemovel = request.getParameter("telemovel");

    int rowsAffected = 0;

    if (!pass.isEmpty()) {

        // Atualiza os dados do utilizador
        String sql = "UPDATE utilizador SET nomeUtilizador = ?, pass = ?, mail = ?, imagem = ?, morada = ?, telemovel = ? WHERE idUtilizador = ?";
        ps = conn.prepareStatement(sql);
        ps.setString(1, nomeUtilizador);
        ps.setString(2, MD5(pass));
        ps.setString(3, mail);
        ps.setString(4, imagem);
        ps.setString(5, morada);
        ps.setString(6, telemovel);
        ps.setInt(7, Integer.parseInt(session.getAttribute("idUtilizador").toString()));
        rowsAffected = ps.executeUpdate();
        ps.close();
    } else {
        // Atualiza os dados do utilizador sem alterar a pass
        String sql = "UPDATE utilizador SET nomeUtilizador = ?, mail = ?, imagem = ?, morada = ?, telemovel = ? WHERE idUtilizador = ?";
        ps = conn.prepareStatement(sql);
        ps.setString(1, nomeUtilizador);
        ps.setString(2, mail);
        ps.setString(3, imagem);
        ps.setString(4, morada);
        ps.setString(5, telemovel);
        ps.setInt(6, Integer.parseInt(session.getAttribute("idUtilizador").toString()));
        rowsAffected = ps.executeUpdate();
        ps.close();
    }

    if (rowsAffected > 0) {
        out.println("<script> alert('Dados atualizados com sucesso!')</script>");
        response.setHeader("Refresh", "0; URL=redirecionar.jsp");
    } else {
        out.println("<script> alert('Erro ao atualizar os dados!')</script>");
        response.setHeader("Refresh", "0; URL=dados_pessoais.jsp");
    }
}
%>
<%! public String getMD5Hash(String input) {
    // Função que gera uma HASH do MD5
    try {
        
        MessageDigest md = MessageDigest.getInstance("MD5");

        byte[] inputBytes = input.getBytes("UTF-8");

        byte[] hashBytes = md.digest(inputBytes);

        StringBuilder sb = new StringBuilder();
        for (byte b : hashBytes) {
            sb.append(String.format("%02x", b));
        }

        return sb.toString();
    } catch (NoSuchAlgorithmException | UnsupportedEncodingException e) {
        e.printStackTrace();
        return null;
    }
}

    // Função para encriptar a senha usando o algoritmo MD5
    public String MD5(String password) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("MD5");
        md.update(password.getBytes());

        byte[] byteData = md.digest();
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < byteData.length; i++) {
            sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
        }
        return sb.toString();
    }

%>
