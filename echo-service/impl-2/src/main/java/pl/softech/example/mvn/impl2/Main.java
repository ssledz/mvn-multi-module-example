package pl.softech.example.mvn.impl2;

/**
 * @author ssledz
 * @since 30.01.17
 */
public class Main {

    public static void main(String[] args) {
        SimpleEchoService simpleEchoService = new SimpleEchoService();
        for (String message : args) {
            simpleEchoService.echo(message);
        }
    }

}
