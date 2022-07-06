<%@page import="beans.Risorsa"%>
<%@page import="gestioneDB.GestioneRisorse"%>
<%@page import="gestioneDB.GestioneUtenti"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.Utente"%>
<%@page import="beans.Soggetto"%>
<%@page import="utility.Utility"%>
<%@page import="gestioneDB.GestioneSoggetti"%>
<%
    Utente utente=(Utente)session.getAttribute("utente");
    String id=Utility.eliminaNull(request.getParameter("id"));
    
    Utente dipendente=GestioneUtenti.getIstanza().ricerca(" soggetti.id="+Utility.isNull(id)+" AND soggetti.stato='1'").get(0);    
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%=dipendente.getCognome()%> <%=dipendente.getNome()%> | <%=Utility.nomeSoftware%></title>                
        <jsp:include page="../_importazioni.jsp"></jsp:include>
        
        <script type="text/javascript">
            function modificautente(inField){                
                var newvalore=inField.value;
                var campodamodificare=inField.id;
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/soggetti/__modifica_soggetto.jsp",
                    data: "newvalore="+encodeURIComponent(String(newvalore))+"&campodamodificare="+campodamodificare+"&id=<%=id%>",
                    dataType: "html",
                    success: function(msg){
                        if(campodamodificare==="privilegi")
                            location.reload();                            
                    },
                    error: function(){
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE modificasoggetto()");
                    }
                });
            }
            
            function cancellautente(id){
                if(confirm("Procedere alla cancellazione dell'utente?")){
                    var newvalore="-1";
                    var campodamodificare="stato";
                    mostraloader("Cancellazione in corso...");
                    $.ajax({
                        type: "POST",
                        url: "<%=Utility.url%>/soggetti/__modifica_soggetto.jsp",
                        data: "newvalore="+encodeURIComponent(String(newvalore))+"&campodamodificare="+campodamodificare+"&id="+id,
                        dataType: "html",
                        success: function(msg){
                            location.href='<%=Utility.url%>/utenti/utenti.jsp';
                        },
                        error: function(){
                            alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE cancellasoggetto()");
                        }
                    });
                }
            }
            
            
            function nuovarisorsa(){
                var soggetto=$("#soggetto").val();
                if(soggetto!==""){
                    if(confirm("Trasformare il dipendente in una risorsa?")){                                
                        mostraloader("Operazione in corso...");
                        var nome=$("#nome").val();
                        var cognome=$("#cognome").val();
                        var cognomenome=cognome+" "+nome;
                        $.ajax({
                            type: "POST",
                            url: "<%=Utility.url%>/risorse/__nuovarisorsa.jsp",
                            data: "rif=SOGGETTI&idrif=<%=id%>&nome="+encodeURIComponent(String(cognomenome)),
                            dataType: "html",
                            success: function(msg){
                                location.reload();

                            },
                            error: function(){
                                alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE nuovarisorsa()");
                            }
                        });
                    }
                }
            }
        </script>
        
    </head>
    <body>
        <jsp:include page="../_menu.jsp"></jsp:include>
        
        
     
        
        
        <div id="container">
            <h1><%=dipendente.getCognome()%> <%=dipendente.getNome()%></h1>
            
            <% if(utente.getPrivilegi().equals("amministratore")){%>        
            <div class="box">                                
                <button class="pulsante red float-right" onclick="cancellautente('<%=id%>');"><img src="<%=Utility.url%>/images/delete.png">Cancella</button>            
            </div>               
            <%}%>
  
        
            <div class="width50 float-left">
                <div class="box">
                    <div class="etichetta">Codice</div>
                    <div class="valore">
                        <input type="text" id="codice" value="<%=dipendente.getCodice()%>" onchange="modificautente(this)">
                    </div>

                    <div class="etichetta">Cognome</div>
                    <div class="valore">
                        <input type="text" id="cognome" value="<%=dipendente.getCognome()%>" onchange="modificautente(this)">
                    </div>

                    <div class="etichetta">Nome</div>
                    <div class="valore">
                        <input type="text" id="nome" value="<%=dipendente.getNome()%>" onchange="modificautente(this)">
                    </div>


                    <div class="displaynone">
                        <div class="etichetta">Costo Orario</div>
                        <div class="valore">
                           <input type="number" id="costo" value="<%=dipendente.getCosto()%>" onchange="modificautente(this);" style="width: 60px"> &euro; 
                        </div>
                    </div>

                    <div class="etichetta">Ruolo</div>
                    <div class="valore">
                        <select id="privilegi" onchange="modificautente(this)">
                            <option value="" >Seleziona il ruolo</option>                            
                            <option value="reparto" <%if(dipendente.getPrivilegi().equals("reparto")){%>selected="true"<%}%>>Reparto</option>
                            <option value="magazzino" <%if(dipendente.getPrivilegi().equals("magazzino")){%>selected="true"<%}%>>Magazzino</option>
                            <option value="montaggio" <%if(dipendente.getPrivilegi().equals("montaggio")){%>selected="true"<%}%>>Montaggio</option>
                            <option value="ufficio" <%if(dipendente.getPrivilegi().equals("ufficio")){%>selected="true"<%}%>>Ufficio</option>                            
                            <%if(utente.getPrivilegi().equals("amministratore")){%>
                                <option value="amministratore" <%if(dipendente.getPrivilegi().equals("amministratore")){%>selected="true"<%}%>>Amministratore</option>
                            <%}%>
                        </select>
                    </div>                    
                </div>
            </div>

            <div class="width50 float-left">       
                <% if(utente.getPrivilegi().equals("amministratore")){%>
                    <div class="box">
                    <%if(!dipendente.getPrivilegi().equals("operaio")){%>
                       <div class="etichetta">Nome Utente</div>
                       <div class="valore">
                           <input type="text" id="nomeutente" value="<%=dipendente.getNomeutente()%>" onchange="modificautente(this)">
                       </div>

                       <div class="etichetta">Password</div>
                       <div class="valore">
                           <input type="text" id="password" value="<%=dipendente.getPassword()%>" onchange="modificautente(this)">
                       </div>
                   <%}else{%>
                       <div class="etichetta">PIN</div>
                       <div class="valore">
                           <input type="text" id="password" value="<%=dipendente.getPassword()%>" onchange="modificautente(this)">
                       </div>
                   <%}%>
                   </div>
                <%}%>
                            
                <div class="clear"></div>
            </div>            
        </div>
            
            
    </body>
</html>
