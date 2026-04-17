package com.wyh.backend.controller;

import com.wyh.backend.model.User;
import com.wyh.backend.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "*")
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping
    public List<User> getAllUsers() {
        return userService.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<User> getUserById(@PathVariable Long id) {
        return userService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/search")
    public List<User> searchUsers(@RequestParam String keyword) {
        return userService.searchUsers(keyword);
    }

    @PostMapping("/register")
    public ResponseEntity<?> registerUser(@RequestBody User user) {
        if (user.getPassword() == null || user.getPassword().isEmpty()) {
            return ResponseEntity.badRequest().body("密码不能为空");
        }
        
        if (user.getPassword().length() < 6) {
            return ResponseEntity.badRequest().body("密码长度至少 6 位");
        }
        
        if (userService.existsByUsername(user.getUsername())) {
            return ResponseEntity.badRequest().body("用户名已存在");
        }
        
        if (user.getRole() == null || user.getRole().isEmpty()) {
            user.setRole("USER");
        }
        
        User savedUser = userService.save(user);
        return ResponseEntity.ok(savedUser);
    }

    @PostMapping
    public ResponseEntity<?> createUser(@RequestBody User user) {
        if (userService.existsByUsername(user.getUsername())) {
            return ResponseEntity.badRequest().body("用户名已存在");
        }
        if (user.getRole() == null || user.getRole().isEmpty()) {
            user.setRole("USER");
        }
        User savedUser = userService.save(user);
        return ResponseEntity.ok(savedUser);
    }

    @PutMapping("/{id}")
    public ResponseEntity<User> updateUser(@PathVariable Long id, @RequestBody User user) {
        return userService.findById(id)
                .map(existingUser -> {
                    if (!existingUser.getUsername().equals(user.getUsername())) {
                        if (userService.existsByUsername(user.getUsername())) {
                            throw new RuntimeException("用户名已存在");
                        }
                    }
                    existingUser.setUsername(user.getUsername());
                    existingUser.setEmail(user.getEmail());
                    if (user.getRole() != null && !user.getRole().isEmpty()) {
                        existingUser.setRole(user.getRole());
                    }
                    if (user.getPassword() != null && !user.getPassword().isEmpty()) {
                        existingUser.setPassword(user.getPassword());
                    }
                    return ResponseEntity.ok(userService.save(existingUser));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        return userService.findById(id)
                .map(user -> {
                    userService.deleteById(id);
                    return ResponseEntity.ok().<Void>build();
                })
                .orElse(ResponseEntity.notFound().build());
    }
}
