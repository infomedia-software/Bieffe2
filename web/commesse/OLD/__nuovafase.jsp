<%@page import="utility.Utility"%>
<%@page import="gestioneDB.GestioneCommesse"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%    
    String commessa=Utility.eliminaNull(request.getParameter("commessa"));    
    String elemento=Utility.eliminaNull(request.getParameter("elemento"));
    String descrizione=Utility.eliminaNull(request.getParameter("descrizione"));
    String durata=Utility.eliminaNull(request.getParameter("durata"));
    String note=Utility.eliminaNull(request.getParameter("note"));
    
    Utility.getIstanza().query("INSERT INTO fasi(commessa,elemento,descrizione,durata,note) VALUES("
            + Utility.isNull(commessa)+","
            + Utility.isNull(elemento)+","
            + Utility.isNull(descrizione)+","
            + durata+","
            + Utility.isNull(note)+")");
     
%>