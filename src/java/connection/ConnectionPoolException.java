package connection;



// Classe che gestisce le eccezioni sollevate a runtime dalla classe 
// ConnectionPool
public class ConnectionPoolException extends Exception {
	public ConnectionPoolException() {
	}
        
        public ConnectionPoolException(String message){
            super(message);
            System.out.println("Errore:\n"+message);
        }
}


