<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="beans.Risorsa"%>
<%@page import="java.util.ArrayList"%>
<%@page import="gestioneDB.GestioneRisorse"%>
<%@page import="utility.Utility"%>
<%
    String operazione=Utility.eliminaNull(request.getParameter("operazione"));
    String data=Utility.eliminaNull(request.getParameter("data"));
    
    if(operazione.equals("abilita")){
        GestionePlanning.getIstanza().creaPlanning(data);
        Utility.getIstanza().query("UPDATE calendario SET situazione='abilitato' WHERE data="+Utility.isNull(data));
    }
    if(operazione.equals("disabilita")){
        Utility.getIstanza().query("DELETE FROM planning WHERE DATE(inizio)="+Utility.isNull(data));
        Utility.getIstanza().query("UPDATE calendario SET situazione='disabilitato' WHERE data="+Utility.isNull(data));
    }
    
    GestionePlanning.getIstanza().riprogrammaRisorse("", data+" 00:00:00");
    
    
    
%>