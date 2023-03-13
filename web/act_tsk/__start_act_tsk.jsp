<%@page import="server.ws.WsServer"%>
<%@page import="beans.Utente"%>
<%@page import="utility.Utility"%>
<%
    Utente utente=(Utente)session.getAttribute("utente");
    String id_act=Utility.eliminaNull(request.getParameter("id_act"));
  
    Utility.getIstanza().query("INSERT INTO act_tsk(id_act,id_soggetto,inizio,stato) VALUES ("
            + Utility.isNull(id_act)+","
            + Utility.isNull(utente.getId())+","
            + "NOW(),"
            + "'1'"        
        + ")");
    
    Utility.getIstanza().query("UPDATE act SET attiva='si' WHERE id="+id_act);
    
    WsServer.sendAll("start_act_tsk");
%>