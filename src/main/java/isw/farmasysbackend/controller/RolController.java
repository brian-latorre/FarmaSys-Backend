package isw.farmasysbackend.controller;

import isw.farmasysbackend.service.RolService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(path="api/v1/rol")
public class RolController {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    RolService rolService;

    @GetMapping
    public ResponseEntity<?> getRoles() {
        try {
            return ResponseEntity.ok(rolService.getRoles());
        } catch (Exception e) {
            logger.error("Error Inesperado", e);
            return new ResponseEntity<>(e.getMessage(), HttpStatus.NOT_FOUND);
        }
    }
}