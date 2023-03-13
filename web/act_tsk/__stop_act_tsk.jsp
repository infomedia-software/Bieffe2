<%@page import="server.ws.WsServer"%>
<%@page import="utility.Utility"%>
<%
    String id_tsk=Utility.eliminaNull(request.getParameter("id_act_tsk"));
    String completata=Utility.eliminaNull(request.getParameter("completata"));
    Utility.getIstanza().query("UPDATE act_tsk SET fine=NOW() WHERE id="+id_tsk);
    
    String id_act=Utility.getIstanza().getValoreByCampo("act_tsk", "id_act", "id="+id_tsk);
    Utility.getIstanza().query("UPDATE act SET attiva='',completata="+Utility.isNull(completata) +" WHERE id="+id_act);
    
    WsServer.sendAll("stop_act_tsk");
%>