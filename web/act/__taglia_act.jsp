<%@page import="server.ws.WsServer"%>
<%@page import="utility.Utility"%>
<%
    String id_act=Utility.eliminaNull(request.getParameter("id_act"));
    Utility.getIstanza().query("UPDATE act SET id_act_res='',inizio=null,fine=null,programmata='' WHERE id="+id_act);
    
    WsServer.sendAll("aggiorna_act_pl");
%>