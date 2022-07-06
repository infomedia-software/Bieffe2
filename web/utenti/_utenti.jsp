<%@page import="beans.Soggetto"%>
<%@page import="gestioneDB.GestioneSoggetti"%>
<%@page import="beans.Utente"%>
<%@page import="java.util.ArrayList"%>
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
</script>

<input type='hidden' id='querysoggetti' value="<%=query%>" style='width: 100%'>
<div id='soggetti'>
    <div id='soggetti_inner'>
        <table class='tabella'>
            <tr>
                <th style="width: 40px;"></th>
                <th>Cognome</th>
                <th>Nome</th>                
                <th style="width: 40px;"></th>
            </tr>
            <%for(Soggetto s:lista){%>
                <tr>
                    <td>
                        <a href='<%=Utility.url%>/utenti/utente.jsp?id=<%=s.getId()%>' class="pulsanteimg">
                            <img src="<%=Utility.url%>/images/edit.png">
                        </a>
                    </td>
                    <td><%=s.getCognome()%></td>
                    <td><%=s.getNome()%></td>                    
                    <td>
                        <button class="pulsanteimg delete" onclick="cancellautente('<%=s.getId()%>');">
                            <img src="<%=Utility.url%>/images/delete.png">
                        </button>
                    </td>
                </tr>
            <%}%>
        </table>
    </div>
</div>