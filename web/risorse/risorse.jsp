<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Risorse | <%=Utility.nomeSoftware%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
    </head>
    <body>
        <jsp:include page="../_menu.jsp"></jsp:include>
        
        <div id="container">            
            
            <%if(Utility.url.contains("localhost")){%>
                <div class='box'>
                    <button class="pulsante" onclick="mostrapopup('<%=Utility.url%>/risorse/_nuovarisorsa.jsp','Nuova Risorsa')">Nuova Risorsa</button>                      
                </div>
            <%}%>  
            <h1>Risorse</h1>                        

            <%String queryrisorse=" risorse.stato='1' ORDER BY risorse.ordinamento ASC";%>
            <jsp:include page="_risorse.jsp">
                <jsp:param name="queryrisorse" value="<%=queryrisorse%>"></jsp:param>
            </jsp:include>
        </div>
    </body>
</html>
