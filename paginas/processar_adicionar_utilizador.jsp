<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.io.*, java.security.MessageDigest, java.security.NoSuchAlgorithmException" %>
<%@ include file="../basedados/basedados.h" %>
<%
// Verifica se o usuário está autenticado como administrador
session = request.getSession();
if (session.getAttribute("tipoUtilizador") == null || !session.getAttribute("tipoUtilizador").equals("1")) {
    out.println("<script>alert('UTILIZADOR NÃO AUTORIZADO: CONTACTE O ADMIN OU ENTRE COM OUTRO UTILIZADOR!')</script>");
    response.setHeader("Refresh", "0; URL=home.jsp");
}

// Verifica se o formulário foi enviado
if ("POST".equals(request.getMethod())) {
    // Obtem os dados do formulário
    String nomeUtilizador = request.getParameter("nomeUtilizador");
    String email = request.getParameter("email");
    String imagem = request.getParameter("imagem");
    String morada = request.getParameter("morada");
    String pass = request.getParameter("pass");
    String telemovel = request.getParameter("telemovel");
    String tipoUtilizador = request.getParameter("tipoUtilizador");

    try {
        // Encripta a senha usando MD5
        pass = MD5(pass);

        // Inseri os dados do novo usuário
        String sql = "INSERT INTO utilizador (nomeUtilizador, mail, imagem, morada, pass, telemovel, tipoUtilizador) VALUES (?, ?, ?, ?, ?, ?, ?)";
        ps = conn.prepareStatement(sql);
        ps.setString(1, nomeUtilizador);
        ps.setString(2, email);
        ps.setString(3, imagem);
        ps.setString(4, morada);
        ps.setString(5, pass);
        ps.setString(6, telemovel);
        ps.setString(7, tipoUtilizador);
        
        int rowsInserted = ps.executeUpdate();
        ps.close();
        
        if (rowsInserted > 0) {
            out.println("<script>alert('Utilizador adicionado com sucesso!')</script>");
            response.setHeader("Refresh", "0; URL=gestao_utilizador.jsp");
        } else {
            out.println("Erro ao adicionar utilizador.");
        }
    } catch (SQLException | NoSuchAlgorithmException e) {
        out.println("Erro ao adicionar utilizador: " + e.getMessage());
    }
} else {
    out.println("Formulário não enviado.");
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

    // Função para encriptar a pass usando o algoritmo MD5
    public String MD5(String pass) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("MD5");
        md.update(pass.getBytes());

        byte[] byteData = md.digest();
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < byteData.length; i++) {
            sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
        }
        return sb.toString();
    }

%>
