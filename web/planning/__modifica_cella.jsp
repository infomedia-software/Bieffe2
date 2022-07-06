<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="beans.PlanningCella"%>
<%@page import="utility.Utility"%>
<%
    String id_cella=Utility.eliminaNull(request.getParameter("id_cella"));
    String new_valore=Utility.eliminaNull(request.getParameter("new_valore"));
    
    String id_risorsa="";
    String inizio="";
    
    /*** *** *** *** *** *** 
     * 
     * 
     *** *** *** *** *** ***/
    
    if(id_cella.contains("_")){
        String[] id_cella_temp=id_cella.split("_");
        id_risorsa=id_cella_temp[0];
        inizio=id_cella_temp[1];
    }
    
    if(new_valore.equals("-1")){
        inizio=Utility.getIstanza().getValoreByCampo("planning", "inizio", "id="+id_cella);
        id_risorsa=Utility.getIstanza().getValoreByCampo("planning", "risorsa", "id="+id_cella);
        Utility.getIstanza().query("DELETE FROM planning WHERE id="+id_cella);        
    }
    if(new_valore.equals("1")){    
        String fine=Utility.aggiungiOre(inizio, 0, 30);
        Utility.getIstanza().query("INSERT INTO planning(risorsa,inizio,fine,valore) VALUES("+Utility.isNull(id_risorsa)+","+Utility.isNull(inizio) +","+Utility.isNull(fine) +",'1')");
    }
    
    GestionePlanning.getIstanza().riprogrammaRisorse(id_risorsa, inizio);
%>