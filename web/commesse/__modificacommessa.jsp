<%@page import="java.util.ArrayList"%>
<%@page import="beans.Commessa"%>
<%@page import="gestioneDB.GestioneCommesse"%>
<%@page import="utility.Utility"%>
<%
    String id=Utility.eliminaNull(request.getParameter("id"));
    String ids=Utility.eliminaNull(request.getParameter("ids"));
    
    String campodamodificare=Utility.eliminaNull(request.getParameter("campodamodificare"));
    String newvalore=Utility.eliminaNull(request.getParameter("newvalore"));
    
    //System.out.println(id+">"+campodamodificare+">"+newvalore);
    
    if(campodamodificare.equals("data_consegna"))
        newvalore=newvalore.replace("T", " ")+":00";
    if(newvalore.equals(":00"))
        newvalore="0001-01-01 01:00:00";
    
    
    ArrayList<Commessa> commesse=null;
    
    if(!id.equals(""))
        commesse=GestioneCommesse.getIstanza().ricerca(" commesse.id="+id+" AND commesse.stato='1' ");
    if(!ids.equals(""))
        commesse=GestioneCommesse.getIstanza().ricerca(" commesse.id IN ("+ids+") AND commesse.stato='1' ");
    
    
    for(Commessa c:commesse){
        Utility.getIstanza().query("UPDATE commesse SET "+campodamodificare+"="+Utility.isNull(newvalore)+" WHERE id="+c.getId());
    }
    
%>