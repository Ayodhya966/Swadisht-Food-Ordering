
package com.swadisht.util;

import java.security.MessageDigest;
import java.security.SecureRandom;
import java.security.spec.KeySpec;
import java.util.Base64;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public final class AdminAuth {

    private static final int ITERATIONS = 210000;
    private static final int KEY_LENGTH = 256;

    private AdminAuth() {}

    public static boolean verifyPassword(String password) {
        if (password == null) {
            return false;
        }

        String stored = System.getenv("SWADISHT_ADMIN_PASSWORD_HASH");

        if (stored == null || stored.isBlank()) {
            return false;
        }

        try {
            String[] parts = stored.split(":", 2);

            if (parts.length != 2) {
                return false;
            }

            byte[] salt = Base64.getDecoder().decode(parts[0]);
            byte[] expected = Base64.getDecoder().decode(parts[1]);
            byte[] actual = hash(password.toCharArray(), salt);

            return MessageDigest.isEqual(expected, actual);

        } catch (Exception e) {
            return false;
        }
    }

    public static String createHash(char[] password)
            throws Exception {

        byte[] salt = new byte[16];
        new SecureRandom().nextBytes(salt);

        byte[] hashed = hash(password, salt);

        return Base64.getEncoder().encodeToString(salt)
                + ":"
                + Base64.getEncoder().encodeToString(hashed);
    }

    private static byte[] hash(char[] password, byte[] salt)
            throws Exception {

        KeySpec spec = new PBEKeySpec(
                password, salt, ITERATIONS, KEY_LENGTH
        );

        try {
            SecretKeyFactory factory =
                    SecretKeyFactory.getInstance(
                            "PBKDF2WithHmacSHA256"
                    );

            return factory.generateSecret(spec).getEncoded();

        } finally {
            ((PBEKeySpec) spec).clearPassword();
        }
    }
}
