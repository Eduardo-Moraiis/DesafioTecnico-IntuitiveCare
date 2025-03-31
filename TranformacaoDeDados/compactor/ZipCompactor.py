import zipfile
from pathlib import Path

from compactor import Compactor

class ZipCompactor(Compactor):
    def __init__(self):
        pass

    def extract(self, filePath, destinyPath):
        sourcePath = Path(filePath)
        destPath = Path(destinyPath)

        if not sourcePath.exists():
            raise FileNotFoundError(f"Arquivo {filePath} não encontrado.")


        with zipfile.ZipFile(sourcePath, 'r') as zipRef:
            zipRef.extractall(destPath)

        print("Arquivos descompactados.")