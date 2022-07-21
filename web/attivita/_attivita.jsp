<%@page import="beans.OrdineFornitore"%>
<%@page import="gestioneDB.GestioneSincronizzazione"%>
<%@page import="beans.Task"%>
<%@page import="gestioneDB.GestioneTasks"%>
<%@page import="gestioneDB.GestioneOpzioni"%>
<%@page import="gestioneDB.GestioneFasi"%>
<%@page import="beans.Fase"%>
<%@page import="beans.Utente"%>
<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="beans.Attivita"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.Commessa"%>
<%@page import="gestioneDB.GestioneCommesse"%>
<%@page import="utility.Utility"%>
    <%
        Utente utente=(Utente)session.getAttribute("utente");
        
        String id=Utility.eliminaNull(request.getParameter("id"));
        Attivita attivita=GestionePlanning.getIstanza().ricercaAttivita(" attivita.id="+id).get(0);

        String modificabile=Utility.eliminaNull(request.getParameter("modificabile"));
        
        boolean mostra_scostamento=false;
        int seq_intero = (int)attivita.getSeq();
        double seq_decimale = attivita.getSeq() - seq_intero;
        if(seq_decimale>0){
            mostra_scostamento=true;
        }
        
        ArrayList<Attivita> attivita_commessa=new ArrayList<Attivita>();        
            attivita_commessa=GestionePlanning.getIstanza().ricercaAttivita(" "
            + "attivita.commessa="+Utility.isNull(attivita.getCommessa().getId())+" AND "
            + "(attivita.stato='1' OR attivita.stato='taglia') AND "
            + "attivita.situazione!='' "
            +" ORDER BY attivita.seq ASC,attivita.inizio ASC ");        
        
        
        

        Attivita attivita_prec=null;
        Attivita attivita_succ=null;
        
        double seq_prec=attivita.getSeq()-0.01;
        seq_prec=Math.round(seq_prec*100.0)/100.0;
        
        double seq_succ=attivita.getSeq()+0.01;       
        seq_succ=Math.round(seq_succ*100.0)/100.0;
        
        double max_scostamento=0;
        double durata_minima=0;
        
        for(Attivita attivita_temp:attivita_commessa){            
            if(attivita_temp.getSeq()==seq_prec){
                attivita_prec=attivita_temp;
                max_scostamento=attivita_temp.getDurata();
            }
            if(attivita_temp.getSeq()==seq_succ){
                attivita_succ=attivita_temp;
                durata_minima=Math.abs(attivita_temp.getScostamento());
            }
        }
            
    %>
    
    <html>
        <title>Attività | <%=Utility.nomeSoftware%></title>
        
        <jsp:include page="../_importazioni.jsp"></jsp:include>
            
    
        <script type="text/javascript">
        
            
        function modifica_commessa(inField){                
            var newvalore=inField.value;
            var campodamodificare=inField.id;                
            $.ajax({
                type: "POST",
                url: "<%=Utility.url%>/commesse/__modificacommessa.jsp",
                data: "newvalore="+encodeURIComponent(String(newvalore))+"&campodamodificare="+campodamodificare+"&id=<%=attivita.getCommessa().getId()%>",
                dataType: "html",
                success: function(msg){
                    attivita_modificata=true;
                },
                error: function(){
                    alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE modificacommessa()");
                }
            });
        }
        
        function rimuovi_attivita_planning(id_attivita){
                if("Rimuovere l'attività dal planning?N.B. L'attività sarà presente nell'elenco attività importate della commessa."){                    
                    mostraloader("Aggiornamento in corso...");
                    $.ajax({
                        type: "POST",
                        url: "<%=Utility.url%>/attivita/__rimuovi_attivita_planning.jsp",
                        data: "id_attivita="+id_attivita,
                        dataType: "html",
                        success: function(msg){
                            aggiorna_attivita();
                        },
                        error: function(){
                            alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE rimuovi_attivita_planning()" );
                        }
                    });
                }
         }
            
        function da_programmare(id_attivita){            
            var new_valore="da programmare";
            mostraloader("Aggiornamento in Corso...");
            $.ajax({
                type: "POST",
                url: "<%=Utility.url%>/attivita/__modificaattivita.jsp",
                data: "campodamodificare=situazione&newvalore="+encodeURIComponent(String(new_valore))+"&idattivita="+id_attivita,
                dataType: "html",
                success: function(msg){
                    aggiorna_attivita();
                },
                error: function(){
                    alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE da_programmare");
                }
            });		
        }
            
        function aggiorna_attivita(){
            $("#div_attivita").load("<%=Utility.url%>/attivita/_attivita.jsp?id_attivita=<%=id%> #div_attivita_inner",function(){nascondiloader();});
        }
        
    </script>
    
    </head>
    
    <body>

    <jsp:include page="../_menu.jsp"></jsp:include>
        
    <div id="container">
        
    <h1>
        <button class="pulsantesmall" type="button" onclick="location.href='<%=request.getHeader("referer")%>'"><img src="<%=Utility.url%>/images/back.png"></button>
        <div class="tag " style="background-color:<%=attivita.getCommessa().getColore()%>">
            <%=attivita.getCommessa().getNumero()%></div> 
        <%=attivita.getCommessa().getSoggetto().getAlias()%> - <%=Utility.standardizzaStringaPerTextArea(attivita.getDescrizione())%>
    </h1>
    
    <input type="hidden" id="old_scostamento" value="<%=attivita.getScostamento()%>">
    <input type="hidden" id="old_ritardo" value="<%=attivita.getRitardo()%>">
    <input type="hidden" id="olddurata" value="<%=attivita.getDurata()%>">
    
    <div class="tabs">
        <div class="tab tab2" id="tabdettagli" onclick="mostratab('dettagli');">Dettagli</div>        
    </div>

    <div class="box">                         
        
        <a href='<%=Utility.url%>/commesse/commessa.jsp?id=<%=attivita.getCommessa().getId()%>' class="pulsante commessa" ><img src="<%=Utility.url%>/images/document.png">Commessa</a>
                
        <%if(attivita.is_in_programmazione() && attivita.getStato().equals("1")){%>
            <button class="pulsante da_programmare" onclick="da_programmare('<%=id%>')"><img src="<%=Utility.url%>/images/planning.png"> Imposta da Da Programmare</button>
            <a href='<%=Utility.url%>/planning/planning.jsp?data=<%=attivita.getInizioData()%>' class="pulsante planning" ><img src="<%=Utility.url%>/images/planning.png">Planning</a>
        <%}%>
    </div>
    
    
    <%
        if(attivita.is_in_programmazione()){
        String verifica_planning=Utility.getIstanza().querySelect("SELECT id FROM planning WHERE valore='1' AND risorsa="+Utility.isNull(attivita.getRisorsa().getId())+" AND inizio>="+Utility.isNull(attivita.getInizio())+" AND fine<="+Utility.isNull(attivita.getFine()), "id");
        if(!verifica_planning.equals("")){
    %>
        <div class="clear"></div>
        <div class="errore">
            Attenzione errore nel Planning.
            <br>
            Risultano presenti delle celle con valore=1 compreso tra <%=attivita.getInizio_it()%> e <%=attivita.getFine_it()%>
        </div>
        <div class="clear"></div>
        <%}%>
    <%}%>
    
<div id="div_attivita">
    <div id="div_attivita_inner">
    
    <div class="scheda" id="schedadettagli"  <%if(modificabile.equals("no")){%>style="pointer-events: none"<%}%> >
        
        
    <div class='width50 float-left'>
        
        <%if(attivita.getStato().equals("taglia")){%>
        <div class="box">
            <div class="messaggio">
            Attività tagliata dal planning ed in attesa di essere incollata.
           </div>
        </div>
        <%}%>
        
        <div class="box">
        <div class="etichetta">Inizio / Fine</div>
        <div class="valore">
            <span style="width: 250px;float: left;"><%=Utility.convertiDatetimeFormatoIT(attivita.getInizio())%> - <%=Utility.convertiDatetimeFormatoIT(attivita.getFine())%></span>            
        </div>  
       
        </div>
        <div class="box">
            <div class="etichetta">Commessa</div>
            <div class="valore">
                <span>
                    <div class="ball" style="background-color:<%=attivita.getCommessa().getColore()%>"></div>
                    <%=attivita.getCommessa().getNumero()%> <%=attivita.getCommessa().getDescrizione()%>  - <%=attivita.getCommessa().getSoggetto().getAlias()%></span>            
            </div>

            <div class="etichetta">Dettagli Commessa</div>
            <div class="valore">
                <textarea id="dettagli" onchange="modifica_commessa(this)"><%=Utility.standardizzaStringaPerTextArea(attivita.getCommessa().getDettagli())%></textarea>
            </div>
            
           
            <div class="etichetta">Note</div>
            <div class="valore">
                <textarea readonly="true" tabindex="-1" class="pointer-events-none"><%=attivita.getCommessa().getNote()%></textarea>
            </div>

            
        </div>
            
        <div class="box">
            
        <div class="etichetta">Risorsa</div>
        <div class="valore">
            <span><%=attivita.getRisorsa().getCodice()%> <%=attivita.getRisorsa().getNome()%></span>
        </div>
        
        <div id="div_fase">
            <div id="div_fase_inner">
                <div class="etichetta">Fase</div>
                <div class="valore">
                    <input type="text" readonly value="<%=attivita.getFase_input().getCodice()%> <%=attivita.getFase_input().getNome()%>">
                </div>
            </div>
        </div>
                
        <div class="etichetta">Sequenza</div>
        <div class="valore"><span style="width: 100px"><%=Utility.elimina_zero(attivita.getSeq())%></span></div>
                
        </div>
        
        <div class="box">
                
            <div class="etichetta">Durata</div>
            <div class="valore">                        
                <span><%=Utility.elimina_zero(attivita.getDurata())%></span>                
            </div>

            <div class="etichetta">Ritardo</div>
            <div class="valore">
                <span><%=Utility.elimina_zero(attivita.getRitardo())%></span>                
            </div>
        
        
            <%if(mostra_scostamento==true){%>
                <div class="etichetta">Scostamento</div>
                <div class="valore">
                    <span><%=Utility.elimina_zero(attivita.getScostamento())%></span>
                </div>
            <%}%>
           
            <button class="pulsante float-right" onclick="mostrapopup('<%=Utility.url%>/attivita/_modifica_durata_attivita.jsp?id_attivita=<%=id%>')"><img src="<%=Utility.url%>/images/edit.png">Modifica</button>
            
        </div>
        
        <div class="box">
            <div class="etichetta">Completata</div>
            <div class="valore">                
                <button class="pulsanti_completata pulsante_tabella color_eee <%if(attivita.is_completata()){%> green <%}%>" id="completata" value="si" onclick="modifica_attivita('<%=id%>',this)" >Si</button>
                <button class="pulsanti_completata pulsante_tabella color_eee <%if(!attivita.is_completata()){%> green <%}%>" id="completata" value=""   onclick="modifica_attivita('<%=id%>',this)">No</button>                
            </div>
            
            <div class="etichetta">Attiva</div>
            <div class="valore">
                <button class="pulsanti_attiva pulsante_tabella color_eee <%if(attivita.getAttiva().equals("si")){%> green <%}%>" id="attiva" value="si" onclick="modifica_attivita('<%=id%>',this)" >Si</button>
                <button class="pulsanti_attiva pulsante_tabella color_eee <%if(!attivita.getAttiva().equals("si")){%> green <%}%>" id="attiva" value=""   onclick="modifica_attivita('<%=id%>',this)">No</button>                
            </div>
        
            <div class="etichetta">Attiva Infogest</div>
            <div class="valore">
                <button class="pulsanti_attiva_infogest pulsante_tabella color_eee <%if(attivita.is_attiva_infogest()){%> green <%}%>" id="attiva_infogest" value="si" onclick="modifica_attivita('<%=id%>',this)" >Si</button>
                <button class="pulsanti_attiva_infogest pulsante_tabella color_eee <%if(!attivita.is_attiva_infogest()){%> green <%}%>" id="attiva_infogest" value=""   onclick="modifica_attivita('<%=id%>',this)">No</button>                
            </div>
                       
        </div>
        
        
        </div>
        
    </div>
    <div class='width50 float-left'>
        
        <div class="box">
            
            <div class="etichetta">
                Descrizione Attività
            </div>
            <div class="valore">
                <textarea id="descrizione" name="descrizione" onchange="modifica_attivita('<%=id%>',this);"><%=Utility.standardizzaStringaPerTextArea(attivita.getDescrizione())%></textarea>
            </div>


            <div class="etichetta">
                Note Attività
            </div>
            <div class="valore">
                <textarea id="note" name="note" style="height: 150px" onchange="modifica_attivita('<%=id%>',this)"><%=Utility.standardizzaStringaPerTextArea(attivita.getNote())%></textarea>
            </div>
            
        </div>
        
        <div class="box">                       
            <!-- Allegati -->
            <div id="schedaallegati" >
                <%if(!modificabile.equals("no")){%>
                    <%if(!utente.getPrivilegi().equals("operaio")){%> 
                        <jsp:include page="../_nuovoallegato.jsp">
                            <jsp:param name="idrif" value="<%=id%>"></jsp:param>
                            <jsp:param name="rif" value="ATTIVITA"></jsp:param>
                        </jsp:include>
                    <%}%>        
                <%}%>

                <%String queryallegati=" rif='ATTIVITA' AND idrif="+Utility.isNull(id)+" AND allegati.stato='1' ORDER BY data ASC";%>
                <jsp:include page="../_allegati.jsp">
                    <jsp:param name="query" value="<%=queryallegati%>"></jsp:param>
                    <jsp:param name="rif" value="ATTIVITA"></jsp:param>
                </jsp:include>
            </div>

        </div>
    
    
    </div>
    
    <div class="height10"></div>
            
    <input type="hidden" id="max_scostamento" value="<%=max_scostamento%>" readonly="true" tabindex="-1">
        <div class="box">
        <%if(attivita_commessa.size()>0){%>
                <h2>Attività Commessa</h2>    
          
                <table class="tabella">
                    <tr>
                        <th colspan="2"></th>
                        <th>Descrizione</th>                        
                        <th>Inizio</th>
                        <th>Fine</th>
                        <th>Risorsa</th>
                        <th>Seq</th>                        
                        <th>H</th>
                    </tr>
                    <%for(Attivita attivita_precedente:attivita_commessa){                        
                        %>
                        <tr>                            
                            <td title="[ID: <%=attivita_precedente.getId()%>] "  style="width: 105px">
                                <%if(!attivita_precedente.getId().equals(id)){%>                                
                                    <a class="pulsante_tabella " href="<%=Utility.url%>/attivita/_attivita.jsp?id=<%=attivita_precedente.getId()%>">
                                        <img src="<%=Utility.url%>/images/edit.png" > Dettagli
                                    </a>
                                <%}%>
                                                             
                            </td>
                            <td>                                
                                <%if(!attivita_precedente.getInizioData().equals("3001-01-01")){%>
                                    <a href='<%=Utility.url%>/planning/planning.jsp?data=<%=attivita_precedente.getInizioData()%>' class="pulsante_tabella planning" >
                                        <img src="<%=Utility.url%>/images/planning.png" > Planning
                                    </a>                                
                                <%}%>
                                <%if(attivita_precedente.getCompletata().equals("si")){%>
                                    <div class="pulsante_tabella float-left green pointer-events-none">Completata</div>
                                <%}%>   
                            </td>
                            <td>                                
                                <%=attivita_precedente.getFase_input().getFase().getNome()%>
                                <%=attivita_precedente.getDescrizione()%>           
                            </td>                            
                            <td><%=Utility.convertiDatetimeFormatoIT(attivita_precedente.getInizio())%></td>
                            <td><%=Utility.convertiDatetimeFormatoIT(attivita_precedente.getFine())%></td>
                            <td>
                                <%=attivita_precedente.getRisorsa().getNome()%>
                            </td>
                            <td>
                                <%if(attivita_precedente.getSeq()>0){%>
                                    <div class="tagsmall float-left">
                                        <%=Utility.elimina_zero(attivita_precedente.getSeq())%>
                                    </div>
                                <%}%>
                                <%if(attivita_precedente.getScostamento()!=0){%>
                                    <div class="tagsmall float-left" style="margin-left: 5px;">
                                        <%=Utility.elimina_zero(attivita_precedente.getScostamento())%>
                                    </div>
                                <%}%>
                            </td>
                            <td>
                                <div class="tagsmall margin-auto">
                                    <%=Utility.elimina_zero(attivita_precedente.getDurata())%> h
                                </div>
                            </td>
                        </tr>
                    <%}%>                
                </table>            
        <%}%>
        </div>
      
        <%if(!GestioneOpzioni.getIstanza().getOpzione(GestioneOpzioni.ATTIVITA_LIBERO_1).equals("")){%>
            <div class="etichetta">
                <%=GestioneOpzioni.getIstanza().getOpzione(GestioneOpzioni.ATTIVITA_LIBERO_1)%>
            </div>
            <div class="valore">
                <input type="text" id="libero1" value="<%=attivita.getLibero1()%>" onchange="modifica_attivita('<%=id%>',this)">
            </div>
        <%}%>
        
        <%if(!GestioneOpzioni.getIstanza().getOpzione(GestioneOpzioni.ATTIVITA_LIBERO_2).equals("")){%>
            <div class="etichetta">
                <%=GestioneOpzioni.getIstanza().getOpzione(GestioneOpzioni.ATTIVITA_LIBERO_2)%>
            </div>
            <div class="valore">
                <input type="text" id="libero2" value="<%=attivita.getLibero2()%>" onchange="modifica_attivita('<%=id%>',this)">
            </div>
        <%}%>
        
        <%if(!GestioneOpzioni.getIstanza().getOpzione(GestioneOpzioni.ATTIVITA_LIBERO_3).equals("")){%>
            <div class="etichetta">
                <%=GestioneOpzioni.getIstanza().getOpzione(GestioneOpzioni.ATTIVITA_LIBERO_3)%>
            </div>
            <div class="valore">
                <input type="text" id="libero3" value="<%=attivita.getLibero3()%>" onchange="modifica_attivita('<%=id%>',this)">
            </div>
        <%}%>
        
        <%if(!GestioneOpzioni.getIstanza().getOpzione(GestioneOpzioni.ATTIVITA_LIBERO_4).equals("")){%>
            <div class="etichetta">
                <%=GestioneOpzioni.getIstanza().getOpzione(GestioneOpzioni.ATTIVITA_LIBERO_4)%>
            </div>
            <div class="valore">
                <input type="text" id="libero5" value="<%=attivita.getLibero5()%>" onchange="modifica_attivita('<%=id%>',this)">
            </div>
        <%}%>
        
        <%if(!GestioneOpzioni.getIstanza().getOpzione(GestioneOpzioni.ATTIVITA_LIBERO_6).equals("")){%>
            <div class="etichetta">
                <%=GestioneOpzioni.getIstanza().getOpzione(GestioneOpzioni.ATTIVITA_LIBERO_6)%>
            </div>
            <div class="valore">
                <input type="text" id="libero6" value="<%=attivita.getLibero6()%>" onchange="modifica_attivita('<%=id%>',this)">
            </div>
        <%}%>
        
        <%if(!GestioneOpzioni.getIstanza().getOpzione(GestioneOpzioni.ATTIVITA_LIBERO_7).equals("")){%>
            <div class="etichetta">
                <%=GestioneOpzioni.getIstanza().getOpzione(GestioneOpzioni.ATTIVITA_LIBERO_7)%>
            </div>
            <div class="valore">
                <input type="text" id="libero7" value="<%=attivita.getLibero7()%>" onchange="modifica_attivita('<%=id%>',this)">
            </div>
        <%}%>
        
              
    </div>

     
    <div class="clear"></div>
        
    </div>
    </div>
        
</body>
</html>
    
    