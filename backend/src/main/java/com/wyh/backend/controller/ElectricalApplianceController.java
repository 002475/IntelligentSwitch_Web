package com.wyh.backend.controller;

import com.wyh.backend.model.ElectricalAppliance;
import com.wyh.backend.service.ElectricalApplianceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/appliances")
@CrossOrigin(origins = "*")
public class ElectricalApplianceController {

    @Autowired
    private ElectricalApplianceService applianceService;

    @GetMapping
    public List<ElectricalAppliance> getAllAppliances() {
        return applianceService.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<ElectricalAppliance> getApplianceById(@PathVariable Long id) {
        return applianceService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<?> createAppliance(@RequestBody ElectricalAppliance appliance) {
        if (applianceService.existsByName(appliance.getName())) {
            return ResponseEntity.badRequest().body("电器名称已存在：" + appliance.getName());
        }
        return ResponseEntity.ok(applianceService.save(appliance));
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateAppliance(
            @PathVariable Long id,
            @RequestBody ElectricalAppliance applianceDetails) {
        return applianceService.findById(id)
                .map(appliance -> {
                    if (!appliance.getName().equals(applianceDetails.getName())) {
                        if (applianceService.existsByName(applianceDetails.getName())) {
                            return ResponseEntity.badRequest().body("电器名称已存在：" + applianceDetails.getName());
                        }
                    }
                    appliance.setType(applianceDetails.getType());
                    appliance.setName(applianceDetails.getName());
                    appliance.setLocation(applianceDetails.getLocation());
                    appliance.setStatus(applianceDetails.getStatus());
                    ElectricalAppliance updated = applianceService.update(appliance);
                    return ResponseEntity.ok(updated);
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @PatchMapping("/{id}/toggle-status")
    public ResponseEntity<ElectricalAppliance> toggleStatus(@PathVariable Long id) {
        return applianceService.findById(id)
                .map(appliance -> {
                    appliance.setStatus(!appliance.getStatus());
                    ElectricalAppliance updated = applianceService.update(appliance);
                    return ResponseEntity.ok(updated);
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteAppliance(@PathVariable Long id) {
        return applianceService.findById(id)
                .map(appliance -> {
                    applianceService.deleteById(id);
                    return ResponseEntity.ok().<Void>build();
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/type/{type}")
    public List<ElectricalAppliance> getByType(@PathVariable String type) {
        return applianceService.findByType(type);
    }

    @GetMapping("/search/name")
    public List<ElectricalAppliance> searchByName(@RequestParam String keyword) {
        return applianceService.searchByName(keyword);
    }

    @GetMapping("/search/location")
    public List<ElectricalAppliance> searchByLocation(@RequestParam String keyword) {
        return applianceService.searchByLocation(keyword);
    }
}
