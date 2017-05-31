package pl.softech.example.mvn.impl1;

import pl.softech.example.mvn.api.EchoService;

/**
 * @author ssledz
 * @since 29.01.17
 */
public class SimpleEchoService implements EchoService {

    @Override
    public String echo(String message) {
        return sString.format("Impl1: %s", message);
    }
}
