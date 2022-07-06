<%@page import="java.util.ArrayList"%>
<%@page import="beans.Attivita"%>
<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="utility.Utility"%>
<%
    String id_attivita=Utility.eliminaNull(request.getParameter("id_attivita"));
    Attivita attivita=GestionePlanning.getIstanza().get_attivita(id_attivita);

    Attivita attivita_prec=null;
    Attivita attivita_succ=null;

    double seq_prec=attivita.getSeq()-0.01;
    seq_prec=Math.round(seq_prec*100.0)/100.0;

    double seq_succ=attivita.getSeq()+0.01;       
    seq_succ=Math.round(seq_succ*100.0)/100.0;

    double minimo_scostamento=0;
    double durata_minima=0;

    ArrayList<Attivita> attivita_commessa=new ArrayList<Attivita>();        
            attivita_commessa=GestionePlanning.getIstanza().ricercaAttivita(" "
            + "attivita.commessa="+Utility.isNull(attivita.getCommessa().getId())+" AND "
            + "(attivita.stato='1' OR attivita.stato='taglia') AND "
            + "attivita.situazione!='' "
            +" ORDER BY attivita.seq ASC,attivita.inizio ASC ");        
    for(Attivita attivita_temp:attivita_commessa){            
        if(attivita_temp.getSeq()==seq_prec){
            attivita_prec=attivita_temp;
            minimo_scostamento=-attivita_temp.getDurata();
        }
        if(attivita_temp.getSeq()==seq_succ){
            attivita_succ=attivita_temp;
            if(attivita_temp.getScostamento()<0)
                durata_minima=Math.abs(attivita_temp.getScostamento());
        }
    }
%>

<script type='text/javascript'>
    
    $(function(){
        $("#durata").focus();
        $("#durata").select();
    });
    
    function modifica_durata_attivita(id_attivita,inField){
        
        var newvalore=inField.value;
        var campodamodificare=inField.id;       
        
        var olddurata=$("#olddurata").val();                
        
        var durata_minima=parseFloat($("#durata_minima").val());
        
        if(campodamodificare==="durata"){
            
            if(validazione_durata(newvalore)===false){                                                
                $("#durata").val(olddurata);
                alert("La durata inserita non è corretta");                                        
                return;
            }     
            var durata=parseFloat($("#durata").val());
            var ritardo=parseFloat($("#ritardo").val());                
            if((durata-ritardo)<=0){
                alert("Impossibile impostare un durata inferiore al ritardo.");                
                $("#durata").val(olddurata);
                return;
            }
            
            if(durata<durata_minima){
                alert("La durata inserita non può essere minore dello scostamento minimo dell'attività successiva.\n");                
                $("#durata").val(olddurata);
                return;
            }                        
        }

        if(campodamodificare==="ritardo"){       
            var old_ritardo=$("#old_ritardo").val();                
            if(validazione_ritardo(newvalore)===false){                                                    
                $("#ritardo").val(old_ritardo);
                alert("Il ritardo inserito non è corretto");                                        
                return;
            }                                    
        }

        if(campodamodificare==="scostamento"){
            var old_scostamento=$("#old_scostamento").val();                
            var new_scostamento=parseFloat(newvalore);
            if(validazione_durata(Math.abs(newvalore))===false && new_scostamento!==0){                                                    
                $("#scostamento").val(old_scostamento);
                alert("Lo scostamento inserito non è corretto");                                        
                return;
            }                    

            var min_scostamento=parseFloat($("#min_scostamento").val());                        
            if(new_scostamento<min_scostamento){
                alert("Impossibile impostare uno scostamente negativo superiore alla durata dell'attività precedente.");
                $("#scostamento").val(old_scostamento);
                return;
            }                            
        }
        
        mostraloader("Aggiornamento in corso...");        
        $.ajax({
            type: "POST",
            url: "<%=Utility.url%>/attivita/__modificaattivita.jsp",
            data: "newvalore="+encodeURIComponent(String(newvalore))+"&campodamodificare="+campodamodificare+"&idattivita="+id_attivita,
            dataType: "html",
            success: function(msg){      
                
            },
            error: function(){
                alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE modifica_durata_attivita()" );
            }
        });          
       
    }
</script>


<div style="display: none">
    <input type='text' id='olddurata' value='<%=Utility.elimina_zero(attivita.getDurata())%>'>
    <input type='text' id='old_scostamento' value='<%=Utility.elimina_zero(attivita.getScostamento())%>'>
    <input type='text' id='old_ritardo' value='<%=Utility.elimina_zero(attivita.getRitardo())%>'>

    <input type='text' id='min_scostamento' value='<%=Utility.elimina_zero(minimo_scostamento)%>'>
    <input type='text' id='durata_minima' value='<%=durata_minima%>'>
</div>

<div class="clear"></div>


<div class='width50 float-left'>
    <div class='box'>

        <div class="messaggio">
            Imposta la durata, il ritardo e lo scostamento dell'attività selezionata
        </div>
        
        <div class="etichetta">Durata</div>
        <div class="valore">                        
            <input type="number" id="durata" value="<%=Utility.elimina_zero(attivita.getDurata())%>" step="0.5"  onchange="modifica_durata_attivita('<%=attivita.getId()%>',this);">                    
            <p style="font-size: 9px;font-style: italic">
                La durata è già comprensiva dell'eventuale ritardo        
            <%if(durata_minima>0){%>                
                <br>
                Durata minima consentita: <%=Utility.elimina_zero(durata_minima)%> h                
            <%}%>
            </p>
        </div>

        <div class="etichetta">Ritardo</div>
        <div class="valore">
            <input type="number" id="ritardo" value="<%=Utility.elimina_zero(attivita.getRitardo())%>" step="0.5" onchange="modifica_durata_attivita('<%=attivita.getId()%>',this);">
        </div>

        <%if(attivita_prec!=null){%>
            <div class="etichetta">Scostamento</div>
            <div class="valore">
                <input type="number" id="scostamento" value="<%=Utility.elimina_zero(attivita.getScostamento())%>" step="0.5" onchange="modifica_durata_attivita('<%=attivita.getId()%>',this);">
                <%if(minimo_scostamento<0){%>
                    <p style="font-size: 9px;font-style: italic">
                        Minimo scostamento consentito: <%=Utility.elimina_zero(minimo_scostamento)%> h
                    </p>
                <%}%>            
            </div>
        <%}%>
    </div>
</div>
<div class="width50 float-left">
    <div class="box">
    <div class="etichetta">Commessa</div>
      <div class="valore">
          <span>
              <div class="ball" style="background-color: <%=attivita.getCommessa().getColore()%>"></div>
              <%=attivita.getCommessa().getNumero()%> <%=attivita.getCommessa().getSoggetto().getAlias()%> - <%=attivita.getCommessa().getDescrizione()%></span>
      </div>        

      <div class="etichetta" >Attività</div>
      <div class="valore"><span title="ID Attività: <%=attivita.getId()%>"><%=attivita.getDescrizione()%></span></div>     

      <div class="etichetta">Risorsa</div>
      <div class="valore"><span> <%=attivita.getRisorsa().getCodice()%> <%=attivita.getRisorsa().getNome()%></span></div>

      <%if(attivita.is_in_programmazione()){%>
          <div class="etichetta">Inizio / Fine / Durata</div>
          <div class="valore">
              <span style="width: 120px;float: left;"><%=attivita.getInizio_it()%></span> 
              <span style="width: 120px;margin-left: 10px;float: left;"><%=attivita.getFine_it()%></span>              
          </div>
          <div class="etichetta">Durata</div>
          <div class="valore">
              <span style="width: 120px;"><%=Utility.elimina_zero(attivita.getDurata())%> h</span>
          </div>

          <%if(attivita.getScostamento()!=0){%>
              <div class="width33 float-left">
                  <div class="etichetta">Scostamento</div>
                  <div class="valore">
                      <span><%=Utility.elimina_zero(attivita.getScostamento())%> h</span>                    
                  </div>            
              </div>
          <%}%>
          <div class="width33 float-left">
              <div class="etichetta">Sequenza</div>
              <div class="valore">
                  <span><%=Utility.elimina_zero(attivita.getSeq())%></span>                    
              </div>            
          </div>
          <div class="clear"></div> 
    <%}%>
    </div>
</div>

<div class="height10"></div>

<%if(attivita_prec!=null){%>
    <div class='width50 float-left'>
        <div class="box ">
            <h3>Attività Precedente</h3>                    

            <div class="etichetta">Risorsa</div>
            <div class="valore"><span><%=attivita_prec.getRisorsa().getNome()%></span></div>

            <div class="etichetta">Inizio</div>
            <div class="valore">
                <span><%=attivita_prec.getInizio_it()%></span>                 
            </div>
            
            <div class="etichetta">Fine</div>
            <div class="valore">                
                <span ><%=attivita_prec.getFine_it()%></span>                
            </div>
            
            <div class="etichetta">Durata</div>
            <div class="valore">                
                <span ><%=Utility.elimina_zero(attivita_prec.getDurata())%> h </span>
            </div>

            <div class="etichetta">Scostamento</div>
            <div class="valore"><span ><%=Utility.elimina_zero(attivita_prec.getScostamento())%> h</span></div>
        </div>
    </div>
<%}%>


<%if(attivita_succ!=null){%>
    <div class='width50 float-left'>
        <div class="box">
            <h3>Attività Successiva</h3>                    

            <div class="etichetta">Risorsa</div>
            <div class="valore"><span><%=attivita_succ.getRisorsa().getNome()%></span></div>

            <div class="etichetta">Inizio</div>
            <div class="valore">
                <span><%=attivita_succ.getInizio_it()%></span>                 
            </div>
            
            <div class="etichetta">Fine</div>
            <div class="valore">                
                <span ><%=attivita_succ.getFine_it()%></span>                
            </div>
            
            <div class="etichetta">Durata</div>
            <div class="valore">                
                <span ><%=Utility.elimina_zero(attivita_succ.getDurata())%> h </span>
            </div>
            
            <div class="etichetta">Scostamento</div>
            <div class="valore"><span ><%=Utility.elimina_zero(attivita_succ.getScostamento())%> h</span></div>
        </div>
    </div>
<%}%>        
