# Booze exchange

An Elixir application to simulate a stock-exchange for booze through Elixir actor model. 


To run the simulation:

```
cd app
mix run --no-halt
```


It simulates a bar with 4 drinks and 4 customers purchasing drinks randomly. 
When a drink is purchased, its price increases by 0.01. If other drinks haven't been purchased for more than 30 seconds, their prices decrease by 0.01.
