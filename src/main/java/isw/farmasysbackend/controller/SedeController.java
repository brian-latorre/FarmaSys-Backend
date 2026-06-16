package isw.farmasysbackend.controller;

import isw.farmasysbackend.service.SedeService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(path="api/v1/sede")
public class SedeController {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    SedeService sedeService;

    @GetMapping
    public ResponseEntity<?> getSedes() {
        try {
            return ResponseEntity.ok(sedeService.getSedes());
        } catch (Exception e) {
            logger.error("Error Inesperado", e);
            return new ResponseEntity<>(e.getMessage(), HttpStatus.NOT_FOUND);
        }
    }
}