<%@page import="java.util.ArrayList"%>
<%@page import="beans.Attivita"%>
<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="utility.Utility"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%

    String commessa=Utility.eliminaNull(request.getParameter("commessa"));    
    String fase=Utility.eliminaNull(request.getParameter("fase"));    
    String descrizione=Utility.eliminaNull(request.getParameter("descrizione"));
    
    String durata=request.getParameter("durata");
    ArrayList<String> d=Utility.standardizzaDurata(durata);
    String ore=Utility.eliminaNull(d.get(0));
    String minuti=Utility.eliminaNull(d.get(1));
        
    String note=Utility.eliminaNull(request.getParameter("note"));    
    
    Utility.getIstanza().query("INSERT into attivita(commessa,fase_cat,inizio,fine,descrizione,ore,minuti,note,situazione) VALUES("
            + Utility.isNull(commessa)+","
            + Utility.isNull(fase)+","
            + Utility.isNull(Utility.dadefinire)+","
            + Utility.isNull(Utility.dadefinire)+","
            + Utility.isNull(descrizione)+","
            + ore+","
            + minuti+","
            + Utility.isNull(note)+", "
            + Utility.isNull(Attivita.DAPROGRAMMARE) +")");

%>