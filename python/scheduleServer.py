import requests
import cohere
import time
import csv
import numpy as np

from flask import Flask
from flask import request
from flask import jsonify
from collections import OrderedDict

app = Flask(__name__)
co = cohere.Client('m41doASsy8NROlwnw6TXLIhH0dhXV8XQEaYvYKvk')
@app.route("/",  methods=['POST'])
def hello():
    input_data = request.form['text']
    print(input_data)
    response = co.embed([input_data], model = 'large', truncate = 'END').embeddings
    print(np.asarray(response)[0])
    inputNPARRAY = np.asarray(response)[0]
    with open('my_csv_file 2.csv', 'r') as csvfile:
        reader = csvfile.read()
        string = reader[:reader.find('[')]
    #     print(string)
        classes = string.split(',')
        classes[len(classes)-1] = classes[len(classes)-1][:-1]
        # print(len(classes))
        embeddings = reader[reader.find('['):].replace(" ", "")
        embeddings = embeddings.replace('[', "")
        embeddings = embeddings.replace(']', "")
        embeddings = embeddings.replace("\n", ",")
        # print(embeddings[:100])
        # print(embeddings[:500])
        embed = []
        splitted = embeddings.split(',')
        for i in splitted:
            if( not i == ''):
                embed.append(float(i))
        # print(embed[:500])
        tupleArray = {}
        for i in range(len(classes)):
            itsEmbed = np.asarray(embed[4096 * i: 4096 *i + 4096])
            a = itsEmbed
            b = inputNPARRAY
            theINDEX = np.dot(a, b) / (np.linalg.norm(a) * np.linalg.norm(b))
            tupleArray[theINDEX] = classes[i]
    
            
        sorted_dict = dict(sorted(tupleArray.items(), reverse= True))
        print(sorted)
        count = 0
        fifteen = {}
        for i in sorted_dict:
            fifteen[i] = sorted_dict[i]
            count += 1
            if(count == 5):
                break
        reversed_dict = dict(reversed(list(fifteen.items())))
        return jsonify(reversed_dict)

@app.route("/friends", methods = ['POST'])
def friends_endpoint():
    print("here")
    print(request.data)
    data = request.get_json()
    print(data)
    first = data['first']
    second = data['second']
    print("here2")
    print(first)

    headers = {
        "accept": "application/json",
        "ucsb-api-version": "3.0",
        "ucsb-api-key": "JN6ET5dspuidWtBFOoR7vF7ub48OgWCO"
    }
    
    first_query = ""
    for course in first["courses"]:
        url = "https://api.ucsb.edu/academics/curriculums/v3/classes/20232/"
        url += course
        response = requests.get(url, headers=headers)
        data = response.json()
        print(data["description"][0:60])
        curr_class = data["title"] + data["classSections"][0]["timeLocations"][0]["beginTime"] + ":" + data["classSections"][0]["timeLocations"][0]["endTime"] + data["description"][0:60]
        first_query += curr_class
    
    response_first = co.embed([first_query], model='large', truncate="END")
    first_embedding = np.asarray(response_first.embeddings)

    tupleArray = {}
    for i, friend_uuid in enumerate(second):
        friend_query = ""
        for course in second[friend_uuid]:
            url = "https://api.ucsb.edu/academics/curriculums/v3/classes/20232/"
            url += course
            response = requests.get(url, headers=headers)
            data = response.json()
            curr_class = data["title"] + data["classSections"][0]["timeLocations"][0]["beginTime"] + ":" + data["classSections"][0]["timeLocations"][0]["endTime"] + data["description"][0:60]
            friend_query += curr_class
        
        friend_response = co.embed([friend_query], model='large', truncate="END")
        friend_embedding = np.asarray(friend_response.embeddings)
        similarity = (np.dot(first_embedding, friend_embedding.transpose()) / (np.linalg.norm(first_embedding) * np.linalg.norm(friend_embedding)))[0]
        print(similarity)
        tupleArray[similarity[0]] = friend_uuid
    
    sorted_dict = dict(sorted(tupleArray.items(), key=lambda x: x[0]))
    return jsonify(sorted_dict)



if __name__ == '__main__':
    app.run(host='0.0.0.0')
