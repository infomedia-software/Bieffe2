<%@page import="beans.Risorsa"%>
<%@page import="gestioneDB.GestioneRisorse"%>
<%@page import="beans.Utente"%>
<%@page import="beans.Attivita"%>
<%@page import="utility.Th"%>
<%@page import="gestioneDB.GestioneSoggetti"%>
<%@page import="beans.Soggetto"%>
<%@page import="java.util.ArrayList"%>
<%@page import="gestioneDB.GestioneCommesse"%>
<%@page import="beans.Commessa"%>
<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
    Utente utente=(Utente)session.getAttribute("utente");
    String query=Utility.eliminaNull(request.getParameter("query"));
    String ordinamento=Utility.eliminaNull(request.getParameter("ordinamento"));
    String limit=Utility.eliminaNull(request.getParameter("limit"));
    
    String risorsa=Utility.eliminaNull(request.getParameter("risorsa"));
    
    if(query.equals("") && ordinamento.equals("") && limit.equals("")){
        query=" attivita.completata='' AND "
                + "attivita.situazione="+Utility.isNull(Attivita.INPROGRAMMAZIONE)+" AND "
                + "attivita.stato='1' AND "
                + "( "
                    + "( DATE(attivita.inizio)<=DATE(NOW()) AND DATE(attivita.fine)>=DATE(NOW()) ) OR ( DATE(attivita.inizio)>=DATE(NOW()) OR DATE(attivita.fine)>=DATE(NOW()) "
                + ") "
            + "OR attivita.attiva_infogest='si' )";        
        if(!risorsa.equals(""))
            query=query+" AND attivita.risorsa="+Utility.isNull(risorsa);
        ordinamento="attivita.inizio ASC";
        limit="0";
    }    
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Attività | <%=Utility.nomeSoftware%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>     
    </head>
    <body>
        <jsp:include page="../_menu.jsp"></jsp:include>
        <div id="container">

            <h1>Attività</h1>
            
            <%                
                ArrayList<Risorsa> risorse =GestioneRisorse.getIstanza().ricercaRisorse(" risorse.stato='1' AND risorse.planning='si' ORDER BY risorse.ordinamento ASC");                
            %>
            <div class="box">
                <button class="pulsante_tabella "  onclick="location.href='<%=Utility.url%>/attivita/lista_attivita.jsp'">Mostra Tutte</button>
                <%for(Risorsa r:risorse){%>
                    <button class="pulsante_tabella "  onclick="location.href='<%=Utility.url%>/attivita/lista_attivita.jsp?risorsa=<%=r.getId()%>'"><%=r.getNome()%></button>
                <%}%>
            </div>
            
          
            <jsp:include page="_lista_attivita.jsp">
                <jsp:param name="query" value="<%=query%>"></jsp:param>
                <jsp:param name="ordinamento" value="<%=ordinamento%>"></jsp:param>
                <jsp:param name="risorsa" value="<%=risorsa%>"></jsp:param>
                <jsp:param name="limit" value="<%=limit%>"></jsp:param>
                <jsp:param name="attivita.situazione" value="<%=Attivita.INPROGRAMMAZIONE%>"></jsp:param>	
            </jsp:include>
        </div>
    </body>
</html>
