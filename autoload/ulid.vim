let s:alphabet = '0123456789ABCDEFGHJKMNPQRSTVWXYZ'

let s:time_part_length = 10
let s:random_part_length = 16

function s:timestamp_part(time)
  if a:time is v:null
    let l:t = localtime() * 1000
  else
    let l:t = a:time
  endif

  let l:res = ''
  for _ in range(1, s:time_part_length)
    let l:rem = l:t % 32
    let l:t = l:t / 32
    let l:res = s:alphabet[l:rem] . l:res
  endfor

  return l:res
endfunction

function s:random_bytes(seed)
  let l:res = []
  for _ in range(1, s:random_part_length)
    call add(l:res, rand(a:seed) % 32)
  endfor
  return l:res
endfunction

function s:increment_bytes(bytes)
  let l:res = []
  let l:carry = 1
  for i in range(0, len(a:bytes) - 1)
    let l:sum = a:bytes[i] + l:carry
    let l:carry = l:sum / 32
    call add(l:res, l:sum % 32)
  endfor
  return l:res
endfunction

function s:random_part(bytes)
  let l:res = ''
  for i in range(0, len(a:bytes) - 1)
    let l:res = s:alphabet[a:bytes[i]] . l:res
  endfor
  return l:res
endfunction

function s:generate(time, seed)
  return s:timestamp_part(a:time) . s:random_part(s:random_bytes(a:seed))
endfunction

function! s:options(args)
  let l:opts = get(a:args, 0, {})
  let l:time = get(l:opts, 'time', localtime() * 1000)
  let l:seed = get(l:opts, 'seed', srand())
  return [l:time, l:seed]
endfunction

function! ulid#generate(...)
  let [l:time, l:seed] = s:options(a:000)
  return s:generate(l:time, l:seed)
endfunction

function! s:monotonic_generate(...) dict
  let [l:time, l:seed] = s:options(a:000)

  if self.last_at is l:time && self.last_bytes isnot v:null
    let self.last_bytes = s:increment_bytes(self.last_bytes)
  else
    let self.last_bytes = s:random_bytes(l:seed)
  endif

  let self.last_at = l:time

  let l:result = s:timestamp_part(l:time) . s:random_part(self.last_bytes)
  return l:result
endfunction

function! ulid#monotonic()
  let l:state = {
  \   'last_at': v:null,
  \   'last_bytes': v:null,
  \   'generate': function('s:monotonic_generate'),
  \ }
  return l:state
endfunction
