<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.io.*" %>
<%@ include file="../basedados/basedados.h" %>
<%
session = request.getSession();

if (session.getAttribute("tipoUtilizador") != null) {
    int tipoUtilizador = Integer.parseInt(session.getAttribute("tipoUtilizador").toString());

    if (tipoUtilizador == 1) {
        response.sendRedirect("pgLogadoAdmin.jsp");
    } else if (tipoUtilizador == 2) {
        response.sendRedirect("pgLogadoDocente.jsp");
    } else if (tipoUtilizador == 3) {
        response.sendRedirect("pgLogadoAluno.jsp");
    } else if (tipoUtilizador == 4) {
        out.println("<script> alert('UTILIZADOR NÃO VALIDADO: CONTACTE O ADMIN!')</script>");
        response.setHeader("Refresh", "0; URL=logout.jsp");
    } else {    
        out.println("<script> alert('UTILIZADOR INVALIDO PODE JÁ ESTAR APAGADO: CONTACTE O ADMIN!')</script>");
        response.setHeader("Refresh", "0; URL=logout.jsp");
    }
}
%>
