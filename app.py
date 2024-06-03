from flask import Flask, request, jsonify
import requests
import json

app = Flask(__name__)


@app.route('/test', methods=["GET"])
def test():
    return 'Container is running', 200


@app.route('/recommendation', methods=["GET"])
def rec_data():
    item_id = request.args.get('item_id', None)
    page = request.args.get('page', default=0, type=int)
    rpp = request.args.get('rpp', default=5, type=int)
    type = request.args.get('type', default='publication', type=str)
    print(type)

    response = get_recommendations(item_id, type, page, rpp)
    return jsonify(response)

def get_recommendations(item_id, type, page, rpp):

    URL = 'http://0.0.0.0:9200/gesis-test/_search'

    headers = {
        'Content-Type': 'application/json'
    }

    query = {
        "query": {
            "bool": {
                "must": {
                    "more_like_this": {
                        "fields": [
                            "_all",
                            "title^10",
                            "topic^7",
                            "abstract^3",
                            "source^3",
                            "title_en^10",
                            "topic_en^7",
                            "abstract_en^3",
                            "title.partial^0.4",
                            "topic.partial^0.3",
                            "abstract.partial^0.2",
                            "content.partial^0.4",
                            "full_text^0.1"
                        ],
                        "like": [
                            {
                                "_index": "gesis-test",
                                "_id": item_id
                            }
                        ]
                    }
                },
                "filter": [
                    {
                        "term": {
                            "type": type
                        }
                    }
                ]
            }
        }
    }


    query_json = json.dumps(query)

    

    response = requests.post(url = URL, headers=headers, data = query_json)

    hit_list = []
    if response.status_code == 200:
        hit_list = [h['_id'] for h in response.json()['hits']['hits']]




    return {
        'page': page,
        'rpp': rpp,
        'item_id': item_id,
        'itemlist': hit_list,
        'num_found': len(hit_list)
    }




if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)