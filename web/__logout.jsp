<%@page import="utility.Utility"%>
<%@page import="beans.Utente"%>
<%
    Utente utente=(Utente)session.getAttribute("utente");
    session.removeAttribute("utente");
    if(utente.getPrivilegi().equals("operaio"))
        response.sendRedirect(Utility.url+"/index.jsp?accesso=operaio");
    else
        response.sendRedirect(Utility.url+"/index.jsp");
%>