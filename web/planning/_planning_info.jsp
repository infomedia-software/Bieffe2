<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    String min_planning=Utility.getIstanza().querySelect("SELECT min(inizio) as min_planning FROM planning ", "min_planning");
    String max_planning=Utility.getIstanza().querySelect("SELECT max(fine) as max_fine FROM planning ", "max_fine");
    String max_calendario=Utility.getIstanza().querySelect("SELECT MAX(DATA) as max_calendario FROM calendario", "max_calendario");
    String max_attivita=Utility.getIstanza().querySelect("SELECT MAX(fine) as max_attivita FROM attivita WHERE situazione='in programmazione' AND DATE(fine)!='3001-01-01'","max_attivita");
    
    String planning_duplicato=Utility.getIstanza().querySelect("SELECT inizio,risorsa,COUNT(*) as numero FROM planning GROUP BY inizio,risorsa HAVING numero>1","inizio");
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Info Planning | <%=Utility.nomeSoftware%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
    </head>
    <body>
        <jsp:include page="../_menu.jsp"></jsp:include>
        
        <div id="container">
            <h1>Info Planning</h1>
            <div class="box">
                <%if(!planning_duplicato.equals("")){%>
                    <div class="clear"></div>
                    <div class="errore blink">ATTENZIONE PLANNING DUPLICATO!!!</div>                
                    <div class="height10"></div>
                <%}%>
                
                <div class="etichetta">Min Planning</div>
                <div class="valore">
                    <span><%=Utility.convertiDatetimeFormatoIT(min_planning)%></span>
                </div>
                
                <div class="etichetta">Max Planning</div>
                <div class="valore">
                    <span><%=Utility.convertiDatetimeFormatoIT(max_planning)%></span>
                </div>
                
                <div class="etichetta">Max Calendario</div>
                <div class="valore">
                    <span><%=Utility.convertiDataFormatoIT(max_calendario)%></span>
                </div>
                
                <div class="etichetta">Max Attività</div>
                <div class="valore">
                    <span><%=Utility.convertiDatetimeFormatoIT(max_attivita)%></span>
                </div>
                
              
            </div>
        </div>
    </body>
</html>
