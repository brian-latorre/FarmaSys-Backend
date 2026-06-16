package isw.farmasysbackend.service;

import isw.farmasysbackend.model.Producto;
import isw.farmasysbackend.repository.ProductoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ProductoService {

    @Autowired
    private ProductoRepository productoRepository;

    public List<Producto> listarTodos() {
        return productoRepository.findAll();
    }

    public Optional<Producto> buscarPorId(Long id) {
        return productoRepository.findById(id);
    }

    public Producto guardar(Producto producto) {
        if (producto.getPrecioVenta().compareTo(producto.getPrecioCosto()) < 0) {
            throw new IllegalArgumentException("Error: El precio de venta es menor al precio de costo");
        }

        return productoRepository.save(producto);
    }

    public void eliminar(Long id) {
        productoRepository.deleteById(id);
    }
}