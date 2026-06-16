package isw.farmasysbackend.service;

import isw.farmasysbackend.model.Rol;
import isw.farmasysbackend.repository.RolRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RolService {

    @Autowired
    RolRepository rolRepository;

    public List<Rol> getRoles() {
        return rolRepository.findAll();
    }
}