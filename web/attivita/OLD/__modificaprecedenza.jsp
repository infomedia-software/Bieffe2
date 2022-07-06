
<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="utility.Utility"%>
<%
    String id=Utility.eliminaNull(request.getParameter("id"));    
    
    String campodamodificare=Utility.eliminaNull(request.getParameter("campodamodificare"));
    String newvalore=Utility.eliminaNull(request.getParameter("newvalore"));

    if(!campodamodificare.equals("stato")){
        String query="UPDATE precedenze SET "+campodamodificare+"="+Utility.isNull(newvalore)+" WHERE id="+id;
        Utility.getIstanza().query(query);    
    }
    if(campodamodificare.equals("stato")){
        String query="DELETE FROM precedenze WHERE id="+id;
        Utility.getIstanza().query(query);    
    }    
    GestionePlanning.getIstanza().verificaPrecedenze("");

%>