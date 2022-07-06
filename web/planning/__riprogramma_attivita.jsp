<%@page import="beans.PlanningCella"%>
<%@page import="beans.Attivita"%>
<%@page import="java.util.ArrayList"%>
<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="utility.Utility"%>
<%
    String id_attivita=Utility.eliminaNull(request.getParameter("id_attivita"));    
    String id_risorsa=Utility.getIstanza().getValoreByCampo("attivita", "risorsa", "id="+id_attivita);
    
    String id_cella=Utility.eliminaNull(request.getParameter("id_cella"));    
    
    if(id_cella.equals("")){
        String new_inizio=Utility.eliminaNull(request.getParameter("new_inizio"));    
        id_cella=GestionePlanning.getIstanza().get_id_cella(id_risorsa, new_inizio);
    }
    
    //System.out.println("id_attivita= "+id_attivita+"\nid_risorsa= "+id_risorsa+"\nid_cella= "+id_cella);
    
    PlanningCella cella=null;
    
    if(id_cella.equals("")){        
        cella=GestionePlanning.getIstanza().trova_cella_disponibile("", "", id_risorsa);                        // Riprogramma subito sotto linea temporale cercando la prima cella disponibile
    }else{
        cella=GestionePlanning.getIstanza().ricercaPlanningCelle(" planning.id="+id_cella).get(0);
    }
    
    String new_inizio=cella.getInizio();
    
    Utility.getIstanza().query("UPDATE attivita SET situazione='in programmazione' WHERE id="+id_attivita);
    
    if(cella.getValore().equals("1")){        
        Utility.getIstanza().query("CALL `dropAttivita`("+Utility.isNull(id_attivita)+", "+Utility.isNull(new_inizio)+","+Utility.isNull(id_risorsa)+")");                

    }
    
    // Cella già occupata
    if(!cella.getValore().equals("1") && !cella.getValore().equals("-1")){
        
        String id_attivita_su_cella=cella.getValore();                                                 
        String new_inizio_ok=Utility.aggiungiOre(new_inizio, 0, 30);
        Utility.getIstanza().query("CALL `dropAttivita`("+Utility.isNull(id_attivita_su_cella)+", "+Utility.isNull(new_inizio_ok)+","+Utility.isNull(id_risorsa)+")");        
        GestionePlanning.getIstanza().riprogrammaRisorse(id_risorsa,"");
        
        Utility.getIstanza().query("CALL `dropAttivita`("+Utility.isNull(id_attivita)+", "+Utility.isNull(new_inizio)+","+Utility.isNull(id_risorsa)+")");        
    }    
    GestionePlanning.getIstanza().riprogrammaRisorse(id_risorsa,new_inizio);
    
%>