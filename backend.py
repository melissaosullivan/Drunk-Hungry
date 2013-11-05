from flask import Flask, request, jsonify
import foursquare
app = Flask(__name__)
client = foursquare.Foursquare(client_id='3NL43YODEKB2KMTIWBYGMONIQANNRKCGXX11OCSFJ1A4OEXU', client_secret='LFGUETUP01IADEEWD15XAXYMR1Q1BWZQVNSS4VLA3ZA3PW05')
@app.route("/")
def foursquare():
    result = []
    blob = client.venues.explore(params={'ll': request.args.get('lat') + ',' + request.args.get('lng'), 'selection': 'food', 'venuePhotos': '1', 'price': '1', 'openNow':'1'})
    for venue in blob['groups'][0]['items']:
        try:
            result.append({"name" : venue['venue']['name'], "photo" : venue['venue']['photos']['groups'][0]['items'][0]['prefix'] + '400x400' + venue['venue']['photos']['groups'][0]['items'][0]['suffix']})
        except Exception, e:
            pass
    return jsonify({"venues": result})
if __name__ == "__main__":
    app.run()