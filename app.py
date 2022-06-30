from flask import Flask, jsonify, request
import json

from lib2to3.pgen2 import token
from os import remove
import numpy as np 
import pandas as pd
import nltk 
import string
import random

col_list = ["Unnamed: 1"]
df = pd.read_csv('Task.csv')
#ler csv

df_column = df["Unnamed: 1"]
df_column = df_column[1:]
df_column = df_column.values.tolist();
df_column = map(lambda x: x.lower(), df_column)
raw_text = '\n'.join(df_column)


#nltk.download('punkt')
#nltk.download('wordnet')
#nltk.download('omw-1.4')
global sent_tokens, word_tokens
sent_tokens = nltk.sent_tokenize(raw_text)
word_tokens = nltk.word_tokenize(raw_text)

lemmer = nltk.stem.WordNetLemmatizer()

def LemTokens(tokens):
    return [lemmer.lemmatize(token) for token in tokens]
remove_punk_dict = dict((ord(punct), None) for punct in string.punctuation)

def LemNormalize(text):
    return LemTokens(nltk.word_tokenize(text.lower().translate(remove_punk_dict)))

GREET_INPUTS = ("hello", "hi","sup","hey")

GREET_RESPONSES = ["hi","hey","hello","I am glad you are here"] # melhorar as mensagens

def greet(sentence):

    for word in sentence.split():
        if word.lower() in GREET_INPUTS:
            return random.choice(GREET_RESPONSES)

from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

def Resposta(user_response):
    robo1_response =""
    TfidfVec = TfidfVectorizer(tokenizer=LemNormalize)
    tfidf = TfidfVec.fit_transform(sent_tokens)
    vals = cosine_similarity(tfidf[-1], tfidf)
    idx = vals.argsort()[0][-2]
    flat = vals.flatten()
    flat.sort()
    req_tfidf = flat[-2]
    if(req_tfidf == 0):
        robo1_response= robo1_response + "I am sorry i can not help you, try again"
        return robo1_response
    else:
        robo1_response = robo1_response + sent_tokens[idx]
        return robo1_response



def main(name,word_tokens):
    user_response = str(name)
    user_response = user_response.lower()
    if(user_response == 'thanks' or user_response == 'thank you'):
        return("Nono Bot: You are welcome...")
    else:
        if(greet(user_response)!=None):
            return("Nono Bot: "+ greet(user_response))
        else:
            sent_tokens.append(user_response)
            word_tokens = word_tokens + nltk.word_tokenize(user_response)
            final_words = list(set(word_tokens))
            aux = "Nono Bot: " + Resposta(user_response)
            sent_tokens.remove(user_response)
            return aux


def Teste2(name):
    return name * 2


def Teste(name):
    if(name == 'acnesol gel'):
        aux = str(name).split(' ')
        return('É o que tu querias ' + Teste2(name)+ ' ' + aux[1])
    else: 
        return(name)

def respostaTeste(name):
    return name * 3

#declared an empty variable for reassignment
response = ''
resposta = " "
name = "error"
#creating the instance of our flask application
app = Flask(__name__)

#route to entertain our post and get request from flutter app
@app.route('/name', methods = ['GET', 'POST'])
def nameRoute():

    #fetching the global response variable to manipulate inside the function
    global response
  
        
    #checking the request type we get from the app
    if(request.method == 'POST'):
        print('olá')
        request_data = request.data #getting the response data
        request_data = json.loads(request_data.decode('utf-8')) #converting it from json to key value pair
        name = request_data['name'] #assigning it to name
        print(name);
        #response = Teste(name)
        #response = f'Hi {name}! this is Python' #re-assigning response with the name we got from the user
        aux = main(str(name),word_tokens)
        response = f'{aux}'
        print(str(aux))
        return " " #to avoid a type error 
    else:
        return jsonify({'name' : response}) #sending data back to your frontend app

if __name__ == "__main__":
    app.run(debug=True)

