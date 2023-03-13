<%@page import="server.ws.WsServer"%>
<%@page import="beans.Act"%>
<%@page import="java.util.ArrayList"%>
<%@page import="gestioneDB.GestioneActCel"%>
<%@page import="gestioneDB.GestioneActPl"%>
<%@page import="gestioneDB.GestioneAct"%>
<%@page import="utility.Utility"%>
<%
    String data=Utility.eliminaNull(request.getParameter("data"));
    String id_act_res=Utility.eliminaNull(request.getParameter("id_act_res"));
    String ora=Utility.eliminaNull(request.getParameter("ora"));
    String operazione=Utility.eliminaNull(request.getParameter("operazione"));
    
    String act_cel="c"+GestioneActCel.calcola_indice_act_cel_from_orario(ora);
    if(operazione.equals("attiva")){
        Utility.getIstanza().query("UPDATE act_pl SET "+act_cel+"='' WHERE data="+Utility.isNull(data)+" AND id_act_res="+Utility.isNull(id_act_res));
    }else{
        Utility.getIstanza().query("UPDATE act_pl SET "+act_cel+"='-1' WHERE data="+Utility.isNull(data)+" AND id_act_res="+Utility.isNull(id_act_res));
    }    
    ArrayList<Act> act_temp=GestioneAct.getIstanza().ricerca(" act.inizio<="+Utility.isNull(data+" "+ora)+" AND act.fine>="+Utility.isNull(data+" "+ora)+" AND act.id_act_res="+Utility.isNull(id_act_res));
    if(act_temp.size()>0){
        Act act=act_temp.get(0);
        GestioneActPl.getIstanza().riprogramma_act_res(id_act_res, act.inizio_data(), act.inizio_ora(), act.getId());
    }
    WsServer.sendAll("aggiorna_act_pl");
%>