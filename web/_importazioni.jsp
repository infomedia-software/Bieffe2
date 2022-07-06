<%@page import="utility.Utility"%>
<link rel="stylesheet" type="text/css" href="<%=Utility.url%>/css/stile2.4.0.css">
<link rel='stylesheet' media='print'  type='text/css' href= '<%=Utility.url%>/css/stile_print.css' />
<script type="text/javascript" src="<%=Utility.url%>/js/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="<%=Utility.url%>/js/jquery-ui.js"></script>
<link rel="shortcut icon" href="<%=Utility.url%>/images/favicon.ico" />

<!-- Upload File-->   
<script src="<%=Utility.url%>/js/upload/js/vendor/jquery.ui.widget.js"></script>
<script src="<%=Utility.url%>/js/upload/js/jquery.iframe-transport.js"></script>
<script src="<%=Utility.url%>/js/upload/js/jquery.fileupload.js"></script>
<script src="<%=Utility.url%>/js/upload/js/load-image.min.js"></script>
<script src="<%=Utility.url%>/js/upload/js/canvas-to-blob.min.js"></script>    
<script src="<%=Utility.url%>/js/upload/js/jquery.fileupload-process.js"></script>
<script src="<%=Utility.url%>/js/upload/js/jquery.fileupload-image.js"></script>
<link rel="stylesheet" href="<%=Utility.url%>/js/upload/css/jquery.fileupload.css">

<link href="https://fonts.googleapis.com/css?family=Roboto:300,400,700&display=swap" rel="stylesheet">

<script type='text/javascript'>
    $(function(){
        $("#popup").draggable({            
            handle: "#popup_titolo"            
        });
    });
    
    
    function mostraloader(testo){
        $("#loader").show();
        if(testo!=="")
            $("#loadertesto").html(testo);
        
    }
    function nascondiloader(){
        $("#loader").hide();
    }
    

    function logout(){
        if(confirm('Desideri uscire da <%=Utility.nomeSoftware%>?')){
            location.href='<%=Utility.url%>/__logout.jsp';
        }
    }
    
    function mostratab(tab){
        $(".scheda").hide();
        $(".tab").removeClass("tab2");
        $("#scheda"+tab).show();
        $("#tab"+tab).addClass("tab2");
    }
    
     
    function mostratabpopup(tab){
        $("#popup_contenuto .scheda").hide();
        $("#popup_contenuto .tab").removeClass("tab2");
        $("#popup_contenuto #scheda"+tab).show();
        $("#popup_contenuto #tab"+tab).addClass("tab2");
    }
    
    function caricatab(pagina,tab){        
        $(".scheda").hide();
        $(".tab").removeClass("tab2");
        $("#tab"+tab).addClass("tab2");        
        mostraloader("");
        $("#scheda"+tab).load(pagina,function(){$("#scheda"+tab).show();nascondiloader();});        
    }
    
    function mostrapopup(popup,titolo){        
        mostraloader("Caricamento in corso...");
        $("#popup_contenuto").load(popup,function(){
            if(titolo==='' || titolo===undefined){
                titolo="<%=Utility.nomeSoftware%>";
            }
            $("#popup_titolo").html(titolo);
            $("#popup_container").show();
            nascondiloader();
        });        
    }
    function nascondipopup(){        
        $("#popup_container").hide();
        $("#popup_contenuto").html("");
        $("#popup_titolo").html("");
        nascondiloader();
    }
    
    function function_nascondipopup(){
        $("#popup_container").hide();
        $("#popup_contenuto").html("");
        $("#popup_titolo").html("");
        nascondiloader();
    }
        
    
    
    
    function verificacampo(campo){
        var errore="";
        var valore=$("#"+campo).val();
        var controlloemail=true;
        var controllodurata=true;
        if(campo==="email"){
            controlloemail=validazione_email(valore);
        }
        if(campo==="durata"){
            controllodurata=validazione_durata(valore);
        }
        if(valore==="" || controlloemail===false || controllodurata===false){
            $("#"+campo).addClass("border-red");
            errore="Verifica di aver compilato correttamente il modulo.";
        }
        return errore;
    }
    
    function validazione_email(email) {
      var reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
      if (!reg.test(email)) return false; else return true;
    }


    function validazione_durata(n){
        var toReturn=!isNaN(parseFloat(n)) && isFinite(n);
        if(toReturn===true){
            var intero = Math.floor(n);            
            var decimale = parseFloat(n - intero);            
            if(decimale===0 || decimale===0.50 || decimale=== 0.5)
                toReturn=true;
            else
                toReturn=false;
        }
        if(intero<=0 && decimale<=0){
            toReturn=false;
        }
        if(intero<0){toReturn=false;}
        if(decimale<0){toReturn=false;}
        return toReturn;
    }
    
    
    
    function validazione_ritardo(n){
        var toReturn=!isNaN(parseFloat(n)) && isFinite(n);
        if(toReturn===true){
            var intero = Math.floor(n);            
            var decimale = parseFloat(n - intero);            
            if(decimale===0 || decimale===0.50 || decimale=== 0.5)
                toReturn=true;
            else
                toReturn=false;
        }
        if(intero<0 && decimale<0){
            toReturn=false;
        }
        if(intero<0){toReturn=false;}
        if(decimale<0){toReturn=false;}
        return toReturn;
    }
    
    
    function trasformainrisorsa(rif,idrif){
        if(confirm('Desideri inserire in planning trasformando in risorsa?')){
            $.ajax({
                type: "POST",
                url: "<%=Utility.url%>/risorse/__nuovarisorsa.jsp",
                data: "rif="+rif+"&idrif="+idrif,
                dataType: "html",
                success: function(msg){
                    alert('Correttamente inserito nelle risorse del planning.');
                    location.reload();
                },
                error: function(){
                    alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE trasformainrisorsa()");
                }
            });
        }
    }
    
  
    $(function(){
        

    function start(websocketServerLocation){
        ws = new WebSocket(websocketServerLocation);
        ws.onmessage = function(evt) {             
            var messaggio=evt.data;
            
            if(messaggio.includes("aggiorna_loader")){
                messaggio=messaggio.replace("aggiorna_loader:","");
                $("#loader").show();
                $("#loadertesto").html("Riprogrammazione risorsa<br>"+messaggio);
            }
            if(messaggio.includes("aggiorna_monitor")){
                location.reload();
            }
            if(messaggio.includes("aggiorna_planning")){
                location.reload();
            }
        };
        ws.onclose = function(){                      
            setTimeout(function(){start(websocketServerLocation)}, 5000);
        };
    }
 
       $('input[list]').on('change', function(e) {
            var input = e.target,
            list = input.getAttribute('list'),
            options = document.querySelectorAll('#' + list + ' option'),
            hiddenInput = document.getElementById(input.getAttribute('id') + '-hidden'),
            inputValue = input.value;

            hiddenInput.value = "";

            var input=inputValue.replace(/\./g,' ').replace(/ /g,'');

            for(var i = 0; i < options.length; i++) {
                    var option = options[i];
                    var opzione=option.innerText.replace(/\./g,' ').replace(/ /g,'');

                    if(opzione === input) {
                        hiddenInput.value = option.getAttribute('data-value');
                            break;
                    }
            }
        });
        start("<%=Utility.socket_url%>");        

    });

    function programma_attivita(id_attivita,new_inizio){              
        if(new_inizio!=="" && id_attivita!==""){
            mostraloader("Programmazione dell'attività in planning...");
            $.ajax({
                type: "POST",
                url: "<%=Utility.url%>/planning/__riprogramma_attivita.jsp",
                data: "id_attivita="+id_attivita+"&new_inizio="+new_inizio,
                dataType: "html",
                success: function(msg){                                
                    aggiorna_pagina();
                },
                error: function(){
                    alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE programma_attivita");
                }
            });        
        }
    }
    
    function modifica_attivita(id_attivita,inField){                     
        var newvalore=inField.value;
        var campodamodificare=inField.id;       
        if(campodamodificare.includes("carta")){
            var carta_selezionati = $('.carta_'+id_attivita+':checked').map(function() {return this.value;}).get().toString();
            carta_selezionati=carta_selezionati.replace(/,/g, '');
            newvalore=carta_selezionati;
            campodamodificare="carta";
        }              
        
        if(campodamodificare==="attiva"){
            $(".pulsanti_"+campodamodificare).removeClass("green");            
            inField.classList.add("green");
            
        }     
        
        if(campodamodificare==="attiva_infogest"){
            $(".pulsanti_"+campodamodificare).removeClass("green");            
            inField.classList.add("green");
            
        }     
        if(campodamodificare==="completata"){                    
            $(".pulsanti_"+campodamodificare).removeClass("green");            
            inField.classList.add("green");
        }
        
        $.ajax({
            type: "POST",
            url: "<%=Utility.url%>/attivita/__modificaattivita.jsp",
            data: "newvalore="+encodeURIComponent(String(newvalore))+"&campodamodificare="+campodamodificare+"&idattivita="+id_attivita,
            dataType: "html",
            success: function(msg){      
                if(campodamodificare==="attiva_infogest" || campodamodificare==="completata"){
                    aggiorna_pagina();
                }
            },
            error: function(){
                alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE modificaattivita()" );
            }
        });          
    }
   
    
    function modifica_cella(id_cella,campo_da_modificare,new_valore){                        
        mostraloader("Operazione in corso...");
        //alert(id_cella+">"+campo_da_modificare+">"+new_valore);
        $.ajax({
            type: "POST",
            url: "<%=Utility.url%>/planning/__modificacella.jsp",
            data: "id_cella="+id_cella+"&new_valore="+encodeURIComponent(String(new_valore))+"&campo_da_modificare="+campo_da_modificare,
            dataType: "html",
            success: function(msg){
                aggiornaplanning();
            },
            error: function(){
                alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE modifica_cella");
            }
        });   
    }
    

    function modificadata(operazione){
        var data=$("#data").val();
        var reparto=$("#reparto").val();
        mostraloader("Caricamento Planning in corso...");
        $.ajax({
            type: "POST",
            url: "<%=Utility.url%>/planning/__cambia_data.jsp",
            data: "operazione="+encodeURIComponent(String(operazione))+"&data="+encodeURIComponent(String(data)),
            dataType: "html",
            success: function(new_data){                
                if(new_data.includes("ERRORE")){
                    location.href="<%=Utility.url%>/errore.jsp?messaggio="+encodeURIComponent(String(new_data));                    
                }else{
                    location.href="<%=Utility.url%>/planning/planning.jsp?data="+new_data+"&reparto="+reparto;
                }
                    
            },
            error: function(){
                alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE");
            }
        });            
    }

    
    function function_da_programmare(attivitaselezionata){        
        var new_valore="da programmare";
        mostraloader("Aggiornamento Planning");
        $.ajax({
            type: "POST",
            url: "<%=Utility.url%>/attivita/__modificaattivita.jsp",
            data: "campodamodificare=situazione&newvalore="+encodeURIComponent(String(new_valore))+"&idattivita="+attivitaselezionata,
            dataType: "html",
            success: function(msg){
                aggiornaplanning();
            },
            error: function(){
                alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE da_programmare");
            }
        });		
    }
    function function_taglia(attivitaselezionata){
        mostraloader("Aggiornamento Planning");
        $.ajax({
            type: "POST",
            url: "<%=Utility.url%>/planning/__taglia.jsp",
            data: "idattivita="+attivitaselezionata,
            dataType: "html",
            success: function(msg){
                aggiornaplanning();
                $("#taglia").hide();
            },
            error: function(){
                alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE taglia");
            }
        });	
    }
    
     function function_non_programmare(id_attivita){        
        if(confirm("Rimuovere l'attività dalla programmazione?\nRitroverai l'attività nella relativa commessa")){            
            mostraloader("Rimozione dal planning in corso...");
            $.ajax({
                type: "POST",
                url: "<%=Utility.url%>/planning/__non_programmare.jsp",
                data: "id_attivita="+id_attivita,
                dataType: "html",
                success: function(msg){
                    if(msg===""){
                        aggiornaplanning();
                    }else{
                        alert(msg);
                        aggiornaplanning();
                    }
                },
                error: function(){
                    alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE non_programmare");
                }
            });
        }
    }
    
</script>