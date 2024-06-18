<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.io.*, java.security.MessageDigest, java.security.NoSuchAlgorithmException" %>
<%@ include file="../basedados/basedados.h" %>
<%

session = request.getSession();
if (session.getAttribute("tipoUtilizador") == null || !session.getAttribute("tipoUtilizador").equals("2")) {
    out.println("<script>alert('UTILIZADOR NÃO AUTORIZADO: CONTACTE O ADMIN OU ENTRE COM OUTRO UTILIZADOR!')</script>");
    response.setHeader("Refresh", "0; URL=home.jsp");
    return;
}

// Verifica se o formulário foi enviado
if ("POST".equals(request.getMethod()) && request.getParameter("id_curso") != null) {
    // Obtem o ID do curso enviado pelo formulário
    int id_curso = Integer.parseInt(request.getParameter("id_curso"));

    try {
        // Altera o estado do curso para Inativo
        String sql = "UPDATE cursos SET estado_curso = 2 WHERE id_curso = ?";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, id_curso);

        int rowsAffected = ps.executeUpdate();
        ps.close();
        
        if (rowsAffected > 0) {
            out.println("<script>alert('Curso marcado como Inativo com sucesso!')</script>");
            response.setHeader("Refresh", "0; URL=gestao_cursos_docente.jsp");
        } else {
            out.println("Erro ao marcar o curso como Inativo.");
        }
    } catch (SQLException e) {
        out.println("Erro ao marcar o curso como Inativo: " + e.getMessage());
    }
} else {
    out.println("Parâmetro inválido.");
}
%>
