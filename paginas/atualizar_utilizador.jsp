<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.io.*, java.security.MessageDigest, java.security.NoSuchAlgorithmException" %>
<%@ include file="../basedados/basedados.h" %>
<%
session = request.getSession();
if (session.getAttribute("tipoUtilizador") == null || !session.getAttribute("tipoUtilizador").equals("1")) {
    out.println("<script>alert('UTILIZADOR NÃO AUTORIZADO: CONTACTE O ADMIN OU ENTRE COM OUTRO UTILIZADOR!')</script>");
    response.setHeader("Refresh", "0; URL=home.jsp");
}

if ("POST".equals(request.getMethod())) {
    String idUtilizador = request.getParameter("idUtilizador");
    String nome = request.getParameter("nome");
    String pass = request.getParameter("pass");
    String email = request.getParameter("email");
    String imagem = request.getParameter("imagem");
    String morada = request.getParameter("morada");
    String telefone = request.getParameter("telefone");
    String tipo = request.getParameter("tipo");

    try {
        // Verifica se a pass foi alterada
        if (!pass.equals("")) {
            // Atualize os dados do usuário
            String sql = "UPDATE utilizador SET nomeUtilizador=?, pass=?, mail=?, imagem=?, morada=?, telemovel=?, tipoUtilizador=? WHERE idUtilizador=?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, nome);
            ps.setString(2, MD5(pass));
            ps.setString(3, email);
            ps.setString(4, imagem);
            ps.setString(5, morada);
            ps.setString(6, telefone);
            ps.setString(7, tipo);
            ps.setString(8, idUtilizador);
            ps.executeUpdate();
            ps.close();

            // Atualiza o idUtilizador na sessão se for o mesmo que o atualizado
            if (session.getAttribute("idUtilizador").equals(idUtilizador)) {
                session.setAttribute("idUtilizador", idUtilizador);
                // Atualiza o tipoUtilizador na sessão
                session.setAttribute("tipoUtilizador", tipo);
                session.invalidate();
                response.setHeader("Refresh", "2; URL=home.jsp");
            }
        } else {
            // Atualize os dados do usuário sem a pass
            String sql = "UPDATE utilizador SET nomeUtilizador=?, mail=?, imagem=?, morada=?, telemovel=?, tipoUtilizador=? WHERE idUtilizador=?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, nome);
            ps.setString(2, email);
            ps.setString(3, imagem);
            ps.setString(4, morada);
            ps.setString(5, telefone);
            ps.setString(6, tipo);
            ps.setString(7, idUtilizador);
            ps.executeUpdate();
            ps.close();

            // Atualiza o idUtilizador na sessão se for o mesmo que o atualizado
            if (session.getAttribute("idUtilizador").equals(idUtilizador)) {
                session.setAttribute("idUtilizador", idUtilizador);
                // Atualiza o tipoUtilizador na sessão
                session.setAttribute("tipoUtilizador", tipo);
                session.invalidate();
                response.setHeader("Refresh", "2; URL=home.jsp");
            }
        }
        out.println("<script>alert('Utilizador atualizado com sucesso!')</script>");
        response.setHeader("Refresh", "0; URL=gestao_utilizador.jsp");
    } catch (SQLException e) {
        out.println("Erro ao atualizar o utilizador: " + e.getMessage());
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
