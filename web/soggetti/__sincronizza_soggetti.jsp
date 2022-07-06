<%@page import="gestioneDB.GestioneSincronizzazione"%>
<%@page import="java.util.HashMap"%>
<%@page import="gestioneDB.DBUtility"%>
<%@page import="utility.GestioneErrori"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.Map"%>
<%@page import="utility.Utility"%>
<%@page import="java.sql.SQLException"%>
<%@page import="connection.ConnectionPoolException"%>
<%@page import="gestioneDB.GestioneSoggetti"%>
<%
    String tipologia=Utility.eliminaNull(request.getParameter("tipologia"));
    
    if(tipologia.toLowerCase().equals("c"))
        GestioneSincronizzazione.getIstanza().sincronizza_clienti("");
        
%>