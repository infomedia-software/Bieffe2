<%@page import="gestioneDB.GestioneUtenti"%>
<%@page import="beans.Utente"%>
<%@page import="utility.Utility"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%
    String nomeutente=Utility.eliminaNull(request.getParameter("nomeutente"));
    String password=Utility.eliminaNull(request.getParameter("password"));        
    String accesso=Utility.eliminaNull(request.getParameter("accesso"));    
    
    if(accesso.equals("operaio"))
        nomeutente=password;
    
    Utente utente=GestioneUtenti.getIstanza().login(nomeutente,password);
    
    if(utente==null){
        out.print("no");
    }else{
        session.setAttribute("utente", utente);        
        out.print(Utility.url+"/index.jsp");    
    }
%>