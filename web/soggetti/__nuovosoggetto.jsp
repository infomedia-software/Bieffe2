<%@page import="utility.Utility"%>
<%@page import="gestioneDB.GestioneSoggetti"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%
    String tipologia=Utility.eliminaNull(request.getParameter("tipologia"));    
    String id="S"+((int)Utility.getIstanza().querySelectDouble("SELECT (count(*)+1) as n from soggetti WHERE 1", "n"));    
    GestioneSoggetti.getIstanza().nuovoSoggetto(id,tipologia);    
    out.print(id);    
%>