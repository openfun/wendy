---
jupyter:
  jupytext:
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.14.5
  kernelspec:
    display_name: Python 3 (ipykernel)
    language: python
    name: python3
---

# Explore courses data

## References

- https://newscatcherapi.com/blog/ultimate-guide-to-text-similarity-with-python
- https://www.analyticsvidhya.com/blog/2021/08/a-friendly-guide-to-nlp-bag-of-words-with-python-example/
- https://www.geeksforgeeks.org/item-to-item-based-collaborative-filtering/
- https://borgelt.net/pyfim.html

```python
# Import libraries and modules

from math import sqrt,exp
from pathlib import Path
import pandas as pd
import re
import spacy
import itertools
import seaborn as sns 
```

```python
nlp = spacy.load("fr_core_news_sm")
```

```python
# Load EdX data

source = "../source/edx_app/"

courses_course = pd.read_csv(Path(source, "courses_course.csv"))
corpus = courses_course[['id', 'short_description']].dropna(subset='short_description').reset_index(drop=True)

corpus
```

## Text representations

 - Text embeddings
 - Word embeddings
 


## Similarity measures

- Jaccard index
- Euclidean distance
- Cosine similarity

```python
# Similarities definition

def jaccard_index(x : list,y :list):
    """Return the jaccard index between two lists."""
    intersection_cardinality = len(set.intersection(*[set(x), set(y)]))
    union_cardinality = len(set.union(*[set(x), set(y)]))
    return intersection_cardinality/float(union_cardinality)

def euclidean_distance(x :list, y: list):
    """Return the euclidean distance between two lists."""
    return sqrt(sum(pow(a-b,2) for a, b in zip(x, y)))

def squared_sum(x):
    """ return 3 rounded square rooted value """
    return round(sqrt(sum([a*a for a in x])),3)

def cosine_similarity(x,y):
    """Return cosine similarity between two lists."""

    numerator = sum(a*b for a,b in zip(x,y))
    denominator = squared_sum(x)*squared_sum(y)
    return round(numerator/float(denominator),3)

```

## Text embedding

```python
corpus_bow = {}

for row in corpus.iterrows():
    bow = re.sub("\W", " ", row[1]['short_description']).lower().split()
    if len(bow)!=0:
        corpus_bow[row[1]['id']] = bow
    
```

```python
corpus_combination = list(itertools.combinations(corpus_bow.keys(), 2))
```

```python
# Compute jaccard similarity

jaccard_index_table= []
for x,y in corpus_combination: 
    index = jaccard_index(corpus_bow[x], corpus_bow[y])
    jaccard_index_table.append([x,y,index])
```

```python
# Display jaccard similarity
raw_data = pd.DataFrame(jaccard_index_table, columns = ['Corpus_X', 'Corpus_Y', 'index'])
data = raw_data.pivot('Corpus_X', 'Corpus_Y', 'index')
sns.heatmap(data)
```

```python
# Text embedding for euclidean distance
corpus_text_embeddings = {}

for row in corpus.iterrows():
    vector = nlp(row[1]['short_description']).vector
    corpus_text_embeddings[row[1]['id']] = vector

```

```python
corpus_text_combination = list(itertools.combinations(corpus_text_embeddings.keys(), 2))
```

```python
# Compute euclidean distance

euclidean_distance_table=[]
for x,y in corpus_text_combination: 
    distance = euclidean_distance(corpus_text_embeddings[x], corpus_text_embeddings[y])
    euclidean_distance_table.append([x,y,distance])
    
```

```python
euclidean_distance_table_normalized = [[euclidean_distance_table[i][0], euclidean_distance_table[i][1], distance_to_similarity(euclidean_distance_table[i][2])] for i in range(len(euclidean_distance_table))]                                                                                                                                   
```

```python
# Display euclidean distance

raw_data = pd.DataFrame(euclidean_distance_table_normalized, columns = ['Corpus_X', 'Corpus_Y', 'distance'])
data = raw_data.pivot('Corpus_X', 'Corpus_Y', 'distance')
sns.heatmap(data)
```

```python
# Compute cosine similarity

cosine_similarity_table=[]
for x,y in corpus_text_combination: 
    distance = cosine_similarity(corpus_text_embeddings[x], corpus_text_embeddings[y])
    cosine_similarity_table.append([x,y,distance])

```

```python
# Display cosine similarity

raw_data = pd.DataFrame(cosine_similarity_table, columns = ['Corpus_X', 'Corpus_Y', 'distance'])
data = raw_data.pivot('Corpus_X', 'Corpus_Y', 'distance')
sns.heatmap(data)
```
