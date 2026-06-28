package isw.farmasysbackend.controller;

import isw.farmasysbackend.dto.ProductoRequest;
import isw.farmasysbackend.dto.ProductoResponse;
import isw.farmasysbackend.service.ProductoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin(origins = "http://localhost:4200")
@RequestMapping("/api/productos")
public class ProductoController {

    @Autowired
    private ProductoService productoService;

    @GetMapping
    public ResponseEntity<List<ProductoResponse>> obtenerProductos() {
        return ResponseEntity.ok(productoService.listarTodos());
    }

    @PostMapping
    public ResponseEntity<ProductoResponse> registrarProducto(@RequestBody ProductoRequest productoRequest) {
        ProductoResponse nuevoProducto = productoService.guardar(productoRequest);
        return ResponseEntity.ok(nuevoProducto);
    }
}