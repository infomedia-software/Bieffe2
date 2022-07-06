<%@page import="beans.Utente"%>
<%@page import="java.util.ArrayList"%>
<%@page import="utility.Utility"%>
<%@page import="beans.Soggetto"%>
<%@page import="gestioneDB.GestioneSoggetti"%>
<%
        
    Utente utente=(Utente)session.getAttribute("utente");
    
    String query=Utility.eliminaNull(request.getParameter("query"));
    
    if(query.equals(""))
        query=" soggetti.stato='1' ORDER BY alias ASC";    
    
    String tipologia=Utility.eliminaNull(request.getParameter("tipologia"));
    if(!tipologia.equals(""))
        query="soggetti.tipologia LIKE "+Utility.isNullLike(tipologia)+" AND "+query;
    
    ArrayList<Soggetto> soggetti=GestioneSoggetti.getIstanza().ricerca(query);
%>
<script type="text/javascript">
    
    function nuovosoggetto(){
        if(confirm("Procedere all'inserimento di un nuovo soggetto?")){
            mostraloader("Inserimento in corso...");
            $.ajax({
                type: "POST",
                url: "<%=Utility.url%>/soggetti/__nuovosoggetto.jsp",
                data: $("#formnuovosoggetto").serialize(),
                dataType: "html",
                success: function(idsoggetto){
                    aggiornasoggetti(idsoggetto);                   
                },
                error: function(){
                    alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE nuovosoggetto()");
                }
            });
        }		
    }
    
    $(function(){
	$("#inputricercasoggetto").keypress(function(e) {
            if(e.which === 13) {
                ricercasoggetto();
            }
	});
    });
    
    function ricercasoggetto(){
        var inputricercasoggetto=$("#inputricercasoggetto").val();        
        if(inputricercasoggetto!==""){
            var query=" (soggetti.comune LIKE '%"+inputricercasoggetto+"%' OR soggetti.alias LIKE '%"+inputricercasoggetto+"%'  OR soggetti.ragionesociale LIKE '%"+inputricercasoggetto+"%' ) AND soggetti.tipologia='<%=tipologia%>' AND soggetti.stato='1' ORDER BY alias ASC";            
            mostraloader("Ricerca in corso...");            
            $("#ricercasoggetto").load("<%=Utility.url%>/soggetti/ricercasoggetto.jsp?tipologia=<%=tipologia%>&query="+encodeURIComponent(String(query))+" #ricercasoggetto_inner",function(){nascondiloader();});            
        }
    }
</script>


<div class="tabs">
    <div class="tab tab2" id="tabricercasoggetto" onclick="mostratabpopup('ricercasoggetto');">Ricerca Soggetto</div>
    <%if(!utente.getPrivilegi().equals("operaio")){%>
        <div class="tab" id="tabnuovosoggetto" onclick="mostratabpopup('nuovosoggetto');">Nuovo Soggetto</div>
    <%}%>
</div>

<!-- RICERCA SOGGETTO-->
<div class="scheda" id="schedaricercasoggetto">
    
    <input type='text' id='inputricercasoggetto' class="inputricercagenerale">
    <button class="pulsanteimg float-left" onclick="ricercasoggetto();" >        
        <img src='<%=Utility.url%>/img/search.png' >    
    </button>
    
    <div id='ricercasoggetto'>
        <div id='ricercasoggetto_inner'>
            <table class='tabella'>
                <tr>
                    <th>Alias</th>
                    <th>Ragione Sociale</th>
                    <th>Indirizzo</th>                
                    <th style="width: 45px;"></th>
                </tr>
                <%for(Soggetto s:soggetti){%>
                    <tr>                   
                        <td><%=s.getAlias()%></td>                    
                        <td><%=s.getRagionesociale()%></td>                    
                        <td><%=s.getIndirizzo0()%> - <%=s.getComune0()%> (<%=s.getProvincia0()%>) </td>                                        
                        <td>
                            <button class="pulsanteimg " type="button" href='<%=Utility.url%>/soggetti/soggetto.jsp?id=<%=s.getId()%>'  onclick="aggiornasoggetti('<%=s.getId()%>')">
                                <img src="<%=Utility.url%>/img/v2.png">
                            </button>
                        </td>
                    </tr>
                <%}%>
            </table>
        </div>
    </div>
</div>


<!-- NUOVO SOGGETTO-->            
<div class="scheda displaynone" id="schedanuovosoggetto">
    
    <form id='formnuovosoggetto'>
        <div class='etichetta'>Tipologia</div>
        <div class='valore'>
            <select name='tipologia'>
                <option value=''>Seleziona la Tipologia</option>
                <option value='C'>Cliente</option>
                <option value='F'>Fornitore</option>
                <option value='CF'>Cliente/Fornitore</option>            
            </select>
        </div>
        
        <div class="etichetta">Alias</div>
        <div class="valore"><input type='text' name='alias'></div>

        <div class="etichetta">Ragione Sociale</div>
        <div class="valore"><input type='text' name='ragionesociale'></div>
        
        <div class="etichetta">Partita IVA</div>
        <div class="valore"><input type='text' name='piva'></div>
        
        <div class="etichetta">Codice Fiscale</div>
        <div class="valore"><input type='text' name='codicefiscale'></div>
        
        <div class="etichetta">Indirizzo</div>
        <div class="valore"><input type='text' name='indirizzo'></div>
        
        <div class="etichetta">Cap</div>
        <div class="valore"><input type='text' name='cap'></div>
        
        <div class="etichetta">Comune</div>
        <div class="valore"><input type='text' name='comune'></div>
        
        <div class="etichetta">Provincia</div>
        <div class="valore"><input type='text' name='provincia'></div>
        
        <div class="etichetta">Email</div>
        <div class="valore"><input type='text' name='email'></div>
        
        <div class="etichetta">Telefono</div>
        <div class="valore"><input type='text' name='telefono'></div>
        
    
        <button class="pulsante float-right" type='button' onclick="nuovosoggetto();">Conferma</button>
        <div class='clear'></div>
                
    </form>
    
    
</div>