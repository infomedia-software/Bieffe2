<%@page import="beans.Indirizzo"%>
<%@page import="beans.Risorsa"%>
<%@page import="java.util.ArrayList"%>
<%@page import="gestioneDB.GestioneRisorse"%>
<%@page import="beans.Soggetto"%>
<%@page import="utility.Utility"%>
<%@page import="gestioneDB.GestioneSoggetti"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
    String id=Utility.eliminaNull(request.getParameter("id"));
    Soggetto s=GestioneSoggetti.getIstanza().ricerca(" soggetti.id="+Utility.isNull(id)+" AND soggetti.stato='1'").get(0);
    
    String tipologia=s.getTipologia();
    if(tipologia.equals(""))
        tipologia="C";
    
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%=s.getAlias()%> | <%=Utility.nomeSoftware%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
        <script type='text/javascript'>
            function modifica_soggetto(inField){                
                var newvalore=inField.value;
                var campodamodificare=inField.id;                
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/soggetti/__modifica_soggetto.jsp",
                    data: "newvalore="+encodeURIComponent(String(newvalore))+"&campodamodificare="+campodamodificare+"&id=<%=id%>",
                    dataType: "html",
                    success: function(msg){
                    },
                    error: function(){
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE modifica_soggetto()");
                    }
                });
            }
            
            function cancellasoggetto(id){
                if(confirm('Procedere alla cancellazione del soggetto?')){
                    var newvalore="-1";
                    var campodamodificare="stato";
                    mostraloader("Cancellazione in corso...");
                    $.ajax({
                        type: "POST",
                        url: "<%=Utility.url%>/soggetti/__modifica_soggetto.jsp",
                        data: "newvalore="+encodeURIComponent(String(newvalore))+"&campodamodificare="+campodamodificare+"&id="+id,
                        dataType: "html",
                        success: function(msg){
                            location.href='<%=Utility.url%>/soggetti/soggetti.jsp?tipologia=<%=tipologia%>'
                        },
                        error: function(){
                            alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE cancellasoggetto()");
                        }
                    });
                }
            }
            
            
        </script>
    </head>
    <body>
        <jsp:include page="../_menu.jsp"></jsp:include>
        <div id='container'>
                <h1><%=s.getAlias()%></h1>
                
                <div class="width50 float-left">
                
                    <div class="box " >
                        <div class='etichetta'>Tipologia</div>
                        <div class='valore'>
                            <select id='tipologia' onchange="modifica_soggetto(this)">
                                <option value='C' <%if(s.getTipologia().equals("C")){%>selected="true"<%}%> >Cliente</option>
                                <option value='F' <%if(s.getTipologia().equals("F")){%>selected="true"<%}%>>Fornitore</option>
                                <option value='CF' <%if(s.getTipologia().equals("CF")){%>selected="true"<%}%>>Cliente/Fornitore</option>
                            </select>
                        </div>

                        <div class="etichetta">Codice</div>
                        <div class="valore">
                            <input type="text" id="codice"  onchange="modificautente(this)" value="<%=s.getCodice()%>">
                        </div>

                        <div class='etichetta'>Alias</div> 
                        <div class='valore'>
                            <input type='text' id='alias' onchange="modifica_soggetto(this);" value="<%=s.getAlias()%>">
                        </div>

                        <div class='clear'></div>
                    </div>
                </div>
            
            <div class="clear"></div>
            
            <h3>Indirizzi</h3>
                <%
                for(int i=0;i<5;i++){                        
                    String indirizzo_string="";
                    String comune="";
                    String provincia="";
                    String nazione="";
                    String telefono="";
                    String email="";
                    if(s.getIndirizzi().size()>i){
                        Indirizzo indirizzo=s.getIndirizzi().get(i);
                        indirizzo_string=indirizzo.getIndirizzo();
                        comune=indirizzo.getComune();
                        provincia=indirizzo.getProvincia();
                        nazione=indirizzo.getNazione();
                        email=indirizzo.getEmail();
                        telefono=indirizzo.getTelefono();
                    }
                %>    
                <div class="width50 float-left">
                    <div class="box">                                
                        <div class="etichetta">Indirizzo</div>
                        <div class="valore">
                            <input type='text' id='indirizzo<%=i%>' onchange="modifica_soggetto(this);" value="<%=indirizzo_string%>">
                        </div>

                        <div class="etichetta">Comune</div>
                        <div class="valore">
                            <input type='text' id='comune<%=i%>' onchange="modifica_soggetto(this);" value="<%=comune%>">
                        </div>

                        <div class="etichetta">Provincia</div>
                        <div class="valore">
                            <input type='text' id='provincia<%=i%>' onchange="modifica_soggetto(this);" value="<%=provincia%>">
                        </div>

                        <div class="etichetta">Nazione</div>
                        <div class="valore">
                            <input type='text' id='nazione<%=i%>' onchange="modifica_soggetto(this);" value="<%=nazione%>">
                        </div>          

                        <div class="etichetta">Telefono</div>
                        <div class="valore">
                            <input type='text' id='telefono<%=i%>' onchange="modifica_soggetto(this);" value="<%=telefono%>">
                        </div>          

                        <div class="etichetta">E-mail</div>
                        <div class="valore">
                            <input type='text' id='email<%=i%>' onchange="modifica_soggetto(this);" value="<%=email%>">
                        </div>                                                                                      
                    </div>
                </div>
                <%}%>                  
        </div>
    </body>
</html>
