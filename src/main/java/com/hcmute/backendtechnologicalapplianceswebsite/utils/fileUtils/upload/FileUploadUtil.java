package com.hcmute.backendtechnologicalapplianceswebsite.utils.fileUtils.upload;

import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

public class FileUploadUtil {
    public static void saveFile(String fileName, MultipartFile multipartFile) {
        Path uploadDirectory = Paths.get("src/main/resources/static/images").toAbsolutePath().normalize();
        if (fileName.contains(".."))
            throw new RuntimeException("File name is invalid");
        else
            try (InputStream inputStream = multipartFile.getInputStream()) {
                Path filePath = uploadDirectory.resolve(fileName);
                Files.copy(inputStream, filePath, StandardCopyOption.REPLACE_EXISTING);
            } catch (IOException e) {
                throw new RuntimeException("Could not save file: " + fileName, e);
            }
    }
}
