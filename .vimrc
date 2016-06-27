version 6.0
" if &cp | set nocp | endif
let s:cpo_save=&cpo
set cpo&vim
map! <xHome> <Home>
map! <xEnd> <End>
map! <S-xF4> <S-F4>
map! <S-xF3> <S-F3>
map! <S-xF2> <S-F2>
map! <S-xF1> <S-F1>
map! <xF4> <F4>
map! <xF3> <F3>
map! <xF2> <F2>
map! <xF1> <F1>
vnoremap p :let current_reg = @"gvdi=current_reg
map <xHome> <Home>
map <xEnd> <End>
map <S-xF4> <S-F4>
map <S-xF3> <S-F3>
map <S-xF2> <S-F2>
map <S-xF1> <S-F1>
map <xF4> <F4>
map <xF3> <F3>
map <xF2> <F2>
map <xF1> <F1>
let &cpo=s:cpo_save
unlet s:cpo_save

set autoindent
set background=dark
set backspace=indent,eol,start
set backupcopy=yes
set fileencodings=ucs-bom,utf-8,latin1
set history=50
set printoptions=paper:a4
set ruler
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set viminfo='20,\"50
" more sena for me
set tabstop=4 sw=4
set hlsearch incsearch
set cursorline
set statusline=%F%m%r%h%w\ [%{&ff}]\ [%Y]\ (%03.3b\ 0x%02.2B)%=%04l,%04v/%L\ %3p%%
set linespace=2
set laststatus=2
set modeline
set backupskip=~/net/*
set mouse=a

set wildmenu
set wildmode=list:longest,full

" always numbers, all the time
set nu

" initialize the pathogen plugin
call pathogen#infect()

syn on
colorscheme desert
if &term =~ '.*256color'
    colorscheme desert256
    set t_Co=256
endif

" damn you debian
filetype plugin on

" load the separate identity file
if filereadable(expand("$HOME/.vim-identities"))
so $HOME/.vim-identities
endif

" -= rcsvers.vim =-
let g:rvSaveDirectoryType=1
let g:rvSaveDirectoryName='$HOME/.vim/RCSFiles/'
let g:rvExcludeExpression='\c_tmp\|\c\.tmp\|mutt\|cvs\|__BUFFERLIST__\|++log\.\|known_hosts\|w3mtmp\|/mnt/net/.*\|/home/folti/net/.*'

"re-map rcsvers.vim keys
map <F8> \rlog

" toggle the Gundo window.
" http://sjl.bitbucket.org/gundo.vim/
nnoremap <F6> :GundoToggle<CR>

" -= bufferlist.vim =-
map <silent> <F5> :call BufferList()<CR>
hi BufferSelected term=reverse ctermfg=white ctermbg=red cterm=bold
hi BufferNormal term=NONE ctermfg=grey ctermbg=black cterm=NONE
let g:BufferListWidth = 30

" Map key to toggle opt
" http://vim.wikia.com/wiki/Quick_generic_option_toggling
function! MapToggle(key, opt)
   let cmd = ':set '.a:opt.'! \| set '.a:opt."?\<CR>"
   exec 'nnoremap '.a:key.' '.cmd
   exec 'inoremap '.a:key." \<C-O>".cmd
endfunction
command! -nargs=+ MapToggle  call MapToggle(<f-args>)
" Display-altering option toggles

MapToggle <F1> paste
MapToggle <F2> scrollbind
MapToggle <F3> wrap
MapToggle <F9> number

" Behavior-altering option toggles
set pastetoggle=<F1>

" Map key to toggle opt
function! HexToggle(key)
   let cmd = ':%!xxd<CR>'
   let ucmd = ':%!xxd -r<CR>'
   exec 'nnoremap '.a:key.' '.cmd
   exec 'inoremap '.a:key." \<C-O>".ucmd
endfunction
command! -nargs=+ HexToggle  call HexToggle(<f-args>)

HexToggle <F4>

" -= explorer.vim =-
let explVertical=1
let explSplitRight=1

" -= taglist.vim =-
noremap <silent> <F10> :Tlist<CR>

" -= vimproject =-
let g:proj_flags='imstbg'

" Diff the current buffer with it's source file. Taken from:
" http://vim.wikia.com/wiki/Diff_current_buffer_and_the_original_file
function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

" http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
"Only do this part when compiled with support for autocommands.
if has("autocmd")
  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

endif " has("autocmd")

"====[ Make tabs, trailing whitespace, and non-breaking spaces visible ]======
exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~"
set list

"" highlight spaces at the end of line.
" highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
" highlight WhitespaceEOL term=reverse ctermbg=Red guibg=Red
" match WhitespaceEOL /\s\+$/

" Python
au BufNewFile,BufRead *.zts setf python

"" force json filetype for files with .json extension
au BufRead,BufNewFile *.json setf json

" make the 81st column stand out
highlight ColorColumn ctermbg=red

function! s:SetLastColumn()
    let _colorcolumn=81
    if &filetype == "gitcommit"
        let _colorcolumn=76
    elseif &filetype == "mail"
        let _colorcolumn=76
    elseif &filetype == "python"
        let _colorcolumn=119
    elseif &filetype == "vim"
        let _colorcolumn=0
    endif
    call matchadd('ColorColumn', '\%'._colorcolumn.'v', 100)
endfunction

"" LustyExplorer
set hidden

" Debian changelog related functions
" Helper functions returning various data.
" Returns full name, either from $DEBFULLNAME or debianfullname.
" TODO Is there a way to determine name from anywhere else?
function! <SID>FullName()
    if exists("$DEBFULLNAME")
	return $DEBFULLNAME
    elseif exists("g:debianfullname")
	return g:debianfullname
    else
	return "Your Name"
    endif
endfunction

" Returns email address, from $DEBEMAIL, $EMAIL or debianemail.
function! <SID>Email()
    if exists("$DEBEMAIL")
	return $DEBEMAIL
    elseif exists("$EMAIL")
	return $EMAIL
    elseif exists("g:debianemail")
	return g:debianfullemail
    else
	return "your@email.address"
    endif
endfunction

" Returns date in RFC822 format.
function! <SID>Date()
    let savelang = v:lc_time
    execute "language time C"
    let dateandtime = strftime("%a, %d %b %Y %X %z")
    execute "language time " . savelang
    return dateandtime
endfunction

function! <SID>SHDate()
    let savelang = v:lc_time
    execute "language time C"
    let dateandtime = strftime("%Y-%m-%d")
    execute "language time " . savelang
    return dateandtime
endfunction

function! <SID>AMDate()
    let savelang = v:lc_time
    execute "language time C"
    let dateandtime = strftime("%d %b %Y")
    execute "language time " . savelang
    return dateandtime
endfunction

function! README_Finalise()
    call setline(".", " -- " . <SID>FullName() . " <" . <SID>Email() . ">  " . <SID>Date())
endfunction

function! SHChglog()
    call append(".","# ".<SID>SHDate()." <bamba>")
endfunction

" Zorp version of NewVersion call from debchangelog.vim. Instead of raising
" version number, adds a .zorpos33.1 suffix to it.
function! NewZVersion()
    if &filetype != "debchangelog"
        echohl MoreMsg
        call input("Not a Debian changelog file! Hit ENTER")
        echohl None
        return
    endif
    " The new entry is unfinalised and shall be changed
    call append(0, substitute(getline(1),'\([[:digit:]]\+\))', '\1.zorpos33.1)', ''))
    call append(1, "")
    call append(2, "")
    call append(3, " -- ")
    call append(4, "")
    call Distribution("3-3-security")
    call Urgency("low")
    normal 1G0
    call search(")")
    normal h
    normal 
"    call setline(1, substitute(getline(1),'\([[:digit:]]\+\))', '\1.zorpos1)', ''))
    if exists("g:debchangelog_fold_enable")
        foldopen
    endif
    call AddEntry()
    startinsert!
endfunction

function BBDistribution(dist)
    call setline(1, substitute(getline(1), ") [[:lower:][:digit:] -]*;", ") " . a:dist . ";", ""))
endfunction

function! Distchange(dist)
    if &filetype != "debchangelog"
        echohl MoreMsg
        call input("Not a Debian changelog file! Hit ENTER")
        echohl None
        return
    endif
    if a:dist == "33sec"
        call BBDistribution("3-3-security")
    elseif a:dist == "31sec"
        call BBDistribution("3-1-security")
    elseif a:dist == "31"
        call BBDistribution("zorpos31")
    elseif a:dist == "33"
        call BBDistribution("zorpos33")
    elseif a:dist == "40"
        call BBDistribution("zorpos40")
    else
        call BBDistribution(a:dist)
    endif
endfunction

function! DebChgMaps()
    command! -n=0 Nv :call NewVersion()
    command! -n=0 Nzv :call NewZVersion()
    command! -n=0 Fi :call Finalise()
    command! -n=1 Dc :call Distchange(<bang><f-args>)
endfunction

function! DelDebChgMaps()
    delcommand Nv
    delcommand Nzv
    delcommand Fi
    delcommand Dc
endfunction

augroup debchangelog
    au BufEnter * if &filetype == "debchangelog" | call DebChgMaps() | endif
    au BufLeave * if &filetype == "debchangelog" | call DelDebChgMaps() | endif
augroup END

function! MaintChg()
    let lno=line(".")
    exec 'norm 1G'
    if line("$") > 20
    let l = 20
    else
    let l = line("$")
    endif
    if search("^Maintainer: ","W") > 0
        exe "1," . l . "g/Maintainer: /s/Maintainer: .*/Maintainer: " . g:debianfullname  . " <" . g:debianemail . ">"
    endif

    if search("^Packager: ","W") > 0
        exe "1," . l . "g/Packager: /s/Packager: .*/Packager: " . g:debianfullname  . " <" . g:debianemail . ">"
    endif

    if search("^Uploaders: ","W") > 0
         exe "1," . l . "g/Uploaders: /d"
    endif
    exec 'norm '.lno.'G'
endfun

au BufEnter,BufRead * call s:SetLastColumn()

if &term =~ "xterm\\|rxvt"
  " use an orange cursor in insert mode
  let &t_SI = "\<Esc>]12;red\x7"
  " use a red cursor otherwise
  let &t_EI = "\<Esc>]12;grey\x7"
  silent !echo -ne "\033]12;grey\007"
  " reset cursor when vim exits
  autocmd VimLeave * silent !echo -ne "\033]112\007"
  " use \003]12;gray\007 for gnome-terminal and rxvt up to version 9.21
endif

" vim:  expandtab ts=4 sw=4
