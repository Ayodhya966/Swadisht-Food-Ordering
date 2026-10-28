
package com.swadisht.util;

import java.util.Scanner;

public class GenerateAdminHash {
    public static void main(String[] args) throws Exception {
        Scanner sc = new Scanner(System.in);

        System.out.print("Enter new admin password: ");
        String password = sc.nextLine();

        String hash = AdminAuth.createHash(password.toCharArray());

        System.out.println("\nYour password hash is:");
        System.out.println(hash);

        sc.close();
    }
}

