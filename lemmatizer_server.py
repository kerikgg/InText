# lemmatizer_server.py

from flask import Flask, request, jsonify
import spacy

app = Flask(__name__)
nlp = spacy.load("ru_core_news_sm")

@app.route("/lemmatize", methods=["POST"])
def lemmatize():
    data = request.get_json()
    text = data.get("text", "")

    if not text:
        return jsonify({"error": "No text provided"}), 400

    doc = nlp(text)
    lemmas = [token.lemma_.lower() for token in doc if token.is_alpha]

    return jsonify({"lemmas": lemmas})

if __name__ == "__main__":
    app.run(host="127.0.0.1")
