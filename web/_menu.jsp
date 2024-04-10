<%@page import="gestioneDB.GestioneReparti"%>
<%@page import="beans.Reparto"%>
<%@page import="beans.Utente"%>
<%@page import="utility.Utility"%>

<%
    Utente utente=(Utente)session.getAttribute("utente");
%>

<jsp:include page="_loader.jsp"></jsp:include>
<jsp:include page="_popup.jsp"></jsp:include>

<!-- MENU-->
<div id="menu">    

    <img src="<%=Utility.url%>/images/infogest.jpg" id="logo_menu">
    <%if(Utility.url.toLowerCase().contains("calendari")){%>
        <div style="padding-top:10px;padding-bottom:10px;font-size: 12px;font-weight: bold;text-align: center;color:#444;background-color: white;border-radius: 10px;width: calc(100% - 20px);margin: 10px;margin-top: 0px;">
        Calendari
        </div>
    <%}%>

    <%if(utente!=null){%>
        <div id="utente">
            <img src="<%=Utility.url%>/images/man.png">                                
        </div>
        <div id="utente_nome_cognome">
            <%=utente.getCognome()%> <%=utente.getNome()%>
        </div>
    
        <a href='<%=Utility.url%>'><div class="icon colore">H</div>Home</a>
        
        <%if(utente.getPrivilegi().equals("amministratore") || utente.getPrivilegi().equals("ufficio")){%>        
            <a href='<%=Utility.url%>/commesse/commesse.jsp?situazione=programmata' ><div class="icon green">C</div>Commesse</a>                        
            <a href='<%=Utility.url%>/act_pl/act_pl.jsp' ><div class="icon planning">P</div>Planning</a>                           
            <!--a href='<%=Utility.url%>/planning/planning.jsp?data=<%=Utility.dataOdiernaFormatoDB()%>' ><div class="icon planning">P</div>Planning</a-->            
            <a href='#' onclick="$('#div_anagrafiche').slideToggle();" ><div class="icon colore">A</div>Anagrafiche</a>            
            <div class="sottomenu" id="div_anagrafiche" >
                <a href='<%=Utility.url%>/soggetti/soggetti.jsp?tipologia=c' >Clienti</a>              
            </div>
                            
            <div class="sottomenu" id="div_monitor">
                <%for(Reparto r:GestioneReparti.getIstanza().ricerca("")){%>
                    <a href="<%=Utility.url%>/monitor/monitor.jsp?reparto=<%=r.getId()%>"><%=r.getNome()%></a>
                <%}%>          
            </div>   
            
            <a href='#' onclick="$('#div_setting').slideToggle();" ><div class="icon colore">S</div>Setting</a>
            <div class="sottomenu" id="div_setting">
                <a href='<%=Utility.url%>/fasi_cat/fasi_cat.jsp'>Fasi</a>
                <a href='<%=Utility.url%>/fasi_cat/sottofasi.jsp' >Sottofasi</a>
                <a href='<%=Utility.url%>/risorse/risorse.jsp' >Risorse</a>
                <a href='<%=Utility.url%>/reparti/reparti.jsp'>Reparti</a>                                                      
                <a href='<%=Utility.url%>/utenti/utenti.jsp'>Utenti</a>      
            </div>            
        <%}%>
        
        <%if(utente.is_magazzino() || utente.is_montaggio() || utente.is_reparto()){%>
            <a href="<%=Utility.url%>/attivita/lista_attivita.jsp"><div class="icon listaattivita">A</div>Attività</a>
            <%for(Reparto r:GestioneReparti.getIstanza().ricerca("")){%>
                <a href="<%=Utility.url%>/monitor/monitor.jsp?reparto=<%=r.getId()%>" ><div class="icon monitor">M</div><%=r.getNome()%></a>
            <%}%>          
        <%}%>
        
        <a href='<%=Utility.url%>/__logout.jsp' ><div class="icon colore">L</div>Logout</a>
        
    <%}%>    
</div>

