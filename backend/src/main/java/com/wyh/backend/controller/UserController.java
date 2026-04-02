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

    /**
     * 获取所有用户列表
     * @return List<User> 用户列表，如果无数据则返回空列表
     */
    @GetMapping
    public List<User> getAllUsers() {
        return userService.findAll();
    }

    /**
     * 根据 ID 获取用户
     * @param id 用户 ID，从 URL 路径中获取
     * @return ResponseEntity<User> 找到用户返回 200 OK 和用户信息；未找到返回 404 Not Found
     */
    @GetMapping("/{id}")
    public ResponseEntity<User> getUserById(@PathVariable Long id) {
        return userService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * 创建新用户
     * @param user 包含用户信息的对象，从请求体中获取
     * @return ResponseEntity<?> 用户名已存在返回 400 Bad Request；创建成功返回 200 OK 和保存后的用户信息
     */
    @PostMapping
    public ResponseEntity<?> createUser(@RequestBody User user) {
        if (userService.existsByUsername(user.getUsername())) {
            return ResponseEntity.badRequest().body("Username already exists");
        }
        User savedUser = userService.save(user);
        return ResponseEntity.ok(savedUser);
    }

    /**
     * 更新用户信息
     * @param id 用户 ID，从 URL 路径中获取
     * @param user 包含更新信息的用户对象，从请求体中获取
     * @return ResponseEntity<User> 更新成功返回 200 OK 和更新后的用户信息；用户不存在返回 404 Not Found
     */
    @PutMapping("/{id}")
    public ResponseEntity<User> updateUser(@PathVariable Long id, @RequestBody User user) {
        return userService.findById(id)
                .map(existingUser -> {
                    existingUser.setUsername(user.getUsername());
                    existingUser.setEmail(user.getEmail());
                    if (user.getPassword() != null && !user.getPassword().isEmpty()) {
                        existingUser.setPassword(user.getPassword());
                    }
                    return ResponseEntity.ok(userService.save(existingUser));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * 删除用户
     * @param id 用户 ID，从 URL 路径中获取
     * @return ResponseEntity<Void> 删除成功返回 200 OK；用户不存在返回 404 Not Found
     */
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
