<%@page import="beans.Commessa"%>
<%@page import="gestioneDB.GestioneRisorse"%>
<%@page import="beans.Risorsa"%>
<%@page import="java.util.Map"%>
<%@page import="beans.Attivita"%>
<%@page import="java.util.ArrayList"%>
<%@page import="gestioneDB.GestionePlanning"%>
<%@page import="utility.Utility"%>
<%
    String data=Utility.eliminaNull(request.getParameter("data"));
    
    // Reparto & Risorse
    String reparto=Utility.eliminaNull(request.getParameter("reparto"));    
    if(reparto.equals(""))  // se reparto è vuoto => carica il reparto standard
        reparto="2";
    String queryrisorse=" risorse.planning='si' AND risorse.stato='1' ORDER BY risorse.ordinamento ASC";
    if(!reparto.equals(""))        
        queryrisorse=" (risorse.reparti LIKE '%"+reparto+",%' OR risorse.reparti LIKE '%"+reparto+"') AND "+queryrisorse;    
        
    ArrayList<Risorsa> risorse =GestioneRisorse.getIstanza().ricercaRisorse(queryrisorse);    
    
    Map<String,ArrayList<Attivita>> mappa_attivita=GestionePlanning.getIstanza().mappa_attivita(
        "(attivita.fine>='"+data+ " 00:00:00' AND attivita.inizio<='"+data+ " 23:59:59') AND "+                                
            "attivita.stato='1' "+ 
            "ORDER BY attivita.inizio ASC ");
    

    String id_attivita_taglia=Utility.getIstanza().getValoreByCampo("attivita", "id", " stato='taglia'");
    
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Planning <%=Utility.convertiDataFormatoIT(data)%> | <%=Utility.nomeSoftware%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
        
        <script type="text/javascript">             
            $(function(){                
                $("body").keydown(function(e) {                
                    if(e.keyCode === 37) { // left

                        mostraloader("Caricamento Planning in corso...");
                        modificadata("-1");
                    }

                    if(e.keyCode === 39) { // right
                        mostraloader("Caricamento Planning in corso...");
                        modificadata("+1");
                    }
                });
            });
            
            function aggiornaplanning(){
                location.reload();
            }
        
            
    
        </script>
        
        
    </head>
    <body>        

        <jsp:include page="../_loader.jsp"></jsp:include>
        <jsp:include page="../_popup.jsp"></jsp:include>
        
        <input type="hidden" id="reparto" value="<%=reparto%>">               
        

        <div style="background-color: #2C3B50;width: calc(100% - 10px);padding: 5px;position: fixed;">                    
            
            <div style="float: left" >
                <a href="<%=Utility.url%>"><img src="<%=Utility.url%>/images/infomedia cerchio.png" style="height: 35px;float: left;margin-right: 10px"></a>

                <button class="pulsantesmall" onclick="modificadata('-1')"><img src="<%=Utility.url%>/images/left.png"></button>                
                <input type="date" id="data" class="date float-left" value="<%=data%>" onchange="modificadata('')"  onkeydown="event.preventDefault()">
                <button class="pulsantesmall float-left" onclick="modificadata('+1')"><img src="<%=Utility.url%>/images/right.png"></button>

                 <a href="<%=Utility.url%>/attivita/attivita_da_programmare.jsp" class="pulsante planning" >
                    <img src="<%=Utility.url%>/images/planning.png">
                    Da Programmare
                </a>
            </div>
            <div style="float: left;width: calc(100% - 400px)">
            <%for(Risorsa risorsa:risorse){%>
                <a href="#<%=risorsa.getId()%>" class="pulsante_tabella float-left"><%=risorsa.getCodice() +" "+risorsa.getNome()%></a>
            <%}%>    
            </div>
            <div class="clear"></div>
        </div>
            
        <div style='height: 70px;'></div>
            <div class="box">
            <table class="tabella" > 
            <%for(Risorsa risorsa:risorse){
                ArrayList<Attivita> lista_attivita=mappa_attivita.get(risorsa.getId());%>                        
                    <tr>
                        <th colspan="2">
                            <a name='<%=risorsa.getId()%>'></a>
                            <h2 style="text-align: left">
                                <%=risorsa.getFase().getNome()%> - <%=risorsa.getCodice()%> <%=risorsa.getNome()%>
                            </h2>
                        </th>
                        <th>Inizio</th>
                        <th>Fine</th>
                        <th style="width: 50px">Durata</th>                        
                        <th>Data<br>Consegna</th>
                        <th style="width: 30px"></th>
                        <th >Commessa</th>
                        <th>Cliente</th>
                        <th>Descrizione</th>
                        <th style="width: 50px">Q.tà</th>
                        <th></th>
                        <th>Note</th>
                    </tr>
                <%
                if(lista_attivita!=null){
                    for(Attivita attivita:lista_attivita){
                        Commessa commessa=attivita.getCommessa();                        
                        %>  
                        <tr>
                            <td>
                                <a href="<%=Utility.url%>/attivita/_attivita.jsp?id=<%=attivita.getId()%>" class="pulsante_tabella" target="_blank">
                                    <img src="<%=Utility.url%>/images/edit.png">
                                    Dettagli
                                </a>                                
                            </td>
                            <td style="width: 210px">
                                <%if(id_attivita_taglia.equals("")){%>
                                    <button class="pulsante_tabella" onclick="function_taglia('<%=attivita.getId()%>')">
                                        <img src="<%=Utility.url%>/images/cut.png">Taglia</button>                                                      
                                <%}%>                                
                                <button class="pulsante_tabella" onclick="mostrapopup('<%=Utility.url%>/attivita/_programma_attivita.jsp?id_attivita=<%=attivita.getId()%>')"><img src="<%=Utility.url%>/images/clock.png">Riprogramma</button>                                                                                                                    
                            </td>
                            <td><%=attivita.getInizio_it()%></td>
                            <td><%=attivita.getFine_it()%></td>
                            <td><%=Utility.elimina_zero(attivita.getDurata())%> h</td>
                            <td><%=commessa.getData_consegna_it()%></td>
                            <td><div class="ball" style="background-color: <%=commessa.getColore()%>"></div></td>                            
                            <td><a href="<%=Utility.url%>/commesse/commessa.jsp?id=<%=commessa.getId()%>"><%=commessa.getNumero()%></a></td>                                                        
                            <td><a href="<%=Utility.url%>/commesse/commessa.jsp?id=<%=commessa.getId()%>"><%=commessa.getSoggetto().getAlias()%></a></td>
                            <td><a href="<%=Utility.url%>/commesse/commessa.jsp?id=<%=commessa.getId()%>"><%=commessa.getDescrizione()%></a></td>                             
                            <td>
                                <%if(commessa.getQta()>0){%>
                                    <%=Utility.elimina_zero(commessa.getQta())%>
                                <%}%>
                            </td>
                            <td>
                                <%if(attivita.is_completata()){%>
                                    <div class="pulsante_tabella green">Completata</div>    
                                <%}%>
                            </td>
                            <td><%=commessa.getNote()%></td>
                        </tr>
                    <%}%>
                <%}else{%>
                    <tr>
                        <td colspan="11">
                            Nessuna attività programmata
                        </td>
                    </tr>
                <%}%>    
                <tr>
                    <td colspan="11">
                        
                    </td>
                </tr>
            <%}%>                  
            </table>
        </div>
    </body>
</html>
