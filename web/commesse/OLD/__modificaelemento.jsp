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
    
    ArrayList<CommessaElemento> elementi=null;
    
    if(!id.equals(""))
        elementi=GestioneCommesse.getIstanza().ricercaElementi(" commessa_elementi.id="+id+" AND commessa_elementi.stato='1' ");
    if(!ids.equals(""))
        elementi=GestioneCommesse.getIstanza().ricercaElementi(" commessa_elementi.id IN ("+ids+") AND commessa_elementi.stato='1' ");
    
    for(CommessaElemento ce:elementi){
        Utility.getIstanza().query("UPDATE commessa_elementi SET "+campodamodificare+"="+Utility.isNull(newvalore)+" WHERE id="+ce.getId());
    }
    
%>