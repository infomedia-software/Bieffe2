<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
    String tipologia=Utility.eliminaNull(request.getParameter("tipologia"));
    String query=" soggetti.stato='1' ORDER BY alias ASC";
    if(tipologia.toLowerCase().equals("c"))
        query=" LOWER(tipologia) LIKE '%c%' AND "+query;
    if(tipologia.toLowerCase().equals("f"))
        query=" LOWER(tipologia) LIKE '%f%' AND "+query;    
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>
              <%if(tipologia.toUpperCase().equals("C")){%>Clienti<%}%>
              <%if(tipologia.toUpperCase().equals("F")){%>Fornitori<%}%>
            | <%=Utility.nomeSoftware%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
        <script type='text/javascript'>
        
              function sincronizza_soggetti(){
                 if(confirm('Procedere alla sincronizzazione?')){
                     mostraloader("Sincronizzazione in corso...");
                     $.ajax({
                         type: "POST",
                         url: "<%=Utility.url%>/soggetti/__sincronizza_soggetti.jsp",
                         data: "tipologia=<%=tipologia%>",
                         dataType: "html",
                         success: function(){
                             location.reload();
                         },
                         error: function(){
                             alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE sicronizza_soggetti()");
                         }
                     });
                 }
             }
             
            function nuovo_fornitore(){
                if(confirm("Procedere alla creazione di un nuovo fornitore?")){
                    $.ajax({
                        type: "POST",
                        url: "<%=Utility.url%>/soggetti/__nuovosoggetto.jsp",
                        data: "tipologia=F",
                        dataType: "html",
                        success: function(id_soggetto){
                            location.href='<%=Utility.url%>/soggetti/soggetto.jsp?id='+id_soggetto;
                        },
                        error: function(){
                            alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE nuovo_fornitore");
                        }
                    });
                }
            }
    
    
            function ricercasoggetti(){
                var query="";
                
                var codice=$("#codice").val();
                if(codice!=="")
                    query=query+" soggetti.codice LIKE '%"+codice+"%' AND ";
                
                var alias=$("#alias").val();
                if(alias!=="")
                    query=query+" soggetti.alias LIKE '%"+alias+"%' AND ";
                
                if(query!=="")
                    query=query+" soggetti.stato='1' AND soggetti.tipologia LIKE '%<%=tipologia%>%' ORDER BY alias DESC";
                    $("#querysoggetti").val(query);
                    aggiornasoggetti();
            }
            
           
        </script>
    </head>
    <body>
        <jsp:include page="../_menu.jsp"></jsp:include>
        
        <div id="container">
            
            
            
            <%if(tipologia.toLowerCase().equals("c")){%>
                <h1>Clienti</h1>
            <%}%>
            <%if(tipologia.toLowerCase().equals("f")){%>
                <h1>Fornitori</h1>
            <%}%>
            
            <div class="box">                    
                <button class="pulsante" onclick="sincronizza_soggetti();">Sincronizza</button>                      
                
                <button class='pulsante float-left' onclick="location.reload()">
                    <img src="../images/search.png">Mostra Tutti
                </button>
                <%if(tipologia.toLowerCase().equals("f")){%>
                    <button class="pulsante" onclick="nuovo_fornitore();"><img src="<%=Utility.url%>/images/add.png">Nuovo Fornitore</button>                      
                <%}%>
            </div>               
        
              
            <div class="width50">
            <div class="box">                    
                <div class='etichetta'>Codice</div>
                <div class='valore'><input type='text' id='codice'></div>
                    
                <div class='etichetta'>Alias</div>
                <div class='valore'><input type='text' id='alias'></div>

                <button class='pulsante float-right' onclick="ricercasoggetti()">
                    <img src="../images/search.png">Ricerca
                </button>
            </div>
               
            </div>
                
                <div class="height10"></div>
            <div class="box">             
                <jsp:include page="_soggetti.jsp">
                    <jsp:param name="query" value="<%=query%>"></jsp:param>
                </jsp:include>            
            </div>
        </div>
    </body>
</html>
