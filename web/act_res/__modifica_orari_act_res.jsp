<%@page import="server.ws.WsServer"%>
<%@page import="gestioneDB.GestioneActPl"%>
<%@page import="gestioneDB.GestioneAct"%>
<%@page import="utility.Utility"%>
<%@page import="utility.Utility"%>
<%
    String id_act_res=Utility.eliminaNull(request.getParameter("id_act_res"));    
    
    String dal=Utility.eliminaNull(request.getParameter("dal"));
    String al=Utility.eliminaNull(request.getParameter("al"));
    
    String query_c="";
    for(int i=0;i<=47;i++){
        String etichetta="c"+i;
        String valore_input=Utility.eliminaNull(request.getParameter(etichetta));
        String valore="-1";
        if(valore_input.equals("attivo"))valore="";
        query_c=query_c+etichetta+"="+Utility.isNull(valore)+", ";                
    }
    query_c=Utility.rimuovi_ultima_occorrenza(query_c, ",");
    
    
    String query="UPDATE act_pl SET "+query_c+" WHERE id_act_res="+Utility.isNull(id_act_res)+" AND data>="+Utility.isNull(dal)+" AND data<="+Utility.isNull(al);
    Utility.getIstanza().query(query);
    
    
    GestioneActPl.getIstanza().riprogramma_act_res(id_act_res, dal, "00:00", "");
    WsServer.sendAll("aggiorna_act_pl");
%>