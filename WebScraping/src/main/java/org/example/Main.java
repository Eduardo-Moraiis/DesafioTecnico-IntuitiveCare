package org.example;

import org.example.compactor.Compactor;
import org.example.compactor.ZipCompactor;
import org.example.webscraper.WebScraper;

public class Main {
    public static void main(String[] args) {
        String pageUrl = "https://www.gov.br/ans/pt-br/acesso-a-informacao/participacao-da-sociedade/atualizacao-do-rol-de-procedimentos";

        String pathDownloadFile = "output";

        String[] fileToDownload = {"Anexo I", "Anexo II"};

        Compactor compactor = new ZipCompactor();

        WebScraper.WebScraperDownloader(pageUrl, pathDownloadFile, fileToDownload);

        compactor.compactFile("output/", "output/arquivos_compactados.zip");

    }
}