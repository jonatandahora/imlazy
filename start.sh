#!/bin/bash
/home/jonatan/.asdf/shims/pg_ctl start
deluged
PORT=8800 /home/jonatan/dev/elixir/imlazy/_build/prod/rel/imlazy/bin/imlazy start
