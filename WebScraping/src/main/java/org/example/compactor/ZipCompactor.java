package org.example.compactor;


import java.io.*;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public class ZipCompactor implements Compactor {
    public ZipCompactor() {
    }

    @Override
    public void compactFile(String folderPath, String zipFilePath) {
        File folder = new File(folderPath);
        File[] files = folder.listFiles();

        for(File file : files){
            if(file.getName().endsWith(".zip")){
                file.delete();
            }
        }

        try{
            zipFolder(folderPath, zipFilePath);
            System.out.println("Arquivos compactados em " + zipFilePath);
            deleteOriginalFiles(folderPath);
        }catch (IOException e){
            e.printStackTrace();
        }
    }

    private void zipFolder(String folderPath, String zipFilePath) throws IOException{
        File folder = new File(folderPath);
        File[] files = folder.listFiles();

        if(files == null || files.length == 0){
            System.out.println("Nenhum arquivo para compactar.");
            return;
        }

        for(File file : files){
            if(file.getName().endsWith(".zip")){
                file.delete();
            }
        }

        try (FileOutputStream fos = new FileOutputStream(zipFilePath);
             ZipOutputStream zos = new ZipOutputStream(fos)) {

            for (File file : files) {
                if (file.isFile()) { // Certifica que é um arquivo, não um diretório
                    addFileToZip(file, zos);
                }
            }
        }
    }

    private void addFileToZip(File file, ZipOutputStream zos) throws IOException{
        try(FileInputStream fis = new FileInputStream(file)){
            ZipEntry zipEntry = new ZipEntry(file.getName());
            zos.putNextEntry(zipEntry);

            byte[] buffer = new byte[1024];
            int bytesRead;

            while ((bytesRead = fis.read(buffer)) != -1) {
                zos.write(buffer, 0, bytesRead);
            }

            zos.closeEntry();
        }
    }

    private void deleteOriginalFiles(String folderPath){
        File folder = new File(folderPath);
        File[] files = folder.listFiles();

        if(files != null){
            for(File file : files){
                if(file.isFile() && !file.getName().endsWith(".zip")){
                    if(file.delete()){
                        System.out.println("Deletado: " + file.getName());
                    }else {
                        System.out.println("Não foi possivel deletar: " + file.getName());
                    }
                }
            }
        }
    }
}
