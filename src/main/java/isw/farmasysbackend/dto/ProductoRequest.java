package isw.farmasysbackend.dto;

import isw.farmasysbackend.model.Producto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProductoRequest {

    private Long id;
    private String codBarras;
    private String descripcion;
    private BigDecimal precioVenta;
    private BigDecimal precioCosto;
    private String laboratorio;
    private String registroSanitario;
    private String condicionVenta;

    public static Producto toEntity(ProductoRequest request) {
        Producto producto = new Producto();

        if (request.getId() != null && request.getId() > 0) {
            producto.setId(request.getId());
        }

        producto.setCodBarras(request.getCodBarras());
        producto.setDescripcion(request.getDescripcion());
        producto.setPrecioVenta(request.getPrecioVenta());
        producto.setPrecioCosto(request.getPrecioCosto());
        producto.setLaboratorio(request.getLaboratorio());
        producto.setRegistroSanitario(request.getRegistroSanitario());
        producto.setCondicionVenta(request.getCondicionVenta());

        return producto;
    }
}