---
jupyter:
  jupytext:
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.14.4
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

from math import sqrt
from pathlib import Path

import pandas as pd
import re
import spacy
```

```python
nlp = spacy.load("fr_core_news_sm")
```

```python
# Load EdX data

source = "../source/edx_app/"

courses_course = pd.read_csv(Path(source, "courses_course.csv"))
corpus = courses_course.short_description.dropna().reset_index(drop=True)

corpus
```

## Corpus similarity

Similarities between all short descriptions is computed. 

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

```

## Text embedding

```python
# Bag of words
low 
bow = sorted([re.sub("\W", " ", corpus[i]).lower().split() for i in range(len(corpus))])
bow = [x for x in bow if len(x) !=0]
```

```python
# Compute jaccard similarity

jaccard_index_table=[]
for x in range(len(bow)):
    jaccard_index_table_x = []
    for y in range(x, len(bow), 1):
        jaccard_index_table_x.append(jaccard_index(bow[x],bow[y]))
    jaccard_index_table.append(jaccard_index_table_x)
```

```python
# Display jaccard similarity


```

```python
# Compute euclidian distance

desc2vec = [nlp(description).vector for description in short_descriptions]
```

```python
euclidian_distance_table=[]
for x in range(len(desc2vec)):
    euclidian_distance_table_x = []
    for y in range(x, len(desc2vec), 1):
        euclidian_distance_table_x.append(euclidean_distance(desc2vec[x],desc2vec[y]))
    euclidian_distance_table.append(euclidian_distance_table_x)
    
print(euclidian_distance_table)
```

```python
# Frequency transformer
from sklearn.feature_extraction.text import TfidfTransformer

tf_transformer = TfidfTransformer(use_idf=False).fit(bow)
X_train_tf = tf_transformer.transform(bow)

```
