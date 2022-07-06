<%@page import="utility.Utility"%>
<script type="text/javascript">
    function nuovo_reparto(){
        $.ajax({
            type: "POST",
            url: "<%=Utility.url%>/reparti/__nuovo_reparto.jsp",
            data: $("#form_nuovo_reparto").serialize(),
            dataType: "html",
            success: function(id_reparto){
                location.href='<%=Utility.url%>/reparti/reparto.jsp?id_reparto='+id_reparto;
            },
            error: function(){
                alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE nuovo_reparto");
            }
        });
    }
</script>

<form id="form_nuovo_reparto">
    <div class="etichetta">Nome</div>
    <div class="valore">
        <input type="text" id="nome" name="nome">
    </div>

    <div class="etichetta">Note</div>
    <div class="valore">
        <textarea id="note" name="note"></textarea>
    </div>
    <button class="pulsante float-right" type="button" onclick="nuovo_reparto()">Conferma</button>
    <div class="clear"></div>
</form>