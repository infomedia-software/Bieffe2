<%@page import="utility.Utility"%>
<%@page import="gestioneDB.GestioneCommesse"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%    
    String commessa=Utility.eliminaNull(request.getParameter("commessa"));
    String nuovoelemento=Utility.eliminaNull(request.getParameter("nuovoelemento"));
    
    Utility.getIstanza().query("INSERT INTO commessa_elementi(commessa,descrizione) VALUES("
            + Utility.isNull(commessa)+","
            + Utility.isNull(nuovoelemento)+ ")");
     
%>