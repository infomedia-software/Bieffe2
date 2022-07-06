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
    PlanningCella cella_drop=GestionePlanning.getIstanza().ricercaPlanningCelle(" planning.id="+idcella).get(0);
    
    String inizio_min=GestionePlanning.getIstanza().inizio_min(idattivita);
    
    if(!inizio_min.equals("") && Utility.viene_prima(cella_drop.getInizio(), inizio_min) && !cella_drop.getInizio().equals(inizio_min)){
        out.println("ERRORE: Impossibile procedere.\nStai incollando in data/ora precedente al minimo consentito in base alle attività ed alle sequenze.\nData/Ora minimi: "+Utility.convertiDatetimeFormatoIT(inizio_min)+"");
    }else{
        String new_risorsa=cella_drop.getRisorsa();
        String attivita_new_inizio=cella_drop.getInizio();
        
        
        // Considero il vecchio inizio e confronto 
        String start_riprogramma_risorsa=Utility.dataOraCorrente_String();    
        // Se il nuovo inizio è precedente -> devo riprogrammare la risorsa a partire dalla cella e non da NOW()
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


        GestionePlanning.getIstanza().riprogrammaRisorse(risorsa_partenza,start_riprogramma_risorsa);

        // se si verifica il problema che rimangono attività da incollare (in seguito ad un taglia)... le imposto in da programmare    
        String query_attivita_incollare="UPDATE attivita SET "
                + "stato='1',"
                + "situazione="+Utility.isNull(Attivita.DAPROGRAMMARE) +","
                + "inizio="+Utility.isNull(Utility.dadefinire)+","
                + "fine="+Utility.isNull(Utility.dadefinire)+" "
            + "WHERE stato='incollare'";
        Utility.getIstanza().query(query_attivita_incollare);
    }
%>
