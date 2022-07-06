<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="utility.Utility"%>
<%
    String attivita=Utility.eliminaNull(request.getParameter("attivita"));
    String precedente=Utility.eliminaNull(request.getParameter("precedente"));
    String scostamento=Utility.eliminaNull(request.getParameter("scostamento"));
    
    Utility.getIstanza().query("INSERT INTO precedenze(attivita,precedente,scostamento) "
            + "VALUES("
            + attivita+","
            + precedente+","
            + scostamento+")");
    
    GestionePlanning.getIstanza().verificaPrecedenze("");
%>