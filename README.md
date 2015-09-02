# tin-can

Talk over the wire.

Run app:

```
$ cabal run
```

Send a little data:

```js
// POST to localhost 8000
{
  "type": "insert",
  "clientId" : 1,
  "wChar": {
    "id": {
      "clientId": 1,
      "clock" : 0
    },
    "visible": true,
    "alpha": "T",
    "prevId": {
      "clientId": 0,
      "clock" : -1
    },
    "nextId": {
      "clientId": 0,
      "clock" : -2
    }  
  }
}
```
