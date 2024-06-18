<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.io.*" %>
<%@ include file="../basedados/basedados.h" %>
<%
    session = request.getSession();
    if (session.getAttribute("tipoUtilizador") == null || !session.getAttribute("tipoUtilizador").equals("3")) {
        out.println("<script>alert('UTILIZADOR NÃO AUTORIZADO: CONTACTE O ADMIN OU ENTRE COM OUTRO UTILIZADOR!')</script>");
        response.setHeader("Refresh", "0; URL=home.jsp");
        return;
    }

    if ("POST".equals(request.getMethod())) {
        int idInscricao = Integer.parseInt(request.getParameter("id_inscricao"));
        int idAluno = Integer.parseInt(request.getParameter("aluno"));
        int idCurso = Integer.parseInt(request.getParameter("curso"));
        String dataInscricao = request.getParameter("data_inscricao");
        int vExamNacional = Integer.parseInt(request.getParameter("vExamNacional"));
        int statusInscricao = Integer.parseInt(request.getParameter("status_inscricao"));

        // Atualiza os dados da inscrição
        try {
            String sql = "UPDATE inscricoes SET id_aluno = ?, id_curso = ?, data_inscricao = ?, v_exam_nacional = ?, status_inscricao = ? WHERE id_inscricao = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idAluno);
            ps.setInt(2, idCurso);
            ps.setString(3, dataInscricao);
            ps.setInt(4, vExamNacional);
            ps.setInt(5, statusInscricao);
            ps.setInt(6, idInscricao);
            int rowsAffected = ps.executeUpdate();
            ps.close();

            if (rowsAffected > 0) {
                out.println("<script>alert('Inscrição atualizada com sucesso!')</script>");
                out.println("<meta http-equiv='refresh' content='0; url=gestao_inscricoes_aluno.jsp'>");
            } else {
                out.println("Nenhuma inscrição encontrada com o ID fornecido.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("Erro ao atualizar a inscrição: " + e.getMessage());
        }
    } else {
        out.println("<script>alert('Acesso inválido!')</script>");
        out.println("<meta http-equiv='refresh' content='0; url=editar_inscricao_aluno.jsp'>");
    }
%>
