<%@page import="beans.Precedenza"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.Attivita"%>
<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="utility.Utility"%>
<%
    String idattivita=Utility.eliminaNull(request.getParameter("idattivita"));
    Attivita attivita=GestionePlanning.getIstanza().ricercaAttivita(" attivita.id="+idattivita+" AND attivita.stato='1' ").get(0);
    
    
    ArrayList<Precedenza> listaprecedenti=GestionePlanning.getIstanza().ricercaPrecedenti(" "
            + "precedenze.attivita="+idattivita+" AND attivita.stato='1' AND precedenze.stato='1' ORDER BY attivita.inizio ASC");
    ArrayList<Attivita> listaattivita=GestionePlanning.getIstanza().ricercaAttivita( " "
            + "attivita.id!="+idattivita+" AND attivita.commessa="+Utility.isNull(attivita.getCommessa().getId())+" AND attivita.stato='1' ORDER BY attivita.inizio ASC");
%>

<script type='text/javascript'>
    function nuovaprecedenza(precedente){
        var scostamento=prompt("Inserire l'eventuale scostamento massimo consentito.\N.B. Lasciare vuoto se uguale a 0");
        if(scostamento==="")
            scostamento="0";
        if(scostamento!=="" && scostamento!==null && validazione_durata(scostamento)===true){
            
            $.ajax({
                type: "POST",
                url: "<%=Utility.url%>/attivita/__nuovaprecedenza.jsp",
                data: "attivita=<%=idattivita%>&precedente="+precedente+"&scostamento="+scostamento,
                dataType: "html",
                success: function(msg){
                    aggiornaprecedenze()
                },
                error: function(){
                    alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE nuovaprecedenza()");
                }
            });		
        }else{
            alert("Il valore inserito relativo allo scostamento non è corretto.");
            return;
        }
    }
    
    function cancellaprecedenza(idprecedenza){
        if(confirm("Procedere alla cancellazione della precedenza")){
            $.ajax({
                type: "POST",
                url: "<%=Utility.url%>/attivita/__modificaprecedenza.jsp",
                data: "newvalore=-1&campodamodificare=stato&id="+idprecedenza,
                dataType: "html",
                success: function(msg){
                    aggiornaprecedenze();
                },
                error: function(){
                    alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE cancellaprecedenza()");
                }
            });
        }
    }
    
    function aggiornaprecedenze(){
        mostraloader("Aggiornamento delle precedenze...");
        $("#div_precedenze").load("<%=Utility.url%>/attivita/_precedenze.jsp?idattivita=<%=idattivita%> #div_precedenze_inner",function(){nascondiloader();});
    }
</script>

<div class="etichetta">Inizio</div>
<div class="valore">
    <input type="text" value="<%=Utility.convertiDatetimeFormatoIT(attivita.getInizio())%>" readonly="true" tabindex="-1">
</div>

<div id="div_precedenze">
    <div id="div_precedenze_inner">
        
        <h2>Attività Precedenti all'Attività selezionati</h2>
        
        <%if(listaprecedenti.size()>0){%>
            <table class="tabella">
                <tr>
                    <th>Descrizione</th>
                    <th>Inizio</th>
                    <th>Fine</th>
                    <th>Scostamento</th>
                    <th>Fine + Scostamento</th>
                    <th></th>
                    <th></th>
                </tr>
                <%for(Precedenza p:listaprecedenti){
                    Attivita precedente=p.getPrecedente();                
                    ArrayList<String> dd=Utility.standardizzaDurata(p.getScostamento()+"");
                    int ore=Utility.convertiStringaInInt(dd.get(0));
                    int minuti=Utility.convertiStringaInInt(dd.get(1));
                    String fineattivita=Utility.aggiungiOre(precedente.getFine(), ore, minuti);
                %>
                    <tr>
                        <td>[ID: <%=precedente.getId()%>] <%=precedente.getDescrizione()%></td>
                        <td><%=Utility.convertiDatetimeFormatoIT(precedente.getInizio())%></td>
                        <td>
                            <%=Utility.convertiDatetimeFormatoIT(precedente.getFine())%>
                        </td>
                        <td>
                            <div class="tag"><%=p.getScostamento()%> h</div>
                        </td>
                        <td>
                            <%=Utility.convertiDatetimeFormatoIT(fineattivita)%>
                        </td>
                        
                        <td>
                            <%if(Utility.confrontaTimestamp(fineattivita, attivita.getInizio())>0){%>
                                <div class="tag red">ERRORE</div>
                            <%}%>
                        </td>
                        <td>
                            <button class="pulsantesmall red" onclick="cancellaprecedenza('<%=p.getId()%>');">
                                <img src="<%=Utility.url%>/images/delete.png">
                            </button>
                        </td>
                    </tr>
                <%}%>
            </table>
        <%}else{%>
            Nessuna precedenza impostata.
        <%}%>

        <div class='height10'></div>

        <h2>Elenco Attività della Commessa <%=attivita.getCommessa().getNumero()%></h2>
        <table class="tabella">
            <tr>
                <th>Descrizione</th>
                <th>Inizio</th>
                <th>Fine</th>
                <th>Durata</th>        
                <th></th>        
            </tr>    
            <%for(Attivita a:listaattivita){%>
                <tr>
                    <td>[ID: <%=a.getId()%>] <%=a.getDescrizione()%></td>
                    <td><%=Utility.convertiDatetimeFormatoIT(a.getInizio())%></td>
                    <td><%=Utility.convertiDatetimeFormatoIT(a.getFine())%></td>
                    <td>
                        <div class="tag"><%=a.getDurata()%> h</div>
                    </td>
                    <td>
                        <button class="pulsante" onclick="nuovaprecedenza('<%=a.getId()%>')">Aggiungi Precedenza</button>
                    </td>                             
                </tr>
            <%}%>
        </table>
    </div>
</div>