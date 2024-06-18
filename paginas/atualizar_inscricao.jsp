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

    // Verifica se o formulário foi submetido
    if ("POST".equals(request.getMethod())) {
        int idInscricao = Integer.parseInt(request.getParameter("id_inscricao"));
        int idAluno = Integer.parseInt(request.getParameter("aluno"));
        int idCurso = Integer.parseInt(request.getParameter("curso"));
        String dataInscricao = request.getParameter("data_inscricao");
        int vExamNacional = Integer.parseInt(request.getParameter("vExamNacional"));
        int statusInscricao = Integer.parseInt(request.getParameter("status_inscricao"));

        // Conta o número de inscrições aprovadas para o curso selecionado
        int numAprovadas = 0;
        try {
            String sqlCount = "SELECT COUNT(*) as num_aprovadas FROM inscricoes WHERE id_curso = ? AND status_inscricao = 2";
            psCount = conn.prepareStatement(sqlCount);
            psCount.setInt(1, idCurso);
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
            String sqlLimite = "SELECT limite_alunos FROM cursos WHERE id_curso = ?";
            psLimite = conn.prepareStatement(sqlLimite);
            psLimite.setInt(1, idCurso);
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

        // Verifica se o aluno já possui uma inscrição ativa para o curso selecionado
        try {
            String queryVerificar = "SELECT * FROM inscricoes WHERE id_aluno = ? AND id_curso = ? AND status_inscricao IN (1, 2, 3)";
            psVerificar = conn.prepareStatement(queryVerificar);
            psVerificar.setInt(1, idAluno);
            psVerificar.setInt(2, idCurso);
            rsVerificar = psVerificar.executeQuery();
            if (rsVerificar.next()) {
                out.println("<script>alert('O aluno já possui uma inscrição para este curso! Podes editar a inscrição existente ou excluir-la. Só então poderá se inscrever!')</script>");
                out.println("<meta http-equiv='refresh' content='0; url=gestao_inscricoes.jsp'>");
                return;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("Erro ao verificar inscrição do aluno: " + e.getMessage());
            return;
        } finally {
            if (rsVerificar != null) rsVerificar.close();
            if (psVerificar != null) psVerificar.close();
        }

        // Atualiza os dados da inscrição no banco de dados
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
                out.println("<meta http-equiv='refresh' content='0; url=gestao_inscricoes.jsp'>");
            } else {
                out.println("Nenhuma inscrição encontrada com o ID fornecido.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("Erro ao atualizar a inscrição: " + e.getMessage());
        }
    } else {
        out.println("<script>alert('Acesso inválido!')</script>");
        out.println("<meta http-equiv='refresh' content='0; url=editar_inscricao.jsp'>");
    }
%>
