#!/usr/bin/python

import urllib2
import json

def read_stock(symbol):
  u = urllib2.urlopen("https://api.iextrading.com/1.0/stock/"+symbol+"/quote")
  query = u.read()
  a = json.loads(query)
  return("<span color='blue'>"+a['symbol']+": "+"</span>"+str(a['iexRealtimePrice'])+"$")

def currency(currency_src,currency_dst = "usd"):
  u = urllib2.urlopen("https://api.cryptonator.com/api/ticker/"+currency_src)
  query = u.read()
  a = json.loads(query)
  return("<span color='red'>"+a['ticker']['base']+"/"+a['ticker']['target']+": "+"</span>"+("%.6f" % float(a['ticker']['price'])))
  

#Stocks can be provided with just the symbol (AAPL) or exchange:symbol (NASDAQ:AAPL)

stocks={"RHT"}
currencies={"BTC-EUR","EUR-USD"}


for stock in stocks:
  print read_stock(stock)
print "---"
line = []
for i in currencies:
  line += [currency(i)]

#print " - ".join(line)+" | length=90"
print " \n".join(line)
