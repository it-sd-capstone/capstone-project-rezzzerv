package controller;

import java.io.*;

import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.ServletException;
import service.RoomService;

@WebServlet("/roomForm")

public class RoomServlet {

    private RoomService roomService;

    public void init(){
        roomService = new RoomService();
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) {

    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) {
        
    }
}
