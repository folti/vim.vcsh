" scmchanges.vim -- plugin to show diffs and create changelog skeletons for tla and cvs
" @Author:      Tamas Pal (mailto:folti@balabit.hu)
" @Website:     <+WWW+>
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-07-04.
" @Last Change: 2007.07.04.
" @Revision:    0.0

if &cp || exists("loaded_scmchanges")
    finish
endif
let loaded_scmchanges = 1

command! -nargs=0 TlaChanges call TlaChanges()
command! -nargs=0 CVSChanges call CVSChanges()
command! -nargs=0 GitChanges call GitChanges()

function! TlaChanges()
    exec 'norm 1G'
    " airbags
    " add an empty entry
    if search("/^\t\* /","W") < 1 
        exec 'norm GG'
        call append(".","\t\* ")
    endif
    
    " Add end of file marker NEWS--(for historical reason)
    exec 'norm 1G'
    if search("^NEWS","W") < 1 
        exec 'norm GG'
        call append(".","NEWS\-\-")
    endif
    
    " create a new buffer and get the tla diffs into it.
    exec 'vnew'
    exec 'r !tla changes --diffs'
    exec 'norm 1G'
    " make it uneditable
    exec 'set ft=diff ro nomodified nomodifiable noswapfile'
    
    " yank all modifications from the diffbuffer.
    exec '/^* comparing/,/^--- /-1y'
    
    " and put them to the changelog buffer, after the first * line.
    silent exe "norm! \<C-W>w" 
    exec '1/^\t\*/'
    exec 'norm p'

    " del all entries regarding file attribute changes.
    if search ("^* file meta","W" ) > 0
    	exec '/^* file meta/,/^* /d'
    endif

    " del all lines starting with *(tla remarks) or <tab>* empty changelog
    " entries
    exec '1,/^NEWS/g/^\*/d'
    exec '1,/^NEWS/g/^\t\* $/d'
    exec 'norm 1G'

    if search("^-- ","W") > 0
        exec '1,/^--/g/^--.*$/d'
    endif 
    
    " delete all .id file entries
    exec 'norm 1G'
    while search("^[AMD=].*(\.|=)id$","W") > 0
        exec '/^[AMD=].*\.id$/d'
    endwhile

    " delete all .arch-ids entries
    exec 'norm 1G'
    while search("^[AMD=].*\.arch-ids","W") > 0
        exec '1,/^NEWS/g/^[AMD=].*\.arch-ids/d'
    endwhile

    " handle directory add/remove
    exec 'norm 1G'
    if search("^A\/","W") >0
        exec '1,/^NEWS/s/^\(A\)\/\(\|\/\)\(.*\)/\t*\3: Added directory/'
    endif

    exec 'norm 1G'
    if search("^D\/","W") >0
        exec '1,/^NEWS/s/^\(D\)\/\(\|\/\)\(.*\)/\t*\3: Deleted directory/'
    endif

    " replace all file modification lines (^[AMD]  <filename>) with 
    " \t* <filename>: <type of change>
    exec '1,/^NEWS/s/^\([AMD]\)\( \|\/\)\(.*\)/\t*\3: \1/'
    exec 'norm 1G'
    " look for file/directory renaming lines. change them to renamed to.
    if search("^=>","W") > 0
        exec '1,/^NEWS/s/^=> \([^\t]*\)\t/\t*\1: renamed to /'
    endif

    " what does it do?
    exec '1,/^NEWS/s/^\(\t\*.*\)$/\1\r/'
    
    " remove eof marker.
    exec 'norm 1G'
    if search("^NEWS--","W") > 0 
        exec '.,.d'
    endif
    
    exec 'norm 1G'
    exec 'norm $'
endfunction

function! GitChanges()
    exec '%s/^#\t\([a-z ]*\):   \(.*\)/  * \2: \1/g'
    exec 'norm 1G'
    " create a new buffer and get the tla diffs into it.
    exec 'vnew'
    exec 'r !git diff --cached'
    exec 'norm 1G'
    " make it uneditable
    exec 'set ft=diff ro nomodified nomodifiable noswapfile'
    
    " and put them to the changelog buffer, after the first * line.
    silent exe "norm! \<C-W>w" 
    exec 'norm 1G'
endfunction

function! CVSChanges()
    exec 'vnew'
    exec 'r !cvs diff'
    exec 'norm 1G'
    exec 'set ft=diff ro nomodified nomodifiable noswapfile'
    while search("^Index: ","W" ) > 0 
	exec '/Index: .*/y'
	silent exe "norm! \<C-W>w" 
	exec 'norm p'
	exec '.,.s/.*: \([^ ]*\)/\t\* \1: \r/'
	silent exe "norm! \<C-W>w" 
    endwhile
endfunction

" vim:  expandtab ts=4

