<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.io.*, java.security.MessageDigest, java.security.NoSuchAlgorithmException" %>
<%@ include file="../basedados/basedados.h" %>
<%

session = request.getSession();
if (session.getAttribute("tipoUtilizador") == null || !session.getAttribute("tipoUtilizador").equals("1")) {
    out.println("<script>alert('UTILIZADOR NÃO AUTORIZADO: CONTACTE O ADMIN OU ENTRE COM OUTRO UTILIZADOR!')</script>");
    out.println("<meta http-equiv='refresh' content='0; url=home.jsp'>");
    return;
}

if (request.getParameter("idUtilizador") != null) {
    int idUtilizador = Integer.parseInt(request.getParameter("idUtilizador"));

    try {
        // Atualiza o campo 'tipoUtilizador' para 'utilizador apagado'
        String sql = "UPDATE utilizador SET tipoUtilizador = 5 WHERE idUtilizador = ?";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, idUtilizador);

        int rowsAffected = ps.executeUpdate();
        ps.close();

        if (rowsAffected > 0) {
            out.println("<script>alert('Utilizador marcado como apagado com sucesso!')</script>");
            out.println("<meta http-equiv='refresh' content='0; url=gestao_utilizador.jsp'>");
        } else {
            out.println("Erro ao marcar o utilizador como apagado.");
        }
    } catch (SQLException e) {
        out.println("Erro ao marcar o utilizador como apagado: " + e.getMessage());
    }
} else {
    out.println("ID do utilizador não fornecido.");
}
%>
