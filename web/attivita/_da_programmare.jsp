<%@page import="gestioneDB.GestioneFasi_Input"%>
<%@page import="beans.Fase_Input"%>
<%@page import="gestioneDB.GestioneRisorse"%>
<%@page import="beans.Risorsa"%>
<%@page import="java.util.ArrayList"%>
<%@page import="gestioneDB.GestioneFasi"%>
<%@page import="beans.Fase"%>
<%@page import="beans.Attivita"%>
<%@page import="utility.Utility"%>
<%@page import="gestioneDB.GestionePlanning"%>
<%
    String id_attivita=Utility.eliminaNull(request.getParameter("id_attivita"));
    String id_commessa="";
    boolean nuova_attivita=false;
    if(id_attivita.equals("")){
        id_commessa=Utility.eliminaNull(request.getParameter("id_commessa"));
        id_attivita=Utility.getIstanza().query_insert("INSERT INTO attivita(commessa) VALUES ("+Utility.isNull(id_commessa)+")");
        nuova_attivita=true;
    }
    
    Attivita attivita=GestionePlanning.getIstanza().ricercaAttivita(" attivita.id="+id_attivita).get(0);
    id_commessa=attivita.getCommessa().getId();
    
    ArrayList<Fase> fasi=GestioneFasi.getIstanza().ricerca("");
    
    String fase=Utility.eliminaNull(request.getParameter("fase"));        
    String sottofase=Utility.eliminaNull(request.getParameter("sottofase"));                
    ArrayList<Fase_Input> sottofasi=GestioneFasi_Input.getIstanza().ricerca(" fasi_input.fase="+Utility.isNull(fase)+" AND fasi_input.stato='1' ORDER BY fasi_input.codice ASC");
    
    ArrayList<Risorsa> risorse=GestioneRisorse.getIstanza().ricercaRisorse(" "
            + "risorse.fase="+Utility.isNull(fase)+" AND "
            + "risorse.fasi_input LIKE "+Utility.isNullLike(sottofase)+" AND risorse.stato='1' AND "
            + "risorse.planning='si' "
            + "ORDER BY risorse.codice ASC");
    
    
    /***************************************************************
     *              Attività selezionata precedente
     ***************************************************************/
    String precedente_tipo=Utility.eliminaNull(request.getParameter("precedente_tipo"));
    String precedente_attivita=Utility.eliminaNull(request.getParameter("precedente_attivita"));
    
    
    String query_precedenti="";
    if(!precedente_tipo.equals("")){
            String  fase_ordinamento=Utility.getIstanza().getValoreByCampo("fasi", "ordinamento", "id="+fase);
            if(precedente_tipo.equals("dopo") || precedente_tipo.equals("insieme")){
                query_precedenti="attivita.id!="+id_attivita+" AND "
                    + "attivita.commessa="+Utility.isNull(attivita.getCommessa().getId())+" AND "
                    + "attivita.seq!=0 AND "
                    + "(attivita.situazione="+Utility.isNull(Attivita.DAPROGRAMMARE)+" OR attivita.situazione="+Utility.isNull(Attivita.INPROGRAMMAZIONE)+" ) AND "
                    + "fasi.ordinamento<"+Utility.isNull(fase_ordinamento)+" AND " 
                    + "attivita.stato='1' ORDER BY seq ASC";
            }
    }
    
    Attivita attivita_precedente=null;    
    if(!precedente_attivita.equals("")){
        attivita_precedente=GestionePlanning.getIstanza().ricercaAttivita(" attivita.id="+precedente_attivita).get(0);
    }
    
    ArrayList<Attivita> precedenti=null;
    if(!query_precedenti.equals(""))
        precedenti=GestionePlanning.getIstanza().ricercaAttivita(query_precedenti);
    else
        precedenti=new ArrayList<Attivita>();
    
        
    
    

%>
    <script type="text/javascript">
        function da_programmare(){ 
            var risorsa=$("#risorsa").val();
           
            var scostamento=parseFloat($("#scostamento").val());
            var precedente_durata=parseFloat($("#precedente_durata").val());
            if(Math.abs(scostamento)>precedente_durata && scostamento<0){
                alert("Impossibile proseguire nella programmazione.\nLo scostamento in anticipo è superiore alla durata dell'attività precedente.");
                return;
            }

            if(risorsa==="" || risorsa===undefined){
                alert("Impossibile proseguire nella programmazione.\nNessuna risorsa selezionata.");
                return;
            }
            
            var precedente_risorsa=$("#precedente_risorsa").val();            
            if(scostamento<0 && risorsa===precedente_risorsa){
                alert("Impossibile proseguire nella programmazione.\nInserito uno scostamento negativo su attività programmate sulla stessa risorsa.");
                return;
            }
            
            var durata=parseFloat($("#durata").val());
            if(durata<=0){
                alert("Impossibile impostare una durata negativa o uguale a zero.");
                return;
            }
            
            var ritardo=parseFloat($("#ritardo").val());
            if(ritardo<0){
                alert("Impossibile impostare un ritardo negativo.");
                return;
            }
            
            
            mostraloader("Aggiornamento attività in corso...");
            $.ajax({
                type: "POST",
                url: "<%=Utility.url%>/attivita/__da_programmare.jsp",
                data: $("#form_in_programmazione").serialize(),
                dataType: "html",
                success: function(msg){
                    aggiorna_attivita();
                },
                error: function(){
                    alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE in_programmazione");
                }
            });		
        }
        
        function seleziona_fase(){
            mostraloader("Ricerca in corso... ");
            var fase=$("#fase").val();
            $("#div_dettagli").load("<%=Utility.url%>/attivita/_da_programmare.jsp?id_attivita=<%=id_attivita%>&fase="+fase+" #div_dettagli_inner",
                function(){
                    nascondiloader();
                });
        }
        
        
        function seleziona_sottofase(){
            mostraloader("Ricerca in corso... ");
            var id_attivita=$("#id_attivita").val();
            var fase=$("#fase").val();
            var sottofase=$("#sottofase").val();
            $("#div_dettagli").load("<%=Utility.url%>/attivita/_da_programmare.jsp?id_attivita="+id_attivita+"&fase="+fase+"&sottofase="+sottofase+" #div_dettagli_inner",
                function(){
                    nascondiloader();
                });
        }
        
        function seleziona_precedente_tipo(precedente_tipo){      
            var fase=$("#fase").val();
            var sottofase=$("#sottofase").val();
            mostraloader("");
            $("#div_dettagli").load("<%=Utility.url%>/attivita/_da_programmare.jsp?id_attivita=<%=id_attivita%>&precedente_tipo="+precedente_tipo+"&fase="+fase+"&sottofase="+sottofase+" #div_dettagli_inner",function(){                 
                nascondiloader();
            });           
        }
        
        function seleziona_precedente_attivita(){
            var precedente_tipo=$("#precedente_tipo").val();
            var precedente_attivita=$("#precedente_attivita").val();
            var fase=$("#fase").val();
            var sottofase=$("#sottofase").val();            
            if(precedente_attivita!==""){
                mostraloader("Ricerca Risorse disponibili in corso...");
                $("#div_dettagli").load("<%=Utility.url%>/attivita/_da_programmare.jsp?id_attivita=<%=id_attivita%>&precedente_attivita="+precedente_attivita+"&precedente_tipo="+precedente_tipo+"&fase="+fase+"&sottofase="+sottofase+" #div_dettagli_inner",function(){
                    nascondiloader();
                });
            }
            
        }
        
        function nascondipopup(){
            <%if(nuova_attivita==true){%>
                mostraloader("");
                var new_valore="-1";
                var campo_da_modificare="stato";
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/attivita/__modificaattivita.jsp",
                    data: "newvalore="+encodeURIComponent(String(new_valore))+"&campodamodificare="+campo_da_modificare+"&idattivita=<%=id_attivita%>",
                    dataType: "html",
                    success: function(msg){
                        nascondiloader();
                        function_nascondipopup();
                    },
                    error: function(){
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE nascondipopup");
                    }
                });	
            <%}else{%>
                
                function_nascondipopup();
            <%}%>
        }
    </script>

    
    
    <form  id="form_in_programmazione">

        <div class="box">
        
        <input type="hidden" name="id_attivita" id="id_attivita"  value="<%=id_attivita%>">
        <input type="hidden" name="id_commessa" id="id_commessa" value="<%=id_commessa%>">

        <div class="etichetta">Commessa</div>
        <div class="valore">
            <input type="text" readonly="true" tabindex="-1" value="<%=attivita.getCommessa().getNumero()%> <%=attivita.getCommessa().getDescrizione()%>">
        </div>
        
        <div class="etichetta"></div>
        <div class="valore">
            <span style="height: auto;line-height: 16px;"><%=attivita.getCommessa().getNote()%></span>
        </div>
        
        <div class="etichetta">Descrizione</div>
        <div class="valore">
            <span><%=attivita.getDescrizione()%></span>
        </div>
        
        <div class="etichetta">Durata</div>
        <div class="valore">
            <input type="number" id="durata" name="durata" value="<%=attivita.getDurata()%>">
        </div>

        <div class="etichetta">Fase</div>
        <div class="valore">
            <select id="fase" name="fase" onchange="seleziona_fase()">
                <option value="">Seleziona la Fase</option>
                <%for(Fase f:fasi){%>
                    <option value="<%=f.getId()%>" <%if(f.getId().equals(fase)){%> selected="true"<%}%> ><%=f.getCodice()%> <%=f.getNome()%> <%=f.getNote()%></option>
                <%}%>
            </select>
        </div>
            
    <div id="div_dettagli" > 
        <div id="div_dettagli_inner"> 

            
        <%if(!fase.equals("")){%>
            <div class="etichetta">Sottofase</div>
                <div class="valore">
                <select id="sottofase" name="fase_input" onchange="seleziona_sottofase()" >
                    <option value="">Seleziona la sottofase</option>
                    <%for(Fase_Input s:sottofasi){%>
                        <option value="<%=s.getId()%>" <%if(s.getId().equals(sottofase)){%> selected="true"<%}%> ><%=s.getCodice()%> <%=s.getNome()%></option>
                        <%}%>
                </select>
            </div>
        <%}%>
            
                        
            
    <%if(!fase.equals("") && !sottofase.equals("")){%>

            <div class="etichetta"></div>
            <div class="valore">
                <button class="pulsante lightgray float-left <%if(precedente_tipo.equals("escludi")){%>colore<%}%>" type="button" onclick="seleziona_precedente_tipo('escludi')">Escludi da precedenze</button>
                <button class="pulsante lightgray float-left <%if(precedente_tipo.equals("primo")){%>colore<%}%>" type="button" onclick="seleziona_precedente_tipo('primo')">Primo di una sequenza</button>
                <button class="pulsante lightgray float-left <%if(precedente_tipo.equals("dopo")){%>colore<%}%>" type="button" onclick="seleziona_precedente_tipo('dopo')">Successivo a</button>
                <button class="pulsante lightgray float-left  <%if(precedente_tipo.equals("insieme")){%>colore<%}%>" type="button" onclick="seleziona_precedente_tipo('insieme')" style="display: none">Insieme a</button>
            </div>
            <div class="clear"></div>
                        
            <input type="hidden" id="precedente_tipo" name="precedente_tipo" value="<%=precedente_tipo%>">
            <%if(precedente_tipo.equals("dopo") || precedente_tipo.equals("insieme")){%>
                <%if(precedenti.size()>0){%>
                    <div class="etichetta"><%=precedente_tipo%> a</div>
                    <div class="valore">             
                        <select id="precedente_attivita" name="precedente_attivita" onchange="seleziona_precedente_attivita()" style='width: calc(85% - 10px)'>
                            <option value="">Seleziona l'attivita</option>
                            <%for(Attivita prec:precedenti){%>
                                <option value="<%=prec.getId()%>" <%if(precedente_attivita.equals(prec.getId())){%>selected="true"<%}%>>
                                    <%=prec.getSeq()%> <%=prec.getFase_input().getCodice()%> <%=prec.getDescrizione()%> su <%=prec.getRisorsa().stampa()%> durata: <%=Utility.elimina_zero(prec.getDurata())%>h
                                </option>
                            <%}%>
                        </select>
                    </div>        
                <%}else{%>                    
                    <div class="etichetta"></div>
                    <div class="valore">Nessuna attività precedente</div>
                    <input type="hidden" id="precedente_attivita" value="" class="readonly" readonly="">
                <%}%>
            <%}%>
            


                <%if(attivita_precedente!=null){%>
                    <div class='etichetta'>Durata</div>
                    <div class="valore">
                        <input type='number' value='<%=attivita_precedente.getDurata()%>' id='precedente_durata' readonly="true" tabindex="-1">
                    </div>

                    <div class='etichetta'>Risorsa</div>
                    <div class="valore">
                        <input type='hidden' value='<%=attivita_precedente.getRisorsa().getId()%>' id='precedente_risorsa' readonly="true" tabindex="-1" class='readonly'> 
                        <input type='text' value='<%=attivita_precedente.getRisorsa().stampa()%>' readonly="true" tabindex="-1">                            
                    </div>



                    <%if(precedente_tipo.equals("dopo")){%>
                        <div class="etichetta">Scostamento</div>
                        <div class="valore">
                            <input type="number" id="scostamento" name="scostamento" value='0' class="float-left">
                            <p class="italic" class="float-left">                                
                                - valore positivo (ad es. 2.5)  per posticipare l'inizio rispetto all'attività precedente
                                <br>- valore negativo (ad es. -3.5) per anticipare l'inizio rispetto all'attività precedente
                            </p>
                        </div>                                 
                    <%}%>
                    <%if(precedente_tipo.equals("insieme")){%>                        
                        <input type="hidden" id="scostamento" name="scostamento" value='-<%=attivita_precedente.getDurata()%>' class="float-left readonly">                        
                    <%}%>
                <%}%>

                   
                <%if(!precedente_tipo.equals("")){%>
                    <div class="etichetta">Risorsa</div>                
                    <div class="valore">
                        <%if(risorse.size()>0){%>
                            <select id="risorsa" name="risorsa" style='width: calc(85% - 10px)'>
                                <option value="">Seleziona la risorsa</option>
                                <%for(int indice_risorse=0;indice_risorse<risorse.size();indice_risorse++){
                                    Risorsa risorsa=risorse.get(indice_risorse);
                                    %>
                                        <option value="<%=risorsa.getId()%>" <%if(indice_risorse==0 && risorse.size()==1){%> selected="true"<%}%>><%=risorsa.getCodice()%> <%=risorsa.getNome()%></option>
                                <%}%>
                            </select>
                        <%}else{%>
                            Nessuna risorsa disponibile per la configurazione selezionata!
                        <%}%>
                    </div>
                <%}%>

                <div class="clear"></div>

                <input type="hidden" name="qta_ordine_fornitore" >
                <input type="hidden" name="prezzo_ordine_fornitore">
                
            
            <div class="etichetta">Note</div>
            <div class="valore">
                <textarea id="note" name="note"></textarea>
            </div>

            <button class="pulsante float-right nuovo" type="button" onclick="da_programmare();">Conferma</button>
            
            </div>
        </div> 
                
    <%}%>
    
    
    </div>
    
    </form>
    
 
    
    
    
    <div class="clear"></div>

    