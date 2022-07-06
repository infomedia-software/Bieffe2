<%@page import="beans.Commessa"%>
<%@page import="beans.Consegna"%>
<%@page import="java.util.ArrayList"%>
<%@page import="gestioneDB.GestioneCalendarioConsegne"%>
<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    String dal=Utility.eliminaNull(request.getParameter("dal"));
    String al=Utility.eliminaNull(request.getParameter("al"));
    if(dal.equals(""))
        dal=Utility.dataOdiernaFormatoDB();
    if(al.equals(""))
        al=Utility.dataFutura(dal, 3);
    
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Calendario Consegne | <%=Utility.nomeSoftware%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
        
        <script type="text/javascript">
            function ricerca_calendario_consegna(){
                var dal=$("#dal").val();
                var al=$("#al").val();                
                location.href="<%=Utility.url%>/calendario_consegne/calendario_consegne.jsp?dal="+dal+"&al="+al;
            }
            
            function modificacommessa(inField,id_commessa){                
                var newvalore=inField.value;
                var campodamodificare=inField.id;                       
                //alert("modificacommessa>"+campodamodificare+">"+newvalore)
                if(campodamodificare.includes("data") || campodamodificare.includes("consegnata") || campodamodificare.includes("situazione"))
                    mostraloader("Aggiornamento in corso...");
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/commesse/__modificacommessa.jsp",
                    data: "newvalore="+encodeURIComponent(String(newvalore))+"&campodamodificare="+campodamodificare+"&id="+id_commessa,
                    dataType: "html",
                    success: function(msg){
                        if(campodamodificare.includes("data") || campodamodificare.includes("consegnata") || campodamodificare.includes("situazione"))
                            ricerca_calendario_consegna();
                    },
                    error: function(){
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE modificacommessa()");
                    }
                });
            }
            
            function modifica_ordine_fornitore(inField,id_ordine_fornitore){            
                var new_valore=inField.value;
                var campo_da_modificare=inField.id;
                //alert("modifica_ordine_fornitore>"+campo_da_modificare+">"+new_valore);
                if(campo_da_modificare.includes("data") || campo_da_modificare.includes("situazione"))
                    mostraloader("Aggiornamento in corso...");                
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/ordini_fornitore/__modifica_ordine_fornitore.jsp",
                    data: "new_valore="+encodeURIComponent(String(new_valore))+"&campo_da_modificare="+campo_da_modificare+"&id_ordine_fornitore="+id_ordine_fornitore,
                    dataType: "html",
                    success: function(msg){
                        if(campo_da_modificare.includes("data") || campo_da_modificare.includes("situazione") )
                            ricerca_calendario_consegna();
                    },
                    error: function(){
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE modifica_ordine_fornitore");
                    }
                });
            }
            
            
        </script>
        
    </head>
    <body>
        <jsp:include page="../_menu.jsp"></jsp:include>
        <div id="container">
            <h1>Calendario Consegne</h1>
        
            <div class="box" style="width: 600px">
                <div class="etichetta">Dal / Al</div>
                <div class="valore">
                    <input type="date" id="dal" value="<%=dal%>"> / <input type="date" id="al" value="<%=al%>">
                </div>
                <button class="pulsante float-right" onclick="ricerca_calendario_consegna();">
                    <img src="<%=Utility.url%>/images/search.png">
                    Ricerca
                </button>                
            </div>
            
            <div class='height10'></div>
            <%
            String d=dal;
            int indice=1;
            al=Utility.dataFutura(al, 1);
            while(!d.equals(al)){
                ArrayList<Consegna> consegne=GestioneCalendarioConsegne.getIstanza().ricerca(d);
                %>
                <div class="width50 float-left">
                    <div class='box'>
                    <h2><%=Utility.convertiDataFormatoIT(d)%></h2>
                    <table class='tabella'>
                        <thead>
                            <tr>
                                <th style="width: 90px"></th>
                                <th style="width: 125px">Tipologia</th>
                                <th>Data</th>
                                <th>Numero</th>
                                <th>Descrizione</th>
                                <th>Soggetto</th>
                                <th style="width: 25px">ST</th>
                                <th style="width: 25px">AL</th>
                            </tr>                        
                        </thead>                    
                        <%
                        for(Consegna consegna:consegne){                        
                            if(consegna.getTipologia().equals("commessa") || 
                                (consegna.getTipologia().equals("ordine_fornitore") && 
                                    (
                                    (consegna.getData_ritiro().equals(d) && !consegna.getSituazione().equals("uscita_ok") && !consegna.getSituazione().equals("entrata_ok"))  ||
                                    consegna.getData_consegna().equals(d) && !consegna.getSituazione().equals("entrata_ok"))
                                    )
                                ){%>
                            <tr>                                
                                <%if(consegna.getTipologia().equals("commessa")){%>                                                                
                                    <td>
                                        <a href='<%=Utility.url%>/commesse/commessa.jsp?id=<%=consegna.getCommessa_numero()%>' class="pulsantesmall" target="_blank">
                                            <img src="<%=Utility.url%>/images/edit.png">
                                        </a>
                                    </td>                                   
                                    <td>
                                        <button class="pulsante_tabella green " style="width: 110px" onclick="modificacommessa(this,'<%=consegna.getCommessa_numero()%>')" id="consegnata" value="si">Consegna Cliente</button>
                                    </td>       
                                    <td>
                                        <input type="date" id="data_consegna" onblur="modificacommessa(this,'<%=consegna.getCommessa_numero()%>')" value="<%=consegna.getData_consegna()%>">
                                    </td>
                                <%}
                                if(consegna.getTipologia().equals("ordine_fornitore")){%>                                  
                                    <td>
                                        <a href='<%=Utility.url%>/ordini_fornitore/ordine_fornitore.jsp?id_ordine_fornitore=<%=consegna.getId()%>' class="pulsantesmall">
                                            <img src="<%=Utility.url%>/images/edit.png">
                                        </a>                                                                                    
                                    </td>                                                                        
                                        <%if(consegna.getData_ritiro().equals(d) && !consegna.getData_consegna().equals(d)){%>
                                            <td>
                                                <button class="pulsante_tabella fornitori " style="width: 110px" onclick="modifica_ordine_fornitore(this,'<%=consegna.getId()%>')" id="situazione" value="uscita_ok">Uscita Fornitore</button>
                                            </td>
                                            <td>
                                                <input type="date" id="data_ritiro" onblur="modifica_ordine_fornitore(this,'<%=consegna.getId()%>')" value="<%=d%>">
                                            </td> 
                                        <%}
                                        if(consegna.getData_consegna().equals(d) && !consegna.getData_ritiro().equals(d)){%>
                                            <td>
                                                <button class="pulsante_tabella fornitori " onclick="modifica_ordine_fornitore(this,'<%=consegna.getId()%>')" id="situazione" value="entrata_ok" style="width: 110px">Entrata Fornitore</button>
                                            </td>
                                            <td>
                                                <input type="date" id="data_consegna" onblur="modifica_ordine_fornitore(this,'<%=consegna.getId()%>')" value="<%=d%>">
                                            </td> 
                                        <%}%>
                                        <%if(consegna.getData_consegna().equals(d) && consegna.getData_ritiro().equals(d)){%>
                                            <td>
                                                <button class="pulsante_tabella fornitori " onclick="modifica_ordine_fornitore(this,'<%=consegna.getId()%>')" id="situazione" value="entrata_ok" style="width: 110px">Entrata Fornitore</button>
                                            </td>
                                            <td>
                                                <input type="date" id="data_consegna" onblur="modifica_ordine_fornitore(this,'<%=consegna.getId()%>')" value="<%=d%>">
                                            </td> 
                                        <%}%>
                                    </td>                                                                              
                                <%}%>
                                <td><%=consegna.getCommessa_numero()%></td>
                                <td><%=consegna.getCommessa_descrizione()%>
                                    <br>
                                    <%if(consegna.getTipologia().equals("ordine_fornitore")){%>              
                                        <%=consegna.getCommessa_cliente()%>
                                    <%}%>
                                </td>         
                                <td><%=consegna.getSoggetto_nome()%></td>                
                                <td>                                        
                                    <div class='ball margin-auto <%=consegna.getStampa()%>'></div>                                                                                
                                </td>
                                <td>
                                    <div class='ball margin-auto <%=consegna.getAllestimento()%>'></div>                                                                                
                                </td>
                            </tr>                            
                            <tr>
                                <td colspan="2"></td>
                                <td colspan="6">
                                    <%if(consegna.getTipologia().equals("ordine_fornitore")){%>
                                        Note Ordine Fornitore
                                        <br>
                                        <textarea style="height: 40px" id="note" onchange="modifica_ordine_fornitore(this,'<%=consegna.getId()%>')"><%=Utility.standardizzaStringaPerTextArea(consegna.getNote())%></textarea>
                                    <%}%>
                                    <%if(consegna.getTipologia().equals("commessa")){%>
                                        Note Consegna
                                        <br>
                                        <textarea style="height: 40px" id="note" onchange="modificacommessa(this,'<%=consegna.getCommessa_numero()%>')"><%=Utility.standardizzaStringaPerTextArea(consegna.getCommessa_note())%></textarea>
                                    <%}%>
                                </td>
                            </tr>                            
                            <%}%>
                        <%}%>
                    </table>
                    </div>
                </div>
            <%                
                if(indice%2==0){%>
                    <div class="clear"></div>
                <%}
                d=Utility.dataFutura(d, 1);
                indice++;
            }%>
        </div>
    </body>
</html>
