<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.io.*, java.security.MessageDigest, java.security.NoSuchAlgorithmException" %>
<%@ include file="../basedados/basedados.h" %>
<%
    session = request.getSession();
    if (session.getAttribute("tipoUtilizador") == null || !session.getAttribute("tipoUtilizador").equals("1")) {
        out.println("<script>alert('UTILIZADOR NÃO AUTORIZADO: CONTACTE O ADMIN OU ENTRE COM OUTRO UTILIZADOR!')</script>");
        response.setHeader("Refresh", "0; URL=home.jsp");
        return;
    }

    if ("POST".equals(request.getMethod()) && request.getParameter("id_inscricao") != null) {
        String id_inscricao = request.getParameter("id_inscricao");

        // Altera o status da inscrição para "Apagada" (ID 4)
        try {
            String sql = "UPDATE inscricoes SET status_inscricao = 4 WHERE id_inscricao = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, id_inscricao);
            int rowsAffected = ps.executeUpdate();
            ps.close();

            if (rowsAffected > 0) {
                out.println("<script>alert('Inscrição marcada como apagada com sucesso!')</script>");
                out.println("<meta http-equiv='refresh' content='0; url=gestao_inscricoes.jsp'>");
            } else {
                out.println("Nenhuma inscrição encontrada com o ID fornecido.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("Erro ao marcar a inscrição como apagada: " + e.getMessage());
        }
    } else {
        out.println("Parâmetro inválido.");
    }
%>
