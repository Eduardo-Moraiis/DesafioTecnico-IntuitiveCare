from pathlib import Path
from ExtractTable import extractTable

from compactor.ZipCompactor import ZipCompactor

if __name__ == '__main__':
    compactor = ZipCompactor()
    basePath = Path(__file__).parent.parent
    outputPath = basePath / "WebScraping" / "output" / "arquivos_compactados.zip"
    inputPath = basePath / "TranformacaoDeDados" / "input"
    try:
        compactor.extract(outputPath,inputPath)
    except FileNotFoundError as e:
        print(e)

    extractTable()