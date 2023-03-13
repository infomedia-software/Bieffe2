<%@page import="gestioneDB.GestioneActRes"%>
<%@page import="beans.ActRes"%>
<%@page import="gestioneDB.GestioneAct"%>
<%@page import="gestioneDB.GestioneActPl"%>
<%@page import="utility.Utility"%>
<%
    String data=Utility.eliminaNull(request.getParameter("data"));
    
    Utility.getIstanza().query("DELETE FROM act_pl WHERE data="+Utility.isNull(data));
    Utility.getIstanza().query("UPDATE act_cal SET attivo='' WHERE data="+Utility.isNull(data));
    
    // RIPROGRAMMA RISORSE
    for(ActRes act_res:GestioneActRes.getIstanza().ricerca(""))
        GestioneActPl.getIstanza().riprogramma_act_res(act_res.getId(), data, "00:00", "");
%>