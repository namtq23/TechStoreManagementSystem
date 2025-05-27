/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Astersa
 */
public class AuthenticationUtil {

    //Check xem damin da dang nhap hay chua
    public static boolean isAdminAuthenticated(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        System.out.println("Checking auth - Session: " + (session != null ? session.getId() : "null"));
        System.out.println("adminId: " + (session != null ? session.getAttribute("adminId") : "null"));
        return (session != null && session.getAttribute("adminId") != null);
    }

    //Lay id cua admin
    public static int getAuthenticatedAdminId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("adminId") != null) {
            return (Integer) session.getAttribute("adminId");
        }
        return -1;
    }

    //Dang xuat
    public static void logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }
}
