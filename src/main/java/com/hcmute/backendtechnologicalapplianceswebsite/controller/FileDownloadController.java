package com.hcmute.backendtechnologicalapplianceswebsite.controller;

import com.hcmute.backendtechnologicalapplianceswebsite.utils.fileUtils.dowload.FileDowloadUtil;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.activation.FileTypeMap;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

@CrossOrigin(origins = {"http://localhost:3000", "http://localhost:4200"})
@RestController
@RequestMapping("/")
public class FileDownloadController {
    @GetMapping("downloadFile/{fileCode}")
    public ResponseEntity<?> dowloadFile(@PathVariable("fileCode") String fileCode) {
        FileDowloadUtil dowloadUtil = new FileDowloadUtil();
        Resource resource;
        try {
            resource = dowloadUtil.getFileAsResource(fileCode);
        } catch (IOException e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
        if (resource == null) {
            return new ResponseEntity<>("File not found", HttpStatus.NOT_FOUND);
        }
        String contenttype = "application/octet-stream";
        String headerValue = "attachment; filename=\"" + resource.getFilename() + "\"";
        return ResponseEntity.ok().contentType(MediaType.parseMediaType(contenttype)).header(HttpHeaders.CONTENT_DISPOSITION, headerValue).body(resource);
    }

    @GetMapping("getImage/{fileCode}")
    public ResponseEntity<byte[]> getImage(@PathVariable("fileCode") String fileCode) throws IOException {
        File img = new File("src/main/resources/static/images/" + fileCode);
        return ResponseEntity.ok().contentType(MediaType.valueOf(FileTypeMap.getDefaultFileTypeMap().getContentType(img))).body(Files.readAllBytes(img.toPath()));
    }
}
