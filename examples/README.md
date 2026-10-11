# Examples

## Programs (`programs/`)

| File | What it shows |
|---|---|
| `greet.s` | argc/argv handling; `greet Ada` → `Hello, Ada!` |
| `rot13.s` | stdin → stdout filter; works in pipes: `echo Hello \| rot13` |

More small programs live in [`os/programs/`](../os/programs/): `hello` (argv), `cat`, `wc`, `upper`,
`tick`/`loop`/`count` (multitasking and pre-emption demos), `skip` (seek).
Everything in these two folders is built by `python scripts/build.py` and installed in `/bin`.

## Recorded sessions (`sessions/`)

Console screens captured from the test suite: POST success/failure, directories and timestamps,
pipes and background tasks, pre-emption, `defrag`.

## Try it

```sh
python scripts/run.py "greet Ada\recho Hello | rot13\rls -l /bin\r"
```
