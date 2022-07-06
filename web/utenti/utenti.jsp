<%@page import="beans.Utente"%>
<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Utente utente=(Utente)session.getAttribute("utente");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Utenti | <%=Utility.nomeSoftware%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
        <script type="text/javascript">
            function nuovoutente(){                
                if(confirm('Procedere alla creazione di un nuovo utente?')){
                    mostraloader("Creazione dell'utente in corso...");
                    $.ajax({
                        type: "POST",
                        url: "<%=Utility.url%>/soggetti/__nuovosoggetto.jsp",
                        data: "tipologia=D",
                        dataType: "html",
                        success: function(msg){
                            location.href='<%=Utility.url%>/utenti/utente.jsp?id='+msg;
                        },
                        error: function(){
                            alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE nuovoutente()");
                        }
                    });
                }
            }
        </script>
    </head>
    <body>
        <jsp:include page="../_menu.jsp"></jsp:include>
        
        <div id="container">
            
            <h1>Utenti</h1>   
            
            <div class="box">                        
                <button class="pulsante" onclick="nuovoutente();">
                    <img src="<%=Utility.url%>/images/add.png">
                    Nuovo Utente
                </button>                                      
            </div>
  
        
            <div class="clear"></div>
            <%
                String query=" soggetti.stato='1' AND soggetti.tipologia='D' ORDER BY cognome ASC";
            %>
            <jsp:include page="_utenti.jsp">
                <jsp:param name="query" value="<%=query%>"></jsp:param>
            </jsp:include>            
            
        </div>
    </body>
</html>
