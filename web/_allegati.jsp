<%@page import="beans.Utente"%>
<%@page import="beans.Allegato"%>
<%@page import="java.util.ArrayList"%>
<%@page import="gestioneDB.GestioneAllegati"%> 
<%@page import="utility.Utility"%>
<%
    Utente utente=(Utente)session.getAttribute("utente");
    String query=Utility.eliminaNull(request.getParameter("query"));
    ArrayList<Allegato> allegati=GestioneAllegati.getIstanza().ricercaAllegati(query);
%>

<script type='text/javascript'>
    
    function aggiornaallegati(){                
        var queryallegati=$("#queryallegati").val();                    
        $("#allegati").load("<%=Utility.url%>/_allegati.jsp?query="+encodeURIComponent(String(queryallegati))+" #allegati_inner",function(){nascondiloader();});
    }
    
    function cancellaallegato(idallegato){
        if(confirm("Procedere alla cancellazione dell'allegato?")){            
            var query="UPDATE allegati SET stato='-1' WHERE id="+idallegato;
            mostraloader("Cancellazione in corso...");
            $.ajax({
                type: "POST",
                url: "<%=Utility.url%>/__query.jsp",
                data: "query="+query,
                dataType: "html",
                success: function(msg){
                    aggiornaallegati();
                    
                },
                error: function(){
                    alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE cancellaallegato()");
                }
            });           
        }
    }
</script>

<input type='hidden' id='queryallegati' value="<%=query%>">

<div class="box">

    <div id='allegati'>
        <div id='allegati_inner'>        

            <%if(allegati.size()==0){%>
                <div class="messaggio">
                    Nessun allegato presente                
                </div>
            <%}else{%>
                <table class="tabella">
                    <tr>  
                        <th style="max-width: 35px"></th>
                        <th>File</th>
                        <th>Data</th>
                        <th style="width: 45px"></th>
                    </tr>
                    <%for(Allegato allegato:allegati){%>
                        <tr>                
                            <td>
                                <a href='<%=Utility.url%>/allegati/<%=allegato.getUrl()%>' class="pulsantesmall" target="_blank">                        
                                    <img src="<%=Utility.url%>/images/link.png" alt="edit">
                                </a>
                            </td>
                            <td>
                                <a href='<%=Utility.url%>/allegati/<%=allegato.getUrl()%>' target="_blank">                        
                                    <%=allegato.getUrl()%>
                                </a>
                            </td>                        
                            <td>
                                <%=Utility.convertiDatetimeFormatoIT(allegato.getData())%>
                            </td>
                            <td>
                                <%if(!utente.getPrivilegi().equals("operaio")){%> 
                                    <a href='#' class="pulsantesmall delete" onclick="cancellaallegato('<%=allegato.getId()%>');">                        
                                        <img src="<%=Utility.url%>/images/delete.png" alt="edit">
                                    </a>
                                <%}%>
                            </td>
                        </tr>
                    <%}%>
                </table>
            <%}%>
        </div>
    </div>
</div>