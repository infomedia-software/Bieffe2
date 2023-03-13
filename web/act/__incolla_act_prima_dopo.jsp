<%@page import="server.ws.WsServer"%>
<%@page import="gestioneDB.GestioneActPl"%>
<%@page import="beans.Act"%>
<%@page import="gestioneDB.GestioneAct"%>
<%@page import="utility.Utility"%>
<%@page import="utility.Utility"%>
<%
    String id_act_incolla=Utility.eliminaNull(request.getParameter("id_act_incolla"));
    String operazione=Utility.eliminaNull(request.getParameter("operazione"));
    String id_act=Utility.eliminaNull(request.getParameter("id_act"));
    Act act=GestioneAct.getIstanza().get_act(id_act);
    
    String id_act_res=act.getAct_res().getId();
    
    if(operazione.equals("prima")){
        String data=act.inizio_data();
        String ora=act.inizio_ora();
        
        GestioneActPl.getIstanza().riprogramma_act_res(id_act_res, data, ora, id_act_incolla);
    }
    if(operazione.equals("dopo")){
        String data=act.fine_data();
        String ora=act.fine_ora();
        GestioneActPl.getIstanza().riprogramma_act_res(id_act_res, data, ora, id_act_incolla);
    }
    WsServer.sendAll("aggiorna_act_pl");
%>