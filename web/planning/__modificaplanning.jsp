<%@page import="gestioneDB.DBUtility"%>
<%@page import="utility.GestioneErrori"%>
<%@page import="connection.ConnectionPoolException"%>
<%@page import="utility.GestioneErrori"%>
<%@page import="java.sql.SQLException"%>
<%@page import="gestioneDB.DBConnection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="beans.Risorsa"%>
<%@page import="gestioneDB.GestioneRisorse"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.PlanningCella"%>
<%@page import="beans.Attivita"%>
<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="utility.Utility"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%
    String idattivita=Utility.eliminaNull(request.getParameter("idattivita"));    
    String attivita_old_risorsa=Utility.getIstanza().getValoreByCampo("attivita", "risorsa", "id="+idattivita);
    
    String idcella=Utility.eliminaNull(request.getParameter("idcella"));
    if(idcella.equals("")){
        idcella=Utility.getIstanza().getValoreByCampo("planning", "id", " valore="+Utility.isNull(idattivita)+" ORDER BY inizio ASC LIMIT 1,1");
    }
    
    PlanningCella cella_drop=GestionePlanning.getIstanza().ricercaPlanningCelle(" planning.id="+idcella).get(0);
    
    
    
    String new_risorsa=cella_drop.getRisorsa();
    String attivita_new_inizio=cella_drop.getInizio();
    
    // Considero il vecchio inizio e confronto 
    String start_riprogramma_risorsa=Utility.dataOraCorrente_String();
    //String attivita_old_inizio=Utility.getIstanza().getValoreByCampo("attivita", "inizio", "id="+idattivita);
    if(Utility.confrontaTimestamp(attivita_new_inizio,Utility.dataOraCorrente_String())<=0){
        start_riprogramma_risorsa=attivita_new_inizio;        
    }
    
    Utility.getIstanza().query("CALL `dropAttivita`("+Utility.isNull(idattivita)+", "+Utility.isNull(attivita_new_inizio)+","+Utility.isNull(new_risorsa)+")");
    
    // Spostamento tra risorse differenti
    // N.B. -> Considero sempre la risorsa con ordinamento più piccolo per la riprogrammazione
    String risorsa_partenza=new_risorsa;
    if(!new_risorsa.equals(attivita_old_risorsa)){
        risorsa_partenza=Utility.getIstanza().getValoreByCampo("risorse", "id", " id="+new_risorsa+" OR id="+attivita_old_risorsa+" ORDER BY ordinamento ASC LIMIT 0,1");
    }

    String id_attivita_insieme=Utility.getIstanza().getValoreByCampo("attivita", "id", "libero7="+Utility.isNull(idattivita));            
    if(!id_attivita_insieme.equals("")){
        String risorsa_attivita_insieme=Utility.getIstanza().getValoreByCampo("attivita", "risorsa", "id="+id_attivita_insieme);
        Utility.getIstanza().query("CALL `dropAttivita`("+Utility.isNull(id_attivita_insieme)+", "+Utility.isNull(attivita_new_inizio)+","+Utility.isNull(risorsa_attivita_insieme)+")");
    }
            
    
    GestionePlanning.getIstanza().riprogrammaRisorse(risorsa_partenza,start_riprogramma_risorsa);
    
%>