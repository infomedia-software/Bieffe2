<%@page import="gestioneDB.GestioneCDL"%>
<%@page import="beans.CDL"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.Commessa"%>
<%@page import="gestioneDB.GestioneCommesse"%>
<%@page import="utility.Utility"%>
<%
    String id=Utility.eliminaNull(request.getParameter("id"));
    String ids=Utility.eliminaNull(request.getParameter("ids"));
    
    String campodamodificare=Utility.eliminaNull(request.getParameter("campodamodificare"));
    String newvalore=Utility.eliminaNull(request.getParameter("newvalore"));
    
    ArrayList<CDL> listacdl=null;
    
    if(!id.equals(""))
        listacdl=GestioneCDL.getIstanza().ricerca(" cdl.id="+id+" AND cdl.stato='1' ");
    if(!ids.equals(""))
        listacdl=GestioneCDL.getIstanza().ricerca(" cdl.id IN ("+ids+") AND cdl.stato='1' ");
    
    for(CDL cdl:listacdl){
        Utility.getIstanza().query("UPDATE cdl SET "+campodamodificare+"="+Utility.isNull(newvalore)+" WHERE id="+cdl.getId());
    }
    
%>