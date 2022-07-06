<%@page import="gestioneDB.GestioneSoggetti"%>
<%@page import="beans.Soggetto"%>
<%@page import="java.util.ArrayList"%>
<%@page import="utility.Utility"%>
<%
    String id=Utility.eliminaNull(request.getParameter("id"));
    String campodamodificare=Utility.eliminaNull(request.getParameter("campodamodificare"));
    String newvalore=Utility.eliminaNull(request.getParameter("newvalore"));
    
    ArrayList<Soggetto> soggetti=null;
    
    if(!id.equals(""))
        soggetti=GestioneSoggetti.getIstanza().ricerca(" soggetti.id="+Utility.isNull(id)+" AND soggetti.stato='1' ");
    
    for(Soggetto s:soggetti){        
        Utility.getIstanza().query("UPDATE soggetti "
                + "SET "+campodamodificare+"="+Utility.isNull(newvalore)+" "
                + "WHERE soggetti.id="+Utility.isNull(s.getId()));
    }
%>