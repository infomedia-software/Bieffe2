<%@page import="gestioneDB.DBConnection_External_DB"%>
<%@page import="gestioneDB.GestioneSincronizzazione"%>
<%@page import="beans.Utente"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.Attivita"%>
<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="beans.Soggetto"%>
<%@page import="gestioneDB.GestioneSoggetti"%>
<%@page import="beans.Commessa"%>
<%@page import="gestioneDB.GestioneCommesse"%>
<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    Utente u=(Utente)session.getAttribute("utente");
    String id=Utility.eliminaNull(request.getParameter("id"));
    Commessa commessa=GestioneCommesse.getIstanza().ricerca(" commesse.id="+Utility.isNull(id)).get(0);
    
    Soggetto cliente=commessa.getSoggetto();
    if(cliente.getAlias().equals("") && !Utility.url.contains("localhost")){
        GestioneSincronizzazione.getIstanza().sincronizza_clienti(" cu.cu_code="+Utility.isNull(commessa.getSoggetto().getCodice()));
        commessa=GestioneCommesse.getIstanza().ricerca(" commesse.id="+Utility.isNull(id)).get(0);
    }
    
    // Elimina le attività con durata pari a 0
    // possono essere create quando crei una nuova attività a mano ma chiudi la scheda con il popup prima di salvare
    Utility.getIstanza().query("UPDATE attivita SET stato='-1' WHERE commessa="+Utility.isNull(commessa.getId())+" AND ore=0 AND minuti=0 AND id_ordine_fornitore='' AND stato='1'");
    
    ArrayList<Attivita> programmate_da_programmare=GestionePlanning.getIstanza().ricercaAttivita(" "
            + "attivita.commessa="+Utility.isNull(id)+" AND "
            + "attivita.situazione!="+Utility.isNull("")+" AND "
            + "attivita.stato='1' ORDER BY attivita.seq ASC");
  
    
    String data_conclusione=Utility.getIstanza().getValoreByCampo("attivita", "fine", " commessa="+Utility.isNull(id)+" AND situazione="+Utility.isNull(Attivita.INPROGRAMMAZIONE)+" AND stato='1' ORDER BY fine DESC LIMIT 0,1");
  
    ArrayList<Soggetto> clienti=GestioneSoggetti.getIstanza().clienti();

%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Commessa <%=commessa.getNumero()%>/<%=commessa.getAnno()%> | <%=Utility.nomeSoftware%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
        <script type='text/javascript'>
    

            function modificacommessa(inField){                
                var newvalore=inField.value;
                var campodamodificare=inField.id;       
                if(campodamodificare==="consegnata" || campodamodificare==="fsc" || campodamodificare==="pefc"){
                    var temp=$("#"+campodamodificare).is(':checked');
                    newvalore="";
                    if(temp===true){
                        newvalore="si";                       
                    }
                }                
                //alert(campodamodificare+">"+newvalore);
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/commesse/__modificacommessa.jsp",
                    data: "newvalore="+encodeURIComponent(String(newvalore))+"&campodamodificare="+campodamodificare+"&id=<%=id%>",
                    dataType: "html",
                    success: function(msg){
                        if(campodamodificare==="scadenza")
                            location.reload();
                    },
                    error: function(){
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE modificacommessa()");
                    }
                });
            }
            
            
            function cancella_commessa(id_commessa){
                <%if(programmate_da_programmare.size()>0){%>
                    alert("Impossibile cancellare la commessa poichè sono presenti delle attività in attesa e/o programmate.");
                <%}else{%>
                    if(confirm("Procedere alla cancellazione della commessa?")){
                        mostraloader("Operazione in corso...");
                        $.ajax({
                            type: "POST",
                            url: "<%=Utility.url%>/commesse/__cancella_commessa.jsp",
                            data: "id_commessa="+id_commessa,
                            dataType: "html",
                            success: function(msg){
                                location.href='<%=Utility.url%>/commesse/commesse.jsp';
                            },
                            error: function(){
                                alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE cancella_commessa");
                            }
                        });
                    }
                <%}%>
            }
            
            function modifica_attivita(id_attivita,inField){                       
                var newvalore=inField.value;
                var campodamodificare=inField.id;
                if(campodamodificare==="situazione"){
                    if(!confirm('Desideri reimpostare in attesa l\'attività?')){return;}
                    else{mostraloader("");}
                }
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/attivita/__modificaattivita.jsp",
                    data: "newvalore="+encodeURIComponent(String(newvalore))+"&campodamodificare="+campodamodificare+"&idattivita="+id_attivita,
                    dataType: "html",
                    success: function(msg){
                        aggiorna_attivita();
                    },
                    error: function(){
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE modifica_attivita()");
                    }
                });
            }
            
            
            function mostra_nuovo_ordine_fornitore(){
                var id_attivita = $('.checkbox_attivita:checked').map(function() {return this.value;}).get();                
                mostrapopup('<%=Utility.url%>/ordini_fornitore/_nuovo_ordine_fornitore.jsp?id_commessa=<%=id%>&id_attivita='+id_attivita,'Nuovo Ordine Fornitore');
            }
          
            function cancella_attivita(id_attivita){                
                if(confirm("Procedere alla cancellazione dell'attività?N.B. Non sarà possibile ripristinare un'attività cancellata.")){
                    $.ajax({
                        type: "POST",
                        url: "<%=Utility.url%>/attivita/__cancella_attivita.jsp",
                        data: "id_attivita="+id_attivita,
                        dataType: "html",
                        success: function(msg){
                            aggiorna_attivita();
                        },
                        error: function(){
                            alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE");
                        }
                    });
		}
            }
              
            function aggiorna_attivita(){                            
                $("#div_attivita").load("<%=Utility.url%>/commesse/commessa.jsp?id=<%=id%> #div_attivita_inner",function(){nascondiloader();function_nascondipopup();});
            }

        </script>
    </head>
    <body>
        
        <jsp:include page="../_menu.jsp"></jsp:include>
        
        
        <div id='container'>
            
            <h1>
                <button class="pulsantesmall" type="button" onclick="location.href='<%=request.getHeader("referer")%>'"><img src="<%=Utility.url%>/images/back.png"></button>
                <div class="tag" style="background-color:<%=commessa.getColore()%>"><%=commessa.getNumero()%></div> <%=commessa.getSoggetto().getAlias()%> - <%=commessa.getDescrizione()%>
            </h1>
                
            

            <%if(!u.getPrivilegi().equals("reparto")){%>
                <div class="box">
                    <button class="pulsante " onclick="mostrapopup('<%=Utility.url%>/attivita/_da_programmare.jsp?id_commessa=<%=id%>','Nuova Attività')">
                        <img src="<%=Utility.url%>/images/add.png">
                        Nuova Attività
                    </button>            
                    
                    <a href='<%=Utility.url%>/commesse/_sincronizza_commesse.jsp?id_commessa=<%=id%>' class="pulsante"><img src="<%=Utility.url%>/images/sincro.png">Sincronizza Commessa</a>
                    
                    <button class="pulsante float-right delete" onclick="cancella_commessa('<%=id%>')">
                        <img src="<%=Utility.url%>/images/delete.png">
                        Cancella
                    </button>
                </div>
                <div class="clear"></div>
            <%}%>
           
          
          
            <div class="height10"></div>
            
            <%if(!u.is_reparto()){%>
                <div class='tabs'>                
                    <div class='tab' id="tabdettagli" onclick="mostratab('dettagli');">Dettagli</div>                                
                    <div class='tab tab2' id="tabattivita" onclick="mostratab('attivita');">Attività</div>                                                    
                </div>
            <%}%>
            
            <!-- DETTAGLI -->
            <div class="scheda <%if(u.getPrivilegi().equals("reparto")){%> pointer-events-none <%}else{%> displaynone <%}%>" id='schedadettagli' >
                
                <div class="width50 float-left">
                
                <div class="box">
                    <div class="etichetta">Colore</div>
                    <div class="valore">
                        <input type="color" id="colore" name="colore" value="<%=commessa.getColore()%>" onchange="modificacommessa(this);">
                    </div>

                    <div class="etichetta" >Situazione </div>
                    <div class="valore">
                        <select id="situazione" onchange="modificacommessa(this);" style="width:125px">
                            <option value="">Seleziona lo stato</option>
                            <option value="daprogrammare" <%if(commessa.getSituazione().equals("daprogrammare")){%>selected="true"<%}%> >Da Programmare</option>                            
                            <option value="programmata" <%if(commessa.getSituazione().equals("programmata")){%>selected="true"<%}%>>Programmata</option>
                            <option value="conclusa" <%if(commessa.getSituazione().equals("conclusa")){%>selected="true"<%}%>>Conclusa</option>
                        </select>
                    </div>
                        
                    <div class="etichetta">Consegnata</div>
                    <div class="valore">
                        <input type="checkbox" id='consegnata' value='si' onchange="modificacommessa(this)" <%if(commessa.getConsegnata().equals("si")){%>checked="true"<%}%> >
                    </div>
                    
                    
                    <div id='soggetti'>
                         <div id='soggetti_inner'>
                             <div class="etichetta">Cliente</div>
                             <div class="valore">
                                 <select id="soggetto" onchange="modificacommessa(this);" >
                                     <%for(Soggetto c:clienti){%>
                                         <option value="<%=c.getId()%>" <%if(c.getId().equals(commessa.getSoggetto().getId())){%> selected="true" <%}%> ><%=c.getAlias()%></option>                                        
                                     <%}%>
                                 </select>
                             </div>
                         </div>
                     </div>

                    <div style='pointer-events: none'>
                        
                        
                        
                        <div class='etichetta'>Numero</div>
                        <div class='valore'>
                            <input type='text' id='numero' style="width:75px" value="<%=commessa.getNumero()%>" onchange="modificacommessa(this);"> 
                        </div>
                          
                    </div>
                        
                        
                        <div class="etichetta">Descrizione</div>
                        <div class="valore">
                            <textarea id="descrizione" onchange="modificacommessa(this);"><%=Utility.standardizzaStringaPerTextArea(commessa.getDescrizione())%></textarea>
                        </div>
                        
                        <div class="etichetta">Qtà</div>
                        <div class="valore">
                            <input id="qta" type="number" onchange="modificacommessa(this);" value="<%=Utility.elimina_zero(commessa.getQta())%>">
                        </div>
          
                        
                        <div class="etichetta">Dettagli</div>
                        <div class="valore">
                            <textarea id="dettagli" style="height: 250px;" onchange="modificacommessa(this);"><%=Utility.standardizzaStringaPerTextArea(commessa.getDettagli())%></textarea>
                        </div>
                        
                     
                    </div>                                                
                </div>
                <div class="width50 float-left">
                    
                    <div class="box">
                        
                        <div class="etichetta">Data Consegna</div>
                        <div class="valore">
                            <input type='datetime-local' id="data_consegna" value='<%=commessa.getData_consegna()%>'  onchange="modificacommessa(this);" >
                        </div>
                        
                        <div class="etichetta">Note</div>
                        <div class="valore">
                            <textarea id="note" style="height: 250px;" onchange="modificacommessa(this);"><%=Utility.standardizzaStringaPerTextArea(commessa.getNote())%></textarea>
                        </div>
                    </div>
                    
                    <div class="box">                        
                        <jsp:include page="../_nuovoallegato.jsp">
                            <jsp:param name="idrif" value="<%=id%>"></jsp:param>
                            <jsp:param name="rif" value="COMMESSA"></jsp:param>
                        </jsp:include>


                        <%
                        String queryallegati=" allegati.rif='COMMESSA' AND allegati.idrif="+Utility.isNull(id)+" AND allegati.stato='1' ORDER BY allegati.id DESC";
                        %>
                        <jsp:include page="../_allegati.jsp">
                            <jsp:param name="query" value="<%=queryallegati%>"></jsp:param>
                        </jsp:include>
                    </div>
                </div>
                        
                <div class="clear"></div>                                
            </div>
                    
         
                
            <div class="scheda <% if(!u.getPrivilegi().equals("amministratore")){%>pointer-events-none<%}%> <%if(u.getPrivilegi().equals("reparto")){%> displaynone <%}else{%> <%}%>" id="schedaattivita">

              
            <div id="div_attivita">
                <div id="div_attivita_inner">
                    
                    <div class="box">
                    <h2>Attività Programmate / Da Programmare</h2>                                       
                    <%if(programmate_da_programmare.size()>0){%>
                    
                    <table class="tabella">
                        <tr>
                            <th style="width: 75px"></th>
                            <th>Descrizione</th>                            
                            <th style="width: 120px">Inizio / Fine</th>
                            <th>Fase</th>
                            
                            <th>Sequenza</th>                            
                            <th>Durata</th>
                            <th>Scostamento</th>
                            <th>Risorsa</th>
                            <th>Note</th>                            
                            <th style="width: 135px">Situazione</th>
                            <th style="width: 200px"></th>
                            
                        </tr>
                        <%for(Attivita a:programmate_da_programmare){%>
                            <tr>
                                <td>
                                    <a href="<%=Utility.url%>/attivita/_attivita.jsp?id=<%=a.getId()%>" class="pulsantesmall" >
                                        <img src="<%=Utility.url%>/images/edit.png">
                                    </a>
                                    <%if(!a.getCompletata().equals("")){%>
                                        <div class="tagsmall green" style="margin: 3px;"><img src="<%=Utility.url%>/images/v2.png"></div>
                                    <%}%>
                                </td>                               
                                <td>
                                    <%=a.getDescrizione()%>
                                    <%if(!a.getNote().equals("null")){out.print(a.getNote());}%>
                                </td>
                                <td>
                                    <%=Utility.convertiDatetimeFormatoIT(a.getInizio())%>
                                    <br>
                                    <%=Utility.convertiDatetimeFormatoIT(a.getFine())%>
                                </td>                            
                                <td><%=a.getFase_input().getCodice()%> <%=a.getFase_input().getNome()%></td>
                             
                                <td>
                                    <%if(a.getSeq()>0){%>
                                        <div class="tag">
                                            <%=Utility.elimina_zero(a.getSeq())%>
                                        </div>
                                    <%}%>
                                </td>                                
                                <td><%=Utility.formatta_durata(a.getDurata())%> h</td>
                                <td><%if(a.getScostamento()!=0){out.print("<div class='tagsmall'>"+Utility.formatta_durata(a.getScostamento())+" h</div>");}%></td>                                
                                <td><%=a.getRisorsa().stampa()%></td>                                
                                <td>
                                    <%=Utility.standardizzaStringaPerTextArea(a.getNote())%>
                                </td>                                                               
                                <td>                                    
                                    <%if(a.is_da_programmare()){%>
                                        <div class="tag da_programmare">Da Programmare</div>
                                    <%}%>
                                    <%if(a.is_in_programmazione()){%>
                                        <div class="tag in_programmazione">In Programmazione</div>
                                    <%}%>
                                </td>
                                <td>
                                    <%if(a.is_da_programmare()){%>
                                        <button class="pulsante_tabella float-left" id="situazione" value="" onclick="modifica_attivita('<%=a.getId()%>',this)">
                                            <img src="<%=Utility.url%>/images/planning.png"> Rimuovi
                                        </button>
                                        <button class="pulsante_tabella float-left fit-content" onclick="mostrapopup('<%=Utility.url%>/act/_new_act.jsp?id_attivita=<%=a.getId()%>')"><img src="<%=Utility.url%>/images/setting.png">Configura Prestampa</button>
                                    <%}%>
                                    <%if(a.is_in_programmazione()){%>
                                        <a href='<%=Utility.url%>/planning/planning.jsp?data=<%=a.getInizioData()%>' class="pulsante_tabella planning float-left " target="_blank">
                                            <img src="<%=Utility.url%>/images/planning.png"> Planning
                                        </a>                                                                                    
                                    <%}%>                                                                           
                                </td>                                
                            </tr>
                        <%}%>
                        </table>
                    <%}else{%>
                        <div class="messaggio">
                            Nessuna attività Programmata / Da Programmare
                        </div>
                    <%}%>
                    </div>
                    
                    
                   
                    <div class="box">
                    <%ArrayList<Attivita> in_attesa=GestionePlanning.getIstanza().ricercaAttivita(" "
                            + "attivita.commessa="+Utility.isNull(id)+" AND "
                            + "attivita.situazione="+Utility.isNull("")+" AND "
                            + "attivita.stato='1' ORDER BY attivita.seq_input ASC");%>
                    <h2>Attività Importate</h2>
                    <table class="tabella">
                        <tr>                                    
                            <th>Descrizione</th>
                            <th>Fase</th>                                                        
                            <th>Durata</th>             
                            <th style="width: 200px"></th>
                        </tr>
                        <%for(Attivita a:in_attesa){%>
                            <tr>                                
                                <td>
                                    <%=a.getDescrizione()%>                                                                        
                                </td>                                 
                                <td>                                                                       
                                    <%=a.getFase_input().getFase().getNome()%> | 
                                    <br>                                    
                                    <%=a.getFase_input().getCodice()%> - <%=a.getFase_input().getNome()%>                                    
                                </td>                                                                
                                <td>
                                    <div class="tagsmall"><%=Utility.formatta_durata(a.getDurata())%> h</div>
                                </td>                                                                
                                <td>
                                    <button class="pulsante_tabella float-left"  onclick="mostrapopup('<%=Utility.url%>/attivita/_da_programmare.jsp?id_attivita=<%=a.getId()%>&fase=<%=a.getFase_input().getFase().getId()%>&sottofase=<%=a.getFase_input().getId()%>','Attivita <%=a.getId()%>')">
                                        <img src="<%=Utility.url%>/images/setting.png"> Configura
                                    </button>
                                    <button class="pulsante_tabella delete float-left" onclick="cancella_attivita('<%=a.getId()%>')">
                                        <img src="<%=Utility.url%>/images/delete.png"> Cancella
                                    </button>
                                </td>
                            </tr>
                        <%}%>
                    </table>
                    </div>
                    <div class="clear"></div>
                </div>
            </div>
            
            
            </div>
                
         
           
        </div>
    </body>
</html>
