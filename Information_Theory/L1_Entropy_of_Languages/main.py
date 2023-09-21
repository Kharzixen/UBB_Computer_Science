import nltk
import math
from numpy import math


def getEntropy(tokens):
    word_count = len(tokens)
    token_freq = {}
    summa = 0
    for token in tokens:
        token_freq[token] = 0
    for token in tokens:
        token_freq[token] += 1
    for key in token_freq:
        token_freq[key] = token_freq[key] / word_count
    for key in token_freq:
        summa += token_freq[key] * math.log2(token_freq[key])
    return -summa


def entropy(language):
    if language in ["hungarian", "hun"]:
        file_content = open("hungarian.txt", encoding="utf8").read()
        tokens = nltk.wordpunct_tokenize(file_content)

    if language in ["english", "en"]:
        file_content = open("english.txt", encoding="utf8").read()
        tokens = nltk.wordpunct_tokenize(file_content)

    if language in ["german", "de"]:
        file_content = open("german.txt", encoding="utf8").read()
        tokens = nltk.wordpunct_tokenize(file_content)

    bigrams = list(nltk.bigrams(tokens))
    trigrams = list(nltk.trigrams(tokens))

    unigram = getEntropy(tokens)
    bigram = getEntropy(bigrams)
    trigram = getEntropy(trigrams)

    print("\nUnigram: ", unigram)
    print("Bigram: ", bigram)
    print("Trigram: ", trigram)


print("Entropy of hungarian language")
entropy("hun")
print("\n\n")
print("Entropy of english language")
entropy("en")
print("\n\n")
print("Entropy of german language")
entropy("de")

