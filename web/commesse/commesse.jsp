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
    String situazione=Utility.eliminaNull(request.getParameter("situazione"));
    String ULTIMA_SINCRONIZZAZIONE=Utility.getIstanza().getValoreByCampo("opzioni", "valori", "etichetta='ULTIMA_SINCRONIZZAZIONE'");
    
    long MINUTI_ULTIMA_SINCRONIZZAZIONE=Utility.compareTwoTimeStamps(Utility.dataOraCorrente_String(), ULTIMA_SINCRONIZZAZIONE);
    if(MINUTI_ULTIMA_SINCRONIZZAZIONE>60){    
        response.sendRedirect(Utility.url+"/commesse/_sincronizza_commesse.jsp?situazione="+situazione);
    }
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Commesse | <%=Utility.nomeSoftware%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>

    </head>
    <body>
        <jsp:include page="../_menu.jsp"></jsp:include>
        <div id="container">            

            <h1>Commesse </h1>

            <div class="box">                
                <a href='<%=Utility.url%>/commesse/_sincronizza_commesse.jsp?situazione=<%=situazione%>' class="pulsante"><img src="<%=Utility.url%>/images/sincro.png">Sincronizza</a>
                <p style="font-size: 10px;text-align: right;font-style:italic">
                    Ultima Sincronizzazione <%=Utility.convertiDatetimeFormatoIT(ULTIMA_SINCRONIZZAZIONE)%>
                </p>
            </div>

            <div class="box">
            <%            
                String query="commesse.stato='1' ";
                String ordinamento="commesse.numero DESC";
                String limit="0";
            %>
            <jsp:include page="_commesse.jsp">
                <jsp:param name="query" value="<%=query%>"></jsp:param>
                <jsp:param name="ordinamento" value="<%=ordinamento%>"></jsp:param>
                <jsp:param name="limit" value="<%=limit%>"></jsp:param>                
            </jsp:include>
            </div>
        </div>
    </body>
</html>