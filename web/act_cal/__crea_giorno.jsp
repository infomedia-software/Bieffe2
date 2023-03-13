<%@page import="gestioneDB.GestioneActPl"%>
<%@page import="beans.ActRes"%>
<%@page import="gestioneDB.GestioneActRes"%>
<%@page import="beans.Risorsa"%>
<%@page import="java.util.ArrayList"%>
<%@page import="gestioneDB.GestioneRisorse"%>
<%@page import="utility.Utility"%>
<%
    String data=Utility.eliminaNull(request.getParameter("data"));
    GestioneActPl.getIstanza().crea_act_pl(data);            
%>