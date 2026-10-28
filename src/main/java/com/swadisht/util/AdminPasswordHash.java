
package com.swadisht.util;

import java.io.Console;
import java.util.Arrays;

public class AdminPasswordHash {

    public static void main(String[] args) throws Exception {

        Console console = System.console();

        if (console == null) {
            System.out.println(
                "Please run this program in a real terminal."
            );
            return;
        }

        char[] password = console.readPassword(
            "Enter your new admin password: "
        );

        if (password == null || password.length < 12) {
            System.out.println(
                "Password must be at least 12 characters long."
            );
            if (password != null) {
                Arrays.fill(password, '\0');
            }
            return;
        }

        char[] confirm = console.readPassword(
            "Confirm your admin password: "
        );

        if (confirm == null || !Arrays.equals(password, confirm)) {
            System.out.println("Passwords do not match.");
            Arrays.fill(password, '\0');
            if (confirm != null) {
                Arrays.fill(confirm, '\0');
            }
            return;
        }

        try {
            String hash = AdminAuth.createHash(password);
            System.out.println("\nYour password hash is:");
            System.out.println(hash);
            System.out.println(
                "\nCopy it securely. Do not share it with anyone."
            );
        } finally {
            Arrays.fill(password, '\0');
            Arrays.fill(confirm, '\0');
        }
    }
}

