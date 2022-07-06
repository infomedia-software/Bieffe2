<%@page import="gestioneDB.GestioneFasiProduzione"%>
<%@page import="beans.Reparto"%>
<%@page import="gestioneDB.GestioneReparti"%>
<%@page import="beans.Attivita"%>
<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="gestioneDB.GestioneFasi_Input"%>
<%@page import="beans.Fase_Input"%>
<%@page import="java.util.ArrayList"%>
<%@page import="gestioneDB.GestioneFasi"%>
<%@page import="beans.Fase"%>
<%@page import="beans.Risorsa"%>
<%@page import="gestioneDB.GestioneRisorse"%>
<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
    String id=Utility.eliminaNull(request.getParameter("id"));
    Risorsa risorsa=GestioneRisorse.getIstanza().ricercaRisorse(" risorse.id="+Utility.isNull(id)).get(0);
    
    Fase fase=GestioneFasi.getIstanza().ricerca(" id="+risorsa.getFase().getId()).get(0);
    
    ArrayList<Fase> fasi=GestioneFasi.getIstanza().ricerca("");
    
    ArrayList<Fase_Input> fasi_input=GestioneFasi_Input.getIstanza().ricerca(" fase="+Utility.isNull(fase.getId())+" ");

    
    ArrayList<Attivita> attivita_su_risorsa=GestionePlanning.getIstanza().ricercaAttivita(" fasi.id="+id+" AND attivita.stato='1' AND "
            + "(attivita.situazione="+Utility.isNull(Attivita.INPROGRAMMAZIONE)+" OR attivita.situazione="+Utility.isNull(Attivita.INPROGRAMMAZIONE)+")");
    
    

%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%=risorsa.getNome()%> | <%=Utility.nomeSoftware%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
        
        <script type="text/javascript">
            function modificarisorsa(inField){
                var newvalore=inField.value;
                var campodamodificare=inField.id;                
                
                if(campodamodificare==="planning"){
                    var temp=$("#"+campodamodificare).is(':checked');
                    newvalore="";
                    if(temp===true){
                        newvalore="si";                       
                    }
                    mostraloader("Aggiornamento del planning in corso....");
                }
                
                if(campodamodificare.startsWith("inizio") || campodamodificare.startsWith("fine")){
                    mostraloader("Aggiornamento orari in corso...");
                }
                
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/risorse/__modificarisorsa.jsp",
                    data: "new_valore="+encodeURIComponent(String(newvalore))+"&campo_da_modificare="+campodamodificare+"&id=<%=id%>",
                    dataType: "html",
                    success: function(msg){
                        if(campodamodificare==="fase"){
                            location.reload();
                        }
                        if(campodamodificare==="planning"){
                            nascondiloader();
                        }
                        if(campodamodificare.startsWith("inizio") || campodamodificare.startsWith("fine")){
                            $("#div_orari").load("<%=Utility.url%>/risorse/risorsa.jsp?id=<%=id%> #div_orari_inner",function(){nascondiloader();})
                        }
                    },
                    error: function(){
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE modificarisorsa()");
                    }
                });
            }
            
            
            
            
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
                            location.href='<%=Utility.url%>/risorse/risorse.jsp';
                        },
                        error: function(){
                            alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE modificarisorsa()");
                        }
                    });		
                }
            }

            function selezionatutti(){
                $('.checkbox_fasi_cat').attr('checked',true);       
                aggiornaprodottoclienti();
            }

            function deselezionatutti(){
                $('.checkbox_fasi_cat').attr('checked',false);       
                aggiornaprodottoclienti();
            }

            $(function(){
                $('.checkbox_fasi_input').change(function() {        
                    aggiorna_fasi_input();
                });
                $('.checkbox_fasi_produzione').change(function() {        
                    aggiorna_fasi_produzione();
                });
                $('.checkbox_reparti').change(function() {        
                    aggiorna_reparti();
                });
            });
            
            function aggiorna_fasi_input(){
                var selected = [];
                $('.checkbox_fasi_input:checked').each(function() {
                    selected.push($(this).attr('id'));
                });      

                var new_valore=selected;
                var campo_da_modificare="fasi_input";
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/risorse/__modificarisorsa.jsp",
                    data: "new_valore="+encodeURIComponent(String(new_valore))+"&campo_da_modificare="+campo_da_modificare+"&id=<%=id%>",
                    dataType: "html",
                    success: function(msg){

                    },
                    error: function(){
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE modificarisorsa()");
                    }
                });
            }
            
            function aggiorna_fasi_produzione(){
                var selected = [];
                $('.checkbox_fasi_produzione:checked').each(function() {
                    selected.push($(this).attr('id'));
                });      
                var new_valore=selected;
                var campo_da_modificare="fasi_produzione";
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/risorse/__modificarisorsa.jsp",
                    data: "new_valore="+encodeURIComponent(String(new_valore))+"&campo_da_modificare="+campo_da_modificare+"&id=<%=id%>",
                    dataType: "html",
                    success: function(msg){

                    },
                    error: function(){
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE modificarisorsa()");
                    }
                });
            }



            function aggiorna_reparti(){
                var selected = [];
                $('.checkbox_reparti:checked').each(function() {
                    selected.push($(this).attr('id'));
                });      

                var new_valore=selected;
                var campo_da_modificare="reparti";
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/risorse/__modificarisorsa.jsp",
                    data: "new_valore="+encodeURIComponent(String(new_valore))+"&campo_da_modificare="+campo_da_modificare+"&id=<%=id%>",
                    dataType: "html",
                    success: function(msg){

                    },
                    error: function(){
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE modificarisorsa()");
                    }
                });
            }


            
        </script>
        
        
    </head>
    <body>
        <jsp:include page="../_menu.jsp"></jsp:include>
        <div id="container">
            
            
            <h1><%=risorsa.getNome()%></h1>
            
       
            
            <div class="box" id="schedadettagli" >
                
                    <div class="etichetta">Codice</div>
                    <div class="valore">
                        <input type="text" id="codice" value="<%=risorsa.getCodice()%>" onchange="modificarisorsa(this);"> 
                    </div>


                    <div class="etichetta">Nome</div>
                    <div class="valore">
                        <input type="text" id="nome" value="<%=risorsa.getNome()%>" onchange="modificarisorsa(this);"> 
                    </div>

                                        

                   <div id="div_orari">
                       <div id="div_orari_inner">                                                     
                           
                            <!-- Turno 1 -->
                            <%
                                int ora=0;
                                int indice=0;                                
                            %>                                               
                            <div class="etichetta">Turno 1</div>
                            <div class="valore">
                                <select id="inizio" style="width: 80px;" onchange="modificarisorsa(this)">
                                    
                                    <%
                                    String orario_selezionato=risorsa.getInizio();
                                    for(int i=0;i<48;i++){
                                        String orario=ora+"";                                    
                                        if(ora<10){orario="0"+orario;};
                                        if(i%2==0){orario=orario+":00";}
                                        if(i%2!=0){orario=orario+":30";ora++;}                                                                                
                                        if(orario.equals(risorsa.getFine())){break;}
                                        %>                                        
                                        <option value="<%=orario%>" <%if(orario.equals(orario_selezionato)){ indice=i;%>selected="true"<%}%> ><%=orario%></option>
                                    <%}
                                    indice++;
                                    %>
                                </select>                                
                                <select id="fine" style="width: 80px;" onchange="modificarisorsa(this)">
                                    
                                    <%                                    
                                    orario_selezionato=risorsa.getFine();
                                    for(int i=indice;i<48;i++){                                        
                                        String orario=((int)i/2)+"";                                    
                                        if(ora<10){orario="0"+orario;};
                                        if(i%2==0){orario=orario+":00";}
                                        if(i%2!=0){orario=orario+":30";ora++;}                                        
                                        if(orario.equals(risorsa.getInizio2())){break;}
                                        if(i>=indice){%>
                                            <option value="<%=orario%>" <%if(orario.equals(orario_selezionato)){ indice=i;%>selected="true"<%}%> ><%=orario%></option>
                                        <%}%>
                                    <%}
                                    indice++;%>
                                </select>
                                
                            </div>
                            
                            <div class="etichetta">Turno 2</div>
                            <div class="valore">
                                <select id="inizio2" style="width: 80px;" onchange="modificarisorsa(this)">
                                    <option value=""></option>
                                    <%                                    
                                    orario_selezionato=risorsa.getInizio2();
                                    for(int i=indice;i<48;i++){                                        
                                        String orario=((int)i/2)+"";                                    
                                        if(i<20){orario="0"+orario;};
                                        if(i%2==0){orario=orario+":00";}
                                        if(i%2!=0){orario=orario+":30";ora++;}                                        
                                        if(orario.equals(risorsa.getFine2())){break;}
                                        if(i>=indice){%>
                                            <option value="<%=orario%>" <%if(orario.equals(orario_selezionato)){ indice=i;%>selected="true"<%}%> ><%=orario%></option>
                                        <%}%>
                                    <%}
                                    indice++;%>
                                </select>
                                
                                <select id="fine2" style="width: 80px;" onchange="modificarisorsa(this)">
                                    <option value=""></option>
                                    <%                                    
                                    orario_selezionato=risorsa.getFine2();
                                    for(int i=indice;i<48;i++){                                        
                                        String orario=((int)i/2)+"";                                    
                                        if(i<20){orario="0"+orario;};
                                        if(i%2==0){orario=orario+":00";}
                                        if(i%2!=0){orario=orario+":30";ora++;}                                        
                                        if(orario.equals(risorsa.getInizio3())){break;}
                                        if(i>=indice){%>
                                            <option value="<%=orario%>" <%if(orario.equals(orario_selezionato)){ indice=i;%>selected="true"<%}%> ><%=orario%></option>
                                        <%}%>
                                    <%}
                                    indice++;%>
                                </select>                           
                            </div>
                                
                            <div class="etichetta">Turno 3</div>
                            <div class="valore">
                            <select id="inizio3" style="width: 80px;" onchange="modificarisorsa(this)">
                                <option value=""></option>
                                <%                                    
                                orario_selezionato=risorsa.getInizio3();
                                for(int i=indice;i<48;i++){                                        
                                    String orario=((int)i/2)+"";                                    
                                    if(i<20){orario="0"+orario;};
                                    if(i%2==0){orario=orario+":00";}
                                    if(i%2!=0){orario=orario+":30";ora++;}                                        
                                    if(orario.equals(risorsa.getFine3())){break;}
                                    if(i>=indice){%>
                                        <option value="<%=orario%>" <%if(orario.equals(orario_selezionato)){ indice=i;%>selected="true"<%}%> ><%=orario%></option>
                                    <%}%>
                                <%}
                                indice++;%>
                            </select>                            
                            <select id="fine3" style="width: 80px;" onchange="modificarisorsa(this)">
                                <option value=""></option>
                                <%                                    
                                orario_selezionato=risorsa.getFine3();
                                for(int i=indice;i<48;i++){                                        
                                    String orario=((int)i/2)+"";                                    
                                    if(i<20){orario="0"+orario;};
                                    if(i%2==0){orario=orario+":00";}
                                    if(i%2!=0){orario=orario+":30";ora++;}                                                                                                                
                                    if(i>=indice){%>
                                        <option value="<%=orario%>" <%if(orario.equals(orario_selezionato)){ indice=i;%>selected="true"<%}%> ><%=orario%></option>
                                    <%}%>
                                <%}
                                indice++;%>
                            </select>                           
                        </div>
                    </div>
                </div>
                            

                 
                    <div class="etichetta">Note</div>
                    <div class="valore">
                        <textarea id="note" onchange="modificarisorsa(this);"><%=risorsa.getNote()%></textarea>
                    </div>
         
                    
                    <div class="etichetta">Reparto</div>                        
                    <%for(Reparto reparto:GestioneReparti.getIstanza().ricerca("")){%>
                        <div class="float-left" style="margin-right: 15px;height: 35px;line-height: 35px;">
                            <input type="checkbox" style="height: 20px;width: 20px" class="checkbox_reparti" id="<%=reparto.getId()%>"
                            <%if(risorsa.getReparti().contains(reparto.getId()+",") || risorsa.getReparti().endsWith(reparto.getId()+"")){%>
                                checked="true"
                            <%}%>
                            ><%=reparto.getNome()%>
                        </div>
                    <%}%>                        
                    <div class="clear"></div>
                  
                    <div class='etichetta'>In Planning</div>
                    <div class="valore">
                        <input type="checkbox" id='planning' value='si' onchange="modificarisorsa(this)" <%if(risorsa.getPlanning().equals("si")){%>checked="true"<%}%> >
                    </div>
                    
                    
                    <%if(attivita_su_risorsa.size()>0){%>
                        <p class="errore clear">
                            Impossibile modificare fase/sottofasi associate alla risorsa.<br>
                            Risultano nr <%=attivita_su_risorsa.size()%> attività pianificate su tale risorsa.
                        </p>
                    <%}%>
                    
                    <div <%if(attivita_su_risorsa.size()>0){%>style="pointer-events: none"<%}%>>
                        <div class="etichetta">
                            Fase
                        </div>
                        <div class="valore">
                            <select id="fase" onchange="modificarisorsa(this);" >
                                <option value="">Seleziona la Fase</option>
                                <%for(Fase f:fasi){%>                                  
                                    <option value="<%=f.getId()%>"  <%if(risorsa.getFase().getId().equals(f.getId())){%> selected="true"<%}%> ><%=f.getCodice()%> <%=f.getNome()%></option>
                              <%}%>                        
                            </select>
                        </div>
                </div>
            </div>
            <div class="box">
                <h2>Sottofasi Preventivo</h2>
                <table class="tabella">
                    <tr>                                                        
                        <th style="width: 40px"></th>
                        <th style='width: 125px'>Codice</th>
                        <th>Descrizione</th>
                    </tr>
                    <%for(Fase_Input fase_input:fasi_input){%>
                        <tr>
                            <td>
                                <input type="checkbox" id="<%=fase_input.getId()%>"  class="checkbox_fasi_input"
                                    <%if(risorsa.getFasi_input().contains(fase_input.getId()+",") || risorsa.getFasi_input().endsWith(fase_input.getId()+"")){%>
                                    checked="true"
                                <%}%>>                                                                       
                            </td>
                            <td><%=fase_input.getCodice()%></td>
                            <td><%=fase_input.getNome()%></td>
                        </tr>
                    <%}%>

                </table>
            </div>
            <div class="box">            
                <h2>Sottofasi Produzione</h2>
                <table class="tabella">
                    <tr>
                        <th style="width: 40px"></th>
                        <th style='width: 125px'>Codice</th>
                        <th>Descrizione</th>
                    </tr>
                    <%for(Fase_Input fase_produzione:GestioneFasiProduzione.getIstanza().ricerca("")){%>
                        <tr>
                            <td>
                                <input type="checkbox" id="<%=fase_produzione.getId()%>"  class="checkbox_fasi_produzione"
                                    <%if(risorsa.getFasi_produzione().contains(fase_produzione.getId()+",") || risorsa.getFasi_produzione().endsWith(fase_produzione.getId()+"")){%>
                                    checked="true"
                                <%}%>>                                                                       
                            </td>
                            <td><%=fase_produzione.getCodice()%></td>
                            <td><%=fase_produzione.getNome()%></td>
                        </tr>
                    <%}%>
                </table>
                <div class="clear"></div>

            </div>

        </div>
    </body>
</html>
