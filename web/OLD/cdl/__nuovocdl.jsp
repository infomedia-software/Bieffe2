<%@page import="gestioneDB.GestioneCDL"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%
    String toReturn=GestioneCDL.getIstanza().nuovoCDL();
    out.print(toReturn);
%>