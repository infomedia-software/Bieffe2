<%@page import="gestioneDB.GestioneReparti"%>
<%@page import="beans.Reparto"%>
<%@page import="utility.Utility"%>
<%@page import="beans.Utente"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Utente utente=(Utente)session.getAttribute("utente");    
    String accesso=Utility.eliminaNull(request.getParameter("accesso"));
    if(accesso.equals(""))
        accesso="ufficio";
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%=Utility.nomeSoftware%></title>
        <jsp:include page="_importazioni.jsp"></jsp:include>
        <script type='text/javascript'>
            function login(){                
                mostraloader("Accesso in corso...");
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/__login.jsp",
                    data: $("#formlogin").serialize(),
                    dataType: "html",
                    success: function(msg){   
                        if(msg==="no"){                                
                            $("#errorelogin").show();                                
                            nascondiloader();
                        }else{
                            location.href=msg;
                        }                            
                    },
                    error: function(){
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE login()");
                    }
                });		                
            }
            
            $(function(){
                $("#nomeutente_login").keypress(function(e) {
                    if(e.which === 13) {
                        login();
                    }
                });
                $("#password_login").keypress(function(e) {
                    if(e.which === 13) {
                        login();
                    }
                });
            });

       
        </script>
    </head>
    <body style="background-color: #2C3B50;">
        
        <!-- LOADER-->
        <div id='loader'>
            <img src="<%=Utility.url%>/images/loader.gif">
            <br>
            <div id='loadertesto'></div>
        </div>
        
        <%if(utente==null){%>
            <div id='login'>                
                
                <div class="box" style="width: 300px;margin: 30px auto 30px auto;float: none;text-align: center;">
                    <img src="<%=Utility.url%>/images/infogest.jpg" style="height: 75px">                                              
                    <%if(Utility.url.toLowerCase().contains("calendari")){%>
                        <span style="font-size: 20px;font-weight: bold;text-align: center;color:#444;">
                        Calendari
                        </span>
                    <%}%>
                </div>                
                <div class="clear"></div>
                <div id='div_login'>                        
                    <form id='formlogin'>                        
                        <input type="hidden" name="accesso" ids="accesso" value="<%=accesso%>" >                                                                       
                        <input type='<%if(!accesso.equals("operaio")){%>text<%}else{%>hidden<%}%>' id='nomeutente_login' name="nomeutente" placeholder="Nome Utente" class="enter" >                       
                        <input type='password' id='password_login' class="enter" name="password" placeholder="<%if(accesso.equals("operaio")){%>Inserisci il Pin<%}else{%>Password<%}%>" >

                        <button class='pulsante margin-auto' onclick="login();" type='button'>
                            <img src="<%=Utility.url%>/images/key.png">
                            Accesso
                        </button>

                        <div class='height10'></div>

                        <div id='errorelogin' class='errore displaynone'>
                            Nessun utente presente con i dati inseriti.
                        </div>
                            
                    </form>
                </div>
            </div>       
        <%}%>
        <%if(utente!=null){%>
        
            <div class="box" style="background-color: white;width: 250px;margin: auto;margin-top: 10px;float: none;text-align: center;">
                <img src="<%=Utility.url%>/images/infogest.jpg" style="height: 50px">                    
                <%if(Utility.url.toLowerCase().contains("calendari")){%>
                    <span style="font-size: 20px;font-weight: bold;text-align: center;color:#444;">
                    Calendari
                    </span>
                <%}%>
            </div>
                        
            <%if(utente.getPrivilegi().equals("amministratore") || utente.getPrivilegi().equals("ufficio")){%>

                <a href="<%=Utility.url%>/commesse/commesse.jsp?situazione=programmata" class="pulsantehome green float-left">
                    <img src="<%=Utility.url%>/images/document.png">
                    <div class="titolo">Commesse<br>Programmate</div>                           
                </a>                                                        

                <a href="<%=Utility.url%>/commesse/commesse.jsp?situazione=daprogrammare" class="pulsantehome red float-left">
                    <img src="<%=Utility.url%>/images/document.png">
                    <div class="titolo">Commesse<br>da Programmare</div>                           
                </a>

                <a href="<%=Utility.url%>/commesse/commesse.jsp?situazione=conclusa" class="pulsantehome commessa float-left">
                    <img src="<%=Utility.url%>/images/document.png">
                    <div class="titolo">Commesse<br>Concluse</div>                           
                </a>                            

                <!--a href="<%=Utility.url%>/planning/planning.jsp?" class="pulsantehome planning float-left">
                    <img src="<%=Utility.url%>/images/planning.png">
                    <div class="titolo">Planning</div>                            
                </a-->   
                    
                  <a href="<%=Utility.url%>/act_pl/act_pl.jsp" class="pulsantehome planning float-left"  >
                    <img src="<%=Utility.url%>/images/planning.png">
                    <div class="titolo">Planning</div>                            
                </a>                                                       


                <a href='<%=Utility.url%>/attivita/lista_attivita.jsp'  class="pulsantehome listaattivita float-left ">
                    <img src="<%=Utility.url%>/images/attivita.png">                        
                    <div class="titolo">Attività</div>                           
                </a>


                <a href='<%=Utility.url%>/fasi_cat/fasi_cat.jsp'  class="pulsantehome fasi float-left ">
                    <img src="<%=Utility.url%>/images/fasi.png">                        
                    <div class="titolo">Fasi</div>                           
                </a>

                <a href='<%=Utility.url%>/fasi_cat/sottofasi.jsp'  class="pulsantehome fasi float-left ">
                    <img src="<%=Utility.url%>/images/sottofasi.png">                        
                    <div class="titolo">Sottofasi</div>                           
                </a>

                <a href='<%=Utility.url%>/risorse/risorse.jsp'  class="pulsantehome risorse float-left ">
                    <img src="<%=Utility.url%>/images/risorsa.png">                        
                    <div class="titolo">Risorse</div>                           
                </a>

                <a href='<%=Utility.url%>/reparti/reparti.jsp'  class="pulsantehome reparti float-left ">
                    <img src="<%=Utility.url%>/images/reparto.png">                        
                    <div class="titolo">Reparti</div>                           
                </a>


                <a href='<%=Utility.url%>/soggetti/soggetti.jsp?tipologia=C'  class="pulsantehome clienti float-left displaynone">
                    <img src="<%=Utility.url%>/images/man.png">                        
                    <div class="titolo">Clienti</div>                            
                </a>


                <a href='<%=Utility.url%>/utenti/utenti.jsp?' class="pulsantehome utenti float-left ">
                    <img src="<%=Utility.url%>/images/man.png">                        
                    <div class="titolo">Utenti</div>
                </a>

            <%}%>

            <%if(utente.is_magazzino() || utente.is_montaggio() || utente.is_reparto()){%>

                <%if(utente.is_magazzino()){%>
                    <a href='<%=Utility.url%>/calendario_consegne/calendario_consegne.jsp'  class="pulsantehome calendario_consegne float-left ">
                      <img src="<%=Utility.url%>/images/trasporti.png">                        
                      <div class="titolo">Calendario Consegne</div>                           
                    </a>
                <%}%>
            
                <a href="<%=Utility.url%>/attivita/lista_attivita.jsp" class="pulsantehome listaattivita float-left">
                    <img src="<%=Utility.url%>/images/attivita.png">
                    <div class="titolo">Attività</div>                            
                </a>

                <%for(Reparto r:GestioneReparti.getIstanza().ricerca("")){%>
                    <a href="<%=Utility.url%>/monitor/monitor.jsp?reparto=<%=r.getId()%>" class="pulsantehome monitor float-left">
                        <img src="<%=Utility.url%>/images/monitor.png">
                        <div class="titolo">Monitor <%=r.getNome()%></div>                            
                    </a>
                <%}%>                                                
            <%}%>    

            <a href='#' class="pulsantehome float-left" onclick="logout();">
                <img src="<%=Utility.url%>/images/logout.png">                        
                <div class="titolo">Esci</div>
            </a>
                            
                
            <div class='height10'></div>               
                            
        <%}%>
        
        <div class="height10"></div>
        
        <div style="background-color: white;width: 150px;margin: 30px auto 30px auto;float: none;text-align: center;padding: 0px;-webkit-border-radius: 3px;-moz-border-radius: 3px;border-radius: 3px;">
            <a href="http://www.infomediatek.it"  target="_blank" ><img src="<%=Utility.url%>/images/infomedia.png" style="height: 35px"></a>            
        </div>
    </body>
</html>
