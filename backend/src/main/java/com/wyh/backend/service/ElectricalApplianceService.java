package com.wyh.backend.service;

import com.wyh.backend.model.ElectricalAppliance;
import com.wyh.backend.repository.ElectricalApplianceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Optional;

@Service
public class ElectricalApplianceService {

    @Autowired
    private ElectricalApplianceRepository applianceRepository;

    public List<ElectricalAppliance> findAll() {
        return applianceRepository.findAll();
    }

    public Optional<ElectricalAppliance> findById(Long id) {
        return applianceRepository.findById(id);
    }

    public ElectricalAppliance save(ElectricalAppliance appliance) {
        return applianceRepository.save(appliance);
    }

    public void deleteById(Long id) {
        applianceRepository.deleteById(id);
    }

    public ElectricalAppliance update(ElectricalAppliance appliance) {
        return applianceRepository.save(appliance);
    }

    public List<ElectricalAppliance> findByType(String type) {
        return applianceRepository.findByType(type);
    }

    public List<ElectricalAppliance> searchByName(String keyword) {
        return applianceRepository.findByNameContaining(keyword);
    }

    public List<ElectricalAppliance> searchByLocation(String keyword) {
        return applianceRepository.findByLocationContaining(keyword);
    }

    public boolean existsByName(String name) {
        return applianceRepository.existsByName(name);
    }

    public boolean existsByNameExcludeId(String name, Long excludeId) {
        return applianceRepository.findByName(name)
                .map(appliance -> !appliance.getId().equals(excludeId))
                .orElse(false);
    }
}
