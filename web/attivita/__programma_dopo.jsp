<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="utility.Utility"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%    
    String id_attivita=Utility.eliminaNull(request.getParameter("id_attivita"));
    String new_inizio_input=Utility.eliminaNull(request.getParameter("new_inizio"));
    
    String id_risorsa=Utility.getIstanza().getValoreByCampo("attivita", "risorsa", " id="+id_attivita);
    String new_inizio=GestionePlanning .getIstanza().trova_prima_cella(id_risorsa, new_inizio_input, 0);
    out.print(new_inizio);
%>