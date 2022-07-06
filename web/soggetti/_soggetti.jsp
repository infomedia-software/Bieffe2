
<%@page import="beans.Indirizzo"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.Soggetto"%>
<%@page import="gestioneDB.GestioneSoggetti"%>
<%@page import="utility.Utility"%>
<%
    String query=Utility.eliminaNull(request.getParameter("query"));
    ArrayList<Soggetto> lista=new ArrayList<Soggetto>();
    if(!query.equals(""))
        lista=GestioneSoggetti.getIstanza().ricerca(query);
%>
<script type='text/javascript'>
    function aggiornasoggetti(){        
        var query=encodeURIComponent(String($("#querysoggetti").val()));
        $("#soggetti").load("<%=Utility.url%>/soggetti/_soggetti.jsp?query="+query+" #soggetti_inner",nascondiloader());
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
                    aggiornasoggetti();
                },
                error: function(){
                    alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE cancellasoggetto()");
                }
            });
        }
    }
    
</script>

<input type='hidden' id='querysoggetti' value="<%=query%>" style='width: 100%'>
<div id='soggetti'>
    <div id='soggetti_inner'>
        
        <%if(lista.size()>0){%>
            <h3>Sono stati trovati <%=lista.size()%> risultati</h3>
            <table class='tabella'>
                <tr>
                    <th style='width: 55px'></th>
                    <th>Codice</th>
                    <th>Alias</th>                
                    <th>E-mail</th>
                    <th>Telefono</th>
                    <th>Indirizzo</th>                
                    <th>Comune</th>                    
                </tr>
                <%for(Soggetto s:lista){%>
                    <tr>
                        <td>
                            <a href='<%=Utility.url%>/soggetti/soggetto.jsp?id=<%=s.getId()%>' class="pulsanteimg">
                                <img src="<%=Utility.url%>/images/edit.png">
                            </a>
                        </td>
                        <td><%=s.getCodice()%></td>
                        <td><%=s.getAlias()%></td>
                        <%if(s.getIndirizzi().size()>=1){
                            Indirizzo indirizzo=s.getIndirizzi().get(0);%>
                            <td><%=indirizzo.getEmail()%></td>
                            <td><%=indirizzo.getTelefono()%></td>                            
                            <td><%=indirizzo.getIndirizzo()%></td>
                            <td><%=indirizzo.getComune()%> (<%=indirizzo.getProvincia()%>)</td>                            
                        <%}else{%>
                            <td colspan="4"></td>
                        <%}%>
                    </tr>
                <%}%>
            </table>
        <%}else{%>  
            <div class="errore">Nessun soggetto presente</div>
        <%}%>
    </div>
</div>