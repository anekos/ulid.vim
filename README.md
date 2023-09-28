An Vim Script library for [ULID (generating Universally Unique Lexicographically Sortable Identifiers)](https://github.com/ulid/spec).

# Install

```
Plug "anekos/ulid.vim"
```

# API

```vim
echo ulid#generate()
" 01HBDC1BARVN8E6NHPZYRWB6JP

let m = ulid#monotonic()
echo m.generate()
echo m.generate()
echo m.generate()
echo m.generate()
" 01HBDC1WX8KEVAW6XPYB6E0DC3
" 01HBDC1WX8KEVAW6XPYB6E0DC4
" 01HBDC1WX8KEVAW6XPYB6E0DC5
" 01HBDC1WX8KEVAW6XPYB6E0DC6
```

With options

```vim
echo ulid#generate({'time': localtime() * 1000, 'seed': srand('616')})
echo ulid#generate({'time': localtime() * 1000, 'seed': srand('616')})
" 01HBDC9NY0X79TF5KQHXHBF39Z
" 01HBDC9NY0X79TF5KQHXHBF39Z

let m = ulid#monotonic()
echo m.generate({'time': localtime() * 1000})
echo m.generate({'time': localtime() * 1000})
" 01HBDCC9XGHXM0X35W885PWFXJ
" 01HBDCC9XGHXM0X35W885PWFXK
```
