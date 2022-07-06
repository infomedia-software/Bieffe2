<%@page import="utility.Utility"%>
    <script type="text/javascript">
        function nuova_fase(){
                        
            var nome=$("#nome").val();
            
            if(nome==="" ){
                alert("Impossibile creare una nuova fase.\nVerifica di aver inserito il nome della fase da inserire.");
                return;
            }
            if(confirm("Procedere all'inserimento della nuova fase?")){          
                mostraloader("Aggiornamento Fasi...");
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/fasi_cat/__nuova_fase.jsp",
                    data: $("#form_nuova_fase").serialize(),
                    dataType: "html",
                    success: function(msg){
                        aggiorna_fasi();
                    },
                    error: function(){
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE nuova_fase");
                    }
                });  
            }
        }    
    </script>

<form id="form_nuova_fase">

    <div class="etichetta">Codice</div>
    <div class="valore">
        <input type="text" name="codice" id="codice">
    </div>

    <div class="etichetta">Nome</div>
    <div class="valore">
        <input type="text" name="nome" id="nome">
    </div>
    
        <button class="pulsante float-right" type="button" onclick="nuova_fase()">Conferma</button>
</form>