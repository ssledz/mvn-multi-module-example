package pl.softech.example.mvn.impl2;

import org.junit.Test;
import pl.softech.example.mvn.api.EchoService;

import java.nio.file.Files;
import java.nio.file.Paths;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.is;

/**
 * @author ssledz
 * @since 29.01.17
 */
public class SimpleEchoServiceTest {

    private EchoService service = new SimpleEchoService();

    private void echo(String line) {
        assertThat(service.echo(line), is(equalTo(String.format("Impl2: %s", line))));
    }

    @Test
    public void echo() throws Exception {
        Files.readAllLines(
                Paths.get(SimpleEchoServiceTest.class.getClassLoader().getResource("echo-input.txt").toURI())
        ).stream().forEach(this::echo);
    }

}