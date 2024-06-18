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
    String titulo = request.getParameter("titulo");
    int docente = Integer.parseInt(request.getParameter("docente"));
    int tipo_curso = Integer.parseInt(request.getParameter("tipo_curso"));
    String data_inicio = request.getParameter("data_inicio");
    String data_fim = request.getParameter("data_fim");
    int limite_alunos = Integer.parseInt(request.getParameter("limite_alunos"));
    String descricao = request.getParameter("descricao");

    try {
        // Valida os dados
        if (titulo.isEmpty() || data_inicio.isEmpty() || data_fim.isEmpty() || descricao.isEmpty()) {
            out.println("<script>alert('Por favor, preencha todos os campos!')</script>");
            response.setHeader("Refresh", "0; URL=adicionar_curso.jsp");
        } else {
            // Inseri o novo curso no banco de dados
            String query = "INSERT INTO cursos (titulo, descricao, data_inicio, data_fim, limite_alunos, id_docente, tipo_curso, estado_curso) VALUES (?, ?, ?, ?, ?, ?, ?, 1)";
            ps = conn.prepareStatement(query);
            ps.setString(1, titulo);
            ps.setString(2, descricao);
            ps.setString(3, data_inicio);
            ps.setString(4, data_fim);
            ps.setInt(5, limite_alunos);
            ps.setInt(6, docente);
            ps.setInt(7, tipo_curso);

            int rowsAffected = ps.executeUpdate();
            ps.close();
            if (rowsAffected > 0) {
                out.println("<script>alert('Curso adicionado com sucesso!')</script>");
                response.setHeader("Refresh", "0; URL=gestao_cursos.jsp");
            } else {
                out.println("<script>alert('Erro ao adicionar curso!')</script>");
                response.setHeader("Refresh", "0; URL=adicionar_curso.jsp");
            }
        }
    } catch (SQLException e) {
        out.println("Erro ao adicionar curso: " + e.getMessage());
    }
} else {
    out.println("Formulário não enviado.");
}
%>
