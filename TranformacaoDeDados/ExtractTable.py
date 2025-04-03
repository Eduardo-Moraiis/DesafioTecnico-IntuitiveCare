from pathlib import Path

import pandas as pd
import zipfile
from io import StringIO
import pdfplumber

def extractProceduresFromPdf(pdfPath):
    procecures = []

    with pdfplumber.open(pdfPath) as pdf:
        for page in pdf.pages:
            tables = page.extract_tables()

            for table in tables:
                if len(table)>1 and len(table[0])>=12:
                    if not procecures:
                        header = table[0] ##pegar cabeçalho
                    else:
                        header = None

                    for row in table[1:]:
                        if len(row)>=12 and row[0].strip():
                            procecures.append(row)

    if procecures:
        df = pd.DataFrame.from_records(procecures, columns=['PROCEDIMENTO', 'RN (alteração)', 'VIGÊNCIA', 'OD', 'AMB', 'HCO',
                                                            'HSO', 'REF', 'PAC', 'DUT', 'SUBGRUPO', 'GRUPO', 'CAPÍTULO'])
        return df
    return pd.DataFrame()

def cleanAndTransformData(df):
    df=df[df['PROCEDIMENTO'].str.strip().astype(bool)]

    abbreviationMap = {
        'OD': 'Seg. Odontológica',
        'AMB': 'Seg. Ambulatorial',
        'HCO': 'Seg. Hospitalar Com Obstetrícia',
        'HSO': 'Seg. Hospitalar Sem Obstetrícia',
        'REF': 'Plano Referência',
        'PAC': 'Procedimento de Alta Complexidade',
        'DUT': 'Diretriz de Utilização'
    }

    df['OD'] = df['OD'].apply(lambda x: abbreviationMap['OD'] if pd.notna(x) and str(x).strip() else '')
    df['AMB'] = df['AMB'].apply(lambda x: abbreviationMap['AMB'] if pd.notna(x) and str(x).strip() else '')

    df = df.map(lambda x: x.strip() if isinstance(x, str) else x)

    return df

def saveToZip(df, myName, outputZip):
    csvBuffer = StringIO()
    df.to_csv(csvBuffer, index=False, encoding='utf-8-sig')
    csvContent = csvBuffer.getvalue()

    zipFileName = f"Teste_{myName}.zip"
    zipPath = outputZip / zipFileName
    with zipfile.ZipFile(zipPath, 'w', zipfile.ZIP_DEFLATED) as zipf:
        zipf.writestr("procedimentos_saude.csv", csvContent)

    return zipFileName

def extractTable():
    pdfPath = Path(__file__).parent / "input" / "Anexo_I_Rol_2021RN_465.2021_RN627L.2024.pdf"
    myName = "Eduardo_Morais_Silva_Martins"
    outputZip = Path(__file__).parent / "output"

    print("Extraindo dados do pdf")
    df = extractProceduresFromPdf(pdfPath)

    if not df.empty:
        print("limpando e tranformando os dados")
        df = cleanAndTransformData(df)

        print("Salvando zip")
        zipFile = saveToZip(df, myName, outputZip)
        print(f"Arquivo {zipFile} criado")
    else:
        print("nenhum dado foi extraido")
