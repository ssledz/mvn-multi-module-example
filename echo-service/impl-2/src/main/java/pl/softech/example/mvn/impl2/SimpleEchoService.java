package pl.softech.example.mvn.impl2;

import pl.softech.example.mvn.api.EchoService;

/**
 * @author ssledz
 * @since 29.01.17
 */
public class SimpleEchoService implements EchoService {

    @Override
    public String echo(String message) {
        return String.format("Impl2: %s", message);
    }

}
