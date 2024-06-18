<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.io.*, java.time.LocalDateTime, java.time.ZoneId" %>
<%@ include file="../basedados/basedados.h" %>
<%
    // Verifica se o usuário está autenticado
    session = request.getSession();
    if (session.getAttribute("tipoUtilizador") == null || !session.getAttribute("tipoUtilizador").equals("2")) {
        out.println("<script>alert('UTILIZADOR NÃO AUTORIZADO: CONTACTE O ADMIN OU ENTRE COM OUTRO UTILIZADOR!')</script>");
        response.setHeader("Refresh", "0; URL=home.jsp");
        return;
    }

    // Define o fuso horário para Portugal (UTC+0)
    LocalDateTime currentDateTime = LocalDateTime.now(ZoneId.of("Europe/Lisbon"));
    // Recebe os dados do formulário
    String aluno = request.getParameter("aluno");
    String curso = request.getParameter("curso");
    String data_inscricao = request.getParameter("data_inscricao");
    String v_exam_nacional = request.getParameter("v_exam_nacional");
    String status_inscricao = request.getParameter("status_inscricao");

    // Valida os dados
    if (aluno == null || curso == null || data_inscricao == null || v_exam_nacional == null || status_inscricao == null ||
        aluno.isEmpty() || curso.isEmpty() || data_inscricao.isEmpty() || v_exam_nacional.isEmpty() || status_inscricao.isEmpty()) {
        out.println("<script>alert('Por favor, preencha todos os campos!')</script>");
        out.println("Por favor, preencha todos os campos.");
        out.println("<meta http-equiv='refresh' content='0; url=adicionar_inscricao_docente.jsp'>");
        return;
    }

    // Carrega a data e hora atual se não estiver definida no POST
    if (data_inscricao.isEmpty()) {
        data_inscricao = currentDateTime.format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
    }

    // Conta o número de inscrições aprovadas para o curso selecionado
    int numAprovadas = 0;
    try {
        String sql_count = "SELECT COUNT(*) as num_aprovadas FROM inscricoes WHERE id_curso = ? AND status_inscricao = 2";
        psCount = conn.prepareStatement(sql_count);
        psCount.setString(1, curso);
        rsCount = psCount.executeQuery();
        if (rsCount.next()) {
            numAprovadas = rsCount.getInt("num_aprovadas");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        if (rsCount != null) rsCount.close();
        if (psCount != null) psCount.close();
    }

    // Busca o limite de alunos do curso selecionado
    int limiteAlunos = 0;
    try {
        String sql_limite = "SELECT limite_alunos FROM cursos WHERE id_curso = ?";
        psLimite = conn.prepareStatement(sql_limite);
        psLimite.setString(1, curso);
        rsLimite = psLimite.executeQuery();
        if (rsLimite.next()) {
            limiteAlunos = rsLimite.getInt("limite_alunos");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        if (rsLimite != null) rsLimite.close();
        if (psLimite != null) psLimite.close();
    }

    // Verifica se o número de inscrições aprovadas é menor ou igual ao limite de alunos
    if (numAprovadas >= limiteAlunos) {
        out.println("<script>alert('O limite de alunos para este curso foi excedido. Não é possível aprovar mais inscrições.')</script>");
        out.println("<meta http-equiv='refresh' content='0; url=gestao_inscricoes_docente.jsp'>");
        return;
    }

    // Verifica se o aluno já possui uma inscrição ativa para o curso selecionado
    try {
        String queryVerificar = "SELECT * FROM inscricoes WHERE id_aluno = ? AND id_curso = ? AND status_inscricao IN (1, 2, 3)";
        psVerificar = conn.prepareStatement(queryVerificar);
        psVerificar.setString(1, aluno);
        psVerificar.setString(2, curso);
        rsVerificar = psVerificar.executeQuery();
        if (rsVerificar.next()) {
            out.println("<script>alert('Você já possui uma inscrição para este curso! Podes editar a inscrição existente ou excluir-la. Só então poderá se inscrever!')</script>");
            out.println("<meta http-equiv='refresh' content='0; url=gestao_inscricoes_docente.jsp'>");
            return;
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        if (rsVerificar != null) rsVerificar.close();
        if (psVerificar != null) psVerificar.close();
    }

    // Inseri a nova inscrição no banco de dados
    try {
        String query = "INSERT INTO inscricoes (id_aluno, id_curso, data_inscricao, v_exam_nacional, status_inscricao) VALUES (?, ?, ?, ?, ?)";
        psInserir = conn.prepareStatement(query);
        psInserir.setString(1, aluno);
        psInserir.setString(2, curso);
        psInserir.setString(3, data_inscricao);
        psInserir.setString(4, v_exam_nacional);
        psInserir.setString(5, status_inscricao);
        psInserir.executeUpdate();
        out.println("<script>alert('Inscrição adicionada com sucesso!')</script>");
        out.println("<meta http-equiv='refresh' content='0; url=gestao_inscricoes_docente.jsp'>");
    } catch (SQLException e) {
        out.println("Erro ao adicionar inscrição: " + e.getMessage());
        out.println("<meta http-equiv='refresh' content='0; url=adicionar_inscricao_docente.jsp'>");
    } finally {
        if (psInserir != null) psInserir.close();
    }

    // Fechar a conexão
    conn.close();
%>
