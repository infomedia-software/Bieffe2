<%@page import="java.util.ArrayList"%>
<%@page import="beans.Act"%>
<%@page import="gestioneDB.GestioneAct"%>
<%@page import="utility.Utility"%>
<%
    String id_act=Utility.eliminaNull(request.getParameter("id_act"));
    
    Act act=GestioneAct.getIstanza().get_act(id_act);
    ArrayList<String> orari=Utility.getIstanza().lista_orari();
%>

<script type="text/javascript">
    function no_programma_act(){
        $.ajax({
            type: "POST",
            url: "<%=Utility.url%>/act/__programma_act.jsp",
            data: $("#form_programma_act").serialize(),
            dataType: "html",
            success: function(msg){
            },
            error: function(){
                alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE");
            }
        });
    }
</script>


    <form id="form_programma_act">
        
        <input type="text" name="id_act" value="<%=act.getId()%>">
        <input type="text" name="id_act_res" value="<%=act.getAct_res().getId()%>">
        

        <div class="box">
            <div class='etichetta'>ID</div>
            <div class='valore'><span><%=act.getId()%></span></div>

            <div class='etichetta'>Descrizione</div>
            <div class='valore'><span><%=act.getDescrizione()%></span></div>

            <div class='etichetta'>Commessa</div>
            <div class='valore'><span><%=act.getCommessa().getNumero()%></span></div>

            <div class='etichetta'>Durata</div>
            <div class='valore'><span><%=act.getDurata_string()%></span></div>

            <div class="etichetta">Risorsa</div>
            <div class="valore"><span><%=act.getAct_res().toString()%></span></div>
        </div>
        
        <div class="box">
            <h3>Programma prima / dopo</h3>
            
        </div>
        
        <div class="box">
            <h3>Programma in data/ora</h3>
            <div class="etichetta">Data / Ora</div>
            <div class="valore">
                <input type='date' id="data" name='data' style="width: 125px" min="<%=Utility.dataOdiernaFormatoDB()%>" >
                <select id="ora"  name="ora" style="width: 100px">
                    <option value=''></option>
                    <%for(String orario:orari){%>
                        <option value='<%=orario%>'><%=orario%></option>
                    <%}%>
                </select>     
            </div>
        </div>

        <button class="pulsante float-right" type="button" onclick="programma_act()">Prosegui</button>
        
    </form>
    
</div>
