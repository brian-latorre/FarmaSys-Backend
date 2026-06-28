package isw.farmasysbackend.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "usuario")
public class Usuario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "username", nullable = false, unique = true, length = 60)
    private String username;

    @Column(name = "password", nullable = false, length = 255)
    @JsonIgnore
    private String password;

    @Column(name = "estado", nullable = false, length = 20)
    private String estado;


    @ManyToOne
    @JoinColumn(name = "id_rol", nullable = false)
    private Rol rol;


    @ManyToOne
    @JoinColumn(name = "id_sede", nullable = false)
    private Sede sede;
}
