<%@page import="beans.Risorsa"%>
<%@page import="gestioneDB.GestioneRisorse"%>
<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="beans.Attivita"%>
<%@page import="utility.Utility"%>
<%@page import="beans.Commessa"%>
<%@page import="java.util.ArrayList"%>
<%@page import="gestioneDB.GestioneCommesse"%>

<%
    String id_attivita=Utility.eliminaNull(request.getParameter("id_attivita"));
    String id_commessa=Utility.eliminaNull(request.getParameter("id_commessa"));
    String query="(attivita.commessa="+Utility.isNull(id_commessa)+"  AND (attivita.stato='1' OR attivita.stato='taglia' )AND attivita.libero7='' ) AND attivita.situazione!='' ORDER BY attivita.seq ASC";            
    ArrayList<Attivita> attivita_commessa=GestionePlanning.getIstanza().ricercaAttivita(query);
    
    String prima_data_planning=Utility.getIstanza().querySelect("SELECT min(inizio) as prima_data_planning FROM planning WHERE 1 ORDER BY inizio DESC LIMIT 0,1", "prima_data_planning");
    
    Commessa commessa=GestioneCommesse.getIstanza().get_commessa(id_commessa);
%>

<html>
    <head>
        <title>Da Programmare | <%=Utility.nomeSoftware%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>

        <script type="text/javascript">
           
            function seleziona_commessa_da_programmare(){
                var commessa_da_programmare=$("#commessa_da_programmare").val();
                if(commessa_da_programmare!==""){
                    mostraloader("Ricerca delle attività da programmare...");
                    $("#div_attivita_da_programmare").load("<%=Utility.url%>/attivita/_daprogrammare.jsp?commessa_da_programmare="+commessa_da_programmare+" #div_attivita_da_programmare_inner",function(){nascondiloader();});
                }
            }


            function modifica_attivita(id_attivita,inField){                       
                var newvalore=inField.value;
                var campodamodificare=inField.id;
                if(campodamodificare==="situazione"){
                    if(!confirm('Desideri rimuovere dal planning l\'attività?')){return;}
                }
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/attivita/__modificaattivita.jsp",
                    data: "newvalore="+encodeURIComponent(String(newvalore))+"&campodamodificare="+campodamodificare+"&idattivita="+id_attivita,
                    dataType: "html",
                    success: function(msg){
                        if(campodamodificare==="situazione" || campodamodificare==="stato")
                            location.reload();
                    },
                    error: function(){
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE modifica_attivita()");
                    }
                });
            }
            
            function aggiornaplanning(){
                location.reload();
            }
            function aggiorna_pagina(){
                location.reload();
            }
        
        </script>
        
    </head>
    <body>
    
    <jsp:include page="../_menu.jsp"></jsp:include>

    <div id="container">
        
        <h1>
            <button class="pulsantesmall" type="button" onclick="location.href='<%=request.getHeader("referer")%>'"><img src="<%=Utility.url%>/images/back.png"></button>
            <div class="tag " style="background-color:<%=commessa.getColore()%>">
                <%=commessa.getNumero()%></div> 
            <%=commessa.getSoggetto().getAlias()%> - <%=Utility.standardizzaStringaPerTextArea(commessa.getDescrizione())%>
    </h1>     
        
        <div class="box">
            <div class="etichetta">Commessa</div>
            <div class="valore"><span><div class="ball" style="background-color:<%=commessa.getColore()%>"></div> <%=commessa.getNumero()%> <%=commessa.getDescrizione()%></span></div>

            <div class="etichetta">Cliente</div>
            <div class="valore"><span><%=commessa.getSoggetto().getAlias()%></span></div>
            
            <div class="etichetta">Q.tà</div>
            <div class="valore"><span><%=commessa.getNote()%></span></div>
            
            <%if(commessa.getData_consegna()!=null){%>
                <div class="etichetta">Data Consegna</div>
                <div class="valore"><span><%=commessa.getData_consegna_it()%></span></div>
            <%}%>
        </div>
        
        <div id="div_attivita_da_programmare">
            <div id="div_attivita_da_programmare_inner">
            
            <div class="box">
                    <%
                    if(attivita_commessa.size()==0){%>
                       <div class="messaggio">Nessuna attività presente</div>
                       
                    <%}
                    else
                    {
                    %>        
                        <table class="tabella">
                            <tr>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th></th>
                                <th>Descrizione</th>
                                <th style="width: 120px">Inizio</th>
                                <th style="width: 120px">Fine</th>
                                <th>Durata</th>
                                <th>Seq</th>
                                <th>Scost</th>
                                <th>Risorsa</th>                                
                                <th style="width: 200px">Note</th>                                
                                <th>Situazione</th>
                                <th></th>
                                <th colspan="3"></th>
                            </tr>
                                <%
                                double seq_prec=0;                                
                                for(Attivita a:attivita_commessa){%>
                                    <tr >
                                        <td>
                                            <a class="pulsante_tabella" title="ID Attività: <%=a.getId()%>" href="<%=Utility.url%>/attivita/_attivita.jsp?id=<%=a.getId()%>">
                                            <%if(id_attivita.equals(a.getId())){%>
                                                <img src="<%=Utility.url%>/images/v.png">
                                            <%}else{%>
                                                <img src="<%=Utility.url%>/images/edit.png">
                                            <%}%>
                                            Dettagli
                                            </a>                                                                                                                                       
                                        </td>   
                                        <td>
                                            <%if(!Utility.viene_prima(a.getInizio(), prima_data_planning)){%>                                         
                                                <%if(a.is_in_programmazione() || (commessa.equals(a.getCommessa().getId()) && ((int)a.getSeq())>=((int)(seq_prec+1))) || (commessa.equals("") || !commessa.equals(a.getCommessa().getId())) || a.getSeq()==0){%>
                                                    <button class="pulsante_tabella" onclick="mostrapopup('<%=Utility.url%>/attivita/_programma_attivita.jsp?id_attivita=<%=a.getId()%>')">
                                                        <img src="<%=Utility.url%>/images/planning.png"> Programma
                                                    </button>
                                                <%}
                                            }
                                            seq_prec=a.getSeq();                                            
                                            %>
                                        </td>      
                                        <td>
                                            <%if(a.is_in_programmazione()){%>                                                
                                                <a class="pulsante_tabella float-left planning " href="<%=Utility.url%>/planning/planning.jsp?data=<%=a.getInizioData()%>">
                                                    <img src="<%=Utility.url%>/images/planning.png"> Planning
                                                </a>                                                
                                            <%}%>
                                        </td>
                                        <td>
                                            <%if(a.is_completata()){%> 
                                                <div class="pulsante_tabella green pointer-events-none">Completata</div>
                                            <%}%> 
                                        </td>
                                        <td>                                            
                                            <%=a.getDescrizione()%> 
                                        </td>
                                        <td>
                                            <%=a.getInizio_it()%>
                                        </td>
                                        <td>
                                            <%=a.getFine_it()%>
                                        </td>
                                        <td>
                                            <div class="tagsmall"><%=Utility.elimina_zero(a.getDurata())%> h</div>
                                        </td>
                                        <td>
                                            <%if(a.getSeq()>0){%>
                                                <div class="tagsmall"><%=Utility.elimina_zero(a.getSeq())%></div>
                                            <%}%>
                                        </td>
                                        <td>
                                            <%if(a.getScostamento()!=0){%>
                                                <div class="tagsmall"><%=Utility.elimina_zero(a.getScostamento())%> h</div>
                                            <%}%>
                                        </td>
                                        <td>
                                            <%=a.getRisorsa().getCodice()%> <%=a.getRisorsa().getNome()%>
                                        </td>                               
                                        <td>
                                            <textarea id="note" onchange="modifica_attivita('<%=a.getId()%>',this)" style="height: 40px"><%=Utility.standardizzaStringaPerTextArea(a.getNote())%></textarea>                                    
                                        </td>
                                        <td style='width: 140px'>
                                            <%if(a.is_in_programmazione()){%>
                                                <div class="tag in_programmazione">In Programmazione</div>
                                            <%}%>
                                            <%if(a.is_da_programmare()){%>
                                                <div class="tag da_programmare">Da Programmare</div>
                                            <%}%>
                                        </td>                                                                                                             
                                        <td>
                                            <%if(!Utility.viene_prima(a.getInizio(), prima_data_planning)){%>                                         
                                                <button class="pulsante_tabella float-left red" onclick="function_non_programmare(<%=a.getId()%>);">
                                                    <img src="<%=Utility.url%>/images/delete.png"> Rimuovi
                                                </button>
                                            <%}%>
                                        </td>
                                    </tr>
                                <%}%>
                        </table>
                        <%}%>

                </div>
            </div>
        </div>
    </div>
    </body>
</html>