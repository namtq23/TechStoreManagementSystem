/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import java.security.SecureRandom;
import java.math.BigInteger;

public class TokenGenerator {

    private static SecureRandom random = new SecureRandom();

    public static String generateToken() {
        return new BigInteger(130, random).toString(32);
    }
}
