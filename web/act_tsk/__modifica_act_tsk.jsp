<%@page import="server.ws.WsServer"%>
<%@page import="utility.Utility"%>
<%
    String id_act_tsk=Utility.eliminaNull(request.getParameter("id_act_tsk"));
    String campo_da_modificare=Utility.eliminaNull(request.getParameter("campo_da_modificare"));
    String new_valore=Utility.eliminaNull(request.getParameter("new_valore"));

    Utility.getIstanza().query("UPDATE act_tsk SET "+campo_da_modificare+"="+Utility.isNull(new_valore)+" WHERE id="+id_act_tsk);
    
    if(!campo_da_modificare.equals("note"))
        WsServer.sendAll("aggiorna_act_pl");
%>