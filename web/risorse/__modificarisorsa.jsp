<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="beans.Risorsa"%>
<%@page import="gestioneDB.GestioneRisorse"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.Commessa"%>
<%@page import="gestioneDB.GestioneCommesse"%>
<%@page import="utility.Utility"%>
<%
    String id=Utility.eliminaNull(request.getParameter("id"));
    String ids=Utility.eliminaNull(request.getParameter("ids"));
    
    String campodamodificare=Utility.eliminaNull(request.getParameter("campo_da_modificare"));
    String newvalore=Utility.eliminaNull(request.getParameter("new_valore"));
    
    ArrayList<Risorsa> risorse=null;
    
    if(!id.equals(""))
        risorse=GestioneRisorse.getIstanza().ricercaRisorse(" risorse.id="+id+" AND risorse.stato='1' ");
    if(!ids.equals(""))
        risorse=GestioneRisorse.getIstanza().ricercaRisorse(" risorse.id IN ("+ids+") AND risorse.stato='1' ");
    
    for(Risorsa risorsa:risorse){
        Utility.getIstanza().query("UPDATE risorse SET "+campodamodificare+"="+Utility.isNull(newvalore)+" WHERE id="+risorsa.getId());
    }
    
    if(campodamodificare.contains("inizio") || campodamodificare.contains("fine")){
        String ultima_data_programmata=Utility.getIstanza().querySelect(" SELECT max(DATE(fine)) as ultima_data_programmata FROM attivita WHERE date(inizio)!='3001-01-01' AND stato='1' ", "ultima_data_programmata");        
        if(!ultima_data_programmata.equals("") && ultima_data_programmata!=null)
            Utility.getIstanza().query(" DELETE FROM planning WHERE date(inizio)>"+Utility.isNull(ultima_data_programmata));
    }
    

    if(campodamodificare.equals("planning") && newvalore.equals("si")){     
        Risorsa r=GestioneRisorse.getIstanza().ricercaRisorse(" risorse.id="+id).get(0);
        GestionePlanning.getIstanza().aggiungi_risorsa_planning(id,r.getInizio(),r.getFine());            
    }
%>