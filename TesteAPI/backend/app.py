from flask import Flask, jsonify, request
from flask_cors import CORS
import pandas as pd
app = Flask(__name__)
CORS(app)

df = pd.read_csv('../inputfile/Relatorio_cadop.csv', sep=';', encoding='utf-8')

@app.route('/testapi', methods=['GET'])
def testapi():
    query = request.args.get('q', default='')
    begin = request.args.get('begin', default=0, type=int)
    limit = request.args.get('limit', default=20, type=int)

    if(limit > len(df)):
        limit = len(df)

    if(begin > len(df)):
        return jsonify(404,{"error": "inicio fora do data frame"})

    if query == '':
        df_copy = df.iloc[begin:limit].fillna("N/A").copy()
        if len(df_copy) == 0:
            return jsonify(404,{"error": f"error"})
        return jsonify({"count": len(df_copy),
                        "resultas": df_copy.to_dict(orient='records')})
    else:
        df_copy = df[df['Razao_Social'].str.contains(query, case=False, na=False)]
        df_copy = df_copy.fillna("N/A")
        if len(df_copy) == 0:
            return jsonify(404,{"error": f"Nenhum resultado foi encontrado para: {query}"})
        else:
            return jsonify({"count": len(df_copy),
                            "resultas": df_copy.to_dict(orient='records')})



if __name__ == '__main__':
    app.run(debug=True)