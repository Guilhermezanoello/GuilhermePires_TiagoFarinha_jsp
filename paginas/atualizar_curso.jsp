<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.io.*, java.util.ArrayList" %>
<%@ include file="../basedados/basedados.h" %>
<!DOCTYPE html>
<html lang="pt-br">
<%
    session = request.getSession();
    if (session.getAttribute("tipoUtilizador") == null || !session.getAttribute("tipoUtilizador").equals("1")) {
        out.println("<script>alert('UTILIZADOR NÃO AUTORIZADO: CONTACTE O ADMIN OU ENTRE COM OUTRO UTILIZADOR!')</script>");
        response.setHeader("Refresh", "0; URL=home.jsp");
    }
%>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Atualizar Curso</title>
    <link rel="stylesheet" href="style.css">
</head>

<body>
    <%
        if ("POST".equals(request.getMethod())) {
            String idCurso = request.getParameter("idCurso");
            
            if (idCurso != null) {
                try {
                    String titulo = request.getParameter("titulo");
                    String descricao = request.getParameter("descricao");
                    String dataInicio = request.getParameter("dataInicio");
                    String dataFim = request.getParameter("dataFim");
                    int limiteAlunos = Integer.parseInt(request.getParameter("limiteAlunos"));
                    int idDocente = Integer.parseInt(request.getParameter("idDocente"));
                    int tipoCurso = Integer.parseInt(request.getParameter("tipoCurso"));
                    int estadoCurso = Integer.parseInt(request.getParameter("estadoCurso"));
                    
                    String sql = "UPDATE cursos SET titulo=?, descricao=?, data_inicio=?, data_fim=?, limite_alunos=?, id_docente=?, tipo_curso=?, estado_curso=? WHERE id_curso=?";
                    
                    ps = conn.prepareStatement(sql);
                    ps.setString(1, titulo);
                    ps.setString(2, descricao);
                    ps.setString(3, dataInicio);
                    ps.setString(4, dataFim);
                    ps.setInt(5, limiteAlunos);
                    ps.setInt(6, idDocente);
                    ps.setInt(7, tipoCurso);
                    ps.setInt(8, estadoCurso);
                    ps.setString(9, idCurso);
                    
                    int rowsUpdated = ps.executeUpdate();
                    
                    if (rowsUpdated > 0) {
                        out.println("<script>alert('Curso atualizado com sucesso!');</script>");
                        response.setHeader("Refresh", "0; URL=gestao_cursos.jsp");
                    } else {
                        out.println("Erro ao atualizar o curso.");
                    }
                    
                    ps.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            } else {
                out.println("ID do curso não fornecido.");
            }
        }
    %>
</body>

</html>
