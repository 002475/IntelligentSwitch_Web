package com.wyh.backend.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PageController {

    /**
     * 首页入口，重定向到登录页面
     * @return String 返回登录页面视图名称
     */
    @GetMapping("/")
    public String index() {
        return "login";
    }

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    @GetMapping("/register")
    public String register() {
        return "register";
    }

    @GetMapping("/home")
    public String home() {
        return "home";
    }

    @GetMapping("/appliances")
    public String appliances() {
        return "electricalappliancesHome";
    }

    @GetMapping("/log")
    public String log() {
        return "logHome";
    }

    @GetMapping("/useredit")
    public String useredit() {
        return "useredit";
    }

    @GetMapping("/applianceedit")
    public String applianceedit() {
        return "electricalappliancesedit";
    }

    @GetMapping("/tasks")
    public String tasks() {
        return "tasksHome";
    }

    @GetMapping("/taskedit")
    public String taskedit() {
        return "taskedit";
    }
}
