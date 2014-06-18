runtime! debian.vim
"设置编码
set encoding=utf-8
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936
set fileencodings=utf-8,ucs-bom,chinese

"语言设置
set langmenu=zh_CN.UTF-8

"""""""""""""""""""""""""""""""
" Vbundle
"""""""""""""""""""""""""""""""
"vbundle使用，可以用来管理插件
     set rtp+=~/.vim/bundle/vundle/
     call vundle#rc()

     " let Vundle manage Vundle
     " required! 
     Bundle 'gmarik/vundle'

     " My Bundles here:  /* 插件配置格式 */
     "   
     " original repos on github （Github网站上非vim-scripts仓库的插件，按下面格式填写）
     "Bundle 'tpope/vim-fugitive'
     "Bundle 'Lokaltog/vim-easymotion'
     "Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
     "Bundle 'tpope/vim-rails.git'
	 Bundle 'chriskempson/tomorrow-theme'
     " vim-scripts repos  （vim-scripts仓库里的，按下面格式填写）
     "Bundle 'L9'
     "Bundle 'FuzzyFinder'
	 Bundle 'ctags.vim'
     Bundle 'taglist.vim'
	 Bundle 'cscope.vim'
	 Bundle 'The-NERD-tree'
	 "Bundle 'Solarized'
	 Bundle 'winmanager'
	 Bundle 'guicolorscheme.vim'
     " non github repos   (非上面两种情况的，按下面格式填写)
     Bundle 'git://git.wincent.com/command-t.git'
     " ... 

    
     "                                           /** vundle命令 **/
     " Brief help
     " :BundleList          - list configured bundles
     " :BundleInstall(!)    - install(update) bundles
     " :BundleSearch(!) foo - search(or refresh cache first) for foo 
     " :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
     "   
     " see :h vundle for more details or wiki for FAQ 
     " NOTE: comments after Bundle command are not allowed..






""""""""""""""""""""""""""""""""""""""""""""""
" CScope
""""""""""""""""""""""""""""""""""""""""""""""
if has("cscope")
            set csprg=/usr/bin/cscope
		 	set cst	" 使支持用 Ctrl+]  和 Ctrl+t 快捷键在代码间跳来跳去
            " check cscope for definition of a symbol before checking ctags:
            " set to 1 if you want the reverse search order.
             set csto=1
			 set nocsverb
			 set cscopequickfix=s-,c-,d-,i-,t-,e- "设定是否使用quickfix窗口显示cscope结果
             " add any cscope database in current directory
             if filereadable("cscope.out")
                 cs add cscope.out
             " else add the database pointed to by environment variable
             elseif $CSCOPE_DB !=""
                 cs add $CSCOPE_DB
             endif

             " show msg when any other cscope db added
             "set cscopeverbose
			 set csverb
			 nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>:copen<CR>
			 nmap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>
			 nmap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>:copen<CR>
			 nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>:copen<CR>
			 nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>:copen<CR>
			 nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>:copen<CR>
			 nmap <C-_>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>:copen<CR>
			 nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>:copen<CR>

endif

"设置F12更新tags方法
map <F12> :call Do_CsTag()<CR>
function! Do_CsTag()
    let dir = getcwd()
    if filereadable("tags")
        if(has("win32") || has("win95") || has("win64") || has("win16"))
            let tagsdeleted=delete(dir."\\"."tags")
        else
            let tagsdeleted=delete("./"."tags")
        endif
        if(tagsdeleted!=0)
            echohl WarningMsg | echo "Fail to do tags! I cannot delete the tags" | echohl None
            return
        endif
    endif
    if has("cscope")
        silent! execute "cs kill -1"
    endif
    if filereadable("cscope.files")
        if(has("win32") || has("win95") || has("win64") || has("win16"))
            let csfilesdeleted=delete(dir."\\"."cscope.files")
        else
            let csfilesdeleted=delete("./"."cscope.files")
        endif
        if(csfilesdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.files" | echohl None
            return
        endif
    endif
    if filereadable("cscope.out")
        if(has("win32") || has("win95") || has("win64") || has("win16"))
            let csoutdeleted=delete(dir."\\"."cscope.out")
        else
            let csoutdeleted=delete("./"."cscope.out")
        endif
        if(csoutdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.out" | echohl None
            return
        endif
    endif
    if(executable('ctags'))
        "silent! execute "!ctags -R --c-types=+p --fields=+S *"
        silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
    endif
    if(executable('cscope') && has("cscope") )
        if(!(has("win32") || has("win95") || has("win64") || has("win16")))
            silent! execute "!find . -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.py' -o -name '*.java' -o -name '*.php' -o -name '*.cs' -o -name '*.inc' > cscope.files"
        else
            silent! execute "!dir /s/b *.c,*.cpp,*.h,*.py,*.java,*.php,*.cs,*.inc >> cscope.files"
        endif
        silent! execute "!cscope -bq -i cscope.files"
        execute "normal :"
        if filereadable("cscope.out")
            execute "cs add cscope.out"
        endif
    endif
endfunction

"set autochdir "自动切换当前目录为文件所在目录
""""""""""""""""""""""""""""""""""""""""""""""
" Taglist
""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <F8> :TlistToggle<CR><CR>  " 按F8按钮，在窗口的左侧出现taglist的窗口,像vc的左侧的workpace
" :Tlist              调用TagList
let Tlist_Show_One_File=0                    " 只显示当前文件的tags
let Tlist_File_Fold_Auto_Close=1			 "非当前文件，函数列表折叠隐藏
let Tlist_Exit_OnlyWindow=1                  " 如果Taglist窗口是最后一个窗口则退出Vim
let Tlist_Use_SingleClick=1	                 "单击时跳转
let Tlist_GainFocus_On_ToggleOpen=1          "打开taglist时获得输入焦点
let Tlist_Use_Right_Window=0                 " 在右侧窗口中显示
let Tlist_Process_File_Always=1              "不管taglist窗口是否打开，始终解析文件中的tag








""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree
""""""""""""""""""""""""""""""""""""""""""""""
map <silent> <F6> :NERDTreeToggle<cr>      " 使用<F6>键就打开/关闭NERDTree窗口
let NERDTreeMinimalUI = 1                               " 关闭书签标签('Press ? for help')
let NERDTreeDirArrows = 1                               "  改变目录结点的显示方式(+/~)
""""""""""""""""""""""""""""""""""""""""""""""""""
"winmanager
"""""""""""""""""""""""""""""""""""""""""""""""
let g:winManagerWindowLayout='FileExplorer|TagList'
nmap wm :WMToggle<cr>




"""""""""""""""""""""""""""""""""""""""""""""""
" Basic 
"""""""""""""""""""""""""""""""""""""""""""""
"去掉vi一致性
set nocompatible

"载入文件类型插件
filetype plugin on

"为特定的文件类型载入相关缩进文件
filetype indent on

"设置当文件被外部改变的时侯自动读入文件
if exists("&autoread")
    set autoread
endif

let mapleader=','
let g:mapleader=','
"set system clipboard
nmap <Leader>c "*y
nmap <Leader>v "*p


"""""""""""""""""""""""""""""""""""""""""""""""""
"用户接口设置
"""""""""""""""""""""""""""""""""""""""""""""""""

"设置7行在光标的上下，当使用j/k移动的时候
set so=7

"打开wild menu
set wildmenu

"忽略编译文件
set wildignore=*.o,*~,*.pyc
"总是显示当前位置
set ruler

"命令栏的高度
set cmdheight=2

"set backspace=2				" make backspace work like most other apps
set backspace=indent,eol,start " 不设定在插入状态无法用退格键和 Delete 键删除回车符
set whichwrap+=h,l			"允许backspace和光标键跨越行边界

"搜索的时候忽略大小写
set ignorecase
set smartcase				"搜索的时候更聪明

"set hisearch				"高亮搜索结果
set incsearch				"设置增量搜索模式

"高亮显示匹配括号
set showmatch

"设置静音模式
set noerrorbells
set novisualbell
set t_vb=
set tm=500

""""""""""""""""""""""""""""""""""""""""""
"编辑器的颜色和字体
""""""""""""""""""""""""""""""""""""""""""
"设置语法高亮
syntax enable
syntax on

"设置方案
colorscheme Tomorrow-Night
set background=dark

if has("gui_running")
	set guioptions-=T           " 隐藏工具栏
	set guioptions+=e
	set t_Co=256
	set guitablabel=%M\ %t
endif

"set font=Mono\ 11
set guifont=Ubuntu\ Mono\ 13


""""""""""""""""""""""""""""""""""""""""""""
"文件和备份
"""""""""""""""""""""""""""""""""""""""""""

set nobackup
set nowb
set noswapfile

"""""""""""""""""""""""""""""""""""""""""""""
"Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""
                            
set number
set expandtab
"智能tab
set smarttab
"设置缩进
set tabstop=4
set shiftwidth=4

set ai "Auto indent"
set si "smart indent"
set wrap "Wrap lines"

"设置默认shell
set shell=bash
"设置VIM记录的历史数
set history=400

"设置ambiwidth
set ambiwidth=double
"设置文件类型
set ffs=unix,dos,mac

"修改vimrc后自动生效
autocmd! bufwritepost .vimrc source ~/.vimrc


"""""""""""""""""""""""""""""""""""""
"状态栏
""""""""""""""""""""""""""""""""""""
set laststatus=2
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

"可以在buffer的任何地方使用鼠标
set mouse=a
set selection=exclusive
set selectmode=mouse,key
set completeopt=longest,menu "关掉智能补全时的预览窗口






"""""""""""""""""""""""""""""""""""""""""""""
"快捷键设置
"""""""""""""""""""""""""""""""""""""""""""""
"系统剪贴板设置

"设置复制快捷键
vnoremap <leader>c "+y
"设置剪切快捷键
vnoremap <leader>x "+d
"设置粘贴快捷键
nnoremap <leader>v "+p

"用Tab跳转到匹配的括号
map <tab> %

"利用空格键来开关折叠
set foldenable
set foldmethod=manual
nnoremap @=((foldclosed(line('.')<0))<0? 'zc':'zo')


"""""""""""""""""""""""""""""""""""""""""
" Helper function
"""""""""""""""""""""""""""""""""""""""""
"return true if paste mode if enabled
function! HasPaste()
	if &paste
		return 'PASTE MODE '
	en
	return ''
endfunction

