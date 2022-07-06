<%@page import="gestioneDB.GestioneFasi"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.PlanningCella"%>
<%@page import="gestioneDB.GestioneTasks"%>
<%@page import="beans.Attivita"%>
<%@page import="utility.Utility"%>
<%@page import="gestioneDB.GestionePlanning"%>
<%
    String id_attivita=Utility.eliminaNull(request.getParameter("id_attivita"));        
    Attivita attivita=GestionePlanning.getIstanza().ricercaAttivita(" attivita.id="+id_attivita+" ").get(0);
    
    String cella_inizio_task=GestioneTasks.getIstanza().verifica_inizio_attivita_task(attivita);    
    PlanningCella pc=null;
    String cella_valore="";
    if(!cella_inizio_task.equals("")){
        pc=GestionePlanning.getIstanza().ricercaPlanningCelle(" planning.id="+cella_inizio_task).get(0);
        if(pc.getValore()!=null)
            cella_valore=pc.getValore();
    }
    String id_attivita_in_conflitto="";
    
    Attivita attivita_in_conflitto=null;

    int minuti_differenza=0;
    if(!attivita.getInizio().contains("3001-01-01"))
        minuti_differenza=Math.abs((int)Utility.compareTwoTimeStamps(attivita.getInizio_tasks(),attivita.getInizio()));
    
    String riprogramma_dopo="";
    
    String no_riposiziona="";
    
    if(cella_valore.equals("-1")){
        no_riposiziona="La cella in cui va riposizionata l'attività risulta essere non attiva.";
    }
    
    // Se cella!=1 && cella!=-1 -> cella già occupata da attività    
    if(!cella_valore.equals("1") && !cella_valore.equals("-1") && !cella_valore.equals("")){        
        if(id_attivita.equals(pc.getValore())){         // l'attività in conflitto è l'attività stessa
            attivita_in_conflitto=attivita;    
            id_attivita_in_conflitto=id_attivita;
        }else{                                          
            ArrayList<Attivita> attivita_in_conflitto_temp=GestionePlanning.getIstanza().ricercaAttivita(" attivita.id="+pc.getValore());        
            if(attivita_in_conflitto_temp.size()>0){
                attivita_in_conflitto=attivita_in_conflitto_temp.get(0);
                id_attivita_in_conflitto=attivita_in_conflitto.getId();
                riprogramma_dopo=Utility.getIstanza().getValoreByCampo("planning", "id"," "
                    + "inizio="+Utility.isNull(attivita_in_conflitto.getFine())+" AND risorsa="+attivita_in_conflitto.getRisorsa().getId() );
            }        
        }
    }
    
    // Ritardo
    double ritardo=attivita.durata_tasks_arrotondata()- attivita.getDurata(); 
%>

<script type='text/javascript'>
    
    function ignora_conflitto(){        
        if(confirm("Desideri ignorare il conflitto?L'attività non verrà più mostrata in questo elenco.")){
            var new_valore="ignora";
            $.ajax({
                type: "POST",
                url: "<%=Utility.url%>/attivita/__modificaattivita.jsp",
                data: "newvalore="+encodeURIComponent(String(new_valore))+"&campodamodificare=completata&idattivita=<%=id_attivita%>",
                dataType: "html",
                success: function(msg){  
                    aggiornaplanning();
                },
                error: function(){
                    alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE attivita_completata()" );
                }
            });
        }
    }
    
    function riprogramma_attivita(id_cella){
        mostraloader("Riprogrammazione in corso da task...");
        $.ajax({
            type: "POST",
            url: "<%=Utility.url%>/planning/__riprogramma_attivita.jsp",
            data: "id_attivita=<%=id_attivita%>&id_cella="+id_cella,
            dataType: "html",
            success: function(msg){  
                aggiornaplanning();
            },
            error: function(){
                alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE riprogramma_attivita_da_task()" );
            }
        });   
    }
    
    
</script>
    
    <h3 style="line-height: 25px;" title="ID: <%=attivita.getId()%>">
        <div class="tag float-left" style="margin-right: 5px;background-color: <%=attivita.getCommessa().getColore()%>"><%=attivita.getCommessa().getNumero()%></div>
        <%=attivita.getCommessa().getSoggetto().getAlias()%>  <%=attivita.getDescrizione()%>
    </h3>

    <div class="height10"></div>
    <table class='tabella' style="table-layout: fixed">
        <tr>
            <th>Risorsa</th>
            <th>Inizio</th>
            <th>Fine</th>
            <th>Fase</th>
            <th>Durata</th>
            <th>Sequenza</th>
            <th>Scostamento</th>
        </tr>
        <tr>
            <td class="text-align-center"><%=attivita.getRisorsa().getNome()%></td>
            <td class="text-align-center"><%=Utility.convertiDatetimeFormatoIT(attivita.getInizio())%></td>
            <td class="text-align-center"><%=Utility.convertiDatetimeFormatoIT(attivita.getFine())%></td>            
            <td class="text-align-center"><%=attivita.getFase_input().getNome()%></td>            
            <td><div class="tagsmall"><%=Utility.elimina_zero(attivita.getDurata())%> h</div></td>
            <td><div class="tagsmall"><%=attivita.getSeq()%></div></td>
            <td>
                <%if(attivita.getScostamento()!=0){%>
                    <div class="tagsmall"><%=attivita.getScostamento()%> h</div>
                <%}%>
            </td>            
        </tr>
    </table>
    
            
    <div class="height10"></div>


    <%if(attivita.getSeq()>0){
        int seq_int=(int)attivita.getSeq();
        ArrayList<Attivita> attivita_precedenti=GestionePlanning.getIstanza().ricercaAttivita(""
                + "attivita.commessa="+Utility.isNull(attivita.getCommessa().getNumero())+" AND attivita.stato='1' AND attivita.seq>="+seq_int+" AND attivita.seq<"+attivita.getSeq()+" AND seq!=0 ORDER BY attivita.seq DESC LIMIT 0,1");
        if(attivita_precedenti.size()>0){            
            Attivita attivita_precedente=attivita_precedenti.get(0);
            String fine_scostamento_temp=Utility.aggiungi_ore_minuti(attivita_precedente.getInizio(), attivita_precedente.getDurata()+attivita.getScostamento());                        
            
            String fine_scostamento=Utility.getIstanza().querySelect(""
                    + "SELECT inizio FROM planning WHERE "
                    + "risorsa="+Utility.isNull(attivita.getRisorsa().getId())+" AND inizio>="+Utility.isNull(fine_scostamento_temp)+" AND valore!='-1' "
                    + "ORDER BY inizio ASC LIMIT 0,1","inizio" );
            if(Utility.compareTwoTimeStamps(fine_scostamento,pc.getInizio())>0){
                no_riposiziona="Impossibile effettuare la riprogrammazione dell'attività.<BR>"
                        + "É presente un'attività, in ordine di sequenza precedente, che termina successivamente all'inizio calcolato =>"+fine_scostamento;
            }
            %>
            
            <h3>Attività Precedente</h3>
            
            <table class='tabella' style="table-layout: fixed">
                <tr>
                    <th>Risorsa</th>
                    <th>Inizio</th>
                    <th>Fine</th>
                    <th>Fase</th>
                    <th>Durata</th>
                    <th>Sequenza</th>
                    <th>Scostamento</th>
                </tr>
                <tr>
                    <td class="text-align-center"><%=attivita_precedente.getRisorsa().getNome()%></td>
                    <td class="text-align-center"><%=Utility.convertiDatetimeFormatoIT(attivita_precedente.getInizio())%></td>
                    <td class="text-align-center"><%=Utility.convertiDatetimeFormatoIT(attivita_precedente.getFine())%></td>            
                    <td class="text-align-center"><%=attivita.getFase_input().getCodice()%></td>            
                    <td><div class="tagsmall"><%=Utility.elimina_zero(attivita_precedente.getDurata())%> h</div></td>
                    <td><div class="tagsmall"><%=attivita_precedente.getSeq()%></div></td>
                    <td>
                        <%if(attivita_precedente.getScostamento()!=0){%>
                            <div class="tagsmall"><%=attivita_precedente.getScostamento()%> h</div>
                        <%}%>
                    </td>            
                </tr>
            </table>
        <%}
    }%>
    
    <div class="height10"></div>
    
    <h3>Task</h3>
    
    <table class='tabella' style="table-layout: fixed">
        <tr>
            <th>ID</th>
            <th>Inizio</th>
            <th></th>
            <th>Durata</th>
            <th></th>
            <th>Sottotask</th>
        </tr>
        <tr>
            <td class="text-align-center"><%=attivita.getTask()%></td>
            <td class="text-align-center"><%=Utility.convertiDatetimeFormatoIT(attivita.getInizio_tasks())%></td>
            <td class="text-align-center"></td>                        
            <td><div class="tagsmall"><%=Utility.elimina_zero(attivita.durata_tasks_arrotondata())%> h</div></td>
            <td></td>
            <td>
                <a href='<%=Utility.url%>/tasks/_sottotasks.jsp?id_esterno=<%=attivita.getTask()%>' class='pulsante task margin-auto' target="_blank">
                    <img src="<%=Utility.url%>/images/task.png">
                    Sottotask
                </a>
            </td>            
        </tr>
    </table>

    <div class='height10'></div>
                    
    
<%if(minuti_differenza>30){%>    
    
    <%if(!pc.getInizio().equals("")){%>
    
        <a href='<%=Utility.url%>/planning/planning.jsp?data=<%=pc.getInizioData()%>' target="_blank">
            <div class='errore' style='height: 60px;line-height: 60px;color:black;width: 600px;margin: auto;padding: 0px;font-weight: bold;'>
                <img src='<%=Utility.url%>/images/idea.png' style='height: 60px;float: left;'>
                Da riprogrammare il <%=Utility.convertiDatetimeFormatoIT(pc.getInizio())%> su <%=attivita.getRisorsa().getNome()%>
            </div>
        </a>
        <div class='height10'></div>
    <%}%>

    
<%if(!pc.getValore().equals("-1") && !pc.getValore().equals("1")){%>                                
    <table class="tabella"  style="table-layout: fixed">
        <tr>
            <th>Risorsa</th>
            <th style='width: 500px'>Attività in Conflitto</th>                                          
            <th>Inizio<br>da Planning</th>
            <th>Durata<br>Planning</th>                 
            <th>Inizio<br>da Optimus</th>                        
            <th>Durata<br>da Optimus</th>
            <th>Attiva/Completata</th>
            <th>Cella<br>Disponibile/Occupata</th> 
        </tr>
        <tr>
            <td class="text-align-center">
                <%=attivita.getRisorsa().getNome()%>
            </td>
            <td style="line-height: 25px;">
                    <div class="tag float-left"  title="ID: <%=attivita_in_conflitto.getId()%>" style="margin-right: 5px;background-color: <%=attivita_in_conflitto.getCommessa().getColore()%>"><%=attivita_in_conflitto.getCommessa().getNumero()%></div>                
                    <a href='<%=Utility.url%>/planning/planning.jsp?data=<%=attivita_in_conflitto.getInizioData()%>' target="_blank">
                        <%=attivita_in_conflitto.getCommessa().getSoggetto().getAlias()%>  <%=attivita_in_conflitto.getDescrizione()%>                                
                    </a>
                    <div class="clear"></div>
            </td>                 
            <td class="text-align-center">
                <%if(attivita_in_conflitto!=null){%>
                    <a href='<%=Utility.url%>/planning/planning.jsp?data=<%=pc.getInizioData()%>'>
                        <%=Utility.convertiDatetimeFormatoIT(pc.getInizio())%>
                    </a>
                <%}%>
            </td>
            <td>
                 <div class="tagsmall">
                     <%=Utility.elimina_zero(attivita_in_conflitto.getDurata())%> h
                 </div>
             </td>                 
            <td class="text-align-center">
                <%if(attivita_in_conflitto!=null){%>
                    <%=Utility.convertiDatetimeFormatoIT(attivita_in_conflitto.getInizio_tasks())%>               
                <%}%>
            </td>
            <td>
                <div class="tag"><%=Utility.elimina_zero(attivita_in_conflitto.getDurata_tasks())%> m</div>
            </td>
            <td>
                 <%if(attivita_in_conflitto.getAttiva().equals("si")){%>
                     <div class="tag blink">Attiva</div>
                 <%}%>             
                 <%if(attivita_in_conflitto.getCompletata().equals("si")){%>
                     <div class="tag green" style="margin-left: 5px;">Completata</div>
                 <%}%>
             </td>    
            <td>
                <%if(pc.getValore().equals("1")){%>
                    <div class='tag green'>Disponibile</div>
                <%}%>
                <%if(pc.getValore().equals("-1")){%>
                    <div class='tag' style="background-color:rgba(158,180,204,1);">Cella Non Disponibile</div>                    
                <%}%>
                <%if(!pc.getValore().equals("-1") && !pc.getValore().equals("1")){%>
                    <div class='tag red'>Occupata</div>
                <%}%>                
            </td>                               
        </tr>
    </table>
<%}%>
    <div class="height10"></div>
    
<%}%>

    <%if(!no_riposiziona.equals("")){%>
        <div class="errore margin-auto">
            <%=no_riposiziona%>
        </div>
    <%}%>
    
    <div class="height10"></div>
    
    <button class="pulsante task" onclick="mostrapopup('<%=Utility.url%>/tasks/task_planning.jsp','Task Infogest/Optimus')">
        <img src="<%=Utility.url%>/images/back.png">
        Torna a Task
    </button>
    
    <div class="float-right">        
        
        <%if(no_riposiziona.equals("") && minuti_differenza>30){%>
                
                <%if(pc.getValore().equals("1") || id_attivita.equals(id_attivita_in_conflitto)){%>
                    <button class="pulsante float-left" title="Sposta l'attività nella cella corretta secondo il corrispondente task" onclick="riprogramma_attivita('<%=cella_inizio_task%>')">Riposiziona Attività</button>
                <%}%>

                <%if(!pc.getValore().equals("1") && !pc.getValore().equals("-1") && !id_attivita.equals(id_attivita_in_conflitto)){%>
                    <button class="pulsante float-left" title="L'attività in conflitto verrà sostituita con l'attività selezionata che verrà scalata sotto" onclick="riprogramma_attivita('<%=cella_inizio_task%>')">Sostituisci Attività</button>

                    <button class="pulsante float-left" title="L'attività viene riprogrammata dopo l'attività in conflitto <%=riprogramma_dopo%>" onclick="riprogramma_attivita('<%=riprogramma_dopo%>')">Riprogramma Dopo</button>
                <%}%>            

        <%}%>


        <%if(ritardo>0){%>
            <button class="pulsante red float-left" 
                    onclick="imposta_ritardo('<%=attivita.getId()%>','<%=Utility.elimina_zero(ritardo)%>')" 
                    title="L'attività in planning risulta essere in ritardo di <%=Utility.elimina_zero(ritardo)%> h">
                <img src="<%=Utility.url%>/images/planning.png">
                Aggiungi Ritardo di <%=ritardo%> h
            </button>
        <%}%>
    
        <button class="pulsante pulsante_inverted float-left" onclick="ignora_conflitto();">Ignora Conflitto</button>
        
    </div>
    
    
    <div class="height10"></div>
    
