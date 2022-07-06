<%@page import="beans.Risorsa"%>
<%@page import="java.util.ArrayList"%>
<%@page import="gestioneDB.GestioneRisorse"%>
<%@page import="utility.Utility"%>
<%
    String queryrisorse=Utility.eliminaNull(request.getParameter("queryrisorse"));
    ArrayList<Risorsa> risorse=new ArrayList<Risorsa>();
    if(!queryrisorse.equals(""))
        risorse=GestioneRisorse.getIstanza().ricercaRisorse(queryrisorse);
%>

<script type='text/javascript'>
    function cancellarisorsa(id){
        if(confirm('Procedere alla cancellazione della risorsa')){
            var newvalore="-1";
            var campodamodificare="stato";
            mostraloader("Aggiornamento in corso...");
            $.ajax({
                type: "POST",
                url: "<%=Utility.url%>/risorse/__modificarisorsa.jsp",
                data: "newvalore="+encodeURIComponent(String(newvalore))+"&campodamodificare="+campodamodificare+"&id="+id,
                dataType: "html",
                success: function(msg){
                    aggiornarisorse();
                },
                error: function(){
                    alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE modificarisorsa()");
                }
            });		
        }
    }
    
    function aggiornarisorse(){        
        mostraloader("Aggiornamento risorse in corso...");        
        $("#risorse").load("<%=Utility.url%>/risorse/risorse.jsp #risorse_inner",function(){nascondiloader();});
    }
    
    function ordinamentorisorsa(risorsa,spostamento){        
        $.ajax({
            type: "POST",
            url: "<%=Utility.url%>/risorse/__ordinamentorisorsa.jsp",
            data: "risorsa="+risorsa+"&spostamento="+spostamento,
            dataType: "html",
            success: function(msg){
                aggiornarisorse();
            },
            error: function(){
                alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE ordinamentorisorsa");
            }
        });

    }
    
</script>

<div id="risorse">
    <div id="risorse_inner">

        <table class="tabella">
            <tr>
                <th style="width: 35px;"></th>                        
                <th>Codice</th>
                <th>Nome</th>
                <th>Fase</th>
                <th>Note</th>                                       
                <th style="width: 125px"></th>                                       
            </tr>
            <%
            String prev_fase="";
            String next_fase="";
            for(int i=0;i<risorse.size();i++){             
                Risorsa risorsa=risorse.get(i);
                if(i>0){
                    prev_fase=risorse.get(i-1).getFase().getId();
                }
                if(i<risorse.size()-1){
                    next_fase=risorse.get(i+1).getFase().getId();
                }
            %>
            <tr>               
                <td>
                    <a href="<%=Utility.url%>/risorse/risorsa.jsp?id=<%=risorsa.getId()%>" class="pulsantesmall" target="_blank">
                        <img src="<%=Utility.url%>/images/edit.png">
                    </a>
                </td>                
                <td>
                    <%=risorsa.getCodice()%>                    
                </td>
                <td><%=risorsa.getNome()%></td>
                <td><%=risorsa.getFase().getNome()%></td>                
                <td><%=risorsa.getNote()%></td>               
                <td>         
                    <div class="tagsmall float-left"><%=risorsa.getOrdinamento()%></div>
                    <%if(i>0 && prev_fase.equals(risorsa.getFase().getId())){%>
                        <button class="pulsantesmall float-left" onclick="ordinamentorisorsa('<%=risorsa.getId()%>','sx');"><img src="<%=Utility.url%>/images/up.png"></button>
                    <%}%>
                    <%if(i<risorse.size()-1 && next_fase.equals(risorsa.getFase().getId())){%>
                        <button class="pulsantesmall float-right" onclick="ordinamentorisorsa('<%=risorsa.getId()%>','dx');"><img src="<%=Utility.url%>/images/down.png"></button>
                    <%}%>                    
                </td>                             
            </tr>
            <%                
            }%>    
        </table>
        
    </div>
</div>