" ========== Basic ==========
set number
set relativenumber

set tabstop=4
set shiftwidth=4
set expandtab
" set smartindent  " not supported by VsVim

set nowrap
set cursorline
set scrolloff=8
" signcolumn is a Neovim/terminal thing; VsVim ignores it

" ========== Search ==========
set ignorecase
set smartcase
"set hlsearch
set incsearch

" ========== Clipboard ==========
" VsVim already integrates with the Windows clipboard.
" 'unnamedplus' is Neovim-specific; use 'unnamed' if you want to force it.
set clipboard=unnamed

" ========== UI ==========
" set splitbelow  " not supported by VsVim
" set splitright  " not supported by VsVim
" termguicolors and colorcolumn are UI/terminal features; not used by VsVim.
" Add a column/ruler at 88 in VS itself (see notes below).

" ========== Leader & basic keymaps ==========
let mapleader=" "
nnoremap <Space> <Nop>

" Quick save / quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>

" ========== Navigation ==========
" Buffer/document navigation (works as 'next/prev open document' in VsVim)
nnoremap <S-h> :bprevious<CR>
nnoremap <S-l> :bnext<CR>

" Splits (VS splits the current editor view)
nnoremap <leader>v :vsplit<CR>
nnoremap <leader>s :split<CR>
nnoremap <leader>n :vnew<CR>
" Tabs (Vim tabpages aren't really a thing in VS; see notes)
" nnoremap <leader>t :tabnew<CR>

" Window navigation via leader
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

" Center the view when moving up and down
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Center after next/prev match, without fold-opening
nnoremap n nzz
nnoremap N Nzz

" ========== Developer Essentials ==========
" Keep selection when indenting in visual mode
vnoremap < <gv
vnoremap > >gv

" Move selected lines up/down and keep selection
xnoremap J :vsc Edit.MoveSelectedLinesDown<CR>
xnoremap K :vsc Edit.MoveSelectedLinesUp<CR>
"These dont work:
" vnoremap J :m '>+1<CR>gv=gv
" vnoremap K :m '<-2<CR>gv=gv
"vnoremap J :<C-U>silent! '<,'>move '>+1<CR>'<,'>normal! gv=gv
"vnoremap K :<C-U>silent! '<,'>move '<-2<CR>'<,'>normal! gv=gv

" Visual mode: paste over selection without overwriting the unnamed register
xnoremap <leader>p "_dP

" ========== Commenting (VS commands) ==========
nnoremap gcc V:vsc Edit.ToggleLineComment<CR><Esc>
xnoremap gc :vsc Edit.ToggleLineComment<CR>

" ========== Case transform (VS commands) ==========

" Visual mode: gu / gU apply to the selection
xnoremap gu :vsc Edit.MakeLowercase<CR>
xnoremap gU :vsc Edit.MakeUppercase<CR>

" Normal mode: guu / gUU apply to the current line
nnoremap guu V:vsc Edit.MakeLowercase<CR><Esc>
nnoremap gUU V:vsc Edit.MakeUppercase<CR><Esc>>

" Find in Files (Ctrl+Shift+F)  -> command: Edit.FindinFiles
nnoremap <leader>ff :vsc Edit.FindinFiles<CR>
xnoremap <leader>ff :vsc Edit.FindinFiles<CR>

" Go To: members (GoTo with "m:" workflow)
nnoremap <leader>fs :vsc Edit.GoToMember<CR>
xnoremap <leader>fs :vsc Edit.GoToMember<CR>

" Replace (Ctrl+H) -> command: Edit.Replace
nnoremap <leader>H :vsc Edit.Replace<CR>

" VS navigation (like the IDE back/forward arrows)
nnoremap <C-o> :vsc View.NavigateBackward<CR>

" Ctrl-i is often seen as <Tab> — map BOTH, so one of them will work
nnoremap <C-i> :vsc View.NavigateForward<CR>

" Go to Implementation (Ctrl+F12 behavior)
nnoremap gi :vsc Edit.GoToImplementation<CR>

" Signature Help / Parameter Info (like Ctrl+Shift+Space)
nnoremap gk :vsc Edit.ParameterInfo<CR>

" Go to References (Find All References)
nnoremap gr :vsc Edit.FindAllReferences<CR>

" Rename symbol
nnoremap <leader>rn :vsc Refactor.Rename<CR>

" Hover / Quick Info tooltip (like Ctrl+K, Ctrl+I)
nnoremap K :vsc Edit.QuickInfo<CR>

" Code Actions / Quick Actions and Refactorings (Ctrl+.)
nnoremap <leader>ca :vsc View.QuickActions<CR>

" ========== Solution Explorer ==========
" Open Solution Explorer and reveal/select the active file in the tree
" (equivalent to Neovim's neo-tree Ctrl+E behavior)
" Note: to close Solution Explorer, press Esc while it is focused.
nnoremap <C-e> :vsc SolutionExplorer.SyncWithActiveDocument<CR>
