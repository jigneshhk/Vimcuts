"written by Jignesh Kakadiya

if !has('python')
    echo "not supported python version" finish
endif

"function! Vimcuts_goto_window_buffer_name(name)"{{{
"    if bufwinnr(bufnr(a:name)) != -1
"        exe bufwinnr(bufnr(a:name)) . "wincmd w"
"        return 1
"    else
"        return 0
"    endif
"endfunction"}}}

"function! Vc_is_visible()"{{{
"    if bufwinnr(bufnr("__VIMCUTS__")) != -1
"        return 1
"    else
"        return 0
"    endif
"endfunction"}}}

"function! VCClose()"{{{
"if bufwinnr(bufnr('__VIMCUTS__')) != -1
"        exe bufwinnr(bufnr('__VIMCUTS__')) . "wincmd w"
"        setlocal nomodifiable
"        quit
"        return 1
"   else
"        echo "vimcuts is already closed!"
"        return 0
"    endif
"endfunction"}}}

function! OpenVC()

python << EOF
import vim

def OpenVC():
    #vim.command(':set splitright')
    vim.command(':botright vnew __VIMCUTS__')

    vim.current.window.width = 50

    fp = open('data.mkd', 'r')
    data = fp.read()
    spl = data.split('\n');
    for dat in spl:
        vim.current.buffer.append(dat);
    fp.close()
    vc_isopen = True;
    vim.command('setlocal buftype=nofile')
    vim.command('setlocal bufhidden=hide')
    vim.command('setlocal noswapfile')
    vim.command('setlocal nobuflisted')
    vim.command('setlocal filetype=vimcuts')
    vim.command('setlocal nomodifiable')
    vim.command('setlocal nolist')
    vim.command('setlocal nonumber')
    vim.command('setlocal norelativenumber')
    vim.command('setlocal nowrap')

target = int(vim.eval("bufwinnr('__VIMCUTS__')"))-1
if target >= 0 and target < len(vim.windows):
    print "vimcuts is already open at window: ", target+1
else:
    global curbuf
    global pos
    curbuf = vim.eval('bufnr(bufname("%"))')
    pos = vim.current.window.cursor
    OpenVC()
EOF

nnoremap <script> <silent> <buffer> q :call CloseVC()
cabbrev  <script> <silent> <buffer> q  call CloseVC()
cabbrev  <script> <silent> <buffer> quit call CloseVC()

syn match vcbullets '='
syn match vcb '*'

syn match vchelp '\ *\ '
syn match vcNumberField '\v\[[0-9]+\]'
syn match vcNumber '\v[0-9]+' contained containedin=vcNumberField

hi def link vchelp Comment
hi def link vcNumberField Comment
hi def link vcNumber Identifier

hi def link vcbullets Keyword
hi def link vcb Keyword

endfunction

function! CloseVC()
python << EOF
import vim

def CloseVc():
    target = int(vim.eval("bufwinnr('__VIMCUTS__')"))
    #vim.current.buffer.append(str(target)+ " " + str(len(vim.windows)))
    if target >= 0 and target <= len(vim.windows):
            vim.command('%dwincmd w' % target)
            vim.command('setlocal modifiable')
            vim.current.buffer[:] = None
            vim.command('wincmd c')
            vim.command('%dbuffer' % int(curbuf))
            vim.current.window.cursor = pos
    else:
        print "vimcuts is already closed!"

CloseVc()
EOF

endfunction
