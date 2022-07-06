<%@page import="utility.Utility"%>
<%@page import="gestioneDB.GestioneCommesse"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%    
    
    String id=GestioneCommesse.getIstanza().nuovaCommessa();
    
    String descrizione=Utility.eliminaNull(request.getParameter("descrizione"));
    if(!descrizione.equals("")){
        Utility.getIstanza().query("UPDATE commesse SET descrizione="+Utility.isNull(descrizione)+" WHERE id="+id);
    }
    out.print(id);
%>