# Mush Tests

## Utilities

Save full output of a command with colors to a file:

```shell
script -q /dev/null -c "make test-build-rust-app" > colored_output.txt
```


Creare il comando echofake

https://github.com/francescobianco/mush-packages/blob/main/packages/echofake/Manifest.toml

che ha il compuito di riprodurre uno statement echo che stampa a video l'output del comando passato come argomento.

```shell
echofake "ls -la"
```

riportando i colori e la formattazione del comando originale con gli spazi esatti