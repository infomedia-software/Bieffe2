<%@page import="beans.Utente"%>
<%@page import="java.util.Map"%>
<%@page import="beans.Risorsa"%>
<%@page import="gestioneDB.GestioneRisorse"%>
<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="beans.Attivita"%>
<%@page import="utility.Th"%>
<%@page import="gestioneDB.GestioneCommesse"%>
<%@page import="java.util.ArrayList"%>
<%@page import="utility.Utility"%>
<%@page import="beans.Commessa"%>
<%            
    Utente utente=(Utente)session.getAttribute("utente");
    String query=Utility.eliminaNull(request.getParameter("query"));   
    
    String risorsa=Utility.eliminaNull(request.getParameter("risorsa"));   
    String ordinamento=Utility.eliminaNull(request.getParameter("ordinamento"));   
    if(ordinamento.equals(""))
        ordinamento=" attivita.inizio ASC";
    ArrayList<Attivita> lista_attivita=GestionePlanning.getIstanza().ricercaAttivita(query+" ORDER BY "+ordinamento);
%>
<script type="text/javascript">
    
    function stampa_lista_attivita(ora_corrente){
        var query=$("#query").val();
        if(ora_corrente==="si")
            query=" attivita.fine>=NOW() AND "+query; 
        var ordinamento=$("#ordinamento").val();
        var risorsa=$("#risorsa").val();
        window.open("<%=Utility.url%>/attivita/_stampa_lista_attivita.jsp?query="+encodeURIComponent(String(query))+"&ordinamento="+encodeURIComponent(String(ordinamento))+"&risorsa="+encodeURIComponent(String(risorsa)),"_blank");
    }
   
   $(document).ready(function(){
        $("#search").on("keyup", function() {
          var value = $(this).val().toLowerCase();
          $("#tabella_lista_attivita tbody tr").filter(function() {
            $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
          });
        });
    });
   
 
    function aggiorna_pagina(){
        location.reload();
    }
   
</script>

    <input type="hidden" id="query" value="<%=query%>" >
    <input type="hidden" id="risorsa" value="<%=risorsa%>" >
    <input type="hidden" id="ordinamento" value="<%=ordinamento%>" >
    
    <div class="box">    
        <h3>
        <%if(!risorsa.equals("")){
            Risorsa risorsa_temp=GestioneRisorse.getIstanza().ricercaRisorse(" risorse.id="+Utility.isNull(risorsa)+" ").get(0);%>
            <%=risorsa_temp.getCodice()+" "+risorsa_temp.getNome()+" - "%> 
        <%}%>                
      
            Sono state trovate <%=lista_attivita.size()%> attività                
            <input type="text" id="search" placeholder="Ricerca...." style="padding-left: 5px;float: right;height: 35px;width: 250px;-webkit-border-radius: 3px;-moz-border-radius: 3px;border-radius: 3px;border:1px solid lightgray;">    

            <%if(utente.is_amministratore() || utente.is_ufficio()){%>
                <button class="pulsante float-right" onclick="stampa_lista_attivita('si')">Stampa da Ora Corrente</button>
                <button class="pulsante float-right" onclick="stampa_lista_attivita()">Stampa</button>
            <%}%>
        </h3>
    </div>
    
    <div class="box">

    <table  class="tabella" id="tabella_lista_attivita" >
        <thead>
            <tr>           
                <%if(utente.is_amministratore() || utente.is_ufficio()){%>
                    <th style="width: 40px;"></th>
                    <th></th> 
                <%}%>
                <th ></th>                
                <th style="width: 100px">Inizio</th>
                <th style="width: 65px;">Durata</th>                    
                <th></th>        
                <th>Commessa</th>                        
                <th>Cliente</th>                        
                <th>Descrizione</th>                        
                <th>Q.tà</th>                
                <th style="width: 300px" >Note Attività</th>
            </tr>
        </thead>
        <tbody>
            <%
            double totale=0;    
            if(!query.equals("")){%>
                <%for(Attivita attivita:lista_attivita){%>
                <%
                totale=totale+attivita.getDurata();
                %>
                <tr>
                    <%if(utente.is_amministratore() || utente.is_ufficio()){%>
                        <td>                                            
                            <a href="<%=Utility.url%>/attivita/_attivita.jsp?id=<%=attivita.getId()%>" class="pulsantesmall">                            
                                <img src="<%=Utility.url%>/images/edit.png">
                            </a>                    
                        </td>
                        <td>
                            <a href="<%=Utility.url%>/planning/planning.jsp?data=<%=attivita.getInizioData()%>" class="pulsante_tabella planning" ><img src="<%=Utility.url%>/images/planning.png">Planning</a>
                        </td>
                    <%}%>
                    <td >   
                        <button class="pulsante_tabella 
                            <%if(attivita.is_attiva_infogest()){%> blink attiva<%}%>                                 
                            <%if(attivita.is_completata()){%> green <%}%>
                            " value="" id="attiva_infogest" onclick="mostrapopup('<%=Utility.url%>/attivita/_attiva_attivita.jsp?id_attivita=<%=attivita.getId()%>')" ><img src="<%=Utility.url%>/images/edit.png">Reparto</button>                        
                    </td>                    
                    <td>
                        <div class="float-left">
                            <%=attivita.getInizio_it()%>                                                
                        </div>
                    </td>
                    <td>
                        <div class="tagsmall"><%=Utility.formatta_durata(attivita.getDurata())%> h</div>                    
                    </td>                              
                    <td>
                        <div class="ball float-left" style="height: 20px;width: 20px;background-color:<%=attivita.getCommessa().getColore()%>;"></div>                  
                    </td>
                    <td>
                        
                        <b><%=attivita.getCommessa().getNumero()%></b>
                    </td>
                    <td>
                        <%=attivita.getCommessa().getSoggetto().getAlias()%>
                    </td>
                    <td>
                        <%=attivita.getCommessa().getDescrizione()%>                        
                    </td>                
                    <td>
                        <%if(risorsa.equals("")){%>
                            <b><%=attivita.getRisorsa().getNome()%></b> - 
                        <%}%>
                        <%=Utility.elimina_zero(attivita.getCommessa().getQta())%>
                    </td>                 
                    <td>
                        <%if(!attivita.getNote().equals("null")){%>
                            <textarea id="note" onchange="modifica_attivita('<%=attivita.getId()%>',this)" style="height: 30px;font-size: 11px;line-height: 14px"><%=Utility.standardizzaStringaPerTextArea(attivita.getNote())%></textarea>                        
                        <%}%>
                    </td>  
                </tr>                
            <%}%>
            <tr>
                <%if(!utente.getPrivilegi().equals("reparto") ){%>
                    <th></th>
                <%}%>
                <th></th>
                <th></th>
                <th>
                    <div class="tag " style="text-transform: lowercase !important"><%=Utility.elimina_zero(totale)%> h</div>
                </th>            
                <th colspan="9"></th>
            </tr>
            <%}%>                           
        </tbody>

    </table>

</div>

