# Valgrind

## memory check
```bash
valgrind --leak-check=full --show-reachable=yes --track-origins=yes --log-file=valgrind.log cmd
```

