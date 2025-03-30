package org.example.webscraper;

import org.example.downloader.Downloader;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.example.compactor.Compactor;

public class WebScraper {
    public static void WebScraperDownloader(String pageUrl, String pathDownloadFile, String[] fileToDownload){
        //Faz a requisição para obter HTML da página
        try {
            Document document = Jsoup.connect(pageUrl).get();

            for(String file : fileToDownload){
            Element linkElement = document.selectFirst("a:contains(" + file + ")");

                if(linkElement != null){
                    String fileUrl = linkElement.attr("href");

                    if(!fileUrl.startsWith("http") || !fileUrl.startsWith("https")){
                        fileUrl = pageUrl + fileUrl;
                    }

                    String fileName = fileUrl.substring(fileUrl.lastIndexOf("/") +1);
                    String pathFile = pathDownloadFile + "/" + fileName;
                    Downloader.downloadFile(fileUrl, pathFile);

                    System.out.println("Download concluido: " + pathDownloadFile + fileName);

                }else{
                    System.out.println("Nenhum link de download encontrado.");
                }
            }
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}
