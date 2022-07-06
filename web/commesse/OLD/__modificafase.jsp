<%@page import="beans.Fase"%>
<%@page import="beans.CommessaElemento"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.Commessa"%>
<%@page import="gestioneDB.GestioneCommesse"%>
<%@page import="utility.Utility"%>
<%
    String id=Utility.eliminaNull(request.getParameter("id"));
    String ids=Utility.eliminaNull(request.getParameter("ids"));
    
    String campodamodificare=Utility.eliminaNull(request.getParameter("campodamodificare"));
    String newvalore=Utility.eliminaNull(request.getParameter("newvalore"));
    
    ArrayList<Fase> fasi=null;
    
    if(!id.equals(""))
        fasi=GestioneCommesse.getIstanza().ricercaFasi(" fasi.id="+id+" AND fasi.stato='1' ");
    if(!ids.equals(""))
        fasi=GestioneCommesse.getIstanza().ricercaFasi(" fasi.id IN ("+ids+") AND fasi.stato='1' ");
    
    for(Fase f:fasi){
        if(campodamodificare.equals("durata"))
            Utility.getIstanza().query("UPDATE fasi SET "+campodamodificare+"="+newvalore+" WHERE id="+f.getId());
        else
            Utility.getIstanza().query("UPDATE fasi SET "+campodamodificare+"="+Utility.isNull(newvalore)+" WHERE id="+f.getId());
    }
    
%>