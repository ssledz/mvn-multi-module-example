package pl.softech.example.mvn;

import pl.softech.example.mvn.api.EchoService;

import java.util.ArrayList;
import java.util.List;
import java.util.ServiceLoader;

/**
 * @author ssledz
 * @since 29.01.17
 */
public class EchoServiceProvider {

    private final ServiceLoader<EchoService> loader = ServiceLoader.load(EchoService.class);

    public List<EchoService> loadAll() {

        List<EchoService> services = new ArrayList<>();
        for(EchoService service : loader) {
            services.add(service);
        }

        return services;
    }

}
