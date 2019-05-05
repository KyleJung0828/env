#!/bin/bash


# Bash COLORS

COLOR_NONE='\033[0m'
COLOR_BLACK='\033[0;30m'
COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_BROWN='\033[0;33m'
COLOR_BLUE='\033[0;34m'
COLOR_PURPLE='\033[0;35m'
COLOR_CYAN='\033[0;36m'
COLOR_LIGHT_GRAY='\033[0;37m'
COLOR_DARK_GRAY='\033[1;30m'
COLOR_LIGHT_RED='\033[1;31m'
COLOR_LIGHT_GREEN='\033[1;32m'
COLOR_YELLOW='\033[1;33m'
COLOR_LIGHT_BLUE='\033[1;34m'
COLOR_LIGHT_PURPLE='\033[1;35m'
COLOR_LIGHT_CYAN='\033[1;36m'
COLOR_WHITE='\033[1;37m'

install_vundle() {
    if [ -e ~/.vim/bundle/Vundle.vim ]; then
        echo -e "${COLOR_RED} Vundle is already installed. ${COLOR_NONE}"
    else
        git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
        echo ' ' >> ~/.vimrc
        echo 'set nocompatible              " be iMproved, required' >> ~/.vimrc
        echo 'filetype off                  " required' >> ~/.vimrc
        echo '" set the runtime path to include Vundle and initialize' >> ~/.vimrc
        echo 'set rtp+=~/.vim/bundle/Vundle.vim' >> ~/.vimrc
        echo 'call vundle#begin()' >> ~/.vimrc
        echo '" let Vundle manage Vundle, required' >> ~/.vimrc
        echo "Plugin 'VundleVim/Vundle.vim'" >> ~/.vimrc
        echo "Plugin 'vim-airline/vim-airline'" >> ~/.vimrc
        echo "Plugin 'vim-airline/vim-airline-themes'" >> ~/.vimrc
        echo "Bundle 'edkolev/tmuxline.vim'" >> ~/.vimrc
        echo "Plugin 'scrooloose/nerdtree'" >> ~/.vimrc
        echo "Plugin 'ctrlpvim/ctrlp.vim'" >> ~/.vimrc
        echo "Plugin 'airblade/vim-gitgutter'" >> ~/.vimrc
        echo "Plugin 'octol/vim-cpp-enhanced-highlight'" >> ~/.vimrc
        echo "Plugin 'bfrg/vim-cpp-modern'" >> ~/.vimrc
        echo 'call vundle#end()            " required' >> ~/.vimrc
        echo 'filetype plugin indent on    " required' >> ~/.vimrc
    fi

    vim +PluginInstall +qall
}

install_tagbar() {
  git clone https://github.com/majutsushi/tagbar ~/.vim/bundle/tagbar
  echo " \" tagbar configuration" >> ~/.vimrc
  echo "map <C-O> :Tagbar<CR>" >> ~/.vimrc 
}

install_multiple_cursors() {
  git clone https://github.com/terryma/vim-multiple-cursors.git ~/.vim/bundle/vim-multiple-cursors
}

promptYCMCustomizationsToVimrc() {
  read -p "Do you want to add YCM customizations to your vimrc? (y/n) " prompt
  if [ $prompt == "y" ]; then
      echo " \"You Complete Me configuration" >> ~/.vimrc
      echo "set encoding=utf-8" >> ~/.vimrc
      echo "highlight YcmErrorLine ctermbg=LightBlue ctermfg=DarkGray cterm=bold guibg=#3f0000" >> ~/.vimrc
      echo "let g:ycm_error_symbol = '!!'" >> ~/.vimrc
      echo "let g:ycm_warning_symbol = '>>'" >> ~/.vimrc
      echo "let g:ycm_max_num_candidates = 1" >> ~/.vimrc
      echo "map <C-F> :YcmCompleter FixIt<CR>" >> ~/.vimrc
      echo "map <C-V> :YcmCompleter GoTo<CR>" >> ~/.vimrc
  else
      echo "enter y/n."
      promptYCMCustomizationsToVimrc
  fi
}

install_you_complete_me() {
  sudo apt-get install build-essential cmake python3-dev \
    && echo "start install you_complete_me" \
    || { echo -e "${COLOR_RED} You need to install 'build-essential', 'cmake', 'python3-dev' before install you_complete_me ${COLOR_NONE}" ; }
  git clone --recursive https://github.com/Valloric/YouCompleteMe.git ~/.vim/bundle/YouCompleteMe
  cd ~/.vim/bundle/YouCompleteMe
  python3 install.py --clang-completer
  promptYCMCustomizationsToVimrc
}

install_fugitive() {
  git clone https://github.com/tpope/vim-fugitive.git ~/.vim/bundle
}

install_light_line() {
  git clone https://github.com/itchyny/lightline.vim.git ~/.vim/bundle/lightline.vim
  
  echo " \" lightline configuration" >> ~/.vimrc
  echo "let g:lightline = {" >> ~/.vimrc
  echo "      \ 'colorscheme': 'solarized'," >> ~/.vimrc
  echo "      \ 'active': {" >> ~/.vimrc
  echo "      \ 'left' : [ [ 'mode', 'paste' ], [ 'readonly', 'absolutepath', 'modified' ] ]," >> ~/.vimrc
  echo "      \ }" >> ~/.vimrc
  echo "      \ }" >> ~/.vimrc

}

install_monokai() {
    
    if [ -e ~/.vim/colors ]; then
        echo "~/.vimrc/colors directory exists."
    else
        mkdir ~/.vim/colors
    fi

    if [ -f ~/.vim/colors/monokai.vim ]; then
        echo "colorscheme already added to vimrc"
    else
        echo "Moving vim-monokai colors file to ~/.vim/colors."
        cp ../vim-monokai/monokai.vim ~/.vim/colors/monokai.vim
        echo ' ' >> ~/.vimrc
        echo "colorscheme monokai" >> ~/.vimrc
        echo '" Syntax coloring' >> ~/.vimrc
        echo ':hi Normal ctermbg=0 ctermfg=253' >> ~/.vimrc
        echo ':hi StorageClass ctermfg=197' >> ~/.vimrc 
        echo ':hi Function ctermfg=154' >> ~/.vimrc
        echo ':hi cCustomClass ctermfg=31' >> ~/.vimrc
        echo ':hi cppSTLnamespace ctermfg=123' >> ~/.vimrc
        echo ':hi Boolean ctermfg=197' >> ~/.vimrc
        echo ' ' >> ~/.vimrc
        echo '"Set the color of the highlight"' >> ~/.vimrc
        echo 'hi Search ctermbg=DarkGray cterm=bold ctermfg=Yellow' >> ~/.vimrc
        echo 'hi Visual ctermbg=LightGreen cterm=bold ctermfg=DarkBlue guifg=Yellow guibg=#FFFFFF' >> ~/.vimrc
        echo ' ' >> ~/.vimrc
        echo '" cpp enhanced highlight' >> ~/.vimrc
        echo 'let g:cpp_class_scope_highlight = 1' >> ~/.vimrc
        echo 'let g:cpp_member_variable_highlight = 0' >> ~/.vimrc
        echo 'let g:cpp_class_decl_highlight = 1' >> ~/.vimrc
        echo 'let g:cpp_experimental_simple_template_highlight = 1' >> ~/.vimrc
        echo 'let g:cpp_experimental_template_highlight = 1' >> ~/.vimrc
        echo 'let g:cpp_concepts_highlight = 1' >> ~/.vimrc
        echo "colorscheme added to vimrc"
    fi
}

install_auto_pairs(){
  git clone https://github.com/jiangmiao/auto-pairs.git ~/.vim/bundle/auto-pairs
}

install_nerd_tree() {
  git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree

  echo " \" nerdtree configuration" >> ~/.vimrc
  echo "map <C-E> :NERDTreeToggle<CR>" >> ~/.vimrc 
}

install_light() {
  install_tagbar
  install_fugitive
  install_light_line
  install_multiple_cursors
  install_vundle
  install_monokai
}

install_all() {
  install_tagbar
  install_fugitive
  install_auto_pairs
  install_multiple_cursors
  install_nerd_tree
  install_light_line
  install_you_complete_me
  install_vundle
  install_monokai
}


##### Main Start
echo -e "${COLOR_YELLOW} Install pathogen vim package ${COLOR_NONE}"

if [ -e ~/.vim/autoload/pathogen.vim ]; then
  echo -e "${COLOR_RED} Already pathogen installed. ${COLOR_NONE}"
else
  mkdir -p ~/.vim ~/.vim/autoload ~/.vim/bundle && \
  curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

  echo " \" Use Pathogen plugins" >> ~/.vimrc
  echo "execute pathogen#infect()" >> ~/.vimrc
  echo "syntax on" >> ~/.vimrc
  echo "filetype plugin indent on" >> ~/.vimrc
fi


if [ "$1" = "all" ] || [ "$1" = "All" ] ; then
  echo -e "${COLOR_GREEN} Install all plugins ... ${COLOR_NONE}"
  install_all

elif [ "$1" = "light" ] || [ "$1" = "lightweight" ] || [ "$1" = "light-version" ] ; then
  echo -e "${COLOR_GREEN} Install light plugins ... ${COLOR_NONE}"
  install_light

elif [ "$1" = "nerdtree" ] || [ "$1" = "nerd-tree" ] || [ "$1" = "nerd_tree" ] ; then
  echo -e "${COLOR_GREEN} Install nerd tree ... ${COLOR_NONE}"
  install_nerd_tree

elif [ "$1" = "fugitive" ] || [ "$1" = "vim-fugitive" ] ; then
  echo -e "${COLOR_GREEN} Install fugitive ... ${COLOR_NONE}"
  install_fugitive

elif [ "$1" = "tagbar" ] || [ "$1" = "Tagbar" ] ; then
  echo -e "${COLOR_GREEN} Install tagbar ... ${COLOR_NONE}"
  install_tagbar

elif [ "$1" = "autopairs" ] || [ "$1" = "auto-pairs" ] || [ "$1" = "auto_pairs" ] ; then
  echo -e "${COLOR_GREEN} Install auto pairs ... ${COLOR_NONE}"
  install_auto_pairs


elif [ "$1" = "multiple-cursors" ] || [ "$1" = "multiple_cursors" ] ; then
  echo -e "${COLOR_GREEN} Install multiple-cursors ... ${COLOR_NONE}"
  install_multiple_cursors

elif [ "$1" = "light-line" ] || [ "$1" = "light_line" ] || [ "$1" = "lightline" ]; then
  echo -e "${COLOR_GREEN} Install light_line ... ${COLOR_NONE}"
  install_light_line

elif [ "$1" = "ycm" ]; then
  echo -e "${COLOR_GREEN} Install you-complete-me ... ${COLOR_NONE}"
  install_you_complete_me

elif [ "$1" = "vundle" ]; then
  echo -e "${COLOR_GREEN} Install vundle ... ${COLOR_NONE}"
  install_vundle

elif [ "$1" = "monokai" ]; then
  echo -e "${COLOR_GREEN} Install monokai colorscheme ... ${COLOR_NONE}"
  install_monokai

else
  echo -e ""
  echo -e ""
  echo -e "${COLOR_LIGHT_GREEN}      How to use vim-plugin.sh ${COLOR_NONE}"
  echo -e "     Usage: ${COLOR_CYAN}./plugin-install.sh [options]${COLOR_NONE}"
  echo -e "   [options] : "
  echo -e "           <Install Set> "
  echo -e "${COLOR_LIGHT_RED}        all(All), light(lightweight, light-version), ${COLOR_NONE}"
  echo -e "           <Install Module> "
  echo -e "${COLOR_LIGHT_RED}       tagbar(Tagbar), multiple-cursors(multiple_cursors)"
  echo -e "       lightline(light-line), fugitive(vim-fugitive)"
  echo -e "       autopairs(auto-pairs, auto_pairs), YouCompleteMe(ycm)"
  echo -e "       vundle(vundle), monokai colorscheme (monokai)"
  echo -e "${COLOR_NONE}"
  echo -e ""
fi


