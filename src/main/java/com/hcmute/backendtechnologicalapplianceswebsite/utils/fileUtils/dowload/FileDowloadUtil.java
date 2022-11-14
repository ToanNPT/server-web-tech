package com.hcmute.backendtechnologicalapplianceswebsite.utils.fileUtils.dowload;

import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class FileDowloadUtil {
    private Path foundFile;

    public Resource getFileAsResource(String fileCode) throws IOException {
        Path uploadDirectory = Paths.get("src/main/resources/static/images");
        Files.list(uploadDirectory).forEach(file -> {
            if (file.getFileName().toString().startsWith(fileCode)) {
                foundFile = file;
            }
        });
        if (foundFile != null) {
            return new UrlResource(foundFile.toUri());
        }
        return null;
    }

}
