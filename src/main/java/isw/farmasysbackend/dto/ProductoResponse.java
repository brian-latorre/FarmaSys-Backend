package isw.farmasysbackend.dto;

import isw.farmasysbackend.model.Producto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProductoResponse {

    private Long id;
    private String codBarras;
    private String descripcion;
    private BigDecimal precioVenta;
    private BigDecimal precioCosto;
    private String laboratorio;
    private String registroSanitario;
    private String condicionVenta;

    public static ProductoResponse fromEntity(Producto producto) {
        return ProductoResponse.builder()
                .id(producto.getId())
                .codBarras(producto.getCodBarras())
                .descripcion(producto.getDescripcion())
                .precioVenta(producto.getPrecioVenta())
                .precioCosto(producto.getPrecioCosto())
                .laboratorio(producto.getLaboratorio())
                .registroSanitario(producto.getRegistroSanitario())
                .condicionVenta(producto.getCondicionVenta())
                .build();
    }

    public static List<ProductoResponse> fromEntities(List<Producto> productos) {
        return productos.stream()
                .map(ProductoResponse::fromEntity)
                .collect(Collectors.toList());
    }
}