package connection;



// Classe che gestisce le eccezioni sollevate a runtime dalla classe 
// ConnectionPool
public class ConnectionException extends Exception {
	public ConnectionException() {
            System.out.println("errore in ConnectionException");
	}
        
        public ConnectionException(String message){
            super(message);
            System.out.println("errore in connectionexception"+message);
        }
}


