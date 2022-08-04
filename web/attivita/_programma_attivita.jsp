<%@page import="gestioneDB.GestioneCalendario"%>
<%@page import="java.sql.CallableStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="gestioneDB.DBConnection"%>
<%@page import="beans.Risorsa"%>
<%@page import="beans.Attivita"%>
<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="java.util.ArrayList"%>
<%@page import="utility.Utility"%>
<%
    String id_attivita=Utility.eliminaNull(request.getParameter("id_attivita"));
    String new_inizio=Utility.eliminaNull(request.getParameter("new_inizio"));
    if(!new_inizio.equals(""))
        new_inizio=new_inizio+":00";    
    Attivita attivita=GestionePlanning.getIstanza().ricercaAttivita(" attivita.id="+id_attivita).get(0);
    
    String prima_data_planning=Utility.getIstanza().querySelect("SELECT DATE(min(inizio)) as prima_data_planning FROM planning WHERE 1 ORDER BY inizio DESC LIMIT 0,1", "prima_data_planning");
    
    
    ArrayList<String> orari=Utility.getIstanza().lista_orari();

    String id_risorsa=attivita.getRisorsa().getId();

    
    Attivita attivita_precedente=GestionePlanning.getIstanza().ricerca_attivita(" "
            + "attivita.id!="+id_attivita+" AND "
            + "attivita.commessa="+Utility.isNull(attivita.getCommessa().getId())+" AND "
            + "(attivita.seq+0.01)="+attivita.getSeq()+" AND attivita.stato='1' "
            + "AND attivita.situazione!='' "
            + "ORDER BY attivita.FINE LIMIT 0,1");
    
    String inizio_minimo="";
    String inizio_minimo_data="";
    String inizio_minimo_orario="";
    if(attivita_precedente!=null){
        inizio_minimo=GestionePlanning.getIstanza().inizio_min(id_attivita);
    }
    
    String data_ora_corrente=Utility.dataOraCorrente_String();
    
    if(inizio_minimo.equals(""))
        inizio_minimo=data_ora_corrente;    
    
    if(Utility.viene_prima(inizio_minimo, data_ora_corrente) && !inizio_minimo.equals(data_ora_corrente)){                    
        inizio_minimo=Utility.getIstanza().getValoreByCampo("planning","inizio"," inizio>=NOW() AND valore!='-1' AND risorsa="+Utility.isNull(id_risorsa) +" ORDER BY inizio ASC LIMIT 0,1 ");    
    }                        
    
    inizio_minimo_data=Utility.substring_data(inizio_minimo);        
    inizio_minimo_orario=Utility.substring_orario(inizio_minimo); 
  
    String ultima_data_planning=Utility.getIstanza().querySelect("SELECT DATE(max(inizio)) as ultima_data_planning FROM planning WHERE 1 ORDER BY inizio DESC LIMIT 0,1", "ultima_data_planning");
    ultima_data_planning=Utility.dataFutura(ultima_data_planning, 1);
    

%>

    <script type="text/javascript">
        
        function riprogramma_attivita(){
            var data_programma_attivita=$("#data_programma_attivita").val();
            var orario_programma_attivita=$("#orario_programma_attivita").val();
            var new_inizio=data_programma_attivita+" "+orario_programma_attivita;            
            programma_attivita('<%=id_attivita%>',new_inizio);
        }
         
        function seleziona_data_orario(arg){
            var data=$("#data_"+arg).val();
            var orario=$("#orario_"+arg).val();
            
            $("#data_programma_attivita").val(data);
            $("#orario_programma_attivita").val(orario);
            
            $("#div_programma_attivita_inner").html("");
            if(arg==="3"){
                $("#data_programma_attivita").show();
                $("#orario_programma_attivita").show();
                $("#div_attivita_su_risorsa").hide();                
            }
            if(arg==="4"){
                $("#div_attivita_su_risorsa").show();                
            }
            
            if(arg==="1" || arg==="2"){
                $("#data_programma_attivita").hide();
                $("#orario_programma_attivita").hide();
                $("#div_attivita_su_risorsa").hide();                
            }
            verifica_disponibilita();                
        }


        function programma_dopo(new_inizio_input){                        
            $.ajax({
                type: "POST",
                url: "<%=Utility.url%>/attivita/__programma_dopo.jsp",
                data: "id_attivita=<%=id_attivita%>&new_inizio="+encodeURIComponent(String(new_inizio_input)),
                dataType: "html",
                success: function(new_inizio){
                    programma_attivita('<%=id_attivita%>',new_inizio);
                },
                error: function(){
                    alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE programma_dopo");
                }
            });
	
        }

        function verifica_disponibilita(){
            var data_programma_attivita=$("#data_programma_attivita").val();
            var orario_programma_attivita=$("#orario_programma_attivita").val();            
            if(data_programma_attivita!=="" && orario_programma_attivita!==""){
                mostraloader("Verifica disponibilità in corso...");
                var new_inizio=data_programma_attivita+" "+orario_programma_attivita;
                $("#div_programma_attivita").load("<%=Utility.url%>/attivita/_programma_attivita.jsp?id_attivita=<%=id_attivita%>&new_inizio="+encodeURIComponent(String(new_inizio))+" #div_programma_attivita_inner",
                function(){
                    $("#pulsante_programma_attivita").show();
                    nascondiloader();
                });
            }                        
        }

    </script>

    <div class='box'>
        
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

        <div class="etichetta">Situazione</div>
        <div class="valore">
            <%if(attivita.is_da_programmare()){%>
                <div class="tag float-left da_programmare">Da Programmare</div>
            <%}%>
            <%if(attivita.is_in_programmazione()){%>
                <div class="tag float-left in_programmazione">In Programmazione</div>
            <%}%>
        
        </div>
        
        <%if(attivita.is_in_programmazione()){%>
            <div class="etichetta">Inizio / Fine / Durata</div>
            <div class="valore">
                <span style="width: 120px;float: left;"><%=attivita.getInizio_it()%></span> 
                <span style="width: 120px;margin-left: 10px;float: left;"><%=attivita.getFine_it()%></span>
                <span style="width: 120px;margin-left: 10px;float: left;"><%=Utility.elimina_zero(attivita.getDurata())%> h</span>
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
      
      
        <%if(attivita_precedente!=null){%>
            <div class="box">                            
                <div class="etichetta">Attività Precedente</div>
                <div class="valore">                                
                    <%=attivita_precedente.getDescrizione()%>
                    <div class="clear"></div>
                    <div class="tag float-left"><%=attivita_precedente.getRisorsa().getCodice()%> <%=attivita_precedente.getRisorsa().getNome()%></div> 
                    <div class="tag float-left" style="margin-left: 5px"> <%=Utility.elimina_zero(attivita_precedente.getDurata())%> h</div>
                    <div class="tag float-left" style="margin-left: 5px">Seq <%=Utility.elimina_zero(attivita_precedente.getSeq())%></div>                    
                   <%=attivita_precedente.getInizio_it()%> - <%=attivita_precedente.getFine_it()%>
               </div>

               <div class="etichetta">Inizio Minimo</div>
               <div class="valore"><span><%=Utility.convertiDatetimeFormatoIT(inizio_minimo)%></span></div>         
            </div>
         <%}%>
        
              
         
        
    </div>
    
    <div class='box'>

        <table class="tabella">            
            <%if(attivita_precedente!=null){%>  
                <tr>
                    <td>
                        <input type="radio" id="data_ora_1" name="opzione" value="data_ora_1" onclick="seleziona_data_orario('1')">
                        <label for="data_ora_1">In coda al precedente</label>
                    </td>
                    <td style="width: 500px">
                        
                    </td>
                    <td>
                        <input type="date" id="data_1" value="<%=inizio_minimo_data%>" readonly="true" tabindex="-1" style="pointer-events: none">
                        <input type="text" id="orario_1" value="<%=inizio_minimo_orario%>" readonly="true" tabindex="-1" style="pointer-events: none">                         
                    </td>                    
                </tr>
            <%}else{%>
                <tr>
                    <td></td>
                    <td colspan="2">Nessuna attività precedente</td>
                </tr>
            <%}%>            
            
            <%
            
                ArrayList<Attivita> lista_attivita_su_risorsa=GestionePlanning.getIstanza().ricercaAttivita(" "
                    + "attivita.id!="+id_attivita+" AND attivita.situazione="+Utility.isNull(Attivita.INPROGRAMMAZIONE)+" AND "
                    + "((attivita.inizio<="+Utility.isNull(inizio_minimo)+" AND attivita.fine>="+Utility.isNull(inizio_minimo)+" ) OR attivita.inizio>="+Utility.isNull(inizio_minimo)+" ) AND "
                    + "attivita.risorsa="+Utility.isNull(id_risorsa)+" AND attivita.stato='1' ORDER BY attivita.inizio ASC ");
                if(lista_attivita_su_risorsa.size()>0){
            %>
            
            <tr>
                <td style="vertical-align: top">
                    <input type="radio" id="data_ora_4" name="opzione" value="data_ora_4" onclick="seleziona_data_orario('4')">
                    <label for="data_ora_4">Programma Dopo</label>                
                </td>
                <td colspan="2">
                    <div id="div_attivita_su_risorsa" style="display: none">
                        <table class="tabella">
                            <tr>
                                <th colspan="2">Cliente</th>
                                <th >Commessa</th>                                
                                <th>Inizio</th>
                                <th>Fine</th>
                                <th>Durata</th>
                                <th>Data Consegna</th>
                                <th></th>
                            </tr>
                            <%                                
                                for(Attivita attivita_su_risorsa:lista_attivita_su_risorsa){%>
                                    <tr>
                                        <td>
                                            <div class="ball" style="background-color: <%=attivita_su_risorsa.getCommessa().getColore()%>"></div>
                                        </td>
                                        <td>
                                            <%=attivita_su_risorsa.getCommessa().getSoggetto().getAlias()%>
                                        </td>
                                        <td>
                                            <span style="font-weight: bold;">
                                            <%=attivita_su_risorsa.getCommessa().getNumero()%>
                                            <%=attivita_su_risorsa.getCommessa().getDescrizione()%>
                                            </span>
                                            <br>
                                            <span style="font-size: 11px;font-style: italic;"><%=attivita_su_risorsa.getNote()%></span>
                                        </td>
                                        
                                        <td><%=attivita_su_risorsa.getInizio_it()%></td>
                                        <td><%=attivita_su_risorsa.getFine_it()%></td>
                                        <td><%=Utility.elimina_zero(attivita_su_risorsa.getDurata())%> h</td>
                                        <td>
                                            <%=attivita_su_risorsa.getCommessa().getData_consegna_it()%>
                                        </td>
                                        <td>
                                            <button class="pulsante_tabella" onclick="programma_dopo('<%=attivita_su_risorsa.getFine()%>')"><img src="<%=Utility.url%>/images/v.png">Seleziona</button>
                                        </td>
                                    </tr>
                            <%}%>
                        </table>
                        </div>
                </td>
            </tr>
            <%}%>
            <%
                String data_orario_5=Utility.getIstanza().querySelect("SELECT inizio FROM planning WHERE risorsa="+Utility.isNull(id_risorsa)+" AND valore='1' "
                        + "AND inizio>="+Utility.isNull(inizio_minimo)+" ORDER BY inizio ASC LIMIT 0,1", "inizio");
             
                if(data_orario_5.equals("")){
                    String data_crea_planning=GestioneCalendario.getIstanza().ultima_data_calendario();
                    data_crea_planning=Utility.dataFutura(data_crea_planning, 1);
                    GestionePlanning.getIstanza().creaPlanning(data_crea_planning);
                    data_orario_5=Utility.getIstanza().querySelect("SELECT inizio FROM planning WHERE risorsa="+Utility.isNull(id_risorsa)+" AND valore='1' "
                        + "AND inizio>="+Utility.isNull(inizio_minimo)+" ORDER BY inizio ASC LIMIT 0,1", "inizio");
                }
                String data_5=data_orario_5.substring(0,10);
                String orario_5=data_orario_5.substring(11,16);
            %>
                <tr>
                     <td colspan='2'>
                        <input type="radio" id="data_ora_5" name="opzione" value="data_ora_5" onclick="seleziona_data_orario('5')">
                        <label for="data_ora_5">Prima cella disponibile</label>
                    </td>
                    <td>
                        <input type="date" id="data_5" value="<%=data_5%>" readonly="true" tabindex="-1" style="pointer-events: none">
                        <input type="text" id="orario_5" value="<%=orario_5%>" readonly="true" tabindex="-1" style="pointer-events: none">                          
                    </td>  
                </tr>                    
            <%
            String data_orario_2_ultima_attivita=Utility.getIstanza().querySelect("SELECT fine FROM attivita WHERE risorsa="+Utility.isNull(id_risorsa)+" AND stato='1' AND situazione="+Utility.isNull(Attivita.INPROGRAMMAZIONE)+" ORDER BY fine DESC LIMIT 0,1","fine");
                if(!data_orario_2_ultima_attivita.equals("")){
                String data_orario_2=Utility.getIstanza().querySelect("SELECT min(inizio) as data_orario_2 FROM planning WHERE inizio>="+Utility.isNull(data_orario_2_ultima_attivita)+" AND risorsa="+id_risorsa+" AND valore='1' ","data_orario_2");
                String data_2=data_orario_2.substring(0,10);
                String orario_2=data_orario_2.substring(11,16);
            %>            
            <tr>
                <td colspan='2'>
                    <input type="radio" id="data_ora_2" name="opzione" value="data_ora_2" onclick="seleziona_data_orario('2')">
                    <label for="data_ora_2">In coda alla risorsa</label>
                </td>
                <td>
                    <input type="date" id="data_2" value="<%=data_2%>" readonly="true" tabindex="-1" style="pointer-events: none">
                    <input type="text" id="orario_2" value="<%=orario_2%>" readonly="true" tabindex="-1" style="pointer-events: none">                          
                </td>    
            </tr>          
             <%}%>
            <tr>
                <td>
                    <input type="radio" id="data_ora_3" name="opzione" value="data_ora_3" onclick="seleziona_data_orario('3')" >
                    <label for="data_ora_3">Altro</label>
                </td>
                <td colspan='2'>
                    <input type='date' id='data_programma_attivita' onchange="verifica_disponibilita()" style="display: none" min="<%=prima_data_planning%>" >
                    <select id="orario_programma_attivita"  onchange="verifica_disponibilita()" style="display: none">
                        <option value=''></option>
                        <%for(String orario:orari){%>
                            <option value='<%=orario%>'><%=orario%></option>
                        <%}%>
                    </select>
                </td>                
            </tr>           
            <tr>
                <td></td>
                <td colspan="2">
                <div id="div_programma_attivita">
                   <div id="div_programma_attivita_inner">

                    <%                        
                    if(!new_inizio.equals("")){                                                      
                        boolean errore=false;
                        
                        if(Utility.viene_prima(new_inizio, prima_data_planning+" 00:00:00")  || Utility.viene_prima(ultima_data_planning+" 00:00:00",new_inizio)){
                            errore=true;%>
                            <div class="errore">
                                Impossibile programmare l'attività nella data/ora selezionata.
                                <br>
                                Planning non è disponibile                                 
                            </div>
                        <%}
                        if(!inizio_minimo.equals("")){
                            if(Utility.viene_prima(new_inizio, inizio_minimo) && Utility.viene_prima(new_inizio, prima_data_planning+" 00:00:00")){
                                errore=true;
                                %>
                                <div class="errore">
                                    Impossibile programmare l'attività nell'orario selezionato poichè è antecedente all'inizio minimo in base alla sequenza 
                                    <br>
                                    È possibile programmare a partire dal <%=Utility.convertiDatetimeFormatoIT(inizio_minimo)%>                            
                                </div>
                            <%}
                        }
                        
                        if(errore==false){
                            String risorsa_disponibile=Utility.getIstanza().getValoreByCampo("planning", "valore", " planning.risorsa="+Utility.isNull(id_risorsa)+" AND inizio="+Utility.isNull(new_inizio));
                            
                            if(risorsa_disponibile.equals("-1")){%>
                                <div class='height5'></div>
                                    <div class="errore">
                                        Risorsa non attiva nell'orario selezionato
                                    </div>
                                <div class='height5'></div>
                            <%}else{
                                Attivita attivita_data_ora=GestionePlanning.getIstanza().ricerca_attivita(" "
                                    + "attivita.id!="+Utility.isNull(attivita.getId())+" AND "
                                    + "attivita.risorsa="+Utility.isNull(attivita.getRisorsa().getId())+" AND "
                                    + "attivita.inizio<="+Utility.isNull(new_inizio)+" AND "
                                    + "attivita.fine>"+Utility.isNull(new_inizio)+" AND attivita.stato='1' ");
                                if(attivita_data_ora!=null){%>                                                                        
                                    <div class='box'>
                                        <div class="errore">
                                            Nell'orario selezionato è già programmata un'altra attività
                                        </div>
                                        <div class='height5'></div>
                                        
                                        <div class='etichetta'>Commessa</div>
                                        <div class='valore'><span><%=attivita_data_ora.getCommessa().getNumero()%> <%=attivita_data_ora.getCommessa().getDescrizione()%></span></div>
                                        
                                        <div class='etichetta'>Cliente</div>
                                        <div class='valore'><span><%=attivita_data_ora.getCommessa().getSoggetto().getAlias()%></span></div>
                                        
                                        <div class='etichetta'>Inizio / Fine Durata</div>
                                        <div class='valore'>
                                            <span style='width: 120px;float: left;'><%=attivita_data_ora.getInizio_it()%></span>                                             
                                            <span style='width: 120px;margin-left: 5px;float: left;'><%=attivita_data_ora.getFine_it()%></span>                                            
                                            <span style='width: 25px;margin-left: 5px;float: left;'><%=Utility.elimina_zero(attivita_data_ora.getDurata())%> h</span>                                            
                                        </div>
                                        
                                    </div>
                                <%}%>              
                                <div class="height5"></div>                                
                                <button class="pulsante float-right planning" id="pulsante_programma_attivita" style="display:none" onclick="riprogramma_attivita()"><img src="<%=Utility.url%>/images/planning.png">Programma</button>                            
                            <%}%>      
                        <%}%>      
                    <%}%>                
                </div>            
            </div>       
            </td>
        </tr>
    </table>
    </div>
    
    

