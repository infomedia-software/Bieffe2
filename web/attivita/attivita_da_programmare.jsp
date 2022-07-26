<%@page import="beans.Risorsa"%>
<%@page import="gestioneDB.GestioneRisorse"%>
<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="beans.Attivita"%>
<%@page import="utility.Utility"%>
<%@page import="beans.Commessa"%>
<%@page import="java.util.ArrayList"%>
<%@page import="gestioneDB.GestioneCommesse"%>

<%
    String id_commessa=Utility.eliminaNull(request.getParameter("id_commessa"));
    
    String q="(attivita.stato='1' AND "
            + "attivita.situazione="+Utility.isNull(Attivita.DAPROGRAMMARE)+" AND attivita.libero7='' ) OR "
            + "(attivita.stato='incollare' ) "
            + "ORDER BY attivita.commessa DESC, attivita.seq ASC";
    
    String commessa_attivita_taglia="";
    
    String search=Utility.eliminaNull(request.getParameter("search"));
    if(!search.equals(""))
        q=" (commesse.numero LIKE "+Utility.isNullLike(search)+" OR commesse.descrizione LIKE "+Utility.isNullLike(search)+" OR clienti.alias LIKE "+Utility.isNullLike(search)+" ) AND "+q;
    
    if(!id_commessa.equals(""))
        q=" attivita.commessa="+Utility.isNull(id_commessa)+" AND "+q;
    
    ArrayList<Attivita> attivita_da_programmare=GestionePlanning.getIstanza().ricercaAttivita(q);
%>

<html>
    <head>
        <title>Da Programmare | <%=Utility.nomeSoftware%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>

        <script type="text/javascript">
           
           function ricerca_attivita_da_programmare(){
              var search=$("#search").val();
              mostraloader("Ricerca in corso...");
              location.href="<%=Utility.url%>/attivita/attivita_da_programmare.jsp?search="+encodeURIComponent(String(search));
           }
           
           $(function(){
                $("#search").focus();                
                $("#search").keypress(function(e) {
                    if(e.which === 13) {
                        ricerca_attivita_da_programmare();
                    }
                });
            });
           
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
                    if(!confirm('Desideri reimpostare in attesa l\'attività?')){return;}                    
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
        
        
            function aggiorna_pagina(){
                var search=$("#search").val();                
                $("#div_attivita_da_programmare").load("<%=Utility.url%>/attivita/attivita_da_programmare.jsp?search="+encodeURIComponent(String(search))+" #div_attivita_da_programmare_inner",function(){
                    nascondiloader();
                    nascondipopup();
                });
            }
        </script>
        
    </head>
    <body>
    
    <jsp:include page="../_menu.jsp"></jsp:include>

    <div id="container">
        
        <h1>Attività Da Programmare</h1>
        
        <input type="text" id="search" class="float-right" placeholder="Ricerca Commessa per numero, cliente o descrizione..." value="<%=search%>" style="width: 300px">
        
        <div id="div_attivita_da_programmare">
            <div id="div_attivita_da_programmare_inner">
                <%
                if(id_commessa.equals("")){
                String id_attivita_taglia=Utility.getIstanza().getValoreByCampo("attivita", "id", "stato='taglia'");
                
                
                if(!id_attivita_taglia.equals("")){
                    Attivita attivita_taglia=GestionePlanning.getIstanza().ricercaAttivita(" attivita.id="+id_attivita_taglia).get(0);
                    commessa_attivita_taglia=attivita_taglia.getCommessa().getId();                    
                %>
                <div class="width50 float-left">
                    <h2>Attività da Incollare</h2>
                    <div class="box " >                                                
                        <div class="etichetta">Descrizione</div>
                        <div class="valore"><span><%=attivita_taglia.getDescrizione()%></span></div>

                        <div class="etichetta">Commessa</div>
                        <div class="valore"><span><%=attivita_taglia.getCommessa().getNumero()%> <%=attivita_taglia.getCommessa().getDescrizione()%></span></div> 

                        <div class="etichetta">Cliente</div>
                        <div class="valore"><span><%=attivita_taglia.getCommessa().getSoggetto().getAlias()%></span></div>

                        <div class="etichetta">Fase</div>
                        <div class="valore"><span><%=attivita_taglia.getFase_input().getNome()%></span></div>
                        
                        <div class="etichetta">Durata</div>
                        <div class="valore"><span><%=Utility.elimina_zero(attivita_taglia.getDurata())%> h</span></div>
                        
                        <div class="etichetta">Sequenza</div>
                        <div class="valore"><span><%=Utility.elimina_zero(attivita_taglia.getSeq())%></span></div>

                        <button class='pulsante float-right' onclick="modifica_attivita('<%=id_attivita_taglia%>',this)" value='1' id='stato'><img src="<%=Utility.url%>/images/delete.png">Imposta a Da Programmare</button>
                    </div>
                </div>
                <div class="height10"></div>
                <%}%>
            <%}%>
        

        <div class="box">
            
            
                    <%
                    if(attivita_da_programmare.size()==0){%>
                       <div class="messaggio">Nessuna attività da programmare</div>
                       
                    <%}
                    else
                    {
                    %>        
                        <table class="tabella">
                            <tr>
                                <th></th>                                
                                <th>Descrizione</th>
                                <th>Durata</th>
                                <th>Seq</th>
                                <th>Scost</th>
                                <th>Risorsa</th>
                                <th style="width: 250px">Note</th>
                                <th colspan="2"></th>
                            </tr>
                                <%
                                double seq_prec=0;
                                String commessa="";
                                for(Attivita a:attivita_da_programmare){%>
                                    <%if(!a.getCommessa().getNumero().equals(commessa)){%>
                                    <tr>
                                         <td colspan='9' style='background-color: lightgray;padding: 5px;'>
                                            <div class="tag float-left" style="background-color:<%=a.getCommessa().getColore()%>;margin-right: 10px;" >                                    
                                                <%=a.getCommessa().getNumero()%>
                                            </div>                                                                         
                                                <a href="<%=Utility.url%>/commesse/commessa.jsp?id=<%=a.getCommessa().getId()%>" style="font-weight: bold;font-size:14px"><%=a.getCommessa().getDescrizione()%></a> - 
                                                <a href="<%=Utility.url%>/soggetti/soggetto.jsp?id=<%=a.getCommessa().getSoggetto().getId()%>" style="font-weight: bold;font-size:14px"><%=a.getCommessa().getSoggetto().getAlias()%></a>
                                            <br>
                                            <%=a.getCommessa().getNote()%>                                            
                                            <%if(a.getCommessa().getData_consegna()!=null){%>
                                                Data Consegna: <%=Utility.convertiDatetimeFormatoIT(a.getCommessa().getData_consegna()).substring(0,10)%>
                                            <%}%>
                                        </td>
                                    </tr>
                                    <%}%>
                                    <tr>
                                        <td>
                                            <a class="pulsantesmall" href="<%=Utility.url%>/attivita/_attivita.jsp?id=<%=a.getId()%>"><img src="<%=Utility.url%>/images/edit.png"></a>
                                        </td>                                                                               
                                        <td>
                                            <%=a.getDescrizione()%> 
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
                                        <td>
                                            <%if(!a.getCommessa().getNumero().equals(commessa_attivita_taglia) && ((commessa.equals(a.getCommessa().getNumero()) && ((int)a.getSeq())>=((int)(seq_prec+1))) || (commessa.equals("") || !commessa.equals(a.getCommessa().getNumero())) || a.getSeq()==0)){%>
                                                <button class="pulsante_tabella planning" onclick="mostrapopup('<%=Utility.url%>/attivita/_programma_attivita.jsp?id_attivita=<%=a.getId()%>')">
                                                    <img src="<%=Utility.url%>/images/planning.png"> Programma
                                                </button>
                                            <%}
                                            seq_prec=a.getSeq();
                                            commessa=a.getCommessa().getNumero();
                                            %>
                                        </td>
                                        <td>
                                            <button class="pulsante_tabella float-left red" id="situazione" value="" onclick="modifica_attivita('<%=a.getId()%>',this)">
                                                <img src="<%=Utility.url%>/images/delete.png"> Rimuovi
                                            </button>
                                        </td>
                                    </tr>
                                <%}%>
                        </table>
                        <%}%>

            </div>
        </div>
    </div>
    </body>
</html>