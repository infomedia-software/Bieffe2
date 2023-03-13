
<%@page import="server.ws.WsServer"%>
<%@page import="beans.Act"%>
<%@page import="gestioneDB.GestioneAct"%>
<%@page import="gestioneDB.GestioneActPl"%>
<%@page import="utility.Utility"%>
<%
    
    boolean riprogramma_act_res=false;
    String id_act=Utility.eliminaNull(request.getParameter("id_act"));
    
    String query_input="";
    
    String descrizione=Utility.eliminaNull(request.getParameter("descrizione"));
    if(!descrizione.equals("")){query_input=query_input+" descrizione="+Utility.isNull(descrizione)+",";}
    
    String durata=Utility.eliminaNull(request.getParameter("durata"));
    if(!durata.equals("")){
        query_input=query_input+" durata="+durata+",";        
        riprogramma_act_res=true;
    }
    
     
    String completata=Utility.eliminaNull(request.getParameter("completata"));    
    if(!completata.equals("")){
        if(completata.equals("no")){completata="";}
        query_input=query_input+" completata="+Utility.isNull(completata)+",";                
    }
    
    
    
    if(!query_input.equals("")){
        String query="UPDATE act SET "+Utility.rimuovi_ultima_occorrenza(query_input, ",") +" WHERE id="+id_act;
        Utility.getIstanza().query(query);
    }
    
    if(riprogramma_act_res){
        Act act=GestioneAct.getIstanza().get_act(id_act);        
        GestioneActPl.getIstanza().riprogramma_act_res(act.getAct_res().getId(), act.inizio_data(), act.inizio_ora(), id_act);
        WsServer.sendAll("aggiorna_act_pl");
    }        
%>