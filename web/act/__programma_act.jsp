<%@page import="server.ws.WsServer"%>
<%@page import="beans.ActCel"%>
<%@page import="gestioneDB.GestioneActCel"%>
<%@page import="gestioneDB.GestioneActPl"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.Act"%>
<%@page import="gestioneDB.GestioneAct"%>
<%@page import="utility.Utility"%>
<%
    String id_act=Utility.eliminaNull(request.getParameter("id_act"));
    String id_act_res=Utility.eliminaNull(request.getParameter("id_act_res"));
    String data=Utility.eliminaNull(request.getParameter("data"));
    String ora=Utility.eliminaNull(request.getParameter("ora"));

    GestioneActPl.getIstanza().riprogramma_act_res(id_act_res, data, ora, id_act);
  
    WsServer.sendAll("aggiorna_act_pl");
%>