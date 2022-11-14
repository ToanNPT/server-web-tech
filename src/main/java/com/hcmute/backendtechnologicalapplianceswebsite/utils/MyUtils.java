package com.hcmute.backendtechnologicalapplianceswebsite.utils;

import lombok.extern.slf4j.Slf4j;
import net.bytebuddy.utility.RandomString;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.io.File;
import java.io.IOException;

@Slf4j
public class MyUtils {
    public static String generateID(String PREFIX, int length, String lastIdStr) {
        long lastId = Long.parseLong(lastIdStr.substring(PREFIX.length()));

        while (lastId >= Math.pow(10, length))
            length = length + 1;

        String format = "%0" + length + "d";

        return PREFIX + String.format(format, lastId + 1);
    }

    public static String generateToken(int length) {
        String generatedString = RandomString.make(length);
        log.info("Generated token: " + generatedString);
        return generatedString;
    }

    public static String generateToken() {
        return generateToken(60);
    }

    public static boolean isImageFile(MultipartFile file) throws IOException {
        return ImageIO.read(file.getInputStream()) != null;
    }
}
