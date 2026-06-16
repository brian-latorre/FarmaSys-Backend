package isw.farmasysbackend.service;

import isw.farmasysbackend.model.Sede;
import isw.farmasysbackend.repository.SedeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SedeService {

    @Autowired
    SedeRepository sedeRepository;

    public List<Sede> getSedes() {
        return sedeRepository.findAll();
    }
}