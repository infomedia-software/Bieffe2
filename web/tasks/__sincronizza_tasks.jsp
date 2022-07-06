<%@page import="gestioneDB.GestioneSincronizzazione"%>
<%
    GestioneSincronizzazione.getIstanza().sincronizza_task("");
%>