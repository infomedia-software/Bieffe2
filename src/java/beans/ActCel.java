package beans;

import utility.Utility;


public class ActCel {
   
    private String data;    
    private String id_act_res;    
    private String etichetta;
    private String valore;

    @Override
    public String toString() {
        return "ActCel{" + "data=" + data + ", id_act_res=" + id_act_res + ", etichetta=" + etichetta + ", valore=" + valore + '}';
    }

    
    

        
                
        
    
    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

    public String getId_act_res() {
        return id_act_res;
    }

    public void setId_act_res(String id_act_res) {
        this.id_act_res = id_act_res;
    }

    public String getEtichetta() {
        return etichetta;
    }

    public void setEtichetta(String etichetta) {
        this.etichetta = etichetta;
    }

    public String getValore() {
        return valore;
    }

    public void setValore(String valore) {
        this.valore = valore;
    }
    
    
    
    public String data_ora_inizio(){
        String toReturn=data+" ";
        if(etichetta.equals("c0")){toReturn=toReturn+"00:00";}
        if(etichetta.equals("c1")){toReturn=toReturn+"00:30";}
        if(etichetta.equals("c2")){toReturn=toReturn+"01:00";}
        if(etichetta.equals("c3")){toReturn=toReturn+"01:30";}
        if(etichetta.equals("c4")){toReturn=toReturn+"02:00";}
        if(etichetta.equals("c5")){toReturn=toReturn+"02:30";}
        if(etichetta.equals("c6")){toReturn=toReturn+"03:00";}
        if(etichetta.equals("c7")){toReturn=toReturn+"03:30";}
        if(etichetta.equals("c8")){toReturn=toReturn+"04:00";}
        if(etichetta.equals("c9")){toReturn=toReturn+"04:30";}
        if(etichetta.equals("c10")){toReturn=toReturn+"05:00";}
        if(etichetta.equals("c11")){toReturn=toReturn+"05:30";}
        if(etichetta.equals("c12")){toReturn=toReturn+"06:00";}
        if(etichetta.equals("c13")){toReturn=toReturn+"06:30";}
        if(etichetta.equals("c14")){toReturn=toReturn+"07:00";}
        if(etichetta.equals("c15")){toReturn=toReturn+"07:30";}
        if(etichetta.equals("c16")){toReturn=toReturn+"08:00";}
        if(etichetta.equals("c17")){toReturn=toReturn+"08:30";}
        if(etichetta.equals("c18")){toReturn=toReturn+"09:00";}
        if(etichetta.equals("c19")){toReturn=toReturn+"09:30";}
        if(etichetta.equals("c20")){toReturn=toReturn+"10:00";}
        if(etichetta.equals("c21")){toReturn=toReturn+"10:30";}
        if(etichetta.equals("c22")){toReturn=toReturn+"11:00";}
        if(etichetta.equals("c23")){toReturn=toReturn+"11:30";}
        if(etichetta.equals("c24")){toReturn=toReturn+"12:00";}
        if(etichetta.equals("c25")){toReturn=toReturn+"12:30";}
        if(etichetta.equals("c26")){toReturn=toReturn+"13:00";}
        if(etichetta.equals("c27")){toReturn=toReturn+"13:30";}
        if(etichetta.equals("c28")){toReturn=toReturn+"14:00";}
        if(etichetta.equals("c29")){toReturn=toReturn+"14:30";}
        if(etichetta.equals("c30")){toReturn=toReturn+"15:00";}
        if(etichetta.equals("c31")){toReturn=toReturn+"15:30";}
        if(etichetta.equals("c32")){toReturn=toReturn+"16:00";}
        if(etichetta.equals("c33")){toReturn=toReturn+"16:30";}
        if(etichetta.equals("c34")){toReturn=toReturn+"17:00";}
        if(etichetta.equals("c35")){toReturn=toReturn+"17:30";}
        if(etichetta.equals("c36")){toReturn=toReturn+"18:00";}
        if(etichetta.equals("c37")){toReturn=toReturn+"18:30";}
        if(etichetta.equals("c38")){toReturn=toReturn+"19:00";}
        if(etichetta.equals("c39")){toReturn=toReturn+"19:30";}
        if(etichetta.equals("c40")){toReturn=toReturn+"20:00";}
        if(etichetta.equals("c41")){toReturn=toReturn+"20:30";}
        if(etichetta.equals("c42")){toReturn=toReturn+"21:00";}
        if(etichetta.equals("c43")){toReturn=toReturn+"21:30";}
        if(etichetta.equals("c44")){toReturn=toReturn+"22:00";}
        if(etichetta.equals("c45")){toReturn=toReturn+"22:30";}
        if(etichetta.equals("c46")){toReturn=toReturn+"23:00";}
        if(etichetta.equals("c47")){toReturn=toReturn+"23:30";}        
        return toReturn;    
    }
    
    public String data_ora_fine(){
        String toReturn=data+" ";        
        if(etichetta.equals("c0")){toReturn=toReturn+"00:30";}
        if(etichetta.equals("c1")){toReturn=toReturn+"01:00";}
        if(etichetta.equals("c2")){toReturn=toReturn+"01:30";}
        if(etichetta.equals("c3")){toReturn=toReturn+"02:00";}
        if(etichetta.equals("c4")){toReturn=toReturn+"02:30";}
        if(etichetta.equals("c5")){toReturn=toReturn+"03:00";}
        if(etichetta.equals("c6")){toReturn=toReturn+"03:30";}
        if(etichetta.equals("c7")){toReturn=toReturn+"04:00";}
        if(etichetta.equals("c8")){toReturn=toReturn+"04:30";}
        if(etichetta.equals("c9")){toReturn=toReturn+"05:00";}
        if(etichetta.equals("c10")){toReturn=toReturn+"05:30";}
        if(etichetta.equals("c11")){toReturn=toReturn+"06:00";}
        if(etichetta.equals("c12")){toReturn=toReturn+"06:30";}
        if(etichetta.equals("c13")){toReturn=toReturn+"07:00";}
        if(etichetta.equals("c14")){toReturn=toReturn+"07:30";}
        if(etichetta.equals("c15")){toReturn=toReturn+"08:00";}
        if(etichetta.equals("c16")){toReturn=toReturn+"08:30";}
        if(etichetta.equals("c17")){toReturn=toReturn+"09:00";}
        if(etichetta.equals("c18")){toReturn=toReturn+"09:30";}
        if(etichetta.equals("c19")){toReturn=toReturn+"10:00";}
        if(etichetta.equals("c20")){toReturn=toReturn+"10:30";}
        if(etichetta.equals("c21")){toReturn=toReturn+"11:00";}
        if(etichetta.equals("c22")){toReturn=toReturn+"11:30";}
        if(etichetta.equals("c23")){toReturn=toReturn+"12:00";}
        if(etichetta.equals("c24")){toReturn=toReturn+"12:30";}
        if(etichetta.equals("c25")){toReturn=toReturn+"13:00";}
        if(etichetta.equals("c26")){toReturn=toReturn+"13:30";}
        if(etichetta.equals("c27")){toReturn=toReturn+"14:00";}
        if(etichetta.equals("c28")){toReturn=toReturn+"14:30";}
        if(etichetta.equals("c29")){toReturn=toReturn+"15:00";}
        if(etichetta.equals("c30")){toReturn=toReturn+"15:30";}
        if(etichetta.equals("c31")){toReturn=toReturn+"16:00";}
        if(etichetta.equals("c32")){toReturn=toReturn+"16:30";}
        if(etichetta.equals("c33")){toReturn=toReturn+"17:00";}
        if(etichetta.equals("c34")){toReturn=toReturn+"17:30";}
        if(etichetta.equals("c35")){toReturn=toReturn+"18:00";}
        if(etichetta.equals("c36")){toReturn=toReturn+"18:30";}
        if(etichetta.equals("c37")){toReturn=toReturn+"19:00";}
        if(etichetta.equals("c38")){toReturn=toReturn+"19:30";}
        if(etichetta.equals("c39")){toReturn=toReturn+"20:00";}
        if(etichetta.equals("c40")){toReturn=toReturn+"20:30";}
        if(etichetta.equals("c41")){toReturn=toReturn+"21:00";}
        if(etichetta.equals("c42")){toReturn=toReturn+"21:30";}
        if(etichetta.equals("c43")){toReturn=toReturn+"22:00";}
        if(etichetta.equals("c44")){toReturn=toReturn+"22:30";}
        if(etichetta.equals("c45")){toReturn=toReturn+"23:00";}
        if(etichetta.equals("c46")){toReturn=toReturn+"23:30";}        
        if(etichetta.equals("c47")){toReturn=Utility.dataFutura(data, 1)+" 00:00";}        
    
        return toReturn;    
    }

    
    
}

