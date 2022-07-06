<%@page import="gestioneDB.GestioneOpzioni"%>
<%@page import="utility.Utility"%>
<%@page import="gestioneDB.GestionePlanning"%>
<%
    String toReturn=GestionePlanning.getIstanza().aggiorna_planning_old();    
    Utility.getIstanza().query("UPDATE opzioni SET valori="+Utility.isNull(Utility.dataOdiernaFormatoDB())+" WHERE etichetta="+Utility.isNull("ULTIMO_AGGIORNA_PLANNING_OLD"));
%>

