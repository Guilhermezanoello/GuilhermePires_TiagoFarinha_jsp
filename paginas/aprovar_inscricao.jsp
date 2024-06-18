<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.io.*" %>
<%@ include file="../basedados/basedados.h" %>
<%
    session = request.getSession();
    if (session.getAttribute("tipoUtilizador") == null || !session.getAttribute("tipoUtilizador").equals("1")) {
        out.println("<script>alert('UTILIZADOR NÃO AUTORIZADO: CONTACTE O ADMIN OU ENTRE COM OUTRO UTILIZADOR!')</script>");
        response.setHeader("Refresh", "0; URL=home.jsp");
        return;
    }

    if ("POST".equals(request.getMethod()) && request.getParameter("id_inscricao") != null && request.getParameter("id_curso") != null) {
        int id_inscricao = Integer.parseInt(request.getParameter("id_inscricao"));
        int id_curso = Integer.parseInt(request.getParameter("id_curso"));

        // Conta o número de inscrições aprovadas para o curso selecionado
        int numAprovadas = 0;
        try {
            String sql_count = "SELECT COUNT(*) as num_aprovadas FROM inscricoes WHERE id_curso = ? AND status_inscricao = 2";
            psCount = conn.prepareStatement(sql_count);
            psCount.setInt(1, id_curso);
            rsCount = psCount.executeQuery();
            if (rsCount.next()) {
                numAprovadas = rsCount.getInt("num_aprovadas");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("Erro ao contar o número de inscrições aprovadas: " + e.getMessage());
            return;
        } finally {
            if (rsCount != null) rsCount.close();
            if (psCount != null) psCount.close();
        }

        // Busca o limite de alunos do curso selecionado
        int limiteAlunos = 0;
        try {
            String sql_limite = "SELECT limite_alunos FROM cursos WHERE id_curso = ?";
            psLimite = conn.prepareStatement(sql_limite);
            psLimite.setInt(1, id_curso);
            rsLimite = psLimite.executeQuery();
            if (rsLimite.next()) {
                limiteAlunos = rsLimite.getInt("limite_alunos");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("Erro ao obter o limite de alunos do curso: " + e.getMessage());
            return;
        } finally {
            if (rsLimite != null) rsLimite.close();
            if (psLimite != null) psLimite.close();
        }

        // Verifica se o número de inscrições aprovadas é menor ou igual ao limite de alunos
        if (numAprovadas >= limiteAlunos) {
            out.println("<script>alert('O limite de alunos para este curso foi excedido. Não é possível aprovar mais inscrições.')</script>");
            out.println("<meta http-equiv='refresh' content='0; url=gestao_inscricoes.jsp'>");
            return;
        }

        // Altera o status da inscrição para "Aprovada" (ID 2)
        try {
            String sql = "UPDATE inscricoes SET status_inscricao = 2 WHERE id_inscricao = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id_inscricao);
            int rowsAffected = ps.executeUpdate();
            ps.close();

            if (rowsAffected > 0) {
                out.println("<script>alert('Inscrição marcada como aprovada com sucesso!')</script>");
                out.println("<meta http-equiv='refresh' content='0; url=gestao_inscricoes.jsp'>");
            } else {
                out.println("Nenhuma inscrição encontrada com o ID fornecido.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("Erro ao marcar a inscrição como aprovada: " + e.getMessage());
        }
    } else {
        out.println("Parâmetro inválido.");
    }
%>
