package com.hcmute.backendtechnologicalapplianceswebsite.controller;

import com.hcmute.backendtechnologicalapplianceswebsite.utils.MyUtils;
import com.hcmute.backendtechnologicalapplianceswebsite.utils.fileUtils.upload.FileUploadUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;

@Slf4j
@CrossOrigin(origins = {"http://localhost:3000", "http://localhost:4200"})
@RestController
@RequestMapping("/api/technological_appliances/")
public class FileUploadController {
    @PostMapping("/uploadFile")
    public ResponseEntity<String> uploadFile(@RequestParam("files") MultipartFile[] files) {

        StringBuilder ImgName = new StringBuilder();
        for (var file : files) {
            String tempName = GetFileNameImg(file);
            ImgName.append(tempName);
        }
        return ResponseEntity.ok().body(ImgName.toString());
    }

    private String GetFileNameImg(MultipartFile file) {
        String fileName = UUID.randomUUID()
                + Objects.requireNonNull(file.getOriginalFilename()).substring(file.getOriginalFilename().lastIndexOf("."));
        FileUploadUtil.saveFile(fileName, file);
        return fileName;
    }

    @PostMapping("/uploadImage")
    public ResponseEntity<Map<String, String>> uploadImage(@RequestParam("image") MultipartFile[] files) throws IOException {
        String getUrl = "http://localhost:8080/getImage/";
        Map<String, String> image = new HashMap<>();
        int i = 1;
        for (var file : files) {
            if (file != null && !file.isEmpty() && MyUtils.isImageFile(file)) {
                StringBuilder ImgName = new StringBuilder();
                ImgName.append(getUrl);

                String tempName = GetFileNameImg(file);
                ImgName.append(tempName);

                image.put("image" + i++, ImgName.toString());
                // Allow four images
                if (i > 4) break;
            }
        }
        return ResponseEntity.ok(image);
    }
}
