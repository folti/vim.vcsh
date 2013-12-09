" my filetype file
augroup filetypedetect
    au! BufNewFile,BufRead *.txt    setf txt
augroup END

augroup filetypedetect
    au! BufNewFile,BufRead *.moin    setf moin
    au! BufNewFile,BufRead wscript*    setf python
    au! BufNewFile,BufRead *.nsh    setf nsis
    au! BufNewFile,BufRead *.wxs    setf xml
augroup END

augroup filetype
  au BufRead reportbug.*                set ft=mail
  au BufRead reportbug-*                set ft=mail
  au BufNewfile,BufRead muttng*         set ft=mail
augroup END
