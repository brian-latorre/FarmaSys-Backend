package isw.farmasysbackend.repository;

import isw.farmasysbackend.model.Producto;
import org.assertj.core.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.data.jpa.test.autoconfigure.DataJpaTest;
import org.springframework.boot.jdbc.EmbeddedDatabaseConnection;
import org.springframework.boot.jdbc.test.autoconfigure.AutoConfigureTestDatabase;

import java.math.BigDecimal;
import org.springframework.test.context.TestPropertySource;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@DataJpaTest
@AutoConfigureTestDatabase(connection = EmbeddedDatabaseConnection.H2)
@TestPropertySource(properties = {
    "spring.flyway.enabled=false",
    "spring.jpa.hibernate.ddl-auto=create-drop"
})
class ProductoRepositoryTest {
    @Autowired
    ProductoRepository productoRepository;
    private Producto producto;


    @BeforeEach
    void setUp() {
    }

    @Test
    public void testFindAll(){
        producto = Producto.builder()
                .codBarras("7751234567890")
                .descripcion("Paracetamol 500mg")
                .precioVenta(new BigDecimal("5.50"))
                .precioCosto(new BigDecimal("2.00"))
                .laboratorio("Genfar")
                .condicionVenta("Sin receta")
                .build();

        producto = productoRepository.save(producto);

        List<Producto> productoList = productoRepository.findAll();

        Assertions.assertThat(productoList).isNotNull();
        Assertions.assertThat(productoList.size()).isEqualTo(1);
    }
}