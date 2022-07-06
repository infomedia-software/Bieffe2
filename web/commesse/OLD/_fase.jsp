<%@page import="beans.Fase"%>
<%@page import="utility.Utility"%>
<%@page import="gestioneDB.GestioneCommesse"%>
<%
    String idfase=Utility.eliminaNull(request.getParameter("idfase"));
    
    Fase f=GestioneCommesse.getIstanza().ricercaFasi(" id="+idfase).get(0);
%>

<script type="text/javascript">
      function modificafase(inField){                
            var newvalore=inField.value;
            var campodamodificare=inField.id;
            if(campodamodificare==="durata"){
                var vd=validazione_durata(newvalore);
                if(vd===false){
                    alert("La durata inserita non è corretta");
                    return false;
                }
            }
            $.ajax({
                type: "POST",
                url: "<%=Utility.url%>/commesse/__modificafase.jsp",
                data: "newvalore="+encodeURIComponent(String(newvalore))+"&campodamodificare="+campodamodificare+"&id=<%=idfase%>",
                dataType: "html",
                success: function(msg){
                    aggiornaelementi();
                },
                error: function(){
                    alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE modificafase()");
                }
            });
        }
</script>


<div class="etichetta">Descrizione</div>
<div class="valore">
    <input type="text" id="descrizione" value="<%=f.getDescrizione()%>" onchange="modificafase(this);">
</div>

<div class="etichetta">Durata</div>
<div class="valore">
    <input type="text" id="durata" value="<%=f.getDurata()%>" onchange="modificafase(this);">
</div>

<div class="etichetta">Note</div>
<div class="valore">
    <textarea id="note" onchange="modificafase(this);"><%=f.getNote()%></textarea>
</div>
