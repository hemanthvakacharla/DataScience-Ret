import numpy as np # linear algebra
import pandas as pd # data processing, CSV file I/O (e.g. pd.read_csv)
from subprocess import check_output
print(check_output(["ls", "../input"]).decode("utf8")) 	.

products = pd.read_csv("../input/products.csv")

products.tail()
ailes = pd.read_csv("../input/aisles.csv")
departments = pd.read_csv("../input/departments.csv")
order_products_prior = pd.read_csv("../input/order_products__prior.csv")
order_products_train = pd.read_csv("../input/order_products__train.csv")
orders = pd.read_csv("../input/orders.csv")
products = pd.read_csv("../input/products.csv")
sample_submission = pd.read_csv("../input/sample_submission.csv")

ailes.head()
departments.head()
order_products_prior.head()
order_products_train.head()
orders.head()
products.head()	
sample_submission.head()
order_products_train2 = pd.merge(order_products_train, orders, on='order_id', how='outer')

order_products_train2.head()
print(order_products_train["reordered"].value_counts())