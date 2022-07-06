<%@page import="gestioneDB.GestioneSincronizzazione"%>
<%@page import="gestioneDB.GestioneFasi"%>
<%
    GestioneSincronizzazione.getIstanza().sincronizza_fasi_input();
%>