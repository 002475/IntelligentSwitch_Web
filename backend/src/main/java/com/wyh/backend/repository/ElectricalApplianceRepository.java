package com.wyh.backend.repository;

import com.wyh.backend.model.ElectricalAppliance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ElectricalApplianceRepository extends JpaRepository<ElectricalAppliance, Long> {
    List<ElectricalAppliance> findByType(String type);
    List<ElectricalAppliance> findByNameContaining(String name);
    List<ElectricalAppliance> findByLocationContaining(String location);
}
