<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Centri di Lavoro | <%=Utility.nomeSoftware%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
        <script type="text/javascript">
            function nuovocdl(){
                if(confirm("Procedere all'inserimento di un nuovo CDL?")){
                    mostraloader("Inserimento in corso...");
                    $.ajax({
                        type: "POST",
                        url: "<%=Utility.url%>/cdl/__nuovocdl.jsp",
                        data: "",
                        dataType: "html",
                        success: function(msg){
                            location.href='centrodilavoro.jsp?id='+msg;
                        },
                        error: function(){
                            alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE nuovocdl");
                        }
                    });
                }
            }
        </script>
    </head>
    <body>
        <jsp:include page="../_menu.jsp"></jsp:include>
        <div id="container">
            <h1>Centri di Lavoro</h1>
            <button class="pulsante" onclick="nuovocdl();">
                <img src="<%=Utility.url%>/images/add.png">Nuovo CDL
            </button>
            
            
            <%String querycdl=" stato='1' ORDER BY codice ASC";%>
            <jsp:include page="_cdl.jsp">
                <jsp:param name="querycdl" value="<%=querycdl%>"></jsp:param>
            </jsp:include>
        </div>
    </body>
</html>
